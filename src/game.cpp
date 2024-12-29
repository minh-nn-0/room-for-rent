#include "game.hpp"
#include <beaver/ecs/systems/movement.hpp>
#include <beaver/ecs/systems/collision.hpp>
#include <beaver/ecs/systems/animation.hpp>
#include <beaver/ecs/systems/render_entity.hpp>

#ifdef __EMSCRIPTEN__
#include "/home/minhmacg/.cache/emscripten/sysroot/include/emscripten.h"
#endif
#ifdef __EMSCRIPTEN__
constexpr std::string game_path()
{
	return "";
};
#else
constexpr std::string game_path()
{
	return {std::string(GAMEPATH) + "/"};
};
#endif

template<typename... Ts>
void bind_dialogue(beaver::ecs<Ts...>& ecs, beaver::sdlgame& beaver, sol::table& tbl, sol::state& lua)
{
	tbl.set_function("set_dialogue", [&](std::size_t eid, const std::string& content)
			{
				auto& dl = ecs.template get_or_set_component<rfr::dialogue>(eid);
				dl->_content = content;
				dl->_time = content.length() / lua["config"]["wpm"].get<float>();
			});
	tbl.set_function("set_dialogue_position", [&](std::size_t eid, float x, float y)
			{
				ecs.template get_or_set_component<rfr::dialogue>(eid)->_position = {x, y};
			});
	tbl.set_function("update_dialogue", [&](float dt)
			{
				for (std::size_t eid: ecs.template with<rfr::dialogue>())
				{
					ecs.template get_component<rfr::dialogue>(eid)->_time -= dt;
				};
			});
};


rfr::game::game(): _beaver("RFR", 1280, 720)
{
	_beaver._graphics._cam = &_camera;

	beaver::scripting::init_lua(_lua);
	beaver::scripting::bind_core(_beaver, _lua);

	sol::table rfr = _lua["rfr"].get_or_create<sol::table>();
	beaver::scripting::bind_entity(_entities, rfr);
	beaver::scripting::bind_ecs_core_components(_entities, _beaver, rfr, _lua);
	beaver::scripting::bind_tile(_beaver, _maps, rfr);
	beaver::scripting::bind_camera(_camera, rfr);

	bind_dialogue(_entities, _beaver, rfr, _lua);

	rfr.set_function("gamepath", [&]{return game_path();});

	try 
	{
		_lua.safe_script_file(game_path() + "config.lua");
		_lua.safe_script_file(game_path() + "scripts/main.lua");
	} catch (const sol::error& e)
	{
		std::println("error loading script: {}", e.what()); 
	};

	using namespace beaver::component;
	rfr.set_function("update_movement", [&](float dt)
			{
				for (auto&& eid:_entities.with<position, velocity>()) 
				{
					position new_pos = _entities.get_component<position>(eid).value();
					velocity new_vel = _entities.get_component<velocity>(eid).value();


					new_pos = beaver::system::movement::apply_velocity(new_pos, new_vel, dt);

					_entities.set_component<position>(eid, new_pos);
					_entities.set_component<velocity>(eid, new_vel);
				};
			});
	rfr.set_function("update_animation", [&](float dt)
			{
				beaver::system::animation::update_tile_animation(_beaver._assets, _entities, dt);
			});
	rfr.set_function("update_countdown", [&](float dt)
			{
				for (auto&& eid: _entities.with<timing::countdown>())
				{
					_entities.get_component<timing::countdown>(eid)->update(dt);
				};
			});
	rfr.set_function("update_timer", [&](float dt)
			{
				for (auto&& eid: _entities.with<timing::stopwatch>())
				{
					_entities.get_component<timing::stopwatch>(eid)->update(dt);
				};
			});
	rfr.set_function("update_particle_emitter", [&](float dt)
			{
				for (auto&& eid: _entities.with<particle_emitter>())
				{
					_entities.get_component<particle_emitter>(eid)->update(dt);
				};
			});
	rfr.set_function("update_state", [&]()
			{
				for (auto&& eid: _entities.with<beaver::component::fsmstr>())
				{
					_entities.get_component<beaver::component::fsmstr>(eid)->update();
				};
			});
	rfr.set_function("find_collisions", [&](std::size_t eid) -> std::vector<std::size_t>
			{
				return beaver::system::collision::find_collisions(eid, _entities);
			});
	rfr.set_function("colliding_with", [&](std::size_t eid, std::size_t other_eid)
			{
				auto collisions = beaver::system::collision::find_collisions(eid, _entities);
				return std::ranges::find(collisions, other_eid) != collisions.end();
			});
	rfr.set_function("update_camera", [&](float dt)
			{
				_camera.update(dt);
			});
	rfr.set_function("clamp_camera", [&](float minx, float maxx)
			{
				_camera._view._pos.x = std::clamp(_camera._view._pos.x, minx, maxx);
			});
	rfr.set_function("cleanup_entities", [&]() {_entities.clear_inactive();});


	rfr.set_function("draw_entities", [&]
			{
				for (std::size_t eid: _entities.with<position, image_render>()) 
				beaver::system::render::render_entity(eid, _entities, _beaver);
			});
	rfr.set_function("draw_particles", [&]
			{
				for (const auto& eid: _entities.with<particle_emitter>())
					_entities.get_component<particle_emitter>(eid)->draw(_beaver._graphics);
			});
	rfr.set_function("draw_dialogue", [&]()
			{
				for (std::size_t eid: _entities.with<rfr::dialogue, beaver::component::position>())
				{
					auto& dialogue = _entities.get_component<rfr::dialogue>(eid).value();
					auto pos = _entities.get_component<beaver::component::position>(eid).value();

					rfr::draw_dialogue(pos._value , dialogue, _beaver);
				};
			});
	rfr.set_function("draw_map", [&](const std::string& map_name, float posx, float posy)
			{
				_beaver._graphics.tilemap(_maps.at(map_name), {posx, posy}, _beaver._assets.get_cvec<sdl::texture>());
			});


	sol::protected_function load = _lua["LOAD"];
	auto load_result = load();
	if (!load_result.valid()) 
		throw std::runtime_error(std::format("runtime error: {}", sol::error{load_result}.what()));
};


