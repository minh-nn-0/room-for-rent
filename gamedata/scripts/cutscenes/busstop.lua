local util = require "luamodules.utilities"
local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")

local cs_work = require "activities.work"
local cs_gohome = require "cutscenes.gohome"
local cs_bus_choice_nonwork = rfr.add_cutscene({
	init = function()
		rfr.set_dialogue_options(rfr.get_dialogue_options_from_json(interaction_details, "bus_choice_nonwork"))
		rfr.unset_flag("player_can_move")
		rfr.unset_flag("player_can_interact")
	end,
	exit = function()
		print("exit bus choice nonwork")
	end,
	scripts = {
		function()
			if not rfr.having_dialogue_options() then
				local sl = rfr.get_dialogue_options_selection()
				if sl == 0 then
					rfr.play_cutscene(cs_gohome)
				else
					rfr.set_flag("player_can_move")
					rfr.set_flag("player_can_interact")
				end
				return true
			end
			return false
		end,
	},
	update = function(dt)
	end
})
local cs_bus_choice_work = rfr.add_cutscene({
	init = function()
		rfr.set_dialogue_options(rfr.get_dialogue_options_from_json(interaction_details, "bus_choice_work"))
		rfr.unset_flag("player_can_move")
	end,
	exit = function()
		print("exit bus choice work")
	end,
	scripts = {
		function()
			if not rfr.having_dialogue_options() then
				local sl = rfr.get_dialogue_options_selection()
				if sl == 0 then
					rfr.play_cutscene(cs_work)
				elseif sl == 1 then
					rfr.play_cutscene(cs_gohome)
				else
					rfr.set_flag("player_can_move")
				end
				return true
			end
			return false
		end,
	},
	update = function(dt)
	end
})

return cs_bus_choice_work, cs_bus_choice_nonwork
