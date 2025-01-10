#pragma once

#include <beaver/ecs/core.hpp>
#include <beaver/sdlgame.hpp>
#include "dialogue.hpp"
#include "interaction.hpp"
#include "location.hpp"
#include "event.hpp"
#include "cutscene.hpp"
namespace rfr
{
	template<typename... Ts>
	void bind_dialogue(beaver::ecs<Ts...>& ecs, dialogue_options& dialogue_options, sol::table& tbl, sol::state& lua)
	{
		tbl.set_function("set_dialogue", [&](std::size_t eid, const std::string& content)
				{
					auto& dl = ecs.template get_or_set_component<rfr::dialogue>(eid);
					dl->_content = content;
					dl->_text_index = 0;
					dl->_time = 0;
				});
		tbl.set_function("set_dialogue_position", [&](std::size_t eid, float x, float y)
				{
					ecs.template get_or_set_component<rfr::dialogue>(eid)->_position = {x, y};
				});
		tbl.set_function("update_dialogue", [&](float dt)
				{
					for (std::size_t eid: ecs.template with<rfr::dialogue>())
					{
						auto& dl = ecs.template get_component<rfr::dialogue>(eid);
						if (dl->_text_index < dl->_content.size())
						{
							dl->_time += lua["config"]["cpf"].get<float>() * dt;
							if (dl->_time > 1)
							{
								dl->_text_index += static_cast<int>(dl->_time);
								dl->_time = 0;
							};
							if (dl->_text_index > dl->_content.size())
								dl->_text_index = dl->_content.size();
						}
						else if (dl->_time < lua["config"]["dialogue_wait_time"].get<float>())
							dl->_time += dt;
					};
				});
		tbl.set_function("has_active_dialogue", [&](std::size_t eid)
				{
					auto& dl = ecs.template get_component<rfr::dialogue>(eid);
					if (dl.has_value())
						return dl->_text_index < dl->_content.size() || dl->_time < lua["config"]["dialogue_wait_time"].get<float>();
					else return false;
				});
		//tbl.set_function("get_dialogue_time", [&](std::size_t eid) -> sol::object
		//		{
		//			auto& dl = ecs.template get_component<rfr::dialogue>(eid);
		//			if (dl.has_value()) 
		//			{
		//				return sol::make_object(lua, dl->_time);
		//			}
		//			else return sol::nil;
		//		});
		tbl.set_function("set_dialogue_options", [&](sol::variadic_args opts)
				{
					dialogue_options._options.clear();
					dialogue_options._selection = 0;
					for (auto&& str: opts) dialogue_options._options.emplace_back(str.as<std::string>());
				});
		tbl.set_function("having_dialogue_options", [&]
				{
					return !dialogue_options._options.empty();
				});
		tbl.set_function("increment_dialogue_options_selection", [&]
				{
					if (dialogue_options._selection != dialogue_options._options.size() - 1)
						dialogue_options._selection++;
				});
		tbl.set_function("decrement_dialogue_options_selection", [&]
				{
					if (dialogue_options._selection > 0)
						dialogue_options._selection--;
				});
		tbl.set_function("select_dialogue_options_selection", [&]
				{
					dialogue_options._options.clear();
					return dialogue_options._selection;
				});

		tbl.set_function("get_dialogue_options_selection", [&] -> int
				{
					return dialogue_options._selection;
				});
	};

	template<typename... Ts>
	void bind_dialogue_options(beaver::ecs<Ts...>& ecs, std::vector<std::string>& options, sol::table& tbl)
	{
	};

