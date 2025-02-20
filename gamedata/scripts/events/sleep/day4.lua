local util = require "luamodules.utilities"
local dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/events/sleep_" .. config.language .. ".json")["day4"]
local bed = require "activities.sleep"
local ghost = require "ghost"
local timer = rfr.add_entity()
local lighting = require "lighting"

local shadow = rfr.add_entity()
rfr.set_image(shadow, ASSETS.images.tileset)
rfr.set_image_source(shadow, 320,304,16,32)
rfr.set_location(shadow, "Map.Mainroom")
rfr.set_rotation(shadow, -30)

local ghost_chase = rfr.add_cutscene({
	init = function()
	end,
	exit = function()
	end,
	scripts = {
		function(dt)
			if rfr.get_location(PLAYER) ~= "Map.Mainroom" then return false end
			rfr.set_timer(timer, 3)
			return true
		end,
		function(dt)
			if rfr.get_timer(timer).running then return false end
			lighting.set_flicker("room_ceiling", 0.3)
			rfr.set_timer(timer, 2)
			return true
		end,
		function(dt)
			if rfr.get_timer(timer).running then return false end
			if lighting.light_flickering("room_ceiling") then
				lighting.set_flicker("room_ceiling", 0)
				lighting.set_light_on("room_ceiling", false)
				rfr.set_timer(timer, 1)
				rfr.set_flag("screen_fill")
				return true
			else
				return false
			end
		end,
		function(dt)
			if rfr.get_timer(timer).running then return false end
			rfr.unset_flag("screen_fill")
			rfr.fade_in(2)
			return true
		end,
		function(dt)
			if not lighting.light_is_on("room_ceiling") then return false end
			rfr.set_state(ghost.eid, "hanging")
			beaver.fade_in_channel("thrillsuspend", -1, -1, 200)
			rfr.unset_flag("player_can_move")
			rfr.unset_flag("player_can_interact")
			rfr.set_dialogue(PLAYER, {content = "VCC"})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_flag("player_can_move")
			rfr.set_flag("player_can_interact")
			rfr.set_state(ghost.eid, "crawling")
			return true
		end,
		function(dt)
			if rfr.get_tileanimation(ghost.eid).playing then return false end
			rfr.set_state(ghost.eid, "idle")
			rfr.set_image(ghost.eid, ASSETS.images.ghost)
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



local hands_wall = {
	{15,6,436},
	{14,6,436 | beaver.TILED_FLIP_H | beaver.TILED_FLIP_V},
	{12,6, 435 | beaver.TILED_FLIP_H | beaver.TILED_FLIP_V},
	{10,6, 436},
	{8,6, 435},
	{7,6, 473},
	{6,6, 437 | beaver.TILED_FLIP_V},
	{5,6, 436},
	{4,7, 435 | beaver.TILED_FLIP_H | beaver.TILED_FLIP_V},
}

local hands_wall_timer = 0
local period = 0.3
local hand_index = 1
local function hands_wall_update(dt)
	if hand_index > #hands_wall then return false end
	hands_wall_timer = hands_wall_timer + dt
	if hands_wall_timer >= period then
		local tx,ty,tile = table.unpack(hands_wall[hand_index])
		rfr.set_tile(MAPS.room, "Map.Mainroom.Bg.hands", tx,ty,tile)
		beaver.play_sound(ASSETS.audios.footstep_mud_run_04)
		hand_index = hand_index + 1
		hands_wall_timer = 0
	end
end
local blood_drip = require "events.sleep.blood_dripping_bathroom"
local hands_on_door = require "events.sleep.hands_bathroom_door"

local out_of_bathroom = rfr.add_cutscene({
	init = function()
	end,
	exit = function()
		rfr.play_cutscene(ghost_chase)
	end,
	scripts = {
		function(dt)
			if rfr.get_location(PLAYER) ~= "Map.Mainroom" or rfr.get_position(PLAYER).x >= 225 then return false end
			return true
		end,
		function(dt)
			hands_wall_update(dt)
			if hand_index <= #hands_wall then return false end
			return true
		end,
		function(dt)
			if rfr.get_location(PLAYER) ~= "Map.Balcony" then return false end
			return true
		end
	},
	update = function(dt)
	end
})
local bathroom = rfr.add_cutscene({
	init = function()
		lighting.set_light_on("bathroom_ceiling", false)
		lighting.set_tint("bathroom_ceiling", {150,50,30,255})
		rfr.set_properties(DOOR_BATHROOM_ROOM, "locked", true)
	end,
	exit = function()
		rfr.play_cutscene(out_of_bathroom)
	end,
	scripts = {
		function(dt)
			if not lighting.light_is_on("bathroom_ceiling") then return false end
			beaver.play_sound(ASSETS.audios.stinger_piano12)
			return true
		end,
		function(dt)
			if not (rfr.get_last_interaction() == DOOR_BATHROOM_ROOM) then return false end
			rfr.set_timer(timer, 3)
			return true
		end,
		function(dt)
			if rfr.get_timer(timer).running then return false end
			hands_on_door.begin()
			rfr.set_tile(MAPS.room, "Map.Mainroom.Bg.Items.2", 15, 6, 434)
			rfr.set_tile(MAPS.room, "Map.Mainroom.Bg.Items.2", 16, 6, 435)
			rfr.set_tile(MAPS.room, "Map.Mainroom.Bg.Items.2", 15, 7, 472)
			rfr.set_tile(MAPS.room, "Map.Mainroom.Bg.Items.2", 16, 7, 473)
			return true
		end,
		function(dt)
			if not hands_on_door.ended() then return false end
			rfr.set_properties(DOOR_BATHROOM_ROOM, "locked", false)
			return true
		end,
		function(dt)
			if rfr.get_location(PLAYER) ~= "Map.Mainroom" then return false end
			return true
		end
	},
	update = function(dt)
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
		beaver.play_sound(ASSETS.audios.doorsqueak)
	end,
	exit = function()
		print("hoihi")
	end,
	scripts = {
		function(dt)
			if rfr.get_timer(timer).running then return false end
			rfr.set_flag("player_can_move")
			rfr.unset_flag("screen_fill")
			rfr.set_dialogue(PLAYER, {content = dialogues["wakeup"],
									cpf = 80, color = {120,120,120,255}})
			beaver.play_sound(ASSETS.audios.ambience_night_2, -1, -1)
			return true
		end,
		function(dt)
			if not shadow_move_in then return false end
			blood_drip.init()
			return true
		end,
		function(dt)
			if rfr.get_location(PLAYER) ~= "Map.Bathroom" then return false end
			rfr.play_cutscene(bathroom)
			return true
		end
	},
	update = function(dt)
		if not shadow_move_in then
			if rfr.get_position(PLAYER).x >= 240 then
				shadow_move_in = true
				shadow_speed = -90
				beaver.play_sound(ASSETS.audios.stinger_piano02)
			end
		else
			local sposx = rfr.get_position(shadow).x
			if sposx <= 300 then shadow_speed = 90 end
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

