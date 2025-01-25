local outside = {}

local clouds = {}

local clouds_srcs = {
	{x = 0, y = 0, w = 121, h = 51},
	{x = 124, y = 0, w = 41, h = 24},
	{x = 121, y = 28 , w = 52, h = 26},
	{x = 112, y = 62, w = 56, h = 16},
	{x = 0, y = 90, w = 72, h = 32},
}

local max_cloud_number = 8
local clouds_present = {}

local function new_cloud(posx)
	return {x = posx, y = math.random(30,60), type = math.random(1, #clouds_srcs)}
end

for i = 1, max_cloud_number do
	clouds_present[i] = new_cloud(math.random(0, 800))
end
function clouds.update(dt)
	for i = 1,max_cloud_number do
		local cloud = clouds_present[i]
		cloud.x = cloud.x - 10 * dt
		if cloud.x < - clouds_srcs[cloud.type].w then
			clouds_present[i] = new_cloud(math.random(700,1000))
		end
	end
end

function clouds.draw()
	for _,c in ipairs(clouds_present) do
		local csrc = clouds_srcs[c.type]
		beaver.draw_texture("clouds", {dst = {x = c.x, y = c.y, w = csrc.w, h = csrc.h}, src = csrc})
	end
end

function outside.update(dt)
	clouds.update(dt)
end

function outside.draw()
	if plocation == "Map.Outside" or plocation == "Map.Hall" then
		beaver.set_draw_color(115,190,211,255)
	else
		beaver.set_draw_color(10,10,10,255)
	end
	beaver.draw_rectangle(0,0,0,0,true)
	clouds.draw()
end
return outside
