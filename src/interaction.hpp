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
	
	void draw_interaction(const std::string& name, const mmath::fvec2& position,
			const std::string& fontname,
			float scale, int padding, beaver::sdlgame& game);
};
