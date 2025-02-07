local selection = {}
local current_selection = 1
local max = 5
function selection.get() return current_selection end
function selection.set(sl) current_selection = sl end
function selection.set_max(n) max = n end
function selection.update()
	if beaver.get_input("UP") == 1 then current_selection = math.max(current_selection - 1, 1) end
	if beaver.get_input("DOWN") == 1 then current_selection = math.min(current_selection + 1, max) end
end
function selection.draw_box()
	beaver.set_draw_color(100,100,100,255)
	local phone_position = rfr.get_position(PHONE)
	local start_app_posy = phone_position.y + 15 * config.cam_zoom
	local box_dst = {x = phone_position.x + 4 * config.cam_zoom,
					y = start_app_posy + (current_selection * 10 - 1) * config.cam_zoom,
					w = (48 - 4 * 2) * config.cam_zoom,
					h = 10 * config.cam_zoom}
	beaver.draw_rectangle(box_dst.x, box_dst.y, box_dst.w, box_dst.h, true)
end
return selection
