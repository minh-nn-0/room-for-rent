local util = require "luamodules.utilities"
local interaction = require "luamodules.interaction"
local character_name = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local selection = require "phone.selection"
local call = {}
local callee = ""
local status = ""
local call_content = ""
local text_index = 1
local text_time = 0
local phone_label = util.load_json(rfr.gamepath() .. "data/ui/" .. config.language .. ".json")
local phonebook = {"owner", "mom"}
local character_icon = {
	["owner"] = {x = 0, y = 8, w = 8, h = 8},
	["mom"] = {x = 0, y = 16, w = 8, h = 8},
}
local app_state = "home"
local call_timer = rfr.add_entity()


local circle_sw = rfr.add_entity()
rfr.set_stopwatch(circle_sw)
local audio_channel = 31

function call.get_audio_channel() return audio_channel end
local states = {
	["home"] = {
		update = function(dt)
			selection.set_max(#phonebook)
			selection.update()
			if beaver.get_input(config.button.interaction) == 1 then
				callee = phonebook[selection.get()]
				rfr.set_timer(call_timer, 10)
				app_state = "calling"
				status = "Calling"
				beaver.play_sound(ASSETS.audios.phonering,audio_channel)
				interaction.set_back("back", function()
						beaver.halt_channel(audio_channel)
						interaction.set_back("back", function() rfr.set_state(PHONE, "home") end)
						app_state = "home"
					end)
			end
		end,
		draw = function()
			selection.draw_box()
			beaver.set_draw_color(40,40,40,255)
			local phone_position = rfr.get_position(PHONE)
			local posx = phone_position.x + 6 * config.cam_zoom
			local start_posy = phone_position.y + 15 * config.cam_zoom
			for i,char in ipairs(phonebook) do
				local posy = start_posy + i * 10 * config.cam_zoom
				local char_head_src = character_icon[char]
				local char_name = character_name[char]

				beaver.draw_texture(ASSETS.images.character_heads, {dst = {x = posx, y = posy, w = 8 * config.cam_zoom, h = 8 * config.cam_zoom},
														src = char_head_src})
				if i == selection.get() then beaver.set_draw_color(230,230,230,255)
				else beaver.set_draw_color(40,40,40,255)
				end

				beaver.draw_text(posx + 10 * config.cam_zoom, posy + 1.5 * config.cam_zoom,
								ASSETS.fonts[config.ui_font], 1,
								char_name, 0, true)
			end
		end,
	},
	["calling"] = {
		update = function(dt)
			if status == "Calling" and not rfr.get_timer(call_timer).running then
				status = "Failed"
			end
			if text_index < #call_content then
				status = "In call"
				text_time = text_time + config.cpf * dt
				if text_time >= 1 then
					text_index = text_index + math.floor(text_time)
					text_time = 0
				end
			else
				if text_time < config.dialogue_wait_time then
					text_time = text_time + dt
				end
			end

			if status ~= "Calling" or not rfr.get_flag("phone_opening") then
				beaver.halt_channel(audio_channel)
			end
		end,
		draw = function()
			beaver.set_draw_color(40,40,40,255)
			local phone_position = rfr.get_position(PHONE)
			local posx = phone_position.x + (48 / 2 - 16 / 2) * config.cam_zoom
			local posy = phone_position.y + 28 * config.cam_zoom
			beaver.set_draw_color(38,133,76,255)
			beaver.draw_circle(posx + 8 * config.cam_zoom, posy + 8 * config.cam_zoom,math.max(45, math.min(55 * math.sin(rfr.get_stopwatch(circle_sw) * 0.8 * 2 * math.pi),55)), true)
			beaver.set_draw_color(30,64,68,255)
			beaver.draw_circle(posx + 8 * config.cam_zoom, posy + 8 * config.cam_zoom,math.max(40, math.min(45 * math.sin(rfr.get_stopwatch(circle_sw) * 0.5 * 2 * math.pi),45)), true)
			beaver.draw_texture(ASSETS.images.character_heads, {dst = {x = posx, y = posy, w = 16 * config.cam_zoom, h = 16 * config.cam_zoom},
													src = character_icon[callee]})
			beaver.set_draw_color(40,40,40,255)
			beaver.draw_text_centered(posx + 8 * config.cam_zoom, posy + 20 * config.cam_zoom, ASSETS.fonts[config.ui_font], 1, phone_label["phone"][status], 0, true)
			if call_content ~= "" then
					beaver.draw_text(phone_position.x + 6 * config.cam_zoom, posy + 30 * config.cam_zoom,
								ASSETS.fonts[config.ui_font], 1,
								string.sub(call_content,1,text_index), 155 ,true)
				end
		end,
	}
}

function call.set_app_state(state)
	app_state = state
end

function call.load()
	interaction.set_back("back", function() rfr.set_state(PHONE, "home") end)
end
function call.update(dt)
	states[app_state].update(dt)
end
function call.draw()
	states[app_state].draw()
end

function call.set_dialogue(content)
	call_content = content
	text_index = 1
	text_time = 0
end
function call.caller_active()
	return status == "In call" and text_time < config.dialogue_wait_time
end
function call.caller_hangup()
	status = "End call"
	call_content = ""
end
function call.is_making_phone_call()
	return app_state == "calling"
end

function call.get_status()
	return status
end
function call.get_callee()
	return callee
end
function call.get_waited_time()
	return rfr.get_timer(call_timer).elapsed
end

return call
