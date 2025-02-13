#pragma once

#include <beaver/sdlgame.hpp>

namespace rfr
{
	float draw_note(float posx, float posy, const std::string& text, const std::string& header,
			sdl::texture* UI_tex,
			sdl::font* font,
			beaver::sdlgame& game, sol::state& lua);
};
