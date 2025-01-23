local map = {}
local map_boundaries = {
	["Map.Mainroom"] = {64, 320},
	["Map.Bathroom"] = {112,288},
	["Map.Hall"] = {340, 800},
	["Map.Outside"] = {0, 800}
}
local current_map = "room"
function map.set_current_map(m)
	current_map = m
end
function map.get_current_map()
	return current_map
end
function map.get_map_boundaries(m)
	return map_boundaries[m]
end

function map.prepare_hall()
	rfr.set_layer_visible("outside", "Map.Outside.Bg.house_wall", false)
	rfr.set_layer_visible("outside", "Map.Outside.Bg.fences", false)
	rfr.set_layer_visible("outside", "Map.Outside.Fg.fences", true)
end

function map.prepare_outside()
	rfr.set_layer_visible("outside", "Map.Outside.Bg.house_wall", true)
	rfr.set_layer_visible("outside", "Map.Outside.Bg.fences", true)
	rfr.set_layer_visible("outside", "Map.Outside.Fg.fences", false)
end
function map.set_only_player_location_visible()
	local player_location = rfr.get_location(PLAYER)
	player_location = player_location == "Map.Hall" and "Map.Outside" or player_location
	for _, group in ipairs(rfr.get_group_layers(current_map, "Map")) do
		rfr.set_layer_visible(current_map, group, false)
	end
	rfr.set_layer_visible(current_map, player_location, true)
end

local outside = require "outside"
function map.draw_bg()
	local plocation = rfr.get_location(PLAYER)
	if plocation == "Map.Outside" or plocation == "Map.Hall" then outside.draw() end
	rfr.draw_map_by_layer(current_map, (plocation == "Map.Hall" and "Map.Outside" or plocation) .. ".Bg", 0, 0)
end

function map.draw_fg()
	local plocation = rfr.get_location(PLAYER)
	rfr.draw_map_by_layer(rfr.get_current_map(), (plocation == "Map.Hall" and "Map.Outside" or plocation) .. ".Fg", 0, 0)
end
return map
