local util = require "luamodules.utilities"
local phone_states = require "phone.states"

local phone_texts = util.load_json(rfr.gamepath() .. "data/ui/" .. config.language .. ".json")
local phone_tex_width = 48
local phone_tex_height = 84
local phone_dsty = 10
local phone_starty = 800
local lerp_time = 0.5 -- takes how many seconds

local phone_apps_info = {
	call = {src = {x = 0, y = 32, w = 8, h = 8}, text = phone_texts["call"]},
	message = {src = {x = 0, y = 40, w = 8, h = 8}, text = phone_texts["message"]},
	note = {src = {x = 0, y = 48, w = 8, h = 8}, text = phone_texts["note"]},
	setting = {src = {x = 0, y = 56, w = 8, h = 8}, text = phone_texts["setting"]},
	exit = {src = {x = 8, y = 32, w = 8, h = 8}, text = phone_texts["exit"]},
}
PHONE = rfr.add_entity()
--rfr.set_position(PHONE, config.render_size[1] / 2 - phone_tex_width * config.cam_zoom / 2, phone_starty)
rfr.set_position(PHONE, 30, phone_starty)
rfr.set_image(PHONE, "phone")
rfr.set_image_source(PHONE, 0,0, phone_tex_width,phone_tex_height)
rfr.set_scale(PHONE, config.cam_zoom, config.cam_zoom)
rfr.add_tag(PHONE, "ui")
for _,app in ipairs({"home","call","message","note"}) do
	rfr.set_state_entry(PHONE, app, function() phone_states[app].load() end)
end
rfr.set_state(PHONE, "home")
--local phone_screen_color = {40,40,40,255}
--local phone_screen_rect = {3, 3, 42, 77}
local function draw_app_title()
	beaver.set_draw_color(40,40,40,255)
	local phone_position = rfr.get_position(PHONE)
	if rfr.get_state(PHONE) == "home" then
		beaver.draw_text_centered(phone_position.x + phone_tex_width / 2 * config.cam_zoom, phone_position.y + 15 * config.cam_zoom,
									config.ui_font, 1,
									phone_texts["home"], 0, true)
	else
		beaver.draw_texture("UI", {dst = { x = phone_position.x + (phone_tex_width / 2 - 4) * config.cam_zoom,
										y = phone_position.y + 14 * config.cam_zoom,
										w = 8 * config.cam_zoom,
										h = 8 * config.cam_zoom},
								src = phone_apps_info[rfr.get_state(PHONE)].src})
	end
end

local function phone_at_position()
	local phone_position = rfr.get_position(PHONE)
	if rfr.get_flag("phone_opening") then return phone_position.y <= phone_dsty
	else return phone_position.y >= phone_starty
	end
end
--local function screen_at_correct_brightness()
--	if opening then return phone_screen_color[1] >= 230
--	else return phone_screen_color[1] <= 40
--	end
--end

local phone_lerp_timer = rfr.add_entity()
rfr.set_timer(phone_lerp_timer, lerp_time)

function rfr.toggle_phone()
	phone_texts = util.load_json(rfr.gamepath() .. "data/ui/" .. config.language .. ".json")
	phone_apps_info = {
		call = {src = {x = 0, y = 32, w = 8, h = 8}, text = phone_texts["call"]},
		message = {src = {x = 0, y = 40, w = 8, h = 8}, text = phone_texts["message"]},
		note = {src = {x = 0, y = 48, w = 8, h = 8}, text = phone_texts["note"]},
		setting = {src = {x = 0, y = 56, w = 8, h = 8}, text = phone_texts["setting"]},
		exit = {src = {x = 8, y = 32, w = 8, h = 8}, text = phone_texts["exit"]},
	}
	rfr.toggle_flag("phone_opening")
	rfr.set_timer(phone_lerp_timer, lerp_time)
	if rfr.get_flag("phone_opening") then
		rfr.set_properties(PLAYER, "can_move", false)
		rfr.set_state(PLAYER, "idle")
	else
		rfr.set_properties(PLAYER, "can_move", true)
	end
end

function rfr.update_phone(dt)
	local phone_position = rfr.get_position(PHONE)
	if not phone_at_position() then
		local t = rfr.get_timer(phone_lerp_timer).elapsed
		if rfr.get_flag("phone_opening") then
			phone_position.y = phone_starty + (phone_dsty - phone_starty) * util.ease_in_out(math.min(t / lerp_time,1))
		else
			phone_position.y = phone_dsty + (phone_starty - phone_dsty) * util.ease_in_out(math.min(t / lerp_time,1))
		end

		rfr.set_position(PHONE, phone_position.x, phone_position.y)
		return
	end
	if rfr.get_flag("phone_opening") then phone_states[rfr.get_state(PHONE)].update(dt)
	else rfr.set_state(PHONE, "home")
	end
	--if not screen_at_correct_brightness() then
	--	if opening then
	--		phone_screen_color[1] = phone_screen_color[1] + 10 * dt
	--		for i in 2,3 do
	--			phone_screen_color[i] = phone_screen_color[1]
	--		end
	--	else
	--		phone_screen_color[1] = phone_screen_color[1] - 10 * dt
	--		for i in 2,3 do
	--			phone_screen_color[i] = phone_screen_color[1]
	--		end
	--	end
	--	return
	--end
end

function rfr.draw_phone()
	draw_app_title()
	phone_states[rfr.get_state(PHONE)].draw()
end
