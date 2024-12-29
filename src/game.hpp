#pragma once

#include <beaver/core.hpp>
#include <beaver/ecs/core.hpp>
#include <beaver/scripting/scripting_ecs.hpp>
#include <beaver/scripting/scripting_core.hpp>
#include <beaver/scripting/scripting_core_components.hpp>
#include <beaver/scripting/scripting_tile.hpp>
#include <beaver/scripting/scripting_camera.hpp>
#include "dialogue.hpp"
#include "tooltip.hpp"
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
		std::unordered_map<std::string, beaver::tile::tilemap> _maps;
		beaver::ecs_core<dialogue, tooltip> _entities;
		beaver::camera2D _camera;

		void run();
		bool update(float dt);
		void draw();
	};
};