local util = require "luamodules.utilities"
local dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/events/sleep_" .. config.language .. ".json")["day4"]
local bed = require "activities.sleep"
local ghost = require "ghost"
local timer = rfr.add_entity()
local lighting = require "lighting"

local shadow = rfr.add_entity()
rfr.set_image(shadow, "tileset")
rfr.set_image_source(shadow, 320,304,16,32)
rfr.set_location(shadow, "Map.Mainroom")
rfr.set_rotation(shadow, -30)

local ghost_chase = rfr.add_cutscene({
	init = function()
		rfr.set_state(ghost.eid, "crawling")
	end,
	exit = function()
	end,
	scripts = {
		function(dt)
			if rfr.get_tileanimation(ghost.eid).playing then return false end
			rfr.set_state(ghost.eid, "idle")
			rfr.set_image(ghost.eid, "ghost")
			rfr.set_position(ghost.eid, 64, 104)
			ghost.chasing = true
			return true
		end,
		function(dt)
			return false
		end,
	},
	update = function(dt)
		if ghost.chasing then
			local px,py = util.player_center()
			ghost.set_target(px, py)
		end
	end
})
local shadow_move_in = false
local shadow_speed = 0
local door_squeak_wakeup = rfr.add_cutscene({
	init = function()
		rfr.set_flag("danger")
		rfr.set_position(shadow, 320,112)
		rfr.set_flag("screen_fill")
		rfr.set_properties(GAME, "screen_fill_color", {0,0,0,255})
		rfr.set_timer(timer, 4)
		bed.wake_up()
		rfr.unset_flag("player_can_move")
		beaver.play_sound("doorsqueak")
	end,
	exit = function()
	end,
	scripts = {
		function(dt)
			if rfr.get_timer(timer).running then return false end
			rfr.set_flag("player_can_move")
			rfr.unset_flag("screen_fill")
			rfr.set_dialogue(PLAYER, {content = dialogues["wakeup"],
									cpf = 80, color = {120,120,120,255}})
			beaver.play_sound("ambience_night_2", -1, -1)
			return true
		end,
		function(dt)
			if shadow_move_in and rfr.get_position(ghost.eid).x <= 320 then
				lighting.set_flicker("room_ceiling", 0.3)
				rfr.set_timer(GAME, 1)
				return true
			else
				return false
			end
		end,
		function(dt)
			if rfr.get_timer(GAME).running then return false end
			if lighting.light_flickering("room_ceiling") then
				lighting.set_flicker("room_ceiling", 0)
				lighting.set_light_on("room_ceiling", false)
				rfr.get_timer(GAME, 1)
				rfr.set_flag("screen_fill")
				return true
			else
				return false
			end
		end,
		function(dt)
			if rfr.get_timer(GAME).running then return false end
			rfr.unset_flag("screen_fill")
			rfr.fade_in(2)
			return true
		end,
		function(dt)
			if lighting.light_is_on("room_ceiling") then
				rfr.set_state(ghost.eid, "hanging")
				beaver.fade_in_channel("thrillsuspend", -1, -1, 2000)
				return true
			else
				return false
			end
		end,
		function(dt)
			if rfr.get_position(PLAYER).x >= 110 then return false end
			rfr.play_cutscene(ghost_chase)
			return true
		end,
	},
	update = function(dt)
		if not shadow_move_in then
			if rfr.get_position(PLAYER).x >= 250 then
				shadow_move_in = true
				shadow_speed = -100
				beaver.play_sound("stinger_piano02")
			end
		else
			local sposx = rfr.get_position(shadow).x
			if sposx <= 308 then shadow_speed = 100 end
			sposx = sposx + shadow_speed * dt
			if shadow_speed > 0 and sposx >= 320 then sposx = 320 end
			rfr.set_position(shadow, sposx, 112)
		end
	end
})


local sleep_day4 = rfr.add_event(
	function()
		local d, tod = rfr.current_time()
		return d == 4 and tod == 2 and rfr.get_flag("sleeping")
	end)

rfr.set_event_listener(GAME, sleep_day4,
	function()
		rfr.set_flag("premature_wakeup")
		rfr.play_cutscene(door_squeak_wakeup)
		rfr.unset_event_listener(GAME, sleep_day4)
	end)

