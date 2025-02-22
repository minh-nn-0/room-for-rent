local util = require "luamodules.utilities"
local interaction = require "luamodules.interaction"
local dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/events/talk_neighbour_at_door_" .. config.language .. ".json")["dialogues"]
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local count = 1
local neighbour_posx = 576
local door_posx = 553
local current_dialogues = {}
local function load_current_dialogues() current_dialogues = dialogues[count - 1] end

local meet_neighbour_scenes = {
	rfr.add_cutscene({
		init = function()
			load_current_dialogues()
		end,
		exit = function()
		end,
		scripts = {
			function(dt)
				rfr.set_dialogue(PLAYER, {content = current_dialogues["greet"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(PLAYER) then return false end
				rfr.set_dialogue(NEIGHBOUR, {content = current_dialogues["reply"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(NEIGHBOUR) then return false end
				rfr.set_dialogue(PLAYER, {content = current_dialogues["introduce"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(PLAYER) then return false end
				rfr.set_dialogue(NEIGHBOUR, {content = current_dialogues["acknowledge"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(NEIGHBOUR) then return false end
				rfr.set_dialogue(PLAYER, {content = current_dialogues["thought"],
										cpf = 80, color = {120,120,120,255},
										verbal = false})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(PLAYER) then return false end
				rfr.set_dialogue(PLAYER, {content = current_dialogues["hesitate"],
										cpf = 80, color = {120,120,120,255},
										verbal = false})
				return true
			end,
		},
		update = function(dt) end
	}),
	rfr.add_cutscene({
		init = function()
			load_current_dialogues()
		end,
		exit = function()
			rfr.unset_flag("neighbour_chilling")
			print("exit neighbour first time")
		end,
		scripts = {
			function(dt)
				rfr.set_dialogue(PLAYER, {content = current_dialogues["ask_name"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(PLAYER) then return false end
				rfr.set_dialogue(NEIGHBOUR, {content  = current_dialogues["name_reveal"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(NEIGHBOUR) then return false end
				rfr.set_dialogue(PLAYER, {content  = current_dialogues["ask_duration"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(PLAYER) then return false end
				rfr.set_dialogue(NEIGHBOUR, {content  = current_dialogues["duration_reply"]})
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
				rfr.set_dialogue(PLAYER, {content = current_dialogues["confused"]})
				return true
			end,
		},
		update = function(dt) end
	}),
	rfr.add_cutscene({
		init = function()
			load_current_dialogues()
		end,
		exit = function()
			rfr.unset_flag("neighbour_chilling")
		end,
		scripts = {
			function(dt)
				rfr.set_dialogue(PLAYER, {content = current_dialogues["follow_up"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(PLAYER) then return false end
				rfr.set_dialogue(NEIGHBOUR, {content = current_dialogues["warning"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(NEIGHBOUR) then return false end
				rfr.set_dialogue(PLAYER, {content = current_dialogues["ask_reason"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(PLAYER) then return false end
				rfr.set_dialogue(NEIGHBOUR, {content = current_dialogues["mystery"]})
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
				rfr.set_dialogue(PLAYER, {content = current_dialogues["puzzled"]})
				return true
			end,
		},
		update = function(dt) end
	}),
	rfr.add_cutscene({
		init = function()
			load_current_dialogues()
		end,
		exit = function()
		end,
		scripts = {
			function(dt)
				rfr.set_dialogue(PLAYER, {content = current_dialogues["greet"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(PLAYER) then return false end
				rfr.set_dialogue(NEIGHBOUR, {content = current_dialogues["reply"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(NEIGHBOUR) then return false end
				rfr.set_dialogue(PLAYER, {content = current_dialogues["ask"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(PLAYER) then return false end
				rfr.set_dialogue(NEIGHBOUR, {content = current_dialogues["answer"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(NEIGHBOUR) then return false end
				rfr.set_dialogue(PLAYER, {content = current_dialogues["remark"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(PLAYER) then return false end
				rfr.set_dialogue(NEIGHBOUR, {content = current_dialogues["response"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(NEIGHBOUR) then return false end
				rfr.set_dialogue(PLAYER, {content = current_dialogues["mention"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(PLAYER) then return false end
				rfr.set_dialogue(NEIGHBOUR, {content = current_dialogues["reaction"]})
				return true
			end,
			function(dt)
				if rfr.has_active_dialogue(NEIGHBOUR) then return false end
				rfr.set_dialogue(PLAYER, {content = current_dialogues["mutter"]})
				return true
			end,
		},
		update = function(dt) end
	})
}

function meet_neighbour_scenes.setup_neighbour()
	rfr.set_position(NEIGHBOUR, neighbour_posx, 144)
	rfr.set_properties(NEIGHBOUR, "facing_direction", "right")
	rfr.set_location(NEIGHBOUR, "Map.Hall")
	rfr.set_flag("neighbour_chilling")
end

local neighbour_interaction = rfr.add_entity()
rfr.set_position(neighbour_interaction, neighbour_posx + 16,140)
rfr.set_location(neighbour_interaction, "Map.Hall")

interaction.add(interaction_names["neighbour"],
	function()
		local px,py = util.player_center()
		return px >= neighbour_posx + 6 and px <= neighbour_posx + 26 and py == 160 and rfr.get_flag("neighbour_chilling") and not rfr.is_cutscene_playing()
	end,
	function()
		rfr.play_cutscene(meet_neighbour_scenes[count])
		count = count + 1
	end)

return meet_neighbour_scenes
