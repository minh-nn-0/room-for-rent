local util = require "luamodules.utilities"
local narrative = require "luamodules.narrative"
local narrative_text = util.load_json(rfr.gamepath() .. "data/narratives/" .. config.language .. ".json")
local particle = require "luamodules.particle"
local bus = require "misc.bus"
local dummy_target = rfr.add_entity()
local cs_gotowork = rfr.add_cutscene({
	init = function()
		bus.appear()
	end,
	exit = function() end,
	scripts = {
		function(dt)
			if rfr.get_position(bus.eid).x >= 180 then return false end
			bus.stop()
			rfr.set_timer(bus.eid, 3)
			rfr.set_cam_target(nil, 0, 0)
			rfr.set_position(PLAYER, 1000, 1000)
			return true
		end,
		function(dt)
			if rfr.get_timer(bus.eid).running then return false end
			bus.start()
			local bpos = rfr.get_position(bus.eid)
			rfr.manual_emit_particles(bus.eid, 60, bpos.x + 125, bpos.y + 40, {})
			return true
		end,
		function(dt)
			if rfr.get_position(bus.eid).x >= -140 then return false end
			rfr.fade_out(3)
			return true
		end,
		function(dt)
			if rfr.is_transition_active() then return false end
			rfr.set_flag("screen_fill")
			rfr.set_properties(GAME, "screen_fill_color", {0,0,0,255})
			rfr.fade_in(1)
			return true
		end,
		function(dt)
			if rfr.is_transition_active() then return false end
			narrative.set_text(narrative_text["work"])
			narrative.set_position(config.render_size[1] / 2, config.render_size[2] / 2)
			narrative.set_scale(2)
			return true
		end,
		function(dt)
			if narrative.text_active() then return false end
			rfr.set_position(bus.eid, 300, 136)
			rfr.unset_flag("screen_fill")
			rfr.fade_in(2)
			rfr.set_cam_target(bus.eid, 50, -36)
			return true
		end,
		function(dt)
			if rfr.get_position(bus.eid).x >= 180 then return false end
			bus.stop()
			rfr.set_timer(bus.eid, 3)
			return true
		end,
		function(dt)
			if rfr.get_timer(bus.eid).running then return false end
			bus.start()
			local bpos = rfr.get_position(bus.eid)
			rfr.manual_emit_particles(bus.eid, 60, bpos.x + 125, bpos.y + 40, {})
			rfr.set_position(PLAYER, 239, 144)
			rfr.set_cam_target(PLAYER, 16, -43)
			rfr.set_flag("player_can_move")
			return true
		end,
		function(dt)
			if rfr.get_position(bus.eid).x >= -140 then return false end
			return true
		end
	},
	update = function(dt)
		bus.update(dt)
		particle.decrease_size_overtime(bus.eid)
	end
})

return cs_gotowork
