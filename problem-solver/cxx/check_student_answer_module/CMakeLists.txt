file(GLOB SOURCES CONFIGURE_DEPENDS
        "*.cpp" "*.hpp"
        "agent/*.cpp" "agent/*.hpp"
        "keynodes/*.hpp"
)

add_library(check_student_answer_module SHARED ${SOURCES})
target_link_libraries(check_student_answer_module
        LINK_PUBLIC sc-machine::sc-memory
)
target_include_directories(check_student_answer_module
        PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}
)
set_target_properties(check_student_answer_module PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${SC_EXTENSIONS_DIRECTORY})

if(${SC_CLANG_FORMAT_CODE})
    target_clangformat_setup(check_student_answer_module)
endif()

if(${SC_BUILD_TESTS})
    set(CHECK_STUDENT_ANSWER_MODULE_SRC_PATH ${CMAKE_CURRENT_SOURCE_DIR})
    add_subdirectory(test)
endif()
