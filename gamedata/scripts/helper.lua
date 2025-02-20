local util = require "luamodules.utilities"
local texts = util.load_json(rfr.gamepath() .. "data/ui/" .. config.language .. ".json")
function rfr.draw_helper()
	if rfr.get_flag("inbed") and not rfr.get_flag("dreaming") then
		beaver.draw_texture(ASSETS.images.UI, {dst = {x = 120, y = 310, w = 8 * config.cam_zoom, h = 8 * config.cam_zoom},
									src = {x = 54, y = 34, w = 10, h = 10}})
		beaver.set_draw_color(255,255,255,255)
		beaver.draw_text(170, 320, ASSETS.fonts[config.ui_font], 1, texts["sleep_helper"], 0, true)
	end

	if rfr.get_flag("showering") then
		local button_posx = config.render_size[1]/2 - 60
		local text_posx = button_posx + 40
		beaver.draw_texture(ASSETS.images.UI, {dst = {x = button_posx , y = 310, w = 8 * config.cam_zoom, h = 8 * config.cam_zoom},
									src = {x = 54, y = 34, w = 10, h = 10}})
		beaver.set_draw_color(255,255,255,255)
		beaver.draw_text(text_posx, 320, ASSETS.fonts[config.ui_font], 1, texts["shower_helper"], 0, true)
	end

end

function rfr.draw_helper_fg()
	if rfr.get_flag("helper_back") then
		local button_posx = config.render_size[1]/2 - 60
		local text_posx = button_posx + 40
		beaver.draw_texture(ASSETS.images.UI, {dst = {x = button_posx , y = 310, w = 8 * config.cam_zoom, h = 8 * config.cam_zoom},
									src = {x = 54, y = 34, w = 10, h = 10}})
		beaver.set_draw_color(255,255,255,255)
		beaver.draw_text(text_posx, 320, ASSETS.fonts[config.ui_font], 1, texts["back"], 0, true)
	end
end
