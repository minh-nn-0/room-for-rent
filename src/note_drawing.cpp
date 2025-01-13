#include "note_drawing.hpp"

float rfr::draw_note(float posx, float posy, const std::string& text, const std::string& header, beaver::sdlgame& game, sol::state& lua)
{
	const sol::table& note_head_color = lua["config"]["note_head_color"];
	const sol::table& note_body_color = lua["config"]["note_body_color"];
	float cam_zoom = lua["config"]["cam_zoom"].get<float>();
	game._graphics.set_draw_color({note_head_color[1].get<unsigned char>(), note_head_color[2].get<unsigned char>(), note_head_color[3].get<unsigned char>(), note_head_color[4].get<unsigned char>()});
	
	sdl::font* font = game._assets.get<sdl::font>(lua["config"]["ui_font"].get<std::string>());

	sdl::texture text_texture = beaver::make_text_blended(game._graphics._rdr, *font, text, {40,40,40,255}, 140);
	game._graphics.rect(posx, posy, 36.5 * cam_zoom, text_texture._height + 3 * cam_zoom, true); 
	game._graphics.text({posx + 1 * cam_zoom, posy + 1 * cam_zoom}, text_texture, 1);

	return text_texture._height;
};
