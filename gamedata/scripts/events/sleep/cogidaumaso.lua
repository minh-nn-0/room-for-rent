local cgdms = {}

cgdms.active = false
local elapsed = 0
local time_each = 1
local dst = {x = config.render_size[1]/2 - 100 * 3, y = 40, w = 200 * 3}
cgdms.current_part = 1
function cgdms.init()
	cgdms.active = true
	beaver.play_sound(ASSETS.audios.whisper)
end
function cgdms.update(dt)
	if not cgdms.active then return end
	if cgdms.current_part == 3 then cgdms.active = false end
	elapsed = elapsed + dt
	if elapsed >= time_each then
		elapsed = elapsed - time_each
		cgdms.current_part = cgdms.current_part + 1
	end
end

function cgdms.draw()
	if not cgdms.active then return end
	local height = cgdms.current_part > 1 and 100 or 50
	dst.h = height * 3
	beaver.draw_texture(ASSETS.images.cgdms, {
		dst = dst,
		src = {x = 0, y = 0, w = 200, h = height}
	})
end

return cgdms
