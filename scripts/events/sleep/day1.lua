local util = require "luamodules.utilities"
local dialogues =util.load_json(rfr.gamepath() .. "data/dialogues/events/sleep_1_" .. config.language .. ".json")
local bed = require "activities.sleep"
local timer = rfr.add_entity()

local water_track = 0
local check_bathroom = false
local water_drip = rfr.add_cutscene({
	init = function()
		rfr.set_flag("screen_fill")
		rfr.set_properties(GAME, "screen_fill_color", {0,0,0,255})
	end,
	exit = function()
	end,
	scripts = {
		function(dt)
			if rfr.is_transition_active() then return false end
			water_track = beaver.play_sound("running_water")
			rfr.set_timer(timer, 2)
			return true
		end,
		function(dt)
			if rfr.get_timer(timer).running then return false end
			rfr.unset_flag("screen_fill")
			rfr.fade_in(1)
			return true
		end,
		function(dt)
			if rfr.is_transition_active() then return false end
			bed.wake_up()
			rfr.set_dialogue(PLAYER, {content = dialogues["confused"]})
			return true
		end,
		function(dt)
			if rfr.get_location(PLAYER) == "Map.Bathroom" then
				beaver.halt_channel(water_track)
				check_bathroom = true
				return true
			end
			if rfr.get_flag("sleeping") then return true end
			return false
		end,
		function(dt)
			if check_bathroom then
				if rfr.get_location(PLAYER) == "Map.Mainroom" then
					rfr.set_dialogue(PLAYER, {content = "..."})
					return true
				end
				return false
			else return true end
		end
	},
	update = function(dt) end
})

local sleep_day1 = rfr.add_event(
	function()
		local d, tod = rfr.current_time()
		return d == 1 and tod == 2 and rfr.get_flag("sleeping")
	end)

rfr.set_event_listener(GAME, sleep_day1,
	function()
		rfr.set_flag("premature_wakeup")
		rfr.play_cutscene(water_drip)
		rfr.unset_event_listener(GAME, sleep_day1)
	end)
