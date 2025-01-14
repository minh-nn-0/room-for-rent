require "cutscenes.pickup_card"
local pickup_card_ev = rfr.add_event(
	function()
		return rfr.get_properties(GAME, "day_number") == 1 and rfr.get_last_interaction() == CABINET
	end)

rfr.set_event_listener(GAME, pickup_card_ev, function()
	rfr.play_cutscene(CS_PICKUP_CARD)
	rfr.unset_event_listener(GAME, pickup_card_ev)
end)
