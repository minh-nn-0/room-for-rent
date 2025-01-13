local util = require "luamodules.utilities"
local selection = require "phone.selection"
local notes = {"guide"}
local current_note = "guide"
local text = util.load_text(rfr.gamepath() .. "data/note/" .. current_note .. "_" .. config.language .. ".txt")
local entry_names = util.load_json(rfr.gamepath() .. "data/note/entry_" .. config.language .. ".json")
local scroll = 0
local wraplength = 140
local app_state = "home"
local states = {
	["home"] = {
		update = function(dt)
			selection.set_max(#notes)
			selection.update()
			if beaver.get_input(config.button.back) == 1 then rfr.set_state(PHONE, "home") end
			if beaver.get_input(config.button.interaction) == 1 then
				current_note = notes[selection.get()]
				app_state = "reading"
			end
		end,
		draw = function()
			selection.draw_box()
			beaver.set_draw_color(40,40,40,255)
			local phone_position = rfr.get_position(PHONE)
			local posx = phone_position.x + 6 * config.cam_zoom
			local start_posy = phone_position.y + 15 * config.cam_zoom
			for i,note in ipairs(notes) do
				local posy = start_posy + i * 10 * config.cam_zoom
				if i == selection.get() then beaver.set_draw_color(230,230,230,255)
				else beaver.set_draw_color(40,40,40,255)
				end

				beaver.draw_text(posx + 10 * config.cam_zoom, posy + 1.5 * config.cam_zoom,
								config.ui_font, 1,
								entry_names[note], 0, true)
			end
		end
	},
	["reading"] = {
		update = function(dt)
			if beaver.get_input("DOWN") > 0 then scroll = math.min(scroll + 0.6, string.len(text) / (wraplength / 16) - 10) end
			if beaver.get_input("UP") > 0 then scroll = math.max(scroll - 0.6,0) end
			if beaver.get_input(config.button.back) == 1 then app_state = "home" end
		end,
		draw = function()
			local phone_position = rfr.get_position(PHONE)
			local posx = phone_position.x + 6 * config.cam_zoom
			local posy = phone_position.y + 30 * config.cam_zoom

			beaver.draw_text_centered(phone_position.x + 48 * config.cam_zoom / 2, phone_position.y + 23 * config.cam_zoom, config.ui_font, 1,
										entry_names[current_note], 0, true)
			beaver.set_draw_color(50,50,50,255)
			beaver.draw_rectangle(posx - 2, posy - 1, 36.5 * config.cam_zoom, 41 * config.cam_zoom, false)
			beaver.set_clip_rect(math.floor(posx), math.floor(posy),
								math.floor(40 * config.cam_zoom),
								math.floor(40 * config.cam_zoom))
			beaver.set_draw_color(0,0,0,255)
			beaver.draw_text(posx + 1 * config.cam_zoom, posy - scroll * 2 * config.cam_zoom, config.ui_font, 1, text, wraplength, true)
			beaver.reset_clip_rect()
		end
	},
}

local function load()
	text = util.load_text(rfr.gamepath() .. "data/note/" .. current_note .. "_" .. config.language .. ".txt")
	entry_names = util.load_json(rfr.gamepath() .. "data/note/entry_" .. config.language .. ".json")
end
local function update(dt)
	states[app_state].update(dt)
end

local function draw()
	states[app_state].draw()
end

return {set_app_state = function(state) app_state = state end, load = load, update = update, draw = draw}
