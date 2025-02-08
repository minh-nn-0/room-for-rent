local util = require "luamodules.utilities"
local narrative = require "luamodules.narrative"
local narrative_text = util.load_json(rfr.gamepath() .. "data/narratives/" .. config.language .. ".json")

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

return cs_gohome
