local camera_shake = {}
local shake_time = 0
local shake_intensity = 0
function camera_shake.active(time, intensity)
	shake_time = time
	shake_intensity = intensity
end

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

return camera_shake
