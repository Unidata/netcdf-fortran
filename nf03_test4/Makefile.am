# This is a automake file, part of Unidata's netCDF package.
# Copyright 2019, see the COPYRIGHT file for more information.

# This file builds and runs the tests for netCDF-4 functions in the
# F90 API.

# Ed Hartnett, 2019

# Find the .mod files for netcdf-4.
AM_FCFLAGS = -I$(top_builddir)/fortran

# All tests need to link to fortran library.
LDADD = ${top_builddir}/fortran/libnetcdff.la

# tst_f90_nc4
NC4_F90_TESTS = f90tst_vars f90tst_vars_vlen f90tst_grps f90tst_fill	\
f90tst_fill2 f90tst_vars2 f90tst_vars3 f90tst_vars4 f90tst_path		\
f90tst_rengrps f90tst_nc4 f90tst_types f90tst_types2
check_PROGRAMS = $(NC4_F90_TESTS)
TESTS = $(NC4_F90_TESTS)

f90tst_vars_SOURCES = f90tst_vars.f90
f90tst_vars_vlen_SOURCES = f90tst_vars_vlen.f90
f90tst_grps_SOURCES = f90tst_grps.f90
f90tst_fill_SOURCES = f90tst_fill.f90
f90tst_fill2_SOURCES = f90tst_fill2.f90
f90tst_vars2_SOURCES = f90tst_vars2.f90
f90tst_vars3_SOURCES = f90tst_vars3.f90
f90tst_vars4_SOURCES = f90tst_vars4.f90
f90tst_path_SOURCES = f90tst_path.f90
f90tst_rengrps_SOURCES = f90tst_rengrps.f90
f90tst_nc4_SOURCES = f90tst_nc4.f90
f90tst_types_SOURCES = f90tst_types.f90
f90tst_types2_SOURCES = f90tst_types2.f90

# This is the netCDF-4 F90 large file test.
if LARGE_FILE_TESTS
check_PROGRAMS += f90tst_flarge
TESTS += f90tst_flarge
f90tst_flarge_SOURCES = f90tst_flarge.f90
endif # LARGE_FILE_TESTS

# This is an f90 benchmark.
if BUILD_BENCHMARKS
check_PROGRAMS += f90tst_io
TESTS += f90tst_io
f90tst_io_SOURCES = f90tst_io.f90
endif #BUILD_BENCHMARKS

# Test parallel I/O.
if TEST_PARALLEL
check_PROGRAMS += f90tst_parallel f90tst_parallel2 f90tst_parallel3	\
f90tst_nc4_par f90tst_parallel_fill
TESTS += run_f90_par_test.sh

# These files are .F90 instead of .f90 because they use ifdefs.
f90tst_parallel_SOURCES = f90tst_parallel.F90
f90tst_parallel2_SOURCES = f90tst_parallel2.F90
f90tst_parallel3_SOURCES = f90tst_parallel3.F90
f90tst_nc4_par_SOURCES = f90tst_nc4_par.F90
f90tst_parallel_fill_SOURCES = f90tst_parallel_fill.f90
endif # TEST_PARALLEL

# If valgrind is present on this machine, this will enable
# check-valgrind target, which runs all tests with valgrind.
@VALGRIND_CHECK_RULES@

EXTRA_DIST = CMakeLists.txt run_f90_par_test.sh f90tst_flarge.f90

# Cleaning up files created during the testing.
CLEANFILES = f90tst_*.nc fort.*
