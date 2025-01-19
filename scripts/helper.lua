local util = require "luamodules.utilities"
local texts = util.load_json(rfr.gamepath() .. "data/ui/" .. config.language .. ".json")
function rfr.draw_helper()
	if rfr.get_flag("sleeping") then
		beaver.draw_texture("UI", {dst = {x = 120, y = 310, w = 8 * config.cam_zoom, h = 8 * config.cam_zoom},
									src = {x = 54, y = 34, w = 10, h = 10}})
		beaver.set_draw_color(255,255,255,255)
		beaver.draw_text(170, 320, config.ui_font, 1, texts["sleep_helper"], 0, true)
	end

	if rfr.get_flag("notebook_opening") then
		beaver.draw_texture("UI", {dst = {x = 60, y = 180, w = 6 * config.cam_zoom, h = 6 * config.cam_zoom},
									src = {x = 44, y = 54, w = 10, h = 10}})
		beaver.draw_texture("UI", {dst = {x = 90, y = 180, w = 6 * config.cam_zoom, h = 6 * config.cam_zoom},
									src = {x = 54, y = 54, w = 10, h = 10}})
		beaver.draw_text(120, 184, config.ui_font, 1, ": " .. texts["turn_page"], 0, true)
		beaver.draw_texture("UI", {dst = {x = 60, y = 230, w = 6 * config.cam_zoom, h = 6 * config.cam_zoom},
									src = {x = 44, y = 44, w = 10, h = 10}})
		beaver.draw_texture("UI", {dst = {x = 90, y = 230, w = 6 * config.cam_zoom, h = 6 * config.cam_zoom},
									src = {x = 54, y = 44, w = 10, h = 10}})
		beaver.draw_texture("UI", {dst = {x = 120, y = 230, w = 6 * config.cam_zoom, h = 6 * config.cam_zoom},
									src = {x = 44, y = 34, w = 10, h = 10}})
		beaver.draw_text(150, 234, config.ui_font, 1, ": " .. texts["select_answer"], 0, true)

		beaver.draw_texture("UI", {dst = {x = 60, y = 280, w = 6 * config.cam_zoom, h = 6 * config.cam_zoom},
									src = {x = 54, y = 34, w = 10, h = 10}})
		beaver.draw_text(90, 284, config.ui_font, 1, ": " .. texts["back"], 0, true)
	end

end
