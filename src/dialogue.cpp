#include "dialogue.hpp"
void rfr::draw_dialogue(const mmath::fvec2& actor_position, const dialogue& dialogue,
		float scale, int padding, int wraplength,
		beaver::sdlgame& game)
{
	sdl::texture* UI_tex = game._assets.get<sdl::texture>("UI");		
	sdl::font* font = game._assets.get<sdl::font>("fvf_fernando");
	sdl::texture text = beaver::make_text_solid(game._graphics._rdr, *font, dialogue._content, game._graphics._draw_color, wraplength);
	
	mmath::frect text_dst = {actor_position.x + dialogue._position.x - text._width / 2.f * scale,
							actor_position.y + dialogue._position.y - text._height * scale,
							text._width * scale,
							text._height * scale};
	mmath::frect text_box {text_dst._pos.x - padding, 
							text_dst._pos.y - padding,
							text_dst._size.x + 2 * padding,
							text_dst._size.y + 2 * padding};
	float cam_max_x = game._graphics._cam->_view._pos.x + game._graphics._cam->_view._size.x / game._graphics._cam->_zoom;

    // Clamp text box within screen boundaries
    if (text_box._pos.x < 0) {
        text_box._pos.x = 0;
    }
    if (text_box._pos.x + text_box._size.x > cam_max_x) {
        text_box._pos.x = cam_max_x - text_box._size.x;
    }
    // Adjust text position based on clamped box
    text_dst._pos.x = text_box._pos.x + padding;
    text_dst._pos.y = text_box._pos.y + padding;

	// Draw corners
	mmath::irect corner_topleft_src {0,0,4,4};
	mmath::irect corner_topright_src {4,0,4,4};
	mmath::irect corner_bottomleft_src {0,4,4,4};
	mmath::irect corner_bottomright_src {4,4,4,4};

	mmath::frect corner_topleft_dst {text_box._pos.x, text_box._pos.y, 4,4};
	mmath::frect corner_topright_dst {text_box._pos.x + text_box._size.x - 4,
										text_box._pos.y, 
										4, 4};
	mmath::frect corner_bottomleft_dst {text_box._pos.x, 
										text_box._pos.y + text_box._size.y - 4,
										4, 4};
	mmath::frect corner_bottomright_dst {text_box._pos.x + text_box._size.x - 4,
										text_box._pos.y + text_box._size.y - 4,
										4, 4};


	game._graphics.texture(*UI_tex, corner_topleft_dst, corner_topleft_src);
	game._graphics.texture(*UI_tex, corner_topright_dst, corner_topright_src);
	game._graphics.texture(*UI_tex, corner_bottomleft_dst, corner_bottomleft_src);
	game._graphics.texture(*UI_tex, corner_bottomright_dst, corner_bottomright_src);

	// Draw sides
							
	mmath::frect left_side_src {0,2,2,3};
	mmath::frect right_side_src {6,2,2,3};
	mmath::frect top_side_src {2,0,2,2};
	mmath::frect bottom_side_src {2,6,2,2};

	mmath::frect left_side_dst {corner_topleft_dst._pos.x, corner_topleft_dst._pos.y + 4, 2, text_box._size.y - 2 * 4};
	mmath::frect right_side_dst {corner_topright_dst._pos.x + 2, corner_topright_dst._pos.y + 4, 2, text_box._size.y - 2 * 4};
	mmath::frect top_side_dst {corner_topleft_dst._pos.x + 4, corner_topleft_dst._pos.y, text_box._size.x - 2 * 4, 2};
	mmath::frect bottom_side_dst {corner_bottomleft_dst._pos.x + 4, corner_bottomleft_dst._pos.y + 2, text_box._size.x - 2 * 4, 2};
	
	game._graphics.texture(*UI_tex, left_side_dst, left_side_src);
	game._graphics.texture(*UI_tex, right_side_dst, right_side_src);
	game._graphics.texture(*UI_tex, top_side_dst, top_side_src);
	game._graphics.texture(*UI_tex, bottom_side_dst, bottom_side_src);

	// Draw center
	
	game._graphics.texture(*UI_tex, {text_box._pos.x + 2, text_box._pos.y + 2, text_box._size.x - 2 * 2, text_box._size.y - 2 * 2}, {2,2,2,2});

	// Draw text
	
	game._graphics.texture(text, text_dst);
};
