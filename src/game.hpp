#pragma once

#include <beaver/core.hpp>
#include <beaver/ecs/core.hpp>
#include <beaver/scripting/scripting_ecs.hpp>
#include <beaver/scripting/scripting_core.hpp>
#include <beaver/scripting/scripting_core_components.hpp>
#include <beaver/scripting/scripting_tile.hpp>
#include <beaver/scripting/scripting_camera.hpp>
#include "binding.hpp"
namespace rfr
{
	// Things need to be done
	// - Map drawing [x]
	// - Dialogue []
	// - Items []
	// - Endings
	struct game
	{
		game();
		beaver::sdlgame _beaver;
		sol::state _lua;
		std::vector<beaver::tile::tilemap> _maps;
		beaver::ecs_core<dialogue, interaction, location, event_listener> _entities;
		event_manager _events;
		cutscene_manager _cutscenes;
		beaver::camera2D _camera;
		void load_interactions();
		void setup_binding();
		void run();
		bool update(float dt);
		void draw();
	};
};
