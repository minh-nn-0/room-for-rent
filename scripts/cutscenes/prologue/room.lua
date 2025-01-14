local util = require "luamodules.utilities"
local dialogues
local cam_target1 = rfr.add_entity()
rfr.set_position(cam_target1, 80, 112)
local start_talking_timer = rfr.add_entity()
local confirm_owner = rfr.add_entity()
CS_PROLOGUE_ROOM = rfr.add_cutscene({
	init = function()
		dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/prologue_" .. config.language .. ".json")
		local interaction_name = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
		rfr.set_flag("prologue_room")
		rfr.set_properties(DOOR_ROOM_TO_HALL, "disable", true)
		rfr.fade_in(1.5)
		rfr.set_current_map("room_before")
		rfr.set_position(PLAYER, 290, 112)
		rfr.set_flipflag(PLAYER, beaver.FLIP_H)
		rfr.unset_flag("player_can_move")
		rfr.set_position(OWNER, 278, 112)
		rfr.set_location(OWNER, "Map.Mainroom")
		rfr.set_state(OWNER, "idle")
		rfr.set_properties(OWNER,"facing_direction", "left")

		rfr.set_position(confirm_owner, 294, 100)
		rfr.set_location(confirm_owner, "Map.Mainroom")
		rfr.set_interaction(confirm_owner, interaction_name["owner"],
			function()
				local px,_ = util.player_center()
				return px >= 280 and px <= 300
			end,
			function()
				rfr.set_dialogue_options(rfr.get_dialogue_options_from_json(dialogues, "player_choice_take_room"))
				rfr.set_flag("player_choice_take_room")
			end)

		rfr.set_timer(start_talking_timer, 3)
		rfr.set_dialogue(PLAYER, "")
		rfr.set_dialogue(OWNER, "")
		rfr.set_cam_target(cam_target1)
	end,
	exit = function()
		rfr.set_active(confirm_owner, false)
		if rfr.get_flag("refuse_room") then
			rfr.play_cutscene(CS_PROLOGUE_REFUSE_ROOM)
		else
			rfr.play_cutscene(CS_PROLOGUE_ACCEPT_ROOM)
		end
		print("exit prologue room")
	end,
	scripts = {
		function(dt)
			if rfr.get_position(cam_target1).x <= 250 then return false end
			rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_checkroom"))
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(OWNER) then return false end
			rfr.set_flag("player_can_move")
			return true
		end,
		function(dt)
			if not rfr.get_flag("player_choice_take_room") then return false end
			if rfr.having_dialogue_options() then return false end
			local sl = rfr.get_dialogue_options_selection()
			if sl == 0 then
				rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_accept_room"))
			elseif sl == 1 then
				rfr.set_flag("refuse_room")
			elseif sl == 2 then
				rfr.unset_flag("player_choice_take_room")
				return false
			end
			return true
		end,
	},
	update = function(dt)
		if rfr.is_transition_active() then return end
		local cam_target_pos = rfr.get_position(cam_target1)
		if cam_target_pos.x <= 320 then
			cam_target_pos.x = cam_target_pos.x + 40 * dt
			rfr.set_position(cam_target1, cam_target_pos.x, cam_target_pos.y)
		else
			rfr.set_cam_target(PLAYER, 16, 0)
		end
	end
})

