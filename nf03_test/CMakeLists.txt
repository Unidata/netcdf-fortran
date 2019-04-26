SET(CMAKE_VERBOSE_MAKEFILE OFF)
SET(CMAKE_BUILD_TYPE "RelWithDebInfo")
SET(CMAKE_INCLUDE_CURRENT_DIR ON)

SET(TESTS)

# Need some stuff from ../nf_test
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}/nf_test ${NC4F_BINARY_DIR}/libsrc
   ${NC4F_BINARY_DIR}/fortran)
# All tests need to link to fortran and C libraries.
LINK_DIRECTORIES(${CMAKE_SOURCE_DIR}/fortran)

# nf03_test is the main test program.
SET(check_PROGRAMS nf03_test)
LIST(APPEND TESTS nf03_test)
SET(nf03_test_SOURCES module_tests.F90 f03lib_f_interfaces.f90 test03_get.F test03_put.F nf03_error.F
  nf03_test.F test03_read.F test03_write.F util03.F f03lib.c)

LIST(APPEND CLEANFILES tests.mod)

# test03_get.F and test03_put.f need to be distributed, so that the user
# need not have m4.
SET(EXTRA_DIST test03_get.F test03_put.F fills.cdl create_fills.sh run_f77_par_test.sh)

# Need a copy of ref_fills.nc for ftest
execute_process(COMMAND cp ${CMAKE_SOURCE_DIR}/nf_test/ref_fills.nc ${CMAKE_CURRENT_BINARY_DIR}/fills.nc)

INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}/fortran ${CMAKE_SOURCE_DIR}/libsrc ${CMAKE_SOURCE_DIR}
  ${CMAKE_CPP_FLAGS} ${NETCDF_C_INCLUDE_DIR})
LINK_DIRECTORIES(${CMAKE_SOURCE_DIR}/fortran ${CMAKE_SOURCE_DIR}/libsrc)
FOREACH(t ${TESTS})
  ADD_EXECUTABLE(${t} ${${t}_SOURCES})
  TARGET_LINK_LIBRARIES(${t} netcdff)
  ADD_TEST(${t} ${t})
ENDFOREACH()
