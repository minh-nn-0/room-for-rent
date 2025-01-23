local util = require "luamodules.utilities"
local dialogues
local map = require "luamodules.map"
local timer = rfr.add_entity()
local function on_second_floor()
	local ppos = rfr.get_position(PLAYER)
	local opos = rfr.get_position(OWNER)
	return ppos.y == 80 and opos.y == 80
end

local function player_behind()
	local ppos = rfr.get_position(PLAYER)
	local opos = rfr.get_position(OWNER)

	if opos.y == 144 then
		return opos.x > ppos.x and opos.x - ppos.x >= 60
	else
		return opos.x < ppos.x and ppos.x - opos.x >= 60
	end
end
local function owner_ready_to_talk()
	return not rfr.has_active_dialogue(OWNER) and not player_behind()
end
CS_PROLOGUE_HALL = rfr.add_cutscene({
	init = function()
		dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/prologue_" .. config.language .. ".json")
		rfr.fade_in(1)
		rfr.set_flag("prologue_hall")
		map.set_current_map("hall")
		rfr.set_location(PLAYER, "Map.Hall")
		rfr.set_location(OWNER, "Map.Hall")
		rfr.set_position(PLAYER, 530,144)
		rfr.set_position(OWNER, 550,144)

		rfr.set_properties(PLAYER, "walkspeed", 0.7)
		rfr.set_properties(OWNER, "walkspeed", 0.5)

		rfr.set_properties(DOOR_HALL_TO_ROOM, "disable", true)
		rfr.set_state(OWNER, "move")
		rfr.set_properties(OWNER, "facing_direction", "right")
	end,

	exit = function()
		print("EXIT PROLOGUE")
		rfr.unset_flag("prologue_hall")
		rfr.play_cutscene(CS_PROLOGUE_ROOM)
	end,
	scripts = {
		function(dt)
			if owner_ready_to_talk() then
				rfr.set_dialogue(OWNER, {content = rfr.get_dialogue_from_json(dialogues, "owner_greeting2")})
				return true
			end
			return false
		end,
		function(dt)
			if owner_ready_to_talk() then
				rfr.set_dialogue(OWNER, {content = rfr.get_dialogue_from_json(dialogues, "owner_one_room_left")})
				return true
			end
			return false
		end,
		function(dt)
			if owner_ready_to_talk() then
				rfr.set_dialogue(OWNER, {content = rfr.get_dialogue_from_json(dialogues, "owner_cheapest")})
				return true
			end
			return false
		end,
		function(dt)
			if owner_ready_to_talk() then
				rfr.set_dialogue(PLAYER, {content = rfr.get_dialogue_from_json(dialogues, "player_near_school")})
				return true
			end
			return false
		end,
		function(dt)
			if not rfr.has_active_dialogue(PLAYER) then
				rfr.set_dialogue(PLAYER, {content = rfr.get_dialogue_from_json(dialogues, "player_ask_details")})
				return true
			end
			return false
		end,
		function(dt)
			if not rfr.has_active_dialogue(PLAYER) and owner_ready_to_talk() then
				rfr.set_dialogue(OWNER, {content = rfr.get_dialogue_from_json(dialogues, "owner_room_details")})
				return true
			end
			return false
		end,
		function(dt)
			if not rfr.has_active_dialogue(OWNER) then
				rfr.set_dialogue(PLAYER, {content = rfr.get_dialogue_from_json(dialogues, "player_surprised")})
				return true
			end
			return false
		end,
		function(dt)
			if not rfr.has_active_dialogue(PLAYER) and owner_ready_to_talk() and on_second_floor() then
				rfr.set_dialogue(OWNER, {content = rfr.get_dialogue_from_json(dialogues, "owner_no_funding")})
				return true
			end
			return false
		end,
		function(dt)
			if owner_ready_to_talk() then
				rfr.set_dialogue(OWNER, {content = rfr.get_dialogue_from_json(dialogues, "owner_special_price")})
				return true
			end
			return false
		end,
		function(dt)
			if owner_ready_to_talk() then
				rfr.set_dialogue(OWNER, {content = rfr.get_dialogue_from_json(dialogues, "owner_normal_price")})
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
					rfr.set_dialogue(PLAYER, {content = rfr.get_dialogue_from_json(dialogues, "player_agree")})
				else
					rfr.set_dialogue(PLAYER, {content = rfr.get_dialogue_from_json(dialogues, "player_doubt")})
				end
				return true
			end
			return false
		end,
		function(dt)
			if not rfr.has_active_dialogue(PLAYER) then
				local sl = rfr.get_dialogue_options_selection()
				if sl == 0 then
					rfr.set_dialogue(OWNER, {content = rfr.get_dialogue_from_json(dialogues, "owner_invite_room")})
				else
					rfr.set_dialogue(OWNER, {content = rfr.get_dialogue_from_json(dialogues, "owner_defensive")})
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
				if rfr.get_position(OWNER).x <= 420 then
					rfr.set_location(OWNER, "Map.Mainroom")
					rfr.set_state(OWNER, "idle")
					rfr.set_properties(DOOR_HALL_TO_ROOM, "disable", false)
					return true
				end
			end
			return false
		end,
		function(dt)
			if rfr.get_last_interaction() == DOOR_HALL_TO_ROOM then return true end
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
			if owner_pos.y == 144 then
				rfr.set_properties(OWNER, "facing_direction", "right")
			end
			if owner_pos.y == 80 then
				rfr.set_properties(OWNER, "facing_direction", "left")
			end
			if owner_pos.x >= 770 and owner_pos.y == 144 then
				rfr.set_position(OWNER, 770, 1000)
				rfr.set_timer(timer, 2)
			end
			if owner_pos.y == 1000 then
				if not rfr.get_timer(timer).running then
					rfr.set_position(OWNER, 770, 80)
				end
			end
			if not rfr.get_flag("prologue_owner_go_in_room") then
				if owner_pos.x <= 448 and owner_pos.y == 80 then
					rfr.set_state(OWNER, "idle")
					rfr.set_properties(OWNER, "facing_direction", "right")
				else
					rfr.set_state(OWNER, "move")
				end
			end
		end
	end
})
