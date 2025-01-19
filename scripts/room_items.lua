local util = require "luamodules.utilities"
local interaction_name = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")
BED = rfr.add_entity()
ALTAR = rfr.add_entity()
CABINET = rfr.add_entity()


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
rfr.set_position(ALTAR, 152,94)
rfr.set_properties(ALTAR, "normal", true)
rfr.set_location(ALTAR, "Map.Mainroom")
rfr.set_interaction(ALTAR, interaction_name["altar"],
	function()
		local px,_ = util.player_center()
		return px >= 144 and px <= 160
	end,
	function()
		if rfr.get_properties(ALTAR, "normal") then
			rfr.set_dialogue(PLAYER, {content = interaction_details["altar"]})
		end
	end)
rfr.set_position(CABINET, 288,100)
rfr.set_properties(CABINET, "normal", true)
rfr.set_location(CABINET, "Map.Mainroom")
rfr.set_interaction(CABINET, interaction_name["cabinet"],
	function()
		local px,_ = util.player_center()
		return px >= 276 and px <= 300
	end,
	function()
		if rfr.get_properties(CABINET, "normal") then
			-- rfr.set_dialogue(PLAYER, {content = interaction_details["cabinet"]})
			-- change_clothes
		end
	end)
