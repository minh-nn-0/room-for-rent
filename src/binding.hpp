#pragma once

#include <beaver/ecs/core.hpp>
#include <beaver/sdlgame.hpp>
#include "dialogue.hpp"
#include "interaction.hpp"
#include "location.hpp"
#include "event.hpp"
#include "cutscene.hpp"
#include "zindex.hpp"
namespace rfr
{
	template<typename... Ts>
	void bind_dialogue(beaver::ecs<Ts...>& ecs, dialogue_options& dialogue_options, sol::table& tbl, sol::state& lua)
	{
		tbl.set_function("set_dialogue", [&](std::size_t eid, const sol::table& param)
				{
					auto& dl = ecs.template get_or_set_component<rfr::dialogue>(eid);
					std::array<unsigned char, 4> text_color {0,0,0,255};
					if (param["color"].is<sol::table>())
					{
						sol::table colortbl = param["color"].get<sol::table>();
						for (int i = 0; i != 3; i++)
							text_color[i] = colortbl[i+1];
					}
					dl->_sound = param["sound"].get_or(lua["config"]["default_dialogue_sound"].get<std::string>());
					dl->_verbal = param["verbal"].get_or(true);
					dl->_cpf = param["cpf"].get_or(lua["config"]["cpf"].get<float>());
					dl->_text_color = text_color;
					dl->_content = param["content"].get<std::string>();
					dl->_text_index = 0;
					dl->_time = 0;
				});
		tbl.set_function("get_dialogue_info", [&](std::size_t eid) -> sol::object
				{
					if (auto& dl = ecs.template get_component<rfr::dialogue>(eid); dl.has_value())
					{
						return lua.create_table_with("sound", dl->_sound, "verbal", dl->_verbal);
					}
					else return sol::nil;
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
							dl->_time += dl->_cpf * dt;
							if (dl->_time > 1)
							{
								dl->_text_index += static_cast<int>(dl->_time);
								dl->_time = 0;
							};
							if (dl->_text_index > dl->_content.size())
								dl->_text_index = dl->_content.size();
						}
						else
						{
							if (dl->_time < lua["config"]["dialogue_wait_time"].get<float>())
								dl->_time += dt;
							else
								dl->_content.clear();
						};
					};
				});
		tbl.set_function("has_active_dialogue", [&](std::size_t eid)
				{
					auto& dl = ecs.template get_component<rfr::dialogue>(eid);
					if (dl.has_value())
						return !dl->_content.empty();
					else return false;
				});
		tbl.set_function("dialogue_reached_fulllength", [&](std::size_t eid)
				{
					auto& dl = ecs.template get_component<rfr::dialogue>(eid);
					if (dl.has_value() && !dl->_content.empty())
						return dl->_text_index >= dl->_content.size();
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
	void bind_interaction(beaver::ecs<Ts...>& ecs, sol::table& tbl)
	{
		tbl.set_function("set_interaction", [&](std::size_t eid, const std::string& name, sol::object condition, sol::object action)
				{
					auto & intr = ecs.template get_or_set_component<rfr::interaction>(eid);
					intr->_name = name;

					if (condition.is<sol::function>()) intr->_condition = condition;
					if (action.is<sol::function>()) intr->_action = action;
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
		//tbl.set_function("find_interaction_with_name", [&](const std::string& name) -> long
		//		{
		//			auto interactions = ecs.template with<rfr::interaction>();
		//			if (auto findrs = std::ranges::find_if(interactions, [&](auto&& eid){
		//						return ecs.template get_component<rfr::interaction>(eid)->_name == name;});
		//					findrs != interactions.end())
		//			{
		//				return *findrs;
		//			}
		//			else return -1;
		//		});
		tbl.set_function("has_interaction", [&](std::size_t eid)
				{
					return ecs.template has_component<interaction>(eid);
				});
		//tbl.set_function("get_interaction", [&](std::size_t eid) -> std::string
		//		{
		//			if (auto& interaction = ecs.template get_component<rfr::interaction>(eid); interaction.has_value())
		//				return interaction->_name;
		//			else return "";
		//		});
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
		tbl.set_function("add_event", [&](sol::function trigger)
				{
					events._events.emplace_back(trigger);
					return events._events.size() - 1;
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

		tbl.set_function("set_event_listener", [&](std::size_t eid, std::size_t eventid, sol::function handler)
				{
					auto& ev = ecs.template get_or_set_component<event_listener>(eid);	
					ev.value()[eventid] = handler;
				});

		tbl.set_function("unset_event_listener", [&](std::size_t eid, std::size_t eventid)
				{
					events._to_remove.emplace_back(eid, eventid);
				});
		tbl.set_function("update_event_listener", [&]()
				{
					for (auto&& eid: ecs.template with<event_listener>())
						for (auto&& event: ecs.template get_component<event_listener>(eid).value())
							if (events._events.at(event.first)()) event.second();	
					for (const auto& [eid, eventid]: events._to_remove)
						ecs.template get_component<event_listener>(eid)->erase(eventid);
					events._to_remove.clear();
				});

		//tbl.set_function("update_events", [&]()
		//		{
		//			events._current_events.clear();
		//			for (std::size_t i = 0; i != events._events.size(); i++)
		//				if (events._events.at(i)()) events._current_events.emplace(i);
		//		});
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

					cm._cutscenes.emplace_back(to_add);
					return cm._cutscenes.size() - 1;
				});

		tbl.set_function("get_current_cutscene", [&]()
				{
					return cm._current_sceneid;
				});
		tbl.set_function("is_cutscene_playing", [&]()
				{
					return cm._player._active;
				});
		tbl.set_function("play_cutscene", [&](int scene)
				{
					cm.play(scene);
				});
		tbl.set_function("update_cutscene", [&](float dt)
				{
					cm.update(dt);
				});
	};

	// ZINDEX
	template<typename... Ts>
	void bind_zindex(beaver::ecs<Ts...>& ecs, std::vector<std::size_t>& draw_order, sol::table& tbl)
	{
		tbl.set_function("set_zindex", [&](std::size_t eid, std::int8_t zindex)
				{
					ecs.template get_or_set_component<rfr::zindex>()._index = zindex;
					std::ranges::stable_sort(draw_order);
				});
	};
};
