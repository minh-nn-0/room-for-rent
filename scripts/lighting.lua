local lighting = {}

local bg_color = {255,255,255,255}
local lights = {}
beaver.new_image(rfr.gamepath() .. "assets/images/lights.png", "lights")
beaver.create_texture_for_drawing("shadow", 1280, 720)
beaver.set_texture_blend_mode("shadow", "modulate")
beaver.set_texture_blend_mode("lights", "additive")
local lightsrc_dimensions = {x = 56, y = 56, w = 190, h = 190}
local lightsource = {
	top = {x = lightsrc_dimensions.x, y = lightsrc_dimensions.y, w = lightsrc_dimensions.w, h = lightsrc_dimensions.h / 2},
	bottom = {x = lightsrc_dimensions.x, y = lightsrc_dimensions.y + lightsrc_dimensions.h / 2, w = lightsrc_dimensions.w, h = lightsrc_dimensions.h / 2},
	left = {x = lightsrc_dimensions.x, y = lightsrc_dimensions.y, w = lightsrc_dimensions.w / 2, h = lightsrc_dimensions.h},
	right = {x = lightsrc_dimensions.x + lightsrc_dimensions.w / 2, y = lightsrc_dimensions.w / 2, h = lightsrc_dimensions.h}
}

local flicker_wait_time = 0.1
lights["room_ceiling"] = {pos = {200, 88},
					scale = 1,
					src = lightsrc_dimensions,
					on = false,
					flicker_rate = 0.01,
					flicker_timer = 0,
					flickering = false,
					tint = {220,150,120,255},
					location = "Map.Mainroom"}

lights["bathroom_ceiling"] = {pos = {216,218},
					scale = 1,
					src = lightsrc_dimensions,
					on = false,
					flicker_rate = 0,
					flicker_timer = 0,
					flickering = false,
					tint = {200,216,200,255},
					location = "Map.Bathroom"
}
--lights["hall_secondfloor_left"] = {draw_properties = {dst = {x = 364, y = 64, w = 272, h = 48},
--										src = {x = 16, y = 144, w = 272, h = 48}},
--								on = false,
--								flicker_rate = 0,
--								flicker_timer = rfr.add_entity(),
--								flickering = false,
--								tint = {220,240,220,255},
--								location = "Map.Hall"}
--lights["hall_secondfloor_right"] = {draw_properties = {dst = {x = 548, y = 64, w = 272, h = 48},
--										src = {x = 16, y = 144, w = 272, h = 48}},
--								on = false,
--								flicker_rate = 0,
--								flicker_timer = rfr.add_entity(),
--								flickering = false,
--								tint = {220,240,220,255},
--								location = "Map.Hall"}
--lights["hall_firstfloor_left"] = {draw_properties = {dst = {x = 364, y = 118, w = 272, h = 58},
--										src = {x = 16, y = 144, w = 272, h = 58}},
--								on = false,
--								flicker_rate = 0,
--								flicker_timer = rfr.add_entity(),
--								flickering = false,
--								tint = {220,240,220,255},
--								location = "Map.Hall"}
--lights["hall_firstfloor_right"] = {draw_properties = {dst = {x = 548, y = 118, w = 272, h = 58},
--										src = {x = 16, y = 144, w = 272, h = 58}},
--								on = false,
--								flicker_rate = 0,
--								flicker_timer = rfr.add_entity(),
--								flickering = false,
--								tint = {220,240,220,255},
--								location = "Map.Hall"}
--
lights["room_sunlight_back"] = {pos = {56, 90},
						scale = 1.5,
						src = lightsrc_dimensions,
						on = true,
						flicker_rate = 0,
						flicker_timer = 0,
						flickering = false,
						tint = {240,240,240,255},
						location = "Map.Mainroom"
					}
lights["room_sunlight_front"] = {pos = {355, 90},
						scale = 1.5,
						src = lightsrc_dimensions,
						on = true,
						flicker_rate = 0,
						flicker_timer = 0,
						flickering = false,
						tint = {240,240,240,255},
						location = "Map.Mainroom"
					}

--
--for _,light in pairs(lights) do rfr.set_timer(light.flicker_timer, flicker_wait_time) end
function lighting.set_background_color(r,g,b,a)
	bg_color = {r,g,b,a}
end

function lighting.get_background_color()
	return bg_color
end

function lighting.toggle_light(name)
	lights[name].on = not lights[name].on
end

function lighting.set_flicker(name, rate)
	lights[name].flicker_rate = rate
end
function lighting.light_flickering(name)
	return lights[name].flickering and lights[name].on
end
function lighting.update(dt)
	local _,tod = rfr.current_time()
	local location = rfr.get_location(PLAYER)
	local color = {}
	if tod == 1 then
		lights["room_sunlight_back"].on = true
		lights["room_sunlight_front"].on = true
		color = {200,200,200,255}
		if location == "Map.Mainroom" or location == "Map.Bathroom" then
			color = {100,100,100,255}
		end
	else
		color = {40,40,80, 255}
		lights["room_sunlight_back"].on = false
		lights["room_sunlight_front"].on = false
	end

	bg_color = color
	for _,light in pairs(lights) do
		if light.on and light.location == rfr.get_location(PLAYER) then
			light.flicker_timer = light.flicker_timer + 1
			if not light.flickering and math.random() < light.flicker_rate then
				light.flickering = true
				light.flicer_timer = 0
			elseif light.flicker_timer > flicker_wait_time then
				light.flickering = false
			end
		end
	end
end
function lighting.draw()
	beaver.set_using_cam(false)
	beaver.set_render_target("shadow")
	beaver.set_draw_color(bg_color[1], bg_color[2], bg_color[3], bg_color[4])
	beaver.draw_rectangle(0,0,0,0,true)

	for _,light in pairs(lights) do
		if light.on and light.location == rfr.get_location(PLAYER) and not light.flickering then
			local dst = {}
			dst.w = light.src.w * light.scale
			dst.h = light.src.h * light.scale

			dst.x = light.pos[1] - dst.w / 2
			dst.y = light.pos[2] - dst.h / 2
			beaver.set_texture_color_mod("lights", light.tint)
			beaver.draw_texture("lights", {dst = dst, src = light.src})
			beaver.set_texture_color_mod("lights", {255,255,255,255})
		end
	end

	beaver.set_using_cam(true)
	beaver.set_render_target()
	beaver.draw_texture("shadow", {dst = {x = 0, y = 0, w = 1280, h = 720}})
end

return lighting
