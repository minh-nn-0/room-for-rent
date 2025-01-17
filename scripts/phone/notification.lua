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

	beaver.draw_texture("UI", {dst = {x = 20, y = 15, w = 6 * config.cam_zoom, h = 10 * config.cam_zoom},
								src = {x = 0, y = 22, w = 6, h = 10}})
	beaver.set_draw_color(255,255,255,255)
	beaver.draw_text(60, 20, config.ui_font, 1, text, 0, true)
end
