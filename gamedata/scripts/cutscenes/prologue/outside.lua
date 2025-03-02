local camera = require "luamodules.camera"
local character = require "character"
local map = require "luamodules.map"
local util = require "luamodules.utilities"
local dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/prologue_" .. config.language .. ".json")
local timer = rfr.add_entity()
local owner_interaction
local call = require "phone.apps.call"
local interaction = require "luamodules.interaction"

local gate_posx = 424
local function player_near_gate()
	return math.abs(rfr.get_position(PLAYER).x - gate_posx) <= 80
end


CS_PROLOGUE_ARRIVE = rfr.add_cutscene({
	init = function()
		rfr.set_flag("prologue")
		rfr.set_flag("prologue_outside")
		rfr.fade_in(5)
		rfr.set_cam_zoom(2)
		camera.set_target(PLAYER, 16, -43)
		map.set_current_map("outside")
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
			rfr.set_dialogue(PLAYER, {content = dialogues["player_arrive1"]})
			return true
		end,
	},
	update = function(dt) end
})

local cs_prologue_talk_at_gate = rfr.add_cutscene({
	init = function()
		dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/prologue_" .. config.language .. ".json")
		interaction.set_active(owner_interaction, false)
	end,
	exit = function()
		print("exit talk_at_gate")
		rfr.unset_flag("prologue_outside")
		rfr.play_cutscene(CS_PROLOGUE_HALL)
	end,
	scripts = {
		function(dt)
			if rfr.has_active_dialogue(OWNER) then return false end
			rfr.set_dialogue(OWNER, {content = character.getTextByCharacter(dialogues["owner_greeting"], 'main')} )
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(OWNER) then return false end
			rfr.set_dialogue(OWNER, {content = dialogues["owner_invite_house"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(OWNER) then return false end
			rfr.set_location(OWNER, "Map.Hall")
			rfr.set_timer(timer, 10)
			interaction.set_active(METAL_GATE_OUTSIDE, true)
			rfr.unset_flag("metal_gate_first_time")
			return true
		end,
		function(dt)
			if not rfr.get_timer(timer).running then
				if not rfr.has_active_dialogue(OWNER) then rfr.set_dialogue(OWNER, {content = dialogues["owner_confused"]}) end
				rfr.set_timer(timer, 10)
			end
			if interaction.get_last() == METAL_GATE_OUTSIDE then return true end
			return false
		end,
	},
	update = function(dt)
	end
})

local cs_prologue_owner_pickup = rfr.add_cutscene({
	init = function()
		rfr.set_timer(timer, 5)
		owner_interaction = interaction.add({424, 142},
			function()
				local px,_ = util.player_center()
				return px >= gate_posx - 10 and px <= gate_posx + 10 and rfr.get_location(PLAYER) == "Map.Outside"
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
			interaction.set_active(METAL_GATE_OUTSIDE, false)
			rfr.set_position(OWNER, gate_posx - 16,144)
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
		print("call_owner")
	end,
	exit = function()
		print("end prologue_call_owner")
		rfr.play_cutscene(cs_prologue_owner_pickup)
	end,
	scripts = {
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, {content = dialogues["player_correct_address"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, {content = dialogues["player_should_call"]})
			rfr.set_timer(timer, 10)
			return true
		end,
		function(dt)
			if not (call.is_making_phone_call() and call.get_callee() == "owner") then
				if not rfr.get_timer(timer).running and not rfr.has_active_dialogue(PLAYER) then
					if math.random() < 0.5 then rfr.set_dialogue(PLAYER, {content = dialogues["player_should_call"]}) end
	 				rfr.set_timer(timer, 10)
				end
				return false
			end
			if call.get_waited_time() < 5 then return false end
			call.set_dialogue(dialogues["owner_call_pickup"])
			return true
		end,
		function(dt)
			if call.caller_active() then return false end
			rfr.set_dialogue(PLAYER, {content = character.getTextByCharacter(dialogues["player_call_greeting"], 'woman')} )
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			call.set_dialogue(dialogues["owner_call_greeting"])
			return true
		end,
		function(dt)
			if call.caller_active() then return false end
			rfr.set_dialogue(PLAYER, {content = dialogues["player_call_introduce"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, {content = dialogues["player_call_arrived"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			call.set_dialogue(dialogues["owner_call_confirm"])
			return true
		end,
		function(dt)
			if call.caller_active() then return false end
			call.caller_hangup()
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

