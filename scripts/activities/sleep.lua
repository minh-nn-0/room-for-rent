local util = require "luamodules.utilities"
local interaction_name = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")

local cs_sleep = rfr.add_cutscene({
	init = function()

	end,
	exit = function() end,
	scripts = {
	},
	update = function() end
})

BED = rfr.add_entity()
rfr.set_position(BED, 104,100)
rfr.set_location(BED, "Map.Mainroom")
rfr.set_properties(BED, "normal", true)
rfr.set_interaction(BED, interaction_name["bed"],
	function()
		local px,_ = util.player_center()
		return px >= 90 and px <= 120
	end,
	function()
		if rfr.get_flag("can_sleep") then
			--rfr.set_dialogue(PLAYER, {content = interaction_details["bed"]})
			-- next_day
		end
	end)
