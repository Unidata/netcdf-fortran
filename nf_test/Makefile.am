# This is a automake file, part of Unidata's netCDF package.
# Copyright 2005-2019, see the COPYRIGHT file for more information.

# This file builds and runs the tests for the netCDF classic F77
# API. Tests are run using traditional include netcdf.inc, and then
# again using the F77 API through its Fortran mod file. To achieve
# this, sed is used to modify the tests using include, to create the
# tests using the fortran module.

# Ed Hartnett, Russ Rew, Dennis Heimbigner, Ward Fisher

# FFLAGS is used when compiling *.F
AM_FFLAGS = -I$(top_builddir)/fortran

# FCFLAGS is used when compiling *.F90.
AM_FCFLAGS = $(AM_FFLAGS)

# All tests need to link to the netcdf fortran library.
LDADD = ${top_builddir}/fortran/libnetcdff.la

# nf_test is the main test program for classic netCDF F77 API.
check_PROGRAMS = nf_test tst_int64
TESTS = nf_test tst_int64
nf_test_SOURCES = f03lib_f_interfaces.f90 test_get.m4 test_put.m4	\
nf_error.F nf_test.F test_read.F test_write.F util.F f03lib.c		\
tests.inc
tst_int64_SOURCES = tst_int64.F

# Add these two V2 test programs, if V2 API is being built.
if BUILD_V2
check_PROGRAMS += tst_f77_v2 ftest
TESTS += tst_f77_v2 ftest
tst_f77_v2_SOURCES = tst_f77_v2.F
ftest_SOURCES = ftest.F f03lib.c
endif # BUILD_V2

# If sed is present, generate these tests at build time. They are the
# same tests as the F77 netCDF-4 tests above, but using the "use
# netcdf4_f03" statement.
if USE_SED

# Build this uninstalled convenience library, tests.mod.
noinst_LTLIBRARIES = libtests.la

# Each convenience library depends on its source.
libtests_la_SOURCES = module_tests.F90

# Each mod file depends on the .o file.
tests.mod: module_tests.$(OBJEXT)

# Mod files are built sources.
BUILT_SOURCES = tests.mod

# The fortran codes will compile into these tests.
F03_TESTS = nf03_test

# These test fortran codes will be created using sed.
F03_TEST_CODES = nf03_error.F test03_read.F test03_write.F	\
nf03_test.F test03_get.F

# test03_put.F and util03.F are copies of similarly named test
# codes, but with "use" instead of "include", as well as some other
# changes to make them work with the tests.mod file instead of
# tests.inc. These files proved too difficult to generate with sed,
# so, we just store slightly modified copies of these codes in the
# repo.
nf03_test_SOURCES = f03lib_f_interfaces.f90 test03_get.F test03_put.F	\
nf03_error.F nf03_test.F test03_read.F test03_write.F util03.F		\
f03lib.c
nf03_test_LDADD = libtests.la ${top_builddir}/fortran/libnetcdff.la

# If the V2 API is being built, then make copies of the two V2 F77 API
# tests, modified to use the fortran module.
if BUILD_V2
F03_TEST_CODES += f03test.F tst03_f77_v2.F
F03_TESTS += f03test tst03_f77_v2
f03test_SOURCES = f03test.F
f03test_LDADD = libtests.la ${top_builddir}/fortran/libnetcdff.la
tst03_f77_v2_SOURCES = tst03_f77_v2.F
tst03_f77_v2_LDADD = libtests.la ${top_builddir}/fortran/libnetcdff.la
endif # BUILD_V2

# Note that all these fortran programs are built at compile-time on
# the user system.
BUILT_SOURCES += $(F03_TEST_CODES)

# Compile and run the generated tests.
check_PROGRAMS += $(F03_TESTS)
TESTS += $(F03_TESTS)

# Use sed to generate the f03 versions of some test codes.
f03test.F: ftest.F
	$(SED) "s|include 'netcdf.inc'|use netcdf_f03|" $< > $@.tmp
	$(SED) "s|ftest.nc|f03test_test.nc|" $@.tmp > $@.tmp2
	$(SED) "s|fcopy.nc|f03test_copy.nc|" $@.tmp2 > $@

tst03_f77_v2.F: tst_f77_v2.F
	$(SED) "s|IMPLICIT NONE|USE tests|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|tst_f77_v2.nc|tst03_f77_v2.nc|" $@.tmp2 > $@

nf03_error.F: nf_error.F
	$(SED) "s|implicit none|USE tests|" $< > $@.tmp
	$(SED) "s|#include \"tests.inc\"|      implicit none|" $@.tmp > $@

nf03_test.F: nf_test.F
	$(SED) "s|implicit none|USE tests|" $< > $@.tmp
	$(SED) "s|#include \"tests.inc\"|      implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|scratch.nc|scratch03.nc|" $@.tmp2 > $@.tmp
	$(SED) "s|test.nc|test03.nc|" $@.tmp > $@

test03_read.F: test_read.F
	$(SED) "s|implicit none|USE tests|" $< > $@.tmp
	$(SED) "s|#include \"tests.inc\"|      implicit none|" $@.tmp > $@

test03_write.F: test_write.F
	$(SED) "s|implicit none|USE tests|" $< > $@.tmp
	$(SED) "s|#include \"tests.inc\"|      implicit none|" $@.tmp > $@

test03_get.F: test_get.F
	$(SED) "s|implicit        none|USE tests|" $< > $@.tmp
	$(SED) "s|#include \"tests.inc\"|      implicit none|" $@.tmp > $@

endif #USE_SED

# Tell make how to turn .m4 files into .F files.
.m4.F:
	m4 $(M4FLAGS) $< >$@

# If valgrind is present on this machine, this will enable
# check-valgrind target, which runs all tests with valgrind.
@VALGRIND_CHECK_RULES@

# test_get.F and test_put.f need to be distributed, so that the user
# need not have m4. ref_fills.nc is copied to fills.nc by configure
# and used by test program ftest.
EXTRA_DIST = test_get.F test_put.F fills.cdl ref_fills.nc	\
CMakeLists.txt

# Cleaning up files created during the process.
CLEANFILES = scratch*.nc test*.nc copy*.nc tst_*.nc ftst_*.nc	\
f90tst_*.nc f03test*.nc *.tmp *.tmp2 fort.* tst03*.nc	\
f03tst*.nc ftest.nc fcopy.nc *.mod $(F03_TEST_CODES)

DISTCLEANFILES = fills.nc

MAINTAINERCLEANFILES = test_get.F test_put.F
