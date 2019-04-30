# This is a automake file, part of Unidata's netCDF package.
# Copyright 2019, see the COPYRIGHT file for more information.

# This file builds and runs tests for the netCDF-4 features in the F77
# API.

# Ed Hartnett, 2019

AM_CPPFLAGS = -I../fortran

# All tests need to link to fortran library.
LDADD = ${top_builddir}/fortran/libnetcdff.la

# These programs test the F77 netCDF-4 API using include netcdf.inc.
NF77_TESTS = ftst_groups ftst_vars ftst_vars2 ftst_vars3 ftst_vars4	\
ftst_vars5 ftst_vars6 ftst_types ftst_types2 ftst_types3 ftst_path	\
ftst_rengrps f03tst_open_mem

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
ftst_types_SOURCES = ftst_types.F
ftst_types2_SOURCES = ftst_types2.F
ftst_types3_SOURCES = ftst_types3.F
ftst_path_SOURCES = ftst_path.F
ftst_rengrps_SOURCES = ftst_rengrps.F
f03tst_open_mem_SOURCES = f03tst_open_mem.F

# This is a netCDF-4 V2 F77 test program.
if BUILD_V2
check_PROGRAMS += ftst_v2
TESTS += ftst_v2
ftst_v2_SOURCES = ftst_v2.F
endif # BUILD_V2

# Test parallel I/O for F77.
if TEST_PARALLEL
check_PROGRAMS += ftst_parallel ftst_parallel_nasa
TESTS += run_f77_par_test.sh
ftst_parallel_SOURCES = ftst_parallel.F
ftst_parallel_nasa_SOURCES = ftst_parallel_nasa.F
endif # TEST_PARALLEL

# Test filters.
if TEST_FILTERS
check_PROGRAMS += ftst_filter
ftst_filter_SOURCES = ftst_filter.F
TESTS += run_tst_filter.sh
endif

# If sed is present, generate these tests at build time. They are the
# same tests as the F77 netCDF-4 tests above, but using the "use
# netcdf4_f03" statement.
if USE_SED

# These test fortran codes will be created using sed.
F03_TEST_CODES = f03tst_groups.F f03tst_vars.F f03tst_vars2.F	\
f03tst_vars3.F f03tst_vars4.F f03tst_vars5.F f03tst_vars6.F	\
f03tst_types.F f03tst_types2.F f03tst_types3.F

# The fortran codes will compile into these tests.
F03_TESTS = f03tst_groups f03tst_vars f03tst_vars2 f03tst_vars3		\
f03tst_vars4 f03tst_vars5 f03tst_vars6 f03tst_types f03tst_types2	\
f03tst_types3

# This is a netCDF-4 V2 F77 test program.
if BUILD_V2
F03_TEST_CODES += f03tst_v2.F
F03_TESTS += f03tst_v2
f03tst_v2_SOURCES = f03tst_v2.F
endif # BUILD_V2

# Convert the parallel test.
if TEST_PARALLEL
F03_TEST_CODES += f03tst_parallel.F
check_PROGRAMS += f03tst_parallel
f03tst_parallel_SOURCES = f03tst_parallel.F
TESTS += run_f77_par_test_03.sh
endif # TEST_PARALLEL

# Note that all these fortran programs are built at compile-time on
# the user system.
BUILT_SOURCES = $(F03_TEST_CODES)

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
f03tst_types_SOURCES = f03tst_types.F
f03tst_types2_SOURCES = f03tst_types2.F
f03tst_types3_SOURCES = f03tst_types3.F

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

f03tst_types.F: ftst_types.F
	$(SED) "s|implicit none|USE netcdf4_f03|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|ftst_types.nc|f03tst_types.nc|" $@.tmp2 > $@

f03tst_types2.F: ftst_types2.F
	$(SED) "s|implicit none|USE netcdf4_f03|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|ftst_types2.nc|f03tst_types2.nc|" $@.tmp2 > $@

f03tst_types3.F: ftst_types3.F
	$(SED) "s|implicit none|USE netcdf4_f03|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|ftst_types3.nc|f03tst_types3.nc|" $@.tmp2 > $@

f03tst_v2.F: ftst_v2.F
	$(SED) "s|implicit none|USE netcdf4_f03|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|ftst_v2.nc|f03tst_v2.nc|" $@.tmp2 > $@

f03tst_parallel.F: ftst_parallel.F
	$(SED) "s|implicit none|USE netcdf4_f03|" $< > $@.tmp
	$(SED) "s|include 'netcdf.inc'|implicit none|" $@.tmp > $@.tmp2
	$(SED) "s|ftst_parallel.nc|f03tst_parallel.nc|" $@.tmp2 > $@

endif #USE_SED

# If valgrind is present on this machine, this will enable
# check-valgrind target, which runs all tests with valgrind.
@VALGRIND_CHECK_RULES@

EXTRA_DIST = CMakeLists.txt run_f77_par_test.sh	\
run_f77_par_test_03.sh

# Cleaning up files created during the testing.
CLEANFILES = ftst_*.nc f03tst_*.nc *.tmp *.tmp2 $(F03_TEST_CODES)
