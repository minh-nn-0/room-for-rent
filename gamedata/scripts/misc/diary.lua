local util = require "luamodules.utilities"
local diary_texts = util.load_json(rfr.gamepath() .. "data/diary_" .. config.language .. ".json")["entries"]
local UI_names = util.load_json(rfr.gamepath() .. "data/ui/" .. config.language .. ".json")
local interaction = require "luamodules.interaction"
local diary = {}
local drawing_texture = beaver.create_texture_for_drawing()
beaver.set_texture_blend_mode(drawing_texture, "blend")
local shadow = beaver.create_texture_for_drawing()
beaver.set_texture_blend_mode(shadow, "modulate")

local current_page = 1

local opening = false
local opacity = 0
local target_opacity = 0
local elapsed = 1
local fade_time = 1
function diary.open()
	opening = true
	target_opacity = 255
	opacity = 0
	elapsed = 0
	interaction.set_back(UI_names["back"], diary.close)
	rfr.unset_flag("player_can_interact")
	rfr.unset_flag("player_can_move")
end

local diary_dst = {x = config.render_size[1] / 2 - 40 * config.cam_zoom, y = 50, w = 80 * config.cam_zoom, h = 60 * config.cam_zoom}

function diary.close()
	print("close diary")
	opening = false
	target_opacity = 0
	elapsed = 0
	interaction.unset_back()
	rfr.set_flag("player_can_interact")
	rfr.set_flag("player_can_move")
end

local candle_light = {}
function diary.update(dt)
	if opening then
		if elapsed < fade_time then
			opacity = math.floor(math.min(255, 255 * util.ease_in_out(elapsed / fade_time)))
		else
			opacity = target_opacity
		end
	else
		if elapsed < fade_time then
			opacity = math.floor(math.max(0, 255 - (255 * util.ease_in_out(elapsed / fade_time))))
		else
			opacity = target_opacity
		end
	end
	if elapsed < fade_time then elapsed = elapsed + dt end
end


function diary.draw()
	if not opening and opacity == target_opacity then return end
	beaver.set_render_target(drawing_texture)
	beaver.set_texture_color_mod(ASSETS.images.diary, {255,255,255,opacity})
	beaver.draw_texture(ASSETS.images.diary, {dst = diary_dst})
	beaver.set_render_target(shadow)
	beaver.set_draw_color(40,40,40,255)
	beaver.draw_rectangle(0,0,0,0,true)

	beaver.set_texture_color_mod(ASSETS.images.light, {150,100,100,255})
	beaver.draw_texture(ASSETS.images.light, {dst = {x = 0, y = 50, w = 190 * config.cam_zoom, h = 190 * config.cam_zoom} , src = {x = 56, y = 65, w = 190, h = 190}})
	beaver.set_texture_color_mod(ASSETS.images.light, {255,255,255,255})

	beaver.set_render_target(drawing_texture)
	beaver.draw_texture(shadow, {dst = {x = 0, y = 0, w = 1280, h = 720}})
	beaver.set_render_target()
	beaver.draw_texture(drawing_texture, {dst = {x = 0, y = 0, w = 1280, h = 720}})
end

return diary

