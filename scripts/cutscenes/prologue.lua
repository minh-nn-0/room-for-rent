local dialogues = rfr.load_dialogue(rfr.gamepath() .. "data/dialogues/prologue.json")
local function on_second_floor()
	local ppos = rfr.get_position(PLAYER)
	local opos = rfr.get_position(OWNER)
	return ppos.y == 64 and opos.y == 64
end

local function player_behind()
	local ppos = rfr.get_position(PLAYER)
	local opos = rfr.get_position(OWNER)

	if opos.y == 240 then
		return opos.x > ppos.x and opos.x - ppos.x >= 60
	else
		return opos.x < ppos.x and ppos.x - opos.x >= 60
	end
end
local function owner_ready_to_talk()
	return not rfr.has_active_dialogue(OWNER) and not player_behind()
end

local cs_can_exit = false
rfr.add_cutscene({
	name = "prologue_hall",
	init = function()
		rfr.set_flag("prologue_hall")
		rfr.set_current_map("hall")
		rfr.set_location(PLAYER, "Map.Hall")
		rfr.set_location(OWNER, "Map.Hall")
		rfr.set_position(PLAYER, 16,240)
		rfr.set_position(OWNER, 32,240)

		rfr.set_properties(PLAYER, "walkspeed", 0.7)
		rfr.set_properties(OWNER, "walkspeed", 0.5)

		rfr.set_state(OWNER, "move")
		rfr.set_properties(OWNER, "facing_direction", "right")
	end,

	exit = function() print("EXIT PROLOGUE") end,
	scripts = {
		function(dt)
			if owner_ready_to_talk() then
				rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_greeting"))
				return true
			end
			return false
		end,
		function(dt)
			if owner_ready_to_talk() then
				rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_one_room_left"))
				return true
			end
			return false
		end,
		function(dt)
			if owner_ready_to_talk() then
				rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_cheapest"))
				return true
			end
			return false
		end,
		function(dt)
			if owner_ready_to_talk() then
				rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_near_school"))
				return true
			end
			return false
		end,
		function(dt)
			if not rfr.has_active_dialogue(PLAYER) then
				rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_ask_details"))
				return true
			end
			return false
		end,
		function(dt)
			if not rfr.has_active_dialogue(PLAYER) and owner_ready_to_talk() then
				rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_room_details"))
				return true
			end
			return false
		end,
		function(dt)
			if not rfr.has_active_dialogue(OWNER) then
				rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_surprised"))
				return true
			end
			return false
		end,
		function(dt)
			if not rfr.has_active_dialogue(PLAYER) and owner_ready_to_talk() and on_second_floor() then
				rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_no_funding"))
				return true
			end
			return false
		end,
		function(dt)
			if owner_ready_to_talk() then
				rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_special_price"))
				return true
			end
			return false
		end,
		function(dt)
			if owner_ready_to_talk() then
				rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_normal_price"))
				return true
			end
			return false
		end,
		function(dt)
			if not rfr.has_active_dialogue(OWNER) then
				rfr.set_dialogue_options(rfr.get_dialogue_options_from_json(dialogues, "player_choice"))
				return true
			end
			return false
		end,
		function(dt)
			if not rfr.having_dialogue_options() then
				local sl = rfr.get_dialogue_options_selection()
				if sl == 0 then
					rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_agree"))
				else
					rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_doubt"))
				end
				return true
			end
			return false
		end,
		function(dt)
			if not rfr.has_active_dialogue(PLAYER) then
				local sl = rfr.get_dialogue_options_selection()
				if sl == 0 then
					rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_invite"))
				else
					rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_defensive"))
				end
				return true
			end
			return false
		end,
		function(dt)
			if not rfr.has_active_dialogue(OWNER) then
				rfr.set_flag("prologue_owner_go_in_room")
				rfr.set_properties(OWNER, "facing_direction", "left")
				rfr.set_state(OWNER, "move")
				if rfr.get_position(OWNER).x <= 30 then
					rfr.set_location(OWNER, "Map.Mainroom")
					rfr.set_state(OWNER, "idle")
					cs_can_exit = true
					return true
				end
			end
			return false
		end
	},
	update = function(dt)
		local owner_pos = rfr.get_position(OWNER)
		local ppos = rfr.get_position(PLAYER)
		if player_behind() then
			rfr.set_state(OWNER, "idle")
			rfr.set_properties(OWNER, "facing_direction", owner_pos.x > ppos.x and "left" or "right")
		else
			if owner_pos.y == 240 then
				rfr.set_properties(OWNER, "facing_direction", "right")
			end
			if owner_pos.y == 64 then
				rfr.set_properties(OWNER, "facing_direction", "left")
			end
			if owner_pos.x >= 294 and owner_pos.y == 240 then
				rfr.set_position(OWNER, 288, 64)
			end
			if not rfr.get_flag("prologue_owner_go_in_room") then
				if owner_pos.x <= 64 and owner_pos.y == 64 then
					rfr.set_state(OWNER, "idle")
					rfr.set_properties(OWNER, "facing_direction", "right")
				else
					rfr.set_state(OWNER, "move")
				end
			end
		end

		if cs_can_exit then
			cs_can_exit = false
			return true
		end
		return false
	end
})

