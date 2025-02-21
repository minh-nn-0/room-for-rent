#include "interaction.hpp"
#include "textbox_drawing.hpp"

void rfr::interaction_helper::draw(const std::string& Zcontent, const std::string& Xcontent, beaver::sdlgame& game, const rfr::interaction_helper::drawdata& ddata, float scale)
{
	static constexpr mmath::ivec2 Z_icon_position {30, 300};
	static constexpr mmath::ivec2 X_icon_position {Z_icon_position.x, Z_icon_position.y + 30};
	static constexpr mmath::ivec2 Z_text_position {Z_icon_position.x + 12, Z_icon_position.y + 5};
	static constexpr mmath::ivec2 X_text_position {X_icon_position.x + 12, Z_icon_position.y + 5};
	static constexpr mmath::irect Z_dst {Z_icon_position.x, Z_icon_position.y, 10, 10};
	static constexpr mmath::irect X_dst {X_icon_position.x, X_icon_position.y, 10, 10};
	
	auto draw_icon_and_text = [&](const std::string& content, 
			const mmath::irect& icon_dst, const mmath::irect& icon_src)
	{
		if (content.empty())
			SDL_SetTextureAlphaMod(*ddata._tex, 150);
		else
		{
			SDL_SetTextureAlphaMod(*ddata._tex, 255);
			game._graphics.text_blended(mmath::ivec2{icon_dst._pos.x + 12, icon_dst._pos.y + 5}, *ddata._font, Zcontent, scale);
		};
		game._graphics.texture(*ddata._tex, static_cast<mmath::frect>(icon_dst), static_cast<mmath::frect>(icon_src));
	};
	draw_icon_and_text(Zcontent, Z_dst, ddata._Zsrc);
	draw_icon_and_text(Xcontent, X_dst, ddata._Xsrc);
};

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
