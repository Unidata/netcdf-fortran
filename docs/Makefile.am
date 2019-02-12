## This is an automake file, part of Unidata's netCDF package.
# Copyright 2005-2019, see the COPYRIGHT file for more information.

# This file builds the netcdf documentation.

# The "all" target does nothing in this directory. The "dist" target
# *does* build the documentation, because the distribution contains
# all of the built documentation.

# Ed Hartnett, Russ Rew, Dennis Heimbigner, Ward Fisher

# The "install" target installs the documentation in a directory
# called $(prefix)/doc/$(PACKAGE)-$(VERSION).

man_MANS = netcdf_fortran.3

# These files will be included with the dist.
EXTRA_DIST = netcdf.m4 $(man_MANS) CMakeLists.txt netcdf-50x50.png	\
Doxyfile.in

# To build documentation you must have M4 in their path.
M4=m4

# Clean up all the junk we created!
MAINTAINERCLEANFILES = netcdf_fortran-man.html stamp-* version*

ARGS_MANPAGE = -DAPI=FORTRAN -DNETCDF4=TRUE
if BUILD_DAP
ARGS_MANPAGE += -DDAP=TRUE
endif
if BUILD_PARALLEL
ARGS_MANPAGE += -DPARALLEL_IO=TRUE
endif

manpages: $(top_srcdir)/docs/netcdf.m4
	m4 $(M4FLAGS) $(ARGS_MANPAGE) $? >netcdf_fortran.3 || rm netcdf_fortran.3
