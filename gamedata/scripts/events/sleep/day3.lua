local bed = require "activities.sleep"
local util = require "luamodules.utilities"
local interaction = require "luamodules.interaction"
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local day3 = {}
local lighting = require "lighting"
local girl_at_table = require "dreams.girl_at_table"
local map = require "luamodules.map"
local items = require "events.sleep.room_dream_items"
local diary = require "misc.diary"
local candle = require "misc.candle"
local timer = rfr.add_entity()

local ghost = require "ghost"
local cgdms = require "events.sleep.cogidaumaso"
local cs_blow_candle = rfr.add_cutscene({
	init = function()
		beaver.play_sound(ASSETS.audios.blowcandle)
		candle.toggle()
		candle.put_down()
		rfr.set_flag("screen_fill")
		rfr.set_properties("screen_fill_color", {0,0,0,255})
		rfr.set_timer(timer, 2)
		rfr.set_location(PLAYER, "Map.Void")
		rfr.set_location(ghost.eid, "Map.Void")
		rfr.set_position(PLAYER, 300, 112)
		rfr.set_position(ghost.eid, -200, 104)
		rfr.set_state(ghost.eid, "idle")
		rfr.set_image(ghost.eid, ASSETS.images.ghost)
		ghost.chasing = true
	end,
	exit = function()
		rfr.unset_flag("screen_fill")
		rfr.set_flag("player_can_move")
		rfr.set_flag("player_can_open_phone")
		rfr.set_flag("draw_helper")
		rfr.set_location(PLAYER, "Map.Mainroom")
		map.set_current_map("room")
		rfr.fade_in(2)
		lighting.set_background_color(30,30,30,255)
		bed.go_to_sleep_normally()
	end,
	scripts = {
		function(dt)
			if rfr.get_timer(timer).running then return false end
			rfr.unset_flag("screen_fill")
			rfr.fade_in(1)
			return true
		end,
		function(dt)
			if rfr.is_transition_active() then return false end
			rfr.set_dialogue(PLAYER, {content = "khong co gi phai so"})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_timer(timer, 1)
			return true
		end,
		function(dt)
			if rfr.get_timer(timer).running then return false end
			rfr.set_flag("screen_fill")
			rfr.unset_flag("player_can_move")
			rfr.set_state(PLAYER, "idle")
			cgdms.init()
			return true
		end,
		function(dt)
			if cgdms.active then return false end
			rfr.unset_flag("screen_fill")
			rfr.set_position(PLAYER, 360, 112)
			rfr.set_position(ghost.eid, 200,104)
			ghost.set_target(500,112)
			rfr.unset_flag("draw_helper")
			rfr.set_properties(ghost.eid, "walkspeed", 2)
			lighting.set_tint("darkview", {160,160,160,255})
			lighting.set_scale("darkview", 0.7)
			return true
		end,
		function(dt)
			if rfr.get_position(ghost.eid).x <= 350 then return false end
			beaver.play_sound(ASSETS.audios.stinger_impact01)
			rfr.set_flag("screen_fill")
			rfr.set_timer(timer, 3)
			return true
		end,
		function(dt)
			if rfr.get_timer(timer).running then return false end
			return true
		end
	},
	update = function(dt)
	end
})

CGDMS_CS = cs_blow_candle

local howl_channel
local crack_sound_schedules = {
	{1, ASSETS.audios.crack3},
	{3, ASSETS.audios.crack2},
	{4, ASSETS.audios.crack4},
	{6, ASSETS.audios.crack3},
	{7, ASSETS.audios.crack5},
	{8, ASSETS.audios.crack2},
	{9, ASSETS.audios.crack4},
	{10, ASSETS.audios.crack3},
	{11, ASSETS.audios.crack4},
	{11.5, ASSETS.audios.crack5},
	{12, ASSETS.audios.crack2},
	{12.5, ASSETS.audios.crack3},
	{13, ASSETS.audios.crack4},
	{13.3, ASSETS.audios.crack3},
	{13.7, ASSETS.audios.crack5},
	{14, ASSETS.audios.crack2},
	{14.2, ASSETS.audios.crack3},
	{14.5,ASSETS.audios.crack4},
	{14.8,ASSETS.audios.crack3},
	{15, ASSETS.audios.crack5},
}
local index = 1
local cs_lights_out = rfr.add_cutscene({
	init = function()
		rfr.set_timer(timer, 3)
	end,
	exit = function()
		rfr.play_cutscene(cs_blow_candle)
	end,
	scripts = {
		function(dt)
			if rfr.get_timer(timer).running then return false end
			howl_channel = beaver.play_sound(ASSETS.audios.ghosthowling)
			items.can_interact = false
			return true
		end,
		function(dt)
			if beaver.channel_playing(howl_channel) then return false end
			rfr.set_stopwatch(timer)
			return true
		end,
		function(dt)
			local elapsed = rfr.get_stopwatch(timer)
			if index <= #crack_sound_schedules then
				print(index)
				local sound = crack_sound_schedules[index]
				if elapsed >= sound[1] then
					beaver.play_sound(sound[2])
					index = index + 1
				end
				return false
			end
			return true
		end
	},
	update = function(dt)
	end
})
local ev_player_read_whole_diary = rfr.add_event(
	function()
		return diary.read_last_page and not diary.opening
	end)

