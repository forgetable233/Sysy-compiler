cmake_minimum_required(VERSION 3.16)
set(CMAKE_CXX_COMPILER g++)
project(compiler)

set(CMAKE_CXX_STANDARD 17)

set(CPP_MODE ON)
if (CPP_MODE)
    set(FB_EXT ".cpp")
else ()
    set(FB_EXT ".c")
endif ()

if(MSVC)
    add_compile_options(/W3)
else()
    # disable warnings caused by old version of Flex
    add_compile_options(-Wall -Wno-register)
endif()

set(LIB_DIR "$ENV{CDE_LIBRARY_PATH}/native" CACHE STRING "directory of libraries")
set(INC_DIR "$ENV{CDE_INCLUDE_PATH}" CACHE STRING "directory of includes")
message(STATUS "Library directory: ${LIB_DIR}")
message(STATUS "Include directory: ${INC_DIR}")

# find Flex/Bison
find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)
find_package(LLVM REQUIRED CONFIG)

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

#generate lexer/parser
file(GLOB_RECURSE L_SOURCES "src/*.l")
file(GLOB_RECURSE Y_SOURCES "src/*.y")
if(NOT (L_SOURCES STREQUAL "" AND Y_SOURCES STREQUAL ""))
    string(REGEX REPLACE ".*/(.*)\\.l" "${CMAKE_CURRENT_BINARY_DIR}/\\1.lex${FB_EXT}" L_OUTPUTS "${L_SOURCES}")
    string(REGEX REPLACE ".*/(.*)\\.y" "${CMAKE_CURRENT_BINARY_DIR}/\\1.tab${FB_EXT}" Y_OUTPUTS "${Y_SOURCES}")
    flex_target(Lexer ${L_SOURCES} ${L_OUTPUTS})
    bison_target(Parser ${Y_SOURCES} ${Y_OUTPUTS})
    add_flex_bison_dependency(Lexer Parser)
endif()

# project link directories
link_directories(${LIB_DIR})

# project include directories
link_directories(src)
link_directories(${CMAKE_CURRENT_BINARY_DIR})
link_directories(${INC_DIR})
link_directories(${LLVM_LIBRARY_DIRS})

#file(GLOB_RECURSE C_SOURCES "src/*.c")
file(GLOB_RECURSE CXX_SOURCES "src/*.cpp")
file(GLOB_RECURSE CC_SOURCES "src/*.cc")
file(GLOB_RECURSE H_SOURCES "src/*.h")
set(SOURCES ${C_SOURCES} ${CXX_SOURCES} ${CC_SOURCES}
        ${FLEX_Lexer_OUTPUTS} ${BISON_Parser_OUTPUT_SOURCE} ${H_SOURCES})

llvm_map_components_to_libnames(llvm_libs support core irreader)
add_compile_options(-g -std=c++17)
add_executable(minic ${SOURCES})
set_target_properties(minic PROPERTIES C_STANDARD 11 CXX_STANDARD 17)
target_link_libraries(minic pthread dl LLVM)


#add_executable(func func.cpp)

#add_executable(test test.cpp)
