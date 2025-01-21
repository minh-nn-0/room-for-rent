local util = require "luamodules.utilities"
local dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/events/complain_no_shower_" .. config.language .. ".json")
local no_shower_ev = rfr.add_event(
	function()
		local d,_ = rfr.current_time()
		return d > 1 and not rfr.get_day_flag(d - 1, "showered")
	end)

rfr.set_event_listener(GAME, no_shower_ev,
	function()
		local d,_ = rfr.current_time()
		if not rfr.get_day_flag(d, "complain_no_shower") then
			if rfr.get_location(PLAYER) == "Map.Mainroom" and not rfr.has_active_dialogue(PLAYER) then
				rfr.set_dialogue(PLAYER, {content = dialogues["noshower"]})
				rfr.set_day_flag(d, "complain_no_shower")
			end
		end
	end)
