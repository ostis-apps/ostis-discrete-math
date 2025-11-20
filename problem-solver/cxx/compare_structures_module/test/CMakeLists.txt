make_tests_from_folder(${CMAKE_CURRENT_LIST_DIR}/units
        NAME compare_structures_module-tests
        DEPENDS sc-machine::sc-builder-lib compare_structures_module
        INCLUDES ${COMPARE_STRUCTURES_MODULE_SRC_PATH}
)

if(${SC_CLANG_FORMAT_CODE})
    target_clangformat_setup(compare_structures_module-tests)
endif()
