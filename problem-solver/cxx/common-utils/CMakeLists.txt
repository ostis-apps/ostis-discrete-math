file(GLOB SOURCES CONFIGURE_DEPENDS
        "keynodes/*.hpp"
        "utils/*.cpp" "utils/*.hpp"
)

add_library(common-utils SHARED ${SOURCES})
target_link_libraries(common-utils
        LINK_PUBLIC sc-machine::sc-memory
)
target_include_directories(common-utils
        PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}
)
set_target_properties(common-utils PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${SC_EXTENSIONS_DIRECTORY})

if(${SC_CLANG_FORMAT_CODE})
    target_clangformat_setup(common-utils)
endif()

if(${SC_BUILD_TESTS})
#     add_subdirectory(test)
endif()
