#pragma once

#include <string>
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
		std::size_t _text_index{0};
		float _time{0};
	};
	struct dialogue_options
	{
		std::vector<std::string> _options;
		unsigned char _selection;
	};
	void draw_dialogue(const mmath::fvec2& actor_position,
			const dialogue& dialogue,
			const std::string& fontname,
			float scale,
			int padding, int wraplength,
			beaver::sdlgame& game);
};