rfr.add_event("prologue_player_open_door",
	function()
		return rfr.get_flag("prologue_hall") and rfr.get_current_map() == "room"
	end)

local open_door_to_room = rfr.add_entity()
rfr.set_event_listener(open_door_to_room, "prologue_player_open_door",
	function()
		rfr.play_cutscene("prologue_room")
	end)


local cam_target1 = rfr.add_entity()
rfr.set_position(cam_target1, 80, 112)
local cam_delay = rfr.add_entity()
rfr.add_cutscene({
	name = "prologue_room",
	init = function()
		rfr.unset_flag("prologue_hall")
		rfr.set_flag("prologue_room")
		rfr.fade_in(3)
		rfr.set_timer(cam_delay, 1)
		rfr.set_location(OWNER, "Map.Mainroom")
		rfr.set_position(OWNER, 278, 112)
		rfr.set_state(OWNER, "idle")
		rfr.set_properties(OWNER, "facing_direction", "left")

		rfr.set_dialogue(PLAYER, "")
		rfr.set_dialogue(OWNER, "")
		rfr.set_cam_target(cam_target1)
	end,
	scripts = {
		function(dt)
			if not rfr.get_timer(cam_delay).running then
				rfr.set_dialogue_options(rfr.get_dialogue_options_from_json(dialogues, "player_choice_take_room"))
				return true
			end
			return false
		end,
		function(dt)
			if not rfr.having_dialogue_options() then
				local sl = rfr.get_dialogue_options_selection()
				if sl == 0 then
					rfr.set_flag("accept_room")
					rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_accept_room"))
				else
					rfr.set_flag("refuse_room")
					rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_refuse_room"))
				end
				return true
			end
			return false
		end,
		function(dt)
			if not rfr.has_active_dialogue(PLAYER) then
				if rfr.get_flag("accept_room") then
					rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_sign"))
					return true
				elseif rfr.get_flag("refuse_room") then
					rfr.set_dialogue_options(rfr.get_dialogue_options_from_json(dialogues, "player_choice_reconsider"))
					return true
				end
			end
			return false
		end,
		function(dt)
			if rfr.get_flag("refuse_room") then
				if not rfr.having_dialogue_options() then
					local sl = rfr.get_dialogue_options_selection()
					if sl == 0 then
						rfr.set_flag("leaving_at_prologue")
						rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_leave"))
					else
						rfr.set_flag("reconsidered")
						rfr.set_dialogue(PLAYER, rfr.get_dialogue_from_json(dialogues, "player_reconsider"))
					end
					return true
				end
			else
				if not rfr.has_active_dialogue(PLAYER) then
					rfr.set_dialogue(OWNER, rfr.get_dialogue_from_json(dialogues, "owner_sign"))
					return true
				end
			end
			return false
		end,
	},
	update = function(dt)
		if rfr.get_timer(cam_delay).running then return false end
		local cam_target_pos = rfr.get_position(cam_target1)
		if cam_target_pos.x <= 320 then
			cam_target_pos.x = cam_target_pos.x + 70 * dt
			rfr.set_position(cam_target1, cam_target_pos.x, cam_target_pos.y)
		else
			rfr.set_cam_target(PLAYER, 16, 0)
		end
		return false
	end,
	exit = function() end
})


