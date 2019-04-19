# This is a automake file, part of Unidata's netCDF package.
# Copyright 2019, see the COPYRIGHT file for more information.

# This file builds and runs the f77 and f90 tests for netCDF-4.

# Ed Hartnett

# Parallel builds don't currently work in this directory.
#.NOTPARALLEL:

AM_CPPFLAGS = -I../fortran

# All tests need to link to fortran library.
LDADD = ${top_builddir}/fortran/libnetcdff.la

# These programs test the F77 netCDF-4 API using include netcdf.inc.
check_PROGRAMS = ftst_groups ftst_vars
TESTS = ftst_groups ftst_vars
ftst_groups_SOURCES = ftst_groups.F
ftst_vars_SOURCES = ftst_vars.F

# These tests are generated at build time. They are the same tests as
# the F77 netCDF-4 tests above, but using the use netcdf4_f03
# statement. These tests are only run if sed is available.
if USE_SED
BUILT_SOURCES = f03tst_groups.F f03tst_vars.F
check_PROGRAMS += f03tst_groups f03tst_vars
TESTS += f03tst_groups f03tst_vars
f03tst_groups_SOURCES = f03tst_groups.F
f03tst_vars_SOURCES = f03tst_vars.F

f03tst_groups.F: ftst_groups.F
	$(SED) "s|implicit none|USE netcdf4_f03|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|ftst_groups.nc|f03tst_groups.nc|" $@.tmp2 > $@

f03tst_vars.F: ftst_vars.F
	$(SED) "s|implicit none|USE netcdf4_f03|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|ftst_vars.nc|f03tst_vars.nc|" $@.tmp2 > $@
endif #USE_SED

# If valgrind is present on this machine, this will enable
# check-valgrind target, which runs all tests with valgrind.
@VALGRIND_CHECK_RULES@

EXTRA_DIST = CMakeLists.txt

# Cleaning up files created during the testing.
CLEANFILES = ftst_*.nc f03tst_*.nc *.tmp *.tmp2 f03tst_groups.F
