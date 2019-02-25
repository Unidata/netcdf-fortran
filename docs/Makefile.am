## This is an automake file, part of Unidata's netCDF package.
# Copyright 2005-2019, see the COPYRIGHT file for more information.

# This directory builds the netcdf F90 API man page, and contains the
# Doxyfile.in for the doxygen documentation.

# Ed Hartnett, Russ Rew, Dennis Heimbigner, Ward Fisher

# The man page for Fortran APIs.
man_MANS = netcdf_fortran.3

# These files will be included with the dist for completeness. The man
# page is built on the developer machine and packaged into the
# dist. The .md files are for the doxygen documentation.
EXTRA_DIST = netcdf.m4 $(man_MANS) CMakeLists.txt netcdf-50x50.png	\
Doxyfile.in netcdf-f77.md netcdf-f90-sec1-usage.md			\
netcdf-f90-sec3-groups.md netcdf-f90-sec5-user_defined_types.md		\
netcdf-f90-sec7-attributes.md netcdf-f90.md				\
netcdf-f90-sec2-datasets.md netcdf-f90-sec4-dimensions.md		\
netcdf-f90-sec6-variables.md

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
