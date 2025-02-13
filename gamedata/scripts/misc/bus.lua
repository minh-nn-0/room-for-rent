local bus = {}
bus.eid = rfr.add_entity()
rfr.set_image(bus.eid, ASSETS.images.tileset)
rfr.set_image_source(bus.eid, 478, 0, 130, 55)
rfr.set_location(bus.eid, "Map.Outside")
rfr.set_position(bus.eid, 1000,1000)

rfr.set_particle_emitter_config(bus.eid, {
	linear_acceleration = {x = 0, y = -30},
	color_gradient = {
		{time = 0.0, color = {255,228,255,255}},
		{time = 1.0, color = {255,228,255,0}},
	},
	area = {x = -8, y = 8},
	direction = math.rad(0),
	spread = math.rad(30),
	size_variation = {min = 2, max = 5},
	speed_variation = {min = 20, max = 30},
	lifetime = 1.5,
})

rfr.set_particle_emitter_auto(bus.eid, false)
local osc_speed = 20
local bus_moving = false
local bus_speed = 50

function bus.appear()
	rfr.set_position(bus.eid, 500, 136)
	bus.start()
end
function bus.stop()
	osc_speed = 50
	bus_moving = false
end

function bus.start()
	osc_speed = 20
	bus_moving = true
end

function bus.visible()
	return rfr.get_position(bus.eid).x <= -130
end
function bus.update(dt)
	local buspos = rfr.get_position(bus.eid)
	if bus_moving then buspos.x = buspos.x - bus_speed * dt end
	buspos.y = 136 + math.sin(beaver.get_elapsed_time() * osc_speed) * 0.3
	rfr.set_position(bus.eid, buspos.x, buspos.y)
end
return bus
