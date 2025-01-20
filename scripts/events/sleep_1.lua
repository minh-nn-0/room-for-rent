local util = require "luamodules.utilities"
local dialogues =util.load_json(rfr.gamepath() .. "data/dialogues/events/sleep_1_" .. config.language .. ".json")
local bed = require "activities.sleep"
local timer = rfr.add_entity()
local doorknock_track

local inbed = true
local count = 1
local shadow = rfr.add_entity()
local shadow_appeared = false
local shadow_timer = 0
local cs_sleep_1 = rfr.add_cutscene({
	init = function()
		rfr.set_flag("screen_fill")
		rfr.set_properties(GAME, "screen_fill_color", {0,0,0,255})
	end,
	exit = function()
	end,
	scripts = {
		function(dt)
			if rfr.is_transition_active() then return false end
			doorknock_track = beaver.play_sound("doorknock")
			rfr.set_flag("premature_wakeup")
			rfr.set_timer(timer,2)
			return true
		end,
		function(dt)
			if rfr.get_timer(timer).running then return false end
			bed.go_to_sleep_normally()
			rfr.unset_flag("screen_fill")
			rfr.set_dialogue_position(BED, 0, 16)
			rfr.set_dialogue(BED, {content = count == 1 and "DM THANG NAO GO CUA DAY" or "SAO NUA???"})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(BED) then return false end
			if count == 2 and rfr.get_last_interaction() == DOOR_ROOM_TO_HALL then
				print(rfr.get_cam_zoom())
				shadow_appeared = true
				rfr.set_position(shadow, 400, 80)
				rfr.set_location(shadow, "Map.Hall")
				rfr.set_image(shadow, "tileset")
				rfr.set_image_source(shadow, 320,304,16,32)
				return true
			end
			return false
		end,
		function(dt)
			if rfr.get_last_interaction() == DOOR_HALL_TO_ROOM then
				rfr.set_dialogue(PLAYER, {content = "LA THAT, chang le mo ngu ?"})
				return true
			end
			return false
		end
	},
	update = function(dt)
		if inbed then bed.animate_bed_sleep() end
		if shadow_appeared then
			shadow_timer = shadow_timer + dt * 0.6
			rfr.set_tint(shadow, 255,255,255, math.floor(255 * math.max(1 - shadow_timer,0)))
			if shadow_timer >= 1 then shadow_appeared = false end
		end
	end
})

local player_sleep_1 = rfr.add_event(
	function()
		local d, tod = rfr.current_time()
		return d == 1 and tod == 2 and rfr.get_flag("sleeping")
	end)

rfr.set_event_listener(GAME, player_sleep_1,
	function()
		if count <= 2 then
			count = count + 1
			rfr.set_flag("premature_wakeup")
			rfr.play_cutscene(cs_sleep_1)
		else
			rfr.unset_event_listener(GAME, player_sleep_1)
		end
	end)
