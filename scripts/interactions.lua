local util = require "luamodules.utilities"
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")

local power_box = rfr.add_entity()
rfr.set_position(power_box, 320, 134)
rfr.set_location(power_box, "Map.Outside")
rfr.set_interaction(power_box, interaction_names["power_box"],
	function()
		local px, py = util.player_center()
		return px >= 310 and px <= 330
	end,
	function()
		rfr.set_dialogue(PLAYER, {content = interaction_details["power_box"]})
	end)
local house_number = rfr.add_entity()
rfr.set_position(house_number, 488, 128)
rfr.set_location(house_number, "Map.Outside")
rfr.set_interaction(house_number, interaction_names["house_number"],
	function()
		local px, py = util.player_center()
		return px >= 480 and px <= 490
	end,
	function()
		rfr.set_flag("read_house_number")
		rfr.set_dialogue(PLAYER, {content = interaction_details["house_number"]})
	end)
