local util = require "luamodules.utilities"
local dialogues
local timer = rfr.add_entity()
local owner_interaction = rfr.add_entity()
local function player_near_gate()
	return math.abs(rfr.get_position(PLAYER).x - 533) <= 80
end
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

		rfr.set_flag("metal_gate_first_time")
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

local cs_prologue_talk_at_gate = rfr.add_cutscene({
	init = function()
		dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/prologue_" .. config.language .. ".json")
		rfr.set_active(owner_interaction, false)
	end,
	exit = function()
		print("exit talk_at_gate")
		rfr.unset_flag("prologue_outside")
		rfr.play_cutscene(CS_PROLOGUE_HALL)
	end,
	scripts = {
		function(dt)
			if rfr.has_active_dialogue(OWNER) then return false end
			rfr.set_dialogue(OWNER, dialogues["owner_greeting"])
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(OWNER) then return false end
			rfr.set_dialogue(OWNER, dialogues["owner_invite_house"])
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(OWNER) then return false end
			rfr.set_location(OWNER, "Map.Hall")
			rfr.set_timer(timer, 10)
			rfr.set_properties(METAL_GATE, "disable", false)
			rfr.unset_flag("metal_gate_first_time")
			return true
		end,
		function(dt)
			if not rfr.get_timer(timer).running then
				if not rfr.has_active_dialogue(OWNER) then rfr.set_dialogue(OWNER, dialogues["owner_confused"]) end
				rfr.set_timer(timer, 10)
			end
			if rfr.get_last_interaction() == METAL_GATE then return true end
			return false
		end,
	},
	update = function(dt)
	end
})

local cs_prologue_owner_pickup = rfr.add_cutscene({
	init = function()
		local interaction_name = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
		rfr.set_timer(timer, 5)
		rfr.set_location(owner_interaction, "Map.Outside")
		rfr.set_position(owner_interaction, 533, 128)
		rfr.set_interaction(owner_interaction, interaction_name["owner"],
			function()
				local px,_ = util.player_center()
				return px >= 520 and px <= 540
			end,
			function()
				rfr.play_cutscene(cs_prologue_talk_at_gate)
			end)
	end,
	exit = function()
		print("exit owner_pickup")
	end,
	scripts = {
		function(dt)
			if rfr.get_timer(timer).running or not player_near_gate() then return false end
			rfr.set_properties(METAL_GATE, "disable", true)
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
			rfr.set_timer(timer, 10)
			return true
		end,
		function(dt)
			if not (rfr.is_making_phone_call() and rfr.get_phone_callee() == "owner") then
				if not rfr.get_timer(timer).running and not rfr.has_active_dialogue(PLAYER) then
					if math.random() < 0.5 then rfr.set_dialogue(PLAYER, dialogues["player_should_call"]) end
	 				rfr.set_timer(timer, 10)
				end
				return false
			end
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

