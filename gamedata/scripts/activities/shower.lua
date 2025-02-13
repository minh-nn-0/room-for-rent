local util = require "luamodules.utilities"
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")
local shower = {}
local on = false
local running_water_channel = 30
SHOWER = rfr.add_entity()

local blur = require "misc.blur"
rfr.set_particle_emitter_config(SHOWER, {
	emitting_position = {x = 198, y = 224},
	linear_acceleration = {x = 0, y = 0},
	color_gradient = {
		{time = 0.0, color = {146,228,255,255}},
		{time = 0.5, color = {51,136,222,255}},
	},
	area = {x = -8, y = 8},
	direction = math.rad(90),
	spread = math.rad(30),
	size_variation = {min = 0.5, max = 1},
	speed_variation = {min = 50, max = 60},
	lifetime = 0.7,
	rate = 100
})

function shower.toggle()
	if on then
		rfr.set_particle_emitter_auto(SHOWER, false)
		beaver.halt_channel(running_water_channel)
		on = false
	else
		rfr.set_particle_emitter_auto(SHOWER, true)
		beaver.play_sound(ASSETS.audios.running_water, running_water_channel, -1)
		on = true
	end
end
rfr.set_state_entry(PLAYER, "shower",
	function()
		rfr.set_tileanimation(PLAYER, {
			frames = {{13, 300},{14,300}},
			framewidth = 32,
			frameheight = 32,
			["repeat"] = true})
	end)

local shower_timer = rfr.add_entity()

local stopped = false
local cs_shower = rfr.add_cutscene({
	init = function()
		rfr.fade_out(2)
		stopped = false
	end,
	exit = function()
		if not stopped then
			local d,_ = rfr.current_time()
			shower.toggle()
			rfr.set_day_flag(d,"showered")
			rfr.fade_in(2)
			rfr.unset_flag("naked")
		else
			rfr.set_flag("naked")
			rfr.set_image(PLAYER, ASSETS.images.male_naked)
			blur.attach()
		end
		rfr.set_state(PLAYER, "idle")
		rfr.set_flag("player_can_move")
		rfr.set_flag("player_can_interact")
		rfr.unset_flag("showering")
	end,
	scripts = {
		function(dt)
			if rfr.is_transition_active() then return false end
			shower.toggle()
			rfr.set_image(PLAYER, ASSETS.images.male_shirt)
			rfr.set_state(PLAYER, "shower")
			rfr.unset_flag("player_can_move")
			rfr.unset_flag("player_can_interact")
			rfr.set_position(PLAYER, 176, 240)
			blur.deattach()
			rfr.fade_in(2)

			rfr.set_flag("showering")
			return true
		end,
		function(dt)
			if stopped then return true end
			if rfr.is_transition_active() then return false end
			rfr.set_timer(shower_timer, 2)
			return true
		end,
		function(dt)
			if stopped then return true end
			if rfr.get_timer(shower_timer).running then return false end
			rfr.fade_out(2)
			return true
		end,
		function(dt)
			if stopped then return true end
			if rfr.is_transition_active() then return false end
			return true
		end
	},
	update = function(dt)
		if rfr.get_flag("showering") and beaver.get_input(config.button.back) == 1 then
			stopped = true
			shower.toggle()
		end
	end
})


rfr.set_position(SHOWER, 194, 224)
rfr.set_location(SHOWER, "Map.Bathroom")
rfr.set_interaction(SHOWER, interaction_names["shower"],
	function()
		local px,_ = util.player_center()
		return px >= 176 and px <= 200
	end,
	function()
		local d,_ = rfr.current_time()
		if rfr.get_day_flag(d,"showered") then
			rfr.set_dialogue(PLAYER, {content = interaction_details["showered"]})
		else
			rfr.play_cutscene(cs_shower)
		end
	end)
