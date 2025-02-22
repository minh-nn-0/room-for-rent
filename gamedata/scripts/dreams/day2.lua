local camera = require "luamodules.camera"
local map = require "luamodules.map"
local scatter_paper = require "dreams.scatter_paper"
local girl_at_table = require "dreams.girl_at_table"
local lighting = require "lighting"
local zoom_speed = 1
local target_zoom = 7
local red_change_rate = 30
local bg_color = {0,0,20,255}
local wake_up_timer = rfr.add_entity()
local dream_day2 = rfr.add_cutscene({
	init = function()
		rfr.set_flag("dreaming")
		rfr.set_flag("screen_fill")
		rfr.set_properties(GAME, "screen_fill_color", {0,0,0,255})
		map.set_current_map("room_dream")
		rfr.set_cam_zoom(3)
		rfr.set_location(PLAYER, "Map.Dream")
		camera.set_target(girl_at_table, 16, 5)

		lighting.toggle_light("room_dream_ceiling")

		rfr.set_flag("scatter_paper")
	end,
	exit = function()
		rfr.unset_flag("dreaming")
		camera.set_target(BED, 0, 12)
		map.set_current_map("room")
		rfr.set_location(PLAYER, "Map.Mainroom")
		rfr.set_cam_zoom(config.cam_zoom)
	end,
	scripts = {
		function(dt)
			if rfr.get_flag("sleeping") then return false end
			rfr.unset_flag("screen_fill")
			rfr.fade_in(2)
			return true
		end,
		function(dt)
			if bg_color[1] < 255 then return false end
			rfr.set_flag("screen_fill")
			rfr.set_timer(wake_up_timer, 3)
			return true
		end,
		function(dt)
			if rfr.get_timer(wake_up_timer).running then return false end
			rfr.fade_in(2)
			rfr.unset_flag("screen_fill")
			return true
		end
	},
	update = function(dt)
		print(rfr.get_cam_zoom())
		rfr.set_cam_zoom(rfr.get_cam_zoom() + zoom_speed * dt)
		if rfr.get_cam_zoom() > target_zoom then
			bg_color[1] = bg_color[1] + red_change_rate * dt
			lighting.set_background_color(math.floor(bg_color[1]),math.floor(bg_color[2]),math.floor(bg_color[3]),math.floor(bg_color[4]))
		end
	end
})

return dream_day2
