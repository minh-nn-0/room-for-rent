#include "interaction.hpp"

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
	float cam_max_x = game._graphics._cam->_view._pos.x + game._graphics._cam->_view._size.x / game._graphics._cam->_zoom;

							
	mmath::frect left_side_src {8,0,4,8};
	mmath::frect right_side_src {12,0,4,8};
	mmath::frect top_side_src {10,0,3,2};
	mmath::frect bottom_side_src {10,6,2,2};

	mmath::frect left_side_dst {text_box._pos.x, text_box._pos.y, 4, 8};
	mmath::frect right_side_dst {text_box._pos.x + text_box._size.x - 4, text_box._pos.y, 4, 8};
	mmath::frect top_side_dst {text_box._pos.x + 4, text_box._pos.y, text_box._size.x - 6, 2};
	mmath::frect bottom_side_dst {text_box._pos.x + 4, text_box._pos.y + 6, text_box._size.x - 6, 2};
	
	game._graphics.texture(*UI_tex, left_side_dst, left_side_src);
	game._graphics.texture(*UI_tex, right_side_dst, right_side_src);
	game._graphics.texture(*UI_tex, top_side_dst, top_side_src);
	game._graphics.texture(*UI_tex, bottom_side_dst, bottom_side_src);

	// Draw center
	game._graphics.texture(*UI_tex, {text_box._pos.x + 2, text_box._pos.y + 2, text_box._size.x - 4, 4}, {10,2,2,2});

	// Draw text
	
	game._graphics.texture(text, text_dst);

};
