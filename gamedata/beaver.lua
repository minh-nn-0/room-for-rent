local beaver = {}

beaver.FLIP_H = FLIP_H
beaver.FLIP_V = FLIP_V
beaver.FLIP_NONE = FLIP_NONE
beaver.TILED_FLIP_H = TILED_FLIP_H
beaver.TILED_FLIP_V = TILED_FLIP_V
--- @param path string
--- @param custom_name? string
function beaver.new_image(path, custom_name)
	NEW_IMAGE(path, custom_name or "")
end

--- @param path string
--- @param custom_name? string
function beaver.new_sound(path, custom_name)
	NEW_SOUND(path, custom_name or "")
end

--- @param path string
--- @param custom_name? string
function beaver.new_music(path, custom_name)
	NEW_MUSIC(path, custom_name or "")
end

--- @param path string
--- @param fontsize integer
--- @param custom_name? string
function beaver.new_font(path, fontsize, custom_name)
	NEW_FONT(path, fontsize, custom_name or "")
end

--- @param keyname string
function beaver.get_input(keyname)
	return GET_INPUT(keyname)
end

function beaver.get_elapsed_time()
	return GET_ELAPSED_TIME()
end

function beaver.set_using_cam(usingcam)
	SET_USING_CAM(usingcam);
end
--- @param x number
--- @param y number
function beaver.draw_point(x,y)
	DRAW_POINT(x,y)
end
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
function beaver.draw_line(x1,y1,x2,y2)
	DRAW_LINE(x1,y1,x2,y2)
end

--- @param x number
--- @param y number
--- @param w number
--- @param h number
--- @param filled boolean
function beaver.draw_rectangle(x,y,w,h,filled)
	DRAW_RECTANGLE(x,y,w,h,filled)
end

--- @param x number
--- @param y number
--- @param r number
--- @param filled boolean
function beaver.draw_circle(x,y,r,filled)
	DRAW_CIRCLE(x,y,r,filled)
end

--- @param texture_name string
--- @param param? table
function beaver.draw_texture(texture_name, param)
	DRAW_TEXTURE(texture_name, param or {})
end

function beaver.set_font_size(fontname, size)
	SET_FONT_SIZE(fontname, size)
end
function beaver.draw_text(x, y, fontname, scale, content, wraplength, blended)
	DRAW_TEXT(x,y,fontname, scale, content, wraplength or 0, blended or false)
end
function beaver.draw_text_centered(x, y, fontname, scale, content, wraplength, blended)
	DRAW_TEXT_CENTERED(x,y,fontname, scale, content, wraplength or 0, blended or false)
end
function beaver.draw_text_right(x, y, fontname,scale, content, wraplength, blended)
	DRAW_TEXT_RIGHT(x,y,fontname, scale, content, wraplength or 0, blended or false)
end
-- @param r integer
-- @param g integer
-- @param b integer
-- @param a integer
function beaver.set_draw_color(r,g,b,a)
	SET_DRAW_COLOR(r,g,b,a)
end

function beaver.set_vsync(on)
	SET_VSYNC(on)
end
function beaver.clear()
	CLS()
end

function beaver.set_texture_blend_mode(texture_name, blend_mode)
	SET_TEXTURE_BLEND_MODE(texture_name, blend_mode)
end
function beaver.set_render_blend_mode(blend_mode)
	SET_RENDER_BLEND_MODE(blend_mode)
end
function beaver.set_texture_color_mod(texturename,color)
	SET_TEXTURE_COLOR_MOD(texturename, color)
end
--- @param x integer
--- @param y integer
function beaver.set_scale(x,y)
	SET_SCALE(x,y)
end

function beaver.set_integer_scale(active)
	SET_INTEGER_SCALE(active)
end
function beaver.set_render_logical_size(x,y)
	SET_RENDER_LOGICAL_SIZE(x,y)
end

function beaver.get_render_logical_size()
	return GET_RENDER_LOGICAL_SIZE()
end
function beaver.get_render_output_size()
	return GET_RENDER_OUTPUT_SIZE()
end
function beaver.create_texture_for_drawing(texture_name, width, height)
	local w,h = GET_RENDER_OUTPUT_SIZE()
	width = width and width or w
	height = height and height or h
	CREATE_TEXTURE_FOR_DRAWING(texture_name, width, height)
end

function beaver.set_render_target(target_name)
	SET_RENDER_TARGET(target_name and target_name or "")
end
function beaver.set_viewport(x,y,w,h)
	SET_VIEWPORT(x,y,w,h)
end
function beaver.set_clip_rect(x,y,w,h)
	SET_CLIP_RECT(x,y,w,h)
end
function beaver.reset_viewport()
	RESET_VIEWPORT()
end
function beaver.reset_clip_rect()
	RESET_CLIP_RECT()
end
function beaver.set_fullscreen(fc)
	SET_FULLSCREEN(fc)
end

function beaver.get_image_size(name)
	return IMAGE_SIZE(name)
end

function beaver.play_sound(name, channel, loop)
	return PLAY_SOUND(name, channel or -1, loop or 0)
end
function beaver.play_music(name, loop)
	PLAY_MUSIC(name, loop or -1)
end
function beaver.pause_channel(channel)
	PAUSE_CHANNEL(channel or -1)
end
function beaver.halt_channel(channel)
	HALT_CHANNEL(channel or -1)
end
function beaver.fade_in_music(music, loops, ms)
	FADE_IN_MUSIC(music, loops, ms)
end
function beaver.fade_out_music(ms)
	FADE_OUT_MUSIC(ms)
end
function beaver.fade_in_channel(name, channel, loop, ms)
	return FADE_IN_CHANNEL(name, channel, loop, ms)
end
function beaver.fade_out_channel(channel, ms)
	FADE_OUT_CHANNEL(channel, ms)
end
function beaver.pause_music()
	PAUSE_MUSIC()
end
function beaver.music_playing()
	return MUSIC_PLAYING()
end
function beaver.channel_playing(channel)
	return CHANNEL_PLAYING(channel)
end
function beaver.set_volume_master(volume)
	SET_VOLUME_MASTER(volume)
end
function beaver.set_volume_music(volume)
	SET_VOLUME_MUSIC(volume)
end
function beaver.set_volume_sound(name, volume)
	SET_VOLUME_SOUND(name, volume)
end
function beaver.set_volume_channel(channel, volume)
	SET_VOLUME_CHANNEL(channel, volume)
end
function beaver.allocate_sound_channels(number)
	ALLOCATE_CHANNELS(number)
end
return beaver
