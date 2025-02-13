#include "textbox_drawing.hpp"

void rfr::draw_textbox_9parts(const mmath::frect& box,
			const mmath::ivec2& texture_box_position,
			int part_size,
			const sdl::texture* UI_tex,
			beaver::graphics& grp)
{
	mmath::irect corner_topleft_src {texture_box_position.x, texture_box_position.y, part_size, part_size};
	mmath::irect corner_topright_src {texture_box_position.x + 2 * part_size, texture_box_position.y, part_size, part_size};
	mmath::irect corner_bottomleft_src {texture_box_position.x, texture_box_position.y + 2 * part_size, part_size, part_size};
	mmath::irect corner_bottomright_src {texture_box_position.x + 2 * part_size, texture_box_position.y + 2 * part_size, part_size, part_size};
	
	mmath::frect corner_topleft_dst {box._pos.x, box._pos.y, static_cast<float>(part_size), static_cast<float>(part_size)};
	mmath::frect corner_topright_dst {box._pos.x + box._size.x - part_size, box._pos.y, static_cast<float>(part_size), static_cast<float>(part_size)};
	mmath::frect corner_bottomleft_dst {box._pos.x, box._pos.y + box._size.y - part_size, static_cast<float>(part_size), static_cast<float>(part_size)};
	mmath::frect corner_bottomright_dst {box._pos.x + box._size.x - part_size, box._pos.y + box._size.y - part_size, static_cast<float>(part_size), static_cast<float>(part_size)};

	mmath::irect left_side_src {texture_box_position.x, texture_box_position.y + part_size,
								part_size, part_size};
	mmath::irect right_side_src {texture_box_position.x + 2 * part_size, texture_box_position.y + part_size,
								part_size, part_size};
	mmath::irect top_side_src {texture_box_position.x + part_size, texture_box_position.y,
								part_size, part_size};
	mmath::irect bottom_side_src {texture_box_position.x + part_size, texture_box_position.y + 2 * part_size,
								part_size, part_size};

	mmath::frect left_side_dst {box._pos.x, box._pos.y + part_size,
							static_cast<float>(part_size), box._size.y - 2 * part_size};
	mmath::frect right_side_dst {box._pos.x + box._size.x - part_size, box._pos.y + part_size,
							static_cast<float>(part_size), box._size.y - 2 * part_size};
	mmath::frect top_side_dst {box._pos.x + part_size, box._pos.y,
							box._size.x - 2 * part_size, static_cast<float>(part_size)};
	mmath::frect bottom_side_dst {box._pos.x + part_size, box._pos.y + box._size.y - part_size,
							box._size.x - 2 * part_size, static_cast<float>(part_size)};


	grp.texture(*UI_tex, corner_topleft_dst, corner_topleft_src);
	grp.texture(*UI_tex, corner_topright_dst, corner_topright_src);
	grp.texture(*UI_tex, corner_bottomleft_dst, corner_bottomleft_src);
	grp.texture(*UI_tex, corner_bottomright_dst, corner_bottomright_src);
	
	grp.texture(*UI_tex, left_side_dst, left_side_src);
	grp.texture(*UI_tex, right_side_dst, right_side_src);
	grp.texture(*UI_tex, top_side_dst, top_side_src);
	grp.texture(*UI_tex, bottom_side_dst, bottom_side_src);

	grp.texture(*UI_tex, {box._pos.x + part_size, box._pos.y + part_size, box._size.x - 2 * part_size, box._size.y - 2 * part_size},
						{texture_box_position.x + part_size, texture_box_position.y + part_size, part_size, part_size});
};

void rfr::draw_textbox_3parts(const mmath::frect& box,
		const mmath::ivec2& texture_box_position,
		int part_width, int part_height,
		const sdl::texture* UI_tex,
		beaver::graphics& grp)
{
	mmath::irect left_side_src {texture_box_position.x, texture_box_position.y,
								part_width, part_height};
	mmath::irect right_side_src {texture_box_position.x + 2 * part_width, texture_box_position.y,
								part_width, part_height};
	mmath::frect left_side_dst {box._pos.x, box._pos.y, static_cast<float>(part_width), static_cast<float>(part_height)};
	mmath::frect right_side_dst {box._pos.x + box._size.x - part_width, box._pos.y, static_cast<float>(part_width), static_cast<float>(part_height)};

	grp.texture(*UI_tex, left_side_dst, left_side_src);
	grp.texture(*UI_tex, right_side_dst, right_side_src);

	grp.texture(*UI_tex, {box._pos.x + part_width, box._pos.y, box._size.x - 2 * part_width, static_cast<float>(part_height)},
						{texture_box_position.x + part_width, texture_box_position.y, part_width, part_height});
};
