# This is a automake file, part of Unidata's netCDF package.
# Copyright 2019, see the COPYRIGHT file for more information.

# This file builds and runs the f77 and f90 tests for netCDF-4.

# Ed Hartnett

# Parallel builds don't currently work in this directory.
.NOTPARALLEL:

AM_CPPFLAGS = -I$(top_srcdir)/fortran

# All tests need to link to fortran library.
LDADD = ${top_builddir}/fortran/libnetcdff.la

check_PROGRAMS = ftst_groups
TESTS = ftst_groups

ftst_groups_SOURCES = ftst_groups.F

# If valgrind is present on this machine, this will enable
# check-valgrind target, which runs all tests with valgrind.
@VALGRIND_CHECK_RULES@

EXTRA_DIST = CMakeLists.txt

# Cleaning up files created during the testing.
CLEANFILES = ftst_*.nc
