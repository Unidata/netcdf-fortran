CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(CMAKE_VERBOSE_MAKEFILE OFF)
SET(CMAKE_BUILD_TYPE "RelWithDebInfo")
SET(CMAKE_INCLUDE_CURRENT_DIR ON)

# Process these files with m4.
SET(m4_SOURCES test_get test_put)
foreach (f ${m4_SOURCES})
		   GEN_m4(${f})
endforeach(f)

SET(nf_test_SOURCES
  f03lib_f_interfaces.f90 test_get.F test_put.F nf_error.F nf_test.F
  test_read.F test_write.F util.F f03lib.c tests.inc)

SET(tst_int64_SOURCES tst_int64.F)

SET(TESTS nf_test tst_int64)
IF (BUILD_V2)
  SET(check_PROGRAMS tst_f77_v2)
  SET(tst_f77_v2_SOURCES tst_f77_v2.F)
  SET(TESTS ${TESTS} tst_f77_v2)

# This is the fortran v2 test. It depends on the utilities being built
# to generate its input file.
  SET(check_PROGRAMS ${check_PROGRAMS} ftest)
  SET(TESTS ${TESTS} ftest)
  SET(ftest_SOURCES ftest.F f03lib.c)
ENDIF(BUILD_V2)

FIND_LIBRARY(NETCDF_C_LIBRARY NAMES netcdf libnetcdf)
FIND_PATH(NETCDF_C_INCLUDE_DIR netcdf.h)
IF(NOT NETCDF_C_LIBRARY)
  MESSAGE(FATAL_ERROR "Cannot find netCDF C library, needed for netCDF Fortran tests.")
ENDIF()

# Need a copy of ref_fills.nc for ftest
execute_process(COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/ref_fills.nc
  ${CMAKE_CURRENT_BINARY_DIR}/fills.nc)

INCLUDE_DIRECTORIES(BEFORE
  ${CMAKE_CURRENT_BINARY_DIR}
  ${CMAKE_BINARY_DIR}/fortran
  ${CMAKE_BINARY_DIR}/libsrc
  ${CMAKE_SOURCE_DIR}
  ${CMAKE_SOURCE_DIR}/fortran
  ${CMAKE_SOURCE_DIR}/libsrc)

INCLUDE_DIRECTORIES(
  ${CMAKE_CPP_FLAGS}
  ${NETCDF_C_INCLUDE_DIR})

LINK_DIRECTORIES(${CMAKE_SOURCE_DIR}/fortran ${CMAKE_SOURCE_DIR}/libsrc
  ${NC4F_BINARY_DIR}/fortran)

# Create pre-compiled tests.
FOREACH(t ${TESTS})
  ADD_EXECUTABLE(${t} ${${t}_SOURCES})
  TARGET_LINK_LIBRARIES(${t} netcdff)
  ADD_TEST(${t} ${t})
ENDFOREACH()

# Copy test scripts in to current directory.
FILE(GLOB COPY_FILES ${CMAKE_CURRENT_SOURCE_DIR}/*.sh)
FILE(COPY ${COPY_FILES}
	  DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/
	  FILE_PERMISSIONS OWNER_WRITE OWNER_READ OWNER_EXECUTE)

# Add script-based tests.
FOREACH(t ${SCRIPT_TESTS})
  add_sh_test(nf_test ${t})
ENDFOREACH()


# test_get.F and test_put.f need to be distributed, so that the user
# need not have m4. fills.nc is used by test program ftest.
SET (EXTRA_DIST test_get.F test_put.F fills.cdl create_fills.sh
   ref_fills.nc)

# Cleaning up files created during the process.
SET (CLEANFILES scratch.nc test.nc copy.nc fills.nc tst_*.nc ftst_*.nc)

SET (MAINTAINERCLEANFILES test_get.F test_put.F)
