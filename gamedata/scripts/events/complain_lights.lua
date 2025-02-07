local util = require "luamodules.utilities"
local dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/events/complain_lights_" .. config.language .. ".json")
local lighting = require "lighting"
local light_flickering = rfr.add_event(
	function()
		return lighting.light_flickering("room_ceiling")
	end)

rfr.set_event_listener(PLAYER, light_flickering,
	function()
		rfr.set_dialogue(PLAYER, {content = dialogues["complain"]})
		rfr.unset_event_listener(PLAYER, light_flickering)
	end)
