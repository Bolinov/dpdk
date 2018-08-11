MESSAGE(STATUS "----------------------------------------")
MESSAGE(STATUS "----------------------------------------")
MESSAGE(STATUS "----         FSTACK  MODULE         ----")
MESSAGE(STATUS "----------------------------------------")
MESSAGE(STATUS "----------------------------------------")

set(FFPATH ${CMAKE_CURRENT_SOURCE_DIR}/f-stack)
set(FF_DPDK ${FFPATH}/dpdk/x86_64-native-linuxapp-gcc)

# Library

# add_subdirectory(f-stack)
add_subdirectory(micro_thread)

MESSAGE(STATUS "----------------------------------------")
MESSAGE(STATUS "----------------------------------------")
MESSAGE(STATUS "----         End of FSTACK          ----")
MESSAGE(STATUS "----------------------------------------")
MESSAGE(STATUS "----------------------------------------")