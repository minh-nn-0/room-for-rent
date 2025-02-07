local map = {}
local map_cam_boundaries = {
	["Map.Mainroom"] = {64, 320},
	["Map.Bathroom"] = {112,288},
	["Map.Hall"] = {330, 690},
	["Map.Balcony"] = {0, 800},
	["Map.Outside"] = {0, 690}
}
local map_move_boundaries = {
	["Map.Mainroom"] = {64, 320},
	["Map.Bathroom"] = {112,288},
	["Map.Hall1"] = {386, 673},
	["Map.Hall2"] = {418, 672},
	["Map.Balcony"] = {96, 238},
	["Map.Outside"] = {0, 690}
}
local current_map = "room"
function map.set_current_map(m)
	if rfr.get_flag("prologue_room") and m == "room" then
		m = "room_before"
	end
	current_map = m
end
function map.get_current_map()
	return current_map
end
function map.get_cam_boundaries(m)
	return map_cam_boundaries[m]
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

local player_width = 6
local clamp_distance_l = 1
local clamp_distance_r = 20 + clamp_distance_l
local function clamp_player()
	local ppos = rfr.get_position(PLAYER)
	local plocation = rfr.get_location(PLAYER)
	if plocation == "Map.Hall" then
		plocation = ppos.y == 96 and "Map.Hall2" or "Map.Hall1"
	end
	local boundary = map_move_boundaries[plocation]
	if boundary then
		if ppos.x <= boundary[1] - player_width - clamp_distance_l then ppos.x = boundary[1] - player_width - clamp_distance_l end
		if ppos.x >= boundary[2] - player_width - clamp_distance_r then ppos.x = boundary[2] - player_width - clamp_distance_r end
	end
	rfr.set_position(PLAYER, ppos.x, ppos.y)
end
local outside = require "outside"
function map.update(dt)
	outside.update(dt)
	clamp_player()
end
function map.draw_bg()
	local plocation = rfr.get_location(PLAYER)
	if plocation == "Map.Outside" or plocation == "Map.Hall" or plocation == "Map.Balcony" then outside.draw() end
	rfr.draw_map_by_layer(current_map, (plocation == "Map.Hall" and "Map.Outside" or plocation) .. ".Bg", 0, 0)
end

function map.draw_fg()
	local plocation = rfr.get_location(PLAYER)
	rfr.draw_map_by_layer(current_map, (plocation == "Map.Hall" and "Map.Outside" or plocation) .. ".Fg", 0, 0)
end
return map
