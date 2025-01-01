local map = {
	current = "room",
}

function map.set_only_player_location_visible(map_name)
	local player_location = rfr.get_location(PEID)
	for _, group in ipairs(rfr.get_group_layers(map_name, "Map")) do
		rfr.set_layer_visible(map_name, group, false)
	end

	rfr.set_layer_visible(map_name, player_location, true)
end


return map
