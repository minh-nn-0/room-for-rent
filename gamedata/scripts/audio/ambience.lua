local ambience = {}
local current_sound_channels = {}
local current_location = ""
local current_tod = 0
local sounds_per_location = {
	["Map.Outside"] = {
		{
			ambience = {ASSETS.audios.ambience_wind},
			random_sound = {
				{ASSETS.audios.carpassing,60,0.4},
				{ASSETS.audios.dog,60,0.2}
			}
		},
		{
			ambience = {ASSETS.audios.ambience_wind, ASSETS.audios.ambience_cricket},
		},
	},
	["Map.Mainroom"] = {
		{
			ambience = {},
			random_sound = {
				{ASSETS.audios.bird, 40, 0.3}
			}
		},
		{
			ambience = {ASSETS.audios.ambience_cricket},
		}
	},
	["Map.Dream"] = {
		{},
		{
			ambience = {ASSETS.audios.creepy_atmosphere},
			random_sound = {
				{ASSETS.audios.crack1, 40, 0.1},
				{ASSETS.audios.crack3, 40, 0.15},
				{ASSETS.audios.crack5, 40, 0.2},
			}
		}
	}
}
local function fade_out_ambience()
	for _,channel in ipairs(current_sound_channels) do
		beaver.fade_out_channel(channel, 1000)
	end

	current_sound_channels = {}
end

local function fade_in_ambience(location, tod)
	local sounds = sounds_per_location[location][tod]
	if sounds.ambience then
		for _,sound in ipairs(sounds.ambience) do
			table.insert(current_sound_channels, beaver.fade_in_channel(sound, -1, -1, 1000))
		end
	end
end

local played_sounds = {}
local function play_random_sounds(location, tod)
	local sounds = sounds_per_location[location][tod]
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
function ambience.update()
	local plocation = rfr.get_location(PLAYER)
	local _, tod = rfr.current_time()

	if current_location ~= plocation or current_tod ~= tod then
		current_location = plocation
		current_tod = tod
		fade_out_ambience()
	end
	if sounds_per_location[current_location] ~= nil then
		play_random_sounds(current_location, current_tod)
		if (#current_sound_channels == 0) then
			fade_in_ambience(current_location, current_tod)
		end
	end
end

return ambience
