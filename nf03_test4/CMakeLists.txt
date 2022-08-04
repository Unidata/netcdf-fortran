SET(CMAKE_VERBOSE_MAKEFILE OFF)
SET(CMAKE_BUILD_TYPE "RelWithDebInfo")
SET(CMAKE_INCLUDE_CURRENT_DIR ON)

# Is the user building netCDF-4?
if (USE_NETCDF4)
  # Add these netCDF-4 test programs.
  SET(nc4_check_PROGRAMS f90tst_vars f90tst_vars_vlen f90tst_grps
    f90tst_fill f90tst_fill2 f90tst_vars3 f90tst_vars4 f90tst_vars2
    f90tst_path f90tst_rengrps f90tst_nc4 f90tst_types f90tst_types2 f90tst_zstandard)
  # Only run this test if quantize is present (i.e. netcdf-c is 4.9.0 or greater).
  IF (HAVE_QUANTIZE)
    SET(nc4_check_PROGRAMS ${nc4_check_PROGRAMS} f90tst_vars5)
  ENDIF()
  SET(check_PROGRAMS ${check_PROGRAMS} ${nc4_check_PROGRAMS})
  SET(TESTS ${TESTS} ${nc4_check_PROGRAMS})

  SET(f90tst_vars_SOURCES f90tst_vars.F90)
  SET(f90tst_vars_vlen_SOURCES f90tst_vars_vlen.F90)
  SET(f90tst_grps_SOURCES f90tst_grps.F90)
  SET(f90tst_fill_SOURCES f90tst_fill.F90)
  SET(f90tst_fill2_SOURCES f90tst_fill2.F90)
  SET(f90tst_vars2_SOURCES f90tst_vars2.F90)
  SET(f90tst_vars3_SOURCES f90tst_vars3.F90)
  SET(f90tst_vars4_SOURCES f90tst_vars4.F90)
  SET(f90tst_vars5_SOURCES f90tst_vars5.F90)
  SET(f90tst_path_SOURCES f90tst_path.F90)
  SET(f90tst_rengrps_SOURCES f90tst_rengrps.F90)
  SET(f90tst_nc4_SOURCES f90tst_nc4.F90)
  SET(f90tst_types_SOURCES f90tst_types.F90)
  SET(f90tst_types2_SOURCES f90tst_types2.F90)
  SET(f90tst_zstandard_SOURCES f90tst_zstandard.F90)

  # Test parallel I/O.
  IF (TEST_PARALLEL)
    SET(check_PROGRAMS ${check_PROGRAMS} f90tst_parallel f90tst_parallel2 f90tst_parallel3
      f90tst_nc4_par f90tst_parallel_fill f90tst_parallel_compressed)

    CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/run_f90_par_test.sh.in"
      "${CMAKE_CURRENT_SOURCE_DIR}/run_f90_par_test.sh"
    @ONLY)
    FILE(COPY "${CMAKE_CURRENT_SOURCE_DIR}/run_f90_par_test.sh" 
      DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/
      FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)


    build_bin_test(f90tst_parallel ".F90")
    build_bin_test(f90tst_parallel2 ".F90")
    build_bin_test(f90tst_parallel3 ".F90")
    build_bin_test(f90tst_nc4_par ".F90")

    build_bin_test(f90tst_parallel_fill ".F90")

    build_bin_test(f90tst_parallel_compressed ".F90")

    add_sh_test(F90_tests run_f90_par_test)
  ENDIF (TEST_PARALLEL)

  # This is the netCDF-4 F90 large file test.
  IF (LARGE_FILE_TESTS)
    SET(nc4_largefile_PROGRAMS f90tst_flarge)
    SET(check_PROGRAMS ${check_PROGRAMS} ${nc4_largefile_PROGRAMS})
    SET(TESTS ${TESTS} ${nc4_largefile_PROGRAMS})
    SET(f90tst_flarge_SOURCES f90tst_flarge.F90)
  ENDIF(LARGE_FILE_TESTS)

  # This is an f90 benchmark.
  IF(BUILD_BENCHMARKS)
    SET(nc4_io_PROGRAMS f90tst_io)
    SET(check_PROGRAMS ${check_PROGRAMS} ${nc4_io_PROGRAMS})
    SET(TESTS ${TESTS} ${nc4_io_PROGRAMS})
    SET(f90tst_io_SOURCES f90tst_io.F90)
  ENDIF(BUILD_BENCHMARKS)
endif(USE_NETCDF4)

# Create pre-compiled tests.
FOREACH(t ${TESTS})
  ADD_EXECUTABLE(${t} ${${t}_SOURCES})
  TARGET_LINK_LIBRARIES(${t} netcdff)
  ADD_TEST(${t} ${t})
ENDFOREACH()

# Cleaning up files created during the process.
SET (CLEANFILES f90tst_*.nc)
