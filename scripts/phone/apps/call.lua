local util = require "luamodules.utilities"
local character_name = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local selection = require "phone.selection"
local callee = ""
local status = ""
local call_content = ""
local text_index = 1
local text_time = 0
local phonebook = {"owner", "mom"}
local character_icon = {
	["owner"] = {x = 0, y = 8, w = 8, h = 8},
	["mom"] = {x = 0, y = 16, w = 8, h = 8},
}
local app_state = "home"
local call_timer = rfr.add_entity()
local states = {
	["home"] = {
		update = function(dt)
			selection.set_max(#phonebook)
			selection.update()
			if beaver.get_input(config.button.back) == 1 then
				rfr.set_state(PHONE, "home")
			end
			if beaver.get_input(config.button.interaction) == 1 then
				callee = phonebook[selection.get()]
				rfr.set_timer(call_timer, 10)
				app_state = "calling"
				status = "Calling"
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

				beaver.draw_texture("character_heads", {dst = {x = posx, y = posy, w = 8 * config.cam_zoom, h = 8 * config.cam_zoom},
														src = char_head_src})
				if i == selection.get() then beaver.set_draw_color(230,230,230,255)
				else beaver.set_draw_color(40,40,40,255)
				end

				beaver.draw_text(posx + 10 * config.cam_zoom, posy + 1.5 * config.cam_zoom,
								config.ui_font, 1,
								char_name, 0, true)
			end
		end,
	},
	["calling"] = {
		update = function(dt)
			print(text_time)
			if beaver.get_input(config.button.back) == 1 then
				app_state = "home"
			end
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
		end,
		draw = function()
			beaver.set_draw_color(40,40,40,255)
			local phone_position = rfr.get_position(PHONE)
			local posx = phone_position.x + (48 / 2 - 16 / 2) * config.cam_zoom
			local posy = phone_position.y + 25 * config.cam_zoom
			beaver.draw_texture("character_heads", {dst = {x = posx, y = posy, w = 16 * config.cam_zoom, h = 16 * config.cam_zoom},
													src = character_icon[callee]})
			beaver.draw_text_centered(posx + 8 * config.cam_zoom, posy + 20 * config.cam_zoom, config.ui_font, 1, status, 0, true)
			if call_content ~= "" then
				beaver.draw_text(phone_position.x + 6 * config.cam_zoom, posy + 30 * config.cam_zoom,
								config.ui_font, 1,
								string.sub(call_content,1,text_index), 155 ,true)
				end
		end,
	}
}
local function load()
	character_name = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
end
local function update(dt)
	states[app_state].update(dt)
end
local function draw()
	states[app_state].draw()
end

function rfr.set_phone_dialogue(content)
	call_content = content
	text_index = 1
	text_time = 0
end
function rfr.phone_caller_active()
	return status == "In call" and text_time < config.dialogue_wait_time
end
function rfr.phone_caller_hangup()
	status = "End Call"
	call_content = ""
end
function rfr.is_making_phone_call()
	return app_state == "calling"
end

function rfr.get_phone_call_status()
	return status
end
function rfr.get_phone_callee()
	return callee
end
function rfr.get_phone_wait_time()
	return rfr.get_timer(call_timer).elapsed
end
return {set_app_state = function(state) app_state = state end, load = load, update = update, draw = draw}
