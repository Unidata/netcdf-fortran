## This is an automake file, part of Unidata's netCDF package.
# Copyright 2005-2011, see the COPYRIGHT file for more information.

# Tell make to install these as a header file.
include_HEADERS = nfconfig.inc

# The F77 API man page.
man_MANS = netcdf_f77.3

# This rule generates the F77 manpage.
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
netcdf_f77.3: $(top_srcdir)/docs/netcdf.m4
	m4 $(M4FLAGS) $(ARGS_MANPAGE) $? >$@ || rm $@

# The nfconfig.in file is turned into nfconfig.inc by the configure
# script. The man page is generated on the developers machine for the
# dist.
EXTRA_DIST = nfconfig.in nfconfig.inc $(man_MANS) \
	netcdf_f.h CMakeLists.txt nfconfig.in.cmake

# These files need to be cleaned up my make.
CLEANFILES = nfconfig1.inc netcdf.inc
DISTCLEANFILES = nfconfig.inc
