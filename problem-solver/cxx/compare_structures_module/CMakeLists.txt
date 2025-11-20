file(GLOB SOURCES CONFIGURE_DEPENDS
        "*.cpp" "*.hpp"
        "agent/*.cpp" "agent/*.hpp"
        "keynodes/*.hpp"
)

add_library(compare_structures_module SHARED ${SOURCES})
target_link_libraries(compare_structures_module
        LINK_PUBLIC sc-machine::sc-memory
)
target_include_directories(compare_structures_module
        PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}
)
set_target_properties(compare_structures_module PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${SC_EXTENSIONS_DIRECTORY})

if(${SC_CLANG_FORMAT_CODE})
    target_clangformat_setup(compare_structures_module)
endif()

if(${SC_BUILD_TESTS})
    set(COMPARE_STRUCTURES_MODULE_SRC_PATH ${CMAKE_CURRENT_SOURCE_DIR})
    add_subdirectory(test)
endif()
