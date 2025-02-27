#include "game.hpp"
#include <beaver/ecs/systems/movement.hpp>
#include <beaver/ecs/systems/collision.hpp>
#include <beaver/ecs/systems/animation.hpp>
#include <beaver/ecs/systems/render_entity.hpp>
#include "note_drawing.hpp"
#include "textbox_drawing.hpp"

#ifndef NDEBUG
//#include <readline/readline.h>
//#include <readline/history.h>

constexpr bool debug = true;
#else
constexpr bool debug = false;
#endif
#ifdef __EMSCRIPTEN__
#include "/home/minhmacg/.cache/emscripten/sysroot/include/emscripten.h"
constexpr std::string game_path()
{
	return "gamedata/";
};
#else
constexpr std::string game_path()
{
	return {std::string(GAMEPATH) + "/gamedata/"}; 
};
#endif

//#ifndef NDEBUG
//std::mutex LUAREPL_MUTEX;
//std::atomic<bool> RUNNING {true};
//
//void run_lua_repl(sol::state& lua)
//{
//	std::string input;
//	while (RUNNING)
//	{
//		char* input = readline("> ");
//		if (!input) continue;
//		try
//		{
//			std::lock_guard<std::mutex> lock (LUAREPL_MUTEX);
//			lua.safe_script(input);
//			add_history(input);
//			free(input);
//		} catch (const sol::error& e)
//		{
//			std::cout << "error: " << e.what() << std::endl;
//		};
//	};
//}
//#endif

std::vector<std::size_t> DRAW_ORDER;
bool NEED_SORTING {true};

rfr::dialogue_options DIALOGUE_OPTIONS;
rfr::interaction_helper::drawdata INTERACTION_DRAWDATA;

rfr::game::game(): _beaver("RFR", 1280, 720), _asset_loader(&_beaver)
{
	_beaver._graphics._cam = &_camera;

	setup_binding();
	auto asset_file_rs = _lua.do_file(game_path() + "assets.lua");
	sol::table asset_table = asset_file_rs.get<sol::table>();
	_asset_loader.load_from_lua(asset_table);

	auto assets = _asset_loader.output();

	auto lua_assets = _lua["ASSETS"].get<sol::table>();
	for (auto& [type, tbl] : asset_table)
	{
		sol::table to_add_tbl = lua_assets[type].get_or_create<sol::table>();
		for (auto& [name, _] : tbl.as<sol::table>())
		{
			auto index = assets.at(name.as<std::string>());
			to_add_tbl[name] = assets.at(name.as<std::string>());
			if (type.as<std::string>() == "images")
			{
				sdl::texture& tex = _beaver._assets.get_vec<sdl::texture>().at(index);
				std::cout << "name " << tex._name << " ptr " << tex._t << " null " << std::boolalpha << (tex._t == nullptr) << " id " << index << '\n';
			};
		};
	};

	sol::protected_function load = _lua["LOAD"];
	auto load_result = load();
	if (!load_result.valid()) 
		throw std::runtime_error(std::format("runtime error: {}", sol::error{load_result}.what()));

	INTERACTION_DRAWDATA._tex = &_beaver._assets.get_vec<sdl::texture>().at(_lua["ASSETS"]["images"]["UI"]);
	INTERACTION_DRAWDATA._font = &_beaver._assets.get_vec<sdl::font>().at(_lua["ASSETS"]["fonts"][_lua["config"]["ui_font"]]);
	INTERACTION_DRAWDATA._Zsrc = {54,34,10,10};
	INTERACTION_DRAWDATA._Xsrc = {44,34,10,10};
	for (auto& map: _maps)
		beaver::tile::load_textures(map, _beaver._assets.get_vec<sdl::texture>());
};

