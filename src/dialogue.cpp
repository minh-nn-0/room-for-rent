#include "dialogue.hpp"
#include "textbox_drawing.hpp"
void rfr::update_dialogue(rfr::dialogue& dl, float wait_time, float dt)
{
	if (dl._text_index < dl._content.size())
	{
		dl._time += dl._cpf * dt;
		if (dl._time > 1)
		{
			dl._text_index += static_cast<int>(dl._time);
			dl._time = 0;
		};
		if (dl._text_index > dl._content.size())
			dl._text_index = dl._content.size();
	}
	else
	{
		if (dl._time < wait_time)
			dl._time += dt;
		else
			dl._content.clear();
	};
};
void rfr::draw_dialogue(const mmath::fvec2& actor_position, const dialogue& dialogue,
		float scale, int padding, int wraplength,
		std::size_t UI_tex,
		std::size_t font,
		beaver::sdlgame& game)
{
	sdl::texture text = beaver::make_text_blended(game._graphics._rdr, game._assets.get_vec<sdl::font>().at(font), dialogue._content.substr(0, dialogue._text_index), dialogue._text_color, wraplength);
	
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
    if (text_box._pos.x < game._graphics._cam->_view._pos.x) {
        text_box._pos.x = game._graphics._cam->_view._pos.x;
    }
    if (text_box._pos.x + text_box._size.x > cam_max_x) {
        text_box._pos.x = cam_max_x - text_box._size.x;
    }
    // Adjust text position based on clamped box
    text_dst._pos.x = text_box._pos.x + padding;
    text_dst._pos.y = text_box._pos.y + padding;

	// Draw corners
	
	if (text_box._size.x > 8 and text_box._size.y > 8) draw_textbox_9parts(text_box, {0,0}, 4, game._assets.get_vec<sdl::texture>().at(UI_tex), game._graphics);
	game._graphics.texture(text, text_dst);
};
