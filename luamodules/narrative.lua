local text_posx = 0
local text_posy = 0
local text_time = 0
local text_content = ""
local text_index = 1

local scale = 1
local wraplength = 0
function rfr.set_narrative_scale(s)
	scale = s
end
function rfr.set_narrative_wraplength(w)
	wraplength = w
end
function rfr.set_narrative_text(content)
	text_content = content
	text_index = 1
	text_time = 0
end

-- Determine center of text
function rfr.set_narrative_position(posx, posy)
	text_posx = posx
	text_posy = posy
end

function rfr.update_narrative(dt)
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

function rfr.narrative_text_active()
	return text_index < #text_content or text_time <= config.narrative_wait_time
end
function rfr.draw_narrative_text()
	if rfr.narrative_text_active() then
		beaver.draw_text_centered(text_posx, text_posy, config.ui_font, scale, string.sub(text_content, 1, text_index), wraplength)
	end
end

