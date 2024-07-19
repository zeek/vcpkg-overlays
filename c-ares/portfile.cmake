string(REGEX MATCH "^([0-9]+)\\.([0-9]+)\\.([0-9]+)" _c_ares_version
             "${VERSION}")
set(_c_ares_version_major "${CMAKE_MATCH_1}")
set(_c_ares_version_minor "${CMAKE_MATCH_2}")
set(_c_ares_version_patch "${CMAKE_MATCH_3}")

set(SOURCE_PATH "${VCPKG_ROOT_DIR}/../c-ares")

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" BUILD_STATIC)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED)

vcpkg_cmake_configure(
  SOURCE_PATH
  "${SOURCE_PATH}"
  OPTIONS
  -DCARES_STATIC=${BUILD_STATIC}
  -DCARES_SHARED=${BUILD_SHARED}
  -DCARES_BUILD_TOOLS=OFF
  -DCARES_BUILD_TESTS=OFF
  -DCARES_BUILD_CONTAINER_TESTS=OFF)

vcpkg_cmake_install()

vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/c-ares)
vcpkg_fixup_pkgconfig()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
  vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/ares.h"
                       "#  ifdef CARES_STATICLIB" "#if 1")
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static" OR NOT VCPKG_TARGET_IS_WINDOWS)
  file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin"
       "${CURRENT_PACKAGES_DIR}/debug/bin") # Empty folders
endif()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include"
     "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage"
     DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(
  INSTALL "${SOURCE_PATH}/LICENSE.md"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)
