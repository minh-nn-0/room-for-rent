#pragma once

#include <functional>
#include <string>
#include <set>
namespace rfr
{
	using event_listener = std::unordered_map<std::string, std::function<void()>>;
	
	struct event_manager
	{
		std::set<std::string_view> _current_events;
		std::unordered_map<std::string, std::function<bool()>> _events;
	};

};
