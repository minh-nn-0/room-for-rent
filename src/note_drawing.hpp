#pragma once

#include <beaver/sdlgame.hpp>

namespace rfr
{
	float draw_note(float posx, float posy, const std::string& text, const std::string& header, beaver::sdlgame& game, sol::state& lua);
};
