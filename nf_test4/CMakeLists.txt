CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(CMAKE_VERBOSE_MAKEFILE OFF)
SET(CMAKE_BUILD_TYPE "RelWithDebInfo")
SET(CMAKE_INCLUDE_CURRENT_DIR ON)

# Is the user building netCDF-4?
if (USE_NETCDF4)
  # Add these netCDF-4 test programs.
  SET(nc4_check_PROGRAMS ftst_groups ftst_vars ftst_vars2 ftst_vars3
    ftst_vars4 ftst_vars5 ftst_vars6 ftst_types ftst_types2
    ftst_types3 ftst_path ftst_rengrps f03tst_open_mem)
  SET(check_PROGRAMS ${check_PROGRAMS} ${nc4_check_PROGRAMS})
  SET(TESTS ${TESTS} ${nc4_check_PROGRAMS})

  SET(ftst_groups_SOURCES ftst_groups.F)
  SET(ftst_vars_SOURCES ftst_vars.F)
  SET(ftst_vars2_SOURCES ftst_vars2.F)
  SET(ftst_vars3_SOURCES ftst_vars3.F)
  SET(ftst_vars4_SOURCES ftst_vars4.F)
  SET(ftst_vars5_SOURCES ftst_vars5.F)
  SET(ftst_vars6_SOURCES ftst_vars6.F)
  SET(ftst_types_SOURCES ftst_types.F)
  SET(ftst_types2_SOURCES ftst_types2.F)
  SET(ftst_types3_SOURCES ftst_types3.F)
  SET(ftst_path_SOURCES ftst_path.F)
  SET(ftst_rengrps_SOURCES ftst_rengrps.F)
  SET(f03tst_open_mem_SOURCES f03tst_open_mem.F)

  # This is a netCDF-4 V2 test program.
  IF (BUILD_V2)
    SET(nc4_v2_PROGRAMS ftst_v2)
    SET(check_PROGRAMS ${check_PROGRAMS} ${nc4_v2_PROGRAMS})
    SET(TESTS ${TESTS} ${nc4_v2_PROGRAMS})
    SET(ftst_v2_SOURCES ftst_v2.F)
  ENDIF (BUILD_V2)

  # Test parallel I/O for F77.
  IF (TEST_PARALLEL)
    SET(check_PROGRAMS ${check_PROGRAMS} ftst_parallel ftst_parallel_nasa)
    SET(SCRIPT_TESTS ${SCRIPT_TESTS} run_f77_par_test)

    # Add executables for f77_par_tst
    build_bin_test(ftst_parallel ".F")
    build_bin_test(ftst_parallel_nasa ".F")

  ENDIF (TEST_PARALLEL)

  IF(ENABLE_FILTER_TEST)
    SET(check_PROGRAMS ${check_PROGRAMS} ftst_filter)
    SET(SCRIPT_TESTS ${SCRIPT_TESTS} run_tst_filter)
    # Add executables
    build_bin_test(ftst_filter ".F")
  ENDIF(ENABLE_FILTER_TEST)

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
SET (CLEANFILES ftst_*.nc)
