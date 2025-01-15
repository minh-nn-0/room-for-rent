local util = require "luamodules.utilities"
print("HAHAHAHAHAA")
local dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/events/talk_neighbour_first_time_" .. config.language .. ".json")
print("HAHAHAHAHAA")
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
print("HAHAHAHAHAA")
rfr.set_position(NEIGHBOUR, 624, 144)
print("HAHAHAHAHAA")
rfr.set_location(NEIGHBOUR, "Map.Hall")
print("HAHAHAHAHAA")

local cs_talk_neighbour_first_time = rfr.add_cutscene({
	init = function() end,
	exit = function() end,
	scripts = {
		function(dt)
			rfr.set_dialogue(PLAYER, dialogues["player_greeting"])
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(NEIGHBOUR, dialogues["neighbour_greeting"])
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(NEIGHBOUR) then return false end
			rfr.set_dialogue(PLAYER, dialogues["player_introduction"])
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(NEIGHBOUR, dialogues["player_thought"])
			return true
		end,
	},
	update = function(dt) end
})

local neighbour_interaction = rfr.add_entity()
rfr.set_position(neighbour_interaction, 640,140)
rfr.set_location(neighbour_interaction, "Map.Hall")
rfr.set_interaction(neighbour_interaction, interaction_names["neighbour"],
	function()
		local px,py = util.player_center()
		return px >= 630 and px <= 656 and py == 160
	end,
	function()
		rfr.play_cutscene(cs_talk_neighbour_first_time)
	end)
