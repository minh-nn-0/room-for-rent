local camera = {}
local camera_shake = {}
local shake_time = 0
local shake_intensity = 0
function camera_shake.update(dt)
	local offsetx = 0
	local offsety = 0
	if shake_time > 0 then
		offsetx = (math.random() * 2 - 1) * shake_intensity
		offsety = (math.random() * 2 - 1) * shake_intensity

		shake_time = shake_time - dt
		shake_intensity = shake_intensity * 0.9
	end
	rfr.set_cam_offset(offsetx, offsety)
end
function camera.shake(time, intensity)
	shake_time = time
	shake_intensity = intensity
end

local target = PLAYER
local offx = 0
local offy = 0

function camera.set_target(tg, ox, oy)
	target = tg
	offx = ox or 0
	offy = oy or 0
end

local map = require "luamodules.map"

function camera.update(dt)
	camera_shake.update(dt)
	if target then
		local pos = rfr.get_position(target)
		rfr.camera_target(pos.x + offx, pos.y + offy, dt)
	end
	local map_boundary = map.get_cam_boundaries(rfr.get_location(PLAYER))
	if map_boundary then
		rfr.clamp_camera(map_boundary[1], map_boundary[2] - config.render_size[1] / rfr.get_cam_zoom())
	end
end
return camera
