local util = require "luamodules.utilities"
local dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/events/talk_neighbour_second_time_" .. config.language .. ".json")
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
rfr.set_position(NEIGHBOUR, 624, 144)
rfr.set_properties(NEIGHBOUR, "facing_direction", "right")
rfr.set_location(NEIGHBOUR, "Map.Hall")

local neighbour_interaction = rfr.add_entity()
rfr.set_position(neighbour_interaction, 640,140)
rfr.set_location(neighbour_interaction, "Map.Hall")
local cs_talk_neighbour_second_time = rfr.add_cutscene({
	init = function() end,
	exit = function()
	end,
	scripts = {
		function(dt)
			rfr.set_dialogue(PLAYER, {content = dialogues["player_greeting"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(NEIGHBOUR, {content = dialogues["neighbour_respond"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(NEIGHBOUR) then return false end
			rfr.set_dialogue(PLAYER, {content = dialogues["player_ask"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(NEIGHBOUR, {content = dialogues["neighbour_dx"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(NEIGHBOUR) then return false end
			rfr.set_properties(NEIGHBOUR, "facing_direction", "left")
			rfr.set_state(NEIGHBOUR, "move")
			return true
		end,
		function(dt)
			if rfr.get_position(NEIGHBOUR).x > 596 then return false end
			rfr.set_location(NEIGHBOUR, "Map")
			rfr.set_state(NEIGHBOUR, "idle")
			return true
		end,
		function(dt)
			rfr.set_dialogue(PLAYER, {content = dialogues["player_confused"]})
			return true
		end,
	},
	update = function(dt) end
})
rfr.set_interaction(neighbour_interaction, interaction_names["neighbour"],
	function()
		local px,py = util.player_center()
		return px >= 630 and px <= 656 and py == 160
	end,
	function()
		rfr.play_cutscene(cs_talk_neighbour_second_time)
		rfr.set_active(neighbour_interaction, false)
	end)
