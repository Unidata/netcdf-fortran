# This is a automake file, part of Unidata's netCDF package.
# Copyright 2019, see the COPYRIGHT file for more information.

# This file builds and runs the f77 and f90 tests for netCDF-4.

# Ed Hartnett

# Parallel builds don't currently work in this directory.
#.NOTPARALLEL:

AM_CPPFLAGS = -I../fortran

# All tests need to link to fortran library.
LDADD = ${top_builddir}/fortran/libnetcdff.la

check_PROGRAMS = ftst_groups
TESTS = ftst_groups
ftst_groups_SOURCES = ftst_groups.F

if USE_SED
BUILT_SOURCES = f03tst_groups.F
check_PROGRAMS += f03tst_groups
TESTS += f03tst_groups
f03tst_groups_SOURCES = f03tst_groups.F

f03tst_groups.F: ftst_groups.F
	$(SED) "s|implicit none|USE netcdf4_f03|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|ftst_groups.nc|f03tst_groups.nc|" $@.tmp2 > $@
endif #USE_SED

# If valgrind is present on this machine, this will enable
# check-valgrind target, which runs all tests with valgrind.
@VALGRIND_CHECK_RULES@

EXTRA_DIST = CMakeLists.txt

# Cleaning up files created during the testing.
CLEANFILES = ftst_*.nc *.tmp *.tmp2 f03tst_groups.F
