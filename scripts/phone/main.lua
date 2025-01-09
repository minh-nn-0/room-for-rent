local util = require "luamodules.utilities"

local phone_texts = util.load_json(rfr.gamepath() .. "data/ui/" .. config.language .. ".json")
local phone_tex_width = 48
local phone_tex_height = 84
local selection = 1
local phone_dst_position = {config.render_size[1] / 2 - phone_tex_width * config.cam_zoom / 2, 10}
local phone_start_position = {config.render_size[1] / 2 - phone_tex_width * config.cam_zoom / 2, 800}
local phone_position = {phone_start_position[1], phone_start_position[2]}
local lerp_time = 0.5 -- takes how many seconds

--local phone_screen_color = {40,40,40,255}
--local phone_screen_rect = {3, 3, 42, 77}

local phone_apps_info = {
	call = {src = {x = 0, y = 32, w = 8, h = 8}, text = phone_texts["call"]},
	message = {src = {x = 0, y = 40, w = 8, h = 8}, text = phone_texts["message"]},
	note = {src = {x = 0, y = 48, w = 8, h = 8}, text = phone_texts["note"]},
	setting = {src = {x = 0, y = 56, w = 8, h = 8}, text = phone_texts["setting"]},
	exit = {src = {x = 8, y = 32, w = 8, h = 8}, text = phone_texts["exit"]},
}
local phone_apps = {"call", "message", "note", "setting", "exit"}
local phone_state = "home"
local function phone_at_position()
	if rfr.get_flag("phone_opening") then return phone_position[2] <= phone_dst_position[2]
	else return phone_position[2] >= phone_start_position[2]
	end
end
--local function screen_at_correct_brightness()
--	if opening then return phone_screen_color[1] >= 230
--	else return phone_screen_color[1] <= 40
--	end
--end
local function draw_phone()
	-- draw screen
--	beaver.set_draw_color(phone_screen_color[1], phone_screen_color[2], phone_screen_color[3], phone_screen_color[4])
--	beaver.draw_rect(phone_position[1] + phone_screen_rect[1], phone_position[2] + phone_screen_rect[2], phone_screen_rect[3], phone_screen_rect[4])
	-- phone texture
	beaver.draw_texture("phone", {dst = {x = phone_position[1], y = phone_position[2], w = 48 * config.cam_zoom, h = 84 * config.cam_zoom},
								 src = {x = 0, y = 0, w = 48, h = 84}})
	beaver.set_draw_color(40,40,40,255)
	beaver.draw_text_centered(phone_position[1] + phone_tex_width * config.cam_zoom / 2, phone_position[2] + 15 * config.cam_zoom,
								config.ui_font, 1/4,
								phone_texts[phone_state], 0, true)
end

local function draw_selection_box()
	beaver.set_draw_color(100,100,100,255)
	local start_app_posy = phone_position[2] + 15 * config.cam_zoom
	local box_dst = {x = phone_position[1] + 4 * config.cam_zoom,
					y = start_app_posy + (selection * 10 - 1) * config.cam_zoom,
					w = (phone_tex_width - 4 * 2) * config.cam_zoom,
					h = 10 * config.cam_zoom}
	beaver.draw_rectangle(box_dst.x, box_dst.y, box_dst.w, box_dst.h, true)
end
local function draw_apps()
	beaver.set_draw_color(40,40,40,255)
	local app_posx = phone_position[1] + 6 * config.cam_zoom
	local start_app_posy = phone_position[2] + 15 * config.cam_zoom
	for i, app in ipairs(phone_apps) do
		local app_posy = start_app_posy + i * 10 * config.cam_zoom
		local app_src = phone_apps_info[app].src
		local app_text = phone_apps_info[app].text
		beaver.draw_texture("UI", {dst = {x = app_posx, y = app_posy, w = 8 * config.cam_zoom, h = 8 * config.cam_zoom},
									src = app_src})
		if i == selection then beaver.set_draw_color(230,230,230,255)
		else beaver.set_draw_color(40,40,40,255)
		end
		beaver.draw_text(app_posx + 10 * config.cam_zoom, app_posy + 1.5 * config.cam_zoom,
						config.ui_font, 1/4,
						app_text, 0, true)
	end
end

local phone_lerp_timer = rfr.add_entity()
rfr.set_timer(phone_lerp_timer, lerp_time)
local function open_phone()
	-- lerp in phone
	-- brighten phone_screen
	-- show things
	-- 		icon
	-- 		text
	-- highlight selection
	-- show how to navigate
end
local function close_phone()
	-- lerp out
end

function rfr.toggle_phone()
	rfr.toggle_flag("phone_opening")
	rfr.set_timer(phone_lerp_timer, lerp_time)
end

local function phone_input()
	if beaver.get_input("UP") == 1 then selection = math.max(selection - 1, 1) end
	if beaver.get_input("DOWN") == 1 then selection = math.min(selection + 1, 5) end
end

function rfr.update_phone(dt)
	if not phone_at_position() then
		local t = rfr.get_timer(phone_lerp_timer).elapsed
		if rfr.get_flag("phone_opening") then
			phone_position[2] = phone_start_position[2] + (phone_dst_position[2] - phone_start_position[2]) * util.ease_in_out(math.min(t / lerp_time,1))
		else
			phone_position[2] = phone_dst_position[2] + (phone_start_position[2] - phone_dst_position[2]) * util.ease_in_out(math.min(t / lerp_time,1))
		end
		return
	end
	if rfr.get_flag("phone_opening") then
		rfr.set_properties(PLAYER, "can_move", false)
		phone_input()
		rfr.set_state(PLAYER, "idle")
	else
		rfr.set_properties(PLAYER, "can_move", true)
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
	beaver.set_using_cam(false)
	draw_phone()
	draw_selection_box()
	draw_apps()
	beaver.set_using_cam(true)
end
