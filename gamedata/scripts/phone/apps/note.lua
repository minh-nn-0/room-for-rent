local util = require "luamodules.utilities"
local note = {}
local note_entries = {}
local scroll = 0
local app_state = "home"
local note_spacing = 1
local total_note_height = 0
local clip_rect_height = math.floor(40 * config.cam_zoom)
function note.draw_note(posx, posy, entry)
	local text = util.load_text(rfr.gamepath() .. "data/note/" .. entry .. "_" .. config.language .. ".txt")
	local entry_names = util.load_json(rfr.gamepath() .. "data/note/entry_" .. config.language .. ".json")
	return rfr.draw_note(posx, posy, text, entry_names[entry])
end
local states = {
	["home"] = {
		update = function(dt)
			if beaver.get_input(config.button.back) == 1 then rfr.set_state(PHONE, "home") end
			if beaver.get_input("UP") > 0 then scroll = scroll + 1 end
			if beaver.get_input("DOWN") > 0 then scroll = scroll - 1 end
			local min_scroll = -((total_note_height - clip_rect_height)/ config.cam_zoom)
			scroll = math.min(0, math.max(scroll, min_scroll))
		end,
		draw = function()
			total_note_height = 0
			local phone_position = rfr.get_position(PHONE)
			local posx = phone_position.x + 6 * config.cam_zoom
			local start_posy = phone_position.y + (25 + scroll) * config.cam_zoom
			local posy = start_posy
			beaver.set_clip_rect(math.floor(posx), math.floor(phone_position.y + 25 * config.cam_zoom),
								math.floor(40 * config.cam_zoom),
								clip_rect_height)
			for _,entry in ipairs(note_entries) do
				total_note_height = total_note_height + note.draw_note(posx, posy, entry) + note_spacing * config.cam_zoom
				posy = posy + total_note_height
			end
			beaver.reset_clip_rect()
			--beaver.draw_text_centered(phone_position.x + 48 * config.cam_zoom / 2, ASSETS.fonts[config.ui_font], 1,
			--beaver.draw_text_centered(phone_position.x + 48 * config.cam_zoom / 2, ASSETS.fonts[config.ui_font], 1,
			--							entry_names[current_note], 0, true)
			--beaver.set_draw_color(50,50,50,255)
			--beaver.draw_rectangle(posx - 2, posy - 1, 36.5 * config.cam_zoom, 41 * config.cam_zoom, false)
			--beaver.set_draw_color(0,0,0,255)
			--beaver.draw_text(posx + 1 * config.cam_zoom, ASSETS.fonts[config.ui_font], 1, text, wraplength, true)
			--beaver.draw_text(posx + 1 * config.cam_zoom, ASSETS.fonts[config.ui_font], 1, text, wraplength, true)
		end
	},
}
function note.add(name)
	table.insert(note_entries, name)
	local noti = require "phone.notification"
	noti.set("note")
end
function note.load()
end
function note.update(dt)
	states[app_state].update(dt)
end

function note.draw()
	states[app_state].draw()
end

return note
