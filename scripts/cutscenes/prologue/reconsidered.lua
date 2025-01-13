local util = require "luamodules.utilities"
local dialogues
CS_PROLOGUE_RECONSIDERED = rfr.add_cutscene({
	init = function()
		dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/prologue_" .. config.language .. ".json")
	end,
	exit = function() end,
	scripts = {
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_sign"))
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_sign"))
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(OWNER) then return false end
			rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_remind"))
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(OWNER) then return false end
			rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_thank"))
			return true
		end,
		function(dt)
			if not rfr.has_active_dialogue(PLAYER) then
				rfr.set_state(OWNER, "move")
				rfr.set_properties(OWNER, "facing_direction", "right")
				if rfr.get_position(OWNER).x >= 300 then
					rfr.set_state(OWNER, "idle")
					rfr.set_position(OWNER, -1000, 1000)
					return true
				end
				return false
			end
			return false
		end
	},
	update = function(dt)
	end
})
