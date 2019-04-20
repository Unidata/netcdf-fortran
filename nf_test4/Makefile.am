# This is a automake file, part of Unidata's netCDF package.
# Copyright 2019, see the COPYRIGHT file for more information.

# This file builds and runs the f77 and f90 tests for netCDF-4.

# Ed Hartnett, 2019

AM_CPPFLAGS = -I../fortran

# All tests need to link to fortran library.
LDADD = ${top_builddir}/fortran/libnetcdff.la

# These programs test the F77 netCDF-4 API using include netcdf.inc.
NF77_TESTS = ftst_groups ftst_vars ftst_vars2 ftst_vars3 ftst_vars4	\
ftst_vars5 ftst_vars6

# Compile and run the F77 API tests.
check_PROGRAMS = $(NF77_TESTS)
TESTS = $(NF77_TESTS)

# Each test depdends on its source.
ftst_groups_SOURCES = ftst_groups.F
ftst_vars_SOURCES = ftst_vars.F
ftst_vars2_SOURCES = ftst_vars2.F
ftst_vars3_SOURCES = ftst_vars3.F
ftst_vars4_SOURCES = ftst_vars4.F
ftst_vars5_SOURCES = ftst_vars5.F
ftst_vars6_SOURCES = ftst_vars6.F

# If sed is present, generate these tests at build time. They are the
# same tests as the F77 netCDF-4 tests above, but using the "use
# netcdf4_f03" statement.
if USE_SED

# These test fortran codes will be created using sed.
F03_TEST_CODES = f03tst_groups.F f03tst_vars.F f03tst_vars2.F	\
f03tst_vars3.F f03tst_vars4.F f03tst_vars5.F f03tst_vars6.F
BUILT_SOURCES = $(F03_TEST_CODES)

# The fortran codes will compile into these tests.
F03_TESTS = f03tst_groups f03tst_vars f03tst_vars2 f03tst_vars3	\
f03tst_vars4 f03tst_vars5 f03tst_vars6

# Compile and run the generated tests.
check_PROGRAMS += $(F03_TESTS)
TESTS += $(F03_TESTS)

# Each generated test code depends on its source.
f03tst_groups_SOURCES = f03tst_groups.F
f03tst_vars_SOURCES = f03tst_vars.F
f03tst_vars2_SOURCES = f03tst_vars2.F
f03tst_vars3_SOURCES = f03tst_vars3.F
f03tst_vars4_SOURCES = f03tst_vars4.F
f03tst_vars5_SOURCES = f03tst_vars5.F
f03tst_vars6_SOURCES = f03tst_vars6.F

# Use sed to generate the f03 versions of the test codes.
f03tst_groups.F: ftst_groups.F
	$(SED) "s|implicit none|USE netcdf4_f03|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|ftst_groups.nc|f03tst_groups.nc|" $@.tmp2 > $@

f03tst_vars.F: ftst_vars.F
	$(SED) "s|implicit none|USE netcdf4_f03|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|ftst_vars.nc|f03tst_vars.nc|" $@.tmp2 > $@

f03tst_vars2.F: ftst_vars2.F
	$(SED) "s|implicit none|USE netcdf4_f03|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|ftst_vars2.nc|f03tst_vars2.nc|" $@.tmp2 > $@

f03tst_vars3.F: ftst_vars3.F
	$(SED) "s|implicit none|USE netcdf4_f03|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|ftst_vars3.nc|f03tst_vars3.nc|" $@.tmp2 > $@

f03tst_vars4.F: ftst_vars4.F
	$(SED) "s|implicit none|USE netcdf4_f03|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|ftst_vars4.nc|f03tst_vars4.nc|" $@.tmp2 > $@

f03tst_vars5.F: ftst_vars5.F
	$(SED) "s|implicit none|USE netcdf4_f03|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|ftst_vars5.nc|f03tst_vars5.nc|" $@.tmp2 > $@

f03tst_vars6.F: ftst_vars6.F
	$(SED) "s|implicit none|USE netcdf4_f03|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|ftst_vars6.nc|f03tst_vars6.nc|" $@.tmp2 > $@
endif #USE_SED

# If valgrind is present on this machine, this will enable
# check-valgrind target, which runs all tests with valgrind.
@VALGRIND_CHECK_RULES@

EXTRA_DIST = CMakeLists.txt

# Cleaning up files created during the testing.
CLEANFILES = ftst_*.nc f03tst_*.nc *.tmp *.tmp2 $(F03_TEST_CODES)
