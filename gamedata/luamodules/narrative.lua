local narrative = {}
local text_posx = 0
local text_posy = 0
local text_time = 0
local text_content = ""
local text_index = 1

local scale = 1
local wraplength = 0
function narrative.set_scale(s)
	scale = s
end
function narrative.set_wraplength(w)
	wraplength = w
end
function narrative.set_text(content)
	text_content = content
	text_index = 1
	text_time = 0
end

-- Determine center of text
function narrative.set_position(posx, posy)
	text_posx = posx
	text_posy = posy
end

function narrative.update(dt)
	if text_index < #text_content then
		text_time = text_time + config.narrative_cpf * dt
		if text_time >= 1 then
			text_index = text_index + math.floor(text_time)
			text_time = 0
		end
	else
		if text_time < config.narrative_wait_time then
			text_time = text_time + dt
		end
	end
end

function narrative.text_active()
	return text_index < #text_content or text_time <= config.narrative_wait_time
end

function narrative.text_appearing()
	return text_index < #text_content
end
function narrative.draw_text()
	if narrative.text_active() then
		beaver.draw_text_centered(text_posx, text_posy, ASSETS.fonts[config.ui_font], scale, string.sub(text_content, 1, text_index), wraplength)
	end
end

return narrative
