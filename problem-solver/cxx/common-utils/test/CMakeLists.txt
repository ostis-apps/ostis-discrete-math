make_tests_from_folder(${CMAKE_CURRENT_LIST_DIR}/units
        NAME common-utils-tests
        DEPENDS sc-machine::sc-builder-lib common-utils
        INCLUDES ${EXAMPLE_MODULE_SRC_PATH}
)

if(${SC_CLANG_FORMAT_CODE})
    target_clangformat_setup(common-utils-tests)
endif()
