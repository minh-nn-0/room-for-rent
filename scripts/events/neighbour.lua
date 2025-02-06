local util = require "luamodules.utilities"
local dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/events/talk_neighbour_first_time_" .. config.language .. ".json")
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local meet_neighbour_scenes = {}

local neighbour_posx = 576
local door_posx = 553

function meet_neighbour_scenes.setup_neighbour()
	rfr.set_position(NEIGHBOUR, neighbour_posx, 144)
	rfr.set_properties(NEIGHBOUR, "facing_direction", "right")
	rfr.set_location(NEIGHBOUR, "Map.Hall")
	rfr.set_flag("neighbour_chilling")
end

meet_neighbour_scenes[1] = rfr.add_cutscene({
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

meet_neighbour_scenes[2] = rfr.add_cutscene({
	init = function() end,
	exit = function()
		rfr.unset_flag("neighbour_chilling")
		print("exit neighbour first time")
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
			if rfr.get_position(NEIGHBOUR).x > door_posx then return false end
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

meet_neighbour_scenes[3] = rfr.add_cutscene({
	init = function() end,
	exit = function()
		rfr.unset_flag("neighbour_chilling")
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
			if rfr.get_position(NEIGHBOUR).x > door_posx then return false end
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

local count = 1
local neighbour_interaction = rfr.add_entity()
rfr.set_position(neighbour_interaction, neighbour_posx + 16,140)
rfr.set_location(neighbour_interaction, "Map.Hall")

rfr.set_interaction(neighbour_interaction, interaction_names["neighbour"],
	function()
		local px,py = util.player_center()
		return px >= neighbour_posx + 6 and px <= neighbour_posx + 26 and py == 160 and rfr.get_flag("neighbour_chilling") and not rfr.is_cutscene_playing()
	end,
	function()
		rfr.play_cutscene(meet_neighbour_scenes[count])
		count = count + 1
	end)

return meet_neighbour_scenes
