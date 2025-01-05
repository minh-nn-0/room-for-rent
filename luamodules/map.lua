local current_map = "room"
function rfr.set_current_map(map)
	current_map = map
end
function rfr.get_current_map()
	return current_map
end
function rfr.set_only_player_location_visible()
	local player_location = rfr.get_location(PLAYER)
	for _, group in ipairs(rfr.get_group_layers(current_map, "Map")) do
		rfr.set_layer_visible(current_map, group, false)
	end
	rfr.set_layer_visible(current_map, player_location, true)
end