rfr.set_event_listener(GAME, ev_player_read_whole_diary,
	function()
		rfr.play_cutscene(cs_lights_out)
		rfr.unset_event_listener(GAME, ev_player_read_whole_diary)
	end)

local cs_room = rfr.add_cutscene({
	init = function()
		beaver.play_sound(ASSETS.audios.stinger_impact01)
		map.set_current_map("room_dream")
		rfr.set_location(PLAYER, "Map.Dream")
		lighting.set_background_color(0,0,10,255)
		lighting.set_tint("darkview", {40,40,40,180})
		lighting.set_light_on("room_dream_ceiling", true)
		lighting.set_tint("room_dream_ceiling", {180,120,100,200})
		lighting.set_scale("room_dream_ceiling", 1)
		rfr.set_location(candle.eid, "Map.Dream")
		rfr.set_timer(timer, 5)
	end,
	exit = function()
	end,
	scripts = {
		function(dt)
			if rfr.get_timer(timer).running then return false end
			lighting.set_light_on("room_dream_ceiling", false)
			rfr.set_position(girl_at_table, 500,500)
			rfr.fade_in(2)
			candle.can_be_pickup = true
			items.can_interact = true
			return true
		end,
		function(dt)
			if not candle.picked_up() then return false end
			candle.can_be_pickup = false
			return true
		end,
	},
	update = function(dt) end
})
local light_switch = rfr.add_entity()
rfr.set_image(light_switch, ASSETS.images.tileset)
rfr.set_image_source(light_switch, 64, 368, 16, 16)
rfr.set_zindex(light_switch, 0)
rfr.set_position(light_switch, 128,112)
rfr.set_location(light_switch, "Map.Void")
interaction.add({136, 112},
	function()
		local px, _ = util.player_center()
		return px >= 130 and px <= 140 and rfr.get_location(PLAYER) == "Map.Void"
	end,
	function()
		rfr.play_cutscene(cs_room)
	end)
local cs_beginning = rfr.add_cutscene({
	init = function()
		rfr.set_flag("custom_background_color")
		rfr.set_flag("screen_fill")
		rfr.set_properties(GAME, "screen_fill_color", {0,0,0,255})
		rfr.set_timer(timer, 4)
		bed.wake_up()
		rfr.set_location(PLAYER, "Map.Void")
		rfr.set_position(PLAYER, 370, 112)
		lighting.set_tint("darkview", {100,100,100,180})
		lighting.set_background_color(50,50,50,255)
		rfr.unset_flag("player_can_move")
		rfr.unset_flag("player_can_open_phone")
	end,
	exit = function()
	end,
	scripts = {
		function(dt)
			if rfr.get_timer(timer).running then return false end
			rfr.unset_flag("screen_fill")
			rfr.fade_in(2)
			return true
		end,
		function(dt)
			if rfr.is_transition_active() then return false end
			rfr.set_flag("player_can_move")
			return true
		end,
	},
	update = function(dt) end
})

local day3_sleep = rfr.add_event(
	function()
		local d, tod = rfr.current_time()
		return d == 3 and tod == 2 and rfr.get_flag("sleeping")
	end)

rfr.set_event_listener(GAME, day3_sleep,
	function()
		rfr.set_flag("premature_wakeup")
		rfr.play_cutscene(cs_beginning)
	end)
return day3
