local player = require "player"
local character = require "character"
local map = require "map"
local interaction = require "interaction"
local transition = require "transition"
local lighting = require "lighting"
local camera = require "camera"
local cutscene = require "cutscene"
local gamestate = {
	current_state = "ingame"
}


local state = {}
state["menu"] = {
	load = function()
	end,
	update = function(dt)
	end,
	draw = function(dt)
	end
}

state["ingame"] = {
	load = function()
	end,
	update = function(dt)
		cutscene.update(dt)
		character.update()
		player.update(dt)
		interaction.update()
		transition.update(dt)
		camera.update(dt)
		map.set_only_player_location_visible(map.current)
		rfr.update_camera(dt)
		rfr.update_animation(dt)
		rfr.update_dialogue(dt)
		rfr.cleanup_entities()
		return true
	end,
	draw = function()
		beaver.set_draw_color(10,10,10,255)
		beaver.clear()
		rfr.draw_map(map.current, 0, 0)
		for _, eid in ipairs(rfr.get_active_entities()) do
			local bgcolor = lighting.get_background_color()
			rfr.set_tint(eid, bgcolor[1], bgcolor[2], bgcolor[3], bgcolor[4])
			if rfr.get_location(eid) == rfr.get_location(PLAYER) then
				rfr.draw_entities(eid)
			end
		end
		lighting.draw()
		for _, eid in ipairs(rfr.get_active_entities()) do
			if rfr.get_location(eid) == rfr.get_location(PLAYER) then
				beaver.set_draw_color(0,0,0,255)
				rfr.draw_dialogue(eid)
				beaver.set_draw_color(255,255,255,255)
				rfr.draw_interactions_info(eid)
			end
		end
		transition.draw()
	end
}

function gamestate.load()
end

function gamestate.update(dt)
	return state[gamestate.current_state].update(dt)
end

function gamestate.draw()
	state[gamestate.current_state].draw()
end
return gamestate