void rfr::game::setup_binding()
{
	beaver::scripting::init_lua(_lua);
	beaver::scripting::bind_core(_beaver, _lua);

	sol::table rfr = _lua["rfr"].get_or_create<sol::table>();
	beaver::scripting::bind_entity(_entities, rfr);
	beaver::scripting::bind_ecs_core_components(_entities, _beaver, rfr, _lua);
	beaver::scripting::bind_tile(_beaver, _maps, rfr);
	beaver::scripting::bind_camera(_camera, rfr);

	bind_dialogue(_entities, DIALOGUE_OPTIONS, rfr, _lua);
	bind_interaction(_entities, rfr);
	bind_location(_entities, rfr);
	bind_event(_entities, _events, rfr);
	bind_cutscene(_cutscenes, rfr);
	bind_zindex(_entities, DRAW_ORDER, NEED_SORTING, rfr);

	rfr.set_function("gamepath", [&]{return game_path();});
	using namespace beaver::component;
	//rfr.set_function("update_movement", [&](float dt)
	//		{
	//			for (auto&& eid:_entities.with<position, velocity>()) 
	//			{
	//				position new_pos = _entities.get_component<position>(eid).value();
	//				velocity new_vel = _entities.get_component<velocity>(eid).value();


	//				new_pos = beaver::system::movement::apply_velocity(new_pos, new_vel, dt);

	//				_entities.set_component<position>(eid, new_pos);
	//				_entities.set_component<velocity>(eid, new_vel);
	//			};
	//		});
	//rfr.set_function("update_animation", [&](float dt)
	//		{
	//			beaver::system::animation::update_tile_animation(_beaver._assets, _entities, dt);
	//		});
	//rfr.set_function("update_countdown", [&](float dt)
	//		{
	//			for (auto&& eid: _entities.with<timing::countdown>())
	//			{
	//				_entities.get_component<timing::countdown>(eid)->update(dt);
	//			};
	//		});
	//rfr.set_function("update_timer", [&](float dt)
	//		{
	//			for (auto&& eid: _entities.with<timing::stopwatch>())
	//			{
	//				_entities.get_component<timing::stopwatch>(eid)->update(dt);
	//			};
	//		});
	//rfr.set_function("update_particle_emitter", [&](float dt)
	//		{
	//			for (auto&& eid: _entities.with<particle_emitter>())
	//			{
	//				_entities.get_component<particle_emitter>(eid)->update(dt);
	//			};
	//		});
	//rfr.set_function("update_state", [&]()
	//		{
	//			for (auto&& eid: _entities.with<beaver::component::fsmstr>())
	//			{
	//				_entities.get_component<beaver::component::fsmstr>(eid)->update();
	//			};
	//		});
	//// COLLISIONS
	//rfr.set_function("find_collisions", [&](std::size_t eid) -> std::vector<std::size_t>
	//		{
	//			return beaver::system::collision::find_collisions(eid, _entities);
	//		});
	//rfr.set_function("colliding_with", [&](std::size_t eid, std::size_t other_eid)
	//		{
	//			auto collisions = beaver::system::collision::find_collisions(eid, _entities);
	//			return std::ranges::find(collisions, other_eid) != collisions.end();
	//		});
	rfr.set_function("camera_target", [&](float tx, float ty, float dt)
			{
				_camera.target({tx, ty},dt);
			});
	rfr.set_function("clamp_camera", [&](float minx, float maxx)
			{
				_camera._view._pos.x = std::clamp(_camera._view._pos.x, minx, maxx);
			});
	rfr.set_function("cleanup_entities", [&]() {_entities.clear_inactive();});

	rfr.set_function("draw_entities", [&](std::size_t eid)
			{
				beaver::system::render::render_entity(eid, _entities, _beaver);
			});
	rfr.set_function("draw_particles", [&](std::size_t eid)
			{
				if (_entities.has_component<particle_emitter>(eid))
					_entities.get_component<particle_emitter>(eid)->draw(_beaver._graphics);
			});
	rfr.set_function("draw_interactions_info", [&](std::size_t eid, std::size_t UI_tex, std::size_t font)
			{
				auto& interaction = _entities.get_component<rfr::interaction>(eid);
				if (interaction.has_value() && interaction->_condition())
				{
					auto& pos = _entities.get_component<position>(eid).value();
					draw_interaction(interaction->_name, pos._value, 
							_lua["config"]["text_scale"],
							_lua["config"]["interaction_box_padding"],
							UI_tex, font,
							_beaver);
				}
			});
	rfr.set_function("draw_interaction_helper", [&](const std::string& Xcontent, const std::string& Zcontent)
			{
				rfr::interaction_helper::draw(Xcontent, Zcontent, _beaver, INTERACTION_DRAWDATA);
			});
	rfr.set_function("draw_dialogue", [&](std::size_t eid, std::size_t UI_tex, std::size_t font)
			{
				auto& dialogue = _entities.get_component<rfr::dialogue>(eid);
				if (dialogue.has_value() && dialogue->_text_index > 1)
				{
					auto pos = _entities.get_component<beaver::component::position>(eid).value();
					rfr::draw_dialogue(pos._value , *dialogue, 
							_lua["config"]["text_scale"],
							_lua["config"]["dialogue_box_padding"],
							_lua["config"]["dialogue_wraplength"],
							UI_tex, font,
							_beaver);
				};
			});
	rfr.set_function("draw_dialogue_options", [&](std::size_t UI_tex, std::size_t font, float x, float y, bool align_left)
			{
				float scale = _lua["config"]["text_scale"];
				float padding = _lua["config"]["interaction_box_padding"];
				float currenty = y;
				for (int i = 0; i != DIALOGUE_OPTIONS._options.size(); i++)
				{
					const std::string& opts = DIALOGUE_OPTIONS._options[i];
					sdl::texture text = beaver::make_text_blended(_beaver._graphics._rdr, _beaver._assets.get_vec<sdl::font>().at(font), opts, _beaver._graphics._draw_color);
					
					// Still want to figure out the oneline formula here
					mmath::frect text_dst = {align_left ? x : x - text._width * scale,
											currenty,
											text._width * scale,
											text._height * scale};
					mmath::frect text_box {text_dst._pos.x - padding, 
											text_dst._pos.y - 1.5f,
											text_dst._size.x + 2 * padding,
											text_dst._size.y + 3};
					
					draw_textbox_9parts(text_box,
										DIALOGUE_OPTIONS._selection == i ? mmath::ivec2{24, 0} : mmath::ivec2{36, 0},
										4,
										_beaver._assets.get_vec<sdl::texture>().at(UI_tex), _beaver._graphics);
					_beaver._graphics.texture(text, text_dst);
					currenty += text_box._size.y + 5/_camera._zoom;
				};
			});
	rfr.set_function("draw_note", [&](float posx, float posy, const std::string& text, const std::string& header, std::size_t UI_tex, std::size_t font)
			{
				return rfr::draw_note(posx, posy, text, header, UI_tex, font, _beaver, _lua);
			});
	rfr.set_function("draw_map", [&](beaver::tile::tilemap* map, float posx, float posy)
			{
				_beaver._graphics.tilemap(*map, {posx, posy}, _beaver._assets.get_cvec<sdl::texture>());
			});
	rfr.set_function("draw_map_by_layer", [&](std::size_t mapid, const std::string& layer_name, float posx, float posy)
			{
				_beaver._graphics.tilemap_by_layer(_maps.at(mapid), layer_name, {posx, posy}, _beaver._assets.get_cvec<sdl::texture>());
			});

	try 
	{
		_lua.safe_script_file(game_path() + "config.lua");
		_lua.safe_script_file(game_path() + "scripts/main.lua");
	} catch (const sol::error& e)
	{
		std::println("error loading script: {}", e.what()); 
	};
	_lua.script(R"(
    function safe_update(dt)
        local success, result = pcall(UPDATE, dt)
        if not success then
			print(debug.traceback())
            error(result) -- Propagate the error back to C++
        end
        return result
    end
	)");
};

