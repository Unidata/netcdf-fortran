CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(CMAKE_VERBOSE_MAKEFILE OFF)
SET(CMAKE_BUILD_TYPE "RelWithDebInfo")
SET(CMAKE_INCLUDE_CURRENT_DIR ON)

# Is the user building netCDF-4?
if (USE_NETCDF4)
  # Add these netCDF-4 test programs.
  SET(nc4_check_PROGRAMS
    f90tst_vars)
  SET(check_PROGRAMS ${check_PROGRAMS} ${nc4_check_PROGRAMS})
  SET(TESTS ${TESTS} ${nc4_check_PROGRAMS})

  SET(f90tst_vars_SOURCES f90tst_vars.f90)

endif(USE_NETCDF4)

FIND_LIBRARY(NETCDF_C_LIBRARY NAMES netcdf libnetcdf)
FIND_PATH(NETCDF_C_INCLUDE_DIR netcdf.h)
IF(NOT NETCDF_C_LIBRARY)
  MESSAGE(FATAL_ERROR "Cannot find netCDF C library, needed for netCDF Fortran tests.")
ENDIF()

INCLUDE_DIRECTORIES(BEFORE
  ${CMAKE_CURRENT_BINARY_DIR}
  ${CMAKE_BINARY_DIR}/fortran
  ${CMAKE_SOURCE_DIR}
  ${CMAKE_SOURCE_DIR}/fortran)

INCLUDE_DIRECTORIES(
  ${CMAKE_CPP_FLAGS}
  ${NETCDF_C_INCLUDE_DIR})

LINK_DIRECTORIES(${CMAKE_SOURCE_DIR}/fortran
  ${NC4F_BINARY_DIR}/fortran)

# Create pre-compiled tests.
FOREACH(t ${TESTS})
  ADD_EXECUTABLE(${t} ${${t}_SOURCES})
  TARGET_LINK_LIBRARIES(${t} netcdff)
  ADD_TEST(${t} ${t})
ENDFOREACH()

# Cleaning up files created during the process.
SET (CLEANFILES f90tst_*.nc)
