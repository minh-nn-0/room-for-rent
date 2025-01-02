#pragma once

#include <beaver/ecs/core.hpp>
#include <beaver/sdlgame.hpp>
#include "dialogue.hpp"
#include "interaction.hpp"
#include "location.hpp"
namespace rfr
{
	template<typename... Ts>
	void bind_dialogue(beaver::ecs<Ts...>& ecs, beaver::sdlgame& beaver, sol::table& tbl, sol::state& lua)
	{
		tbl.set_function("set_dialogue", [&](std::size_t eid, const std::string& content)
				{
					auto& dl = ecs.template get_or_set_component<rfr::dialogue>(eid);
					dl->_content = content;
					dl->_time = content.length() * lua["config"]["wpm"].get<float>();
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
						if (dl->_time > 0) dl->_time -= dt;
					};
				});
		tbl.set_function("has_active_dialogue", [&](std::size_t eid)
				{
					auto& dl = ecs.template get_component<rfr::dialogue>(eid);
					if (dl.has_value()) return dl->_time > 0;
					else return false;
				});
		tbl.set_function("get_dialogue_time", [&](std::size_t eid) -> sol::object
				{
					auto& dl = ecs.template get_component<rfr::dialogue>(eid);
					if (dl.has_value()) 
					{
						return sol::make_object(lua, dl->_time);
					}
					else return sol::nil;
				});
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
	void bind_location(beaver::ecs<Ts...>& ecs, sol::table& tbl)
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
};
