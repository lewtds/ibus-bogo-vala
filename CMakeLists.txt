project(ibus-engine-bogo C)
cmake_minimum_required(VERSION 2.6)

SET (APPNAME "${CMAKE_PROJECT_NAME}")
SET (APPLONGNAME "Ibus Engine Bogo")
SET (COPYRIGHT "Ngo Trung <ndtrung4419@gmail.com>")


set (VERSION_MAJOR 0)
set (VERSION_MINOR 1)
set (VERSION_PATCH 0)

#set(GETTEXT_PACKAGE "sleepy")


list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/vala)
include(FindVala)
include(UseVala)

find_package(Vala "0.12" REQUIRED)
include(${VALA_USE_FILE})

#CONFIGURE_FILE( ${CMAKE_SOURCE_DIR}/include/config.h.cmake ${CMAKE_SOURCE_DIR}/include/config.h )
include_directories(${CMAKE_SOURCE_DIR}/include)
LIST(APPEND CFLAGS -DHAVE_CONFIG_H)

find_package(PkgConfig)

#pkg_check_modules(GTK2 REQUIRED gtk+-2.0)
#pkg_check_modules(GEE REQUIRED gee-1.0)
#pkg_check_modules(INDICATOR REQUIRED appindicator-0.1)
#pkg_check_modules(NOTIFY REQUIRED libnotify)
pkg_check_modules(IBUS REQUIRED ibus-1.0)

set(CFLAGS
  ${GTK2_CLAGS} ${GTK2_CFLAGS_OTHER}
  -DGETTEXT_PACKAGE="${APPNAME}"
)
add_definitions(${CFLAGS})

set(LIBS
#  ${GTK2_LIBRARIES}
#  ${GEE_LIBRARIES}
#  ${INDICATOR_LIBRARIES}
#  ${NOTIFY_LIBRARIES}
  ${IBUS_LIBRARIES}
)
link_libraries(${LIBS})

set(LIB_PATHS
#  ${GTK2_LIBRARY_DIRS}
#  ${GEE_LIBRARY_DIRS}
#  ${INDICATOR_LIBRARY_DIRS}
#  ${NOTIFI_LIBRARY_DIRS}
  ${IBUS_LIBRARY_DIRS}
)
link_directories(${LIB_PATHS})

set(INCLUDE_PATHS
#  ${GTK2_INCLUDE_DIRS}
#  ${GEE_INCLUDE_DIRS}
#  ${INDICATOR_INCLUDE_DIRS}
#  ${NOTIFY_INCLUDE_DIRS}
  ${IBUS_INCLUDE_DIRS}
)
include_directories(${INCLUDE_PATHS})

set(VALA_PKGS
#    gtk+-2.0
#    gee-1.0
#    libnotify
    posix
#    appindicator-0.1
    ibus-1.0
)

add_subdirectory(src)
#add_subdirectory(po)
#add_subdirectory(data)

