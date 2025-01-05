#include "interaction.hpp"
#include "textbox_drawing.hpp"

void rfr::draw_interaction(const std::string& name, const mmath::fvec2& position, float scale, int padding, beaver::sdlgame& game)
{
	sdl::texture* UI_tex = game._assets.get<sdl::texture>("UI");		
	sdl::font* font = game._assets.get<sdl::font>("inconsolata");
	sdl::texture text = beaver::make_text_blended(game._graphics._rdr, *font, name, game._graphics._draw_color);

	mmath::frect text_dst = {position.x - text._width / 2.f * scale,
							position.y - text._height * scale,
							text._width * scale,
							text._height * scale};
	mmath::frect text_box {text_dst._pos.x - padding, 
							text_dst._pos.y - 0.6f,
							text_dst._size.x + 2 * padding,
							8};

	draw_textbox_3parts(text_box, {12,12}, 4, 8, *UI_tex, game._graphics);

	game._graphics.texture(text, text_dst);

};
