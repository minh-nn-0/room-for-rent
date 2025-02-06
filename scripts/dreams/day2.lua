local map = require "luamodules.map"
local scatter_paper = require "dreams.scatter_paper"
local girl_at_table = require "dreams.girl_at_table"
local lighting = require "lighting"
local zoom_speed = 0.5
DREAM_DAY2 = rfr.add_cutscene({
	init = function()
		rfr.set_flag("dreaming")
		rfr.set_flag("screen_fill")
		rfr.set_properties(GAME, "screen_fill_color", {0,0,0,255})
		map.set_current_map("room_dream")
		rfr.set_cam_zoom(3)
		rfr.set_location(PLAYER, "Map.Dream")
		rfr.set_position(girl_at_table, 168, 112)
		rfr.set_cam_target(girl_at_table, 16, 5)

		lighting.set_background_color(0,0,20,255)
		lighting.toggle_light("room_dream_ceiling")

		rfr.set_flag("scatter_paper")
	end,
	exit = function()
	end,
	scripts = {
		function(dt)
			if rfr.get_flag("sleeping") then return false end
			rfr.unset_flag("screen_fill")
			rfr.fade_in(2)
			return true
		end,
		function(dt)
			return false
		end
	},
	update = function(dt)
		print(rfr.get_cam_zoom())
		rfr.set_cam_zoom(rfr.get_cam_zoom() + zoom_speed * dt)
		if rfr.get_cam_zoom() > 7 then zoom_speed = 1 end
	end
})
