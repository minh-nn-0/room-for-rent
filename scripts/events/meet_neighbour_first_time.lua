local util = require "luamodules.utilities"
local dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/events/talk_neighbour_first_time_" .. config.language .. ".json")
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
rfr.set_position(NEIGHBOUR, 624, 144)
rfr.set_properties(NEIGHBOUR, "facing_direction", "right")
rfr.set_location(NEIGHBOUR, "Map.Hall")

local neighbour_interaction = rfr.add_entity()
rfr.set_position(neighbour_interaction, 640,140)
rfr.set_location(neighbour_interaction, "Map.Hall")

local cs_friendly_continue = rfr.add_cutscene({
	init = function() end,
	exit = function()
		rfr.set_active(neighbour_interaction, false)
	end,
	scripts = {
		function(dt)
			rfr.set_dialogue(PLAYER, {content = dialogues["player_friendly_continue"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(NEIGHBOUR, {content  = dialogues["neighbour_name_reveal"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(NEIGHBOUR) then return false end
			rfr.set_dialogue(PLAYER, {content  = dialogues["player_question_duration"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(NEIGHBOUR, {content  = dialogues["neighbour_duration_response"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(NEIGHBOUR) then return false end
			rfr.set_state(NEIGHBOUR, "move")
			rfr.set_properties(NEIGHBOUR, "facing_direction", "left")
			rfr.set_properties(NEIGHBOUR, "walkspeed", 1)
			return true
		end,
		function(dt)
			if rfr.get_position(NEIGHBOUR).x > 596 then return false end
			rfr.set_location(NEIGHBOUR, "Map")
			rfr.set_state(NEIGHBOUR, "idle")
			return true
		end,
		function(dt)
			rfr.set_dialogue(PLAYER, {content = dialogues["player_confusion"]})
			return true
		end,
	},
	update = function(dt) end
})

local cs_talk_neighbour_first_time = rfr.add_cutscene({
	init = function() end,
	exit = function()
		rfr.set_interaction(neighbour_interaction, interaction_names["neighbour"],
			function()
				local px,py = util.player_center()
				return px >= 630 and px <= 656 and py == 160
			end,
			function()
				rfr.play_cutscene(cs_friendly_continue)
			end)
	end,
	scripts = {
		function(dt)
			rfr.set_dialogue(PLAYER, {content = dialogues["player_greeting"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(NEIGHBOUR, {content = dialogues["neighbour_greeting"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(NEIGHBOUR) then return false end
			rfr.set_dialogue(PLAYER, {content = dialogues["player_introduction"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(NEIGHBOUR, {content = ".......", 20})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(NEIGHBOUR) then return false end
			rfr.set_dialogue(PLAYER, {content = dialogues["player_thought"],
									cpf = 80, color = {120,120,120,255},
									verbal = false})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, {content = dialogues["player_should_talk"],
									cpf = 80, color = {120,120,120,255},
									verbal = false})
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
		rfr.play_cutscene(cs_talk_neighbour_first_time)
	end)
