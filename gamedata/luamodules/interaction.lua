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
local list = {}
local disabled = {}
local current_interaction = -1
local current_back = nil
local last_interaction

function interaction.add(name, condition, action)
	list[#list + 1] = {name = name, condition = condition, action = action}
	return #list
end

function interaction.set_active(id, active)
	disabled[id] = active
end

function interaction.set_back(name, action)
	current_back = {name = name, action = action}
end

function interaction.unset_back()
	current_back = nil
end

function interaction.get_current_interaction()
	return list[current_interaction] and list[current_interaction] or nil
end

function interaction.get_current_back()
	return current_back
end
function interaction.get_first_available()
	for id, itrt in ipairs(list) do
		if not disabled[id] and itrt.condition() then
			return id
		end
	end
	return -1
end

function interaction.update()
	if rfr.get_flag("player_can_interact") then
		current_interaction = interaction.get_first_available()
		if current_interaction > 0 then
			if beaver.get_input(config.button.interaction) == 1 then
				list[current_interaction].action()
				last_interaction = current_interaction
			end
		end
		if current_back and beaver.get_input(config.button.back) == 1 then
			current_back.action()
		end
	end
end

function interaction.get_last() return last_interaction end

return interaction
