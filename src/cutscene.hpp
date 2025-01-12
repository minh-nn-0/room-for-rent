#pragma once

#include <string>
#include <functional>
namespace rfr
{
	struct cutscene
	{
		std::vector<std::function<bool(float)>> _scripts;
		std::function<void(float)> _updatef;
		std::function<void()> _initf;
		std::function<void()> _exitf;
	};
	struct cutscene_player
	{
		cutscene _current_scene;
		std::size_t _current_scriptid{0};
		bool _active {false};
		void play(const cutscene&);
		void update(float dt);
	};

	struct cutscene_manager
	{
		int _next_sceneid {-1};
		int _current_sceneid;
		std::vector<cutscene> _cutscenes;
		cutscene_player _player;

		void play(int scene_name);
		void update(float dt);
	};
};
