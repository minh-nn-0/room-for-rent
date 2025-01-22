local util = require "luamodules.utilities"
local dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/events/complain_lights_" .. config.language .. ".json")
local lighting = require "lighting"
local light_flickering = rfr.add_event(
	function()
		local d,tod = rfr.current_time()
		return d == 1 and tod == 2 and lighting.light_flickering("room_ceiling")
	end)

rfr.set_event_listener(PLAYER, light_flickering,
	function()
		rfr.set_dialogue(PLAYER, {content = dialogues["complain"]})
		lighting.set_flicker("room_ceiling", 0)
		rfr.unset_event_listener(PLAYER, light_flickering)
	end)
