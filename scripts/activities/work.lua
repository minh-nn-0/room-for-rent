local util = require "luamodules.utilities"
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local narratives = util.load_json(rfr.gamepath() .. "data/narratives/" .. config.language .. ".json")

local cs_gotowork = rfr.add_cutscene({
	init = function()
		rfr.unset_flag("player_can_move")
		rfr.unset_flag("player_can_interact")
		rfr.fade_out(2)
	end,
	exit = function() end,
	scripts = {
		function(dt)
			if rfr.is_transition_active() then return false end
			rfr.set_flag("screen_fill")
			rfr.set_properties(GAME, "screen_fill_color", {0,0,0,255})
			rfr.fade_in(1)
			return true
		end,
		function(dt)
			if rfr.is_transition_active() then return false end
			rfr.set_narrative_text(narratives["work"])
			rfr.set_narrative_position(config.render_size[1] / 2, config.render_size[2] / 2)
			rfr.set_narrative_scale(2)
			return true
		end,
		function(dt)
			if rfr.narrative_text_active() then return false end
			rfr.unset_flag("screen_fill")
			rfr.fade_in(2)
			return true
		end,
		function(dt)
			if rfr.is_transition_active() then return false end
			rfr.set_flag("player_can_move")
			rfr.set_flag("player_can_interact")
			return true
		end,
	},
	update = function(dt) end
})
