cmake_minimum_required(VERSION 3.25)

project(rfr)

add_executable(rfr 
	${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp
	${CMAKE_CURRENT_SOURCE_DIR}/src/game.cpp
	${CMAKE_CURRENT_SOURCE_DIR}/src/dialogue.cpp
)

target_compile_definitions(rfr PRIVATE
	GAMEPATH="${CMAKE_CURRENT_SOURCE_DIR}"
)
target_link_libraries(rfr PRIVATE beaver)
