################################################################################

# c++17: needed for string_view
# c++20: why not?
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

cmake_minimum_required(VERSION 3.22)

################################################################################

find_library(YOSYS_LIBRARY yosys REQUIRED)
find_path(YOSYS_INCLUDE_DIR kernel/yosys.h REQUIRED
          PATH_SUFFIXES yosys)

################################################################################

add_library(verilog_compiler
    verilog_compiler.cpp
)

target_link_libraries(verilog_compiler
    PRIVATE
    # IMPORTANT: Yosys passes are "auto registered" which means that they are NOT
    # directly used. Which causes them to be optmized out when static linking
    # eg "ERROR: No such command: techmap"
    # We MUST use "whole-archive" when using STATIC to make it work.
    # -Wl,--whole-archive
    ${YOSYS_LIBRARY}
    # -Wl,--no-whole-archive
)

target_include_directories(verilog_compiler
    PRIVATE
    ${YOSYS_INCLUDE_DIR}
)

target_compile_definitions(verilog_compiler
    PRIVATE
    # kernel/yosys.h:75:4: error: It looks like you are trying to build Yosys without the config defines set.          When building Yosys with a custom make system, make sure you set all the          defines the Yosys Makefile would set for your build configuration.
    # [build] #  error It looks like you are trying to build Yosys without the config defines set. \
    _YOSYS_
)

################################################################################

add_executable(test_yosys
    main.cpp
)

target_link_libraries(test_yosys
    PRIVATE
    verilog_compiler
)