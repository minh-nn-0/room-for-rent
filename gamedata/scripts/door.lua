local util = require "luamodules.utilities"
local interaction_name = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")
local map = require "luamodules.map"
local door_label_position = {
	room_bathroom = {pos = {256,100}, location = "Map.Mainroom"},
	bathroom_room = {pos = {256,230}, location = "Map.Bathroom"},
	room_hall = {pos = {305,100}, location = "Map.Mainroom"},
	hall_room = {pos = {458, 70}, location = "Map.Hall"},
	room_balcony = {pos = {80,100}, location = "Map.Mainroom"},
	balcony_room = {pos = {144,84}, location = "Map.Balcony"},
	hallstair_1 = {pos = {660, 134}, location = "Map.Hall"},
	hallstair_2 = {pos = {660, 80}, location = "Map.Hall"},
	gate_in = {pos = {424,134}, location = "Map.Hall"},
	gate_out = {pos = {424,134}, location = "Map.Outside"},
}

local door_destination = {
	room_bathroom = {pos = {240,240}, location = "Map.Bathroom", map = "room"},
	bathroom_room = {pos = {240,112}, location = "Map.Mainroom", map = "room"},
	room_hall = {pos = {440,96}, location = "Map.Hall", map = "outside"},
	room_balcony = {pos = {128,96}, location = "Map.Balcony", map = "balcony"},
	balcony_room = {pos = {64,112}, location = "Map.Mainroom", map = "room"},
	hall_room = {pos = {290,112}, location = "Map.Mainroom", map = "room"},
	hallstair_1 = {pos = {640,96}, location = "Map.Hall", map = "outside"},
	hallstair_2 = {pos = {640,144}, location = "Map.Hall", map = "outside"},
	gate_in = {pos = {400,144}, location = "Map.Outside", map = "outside"},
	gate_out = {pos = {400,144}, location = "Map.Hall", map = "outside"},
}
local function make_door(d)
	local door_eid = rfr.add_entity()
	local door_pos = door_label_position[d].pos
	local door_location = door_label_position[d].location
	rfr.set_position(door_eid, door_pos[1], door_pos[2])
	rfr.set_location(door_eid, door_location)
	return door_eid
end
local function player_in_range(d,range)
	local px,_ = util.player_center()
	local door_pos = door_label_position[d].pos
	return px >= door_pos[1] - range and px <= door_pos[1] + range
end
local function move_player_to_destination(d, move_cam)
	local door_dst = door_destination[d]
	map.set_current_map(door_dst.map)
	rfr.set_location(PLAYER, door_dst.location)
	rfr.set_position(PLAYER, door_dst.pos[1], door_dst.pos[2])

	if move_cam then
		rfr.set_cam_center(door_dst.pos[1] + 16, door_dst.pos[2]+16)
	end
end
DOOR_ROOM_BATHROOM = make_door("room_bathroom")
DOOR_ROOM_HALL = make_door("room_hall")
DOOR_ROOM_BALCONY = make_door("room_balcony")
DOOR_BATHROOM_ROOM = make_door("bathroom_room")
DOOR_BALCONY_ROOM = make_door("balcony_room")
DOOR_HALL_ROOM = make_door("hall_room")
DOOR_HALL_STAIR_FIRST = make_door("hallstair_1")
DOOR_HALL_STAIR_SECOND = make_door("hallstair_2")
METAL_GATE_OUTSIDE = make_door("gate_out")
METAL_GATE_INSIDE = make_door("gate_in")
local locked_doors

rfr.set_interaction(DOOR_ROOM_BATHROOM, interaction_name["door_room_to_bathroom"],
	function()
		return player_in_range("room_bathroom", 10)
	end,
	function()
		beaver.play_sound("dooropen")
		rfr.fade_in(2)
		move_player_to_destination("room_bathroom", true)
	end)

rfr.set_interaction(DOOR_BATHROOM_ROOM, interaction_name["door_bathroom_to_room"],
	function()
		return player_in_range("bathroom_room", 10)
	end,
	function()
		beaver.play_sound("dooropen")
		rfr.fade_in(2)
		move_player_to_destination("bathroom_room", true)
	end)

rfr.set_interaction(DOOR_ROOM_HALL, interaction_name["door_room_to_hall"],
	function()
		return player_in_range("room_hall", 10)
	end,
	function()
		if rfr.get_flag("prologue_room") then rfr.set_dialogue(PLAYER, {content = interaction_details["door_room_to_hall_not_clean"]})
		else
			beaver.play_sound("dooropen2")
			rfr.set_cam_zoom(3)
			rfr.fade_in(2)
			move_player_to_destination("room_hall", true)
		end
	end)
rfr.set_interaction(DOOR_ROOM_BALCONY, interaction_name["door_room_to_balcony"],
	function()
		return player_in_range("room_balcony", 10)
	end,
	function()
		rfr.set_cam_zoom(3)
		rfr.fade_in(1)
		move_player_to_destination("room_balcony", true)
	end)

rfr.set_interaction(DOOR_BALCONY_ROOM, interaction_name["door_balcony_to_room"],
	function()
		return player_in_range("balcony_room", 10)
	end,
	function()
		rfr.set_cam_zoom(config.cam_zoom)
		rfr.fade_in(1)
		move_player_to_destination("balcony_room", true)
	end)

rfr.set_interaction(DOOR_HALL_ROOM, interaction_name["door_hall_to_room"],
	function()
		return player_in_range("hall_room", 10)
	end,
	function()
		beaver.play_sound("dooropen2")
		rfr.set_cam_zoom(config.cam_zoom)
		rfr.fade_in(2)
		rfr.set_cam_center(PLAYER, 16,0)
		move_player_to_destination("hall_room", true)
	end)

rfr.set_interaction(DOOR_HALL_STAIR_FIRST, interaction_name["door_hall_stair_first"],
	function()
		local pposy = rfr.get_position(PLAYER).y
		return player_in_range("hallstair_1", 10) and pposy == 144
	end,
	function()
		rfr.fade_in(1)
		rfr.set_cam_target(PLAYER, 16, 0)
		move_player_to_destination("hallstair_1")
	end)
rfr.set_interaction(DOOR_HALL_STAIR_SECOND, interaction_name["door_hall_stair_second"],
	function()
		local pposy = rfr.get_position(PLAYER).y
		return player_in_range("hallstair_2", 10) and pposy == 96
	end,
	function()
		rfr.fade_in(1)
		move_player_to_destination("hallstair_2")
	end)

rfr.set_interaction(METAL_GATE_OUTSIDE, interaction_name["metal_gate"],
	function()
		return player_in_range("gate_out", 15)
	end,
	function()
		if rfr.get_flag("metal_gate_first_time") then rfr.set_dialogue(PLAYER, {content = interaction_details["metal_gate_first_time"]})
		else
			map.prepare_hall()
			rfr.set_cam_zoom(3)
			rfr.set_cam_target(PLAYER, 16, -16)
			rfr.fade_in(3)
			move_player_to_destination("gate_out", true)
		end
	end)
rfr.set_interaction(METAL_GATE_INSIDE, interaction_name["metal_gate"],
	function()
		local pposy = rfr.get_position(PLAYER).y
		return player_in_range("gate_in", 15) and pposy == 144
	end,
	function()
		map.prepare_outside()
		rfr.set_cam_zoom(2)
		rfr.fade_in(3)
		rfr.set_cam_target(PLAYER, 16, -43)
		move_player_to_destination("gate_in", true)
	end)
