local camera = {}

function camera.update(dt)
	local ppos = rfr.get_position(PLAYER)
	rfr.set_cam_target(ppos.x + 16, ppos.y)
	rfr.update_camera(dt)
end
return camera
