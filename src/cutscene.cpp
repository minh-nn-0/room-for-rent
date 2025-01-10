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

void rfr::cutscene_manager::play(const std::string& scene_name)
{
	if (_cutscenes.contains(scene_name))
	{
		_current_cutscene_name = scene_name;
		_player.play(_cutscenes.at(scene_name));
	}
	else throw std::invalid_argument(std::format("scene {} doesn't exist", scene_name));
};
void rfr::cutscene_manager::update(float dt)
{
	if (_player._active) _player.update(dt);
};
