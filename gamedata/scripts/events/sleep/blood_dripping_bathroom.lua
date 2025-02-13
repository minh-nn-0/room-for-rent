local bloods_dripping_bathroom = {}

local blood_drips = {
	{
		posx = 190,
		period = 5,
		type = 1,
	},
	{
		posx = 210,
		period = 7,
		type = 2,
	}
}
for _,b in ipairs(blood_drips) do
	b.eid = rfr.add_entity()
	rfr.set_position(b.eid, b.posx, 208)
	rfr.set_image(b.eid, ASSETS.images["bloods_ceiling_" .. b.type])
	rfr.set_tileanimation(b.eid, {
		frames = {{1,150},{2,150},{3,150},{4,150},{5,150},{6,150},{7,150},{8,150},{0,150}},
		framewidth = 32,
		frameheight = 32,
		["repeat"] = false
	})

	b.floor = rfr.add_entity()
	rfr.set_image(b.floor, ASSETS.images.bloods_floor)
	rfr.set_tileanimation(b.floor, {
		frames = {{0,150},{1,150},{2,150},{3,150},{4,150},{5,150},{6,150}},
		framewidth = 32,
		frameheight = 20,
		["repeat"] = false
	})
	rfr.set_position(b.floor, b.posx, 253)
end
local appeared = false
function bloods_dripping_bathroom.init()
	rfr.set_layer_visible(MAPS.room, "Map.Bathroom.Bg.splatter", true)
	for _,b in ipairs(blood_drips) do
		rfr.set_location(b.eid, "Map.Bathroom")
		rfr.set_location(b.floor, "Map.Bathroom")
	end
	appeared = true
end

function bloods_dripping_bathroom.appear(yes)
	appeared = yes
end
local bloods = {}
function bloods_dripping_bathroom.update(dt)
	if not appeared then return end
	for _,b in ipairs(blood_drips) do
		local anim = rfr.get_tileanimation(b.eid)
		if math.floor(beaver.get_elapsed_time() % b.period) == 1 and not anim.playing then
			rfr.reset_tileanimation(b.eid)
		end
		if anim.playing then
			if anim.currentid == 6 and bloods[b.floor] == nil then bloods[b.floor] = 5 end
		end
	end
	for i,b in pairs(bloods) do
		if b then
			if b >= 60 then
				beaver.play_sound(ASSETS.audios.waterdrops)
				rfr.reset_tileanimation(i)
				bloods[i] = nil
			else
				bloods[i] = b * 64 * dt
			end
		end
	end

end

function bloods_dripping_bathroom.draw()
	if not appeared then return end
	for i,b in pairs(bloods) do
		if b then
			local blood_pos = rfr.get_position(i)
			beaver.set_draw_color(115,23,45,255)
			beaver.draw_rectangle(blood_pos.x + 15, 208 + b, 2,2,true)
		end
	end
end
return bloods_dripping_bathroom
