local lighting = {}

local bg_color = {255,255,255,255}
local lights = {}
beaver.new_image(rfr.gamepath() .. "assets/images/lights.png", "lights")
beaver.create_texture_for_drawing("shadow", 1280, 720)
beaver.set_texture_blend_mode("shadow", "modulate")
beaver.set_texture_blend_mode("lights", "additive")
local lightsource = {
	round = {x = 56, y = 65, w = 190, h = 190},
	cone = {x = 377, y = 91, w = 146, h = 119}
}

local flicker_wait_time = 0.1
lights["room_ceiling"] = {pos = {200, 88},
					scale = 1.5,
					src = lightsource.round,
					on = false,
					flicker_rate = 0.01,
					flicker_timer = 0,
					flickering = false,
					tint = {220,150,120,255},
					location = "Map.Mainroom"}

lights["bathroom_ceiling"] = {pos = {216,218},
					scale = 1,
					src = lightsource.round,
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
						src = lightsource.round,
						on = true,
						flicker_rate = 0,
						flicker_timer = 0,
						flickering = false,
						tint = {240,240,240,255},
						location = "Map.Mainroom"
					}
lights["room_sunlight_front"] = {pos = {355, 90},
						scale = 1.5,
						src = lightsource.round,
						on = true,
						flicker_rate = 0,
						flicker_timer = 0,
						flickering = false,
						tint = {240,240,240,255},
						location = "Map.Mainroom"
					}
lights["outside_pole_round"] = {pos = {318,86},
						scale = 1,
						src = lightsource.round,
						flicker_rate = 0,
						flicker_timer = 0,
						flickering = false,
						tint = {255,235,63,120},
						location = "Map.Outside"
					}
lights["outside_pole_cone"] = {pos = {318,128},
						scale = 1,
						src = lightsource.cone,
						flicker_rate = 0,
						flicker_timer = 0,
						flickering = false,
						tint = {255,235,63,255},
						location = "Map.Outside"
					}

local hall_light_color = {230,180,160, 200}
lights["hall_first_left"] = {pos = {480,159},
						scale = 0.7,
						src = {x = lightsource.round.x , y = lightsource.round.y + lightsource.round.h / 2, w = lightsource.round.w, h = lightsource.round.h / 2},
						flicker_rate = 0,
						flicker_timer = 0,
						flickering = false,
						tint = hall_light_color,
						location = "Map.Hall"
					}
lights["hall_first_right"] = {pos = {592,159},
						scale = 0.7,
						src = {x = lightsource.round.x , y = lightsource.round.y + lightsource.round.h / 2, w = lightsource.round.w, h = lightsource.round.h / 2},
						flicker_rate = 0,
						flicker_timer = 0,
						flickering = false,
						tint = hall_light_color,
						location = "Map.Hall"
					}
lights["hall_second_left"] = {pos = {480,111},
						scale = 0.7,
						src = {x = lightsource.round.x , y = lightsource.round.y + lightsource.round.h / 2, w = lightsource.round.w, h = lightsource.round.h / 2},
						flicker_rate = 0,
						flicker_timer = 0,
						flickering = false,
						tint = hall_light_color,
						location = "Map.Hall"
					}
lights["hall_second_right"] = {pos = {592,111},
						scale = 0.7,
						src = {x = lightsource.round.x , y = lightsource.round.y + lightsource.round.h / 2, w = lightsource.round.w, h = lightsource.round.h / 2},
						flicker_rate = 0,
						flicker_timer = 0,
						flickering = false,
						tint = hall_light_color,
						location = "Map.Hall"
					}
lights["hall_second_left_outside"] = {pos = {480,111},
						scale = 0.7,
						src = {x = lightsource.round.x , y = lightsource.round.y + lightsource.round.h / 2, w = lightsource.round.w, h = lightsource.round.h / 2},
						flicker_rate = 0,
						flicker_timer = 0,
						flickering = false,
						tint = hall_light_color,
						location = "Map.Outside"
					}
lights["hall_second_right_outside"] = {pos = {592,111},
						scale = 0.7,
						src = {x = lightsource.round.x , y = lightsource.round.y + lightsource.round.h / 2, w = lightsource.round.w, h = lightsource.round.h / 2},
						flicker_rate = 0,
						flicker_timer = 0,
						flickering = false,
						tint = hall_light_color,
						location = "Map.Outside"
					}
lights["room_dream_ceiling"] = {pos = {200, 88},
					scale = 1,
					src = lightsource.round,
					on = false,
					flicker_rate = 0.002,
					flicker_timer = 0,
					flickering = false,
					tint = {60,50,20,255},
					location = "Map.Dream"}
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
	if not rfr.get_flag("dreaming") then
		local color = {}
		if tod == 1 then
			lights["room_sunlight_back"].on = true
			lights["room_sunlight_front"].on = true
			lights["outside_pole_round"].on = false
			lights["outside_pole_cone"].on = false
			lights["hall_first_left"].on = false
			lights["hall_first_right"].on = false
			lights["hall_second_left"].on = false
			lights["hall_second_right"].on = false
			lights["hall_second_left_outside"].on = false
			lights["hall_second_right_outside"].on = false
			color = {240,240,240,255}
			if location == "Map.Mainroom" or location == "Map.Bathroom" then
				color = {140,140,140,255}
			end
		else
			color = {20,20,40, 255}
			lights["room_sunlight_back"].on = false
			lights["room_sunlight_front"].on = false
			lights["outside_pole_round"].on = true
			lights["outside_pole_cone"].on = true
			lights["hall_first_left"].on = true
			lights["hall_first_right"].on = true
			if location == "Map.Outside" then
				lights["hall_second_left"].on = false
				lights["hall_second_right"].on = false
				lights["hall_second_left_outside"].on = true
				lights["hall_second_right_outside"].on = true
			end
			if location == "Map.Hall" then
				lights["hall_second_left"].on = true
				lights["hall_second_right"].on = true
				lights["hall_second_left_outside"].on = false
				lights["hall_second_right_outside"].on = false
			end
		end

		bg_color = color
	end
	for _,light in pairs(lights) do
		if light.on and light.location == location then
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
