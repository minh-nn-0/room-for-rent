local scatter_paper = {}
local num = 20
local papers = {}

local scale_speed = 0.5
local rotation_speed = 30
local max_time = 5

local paper_srcxs = {464,480,496}
local function new_paper()
	return {pos = {math.random(70,300), math.random(86, 143)},
			scale = math.random(),
			rotation = math.random(0,360),
			timer = math.random() * 3,
			type = math.random(1, #paper_srcxs)
		}
end
for i = 1,num do
	papers[i] = new_paper()

end
function scatter_paper.update(dt)
	for i,p in ipairs(papers) do
		p.timer = p.timer + dt
		if p.timer >= max_time then papers[i] = new_paper() end
		p.scale = p.scale + scale_speed * dt
		if (p.rotation > 360) then p.rotation = 360 - p.rotation end
		p.rotation = p.rotation + rotation_speed * dt
	end
end

function scatter_paper.draw()
	for _,p in ipairs(papers) do
		local pwidth = 16 * p.scale
		beaver.set_texture_color_mod("tileset", {255,255,255,math.floor(255 - (255 * p.timer / max_time))})
		beaver.draw_texture("tileset", {dst = {x = p.pos[1] - pwidth / 2, y = p.pos[2] - pwidth / 2, w = pwidth, h = pwidth},
										src = {x = paper_srcxs[p.type], y = 80, w = 16, h = 16},
										angle = math.floor(p.rotation),
										pivot = {x = 9, y = 8}
									})
	end
end

function SET_SCATTER_SCALE_SPEED(s) scale_speed = s end
function SET_SCATTER_ROTATION_SPEED(s) rotation_speed = s end

return scatter_paper
