local util = require "luamodules.utilities"
local dialogues
CS_PROLOGUE_ARRIVE = rfr.add_cutscene({
	init = function()
		dialogues =util.load_json(rfr.gamepath() .. "data/dialogues/prologue_" .. config.language .. ".json")
		rfr.set_flag("prologue_outside")
		rfr.fade_in(5)
		rfr.set_cam_zoom(2)
		rfr.set_cam_target(PLAYER, 16, -20)
		rfr.set_current_map("outside")
		rfr.set_location(PLAYER, "Map.Outside")
		rfr.set_position(PLAYER, 30, 144)
		rfr.set_properties(PLAYER, "walkspeed", 0.8)
		rfr.unset_flag("player_can_move")
		rfr.unset_flag("player_can_interact")
		rfr.unset_flag("player_can_open_phone")
		rfr.add_tag(PLAYER, "npc")
		rfr.set_state(PLAYER, "move")
		rfr.set_flipflag(PLAYER, beaver.FLIP_NONE)
	end,
	exit = function()
		print("exit prologue_outside")
		rfr.set_flag("player_can_move")
		rfr.set_flag("player_can_interact")
		rfr.set_flag("player_can_open_phone")
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

local owner_pickup_timer = rfr.add_entity()
local cs_prologue_owner_pickup = rfr.add_cutscene({
	init = function()
		rfr.set_timer(owner_pickup_timer, 5)
	end,
	exit = function()
		print("exit owner_pickup")
	end,
	scripts = {
		function(dt)
			if rfr.get_timer(owner_pickup_timer).running then return false end
			rfr.set_position(OWNER, 524,144)
			rfr.set_location(OWNER, "Map.Outside")
			rfr.set_state(OWNER, "idle")
			return true
		end,
	},
	update = function(dt)
		if rfr.get_position(PLAYER).x > rfr.get_position(OWNER).x then
			rfr.set_properties(OWNER, "facing_direction", "right")
		else
			rfr.set_properties(OWNER, "facing_direction", "left")
		end
	end})

local cs_prologue_call_owner = rfr.add_cutscene({
	init = function()
	end,
	exit = function()
		print("end prologue_call_owner")
		rfr.play_cutscene(cs_prologue_owner_pickup)
	end,
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
		function(dt)
			if not (rfr.is_making_phone_call() and rfr.get_phone_callee() == "owner") then return false end
			if rfr.get_phone_wait_time() < 5 then return false end
			rfr.set_phone_dialogue(dialogues["owner_call_pickup"])
			return true
		end,
		function(dt)
			if rfr.phone_caller_active() then return false end
			rfr.set_dialogue(PLAYER, dialogues["player_call_greeting"])
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_phone_dialogue(dialogues["owner_call_greeting"])
			return true
		end,
		function(dt)
			if rfr.phone_caller_active() then return false end
			rfr.set_dialogue(PLAYER, dialogues["player_call_introduce"])
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, dialogues["player_call_arrived"])
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_phone_dialogue(dialogues["owner_call_confirm"])
			return true
		end,
		function(dt)
			if rfr.phone_caller_active() then return false end
			rfr.phone_caller_hangup()
			return true
		end
	},
	update = function(dt) end
})



local read_house_number_first_time = rfr.add_event(
	function()
		return rfr.get_flag("read_house_number")
	end)
rfr.set_event_listener(PLAYER, read_house_number_first_time,
	function()
		rfr.play_cutscene(cs_prologue_call_owner)
		rfr.unset_event_listener(PLAYER, read_house_number_first_time)
	end)

