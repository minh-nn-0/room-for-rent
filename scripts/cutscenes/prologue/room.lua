local util = require "luamodules.utilities"
local dialogues
local cam_target1 = rfr.add_entity()
rfr.set_position(cam_target1, 80, 112)
local cam_delay = rfr.add_entity()

local start_talking_timer = rfr.add_entity()
rfr.add_cutscene({
	name = "cs_prologue_room",
	init = function()
		dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/prologue_" .. config.language .. ".json")
		local interaction_name = util.load_json(rfr.gamepath() .. "data/interaction/" .. config.language .. ".json")
		rfr.set_flag("prologue_room")
		rfr.fade_in(2)
		rfr.set_timer(cam_delay, 1)
		rfr.set_location(OWNER, "Map.Mainroom")
		rfr.set_position(OWNER, 278, 112)
		rfr.set_state(OWNER, "idle")
		rfr.set_properties(OWNER,"facing_direction", "left")

		local confirm_owner = rfr.add_entity()
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
	exit = function() print("HAHAHAHHA") end,
	scripts = {
		function(dt)
			if rfr.get_position(cam_target1).x <= 250 then return false end
			rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_checkroom"))
			return true
		end,
		function(dt)
			if not rfr.get_flag("player_choice_take_room") then return false end
			if rfr.having_dialogue_options() then return false end
			local sl = rfr.get_dialogue_options_selection()
			if sl == 2 then
				rfr.unset_flag("player_choice_take_room")
				return false
			end
			if sl == 1 then
				rfr.set_flag("refuse_room")
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

rfr.add_event("ev_prologue_room_choice", function() return rfr.get_current_cutscene_name() == "cs_prologue_room" and not rfr.is_cutscene_playing() end)
local refuse_room_event = rfr.add_entity()
rfr.set_event_listener(refuse_room_event, "ev_prologue_room_choice",
	function()
		if rfr.get_flag("refuse_room") then
			rfr.play_cutscene("cs_prologue_player_refuse_room")
		else
			rfr.play_cutscene("cs_prologue_player_accept_room")
		end
	end)

rfr.add_event("ev_prologue_room_refuse", function()
	return rfr.get_current_cutscene_name() == "cs_prologue_player_refuse_room" and not rfr.is_cutscene_playing()
end)
local reconsidered_room_event = rfr.add_entity()
rfr.set_event_listener(reconsidered_room_event, "ev_prologue_room_refuse",
	function()
		if rfr.get_flag("reconsidered") then
			rfr.play_cutscene("cs_prologue_player_reconsidered")
		else
			rfr.play_cutscene("cs_prologue_player_leave")
		end
	end)
