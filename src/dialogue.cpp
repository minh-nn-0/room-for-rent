#include "dialogue.hpp"
const float dialogue_text_downscale = 3;
void rfr::draw_dialogue(const mmath::fvec2& actor_position, const dialogue& dialogue,
		beaver::sdlgame& game)
{
	sdl::texture* UI_tex = game._assets.get<sdl::texture>("UI");		
	sdl::font* font = game._assets.get<sdl::font>("fvf_fernando");
	sdl::texture text = beaver::make_text_blended(game._graphics._rdr, *font, dialogue._content, game._graphics._draw_color, dialogue._wraplength);
	
	mmath::frect text_dst = {actor_position.x + dialogue._position.x - text._width / 2.f / dialogue_text_downscale,
							actor_position.y + dialogue._position.y - text._height / dialogue_text_downscale,
							text._width / dialogue_text_downscale,
							text._height / dialogue_text_downscale};
	mmath::frect text_box {text_dst._pos.x - dialogue._padding, 
							text_dst._pos.y - dialogue._padding,
							text_dst._size.x + 2 * dialogue._padding,
							text_dst._size.y + 2 * dialogue._padding};
	float cam_max_x = game._graphics._cam->_view._pos.x + game._graphics._cam->_view._size.x / game._graphics._cam->_zoom;

    // Clamp text box within screen boundaries
    if (text_box._pos.x < 0) {
        text_box._pos.x = 0;
    }
    if (text_box._pos.x + text_box._size.x > cam_max_x) {
        text_box._pos.x = cam_max_x - text_box._size.x;
    }
    // Adjust text position based on clamped box
    text_dst._pos.x = text_box._pos.x + dialogue._padding;
    text_dst._pos.y = text_box._pos.y + dialogue._padding;

	// Draw corners
	mmath::irect corner_topleft_src {0,0,8,8};
	mmath::irect corner_topright_src {16,0,8,8};
	mmath::irect corner_bottomleft_src {0,16,8,8};
	mmath::irect corner_bottomright_src {16,16,8,8};

	mmath::frect corner_topleft_dst {text_box._pos.x, text_box._pos.y, 8,8};
	mmath::frect corner_topright_dst {text_box._pos.x + text_box._size.x - 8,
										text_box._pos.y, 
										8, 8};
	mmath::frect corner_bottomleft_dst {text_box._pos.x, 
										text_box._pos.y + text_box._size.y - 8,
										8, 8};
	mmath::frect corner_bottomright_dst {text_box._pos.x + text_box._size.x - 8,
										text_box._pos.y + text_box._size.y - 8,
										8, 8};


	game._graphics.texture(*UI_tex, corner_topleft_dst, corner_topleft_src);
	game._graphics.texture(*UI_tex, corner_topright_dst, corner_topright_src);
	game._graphics.texture(*UI_tex, corner_bottomleft_dst, corner_bottomleft_src);
	game._graphics.texture(*UI_tex, corner_bottomright_dst, corner_bottomright_src);

	// Draw sides
							
	mmath::frect left_side_src {0,8,8,8};
	mmath::frect right_side_src {16,8,8,8};
	mmath::frect top_side_src {8,0,8,8};
	mmath::frect bottom_side_src {8,16,8,8};

	mmath::frect left_side_dst {corner_topleft_dst._pos.x, corner_topleft_dst._pos.y + 8, 8, text_box._size.y - 2 * 8};
	mmath::frect right_side_dst {corner_topright_dst._pos.x, corner_topright_dst._pos.y + 8, 8, text_box._size.y - 2 * 8};
	mmath::frect top_side_dst {corner_topleft_dst._pos.x + 8, corner_topleft_dst._pos.y, text_box._size.x - 2 * 8, 8};
	mmath::frect bottom_side_dst {corner_bottomleft_dst._pos.x + 8, corner_bottomleft_dst._pos.y, text_box._size.x - 2 * 8, 8};
	
	game._graphics.texture(*UI_tex, left_side_dst, left_side_src);
	game._graphics.texture(*UI_tex, right_side_dst, right_side_src);
	game._graphics.texture(*UI_tex, top_side_dst, top_side_src);
	game._graphics.texture(*UI_tex, bottom_side_dst, bottom_side_src);

	// Draw center
	
	game._graphics.texture(*UI_tex, {text_box._pos.x + 8, text_box._pos.y + 8, text_box._size.x - 2 * 8, text_box._size.y - 2 * 8}, {8,8,8,8});

	// Draw text
	
	game._graphics.texture(text, text_dst);
};