bool rfr::game::update(float dt)
{
	_camera._view._size = _beaver.window_size();
	sol::protected_function lua_update = _lua["UPDATE"];
	auto update_result = lua_update(dt);
	if (!update_result.valid())
		throw std::runtime_error(std::format("runtime error: {}", sol::error{update_result}.what()));

	return update_result;
};


void rfr::game::draw()
{
	sol::protected_function lua_draw = _lua["DRAW"];
	auto draw_result = lua_draw();
	if (!draw_result.valid())
		throw std::runtime_error(std::format("runtime error: {}", sol::error{draw_result}.what()));

	//SDL_RenderClear(_beaver._graphics._rdr);

	//SDL_Texture* shadow = *_beaver._assets.get<sdl::texture>("shadow");
	//SDL_SetRenderTarget(_beaver._graphics._rdr, shadow);
	//SDL_SetRenderDrawColor(_beaver._graphics._rdr, 0, 0, 0, 255);

	//SDL_RenderFillRect(_beaver._graphics._rdr, nullptr); /* draw the color to the entire shadow*/

	//SDL_Rect lightdes = {50,50,80,80};
	//SDL_RenderCopy(_beaver._graphics._rdr, *_beaver._assets.get<sdl::texture>("tl"), nullptr, &lightdes); /* your spotlights */

	//SDL_SetRenderTarget(_beaver._graphics._rdr, nullptr) /* set the render back to your scene*/;

	//SDL_RenderCopy(_beaver._graphics._rdr, shadow, nullptr, nullptr); /* shadow */
}

void rfr::game::run()
{
	beaver::run_game(_beaver, 
			[&](float dt){return update(dt);},
			[&](){draw();});
};