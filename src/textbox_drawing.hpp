#pragma once

#include <beaver/graphics.hpp>

namespace rfr
{
	void draw_textbox_9parts(const mmath::frect& box,
			const mmath::ivec2& texture_box_position,
			int part_size,
			const sdl::texture& UI_tex,
			beaver::graphics& grp);
	void draw_textbox_3parts(const mmath::frect& box,
			const mmath::ivec2& texture_box_position,
			int part_width, int part_height,
			const sdl::texture& UI_tex,
			beaver::graphics& grp);
};
