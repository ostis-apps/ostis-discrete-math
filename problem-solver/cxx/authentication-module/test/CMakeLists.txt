make_tests_from_folder(${CMAKE_CURRENT_LIST_DIR}/units
        NAME authentication-module-tests
        DEPENDS sc-machine::sc-builder-lib authentication-module
        INCLUDES ${EXAMPLE_MODULE_SRC_PATH}
)

if(${SC_CLANG_FORMAT_CODE})
    target_clangformat_setup(authentication-module-tests)
endif()
