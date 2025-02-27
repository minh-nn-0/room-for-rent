#include "asset_loader.hpp"

asset_loader::asset_loader(beaver::sdlgame* game): _game(game) {};

std::size_t asset_loader::load_image(const std::filesystem::path& path)
{
	sdl::texture tex {path, _game->_graphics._rdr};

	std::lock_guard lock {_mt_image};
	
	auto& vec = _game->_assets.get_vec<sdl::texture>();
	std::println("loading images: {}", path.string());
	vec.emplace_back(std::move(tex));
	return vec.size() - 1;
};
std::size_t asset_loader::load_sound(const std::filesystem::path& path)
{
	sdl::soundchunk sound {path.c_str()};
	
	std::lock_guard lock {_mt_audios};
	
	auto& vec = _game->_assets.get_vec<sdl::soundchunk>();
	std::println("loading sound: {}", path.string());
	vec.emplace_back(std::move(sound));
	return vec.size() - 1;
};
std::size_t asset_loader::load_music(const std::filesystem::path& path)
{
	sdl::music music {path.c_str()};

	std::lock_guard lock {_mt_audios};

	auto& vec = _game->_assets.get_vec<sdl::music>();
	std::println("loading music: {}", path.string());
	vec.emplace_back(std::move(music));
	return vec.size() - 1;
};
std::size_t asset_loader::load_font(const std::filesystem::path& path, int font_size)
{
	sdl::font font {path.c_str(), font_size};

	std::lock_guard lock {_mt_fonts};

	auto& vec = _game->_assets.get_vec<sdl::font>();
	std::println("loading font: {}", path.string());
	vec.emplace_back(std::move(font));
	return vec.size() - 1;
};

void asset_loader::load_from_lua(sol::table& assets)
{
	for (auto&& [k,v] : assets["images"].get<sol::table>())
		_assets_index.emplace(k.as<std::string>(), std::async(&asset_loader::load_image, this, v.as<std::string>()));
	for (auto&& [k,v] : assets["audios"].get<sol::table>())
		_assets_index.emplace(k.as<std::string>(), std::async(&asset_loader::load_sound, this, v.as<std::string>()));
	for (auto&& [k,v] : assets["fonts"].get<sol::table>())
		_assets_index.emplace(k.as<std::string>(), std::async(&asset_loader::load_font, this, v.as<std::string>(), 16));
};

std::unordered_map<std::string, std::size_t> asset_loader::output()
{
	std::unordered_map<std::string, std::size_t> rs;
	for (auto& [k,v] : _assets_index)
	{
		auto s = rs.emplace(k, v.get());
		std::println("getting {} id {}", s.first->first, s.first->second);
	}
	return rs;
};
