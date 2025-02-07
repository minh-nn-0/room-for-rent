local pickup_card_ev = rfr.add_event(
	function()
		return rfr.get_last_interaction() == CABINET
	end)

rfr.set_event_listener(GAME, pickup_card_ev, function()
	rfr.play_cutscene(require "cutscenes.pickup_card")
	rfr.unset_event_listener(GAME, pickup_card_ev)
end)
