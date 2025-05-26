make_tests_from_folder(${CMAKE_CURRENT_LIST_DIR}/units
        NAME example-module-tests
        DEPENDS sc-machine::sc-builder-lib example-module
        INCLUDES ${EXAMPLE_MODULE_SRC_PATH}
)

if(${SC_CLANG_FORMAT_CODE})
    target_clangformat_setup(example-module-tests)
endif()
