local audio = {}
local narrative = require "luamodules.narrative"
local narrative_sound_timer = rfr.add_entity()
local ambience = require "audio.ambience"
rfr.set_timer(narrative_sound_timer,0)
function audio.update()
	for _, eid in ipairs(rfr.get_active_entities()) do
		if rfr.get_location(eid) == rfr.get_location(PLAYER) then
			local location = rfr.get_location(PLAYER)
			local dialogue_info = rfr.get_dialogue_info(eid)
			--if dialogue_info and dialogue_info.verbal and rfr.has_active_dialogue(eid) and not rfr.dialogue_reached_fulllength(eid) then
			--	if not rfr.get_properties(eid, "dialogue_audio_timer") then
			--		rfr.set_properties(eid, "dialogue_audio_timer", rfr.add_entity()) end
			--	local audio_timerid = rfr.get_properties(eid, "dialogue_audio_timer")
			--	local audio_timer = rfr.get_timer(audio_timerid)
			--	if audio_timer then
			--		if not audio_timer.running then
			--			beaver.play_sound(dialogue_info.sound)
			--			rfr.set_timer(audio_timerid, 6/config.cpf)
			--		end
			--	else
			--		rfr.set_timer(audio_timerid, 6/config.cpf)
			--	end
			--end

			if rfr.has_tag(eid, "footstep_sound") then
				local tileanimation_id = rfr.get_tileanimation(eid)
				if tileanimation_id and rfr.get_properties(eid, "footstep_sound") then
					if location == "Map.Outside" or location == "Map.Hall" then
						rfr.set_properties(eid, "footstep_sound", eid == PLAYER and ASSETS.audios.footstep_tile_medium or ASSETS.audios.footstep_tile_light)
					else
						rfr.set_properties(eid, "footstep_sound", ASSETS.audios.footstep_wood_light)
					end
					if tileanimation_id.currentid == 5 or tileanimation_id.currentid == 9 then
						if not rfr.get_properties(eid, "footstep") then
							beaver.play_sound(rfr.get_properties(eid,"footstep_sound"))
							rfr.set_properties(eid, "footstep", true)
						end
					else
						rfr.set_properties(eid, "footstep", false)
					end
				end
			end

		end
	end
	if rfr.get_flag("narrative_sound") then
		if narrative.text_appearing() then
			if not rfr.get_timer(narrative_sound_timer).running then
				beaver.play_sound(ASSETS.audios.dialogue1)
				rfr.set_timer(narrative_sound_timer, 6/config.narrative_cpf)
			end
		end
	end

	ambience.update()
end

return audio
