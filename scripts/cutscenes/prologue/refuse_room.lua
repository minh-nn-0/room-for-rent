local util = require "luamodules.utilities"
local dialogues
CS_PROLOGUE_REFUSE_ROOM = rfr.add_cutscene({
	init = function()
		dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/prologue_" .. config.language .. ".json")
	end,
	exit = function()
		print("cs_prologue_refuse_exit")
		if rfr.get_flag("reconsidered") then
			rfr.play_cutscene(CS_PROLOGUE_ACCEPT_ROOM)
		else
			--rfr.play_cutscene(CS_PROLOGUE_LEAVE)
		end
	end,
	scripts = {
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, {content = rfr.get_dialogue_from_json(dialogues, "player_refuse_room")})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(OWNER, {content = rfr.get_dialogue_from_json(dialogues, "owner_excuse")})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(OWNER) then return false end
			rfr.set_dialogue(OWNER, {content = rfr.get_dialogue_from_json(dialogues, "owner_persuade")})
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
				rfr.set_dialogue(PLAYER, {content = rfr.get_dialogue_from_json(dialogues, "player_leave")})
			else
				rfr.set_flag("reconsidered")
				rfr.set_dialogue(PLAYER, {content = rfr.get_dialogue_from_json(dialogues, "player_reconsider")})
			end
			return true
		end,
		function(dt)
			return not rfr.has_active_dialogue(PLAYER)
		end
	},
	update = function(dt) end
})
