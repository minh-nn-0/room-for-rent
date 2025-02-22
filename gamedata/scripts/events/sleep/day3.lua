local bed = require "activities.sleep"
local util = require "luamodules.utilities"
local interaction = require "luamodules.interaction"
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local day3 = {}
local lighting = require "lighting"
local girl_at_table = require "dreams.girl_at_table"
local map = require "luamodules.map"

local timer = rfr.add_entity()
--local cs_blow_candle = rfr.add_cutscene({
--})
--local cs_lights_out = rfr.add_cutscene({
--})

local candle = require "misc.candle"
local cs_room = rfr.add_cutscene({
	init = function()
		beaver.play_sound(ASSETS.audios.stinger_impact01)
		map.set_current_map("room_dream")
		rfr.set_location(PLAYER, "Map.Dream")
		lighting.set_tint("darkview", {40,40,40,180})
		lighting.set_light_on("room_dream_ceiling", true)
		lighting.set_tint("room_dream_ceiling", {212,120,100,200})
		lighting.set_scale("room_dream_ceiling", 1.5)
		rfr.set_location(candle.eid, "Map.Dream")
		rfr.set_timer(timer, 10)
	end,
	exit = function()
	end,
	scripts = {
		function(dt)
			if rfr.get_timer(timer).running then return false end
			lighting.set_light_on("room_dream_ceiling", false)
			rfr.set_position(girl_at_table, 500,500)
			rfr.fade_in(2)
			return true
		end,
		function(dt)
			if rfr.is_transition_active() then return false end
			rfr.set_dialogue(PLAYER, {content = "Toi qua"})
			rfr.set_flag("can_pickup_candle")
			return true
		end,
		function(dt)
			if not candle.picked_up() then return false end
			rfr.unset_flag("can_pickup_candle")
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
interaction.add(interaction_names["light_switch"],
	function()
		local px, _ = util.player_center()
		return px >= 130 and px <= 140 and rfr.get_location(PLAYER) == "Map.Void"
	end,
	function()
		rfr.play_cutscene(cs_room)
	end)
local cs_beginning = rfr.add_cutscene({
	init = function()
		rfr.set_flag("screen_fill")
		rfr.set_properties(GAME, "screen_fill_color", {0,0,0,255})
		rfr.set_timer(timer, 4)
		bed.wake_up()
		rfr.set_location(PLAYER, "Map.Void")
		rfr.set_position(PLAYER, 370, 112)
		lighting.set_tint("darkview", {100,100,100,180})
		rfr.unset_flag("player_can_move")
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
