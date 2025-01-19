
function rfr.update_audios()
	for _, eid in ipairs(rfr.get_active_entities()) do
		if rfr.get_location(eid) == rfr.get_location(PLAYER) then
			local dialogue_info = rfr.get_dialogue_info(eid)
			if dialogue_info and dialogue_info.verbal and rfr.has_active_dialogue(eid) and not rfr.dialogue_reached_fulllength(eid) then
				if not rfr.get_properties(eid, "dialogue_audio_timer") then
					rfr.set_properties(eid, "dialogue_audio_timer", rfr.add_entity()) end
				local audio_timerid = rfr.get_properties(eid, "dialogue_audio_timer")
				local audio_timer = rfr.get_timer(audio_timerid)
				if audio_timer then
					if not audio_timer.running then
						beaver.play_sound(dialogue_info.sound)
						rfr.set_timer(audio_timerid, 5/config.cpf)
					end
				else
					rfr.set_timer(audio_timerid, 5/config.cpf)
				end
			end

			if eid ~= GHOST then
				local tileanimation_id = rfr.get_tileanimation(eid)
				if tileanimation_id then
					if tileanimation_id.currentid == 5 or tileanimation_id.currentid == 9 then
						if not rfr.get_properties(eid, "footstep") then
							beaver.play_sound("footstep1")
							rfr.set_properties(eid, "footstep", true)
						end
					else
						rfr.set_properties(eid, "footstep", false)
					end
				end
			end
		end
	end
end