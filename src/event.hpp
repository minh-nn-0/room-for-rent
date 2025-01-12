#pragma once

#include <functional>
#include <string>
#include <set>
namespace rfr
{
	using event_listener = std::unordered_map<std::size_t, std::function<void()>>;
	
	struct event_manager
	{
		std::set<std::size_t> _current_events;
		std::vector<std::function<bool()>> _events;
	};

};
