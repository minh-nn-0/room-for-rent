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
		sol::function _condition;
		sol::function _action;
	};

	namespace interaction_helper
	{
		struct drawdata
		{
			sdl::texture* _tex;
			mmath::irect _Zsrc, _Xsrc;
			sdl::font* _font;
		};
		void draw(const std::string& Zcontent, const std::string& Xcontent, beaver::sdlgame&, const drawdata&);
	};
	
	void draw_interaction(const std::string& name, const mmath::fvec2& position,
			float scale, int padding,
			std::size_t UI_tex,
			std::size_t font,
			beaver::sdlgame& game);
};
