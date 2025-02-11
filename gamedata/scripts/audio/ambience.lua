local ambience = {}
local current_sound_channels = {}
local current_location = nil
local sounds_per_location = {
	["Map.Outside"] = {
		{
			ambience = {"ambience_wind", "ambience_bird"},
			random_sound = {
				{"carpassing",10,0.3},
				{"dog",15,0.3}
			}
		}
	},
	["Map.Mainroom"] = {
		{},
		{
			ambience = {"ambience_cricket"},
		}
	}
}
local function fade_out_ambience()
	for _,channel in ipairs(current_sound_channels) do
		beaver.fade_out_channel(channel, 1000)
	end

	current_sound_channels = {}
end

local function fade_in_ambience(location)
	for _,sounds in ipairs(sounds_per_location[location]) do
		if sounds.ambience then
			for _,sound in ipairs(sounds.ambience) do
				table.insert(current_sound_channels, beaver.fade_in_channel(sound, -1, -1, 1000))
			end
		end
	end
end

local played_sounds = {}
local function play_random_sounds(location)
	for _,sounds in ipairs(sounds_per_location[location]) do
		if sounds.random_sound then
			for _,sound in ipairs(sounds.random_sound) do
				if math.floor(beaver.get_elapsed_time() % sound[2]) == 1 and math.random() < sound[3]
						and not played_sounds[sound[1]] then
					played_sounds[sound[1]] = beaver.play_sound(sound[1])
				end
			end

			for i,channel in pairs(played_sounds) do
				if not beaver.channel_playing(channel) then played_sounds[i] = nil end
			end
		end
	end
end
function ambience.update()
	local plocation = rfr.get_location(PLAYER)
	if sounds_per_location[plocation] ~= nil then
		if current_location ~= plocation then
			current_location = plocation
			fade_out_ambience()
			fade_in_ambience(current_location)
		else
			play_random_sounds(current_location)
		end
	end
end

return ambience
