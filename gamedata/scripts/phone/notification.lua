local phone_noti = {}
local notifying_app = {}

function phone_noti.set(app)
	notifying_app[app] = true
end

function phone_noti.clear(app)
	notifying_app[app] = false
end

function phone_noti.get_notifying_apps()
	--local rs = {}
	--for app,nt in pairs(notifying_app) do
	--	if nt then table.insert(rs,app) end
	--end
	--return rs

	return notifying_app
end


local util = require("luamodules.utilities")
function rfr.draw_phone_notification()
	local should_draw = false
	for _,app in pairs(notifying_app) do
		if app == true then
			should_draw = true
			break
		end
	end

	if not should_draw or rfr.get_flag("phone_opening") then return end
	local text = util.load_json(rfr.gamepath() .. "data/ui/" .. config.language .. ".json")["phone_noti"]

	beaver.set_draw_color(20,20,20,200)
	beaver.draw_rectangle(15, 10, 54 * config.cam_zoom, 12 * config.cam_zoom, true)
	beaver.draw_texture(ASSETS.images.UI, {dst = {x = 20, y = 15, w = 6 * config.cam_zoom, h = 10 * config.cam_zoom},
								src = {x = 0, y = 22, w = 6, h = 10}})
	beaver.set_draw_color(255,255,255,255)
	beaver.draw_text(60, 20, config.ui_font, 1, text, 0, true)
end

return phone_noti
