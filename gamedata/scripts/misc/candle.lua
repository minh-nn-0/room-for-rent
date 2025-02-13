local candle = {}

candle.eid = rfr.add_entity()
rfr.set_image(candle.eid, "tileset")
rfr.set_image_source(candle.eid, 416, 64, 16,16)

rfr.set_particle_emitter_config(candle.eid, {
	color_gradient = {
		{time = 0.0, color = {245,239,176,255}},
		{time = 0.3, color = {243,204,79,255}},
		{time = 0.8, color = {204,69,23,255}}
	},
	direction = math.rad(270),
	spread = math.rad(30),
	speed_variation = {min = 1, max = 5},
	size_variation = {min = 1, max = 1},
	lifetime = 0.5,
	rate = 7
})

local lit = false

local pickedup = false
local lighting = require "lighting"
local util = require "luamodules.utilities"

local candle_interaction = rfr.add_entity()
rfr.set_position(candle_interaction, 167, 112)
rfr.set_location(candle_interaction, "Map.Mainroom")
rfr.set_interaction(candle_interaction, "NEN",
	function()
		local px, _ = util.player_center()
		return px >= 160 and px <= 172
	end,
	function()
		if not pickedup then
			pickedup = true
		else
			rfr.set_position(candle.eid, 160,112)
			pickedup = false
		end
	end)


function candle.toggle()
	lit = not lit
	rfr.set_particle_emitter_auto(candle.eid, lit)
	lighting.set_light_on("candle", lit)
end

function candle.is_lit()
	return lit
end

function candle.picked_up()
	return pickedup
end

-- HOLDING CANDLE
rfr.set_state_entry(PLAYER, "idle_candle",
	function()
		rfr.set_tileanimation(PLAYER, {
			frames = {{19,400},{20,200},{21,200},{22,200}},
			framewidth = 32,
			frameheight = 32,
			["repeat"] = true
		})
	end)

rfr.set_state_entry(PLAYER, "move_candle",
	function()
		local speed = config.base_character_move_animation_speed / rfr.get_properties(PLAYER, "walkspeed")
		rfr.set_tileanimation(PLAYER, {
			frames = {{23,speed},{24,speed},{25,speed},{26,speed},{27,speed},{28,speed},{29,speed},{30,speed}},
			framewidth = 32,
			frameheight = 32,
			["repeat"] = true
		})
	end)

rfr.set_state_entry(PLAYER, "move_fast_candle",
	function()
		local speed = config.base_character_move_animation_speed / rfr.get_properties(PLAYER, "walkspeed")
		rfr.set_tileanimation(PLAYER, {
			frames = {{23,speed},{24,speed},{25,speed},{26,speed},{27,speed},{28,speed},{29,speed},{30,speed}},
			framewidth = 32,
			frameheight = 32,
			["repeat"] = true
		})
	end)
local frames_offsety_moving = {0,1,2,1,0,1,2,1}
local frames_offsety_idle = {0,0,1,1}
local pe = require "luamodules.particle"
function candle.update(dt)
	--pe.decrease_size_overtime(candle.eid)
	local cpos = rfr.get_position(candle.eid)
	if pickedup then
		local ppos = rfr.get_position(PLAYER)
		local pstate = string.gsub(rfr.get_state(PLAYER), "_candle", "")
		local panim = rfr.get_tileanimation(PLAYER).currentid
		local index = 1
		local moving = (pstate == "move" or pstate == "move_fast") and true or false

		if moving then index = panim - 22
		else index = panim - 18 end
		if index < 1 then return end

		local facing_left = rfr.get_flipflag(PLAYER) == beaver.FLIP_H
		if moving then
			rfr.set_particle_emitter_config(candle.eid, {lifetime = 0.06, rate = 20})
		else
			rfr.set_particle_emitter_config(candle.eid, {lifetime = 0.5})
		end
		local offsety = moving and frames_offsety_moving[index] or frames_offsety_idle[index] + 2
		cpos.x = facing_left and ppos.x or ppos.x + 17
		cpos.y = ppos.y + offsety

		rfr.set_location(candle.eid, rfr.get_location(PLAYER))
	end
	lighting.set_location("candle", rfr.get_location(candle.eid))
	lighting.set_position("candle", cpos.x + 7.5 + math.sin(beaver.get_elapsed_time()), cpos.y + 5)
	lighting.set_scale("candle", 0.3 + (math.random() * 2 - 1) * 0.02)
	rfr.set_particle_emitter_config(candle.eid, {emitting_position = {x = cpos.x + 7, y = cpos.y + 6}})
	rfr.set_position(candle.eid, cpos.x, cpos.y)
end

return candle