using namespace beaver::component;
bool rfr::game::update(float dt)
{
	_camera._view._size = _beaver.render_logical_size();
	// countdown
	for (auto&& eid: _entities.with<timing::countdown>())
		_entities.get_component<timing::countdown>(eid)->update(dt);

	// stopwatch
	for (auto&& eid: _entities.with<timing::stopwatch>())
		_entities.get_component<timing::stopwatch>(eid)->update(dt);

	// particles
	for (auto&& eid: _entities.with<particle_emitter>())
		_entities.get_component<particle_emitter>(eid)->update(dt);

	// state
	for (auto&& eid: _entities.with<beaver::component::fsmstr>())
		_entities.get_component<beaver::component::fsmstr>(eid)->update();

	// event
	for (auto&& eid: _entities.with<rfr::event_listener>())
		rfr::update_event_listener(_entities.get_component<rfr::event_listener>(eid).value(), _events);

	for (auto&& [eid, eventid]: _events._to_remove)
	{
		_entities.get_component<rfr::event_listener>(eid)->erase(eventid);
		_events._to_remove.clear();
	}
	// dialogue
	for (auto&& eid: _entities.with<rfr::dialogue>())
		rfr::update_dialogue(_entities.get_component<rfr::dialogue>(eid).value(),
				_lua["config"]["dialogue_wait_time"], dt);
	// interaction
	// scene
	// cutscene
	_cutscenes.update(dt);

	// tile animation
	beaver::system::animation::update_tile_animation(_beaver._assets, _entities, dt);
	sol::protected_function lua_update = _lua["safe_update"];
	auto update_result = lua_update(dt);
	if (!update_result.valid())
		throw std::runtime_error(std::format("runtime error: {}", sol::error{update_result}.what()));
	// cleanup
	_entities.clear_inactive();
	return update_result;
};


