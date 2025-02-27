cmake_minimum_required(VERSION 3.25)

project(rfr)

add_executable(rfr 
	${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp
	${CMAKE_CURRENT_SOURCE_DIR}/src/game.cpp
	${CMAKE_CURRENT_SOURCE_DIR}/src/interaction.cpp
	${CMAKE_CURRENT_SOURCE_DIR}/src/event.cpp
	${CMAKE_CURRENT_SOURCE_DIR}/src/cutscene.cpp
	${CMAKE_CURRENT_SOURCE_DIR}/src/dialogue.cpp
	${CMAKE_CURRENT_SOURCE_DIR}/src/textbox_drawing.cpp
	${CMAKE_CURRENT_SOURCE_DIR}/src/note_drawing.cpp
	${CMAKE_CURRENT_SOURCE_DIR}/src/asset_loader.cpp
)
target_compile_definitions(rfr PRIVATE
	GAMEPATH="${CMAKE_CURRENT_SOURCE_DIR}"
)
if (EMSCRIPTEN)
	add_custom_command(
		TARGET rfr PRE_BUILD
		COMMAND ${CMAKE_COMMAND} -E copy_directory
			"${CMAKE_CURRENT_SOURCE_DIR}/gamedata"
			"${CMAKE_CURRENT_BINARY_DIR}/gamedata"
		COMMENT "Copying gamedata to build directory"
	)
	target_link_options(rfr PRIVATE --preload-file=gamedata -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_TTF=2 -sUSE_SDL_MIXER=2) 
	set_target_properties(rfr PROPERTIES SUFFIX ".html")
	target_link_options(rfr PRIVATE -sALLOW_MEMORY_GROWTH)
endif()

target_link_libraries(rfr PRIVATE beaver)
#target_link_options(rfr PRIVATE $<$<CONFIG:Debug>:"-lreadline">)
