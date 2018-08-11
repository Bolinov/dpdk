MESSAGE(STATUS "----------------------------------------")
MESSAGE(STATUS "----------------------------------------")
MESSAGE(STATUS "----       Micro Thread MODULE      ----")
MESSAGE(STATUS "----------------------------------------")
MESSAGE(STATUS "----------------------------------------")

set(MICRO_THREAD_DIR ${CMAKE_CURRENT_SOURCE_DIR})
AUX_SOURCE_DIRECTORY(. MICRO_SRCS)
list(REMOVE_ITEM MICRO_SRCS echo.cpp)

find_path(TEST_PATH NAMES start.sh
        PATHS ${CMAKE_CURRENT_SOURCE_DIR}
        DOC "Location for FFPATH")

add_library(ffmicro ${MICRO_SRCS})
add_executable(ffmicro_echo echo.cpp)
set(ff_obj_list ffmicro ffmicro_echo)
link_directories(${FFPATH}/lib ${FF_DPDK}/lib)

foreach(one_fcm IN LISTS ff_obj_list)
    target_link_libraries(${one_fcm} m dl crypto pthread) #rt
    if(APPLE)
        message(WARNING "Implementing on APPLE_Platform, using apple_rt")
        target_link_libraries(${one_fcm} apple_rt)
    else()
        message(WARNING "Implementing on Linux Platform, using rt, numa")
        target_link_libraries(${one_fcm} rt numa)
    endif()

    target_compile_definitions(${one_fcm} PUBLIC -DENABLE_FSTACK)
    target_compile_options(${one_fcm} PRIVATE
            -Wl,-L${FFPATH}/lib,--whole-archive,-lfstack,--no-whole-archive
            -Wl,-L${FF_DPDK}/lib,--whole-archive,-ldpdk,--no-whole-archive
            -Wall -g -fPIC -O0 -DMT_REAL_TIME)

    target_include_directories(${one_fcm} PUBLIC ${FFPATH}/lib ${MICRO_THREAD_DIR}/valgrind ${MICRO_THREAD_DIR})

endforeach()

MESSAGE(STATUS "----------------------------------------")
MESSAGE(STATUS "----------------------------------------")
MESSAGE(STATUS "----     End  of  Micro  Thread     ----")
MESSAGE(STATUS "----------------------------------------")
MESSAGE(STATUS "----------------------------------------")
