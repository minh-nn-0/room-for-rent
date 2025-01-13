local util = require "luamodules.utilities"
local door = {}
DOOR_ROOM_TO_BATHROOM = rfr.add_entity()
DOOR_BATHROOM_TO_ROOM = rfr.add_entity()
DOOR_ROOM_TO_HALL = rfr.add_entity()
DOOR_HALL_TO_ROOM = rfr.add_entity()
DOOR_HALL_STAIR_FIRST = rfr.add_entity()
DOOR_HALL_STAIR_SECOND = rfr.add_entity()
METAL_GATE = rfr.add_entity()
local locked_doors

function door.load()
	local interaction_name = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
	local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")
	rfr.set_position(DOOR_ROOM_TO_BATHROOM, 256, 100)
	rfr.set_location(DOOR_ROOM_TO_BATHROOM, "Map.Mainroom")
	rfr.set_interaction(DOOR_ROOM_TO_BATHROOM, interaction_name["door_room_to_bathroom"],
		function()
			local px,_ = util.player_center()
			return px >= 248 and px <= 264
		end,
		function()
			rfr.set_cam_center(256, 240)
			rfr.set_location(PLAYER, "Map.Bathroom")
			rfr.set_position(PLAYER, 240, 240)
			rfr.fade_in(1)
		end)

	rfr.set_position(DOOR_BATHROOM_TO_ROOM, 256, 230)
	rfr.set_location(DOOR_BATHROOM_TO_ROOM, "Map.Bathroom")
	rfr.set_interaction(DOOR_BATHROOM_TO_ROOM, interaction_name["door_bathroom_to_room"],
		function()
			local px,_ = util.player_center()
			return px >= 248 and px <= 264
		end,
		function()
			rfr.set_cam_center(256, 112)
			rfr.set_location(PLAYER, "Map.Mainroom")
			rfr.set_position(PLAYER, 240, 112)
			rfr.fade_in(1)
		end)

	rfr.set_position(DOOR_ROOM_TO_HALL, 305, 100)
	rfr.set_location(DOOR_ROOM_TO_HALL, "Map.Mainroom")
	rfr.set_interaction(DOOR_ROOM_TO_HALL, interaction_name["door_room_to_hall"],
		function()
			local px,_ = util.player_center()
			return px >= 300 and px <= 320 and not rfr.get_flag("prologue_room")
		end,
		function()
			rfr.set_cam_center(432, 96)
			rfr.set_current_map("hall")
			rfr.set_location(PLAYER, "Map.Hall")
			rfr.set_position(PLAYER, 416,80)
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
			rfr.set_cam_center(316, 112)
			rfr.set_current_map("room")
			rfr.set_location(PLAYER, "Map.Mainroom")
			rfr.set_position(PLAYER, 290,112)
			rfr.fade_in(1)
		end)

	rfr.set_position(DOOR_HALL_STAIR_FIRST, 780, 124)
	rfr.set_location(DOOR_HALL_STAIR_FIRST, "Map.Hall")
	rfr.set_interaction(DOOR_HALL_STAIR_FIRST, interaction_name["door_hall_stair_first"],
		function()
			local px,_ = util.player_center()
			return px >= 770 and px <= 790
		end,
		function()
			rfr.set_position(PLAYER, 770, 80)
		end)
	rfr.set_position(METAL_GATE, 533, 124)
	rfr.set_location(METAL_GATE, "Map.Outside")
	rfr.set_interaction(METAL_GATE, interaction_name["metal_gate"],
		function()
			local px, py = util.player_center()
			return px >= 510 and px <= 556
		end,
		function()
			if rfr.get_flag("metal_gate_first_time") then rfr.set_dialogue(PLAYER, interaction_details["metal_gate_first_time"])
			else
				rfr.set_current_map("hall")
				rfr.set_location(PLAYER, "Map.Hall")
				rfr.set_cam_zoom(3)
				rfr.set_position(PLAYER, 530,144)
				rfr.fade_in(1)
			end
		end)
	end
return door
