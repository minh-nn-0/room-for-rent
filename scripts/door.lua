local util = require "luamodules.utilities"
local interaction_name = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")
local map = require "luamodules.map"
DOOR_ROOM_TO_BATHROOM = rfr.add_entity()
DOOR_ROOM_TO_HALL = rfr.add_entity()
DOOR_ROOM_TO_BALCONY = rfr.add_entity()
DOOR_BATHROOM_TO_ROOM = rfr.add_entity()
DOOR_BALCONY_TO_ROOM = rfr.add_entity()
DOOR_HALL_TO_ROOM = rfr.add_entity()
DOOR_HALL_STAIR_FIRST = rfr.add_entity()
DOOR_HALL_STAIR_SECOND = rfr.add_entity()
METAL_GATE_OUTSIDE = rfr.add_entity()
METAL_GATE_INSIDE = rfr.add_entity()
local locked_doors

rfr.set_position(DOOR_ROOM_TO_BATHROOM, 256, 100)
rfr.set_location(DOOR_ROOM_TO_BATHROOM, "Map.Mainroom")
rfr.set_interaction(DOOR_ROOM_TO_BATHROOM, interaction_name["door_room_to_bathroom"],
	function()
		local px,_ = util.player_center()
		return px >= 248 and px <= 264
	end,
	function()
		beaver.play_sound("dooropen")
		rfr.set_cam_center(256, 240)
		rfr.set_location(PLAYER, "Map.Bathroom")
		rfr.set_position(PLAYER, 240, 240)
		rfr.fade_in(2)
	end)

rfr.set_position(DOOR_BATHROOM_TO_ROOM, 256, 230)
rfr.set_location(DOOR_BATHROOM_TO_ROOM, "Map.Bathroom")
rfr.set_interaction(DOOR_BATHROOM_TO_ROOM, interaction_name["door_bathroom_to_room"],
	function()
		local px,_ = util.player_center()
		return px >= 248 and px <= 264
	end,
	function()
		beaver.play_sound("dooropen")
		rfr.set_cam_center(256, 112)
		rfr.set_location(PLAYER, "Map.Mainroom")
		rfr.set_position(PLAYER, 240, 112)
		rfr.fade_in(2)
	end)

rfr.set_position(DOOR_ROOM_TO_HALL, 305, 100)
rfr.set_location(DOOR_ROOM_TO_HALL, "Map.Mainroom")
rfr.set_interaction(DOOR_ROOM_TO_HALL, interaction_name["door_room_to_hall"],
	function()
		local px,_ = util.player_center()
		return px >= 305 and px <= 320
	end,
	function()
		if rfr.get_flag("prologue_room") then rfr.set_dialogue(PLAYER, {content = interaction_details["door_room_to_hall_not_clean"]})
		else
			beaver.play_sound("dooropen2")
			rfr.set_cam_zoom(3)
			rfr.set_cam_center(432, 96)
			map.set_current_map("outside")
			rfr.set_location(PLAYER, "Map.Hall")
			rfr.set_position(PLAYER, 416,80)
			rfr.fade_in(2)
		end
	end)
rfr.set_position(DOOR_ROOM_TO_BALCONY, 80,100)
rfr.set_location(DOOR_ROOM_TO_BALCONY, "Map.Mainroom")
rfr.set_interaction(DOOR_ROOM_TO_BALCONY, interaction_name["door_room_to_balcony"],
	function()
		local px,_ = util.player_center()
		return px >= 65 and px <= 80
	end,
	function()
		rfr.set_cam_zoom(3)
		map.set_current_map("balcony")
		rfr.set_location(PLAYER, "Map.Balcony")
		rfr.set_position(PLAYER, 128, 96)
		rfr.fade_in(1)
	end)

rfr.set_position(DOOR_BALCONY_TO_ROOM, 144,84)
rfr.set_location(DOOR_BALCONY_TO_ROOM, "Map.Balcony")
rfr.set_interaction(DOOR_BALCONY_TO_ROOM, interaction_name["door_balcony_to_room"],
	function()
		local px,_ = util.player_center()
		return px >= 130 and px <= 155
	end,
	function()
		rfr.set_cam_zoom(config.cam_zoom)
		rfr.set_cam_center(80, 128)
		map.set_current_map("room")
		rfr.set_location(PLAYER, "Map.Mainroom")
		rfr.set_position(PLAYER, 64,112)
		rfr.fade_in(1)
	end)

rfr.set_position(DOOR_HALL_TO_ROOM, 432, 70)
rfr.set_location(DOOR_HALL_TO_ROOM, "Map.Hall")
rfr.set_interaction(DOOR_HALL_TO_ROOM, interaction_name["door_hall_to_room"],
	function()
		local px,_ = util.player_center()
		return px >= 420 and px <= 440
	end,
	function()
		beaver.play_sound("dooropen2")
		rfr.set_cam_zoom(config.cam_zoom)
		rfr.set_cam_center(316, 112)
		map.set_current_map("room")
		rfr.set_location(PLAYER, "Map.Mainroom")
		rfr.set_position(PLAYER, 290,112)
		rfr.fade_in(2)
	end)

rfr.set_position(DOOR_HALL_STAIR_FIRST, 654, 134)
rfr.set_location(DOOR_HALL_STAIR_FIRST, "Map.Hall")
rfr.set_interaction(DOOR_HALL_STAIR_FIRST, interaction_name["door_hall_stair_first"],
	function()
		local px, py = util.player_center()
		return px >= 640 and px <= 660 and py == 160
	end,
	function()
		rfr.set_position(PLAYER, 654, 96)
	end)
rfr.set_position(DOOR_HALL_STAIR_SECOND, 654, 80)
rfr.set_location(DOOR_HALL_STAIR_SECOND, "Map.Hall")
rfr.set_interaction(DOOR_HALL_STAIR_SECOND, interaction_name["door_hall_stair_second"],
	function()
		local px, py = util.player_center()
		return px >= 640 and px <= 660 and py == 109
	end,
	function()
		rfr.set_position(PLAYER, 654, 144)
	end)

rfr.set_position(METAL_GATE_OUTSIDE, 424, 134)
rfr.set_location(METAL_GATE_OUTSIDE, "Map.Outside")
rfr.set_interaction(METAL_GATE_OUTSIDE, interaction_name["metal_gate"],
	function()
		local px,_ = util.player_center()
		return px >= 403 and px <= 446
	end,
	function()
		if rfr.get_flag("metal_gate_first_time") then rfr.set_dialogue(PLAYER, {content = interaction_details["metal_gate_first_time"]})
		else
			rfr.set_location(PLAYER, "Map.Hall")
			rfr.set_layer_visible("outside", "Map.Outside.Bg.house_wall", false)
			rfr.set_cam_zoom(3)
			rfr.set_position(PLAYER, 408,144)
			rfr.set_cam_target(PLAYER, 16, -5)
			rfr.fade_in(2)
		end
	end)
rfr.set_position(METAL_GATE_INSIDE, 424, 134)
rfr.set_location(METAL_GATE_INSIDE, "Map.Hall")
rfr.set_interaction(METAL_GATE_INSIDE, interaction_name["metal_gate"],
	function()
		local px, py = util.player_center()
		return px >= 403 and px <= 446 and py == 160
	end,
	function()
		rfr.set_location(PLAYER, "Map.Outside")
			rfr.set_layer_visible("outside", "Map.Outside.Bg.house_wall", true)
		rfr.set_cam_zoom(2)
		rfr.set_position(PLAYER, 408,144)
		rfr.set_cam_target(PLAYER, 16, -30)
		rfr.fade_in(2)
	end)
