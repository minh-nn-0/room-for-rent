#include "asset_loader.hpp"

asset_loader::asset_loader(beaver::sdlgame* game): _game(game) {};

std::size_t asset_loader::load_image(const std::filesystem::path& path)
{
#ifdef CONCURRENT_LOAD
	std::lock_guard lock {_mt_image};
	std::println("loading images: {}", path.string());
	_surfaces.emplace_back(IMG_Load(path.c_str()));
	return _surfaces.size() - 1;
#else
	sdl::texture tex {path, _game->_graphics._rdr};
	auto& vec = _game->_assets.get_vec<sdl::texture>();
	std::println("loading images: {}", path.string());
	vec.emplace_back(std::move(tex));
	return vec.size() - 1;
#endif
};
std::size_t asset_loader::load_sound(const std::filesystem::path& path)
{
	sdl::soundchunk sound {path.c_str()};
	
#ifdef CONCURRENT_LOAD
	std::lock_guard lock {_mt_audios};
#endif
	
	auto& vec = _game->_assets.get_vec<sdl::soundchunk>();
	std::println("loading sound: {}", path.string());
	vec.emplace_back(std::move(sound));
	return vec.size() - 1;
};
std::size_t asset_loader::load_music(const std::filesystem::path& path)
{
	sdl::music music {path.c_str()};

#ifdef CONCURRENT_LOAD
	std::lock_guard lock {_mt_audios};
#endif

	auto& vec = _game->_assets.get_vec<sdl::music>();
	std::println("loading music: {}", path.string());
	vec.emplace_back(std::move(music));
	return vec.size() - 1;
};
std::size_t asset_loader::load_font(const std::filesystem::path& path, int font_size)
{
	sdl::font font {path.c_str(), font_size};

#ifdef CONCURRENT_LOAD
	std::lock_guard lock {_mt_fonts};
#endif
	auto& vec = _game->_assets.get_vec<sdl::font>();
	std::println("loading font: {}", path.string());
	vec.emplace_back(std::move(font));
	return vec.size() - 1;
};

void asset_loader::load_from_lua(sol::table& assets)
{
	_lua = &assets;
	for (auto&& [k, v] : assets["images"].get<sol::table>()) {
#ifdef CONCURRENT_LOAD
		_assets_index.emplace(k.as<std::string>() + "___images", 
			std::async(std::launch::async, &asset_loader::load_image, this, v.as<std::string>()));
#else
		_assets_index.emplace(k.as<std::string>(), load_image(v.as<std::string>()));
#endif
	}

	for (auto&& [k, v] : assets["audios"].get<sol::table>()) {
#ifdef CONCURRENT_LOAD
		_assets_index.emplace(k.as<std::string>(), 
			std::async(std::launch::async, &asset_loader::load_sound, this, v.as<std::string>()));
#else
		_assets_index.emplace(k.as<std::string>(), load_sound(v.as<std::string>()));
#endif
	}

	for (auto&& [k, v] : assets["fonts"].get<sol::table>()) {
#ifdef CONCURRENT_LOAD
		_assets_index.emplace(k.as<std::string>(), 
			std::async(&asset_loader::load_font, this, v.as<std::string>(), 16));
#else
		_assets_index.emplace(k.as<std::string>(), load_font(v.as<std::string>(), 16));
#endif
	}
}

std::unordered_map<std::string, std::size_t> asset_loader::output()
{
	std::unordered_map<std::string, std::size_t> rs;
	for (auto& [k,v] : _assets_index)
	{
		std::unordered_map<std::string, std::size_t>::iterator inserted;
#ifdef CONCURRENT_LOAD
		if (k.ends_with("___images"))
		{
			auto name = k.substr(0, k.size() - std::string_view{"___images"}.size());
			sdl::texture tex {SDL_CreateTextureFromSurface(_game->_graphics._rdr,_surfaces.at(v.get())),
				std::filesystem::path{(*_lua)["images"][name].get<std::string>()}.filename().c_str()}; 
			auto& vec = _game->_assets.get_vec<sdl::texture>();
			vec.emplace_back(std::move(tex));
			inserted = rs.emplace(name, vec.size() - 1).first;
		}
		else inserted = rs.emplace(k, v.get()).first;
#else
		inserted = rs.emplace(k, v).first;
#endif
		std::println("getting {} id {}", inserted->first, inserted->second);
	}
	return rs;
};
