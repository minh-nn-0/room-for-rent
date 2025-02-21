#include "event.hpp"
void rfr::update_event_listener(rfr::event_listener& listener, event_manager& manager)
{
	for (auto&& [eventid, resolver]: listener)
	if (manager._events.at(eventid)()) resolver();
};
