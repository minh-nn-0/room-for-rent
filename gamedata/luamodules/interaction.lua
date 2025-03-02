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

rfr.set_flag("draw_helper")
function interaction.add(pos, condition, action)
	list[#list + 1] = {pos = pos, condition = condition, action = action}
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
	if rfr.get_flag("player_can_interact") and not rfr.having_dialogue_options() then
		current_interaction = interaction.get_first_available()
		if current_interaction > 0 then
			if beaver.get_input(config.button.interaction) == 1 then
				list[current_interaction].action()
				last_interaction = current_interaction
			end
		end
	end
	if current_back and beaver.get_input(config.button.back) == 1 then
		current_back.action()
	end
end

function interaction.draw()
	beaver.set_draw_color(255,255,255,255)
	local itr = interaction.get_current_interaction()
	if itr then
		beaver.draw_texture(ASSETS.images.UI, {dst = {x = itr.pos[1] - 4, y = math.sin(beaver.get_elapsed_time() * 3) * 0.5 + itr.pos[2] - 8, w = 8, h = 8},
												src = {x = 24, y = 48, w = 8, h = 8}})
	end
	if current_back then
		beaver.draw_texture(ASSETS.images.UI, {dst = {x = 20, y = 340, w = 8, h = 8},
												src = {x = 32, y = 32, w = 8, h = 8}})
		beaver.draw_text(30, 340, ASSETS.fonts.unifont, 1, current_back.name)

	end
end

function interaction.get_last() return last_interaction end

return interaction
