## This is an automake file, part of Unidata's netCDF package.
# Copyright 2005-2019, see the COPYRIGHT file for more information.

# This directory builds the netcdf F90 API man page, and contains the
# Doxyfile.in for the doxygen documentation.

# Ed Hartnett, Russ Rew, Dennis Heimbigner, Ward Fisher

# The man pages for Fortran 90 and Fortran 77 APIs.
man_MANS = netcdf_fortran.3  netcdf_f77.3

# Build the doxygen docs, if desired.
if BUILD_DOCS
all-local: doxyfile.stamp
clean-local:
	rm -rf $(top_builddir)/docs/man
	rm -rf $(top_builddir)/docs/html
	rm -rf $(top_builddir)/docs/latex
	rm -rf $(top_builddir)/docs/latex_main

# Doxygen imestamp to prevent rebuilds.
doxyfile.stamp:
	$(DOXYGEN) Doxyfile
endif

# Decide what should be in the man pages. This will happen on the
# developer machine instead of the build machine. See github issue
# #127.
ARGS_MANPAGE = -DAPI=FORTRAN
if USE_NETCDF4
ARGS_MANPAGE += -DNETCDF4=TRUE
endif
if BUILD_DAP
ARGS_MANPAGE += -DDAP=TRUE
endif
if BUILD_PARALLEL
ARGS_MANPAGE += -DPARALLEL_IO=TRUE
endif

# Create the F77 API man page from the m4 source.
netcdf_f77.3: netcdf.m4
	m4 $(M4FLAGS) $(ARGS_MANPAGE) $? >$@ || rm $@

# Create the F90 API man page from the m4 source.
netcdf_fortran.3: netcdf.m4
	m4 $(M4FLAGS) $(ARGS_MANPAGE) $? >$@ || rm $@

# These files will be included with the dist for completeness. The man
# page is built on the developer machine and packaged into the
# dist. The .md files are for the doxygen documentation.
EXTRA_DIST = netcdf.m4 $(man_MANS) CMakeLists.txt netcdf-50x50.png	\
Doxyfile.in netcdf-f77.md netcdf-f90-sec1-usage.md			\
netcdf-f90-sec3-groups.md netcdf-f90-sec5-user_defined_types.md		\
netcdf-f90-sec7-attributes.md netcdf-f90.md				\
netcdf-f90-sec2-datasets.md netcdf-f90-sec4-dimensions.md		\
netcdf-f90-sec6-variables.md

CLEANFILES = doxyfile.stamp

# Clean up all the junk we created!
MAINTAINERCLEANFILES = netcdf_fortran-man.html stamp-* version*
