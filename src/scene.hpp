#pragma once

#include <sol/sol.hpp>
namespace rfr
{
	struct scene
	{
		sol::function _init;
		sol::function _update(float dt);
	};
};
