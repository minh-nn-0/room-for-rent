--local room_desk_lamp = rfr.add_entity()
--rfr.set_position(room_desk_lamp, 72,100)
--rfr.set_location(room_desk_lamp, "Map.Mainroom")
--rfr.set_interaction(room_desk_lamp, "Đèn bàn",
--	function()
--		local px,_ = util.player_center()
--		return px >= 60 and px <= 80
--	end,
--	function()
--		lighting.toggle_light("room_desk_lamp")
--	end)
local interaction = {}
local last_interaction
function interaction.get_first_available()
	for _, eid in ipairs(rfr.get_active_entities()) do
		if rfr.has_interaction(eid) and rfr.get_location(eid) == rfr.get_location(PLAYER)
			and rfr.is_interaction_available(eid) and not rfr.get_properties(eid, "disable") then
			return eid
		end
	end
	return -1
end

function interaction.update()
	if rfr.get_flag("player_can_interact") then
		local available_interaction = interaction.get_first_available()
		if available_interaction > 0 then
			--local ppos = rfr.get_position(PLAYER)
			--rfr.set_position(available_interaction, ppos.x + 16, ppos.y)
			if beaver.get_input(config.button.interaction) == 1 then
				rfr.trigger_interaction(available_interaction)
				last_interaction = available_interaction
			end
		end
	end
end

function interaction.get_last() return last_interaction end

return interaction
