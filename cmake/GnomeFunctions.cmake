cmake_minimum_required(VERSION 3.31)

function(gnome_compile_resources)
    set(flags
        GRESOURCE_BUNDLE)
    set(args
        FILE
        OUTPUT_VAR
        C_NAME)
    set(listArgs
        EXTRA_ARGS
        DEPENDENCIES
        SOURCE_DIRS)

    cmake_parse_arguments(arg "${flags}" "${args}" "${listArgs}" ${ARGN})

    find_program(GLIB_COMPILE_RESOURCES_BINARY glib-compile-resources REQUIRED)

    if(NOT IS_ABSOLUTE "${arg_FILE}")
        set(arg_FILE "${CMAKE_CURRENT_SOURCE_DIR}/${arg_FILE}")
    endif()

    # Check file
    if(NOT IS_READABLE "${arg_FILE}")
        message(FATAL_ERROR "[gnome_compile_resources]: The input file provided (${arg_FILE}) is not readable!")
    endif()

    # Check OUTPUT_VAR
    if(NOT arg_OUTPUT_VAR)
        message(FATAL_ERROR "[gnome_compile_resources]: OUTPUT_VAR is required!")
    endif()

    # Assemble command options
    set(COMMON_ARGS)

    list(APPEND COMMON_ARGS ${arg_EXTRA_ARGS})

    if(arg_C_NAME)
        list(APPEND COMMON_ARGS "--c-name" "${arg_C_NAME}")
    endif()

    if(arg_SOURCE_DIRS)
        foreach(DIR_TO_CHECK "${arg_SOURCE_DIRS}")
            if(NOT IS_ABSOLUTE "${DIR_TO_CHECK}")
                set(DIR_TO_CHECK "${CMAKE_CURRENT_SOURCE_DIR}/${DIR_TO_CHECK}")
            endif()

            if(IS_DIRECTORY "${DIR_TO_CHECK}")
                list(APPEND COMMON_ARGS "--sourcedir" "${DIR_TO_CHECK}")
            else()
                message(FATAL_ERROR "[gnome_compile_resources]: Path passed to SOURCE_DIRS (${DIR_TO_CHECK}) is not a proper directory path!")
            endif()
        endforeach()
    else()
        get_filename_component(FILE_DIRECTORY "${arg_FILE}" DIRECTORY)

        list(APPEND COMMON_ARGS "--sourcedir" "${FILE_DIRECTORY}")
    endif()

    # Get input file name without extensions
    get_filename_component(FILE_NAME "${arg_FILE}" NAME_WE)

    # Final execution
    if(arg_GRESOURCE_BUNDLE)
        set(TARGET_GRESOURCE "${CMAKE_CURRENT_BINARY_DIR}/${FILE_NAME}.gresource")

        set(DEPENDENCY_FILE "${CMAKE_CURRENT_BINARY_DIR}/${FILE_NAME}.gresource.depfile")

        list(APPEND GRESOURCE_ARGS ${COMMON_ARGS} "--target" "${TARGET_GRESOURCE}" "--dependency-file" "${DEPENDENCY_FILE}")

        add_custom_command(
            OUTPUT "${TARGET_GRESOURCE}"
            COMMAND "${GLIB_COMPILE_RESOURCES_BINARY}" ${GRESOURCE_ARGS} "${arg_FILE}"
            DEPENDS "${arg_FILE}" ${arg_DEPENDENCIES}
            DEPFILE "${DEPENDENCY_FILE}"
            CODEGEN
            COMMENT "[gnome_compile_resources]: Compiling resources from file ${arg_FILE}"
        )

        list(APPEND OUTPUT_TARGETS "${TARGET_GRESOURCE}")
        set("${arg_OUTPUT_VAR}" "${OUTPUT_TARGETS}" PARENT_SCOPE)
    else()
        set(TARGET_SOURCE "${CMAKE_CURRENT_BINARY_DIR}/${FILE_NAME}.c")

        set(DEPENDENCY_FILE "${CMAKE_CURRENT_BINARY_DIR}/${FILE_NAME}.c.depfile")

        list(APPEND SOURCE_ARGS ${COMMON_ARGS} "--generate-source" "--target" "${TARGET_SOURCE}" "--dependency-file" "${DEPENDENCY_FILE}")

        set(TARGET_HEADER "${CMAKE_CURRENT_BINARY_DIR}/${FILE_NAME}.h")
        list(APPEND HEADER_ARGS ${COMMON_ARGS} "--generate-header" "--target" "${TARGET_HEADER}")

        add_custom_command(
            OUTPUT "${TARGET_SOURCE}" "${TARGET_HEADER}"
            COMMAND "${GLIB_COMPILE_RESOURCES_BINARY}" ${SOURCE_ARGS} "${arg_FILE}"
            COMMAND "${GLIB_COMPILE_RESOURCES_BINARY}" ${HEADER_ARGS} "${arg_FILE}"
            DEPENDS "${arg_FILE}" ${arg_DEPENDENCIES}
            DEPFILE "${DEPENDENCY_FILE}"
            CODEGEN
            COMMENT "[gnome_compile_resources]: Compiling resources from file ${arg_FILE}"
        )

        list(APPEND OUTPUT_TARGETS "${TARGET_SOURCE}" "${TARGET_HEADER}")
        set("${arg_OUTPUT_VAR}" "${OUTPUT_TARGETS}" PARENT_SCOPE)
    endif()
endfunction()

function(gnome_compile_schemas)
    set(flags)
    set(args VERSION)
    set(listArgs)

    cmake_parse_arguments(arg "${flags}" "${args}" "${listArgs}" ${ARGN})

    message(FATAL_ERROR "[gnome_compile_schemas]: This function is not yet ready!")
endfunction()

function(gnome_post_install)
    set(flags
        GLIB_COMPILE_SCHEMAS
        GIO_QUERYMODULES
        GTK_UPDATE_ICON_CACHE
        UPDATE_DESKTOP_DATABASE
        UPDATE_MIME_DATABASE)
    set(args VERSION)
    set(listArgs)

    cmake_parse_arguments(arg "${flags}" "${args}" "${listArgs}" ${ARGN})

    if(LINUX AND (NOT DEFINED ENV{DESTDIR}) AND (NOT DEFINED GNOME_POST_INSTALL_ADDED))
        set(GNOME_POST_INSTALL_ADDED TRUE CACHE INTERNAL "")
        
        if(arg_GLIB_COMPILE_SCHEMAS)
            find_program(GLIB_COMPILE_SCHEMAS_BINARY glib-compile-schemas REQUIRED)

            install(CODE "execute_process()")
        endif()

        if(arg_GIO_QUERYMODULES)
            find_program(GIO_QUERYMODULES_BINARY gio-querymodules REQUIRED)
        endif()

        if(arg_GTK_UPDATE_ICON_CACHE)
            find_program(GTK_UPDATE_ICON_CACHE_BINARY gtk-update-icon-cache REQUIRED)
        endif()

        if(arg_UPDATE_DESKTOP_DATABASE)
            find_program(UPDATE_DESKTOP_DATABASE_BINARY update-desktop-database REQUIRED)
        endif()

        if(arg_UPDATE_MIME_DATABASE)
            find_program(UPDATE_MIME_DATABASE_BINARY update-mime-database REQUIRED)
        endif()
    endif()

    message(FATAL_ERROR "[gnome_post_install]: This function is not yet ready!")
endfunction()