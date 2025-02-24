local util = require "luamodules.utilities"
local UI_names = util.load_json(rfr.gamepath() .. "data/ui/" .. config.language .. ".json")
local interaction = require "luamodules.interaction"
local diary = {}
local drawing_texture = beaver.create_texture_for_drawing()
beaver.set_texture_blend_mode(drawing_texture, "blend")
local shadow = beaver.create_texture_for_drawing()
beaver.set_texture_blend_mode(shadow, "modulate")

local diary_texts = util.load_json(rfr.gamepath() .. "data/diary_" .. config.language .. ".json")["entries"]
diary.current_page = 1

diary.read_last_page = false
diary.opening = false
local opacity = 0
local target_opacity = 0
local elapsed = 1
local fade_time = 1
function diary.open()
	diary.opening = true
	target_opacity = 255
	opacity = 0
	elapsed = 0
	interaction.set_back(UI_names["back"], diary.close)
	rfr.unset_flag("player_can_interact")
	rfr.unset_flag("player_can_move")
end

local diary_dst = {x = 30, y = 50, w = 80 * config.cam_zoom, h = 60 * config.cam_zoom}

function diary.close()
	print("close diary")
	diary.opening = false
	target_opacity = 0
	elapsed = 0
	interaction.unset_back()
	rfr.set_flag("player_can_interact")
	rfr.set_flag("player_can_move")
end

function diary.update(dt)
	if diary.opening then
		if elapsed < fade_time then
			opacity = math.floor(math.min(255, 255 * util.ease_in_out(elapsed / fade_time)))
		else
			opacity = target_opacity
		end
		if beaver.get_input("LEFT") == 1 then diary.current_page = math.max(1, diary.current_page - 1) end
		if beaver.get_input("RIGHT") == 1 then diary.current_page = math.min(#diary_texts, diary.current_page + 1) end
	else
		if elapsed < fade_time then
			opacity = math.floor(math.max(0, 255 - (255 * util.ease_in_out(elapsed / fade_time))))
		else
			opacity = target_opacity
		end
	end
	if elapsed < fade_time then elapsed = elapsed + dt end
	if not diary.read_last_page then diary.read_last_page = diary.current_page == #diary_texts end
end

local function draw_text()
	beaver.draw_text(diary_dst.x + diary_dst.w + 30, diary_dst.y + 30, ASSETS.fonts.unifont, config.text_scale, "x/xx/xxxx")
	beaver.draw_text(diary_dst.x + diary_dst.w + 30, diary_dst.y + 50, ASSETS.fonts.unifont, config.text_scale, diary_texts[diary.current_page], 250)
end

function diary.draw()
	if not diary.opening and opacity == target_opacity then return end
	beaver.set_render_target(drawing_texture)
	beaver.set_draw_color(0,0,0,0)
	beaver.clear()
	beaver.draw_texture(ASSETS.images.diary, {dst = diary_dst})
	beaver.set_render_target(shadow)
	beaver.set_draw_color(40,40,40,255)
	beaver.draw_rectangle(0,0,0,0,true)

	beaver.set_texture_color_mod(ASSETS.images.light, {150,100,100,255})
	local random_scale = (math.random() * 2 - 1) * 10 * math.random()
	beaver.draw_texture(ASSETS.images.light, {dst = {x = 0, y = -200, w = 120 * config.cam_zoom + random_scale, h = 120 * config.cam_zoom + random_scale} , src = {x = 56, y = 65, w = 190, h = 190}})
	beaver.set_texture_color_mod(ASSETS.images.light, {255,255,255,255})

	beaver.set_render_target(drawing_texture)
	beaver.draw_texture(shadow, {dst = {x = 0, y = 0, w = 1280, h = 720}})
	beaver.set_draw_color(255,255,255,255)
	draw_text()

	beaver.set_render_target()
	beaver.set_texture_color_mod(drawing_texture, {255,255,255,opacity})
	beaver.draw_texture(drawing_texture, {dst = {x = 0, y = 0, w = 1280, h = 720}})
end

return diary

