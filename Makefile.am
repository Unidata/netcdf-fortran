## This is a automake file, part of Unidata's netCDF package.
# Copyright 2012-2019, see the COPYRIGHT file for more information.

# This is the main automake file for netCDF-Fortran.

# Ed Hartnett, Russ Rew, Dennis Heimbigner, Ward Fisher

# This directory stores libtool macros, put there by aclocal.
ACLOCAL_AMFLAGS = -I m4

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = netcdf-fortran.pc

# Run these tests for netCDF-4 builds.
if USE_NETCDF4
NF_TEST4 = nf_test4     # netCDF-4 F77 API tests
NF03_TEST4 = nf03_test4 # netCDF-4 F90 API tests
endif # USE_NETCDF4

# This is the list of subdirs for which Makefiles will be constructed
# and run.
SUBDIRS = libsrc fortran nf_test nf03_test $(NF_TEST4) $(NF03_TEST4)	\
docs examples CMakeExtras

# The nf-config script helps the user build programs with netCDF.
bin_SCRIPTS = nf-config

check_nc_config:
	$(F03) `./nf-config --fflags` test_prog.f03 -o test_prog `./nf-config --libs`
	./test_prog

# These files get added to the distribution.
EXTRA_DIST = README.md RELEASE_NOTES.md netcdf-fortran.pc.in	\
F03Interfaces_LICENSE CMakeLists.txt COPYRIGHT nf-config.in	\
config.h.cmake.in CTestConfig.cmake.in nf-config.cmake.in

# Remove these generated files, for a distclean.
DISTCLEANFILES = VERSION

install-data-hook:
	@echo ''
	@echo '+-------------------------------------------------------------+'
	@echo '| Congratulations! You have successfully installed the netCDF |'
	@echo '| Fortran libraries.                                          |'
	@echo '|                                                             |'
	@echo '| You can use script "nf-config" to find out the relevant     |'
	@echo '| compiler options to build your application. Enter           |'
	@echo '|                                                             |'
	@echo '|     nf-config --help                                        |'
	@echo '|                                                             |'
	@echo '| for additional information.                                 |'
	@echo '|                                                             |'
	@echo '| CAUTION:                                                    |'
	@echo '|                                                             |'
	@echo '| If you have not already run "make check", then we strongly  |'
	@echo '| recommend you do so. It does not take very long.            |'
	@echo '|                                                             |'
	@echo '| Before using netCDF to store important data, test your      |'
	@echo '| build with "make check".                                    |'
	@echo '|                                                             |'
	@echo '| NetCDF is tested nightly on many platforms at Unidata       |'
	@echo '| but your platform is probably different in some ways.       |'
	@echo '|                                                             |'
	@echo '| If any tests fail, please see the netCDF web site:          |'
	@echo '| http://www.unidata.ucar.edu/software/netcdf/                |'
	@echo '|                                                             |'
	@echo '| NetCDF is developed and maintained at the Unidata Program   |'
	@echo '| Center. Unidata provides a broad array of data and software |'
	@echo '| tools for use in geoscience education and research.         |'
	@echo '| http://www.unidata.ucar.edu                                 |'
	@echo '+-------------------------------------------------------------+'
	@echo ''
