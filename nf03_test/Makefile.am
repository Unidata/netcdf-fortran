## This is a automake file, part of Unidata's netCDF package.
# Copyright 2005-2019, see the COPYRIGHT file for more information.

# These are the fortran 90 API tests.

# Ed Hartnett, Russ Rew, Dennis Heimbigner, Ward Fisher

AM_FCFLAGS = -I$(top_builddir)/fortran -I$(top_srcdir)/nf_test

AM_FFLAGS = ${AM_FCFLAGS}

# All tests need to link to fortran and C libraries.
LDADD = ${top_builddir}/fortran/libnetcdff.la

# The F90 API tests.
check_PROGRAMS = tst_f90 tst_fill_int64
TESTS = tst_f90 tst_fill_int64
tst_f90_SOURCES = tst_f90.f90
tst_fill_int64_SOURCES = tst_fill_int64.F90

# If valgrind is present on this machine, this will enable
# check-valgrind target, which runs all tests with valgrind.
@VALGRIND_CHECK_RULES@

EXTRA_DIST = CMakeLists.txt

# Cleaning up files created during the process.
CLEANFILES = tst*.nc
