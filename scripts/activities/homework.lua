local util = require "luamodules.utilities"
local notebook = require "activities.notebook"
local interaction_name = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local UI_name = util.load_json(rfr.gamepath() .. "data/ui/" .. config.language .. ".json")
function rfr.update_homework()
	notebook.update()
end

function rfr.draw_homework()
	notebook.draw()
	if rfr.get_flag("notebook_opening") then
		beaver.set_draw_color(255,255,255,255)
		local hwstr = ""
		for _, hw in ipairs(notebook.current_questions()) do
			hwstr = hwstr .. tostring(hw) .. ", "
		end
		hwstr = string.sub(hwstr,1,#hwstr - 2)
		beaver.draw_text(60, 90, config.ui_font, 1, UI_name["today_homework"] .. ": " .. UI_name["page"] .. " " .. hwstr, 0, true)
		beaver.draw_texture("UI", {dst = {x = 60, y = 180, w = 6 * config.cam_zoom, h = 6 * config.cam_zoom},
									src = {x = 44, y = 54, w = 10, h = 10}})
		beaver.draw_texture("UI", {dst = {x = 90, y = 180, w = 6 * config.cam_zoom, h = 6 * config.cam_zoom},
									src = {x = 54, y = 54, w = 10, h = 10}})
		beaver.draw_text(120, 184, config.ui_font, 1, ": " .. UI_name["turn_page"], 0, true)
		beaver.draw_texture("UI", {dst = {x = 60, y = 230, w = 6 * config.cam_zoom, h = 6 * config.cam_zoom},
									src = {x = 44, y = 44, w = 10, h = 10}})
		beaver.draw_texture("UI", {dst = {x = 90, y = 230, w = 6 * config.cam_zoom, h = 6 * config.cam_zoom},
									src = {x = 54, y = 44, w = 10, h = 10}})
		beaver.draw_texture("UI", {dst = {x = 120, y = 230, w = 6 * config.cam_zoom, h = 6 * config.cam_zoom},
									src = {x = 44, y = 34, w = 10, h = 10}})
		beaver.draw_text(150, 234, config.ui_font, 1, ": " .. UI_name["select_answer"], 0, true)

		beaver.draw_texture("UI", {dst = {x = 60, y = 280, w = 6 * config.cam_zoom, h = 6 * config.cam_zoom},
									src = {x = 54, y = 34, w = 10, h = 10}})
		beaver.draw_text(90, 284, config.ui_font, 1, ": " .. UI_name["back"], 0, true)
	end
end

DESK = rfr.add_entity()
rfr.set_position(DESK, 184,100)
rfr.set_location(DESK, "Map.Mainroom")
rfr.set_interaction(DESK, interaction_name["desk"],
	function()
		local px,_ = util.player_center()
		return px >= 176 and px <= 190
	end,
	function()
		notebook.toggle()
	end)
