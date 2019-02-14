## This is an automake file, part of Unidata's netCDF package.
# Copyright 2005-2019, see the COPYRIGHT file for more information.

# This file builds the netcdf documentation.

# The "all" target does nothing in this directory. The "dist" target
# *does* build the documentation, because the distribution contains
# all of the built documentation.

# Ed Hartnett, Russ Rew, Dennis Heimbigner, Ward Fisher

# The man page for Fortran APIs.
man_MANS = netcdf_fortran.3

# These files will be included with the dist. The man page is built on
# the developer machine and packaged into the dist.
EXTRA_DIST = netcdf.m4 $(man_MANS) CMakeLists.txt netcdf-50x50.png	\
Doxyfile.in

# To build documentation you must have M4 in their path.
M4 = m4

# Clean up all the junk we created!
MAINTAINERCLEANFILES = netcdf_fortran-man.html stamp-* version*

# Decide what should be in the man page. This will happen on the
# developer machine instead of the build machine. See github issue
# #127.
ARGS_MANPAGE = -DAPI=FORTRAN -DNETCDF4=TRUE
if BUILD_DAP
ARGS_MANPAGE += -DDAP=TRUE
endif
if BUILD_PARALLEL
ARGS_MANPAGE += -DPARALLEL_IO=TRUE
endif

# Rule to build the man page.
manpages: $(top_srcdir)/docs/netcdf.m4
	m4 $(M4FLAGS) $(ARGS_MANPAGE) $? >netcdf_fortran.3 || rm netcdf_fortran.3
