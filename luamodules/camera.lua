local target = PLAYER
local offx = 0
local offy = 0

function rfr.set_cam_target(tg, ox, oy)
	target = tg
	offx = ox or 0
	offy = oy or 0
end

local map_boundaries = {
	["Map.Mainroom"] = {0, 320},
	["Map.Bathroom"] = {112,288},
	["Map.Hall"] = {0, 320}
}

function rfr.update_camera(dt)
	if target then
		local pos = rfr.get_position(target)
		rfr.camera_target(pos.x + offx, pos.y + offy, dt)
	end
	local map_boundary = map_boundaries[rfr.get_location(PLAYER)]
	if map_boundary then
		rfr.clamp_camera(map_boundary[1], map_boundary[2] - config.render_size[1] / config.cam_zoom)
	end
end