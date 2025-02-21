#pragma once

#include <functional>
#include <set>
namespace rfr
{
	using event_listener = std::unordered_map<std::size_t, std::function<void()>>;

	
	struct event_manager
	{
		std::vector<std::function<bool()>> _events;
		std::vector<std::pair<std::size_t, std::size_t>> _to_remove;

	};
	void update_event_listener(event_listener&, event_manager&);
};
