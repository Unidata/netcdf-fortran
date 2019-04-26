# This is a automake file, part of Unidata's netCDF package.
# Copyright 2005-2019, see the COPYRIGHT file for more information.

# This file builds and runs the f77 and f90 tests.

# Ed Hartnett, Russ Rew, Dennis Heimbigner, Ward Fisher

# Parallel builds don't currently work in this directory.
.NOTPARALLEL:

AM_CPPFLAGS = -I$(top_srcdir)/fortran -I../fortran

# Some fortran compilers think your files should not have an .f90
# extension! The value of FCFLAGS_f90 is set in the configure script,
# based on the fortran compiler.
AM_FCFLAGS = @MOD_FLAG@$(top_builddir)/fortran $(FCFLAGS_f90)

AM_FFLAGS = ${AM_FCFLAGS}

# All tests need to link to fortran library.
LDADD = ${top_builddir}/fortran/libnetcdff.la

# Need access to top_srcdir
TESTS_ENVIRONMENT = TOPSRCDIR=${abs_top_srcdir}

# nf_test is the main test program.
check_PROGRAMS = nf_test
TESTS = nf_test

nf_test_SOURCES = f03lib_f_interfaces.f90 test_get.m4 test_put.m4	\
nf_error.F nf_test.F test_read.F test_write.F util.F f03lib.c		\
tests.inc

# Did the user build the V2 F77 API? If so, run this test.
if BUILD_V2
check_PROGRAMS += tst_f77_v2 ftest
TESTS += tst_f77_v2 ftest
tst_f77_v2_SOURCES = tst_f77_v2.F
ftest_SOURCES = ftest.F f03lib.c
endif # BUILD_V2

# nf03_test is the same as nf_test, but with "use" instead of
# "include". Soon I hope to generate these files with sed, but for
# now, we just store slightly modified copies of these codes in the
# repo.
check_PROGRAMS += nf03_test
TESTS += nf03_test
nf03_test_SOURCES = module_tests.F90 f03lib_f_interfaces.f90		\
test03_get.F test03_put.F nf03_error.F nf03_test.F test03_read.F	\
test03_write.F util03.F f03lib.c

# programs that "use tests" from the tests.mod module depend on it
# being built first, needed for make -j
nf03_error.o nf03_test.o test03_get.o test03_put.o test03_read.o test03_write.o util03.o: \
module_tests.o

# If sed is present, generate these tests at build time. They are the
# same tests as the F77 netCDF-4 tests above, but using the "use
# netcdf4_f03" statement.
if USE_SED

# These test fortran codes will be created using sed.
F03_TEST_CODES =

# The fortran codes will compile into these tests.
F03_TESTS =

if BUILD_V2
F03_TEST_CODES += f03test.F tst03_f77_v2.F
F03_TESTS += f03test tst03_f77_v2
f03test_SOURCES = f03test.F
tst03_f77_v2_SOURCES = tst03_f77_v2.F
endif # BUILD_V2

# Note that all these fortran programs are built at compile-time on
# the user system.
BUILT_SOURCES = $(F03_TEST_CODES)

# Compile and run the generated tests.
check_PROGRAMS += $(F03_TESTS)
TESTS += $(F03_TESTS)

# Use sed to generate the f03 versions of some test codes.
f03test.F: ftest.F
	$(SED) "s|include 'netcdf.inc'|use netcdf_f03|" $< > $@.tmp
	$(SED) "s|test.nc|f03tst_test.nc|" $@.tmp > $@.tmp2
	$(SED) "s|copy.nc|f03tst_copy.nc|" $@.tmp2 > $@

tst03_f77_v2.F: tst_f77_v2.F
	$(SED) "s|IMPLICIT NONE|USE tests|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|tst_f77_v2.nc|tst03_f77_v2.nc|" $@.tmp2 > $@

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
CLEANFILES = scratch.nc test.nc copy.nc tst_*.nc ftst_*.nc	\
f90tst_*.nc temp.tmp fort.*

DISTCLEANFILES = fills.nc

MAINTAINERCLEANFILES = test_get.F test_put.F
