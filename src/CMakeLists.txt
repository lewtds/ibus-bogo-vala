vala_precompile(VALA_C
SOURCES
    main.vala
    engine.vala
    #factory.vala
PACKAGES
    ${VALA_PKGS}
#CUSTOM_VAPIS
#    ${CMAKE_SOURCE_DIR}/vapi/config.vapi
)


add_executable(ibus-engine-bogo ${VALA_C})

#install(TARGETS
#    ibus-engine-bogo
#DESTINATION
#    ${CMAKE_INSTALL_PREFIX}/bin
#)
