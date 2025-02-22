local util = require "luamodules.utilities"
local interaction = require "luamodules.interaction"
local selection = require "phone.selection"

local UI_names = util.load_json(rfr.gamepath() .. "data/ui/" .. config.language .. ".json")
local actor_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")

local messages = {}

local actors = {"boss"}
local app_state = "home"
local states = {
	["home"] = {
		update = function(dt)
			selection.set_max(#actors)
			selection.update()
		end,
		draw = function()
			selection.draw_box()
			beaver.set_draw_color(40,40,40,255)
			local phone_position = rfr.get_position(PHONE)
			local posx = phone_position.x + 6 * config.cam_zoom
			local start_posy = phone_position.y + 15 * config.cam_zoom
			for i,actor in ipairs(actors) do
				local posy = start_posy + i * 10 * config.cam_zoom
				local actor_name = actor_names[actor]

				beaver.draw_texture(ASSETS.images.character_heads, {dst = {x = posx, y = posy, w = 8 * config.cam_zoom, h = 8 * config.cam_zoom},
														src = {x = 8, y = 16, w = 8, h = 8}})
				if i == selection.get() then beaver.set_draw_color(230,230,230,255)
				else beaver.set_draw_color(40,40,40,255)
				end

				beaver.draw_text(posx + 10 * config.cam_zoom, posy + 1.5 * config.cam_zoom,
								ASSETS.fonts[config.ui_font], 1,
								actor_name, 0, true)
			end
		end,
		["in_messages"] = {
			init = function()
			end,
			update = function(dt)
			end,
			draw = function()
			end
		}
	}
}
local function load()
	interaction.set_back(UI_names["back"], function() rfr.set_state(PHONE, "home") end)
end
local function update(dt)
	states[app_state].update(dt)
end
local function draw()
	states[app_state].draw()
end

function rfr.add_phone_messages(actor, content)
	if not messages[actor] then messages[actor] = {} end
	table.insert(messages[actor], content)
	local noti = require "phone.notification"
	noti.set("message")
end

return {set_app_state = function(state) app_state = state end,
	load = load, update = update, draw = draw}
