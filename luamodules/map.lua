local map_boundaries = {
	["Map.Mainroom"] = {64, 320},
	["Map.Bathroom"] = {112,288},
	["Map.Hall"] = {340, 800},
	["Map.Outside"] = {0, 800}
}
local current_map = "room"
function rfr.set_current_map(map)
	if map == "room" and rfr.get_flag("prologue") then map = "room_before" end
	current_map = map
end
function rfr.get_current_map()
	return current_map
end
function rfr.get_map_boundaries(map)
	return map_boundaries[map]
end
function rfr.set_only_player_location_visible()
	local player_location = rfr.get_location(PLAYER)
	for _, group in ipairs(rfr.get_group_layers(current_map, "Map")) do
		rfr.set_layer_visible(current_map, group, false)
	end
	rfr.set_layer_visible(current_map, player_location, true)
end
