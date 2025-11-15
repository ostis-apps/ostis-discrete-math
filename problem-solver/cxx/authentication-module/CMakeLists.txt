file(GLOB SOURCES CONFIGURE_DEPENDS
        "*.cpp" "*.hpp"
        "agent/*.cpp" "agent/*.hpp"
        "keynodes/*.hpp"
        "searcher/*.cpp" "searcher/*.hpp"
        "utils/*.cpp" "utils/*.hpp"
)

add_library(authentication-module SHARED ${SOURCES})
target_link_libraries(authentication-module
        LINK_PUBLIC sc-machine::sc-memory
        LINK_PUBLIC OpenSSL::SSL
        LINK_PUBLIC OpenSSL::Crypto
        LINK_PUBLIC common-utils
)
target_include_directories(authentication-module
        PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}
)
set_target_properties(authentication-module PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${SC_EXTENSIONS_DIRECTORY})

if(${SC_CLANG_FORMAT_CODE})
    target_clangformat_setup(authentication-module)
endif()

if(${SC_BUILD_TESTS})
    add_subdirectory(test)
endif()
