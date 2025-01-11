local util = require "luamodules.utilities"
local dialogues
rfr.add_cutscene({
	name = "cs_prologue_arrive",
	init = function()
		dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/prologue_" .. config.language .. ".json")
		rfr.set_flag("prologue_outside")
		rfr.fade_in(5)
		rfr.set_cam_zoom(2)
		rfr.set_cam_target(PLAYER, 16, -20)
		rfr.set_current_map("outside")
		rfr.set_location(PLAYER, "Map.Outside")
		rfr.set_position(PLAYER, 30, 144)
		rfr.set_properties(PLAYER, "walkspeed", 0.8)
		rfr.set_properties(PLAYER, "can_move", false)
		rfr.set_state(PLAYER, "move")
		rfr.add_tag(PLAYER, "npc")
		rfr.set_flipflag(PLAYER, beaver.FLIP_NONE)
	end,
	exit = function()
		print("exit prologue_outside")
		rfr.set_properties(PLAYER, "can_move", true)
		rfr.remove_tag(PLAYER, "npc")
	end,
	scripts = {
		function(dt)
			if rfr.get_position(PLAYER).x < 280 then return false end
			rfr.set_state(PLAYER, "idle")
			rfr.set_dialogue(PLAYER, dialogues["player_arrive1"])
			return true
		end,
	},
	update = function(dt) end
})

rfr.add_event("read_house_number_first_time",
	function()
		return rfr.get_flag("read_house_number")
	end)

rfr.set_event_listener(PLAYER, "read_house_number_first_time",
	function()
		rfr.play_cutscene("cs_prologue_call_owner")
	end)

rfr.add_cutscene({
	name = "cs_prologue_call_owner",
	init = function()
		rfr.unset_event_listener(PLAYER, "read_house_number_first_time")
	end,
	exit = function() end,
	scripts = {
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, dialogues["player_correct_address"])
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, dialogues["player_should_call"])
			return true
		end,
	},
	update = function(dt) end
})
