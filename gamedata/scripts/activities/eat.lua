local camera = require "luamodules.camera"
local util = require "luamodules.utilities"
local interaction = require "luamodules.interaction"
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")

local eat = rfr.add_entity()

rfr.set_particle_emitter_config(eat, {
	emitting_position = {x = 186, y = 126},
	linear_acceleration = {x = 0, y = 0},
	color_gradient = {
		{time = 0.0, color = {255,255,255,255}},
	},
	area = {x = -3, y = 3},
	direction = math.rad(270),
	spread = math.rad(30),
	size_variation = {min = 1, max = 3},
	speed_variation = {min = 2, max = 20},
	lifetime = 1,
	rate = 5
})

rfr.set_particle_emitter_auto(eat, false)
rfr.set_image(eat, rfr.get_image(PLAYER))
rfr.set_zindex(eat, 1)
rfr.set_tileanimation(eat, {
	frames = {{15,300},{16,300},{17,300},{18,300}},
	framewidth = 32,
	frameheight = 32,
	["repeat"] = true})

rfr.set_animation_playing(eat, false)
rfr.set_position(eat, 1000,1000)
rfr.set_location(eat, "Map.Mainroom")
local cs_eat = rfr.add_cutscene({
	init = function()
		rfr.set_image(eat, rfr.get_image(PLAYER))
		rfr.set_animation_playing(eat, true)
		rfr.set_position(eat, 168, 112)
		camera.set_target(eat, 16,0)
		rfr.set_position(PLAYER, 1000,1000)
		rfr.unset_flag("player_can_move")
		rfr.unset_flag("player_can_interact")
		rfr.set_flag("eating")
		rfr.set_particle_emitter_auto(eat, true)
		beaver.play_sound(ASSETS.audios.eatnoddle)

		rfr.set_timer(eat, 5)
	end,
	exit = function()
		rfr.set_animation_playing(eat, false)
		rfr.set_position(eat, 1000, 1000)
		camera.set_target(PLAYER, 16,0)
		rfr.set_position(PLAYER, 169,112)

		rfr.set_flag("player_can_move")
		rfr.set_flag("player_can_interact")
		rfr.unset_flag("eating")
		local d,_ = rfr.current_time()
		rfr.set_day_flag(d, "eat")
	end,
	scripts = {
		function(dt)
			if rfr.get_timer(eat).elapsed > 3 then rfr.set_particle_emitter_auto(eat, false) end
			if rfr.get_timer(eat).running then return false end
			return true
		end
	},
	update = function(dt) end
})

interaction.add({214, 96},
	function()
		local px,_ = util.player_center()
		return px >= 204 and px <= 220 and rfr.get_location(PLAYER) == "Map.Mainroom"
	end,
	function()
		local d,_ = rfr.current_time()
		if rfr.get_day_flag(d, "eat") then rfr.set_dialogue(PLAYER, {content = interaction_details["eaten"]})
		else
			rfr.play_cutscene(cs_eat)
		end
	end)
return cs_eat
