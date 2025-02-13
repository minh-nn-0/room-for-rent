#include "note_drawing.hpp"
#include "textbox_drawing.hpp"
float rfr::draw_note(float posx, float posy, const std::string& text, const std::string& header,
		sdl::texture* UI_tex,
		sdl::font* font,
		beaver::sdlgame& game, sol::state& lua)
{
	float cam_zoom = lua["config"]["cam_zoom"].get<float>();
	TTF_SetFontStyle(*font, TTF_STYLE_BOLD);	
	sdl::texture header_texture = beaver::make_text_blended(game._graphics._rdr, *font, header, {0,0,0,255});
	TTF_SetFontStyle(*font, TTF_STYLE_NORMAL);	
	sdl::texture text_texture = beaver::make_text_blended(game._graphics._rdr, *font, text, {40,40,40,255}, 140);
	
	mmath::frect header_dst = {posx + 2 * cam_zoom, posy + 2 * cam_zoom,
							static_cast<float>(header_texture._width),
							static_cast<float>(header_texture._height)};
	mmath::frect text_dst = {header_dst._pos.x, header_dst._pos.y + header_dst._size.y + 1 * cam_zoom,
							static_cast<float>(text_texture._width),
							static_cast<float>(text_texture._height)};
	mmath::frect text_box = {posx, posy,
							36 * cam_zoom,
							header_dst._size.y + text_dst._size.y + 4 * cam_zoom};
	draw_textbox_9parts(text_box, {48,0}, 4, UI_tex, game._graphics);
	game._graphics.texture(header_texture, header_dst);
	game._graphics.texture(text_texture, text_dst);
	return text_box._size.y;
};
