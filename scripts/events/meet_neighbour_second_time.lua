local util = require "luamodules.utilities"
local dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/events/talk_neighbour_second_time_" .. config.language .. ".json")
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
rfr.set_position(NEIGHBOUR, 624, 144)
rfr.set_properties(NEIGHBOUR, "facing_direction", "right")
rfr.set_location(NEIGHBOUR, "Map.Hall")

local neighbour_interaction = rfr.add_entity()
rfr.set_position(neighbour_interaction, 640,140)
rfr.set_location(neighbour_interaction, "Map.Hall")
rfr.set_interaction(neighbour_interaction, interaction_names["neighbour"],
	function()
		local px,py = util.player_center()
		return px >= 630 and px <= 656 and py == 160
	end,
	function()
		rfr.play_cutscene(cs_talk_neighbour_second_time)
		rfr.set_active(neighbour_interaction, false)
	end)
