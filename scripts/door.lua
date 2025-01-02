local transition = require "transition"
local map = require "map"
local util = require "utilities"

local door = {}
local room_to_bathroom = rfr.add_entity()
rfr.set_position(room_to_bathroom, 256, 100)
rfr.set_location(room_to_bathroom, "Map.Mainroom")
rfr.set_interaction(room_to_bathroom, "Nhà tắm",
	function()
		local px,_ = util.player_center()
		return px >= 248 and px <= 264
	end,
	function()
		rfr.set_cam_position(256,256)
		rfr.set_location(PLAYER, "Map.Bathroom")
		rfr.set_position(PLAYER, 240, 240)
		transition.fade_in(1)
		print("hhaha")
	end)

local bathroom_to_room = rfr.add_entity()
rfr.set_position(bathroom_to_room, 256, 230)
rfr.set_location(bathroom_to_room, "Map.Bathroom")
rfr.set_interaction(bathroom_to_room, "Phòng ngủ",
	function()
		local px,_ = util.player_center()
		return px >= 248 and px <= 264
	end,
	function()
		rfr.set_cam_position(256,128)
		rfr.set_location(PLAYER, "Map.Mainroom")
		rfr.set_position(PLAYER, 240, 112)
		transition.fade_in(1)
		print("hhaha")
		print("hhaha")
	end)

local room_to_hall = rfr.add_entity()
rfr.set_position(room_to_hall, 305, 100)
rfr.set_location(room_to_hall, "Map.Mainroom")
rfr.set_interaction(room_to_hall, "Hành lang",
	function()
		local px,_ = util.player_center()
		return px >= 300 and px <= 320
	end,
	function()
		map.current = "hall"
		rfr.set_location(PLAYER, "Map.Hall")
		rfr.set_position(PLAYER, 32,64)
		transition.fade_in(1)
	end)

local hall_to_room = rfr.add_entity()
rfr.set_position(hall_to_room, 48, 48)
rfr.set_location(hall_to_room, "Map.Hall")
rfr.set_interaction(hall_to_room, "Hành lang",
	function()
		local px,_ = util.player_center()
		return px >= 40 and px <= 60
	end,
	function()
		map.current = "room"
		rfr.set_location(PLAYER, "Map.Mainroom")
		rfr.set_position(PLAYER, 300,112)
	end)

local hall_stair_second
local hall_stair_first
local locked_doors

return door
