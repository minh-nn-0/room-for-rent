local util = require "luamodules.utilities"
local phone_states = require "phone.states"

local phone_texts = util.load_json(rfr.gamepath() .. "data/ui/" .. config.language .. ".json")
local phone_tex_width = 48
local phone_tex_height = 84
local phone_dsty = 10
local phone_starty = 800
local lerp_time = 0.5 -- takes how many seconds

PHONE = rfr.add_entity()
--rfr.set_position(PHONE, config.render_size[1] / 2 - phone_tex_width * config.cam_zoom / 2, phone_starty)
rfr.set_position(PHONE, 30, phone_starty)
rfr.set_image(PHONE, "phone")
rfr.set_image_source(PHONE, 0,0, phone_tex_width,phone_tex_height)
rfr.set_scale(PHONE, config.cam_zoom, config.cam_zoom)
rfr.add_tag(PHONE, "ui")
rfr.set_state(PHONE, "home")
--local phone_screen_color = {40,40,40,255}
--local phone_screen_rect = {3, 3, 42, 77}
local function draw_app_title()
	beaver.set_draw_color(40,40,40,255)
	local phone_position = rfr.get_position(PHONE)
	beaver.draw_text_centered(phone_position.x + phone_tex_width / 2 * config.cam_zoom, phone_position.y + 15 * config.cam_zoom,
								config.ui_font, 1,
								phone_texts[rfr.get_state(PHONE)], 0, true)
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
	if rfr.get_flag("phone_opening") then phone_states[rfr.get_state(PHONE)].update(dt) end
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