void rfr::game::draw()
{
	if (NEED_SORTING)
	{
		DRAW_ORDER = _entities.with<rfr::zindex>();
		std::ranges::stable_sort(DRAW_ORDER, {}, [&](std::size_t eid){return _entities.get_component<rfr::zindex>(eid)->_value;});
		NEED_SORTING = false;
	};
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
#ifdef __EMSCRIPTEN__
void rungame(void* arg)
{
	rfr::game* game = static_cast<rfr::game*>(arg);
	SDL_Event sdlevent;
	game->_beaver._gametime += 1.f/60;
	while (SDL_PollEvent(&sdlevent))
	{
		game->_beaver._ctl.update(sdlevent);
		if (sdlevent.type == SDL_QUIT) 
		{
		};
	};

	game->update(1.f/60);
	
	game->draw();
	SDL_RenderPresent(game->_beaver._graphics._rdr);
	for (auto& [_,v]: game->_beaver._ctl._keystate)
		if (v > 0) v++;
};
#endif

void rfr::game::run()
{
#ifdef __EMSCRIPTEN__
	emscripten_set_main_loop_arg(rungame, this, 60, 1);
#else
//#ifndef NDEBUG
//	std::thread lua_repl_thread {run_lua_repl, std::ref(_lua)};
//#endif
	beaver::run_game(_beaver, 
			[&](float dt)
			{
//#ifndef NDEBUG
//				std::lock_guard<std::mutex> lock (LUAREPL_MUTEX);
//#endif
				return update(dt); 
			},
			[&]()
			{
//#ifndef NDEBUG
//				std::lock_guard<std::mutex> lock (LUAREPL_MUTEX);
//#endif
				draw();
			});
//#ifndef NDEBUG
//	RUNNING = false;
//	if (lua_repl_thread.joinable())
//		lua_repl_thread.join();
//#endif

#endif
};
