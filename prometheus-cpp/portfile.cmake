set(SOURCE_PATH "${VCPKG_ROOT_DIR}/../prometheus-cpp")

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DUSE_THIRDPARTY_LIBRARIES=OFF # use vcpkg packages
        -DENABLE_PULL=ON
        -DENABLE_PUSH=OFF
        -DGENERATE_PKGCONFIG=OFF
        -DENABLE_COMPRESSION=ON
        -DENABLE_TESTING=OFF
)

vcpkg_cmake_install()

vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/prometheus-cpp")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# Handle copyright
configure_file("${SOURCE_PATH}/LICENSE" "${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright" COPYONLY)
