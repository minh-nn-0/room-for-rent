local opacity = 0
local target_opacity = 255
local fade_in = true
local time = 0
local elapsed = 0
local active = false

function rfr.is_transition_active() return active end
function rfr.fade_in(duration)
	opacity = 255
	target_opacity = 0
	fade_in = true
	active = true
	time = duration
	elapsed = 0
end

function rfr.fade_out(duration)
	opacity = 0
	target_opacity = 255
	fade_in = false
	active = true
	time = duration
	elapsed = 0
end

function rfr.update_transition(dt)
	if not active then return end
	if fade_in then
		opacity = math.floor(math.max(0, 255 - (255 * elapsed/time)))
	else
		opacity = math.floor(math.min(255, 255 * elapsed/time))
	end
	elapsed = elapsed + dt
	if elapsed >= time then
		opacity = target_opacity
		active = false
	end
end

function rfr.draw_transition()
	beaver.set_draw_color(0,0,0,opacity)
	beaver.draw_rectangle(0,0,0,0,true)
end
