local util = require "luamodules.utilities"
local text = util.load_json(rfr.gamepath() .. "data/narratives/" .. config.language .. ".json")["introduction"]
local narrative = require "luamodules.narrative"

local timer = rfr.add_entity()
local index = 1
local introduction = rfr.add_cutscene({
	init = function()
		index = 1
		rfr.set_flag("narrative_sound")
		rfr.set_flag("screen_fill")
		rfr.set_properties(GAME, "screen_fill_color", {0,0,0,255})
		rfr.set_timer(timer, 3)
		narrative.set_position(config.render_size[1]/2, 80)
		narrative.set_scale(2)
		narrative.set_wraplength(280)
	end,
	exit = function()
		rfr.unset_flag("screen_fill")
		rfr.fade_in(2)
	end,
	scripts = {
		function(dt)
			if rfr.get_timer(timer).running then return false end
			return true
		end,
		function(dt)
			if narrative.text_active() then return false end
			if index < #text then
				narrative.set_text(text[index])
				index = index + 1
				return false
			else
				return true
			end
		end
	},
	update = function(dt) end
})

return introduction
