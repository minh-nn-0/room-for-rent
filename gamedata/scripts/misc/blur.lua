local blur = {}

blur.eid = rfr.add_entity()

rfr.set_image(blur.eid, ASSETS.images.blur)
rfr.set_tileanimation(blur.eid, {
	frames = {{0,150},{1,150},{2,150},{3,150},{4,150},{5,150},{6,150},{7,150}},
	framewidth = 8,
	frameheight = 8,
	["repeat"] = true
})

local attaching = false
function blur.attach()
	attaching = true
end
function blur.deattach()
	attaching = false
	rfr.set_position(blur.eid, 1000,1000)
end

function blur.update()
	if attaching then
		local ppos = rfr.get_position(PLAYER)
		local plocation = rfr.get_location(PLAYER)
		local facing_left = rfr.get_flipflag(PLAYER) == beaver.FLIP_H

		rfr.set_location(blur.eid, plocation)
		rfr.set_position(blur.eid, facing_left and ppos.x + 11 or ppos.x + 13, ppos.y + 20)
	end
end

return blur

