#pragma once

#include <sol/sol.hpp>
#include <beaver/sdlgame.hpp>
#include <beaver/ecs/core.hpp>
namespace rfr
{
	struct interaction
	{
		// for printing out to screen
		std::string _name;
		std::function<bool()> _condition;
		std::function<void()> _action;
	};
	
	template<typename... Ts>
	void bind_interaction(beaver::ecs<Ts...>& ecs, sol::table& tbl)
	{
		tbl.set_function("set_interaction", [&](std::size_t eid, const std::string& name, sol::function condition, sol::function action)
				{
					ecs.template set_component<rfr::interaction>(eid, 
							interaction{name,
										[condition]{return condition();},
										[action]{return action();}}
									);
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
	};

	void draw_interaction(const std::string& name, const mmath::fvec2& position, float scale, int padding, beaver::sdlgame& game);
};
