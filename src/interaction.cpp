#include "interaction.hpp"
#include "textbox_drawing.hpp"

void rfr::draw_interaction(const std::string& name, const mmath::fvec2& position,
		float scale, int padding,
		std::size_t UI_tex,
		std::size_t font,
		beaver::sdlgame& game)
{
	sdl::texture text = beaver::make_text_blended(game._graphics._rdr, game._assets.get_vec<sdl::font>().at(font), name, game._graphics._draw_color);

	mmath::frect text_dst = {position.x - text._width / 2.f * scale,
							position.y - text._height * scale,
							text._width * scale,
							text._height * scale};
	mmath::frect text_box {text_dst._pos.x - padding, 
							text_dst._pos.y - 1.f,
							text_dst._size.x + 2 * padding,
							text_dst._size.y + padding};

	draw_textbox_9parts(text_box, {12,0}, 4, game._assets.get_vec<sdl::texture>().at(UI_tex), game._graphics);

	game._graphics.texture(text, text_dst);

};
