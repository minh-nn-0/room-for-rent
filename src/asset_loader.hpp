#pragma once

#include <future>
#include <beaver/sdlgame.hpp>

struct asset_loader
{
#ifdef CONCURRENT_LOAD
	std::unordered_map<std::string, std::future<std::size_t>> _assets_index;
	std::mutex _mt_image, _mt_audios, _mt_fonts;
	std::vector<SDL_Surface*> _surfaces;
#else
	std::unordered_map<std::string, std::size_t> _assets_index;
#endif
	beaver::sdlgame* _game;
	sol::table* _lua;
	asset_loader(beaver::sdlgame*);
	asset_loader(const asset_loader&) = delete;
	asset_loader(asset_loader&&) = delete;
	
	std::size_t load_image(const std::filesystem::path&);
	std::size_t load_sound(const std::filesystem::path&);
	std::size_t load_music(const std::filesystem::path&);
	std::size_t load_font(const std::filesystem::path&, int font_size);

	void load_from_lua(sol::table&);
	std::unordered_map<std::string, std::size_t> output();
};
