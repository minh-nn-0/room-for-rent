local util = require "luamodules.utilities"
local dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/events/call_mom_first_time_" .. config.language .. ".json")

local call_timer = rfr.add_entity()
local cs_call_mom_first_time = rfr.add_cutscene({
	init = function()
		rfr.set_timer(call_timer, 3)
	end,
	exit = function() end,
	scripts = {
		function(dt)
			if rfr.get_timer(call_timer).running then return false end
			rfr.set_phone_dialogue(dialogues["mom_greeting"])
			return true
		end,
		function(dt)
			if rfr.phone_caller_active() then return false end
			rfr.set_dialogue(PLAYER, {content = dialogues["player_respond"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_phone_dialogue(dialogues["mom_remind"])
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
local call_mom_ev = rfr.add_event(
	function()
		return rfr.is_making_phone_call() and rfr.get_phone_callee() == "mom"
	end)

rfr.set_event_listener(PLAYER, call_mom_ev,
	function()
		rfr.play_cutscene(cs_call_mom_first_time)
		rfr.unset_event_listener(PLAYER, call_mom_ev)
	end)
