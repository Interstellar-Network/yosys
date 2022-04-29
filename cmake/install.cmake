################################################################################
#  Handle share/ data [using make]
file(GENERATE OUTPUT ${PROJECT_SOURCE_DIR}/Makefile.conf CONTENT
  # TODO pass correct CXX flags(at least use the same warnings than CMake)
  # ENABLE_DEBUG: NOT ENOUGH, also needs "fno-limit-debug-info"
  # TODO install; handle DATDIR ?
  "ENABLE_LIBYOSYS := 1\nENABLE_ABC := 1\nENABLE_DEBUG := $<IF:$<CONFIG:Debug>,1,0>\nPREFIX := ${CMAKE_CURRENT_BINARY_DIR}/install\n"
)

# https://stackoverflow.com/questions/55174921/cmake-how-to-build-an-external-project-using-all-cores-on-nix-systems
include(ProcessorCount)
ProcessorCount(N)

# we (ab)use "make install" to generate the share/ data
# NOTE: it will recompile everything...
# NOTE2: it will also copy libyosys.so and yosys exe but we DO NOT want those b/c they do not have proper SONAME/SOVERSION
add_custom_command(TARGET libyosys
  POST_BUILD
  COMMAND make -j${N} install
  DEPENDS ${PROJECT_SOURCE_DIR}/Makefile.conf
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
  VERBATIM
  # lots of other files to
  BYPRODUCTS ${CMAKE_CURRENT_BINARY_DIR}/share/yosys/include/kernel/yosys.h
)

################################################################################
# default to only DEB
option(CPACK_BINARY_DEB "<help_text>" ON)
option(CPACK_BINARY_STGZ "<help_text>" OFF)
option(CPACK_BINARY_TBZ2 "<help_text>" OFF)
option(CPACK_BINARY_TGZ "<help_text>" OFF)
option(CPACK_BINARY_TZ "<help_text>" OFF)
option(CPACK_BINARY_ZIP "<help_text>" OFF)

install(TARGETS libyosys LIBRARY DESTINATION lib)
install(TARGETS yosys_exe RUNTIME DESTINATION bin RENAME yosys)
# MUST include/ with trailing slash to copy the CONTENT of include/ to the dest
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/install/share/yosys/include/ DESTINATION include/yosys)
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/install/share/yosys/ DESTINATION share/yosys PATTERN "*/include/*" EXCLUDE)

set(CPACK_PACKAGE_CONTACT "dev@interstellar.gg")
set(CPACK_STRIP_FILES ON)
# "A good package should list its dependencies. This can be turned on with the following variable:"
set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS YES)

include(CPack)

cpack_add_component(applications
  DISPLAY_NAME "Yosys Application"
  DESCRIPTION
   "Yosys executable"
  GROUP Runtime)
cpack_add_component(libraries
  DISPLAY_NAME "Yosys library: libyosys"
  DESCRIPTION
  "Yosys shared library"
  GROUP Development)
cpack_add_component(headers
  DISPLAY_NAME "C++ Headers"
  DESCRIPTION "C/C++ header files for use with libyosys.so"
  GROUP Development
  DEPENDS libraries
  )