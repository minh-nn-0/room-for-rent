local util = require "luamodules.utilities"
local dialogues =util.load_json(rfr.gamepath() .. "data/dialogues/events/sleep_2_" .. config.language .. ".json")
local bed = require "activities.sleep"
local timer = rfr.add_entity()
local doorknock_track

local count = 0
local shadow = rfr.add_entity()
local shadow_appeared = false
local shadow_timer = 0
local cs_sleep_1 = rfr.add_cutscene({
	init = function()
		rfr.set_flag("screen_fill")
		rfr.set_properties(GAME, "screen_fill_color", {0,0,0,255})
	end,
	exit = function()
		if count == 2 then rfr.set_active(shadow, false) end
	end,
	scripts = {
		function(dt)
			if rfr.is_transition_active() then return false end
			doorknock_track = beaver.play_sound(ASSETS.audios.doorknock_panright)
			rfr.set_timer(timer,2)
			return true
		end,
		function(dt)
			if rfr.get_timer(timer).running then return false end
			rfr.unset_flag("screen_fill")
			rfr.set_dialogue_position(BED, 0, 16)
			rfr.set_dialogue(BED, {content = count == 1 and dialogues["complain1"] or dialogues["complain2"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(BED) then return false end
			if count == 2 then
				if rfr.get_last_interaction() == DOOR_ROOM_HALL then
					print("hihihi")
					shadow_appeared = true
					rfr.set_position(shadow, 420, 96)
					rfr.set_location(shadow, "Map.Hall")
					rfr.set_image(shadow, ASSETS.images.tileset)
					rfr.set_image_source(shadow, 320,304,32,32)
					return true
				else
					return false
				end
			else
				return true
			end
		end,
		function(dt)
			if count == 2 then
				if rfr.get_last_interaction() == DOOR_HALL_ROOM then
					rfr.set_dialogue(PLAYER, {content = dialogues["confused"]})
					return true
				else return false
				end
			else
				return true
			end
		end
	},
	update = function(dt)
		if shadow_appeared then
			shadow_timer = shadow_timer + dt
			if shadow_timer > 1 then
				rfr.set_tint(shadow, 255,255,255, math.floor(255 * math.max(1 - (shadow_timer - 1.4)/0.3,0)))
			end
			if shadow_timer >= 3 then shadow_appeared = false end
		end
	end
})

local player_sleep_1 = rfr.add_event(
	function()
		local d, tod = rfr.current_time()
		return d == 2 and tod == 2 and rfr.get_flag("sleeping")
	end)

rfr.set_event_listener(GAME, player_sleep_1,
	function()
		if count < 2 then
			count = count + 1
			rfr.set_flag("premature_wakeup")
			rfr.play_cutscene(cs_sleep_1)
		else
			rfr.unset_event_listener(GAME, player_sleep_1)
		end
	end)
