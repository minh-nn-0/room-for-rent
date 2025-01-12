#include "cutscene.hpp"
#include <print>

void rfr::cutscene_player::play(const rfr::cutscene& scene)
{
	scene._initf();
	_current_scene = scene;
	_active = true;
	_current_scriptid = 0;
};

void rfr::cutscene_player::update(float dt)
{
	if (!_active) return;
	if (_current_scriptid != _current_scene._scripts.size()
		&& _current_scene._scripts.at(_current_scriptid)(dt))
			_current_scriptid++;
	_current_scene._updatef(dt);
	if (_current_scriptid >= _current_scene._scripts.size())
	{
		_active = false;
		_current_scene._exitf();
		return;
	};
};

void rfr::cutscene_manager::play(int scene)
{
	if (scene < _cutscenes.size())
		_next_sceneid = scene;
	else throw std::invalid_argument(std::format("scene {} out of bound", scene));
};
void rfr::cutscene_manager::update(float dt)
{
	if (!_player._active)
	{
		if (_next_sceneid != -1)
		{
			_player.play(_cutscenes.at(_next_sceneid));
			_current_sceneid = _next_sceneid;
			_next_sceneid = -1;
		};
	}
	else _player.update(dt);
};
