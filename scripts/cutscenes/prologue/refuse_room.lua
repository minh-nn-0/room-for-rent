local util = require "luamodules.utilities"
local dialogues
rfr.add_cutscene({
	name = "cs_prologue_player_refuse_room",
	init = function()
		dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/prologue_" .. config.language .. ".json")
	end,
	exit = function() print("cs_prologue_refuse_exit") end,
	scripts = {
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_refuse_room"))
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_excuse"))
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(OWNER) then return false end
			rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_persuade"))
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(OWNER) then return false end
			rfr.set_dialogue_options(rfr.get_dialogue_options_from_json(dialogues, "player_choice_reconsider"))
			return true
		end,
		function(dt)
			if rfr.having_dialogue_options() then return false end
			local sl = rfr.get_dialogue_options_selection()
			if sl == 0 then
				rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_leave"))
			else
				rfr.set_flag("reconsidered")
				rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_reconsider"))
			end
			return true
		end,
		function(dt)
			return not rfr.has_active_dialogue(PLAYER)
		end
	},
	update = function(dt) end
})
