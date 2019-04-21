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
check_PROGRAMS += tst_f77_v2
tst_f77_v2_SOURCES = tst_f77_v2.F
TESTS += tst_f77_v2
endif # BUILD_V2

# If the user building netCDF-4 add the netCDF-4 test programs.
if USE_NETCDF4

# Add these netCDF-4 f90 API test programs.
check_PROGRAMS +=  tst_types tst_types2 f90tst_vars_vlen	\
tst_f90_nc4 f90tst_grps f90tst_fill f90tst_fill2 f90tst_vars3		\
f90tst_vars4 f90tst_vars2 f90tst_path f90tst_rengrps

TESTS += tst_types tst_types2 f90tst_vars_vlen	\
tst_f90_nc4 f90tst_grps f90tst_fill f90tst_fill2 f90tst_vars3	\
f90tst_vars4 f90tst_vars2 f90tst_path f90tst_rengrps

tst_types_SOURCES = tst_types.f90
tst_types2_SOURCES = tst_types2.f90
tst_f90_nc4_SOURCES = tst_f90_nc4.f90

# This is the netCDF-4 F90 large file test.
if LARGE_FILE_TESTS
check_PROGRAMS += tst_flarge
TESTS += tst_flarge
tst_flarge_SOURCES = tst_flarge.f90
endif # LARGE_FILE_TESTS

# This is an f90 benchmark.
if BUILD_BENCHMARKS
check_PROGRAMS += tst_io
TESTS += tst_io
tst_io_SOURCES = tst_io.f90
endif #BUILD_BENCHMARKS

# Test parallel I/O.
if TEST_PARALLEL
check_PROGRAMS += f90tst_parallel f90tst_parallel2 f90tst_parallel3	\
f90tst_nc4_par f90tst_parallel_fill
TESTS += run_f90_par_test.sh

f90tst_parallel_SOURCES = f90tst_parallel.F90
f90tst_parallel2_SOURCES = f90tst_parallel2.F90
f90tst_parallel3_SOURCES = f90tst_parallel3.F90
f90tst_nc4_par_SOURCES = f90tst_nc4_par.F90
f90tst_parallel_fill_SOURCES = f90tst_parallel_fill.f90
endif # TEST_PARALLEL

endif #USE_NETCDF4

# This is the fortran v2 test.
if BUILD_V2
check_PROGRAMS += ftest
TESTS += ftest
ftest_SOURCES = ftest.F f03lib.c
endif # BUILD_V2

check_PROGRAMS += tst_f90
TESTS += tst_f90
tst_f90_SOURCES = tst_f90.f90

# Tell make how to turn .m4 files into .F files.
.m4.F:
	m4 $(M4FLAGS) $< >$@

# If valgrind is present on this machine, this will enable
# check-valgrind target, which runs all tests with valgrind.
@VALGRIND_CHECK_RULES@

# test_get.F and test_put.f need to be distributed, so that the user
# need not have m4. ref_fills.nc is copied to fills.nc by configure
# and used by test program ftest.
EXTRA_DIST = test_get.F test_put.F fills.cdl run_f90_par_test.sh	\
ref_fills.nc CMakeLists.txt

# Cleaning up files created during the process.
CLEANFILES = scratch.nc test.nc copy.nc tst_*.nc ftst_*.nc	\
f90tst_*.nc temp.tmp fort.*

DISTCLEANFILES = fills.nc

MAINTAINERCLEANFILES = test_get.F test_put.F
