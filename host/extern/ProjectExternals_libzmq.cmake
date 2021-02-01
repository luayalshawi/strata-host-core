#
# libzmq
#

get_git_hash_and_installation_status("${SOURCE_DIR_EXTERN}/libzmq" "${EXTERN_INSTALL_DIR_PATH}/libzmq")
if(NOT LIB_INSTALLED)
    file(MAKE_DIRECTORY ${EXTERN_INSTALL_DIR_PATH}/libzmq-${GIT_HASH}/include)
    file(MAKE_DIRECTORY ${EXTERN_INSTALL_DIR_PATH}/libzmq-${GIT_HASH}/lib)

    if(WIN32)
        ExternalProject_Add(libzmq
            INSTALL_DIR ${EXTERN_INSTALL_DIR_PATH}/libzmq-${GIT_HASH}
            SOURCE_DIR ${SOURCE_DIR_EXTERN}/libzmq
            EXCLUDE_FROM_ALL ON
            CMAKE_ARGS "${CMAKE_ARGS}"
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                -DCMAKE_PDB_OUTPUT_DIRECTORY=<INSTALL_DIR>/bin
                -DWITH_PERF_TOOL=OFF
                -DZMQ_BUILD_TESTS=OFF
                -DENABLE_CPACK=OFF

            PATCH_COMMAND ${GIT_EXECUTABLE} reset --hard && ${GIT_EXECUTABLE} apply --verbose --ignore-space-change --ignore-whitespace ${CMAKE_CURRENT_SOURCE_DIR}/patches/libzmq/jom-build-support.patch
            && ${GIT_EXECUTABLE} apply --verbose --ignore-space-change --ignore-whitespace ${CMAKE_CURRENT_SOURCE_DIR}/patches/libzmq/remove-library-name-postfix.patch

            INSTALL_COMMAND ${CMAKE_COMMAND} --build . --target install
            COMMAND ${CMAKE_COMMAND} -E copy_if_different <INSTALL_DIR>/bin/libzmq$<$<CONFIG:DEBUG>:d>${CMAKE_SHARED_LIBRARY_SUFFIX} ${CMAKE_BINARY_DIR}/bin
        )
    else()
        ExternalProject_Add(libzmq
            INSTALL_DIR ${EXTERN_INSTALL_DIR_PATH}/libzmq-${GIT_HASH}
            SOURCE_DIR ${SOURCE_DIR_EXTERN}/libzmq
            EXCLUDE_FROM_ALL ON
            CMAKE_ARGS "${CMAKE_ARGS}"
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                -DCMAKE_MACOSX_RPATH=0
                -DWITH_PERF_TOOL=OFF
                -DZMQ_BUILD_TESTS=OFF
                -DENABLE_CPACK=OFF

            INSTALL_COMMAND ${CMAKE_COMMAND} --build . --target install
        )
    endif()
else()
    if(WIN32)
        # TODO: RS: File output build dependency for ExternalProject_Add in CMake
        # https://jira.onsemi.com/browse/CS-1442
        file(COPY "${EXTERN_INSTALL_DIR_PATH}/libzmq-${GIT_HASH}/bin/libzmq${CMAKE_DEBUG_POSTFIX}${CMAKE_SHARED_LIBRARY_SUFFIX}"
            DESTINATION "${CMAKE_BINARY_DIR}/bin")
    endif()
endif()

add_library(zeromq::libzmq SHARED IMPORTED GLOBAL)

if(WIN32)
    set_target_properties(zeromq::libzmq PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${EXTERN_INSTALL_DIR_PATH}/libzmq-${GIT_HASH}/include"
            IMPORTED_LOCATION "${CMAKE_BINARY_DIR}/bin/libzmq${CMAKE_SHARED_LIBRARY_SUFFIX}"
            IMPORTED_LOCATION_DEBUG "${CMAKE_BINARY_DIR}/bin/libzmqd${CMAKE_SHARED_LIBRARY_SUFFIX}"
            IMPORTED_IMPLIB "${EXTERN_INSTALL_DIR_PATH}/libzmq-${GIT_HASH}/lib/libzmq${CMAKE_STATIC_LIBRARY_SUFFIX}"
            IMPORTED_IMPLIB_DEBUG "${EXTERN_INSTALL_DIR_PATH}/libzmq-${GIT_HASH}/lib/libzmqd${CMAKE_STATIC_LIBRARY_SUFFIX}"
    )
else()
    set_target_properties(zeromq::libzmq PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${EXTERN_INSTALL_DIR_PATH}/libzmq-${GIT_HASH}/include"
            IMPORTED_LOCATION "${EXTERN_INSTALL_DIR_PATH}/libzmq-${GIT_HASH}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}zmq${CMAKE_SHARED_LIBRARY_SUFFIX}"
    )
endif()
add_dependencies(zeromq::libzmq DEPENDS libzmq)
# TODO: cppzmq (c++ headers only zmq wrapper) & zhelper.hpp are still referenced from our source code
# https://jira.onsemi.com/browse/CS-1416
