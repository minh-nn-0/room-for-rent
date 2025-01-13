local util = require "luamodules.utilities"
local dialogues
local interaction_names

local cs_prologue_after_broom = rfr.add_cutscene({
	init = function()
	end,
	exit = function()
	end,
	scripts = {
		function(dt)
			return true
		end,
	},
	update = function(dt) end
})
CS_PROLOGUE_CLEAN_ROOM = rfr.add_cutscene({
	init = function()
		print("enter clean")
		dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/prologue_" .. config.language .. ".json")
		interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
	end,
	exit = function()
		print("exit prologue_clean_room")
	end,
	scripts = {
		function(dt)
			rfr.set_dialogue(PLAYER, dialogues["player_shiver"])
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, dialogues["player_shiver2"])
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, dialogues["player_should_clean"])
			local broom = rfr.add_entity()
			rfr.set_position(broom, 216, 110)
			rfr.set_location(broom, "Map.Mainroom")
			rfr.set_interaction(broom, interaction_names["broom"],
				function()
					local px,_ = util.player_center()
					return px >= 210 and px <= 220
				end,
				function()
					rfr.play_cutscene(cs_prologue_after_broom)
				end)
			return true
		end
	},
	update = function(dt) end
})



