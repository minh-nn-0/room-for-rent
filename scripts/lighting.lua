local lighting = {}

local bg_color = {255,255,255,255}
local lights = {}
beaver.new_image(rfr.gamepath() .. "assets/images/lights.png", "lights")
beaver.create_texture_for_drawing("shadow", 1280, 720)
beaver.set_texture_blend_mode("shadow", "modulate")
beaver.set_texture_blend_mode("lights", "additive")

lights["room"] = {draw_properties = {dst = {x = 64, y = 80, w = 272, h = 64},
										src = {x = 16, y = 144, w = 272, h = 64}},
					on = false,
					tint = {255,255,255,255},
					location = "Map.Mainroom"}

lights["bathroom"] = {draw_properties = {dst = {x = 112, y = 208, w = 176, h = 64},
										src = {x = 48, y = 144, w = 176, h = 64}},
					on = true,
					tint = {200,216,200,255},
					location = "Map.Bathroom"}
lights["hall_secondfloor_left"] = {draw_properties = {dst = {x = 364, y = 64, w = 272, h = 48},
										src = {x = 16, y = 144, w = 272, h = 48}},
								on = true,
								tint = {220,240,220,255},
								location = "Map.Hall"}
lights["hall_secondfloor_right"] = {draw_properties = {dst = {x = 548, y = 64, w = 272, h = 48},
										src = {x = 16, y = 144, w = 272, h = 48}},
								on = true,
								tint = {220,240,220,255},
								location = "Map.Hall"}
lights["hall_firstfloor_left"] = {draw_properties = {dst = {x = 364, y = 118, w = 272, h = 58},
										src = {x = 16, y = 144, w = 272, h = 58}},
								on = true,
								tint = {220,240,220,255},
								location = "Map.Hall"}
lights["hall_firstfloor_right"] = {draw_properties = {dst = {x = 548, y = 118, w = 272, h = 58},
										src = {x = 16, y = 144, w = 272, h = 58}},
								on = true,
								tint = {220,240,220,255},
								location = "Map.Hall"}
function lighting.set_background_color(r,g,b,a)
	bg_color = {r,g,b,a}
end

function lighting.get_background_color()
	return bg_color
end

function lighting.toggle_light(name)
	lights[name].on = not lights[name].on
end

function lighting.draw()
	beaver.set_using_cam(false)
	beaver.set_render_target("shadow")
	beaver.set_draw_color(bg_color[1], bg_color[2], bg_color[3], bg_color[4])
	beaver.draw_rectangle(0,0,0,0,true)

	for _,light in pairs(lights) do
		if light.on and light.location == rfr.get_location(PLAYER) then
			beaver.set_texture_color_mod("lights", light.tint)
			beaver.draw_texture("lights", light.draw_properties)
			beaver.set_texture_color_mod("lights", {255,255,255,255})
		end
	end

	beaver.set_using_cam(true)
	beaver.set_render_target()
	beaver.draw_texture("shadow", {dst = {x = 0, y = 0, w = 1280, h = 720}})
end

return lighting
