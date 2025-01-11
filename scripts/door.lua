local util = require "luamodules.utilities"
local door = {}
local room_to_bathroom
local bathroom_to_room
local room_to_hall
local hall_to_room
local hall_stair_second
local hall_stair_first
local locked_doors

function door.load()
	local interaction_name = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
	room_to_bathroom = rfr.add_entity()
	rfr.set_position(room_to_bathroom, 256, 100)
	rfr.set_location(room_to_bathroom, "Map.Mainroom")
	rfr.set_interaction(room_to_bathroom, interaction_name["door_room_to_bathroom"],
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

	bathroom_to_room = rfr.add_entity()
	rfr.set_position(bathroom_to_room, 256, 230)
	rfr.set_location(bathroom_to_room, "Map.Bathroom")
	rfr.set_interaction(bathroom_to_room, interaction_name["door_bathroom_to_room"],
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

	room_to_hall = rfr.add_entity()
	rfr.set_position(room_to_hall, 305, 100)
	rfr.set_location(room_to_hall, "Map.Mainroom")
	rfr.set_interaction(room_to_hall, interaction_name["door_room_to_hall"],
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

	hall_to_room = rfr.add_entity()
	rfr.set_position(hall_to_room, 432, 70)
	rfr.set_location(hall_to_room, "Map.Hall")
	rfr.set_interaction(hall_to_room, interaction_name["door_hall_to_room"],
		function()
			local px,_ = util.player_center()
			return px >= 420 and px <= 440 and not rfr.get_flag("prologue_hall")
		end,
		function()
			rfr.set_cam_center(316, 112)
			rfr.set_current_map("room")
			rfr.set_location(PLAYER, "Map.Mainroom")
			rfr.set_position(PLAYER, 290,112)
			rfr.fade_in(1)
		end)

	hall_stair_first = rfr.add_entity()
	rfr.set_position(hall_stair_first, 780, 124)
	rfr.set_location(hall_stair_first, "Map.Hall")
	rfr.set_interaction(hall_stair_first, interaction_name["door_hall_stair_first"],
		function()
			local px,_ = util.player_center()
			return px >= 760 and px <= 780
		end,
		function()
			rfr.set_position(PLAYER, 770, 80)
		end)
end
return door
