local util = require "luamodules.utilities"
local interaction_name = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")
ALTAR = rfr.add_entity()
CABINET = rfr.add_entity()
LIGHT_SWITCH_MAINROOM = rfr.add_entity()
LIGHT_SWITCH_BATHROOM = rfr.add_entity()

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

local lighting = require "lighting"
rfr.set_position(LIGHT_SWITCH_MAINROOM, 135,94)
rfr.set_location(LIGHT_SWITCH_MAINROOM, "Map.Mainroom")
rfr.set_interaction(LIGHT_SWITCH_MAINROOM, interaction_name["light_switch"],
	function()
		local px,_ = util.player_center()
		return px >= 128 and px < 144
	end,
	function()
		lighting.toggle_light("room")
	end)

rfr.set_position(LIGHT_SWITCH_BATHROOM, 272,224)
rfr.set_location(LIGHT_SWITCH_BATHROOM, "Map.Bathroom")
rfr.set_interaction(LIGHT_SWITCH_BATHROOM, interaction_name["light_switch"],
	function()
		local px,_ = util.player_center()
		return px >= 272 and px < 287
	end,
	function()
		lighting.toggle_light("bathroom")
	end)
