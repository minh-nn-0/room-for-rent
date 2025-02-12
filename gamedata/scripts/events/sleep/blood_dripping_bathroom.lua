local bloods_dripping_bathroom = {}

local onceiling = rfr.add_entity()
local ceiling_pos = {190, 208}
rfr.set_image(onceiling, "bloods_bathroom_ceiling")
rfr.set_tileanimation(onceiling, {
	frames = {{1,150},{2,150},{3,150},{4,150},{5,150},{6,150},{7,150},{8,150},{9,150},{0,150}},
	framewidth = 64,
	frameheight = 32,
	["repeat"] = false
})
rfr.set_position(onceiling, ceiling_pos[1], ceiling_pos[2])
rfr.set_location(onceiling, "Map.Bathroom")

local floor = {rfr.add_entity(),rfr.add_entity()}

rfr.set_image(floor[1], "bloods_bathroom_floor")
rfr.set_image(floor[2], "bloods_bathroom_floor")

rfr.set_tileanimation(floor[1], {
	frames = {{0,150},{1,150},{2,150},{3,150},{4,150},{5,150},{6,150}},
	framewidth = 32,
	frameheight = 20,
	["repeat"] = false
})
rfr.set_tileanimation(floor[2], {
	frames = {{0,150},{1,150},{2,150},{3,150},{4,150},{5,150},{6,150}},
	framewidth = 32,
	frameheight = 20,
	["repeat"] = false
})

rfr.set_position(floor[1], 191, 252)
rfr.set_position(floor[2], 209, 252)
rfr.set_location(floor[1], "Map.Bathroom")
rfr.set_location(floor[2], "Map.Bathroom")
local bloods = {}
local period = 5
function bloods_dripping_bathroom.update(dt)
	local ceiling_animation = rfr.get_tileanimation(onceiling)
	if math.floor(beaver.get_elapsed_time() % period) == 1 and not ceiling_animation.playing then
		print("hihi")
		rfr.reset_tileanimation(onceiling)
	end
	if ceiling_animation.playing then
		if ceiling_animation.currentid == 6 and bloods[1] == nil then bloods[1] = 6 end
		if ceiling_animation.currentid == 7 and bloods[2] == nil then bloods[2] = 3 end
	end

	for i,b in pairs(bloods) do
		if b then
			if b >= 62 then
				beaver.play_sound("waterdrops")
				rfr.reset_tileanimation(floor[i])
				bloods[i] = nil
			else
				bloods[i] = b * 64 * dt
			end
		end
		print(i, b)
	end

end

function bloods_dripping_bathroom.draw()
	for i,b in pairs(bloods) do
		if b then
			local blood_posx = i == 1 and ceiling_pos[1] + 13 or ceiling_pos[1] + 32
			beaver.set_draw_color(115,23,45,255)
			beaver.draw_rectangle(blood_posx, ceiling_pos[2] + b, 2,2,true)
		end
	end
end
return bloods_dripping_bathroom
