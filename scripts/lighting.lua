local lighting = {}

local bg_color = {255,255,255,255}
local lights = {}
beaver.new_image(rfr.gamepath() .. "assets/images/lights.png", "lights")
beaver.create_texture_for_drawing("shadow", 1280, 720)
beaver.set_texture_blend_mode("shadow", "modulate")
beaver.set_texture_blend_mode("lights", "additive")

lights["room_ceiling"] = {draw_properties = {dst = {x = 64, y = 80, w = 256, h = 64},
										src = {x = 44, y = 80, w = 256, h = 64}},
							on = false}


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
		if light.on then
			beaver.draw_texture("lights", light.draw_properties)
		end
	end

	beaver.set_using_cam(true)
	beaver.set_render_target()
	beaver.draw_texture("shadow", {dst = {x = 0, y = 0, w = 1280, h = 720}})
end

return lighting
