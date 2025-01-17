local util = require "luamodules.utilities"

local dialogues
local card_start_posy = 500
local card_end_posy = 100
local showing = false
local lerp_timer = rfr.add_entity()
local lerp_time = 1

local card = rfr.add_entity()
rfr.add_tag(card, "ui")
rfr.set_position(card, config.render_size[1]/2 - 32 * config.cam_zoom, card_start_posy)
rfr.set_image(card, "student_card")
rfr.set_image_source(card, 0, 0, 64, 40)
rfr.set_scale(card, config.cam_zoom, config.cam_zoom)

local function card_at_position()
	local card_position = rfr.get_position(card)
	if showing then return card_position.y <= card_end_posy
	else return card_position.y >= card_start_posy
	end
end
CS_PICKUP_CARD = rfr.add_cutscene({
	init = function()
		dialogues =util.load_json(rfr.gamepath() .. "data/dialogues/events/pickup_card_" .. config.language .. ".json")
	end,
	exit = function()
	end,
	scripts = {
		function(dt)
			rfr.set_dialogue(PLAYER, {content = dialogues["surprised"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			showing = true
			rfr.set_flag("screen_fill")
			rfr.set_properties(GAME, "screen_fill_color", {20,20,20,150})
			rfr.set_timer(lerp_timer, lerp_time)
			return true
		end,
		function(dt)
			if not card_at_position() then return false end
			if beaver.get_input(config.button.back) == 1 then
				showing = false
				rfr.set_timer(lerp_timer, lerp_time)
				return true
			end
			return false
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) or not card_at_position() then return false end
			rfr.unset_flag("screen_fill")
			rfr.set_dialogue(PLAYER, {content = dialogues["familiar"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, {content = dialogues["same_school"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			showing = false
			rfr.set_timer(lerp_timer, lerp_time)
			return true
		end,
		function(dt)
			if not card_at_position() then return false
			else return true
			end
		end,
	},
	update = function(dt)
		local card_position = rfr.get_position(card)
		if not card_at_position() then
			local t = rfr.get_timer(lerp_timer).elapsed
			if showing then
				card_position.y = card_start_posy + (card_end_posy - card_start_posy) * util.ease_in_out(math.min(t / lerp_time,1))
			else
				card_position.y = card_end_posy + (card_start_posy - card_end_posy) * util.ease_in_out(math.min(t / lerp_time,1))
			end
			rfr.set_position(card, card_position.x, card_position.y)
		end
		if showing and rfr.get_position(PLAYER).x >= 250 then
			rfr.set_dialogue_position(PLAYER, 30 - rfr.get_position(PLAYER).x,0)
		end
	end
})

