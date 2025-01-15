local notifying_app = ""

function rfr.set_phone_notification(app)
	notifying_app = app
end

function rfr.clear_phone_notification()
	notifying_app = ""
end

function rfr.get_phone_notifying_app()
	return notifying_app
end


local util = require("luamodules.utilities")

function rfr.draw_phone_notification()
	if notifying_app == "" or rfr.get_flag("phone_opening") then return end
	local text = util.load_json(rfr.gamepath() .. "data/ui/" .. config.language .. ".json")["phone_noti"]

	beaver.draw_texture("UI", {dst = {x = 40, y = 20, w = 8 * config.cam_zoom, h = 14 * config.cam_zoom},
								src = {x = 56, y = 50, w = 8, h = 14}})
	beaver.set_draw_color(255,255,255,255)
	beaver.draw_text(90, 40, config.ui_font, 1, text, 0, true)
end
