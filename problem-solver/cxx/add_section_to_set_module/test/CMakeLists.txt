make_tests_from_folder(${CMAKE_CURRENT_LIST_DIR}/units
        NAME add_section_to_set_module-tests
        DEPENDS sc-machine::sc-builder-lib add_section_to_set_module
        INCLUDES ${ADD_SECTION_TO_SET_MODULE_SRC_PATH}
)

if(${SC_CLANG_FORMAT_CODE})
    target_clangformat_setup(add_section_to_set_module-tests)
endif()
