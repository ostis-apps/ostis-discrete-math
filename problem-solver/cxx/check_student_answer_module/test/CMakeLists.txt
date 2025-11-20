make_tests_from_folder(${CMAKE_CURRENT_LIST_DIR}/units
        NAME check_student_answer_module-tests
        DEPENDS sc-machine::sc-builder-lib check_student_answer_module
        INCLUDES ${ADD_SECTION_TO_SET_MODULE_SRC_PATH}
)

if(${SC_CLANG_FORMAT_CODE})
    target_clangformat_setup(check_student_answer_module-tests)
endif()
