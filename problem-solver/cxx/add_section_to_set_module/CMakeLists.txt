file(GLOB SOURCES CONFIGURE_DEPENDS
        "*.cpp" "*.hpp"
        "agent/*.cpp" "agent/*.hpp"
        "keynodes/*.hpp"
)

add_library(add_section_to_set_module SHARED ${SOURCES})
target_link_libraries(add_section_to_set_module
        LINK_PUBLIC sc-machine::sc-memory
)
target_include_directories(add_section_to_set_module
        PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}
)
set_target_properties(add_section_to_set_module PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${SC_EXTENSIONS_DIRECTORY})

if(${SC_CLANG_FORMAT_CODE})
    target_clangformat_setup(add_section_to_set_module)
endif()

if(${SC_BUILD_TESTS})
    set(ADD_SECTION_TO_SET_MODULE_SRC_PATH ${CMAKE_CURRENT_SOURCE_DIR})
    add_subdirectory(test)
endif()
