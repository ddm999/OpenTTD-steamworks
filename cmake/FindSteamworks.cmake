#[=======================================================================[.rst:
FindSteamworks
-------

Finds the Steamworks API.

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``Steamworks_FOUND``
  True if the system has the Steamworks API.
``Steamworks_INCLUDE_DIRS``
  Include directories needed to use the Steamworks API.
``Steamworks_LIBRARIES``
  Needed Steamworks API redistributable libraries.
``Steamworks_VERSION``
  The version of Steamworks which was found.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``STEAMWORKS_INCLUDE_DIR``
  The directory containing ``steam_api.h``.
``STEAMWORKS_LIBRARY``
  The path to the Steamworks API redistributables.

#]=======================================================================]

find_path(STEAMWORKS_INCLUDE_DIR
    NAMES steam_api.h
    PATHS ${STEAMWORKS_DIR}\\public\\steam
    NO_DEFAULT_PATH
)

if(WIN32)
    if(CMAKE_SYSTEM_PROCESSOR STREQUAL "AMD64")
        find_library(STEAMWORKS_LIBRARY
            NAMES steam_api64
            PATHS ${STEAMWORKS_DIR}\\redistributable_bin\\win64 ${STEAMWORKS_DIR}\\public\\steam\\lib\\win64
            NO_DEFAULT_PATH
        )
    else()
        find_library(STEAMWORKS_LIBRARY
            NAMES steam_api
            PATHS ${STEAMWORKS_DIR}\\redistributable_bin ${STEAMWORKS_DIR}\\public\\steam\\lib\\win32
            NO_DEFAULT_PATH
        )
    endif()
elseif(UNIX)
    if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
        find_library(STEAMWORKS_LIBRARY
            NAMES libsteam_api
            PATHS ${STEAMWORKS_DIR}\\redistributable_bin\\linux64 ${STEAMWORKS_DIR}\\public\\steam\\lib\\linux64
            NO_DEFAULT_PATH
        )
    else()
        find_library(STEAMWORKS_LIBRARY
            NAMES libsteam_api
            PATHS ${STEAMWORKS_DIR}\\redistributable_bin\\linux32 ${STEAMWORKS_DIR}\\public\\steam\\lib\\linux32
            NO_DEFAULT_PATH
        )
    endif()
elseif(APPLE)
    find_library(STEAMWORKS_LIBRARY
        NAMES libsteam_api
        PATHS ${STEAMWORKS_DIR}\\redistributable_bin\\osx ${STEAMWORKS_DIR}\\public\\steam\\lib\\osx
        NO_DEFAULT_PATH
    )
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Steamworks
    FOUND_VAR Steamworks_FOUND
    REQUIRED_VARS
        STEAMWORKS_LIBRARY
        STEAMWORKS_INCLUDE_DIR
)

if(Steamworks_FOUND)
    set(Steamworks_LIBRARIES ${STEAMWORKS_LIBRARY})
    set(Steamworks_INCLUDE_DIRS ${STEAMWORKS_INCLUDE_DIR})
endif()

mark_as_advanced(
    STEAMWORKS_LIBRARY
    STEAMWORKS_INCLUDE_DIR
)
