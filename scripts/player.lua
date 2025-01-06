require "cutscenes.prologue"
local player = {}

PLAYER = rfr.add_entity()
rfr.set_properties(PLAYER, "walkspeed", 1)
rfr.set_properties(PLAYER, "can_move", true)
rfr.set_properties(PLAYER, "can_interact", true)
rfr.set_position(PLAYER, 144, 112)
rfr.set_location(PLAYER, "Map.Mainroom")
rfr.set_dialogue_position(PLAYER, 16, -3)
rfr.set_image(PLAYER, "male_shirt")
rfr.set_state_entry(PLAYER, "idle",
	function()
		rfr.set_tileanimation(PLAYER, {
			frames = {{0,400},{1,200},{2,200},{3,200}},
			framewidth = 32,
			frameheight = 32,
			["repeat"] = true
		})
	end)
rfr.set_state_entry(PLAYER, "move",
	function()
		local speed = config.base_character_move_animation_speed / rfr.get_properties(PLAYER, "walkspeed")
		rfr.set_tileanimation(PLAYER, {
			frames = {{4,speed},{5,speed},{6,speed},{7,speed},{8,speed},{9,speed},{10,speed},{11,speed}},
			framewidth = 32,
			frameheight = 32,
			["repeat"] = true
		})
	end)
rfr.set_state(PLAYER, "idle")

function player.update(dt)
	local ppos = rfr.get_position(PLAYER)
	local walkspeed = rfr.get_properties(PLAYER, "walkspeed")

	if rfr.get_properties(PLAYER, "can_move") then
		if beaver.get_input("LEFT") > 0 then
			ppos.x = ppos.x - walkspeed
			rfr.set_state(PLAYER, "move")
			rfr.set_flipflag(PLAYER, beaver.FLIP_H)
			rfr.set_dialogue_position(PLAYER, 10, -3)
		elseif beaver.get_input("RIGHT") > 0 then
			ppos.x = ppos.x + walkspeed
			rfr.set_state(PLAYER, "move")
			rfr.set_flipflag(PLAYER, beaver.FLIP_NONE)
			rfr.set_dialogue_position(PLAYER, 22, -3)
		else
			rfr.set_state(PLAYER, "idle")
		end
	end

	--print(ppos.x + 16, ppos.y + 16)
	if beaver.get_input("S") == 1 then
		rfr.set_image(PLAYER, "girl")
	end
	if beaver.get_input("D") == 1 then
		rfr.set_dialogue_options("Đồng ý xem phòng", "Nghi ngờ")
	end

	rfr.set_position(PLAYER, ppos.x, ppos.y)
	if beaver.get_input("E") == 1 then
		rfr.play_cutscene("cs_prologue_room")
	end

	if rfr.having_dialogue_options() then
		rfr.set_properties(PLAYER, "can_interact", false)
		if beaver.get_input("UP") == 1 then rfr.decrement_dialogue_options_selection() end
		if beaver.get_input("DOWN") == 1 then rfr.increment_dialogue_options_selection() end
		if beaver.get_input(config.button.interaction) == 1 then rfr.select_dialogue_options_selection() end
	else rfr.set_properties(PLAYER, "can_interact", true)
	end
end

return player
