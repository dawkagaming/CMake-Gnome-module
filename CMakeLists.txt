cmake_minimum_required(VERSION 3.31)

project(Gnome
    VERSION 0.1
)

include(CMakePackageConfigHelpers)

include(GNUInstallDirs)

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/GnomeConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/GnomeConfig.cmake"
    INSTALL_DESTINATION "${CMAKE_INSTALL_DATADIR}/cmake/${PROJECT_NAME}"
)

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/GnomeConfigVersion.cmake"
    COMPATIBILITY AnyNewerVersion
    ARCH_INDEPENDENT
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/GnomeConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/GnomeConfigVersion.cmake"
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/GnomeFunctions.cmake"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/cmake/${PROJECT_NAME}"
)
