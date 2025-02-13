local do_homework_at_night = rfr.add_event(
	function()
		return rfr.get_flag("notebook_opening")
	end)

local shadow = rfr.add_entity()
local shadow_appeared = false
local shadow_timer = 0
local shadow_delay = 0
local shadow_full_duration = false
local cs_shadow_appear_behind = rfr.add_cutscene({
	init = function()
		print("HHIHIHI")
		shadow_timer = 0
		shadow_delay = 0
		shadow_appeared = false
	end,
	exit = function()
		if shadow_full_duration then
			rfr.unset_event_listener(GAME, do_homework_at_night)
			rfr.set_active(shadow, false)
		else
			rfr.set_position(shadow, 1000,1000)
		end
	end,
	scripts = {
		function()
			if not rfr.get_flag("notebook_opening") then return true end
			if shadow_delay > 3 then
				shadow_appeared = true
				rfr.set_position(shadow, 160, 112)
				rfr.set_location(shadow, "Map.Mainroom")
				rfr.set_image(shadow, ASSETS.images.tileset)
				rfr.set_image_source(shadow, 320,304,16,32)
			end
			if shadow_timer > 1.5 then
				shadow_full_duration = true
				return true
			end
			return false
		end
	},
	update = function(dt)
		if shadow_delay < 3 then shadow_delay = shadow_delay + dt end
		if shadow_appeared then
			shadow_timer = shadow_timer + dt
			if shadow_timer > 0.5 then
				rfr.set_tint(shadow, 255,255,255, math.floor(255 * math.max(1 - (shadow_timer - 1.4)/0.3,0)))
			end
		end
	end
})

rfr.set_event_listener(GAME, do_homework_at_night,
	function()
		if not rfr.is_cutscene_playing() then rfr.play_cutscene(cs_shadow_appear_behind) end
	end)


