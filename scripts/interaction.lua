local interaction = {}
local function get_first_within_player_location()
	for _, eid in ipairs(rfr.get_active_entities()) do
		if rfr.has_interaction(eid) and rfr.get_location(eid) == rfr.get_location(PEID)
			and rfr.is_interaction_available(eid) then
			return eid
		end
	end

	return -1
end

function interaction.update()
	local available_interaction = get_first_within_player_location()

	if available_interaction > 0 then
		--local ppos = rfr.get_position(PEID)
		--rfr.set_position(available_interaction, ppos.x + 16, ppos.y)

		if beaver.get_input(config.button.interaction) == 1 then
			rfr.trigger_interaction(available_interaction)
		end
	end
end

return interaction
