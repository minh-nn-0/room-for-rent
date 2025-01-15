local util = require "luamodules.utilities"
local selection = require "phone.selection"
require "phone.notification"
local phone_texts
local phone_apps_info
local phone_apps = {"call", "message", "note", "setting", "exit"}

local function load()
	phone_texts = util.load_json(rfr.gamepath() .. "data/ui/" .. config.language .. ".json")
	phone_apps_info = {
		call = {src = {x = 0, y = 32, w = 8, h = 8}, text = phone_texts["call"]},
		message = {src = {x = 0, y = 40, w = 8, h = 8}, text = phone_texts["message"]},
		note = {src = {x = 0, y = 48, w = 8, h = 8}, text = phone_texts["note"]},
		setting = {src = {x = 0, y = 56, w = 8, h = 8}, text = phone_texts["setting"]},
		exit = {src = {x = 8, y = 32, w = 8, h = 8}, text = phone_texts["exit"]},
	}
end
local function update(dt)
	selection.set_max(#phone_apps)
	selection.update()
	if beaver.get_input(config.button.interaction) == 1 then
		rfr.set_state(PHONE, phone_apps[selection.get()])
		selection.set(1)
	end
	if beaver.get_input(config.button.back) == 1 then
		rfr.toggle_phone()
	end
end
local function draw()
	selection.draw_box()
	beaver.set_draw_color(40,40,40,255)
	local phone_position = rfr.get_position(PHONE)
	local app_posx = phone_position.x + 6 * config.cam_zoom
	local start_app_posy = phone_position.y + 15 * config.cam_zoom
	for i, app in ipairs(phone_apps) do
		local app_posy = start_app_posy + i * 10 * config.cam_zoom
		local app_src = phone_apps_info[app].src
		local app_text = phone_apps_info[app].text
		beaver.draw_texture("UI", {dst = {x = app_posx, y = app_posy, w = 8 * config.cam_zoom, h = 8 * config.cam_zoom},
									src = app_src})
		if app == rfr.get_phone_notifying_app() then
			beaver.draw_texture("UI", {dst = {x = app_posx + 5 * config.cam_zoom, y = app_posy - 1 * config.cam_zoom, w = 5 * config.cam_zoom, h = 7 * config.cam_zoom},
										src = {x = 8, y = 40, w = 5, h = 7}})
		end
		if i == selection.get() then beaver.set_draw_color(230,230,230,255)
		else beaver.set_draw_color(40,40,40,255)
		end
		beaver.draw_text(app_posx + 10 * config.cam_zoom, app_posy + 1.5 * config.cam_zoom,
						config.ui_font, 1,
						app_text, 0, true)
	end
end

return {load = load, update = update, draw = draw}
