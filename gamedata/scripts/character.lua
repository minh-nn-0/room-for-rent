CHARACTER_INFO = {
	main_male = {
		name = "Sáng",
		department = "IT",
	},
	main_female = {
		name = "Mây",
		department = "IT"
	},
	neighbour = {
		name = "Trà"
	},
	woman = {
		name = "Thắm"
	}
}
local current_main_character = config.current_main_character
local character = {}

OWNER = rfr.add_entity()
NEIGHBOUR = rfr.add_entity()
rfr.add_tag(OWNER, "npc")
rfr.add_tag(NEIGHBOUR, "npc")
rfr.add_tag(NEIGHBOUR, "footstep_sound")
rfr.set_position(OWNER, 1000,1000)
rfr.set_position(NEIGHBOUR, 1000,1000)
rfr.set_properties(OWNER, "walkspeed", 0.3)
rfr.set_properties(NEIGHBOUR, "walkspeed", 0.5)
rfr.set_properties(OWNER, "footstep_sound", "footstep_tile_light")
rfr.set_properties(OWNER, "facing_direction", "left")
rfr.set_properties(NEIGHBOUR, "facing_direction", "left")
rfr.set_image(OWNER, ASSETS.images.woman)
rfr.set_image(NEIGHBOUR, ASSETS.images.neighbour)
rfr.set_state_entry(OWNER, "idle",
	function()
		rfr.set_tileanimation(OWNER, {
			frames = {{0,400},{1,200},{2,200},{3,200}},
			framewidth = 32,
			frameheight = 32,
			["repeat"] = true
		})
	end)
rfr.set_state_entry(OWNER, "move",
	function()
		local speed = config.base_character_move_animation_speed / rfr.get_properties(OWNER, "walkspeed")
		rfr.set_tileanimation(OWNER, {
			frames = {{4,speed},{5,speed},{6,speed},{7,speed},{8,speed},{9,speed},{10,speed},{11,speed}},
			framewidth = 32,
			frameheight = 32,
			["repeat"] = true
		})
	end)
rfr.set_state(OWNER, "idle")

rfr.set_state_entry(NEIGHBOUR, "idle",
	function()
		rfr.set_tileanimation(NEIGHBOUR, {
			frames = {{0,400},{1,200},{2,200},{3,200}},
			framewidth = 32,
			frameheight = 32,
			["repeat"] = true
		})
	end)
rfr.set_state(NEIGHBOUR, "idle")

function character.getTextByCharacter(text, characterType)
	if characterType == 'main' then
		local nameByType =  characterType .. "_" .. current_main_character
		local characterName =  CHARACTER_INFO[nameByType]['name']
		return text:gsub("{name}", characterName)
	else
		local characterName = CHARACTER_INFO[characterType]['name']
		return text:gsub("{name}", characterName)
	end
end

function rfr.update_character(dt)
	for _,char in ipairs(rfr.get_entities_with_tags({"npc"})) do
		local dir = rfr.get_properties(char, "facing_direction")
		if dir == "left" then
			rfr.set_flipflag(char, beaver.FLIP_H)
			rfr.set_dialogue_position(char, 10, -3)
		else
			rfr.set_flipflag(char, beaver.FLIP_NONE)
			rfr.set_dialogue_position(char, 22, -3)
		end
		if rfr.get_state(char) == "move" then
			local pos = rfr.get_position(char)
			local speed = rfr.get_properties(char, "walkspeed")
			if dir == "left" then
				pos.x = pos.x - speed
			else
				pos.x = pos.x + speed
			end
			rfr.set_position(char, pos.x, pos.y)
		end
	end
end
return character
