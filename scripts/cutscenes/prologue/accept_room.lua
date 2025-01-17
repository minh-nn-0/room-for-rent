local util = require "luamodules.utilities"
local dialogues
CS_PROLOGUE_ACCEPT_ROOM = rfr.add_cutscene({
	init = function()
		dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/prologue_" .. config.language .. ".json")
	end,
	exit = function()
		rfr.set_properties(DOOR_ROOM_TO_HALL, "disable", false)
		print("cs_prologue_accept_exit")
		rfr.play_cutscene(CS_PROLOGUE_CLEAN_ROOM)
	end,
	scripts = {
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, {content = rfr.get_dialogue_from_json(dialogues, "player_sign")})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(OWNER, {content = rfr.get_dialogue_from_json(dialogues, "owner_sign")})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(OWNER) then return false end
			rfr.set_dialogue(OWNER, {content = rfr.get_dialogue_from_json(dialogues, "owner_remind")})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(OWNER) then return false end
			rfr.set_dialogue(PLAYER, {content = rfr.get_dialogue_from_json(dialogues, "player_thank")})
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

