#pragma once

#include <string>
#include <set>
#include <beaver/sdlgame.hpp>
namespace rfr
{
	// What are the operations ?
	// - Show dialogue on screen (ideally on top of actors head)
	// 		- Character can still move 
	// - Options (respond) 
	// 		- Will appear (can configure how it appear) while other actor is talking
	// 		- Have conditions
	//
	// - change gamestate if needed
	
	// talk() -> show text on actors head
	// respond() -> show available options beside characters
	// how to handle branching ?
	

	struct dialogue
	{
		std::string _content;
		// determine where the bottom center of dialogue box will be in relative to actor position
		mmath::fvec2 _position;
		float _time;
	};


	void draw_dialogue(const mmath::fvec2& actor_position,
			const dialogue& dialogue,
			float scale,
			int padding, int wraplength,
			beaver::sdlgame& game);
};
