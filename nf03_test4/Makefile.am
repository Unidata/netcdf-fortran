# This is a automake file, part of Unidata's netCDF package.
# Copyright 2019, see the COPYRIGHT file for more information.

# This file builds and runs the tests for netCDF-4 functions in the
# F90 API.

# Ed Hartnett, 2019

# Find the .mod files for netcdf-4.
AM_FCFLAGS = -I$(top_builddir)/fortran

# All tests need to link to fortran library.
LDADD = ${top_builddir}/fortran/libnetcdff.la

check_PROGRAMS = f90tst_vars
TESTS = f90tst_vars

f90tst_vars_SOURCES = f90tst_vars.f90

# If valgrind is present on this machine, this will enable
# check-valgrind target, which runs all tests with valgrind.
@VALGRIND_CHECK_RULES@

EXTRA_DIST = CMakeLists.txt run_f77_par_test.sh

# Cleaning up files created during the testing.
CLEANFILES = f90tst_*.nc
