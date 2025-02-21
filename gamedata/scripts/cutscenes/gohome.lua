local camera = require "luamodules.camera"
local util = require "luamodules.utilities"
local narrative = require "luamodules.narrative"
local narrative_text = util.load_json(rfr.gamepath() .. "data/narratives/" .. config.language .. ".json")["gohome_prologue"]
local bus = require "misc.bus"

local index = 1
local cs_gohome_prologue = rfr.add_cutscene({
	init = function()
		rfr.set_flag("screen_fill")
		rfr.set_state(PLAYER, "idle")
		narrative.set_position(config.render_size[1] / 2, 80)
		narrative.set_scale(2)
		narrative.set_wraplength(280)
		rfr.set_timer(GAME, 2)
	end,
	exit = function()
	end,
	scripts = {
		function(dt)
			if rfr.get_timer(GAME).running then return false end
			rfr.set_properties(GAME, "screen_fill_color", {0,0,0,180})
			rfr.fade_in(2)
			rfr.set_position(PLAYER, 400,144)
			rfr.add_tag(PLAYER, "npc")
			rfr.unset_flag("player_can_move")
			rfr.unset_flag("player_can_interact")
			rfr.set_state(PLAYER, "move")
			rfr.set_properties(PLAYER, "walkspeed", 0.5)
			rfr.set_properties(PLAYER, "facing_direction", "left")
			return true
		end,
		function()
			if rfr.get_position(PLAYER).x >= 230 then return false end
			rfr.set_state(PLAYER, "idle")
			bus.appear()
			beaver.fade_in_channel("busengine", 2, 0, 1000)
			return true
		end,
		function(dt)
			if rfr.get_position(bus.eid).x >= 180 then return false end
			bus.stop()
			beaver.play_sound(ASSETS.audios.busdoor, -1, 0)
			rfr.set_timer(bus.eid, 3)
			camera.set_target(nil, 0, 0)
			rfr.set_position(PLAYER, 1000, 1000)
			return true
		end,
		function(dt)
			if rfr.get_timer(bus.eid).running then return false end
			bus.start()
			beaver.fade_out_channel(2, 7000)
			local bpos = rfr.get_position(bus.eid)
			rfr.manual_emit_particles(bus.eid, 60, bpos.x + 125, bpos.y + 40, {})
			return true
		end,
		function(dt)
			if rfr.get_position(bus.eid).x >= -140 then return false end
			rfr.fade_out(3)
			return true
		end,
	},
	update = function(dt)
		if rfr.get_timer(GAME).running then return end
		if not narrative.text_active() and index < #narrative_text then
			narrative.set_text(narrative_text[index])
			index = index + 1
		end
	end,
})
local cs_gohome = rfr.add_cutscene({
	init = function()
		rfr.fade_out(2)
	end,
	exit = function()
		print("exit cs_gohome")
	end,
	scripts = {
		function(dt)
			if rfr.is_transition_active() then return false end
			rfr.fade_in(2)
			return true
		end,
	},
	update = function(dt) end
})

return {cs_gohome, cs_gohome_prologue}