	template<typename... Ts>
	void bind_interaction(beaver::ecs<Ts...>& ecs, sol::table& tbl)
	{
		tbl.set_function("set_interaction", [&](std::size_t eid, const std::string& name, sol::object condition, sol::object action)
				{
					auto & intr = ecs.template get_or_set_component<rfr::interaction>(eid);
					intr->_name = name;

					if (condition.is<sol::function>()) intr->_condition = [condition]{return condition.as<sol::function>()();};
					if (action.is<sol::function>()) intr->_action = [action]{action.as<sol::function>()();};
				});
		tbl.set_function("trigger_interaction", [&](std::size_t eid)
				{
					auto& interaction = ecs.template get_component<rfr::interaction>(eid).value();
					if (interaction._condition()) interaction._action();
				});
		tbl.set_function("is_interaction_available", [&](std::size_t eid)
				{
					if (auto& interaction = ecs.template get_component<rfr::interaction>(eid); interaction.has_value())
					{
						return interaction->_condition();
					}
					else throw std::runtime_error(std::format("eid {} doesn't have interaction component", eid));
				});
		tbl.set_function("find_interaction_with_name", [&](const std::string& name) -> long
				{
					auto interactions = ecs.template with<rfr::interaction>();
					if (auto findrs = std::ranges::find_if(interactions, [&](auto&& eid){
								return ecs.template get_component<rfr::interaction>(eid)->_name == name;});
							findrs != interactions.end())
					{
						return *findrs;
					}
					else return -1;
				});
		tbl.set_function("has_interaction", [&](std::size_t eid)
				{
					return ecs.template has_component<interaction>(eid);
				});

		tbl.set_function("get_interaction", [&](std::size_t eid) -> std::string
				{
					if (auto& interaction = ecs.template get_component<rfr::interaction>(eid); interaction.has_value())
						return interaction->_name;
					else return "";
				});
	};

	template<typename... Ts>
	void bind_location(beaver::ecs<Ts...>& ecs ,sol::table& tbl)
	{
		tbl.set_function("set_location", [&](std::size_t eid, const std::string& location)
				{
					ecs.template set_component<rfr::location>(eid, rfr::location{location});
				});
		tbl.set_function("get_location", [&](std::size_t eid) -> std::string
				{
					if (auto& lct = ecs.template get_component<rfr::location>(eid); lct.has_value())
						return lct->_value;
					else return "";
				});
	};
	template<typename... Ts>
	void bind_event(beaver::ecs<Ts...>& ecs, event_manager& events, sol::table& tbl)
	{
		tbl.set_function("add_event", [&](const std::string& name, sol::function trigger)
				{
					events._events[name] = trigger;
				});

		//tbl.set_function("remove_event", [&](std::size_t eventid)
		//		{
		//			for (auto&& eid: ecs.template with<event_listener>())
		//			{
		//				auto& events = ecs.template get_component<event_listener>(eid).value();
		//				std::erase_if(events, [&](auto&& event) {return event.first == eventid;});
		//			};

		//			events.remove_event(eventid);
		//		});

		tbl.set_function("set_event_listener", [&](std::size_t eid, const std::string& event_name, sol::function handler)
				{
					auto& ev = ecs.template get_or_set_component<event_listener>(eid);	
					ev.value()[event_name] = handler;
				});

		tbl.set_function("unset_event_listener", [&](std::size_t eid, const std::string& event_name)
				{
					auto& ev = ecs.template get_or_set_component<event_listener>(eid);	
					ev->erase(event_name);
				});
		tbl.set_function("update_event_listener", [&]()
				{
					for (auto&& eid: ecs.template with<event_listener>())
						for (auto&& event: ecs.template get_component<event_listener>(eid).value())
							if (events._current_events.contains(event.first)) event.second();	
				});

		tbl.set_function("update_events", [&]()
				{
					events._current_events.clear();
					for(const auto& [ename, etrigger]: events._events)
						if (etrigger()) events._current_events.emplace(ename);
				});
	};


	template<typename... Ts>
	void bind_cutscene(cutscene_manager& cm, sol::table& tbl)
	{
		tbl.set_function("add_cutscene", [&](const sol::table& param)
				{
					cutscene to_add;
					to_add._updatef = param["update"].get<sol::function>();
					to_add._initf = param["init"].get<sol::function>();
					to_add._exitf = param["exit"].get<sol::function>();

					for (auto& [_,v]: param["scripts"].get<sol::table>())
						to_add._scripts.emplace_back(v.as<sol::function>());

					cm._cutscenes.emplace(param["name"].get<std::string>(), to_add);
				});

		tbl.set_function("get_current_cutscene_name", [&]()
				{
					return cm._current_cutscene_name;
				});
		tbl.set_function("is_cutscene_playing", [&]()
				{
					return cm._player._active;
				});
		tbl.set_function("play_cutscene", [&](const std::string& scene_name)
				{
					cm.play(scene_name);
				});
		tbl.set_function("update_cutscene", [&](float dt)
				{
					cm.update(dt);
				});
	};
};
