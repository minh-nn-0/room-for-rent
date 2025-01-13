local util = require "luamodules.utilities"
local selection = require "phone.selection"
local notes = {"guide"}
local scroll = 0
local wraplength = 140
local app_state = "home"
local note_spacing = 2
local function draw_note(posx, posy, note)
	local text = util.load_text(rfr.gamepath() .. "data/note/" .. note .. "_" .. config.language .. ".txt")
	local entry_names = util.load_json(rfr.gamepath() .. "data/note/entry_" .. config.language .. ".json")
	local text_height = (string.len(text) / (wraplength / 16) + 28) * config.cam_zoom
	beaver.set_draw_color(218,177,99,255)
	beaver.draw_rectangle(posx, posy, 36.5 * config.cam_zoom, text_height, true)
	beaver.set_draw_color(40,40,40,255)
	beaver.draw_text(posx, posy + 0.5 * config.cam_zoom, config.ui_font, 1, text, wraplength, true)

	return text_height + note_spacing * config.cam_zoom
end
local states = {
	["home"] = {
		update = function(dt)
			if beaver.get_input("UP") > 0 then scroll = scroll - 1 end
			if beaver.get_input("DOWN") > 0 then scroll = scroll + 1 end
		end,
		draw = function()
			local phone_position = rfr.get_position(PHONE)
			local posx = phone_position.x + 6 * config.cam_zoom
			local start_posy = phone_position.y + scroll * config.cam_zoom
			local posy = start_posy
			beaver.set_clip_rect(math.floor(posx), math.floor(phone_position.y + 25 * config.cam_zoom),
								math.floor(40 * config.cam_zoom),
								math.floor(40 * config.cam_zoom))
			for _,note in ipairs({"guide", "guide1"}) do
				posy = posy + draw_note(posx, posy, note)
			end
			beaver.reset_clip_rect()
			--beaver.draw_text_centered(phone_position.x + 48 * config.cam_zoom / 2, phone_position.y + 23 * config.cam_zoom, config.ui_font, 1,
			--							entry_names[current_note], 0, true)
			--beaver.set_draw_color(50,50,50,255)
			--beaver.draw_rectangle(posx - 2, posy - 1, 36.5 * config.cam_zoom, 41 * config.cam_zoom, false)
			--beaver.set_draw_color(0,0,0,255)
			--beaver.draw_text(posx + 1 * config.cam_zoom, posy - scroll * 2 * config.cam_zoom, config.ui_font, 1, text, wraplength, true)
		end
	},
}
local function load()
end
local function update(dt)
	states[app_state].update(dt)
end

local function draw()
	states[app_state].draw()
end

return {set_app_state = function(state) app_state = state end, load = load, update = update, draw = draw}
