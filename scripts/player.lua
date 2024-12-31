local player = {}

function player.load()
	PEID = rfr.add_entity()
	rfr.set_position(PEID, 144, 112)
	rfr.set_image(PEID, "male_shirt")

	rfr.set_state_entry(PEID, "idle",
		function()
			rfr.set_tileanimation(PEID, {
				frames = {{0,400},{1,200},{2,200},{3,200}},
				framewidth = 32,
				frameheight = 32,
				["repeat"] = true
			})
		end)
	rfr.set_state_entry(PEID, "move",
		function()
			rfr.set_tileanimation(PEID, {
				frames = {{4,150},{5,150},{6,150},{7,150},{8,150},{9,150},{10,150},{11,150}},
				framewidth = 32,
				frameheight = 32,
				["repeat"] = true
			})
		end)

	rfr.set_location(PEID, "Map.Mainroom")
	rfr.set_state(PEID, "idle")
end

function player.update(dt)
	local ppos = rfr.get_position(PEID)

	if beaver.get_input("LEFT") > 0 then
		ppos.x = ppos.x - 1.5
		rfr.set_state(PEID, "move")
		rfr.set_flipflag(PEID, beaver.FLIP_H)
		rfr.set_dialogue_position(PEID, 10, -3)
	elseif beaver.get_input("RIGHT") > 0 then
		ppos.x = ppos.x + 1.5
		rfr.set_state(PEID, "move")
		rfr.set_flipflag(PEID, beaver.FLIP_NONE)
	rfr.set_dialogue_position(PEID, 22, -3)
	else
		rfr.set_state(PEID, "idle")
	end

	--if beaver.get_input("S") == 1 then
	--	rfr.set_image(PEID, "female_1")
	--end
	--if beaver.get_input("D") == 1 then
	--	rfr.set_image(PEID, "male_shirt")
	--end
	rfr.set_position(PEID, ppos.x, ppos.y)
end
return player
