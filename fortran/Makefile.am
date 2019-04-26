## This is an automake file, part of Unidata's netCDF package.
# Copyright 2005-2006, see the COPYRIGHT file for more information.

# This file controls the building of the fortran 90 API.

# Ed Hartnett, Russ Rew, Dennis Heimbigner, Ward Fisher

# Turn off parallel builds in this directory.
.NOTPARALLEL:

# This is what we are building: the netCDF fortran library, containing
# the F77 and the F90 APIs.
lib_LTLIBRARIES = libnetcdff.la

# These linker flags specify libtool version info.
# See http://www.gnu.org/software/libtool/manual/libtool.html#Libtool-versioning
# for information regarding incrementing `-version-info`.
libnetcdff_la_LDFLAGS = -version-info 6:1:1

# This, plus either netcdf4.f90 or netcdf.f90, is the main source.
libnetcdff_la_SOURCES = typeSizes.f90

if USE_NETCDF4
NETCDF_O = netcdf4.$(OBJEXT)
else
NETCDF_O = netcdf.$(OBJEXT)
endif

# These f90 codes are used for either netCDF classic or netCDF-4 F90
# API.
COMMON_CODES = netcdf_constants.f90 netcdf_externals.f90		\
netcdf_dims.f90 netcdf_attributes.f90 netcdf_overloads.f90		\
netcdf_visibility.f90 netcdf_file.f90 netcdf_variables.f90		\
netcdf_text_variables.f90 netcdf_expanded.f90 netcdf_eightbyte.f90

# These f90 codes are used for the netCDF-4 F90 API.
NETCDF4_CODES = netcdf4_externals.f90 netcdf4_visibility.f90	\
netcdf4_func.f90 netcdf4_overloads.f90 netcdf4_file.f90		\
netcdf4_eightbyte.f90 netcdf4_variables.f90

# Add dependencies for source files included in "meta" source files,
# so the meta source is rebuilt properly when an included file is
# modified.
netcdf.$(OBJEXT): $(COMMON_CODES) netcdf3_file.f90
netcdf4.$(OBJEXT): $(COMMON_CODES) $(NETCDF4_CODES)

# Modules and source for the F77 API.
libnetcdff_la_SOURCES += module_netcdf_nc_data.F90			\
module_netcdf_nc_interfaces.f90 module_netcdf_nf_data.F90		\
module_netcdf_nf_interfaces.F90 module_netcdf_f03.f90 nf_attio.F90	\
nf_control.F90 nf_dim.f90 nf_misc.f90 nf_genatt.f90 nf_geninq.f90	\
nf_genvar.f90 nf_vario.F90 nf_var1io.F90 nf_varaio.F90 nf_varmio.F90	\
nf_varsio.F90

# Add netCDF-4 to F77 API if needed.
if USE_NETCDF4
libnetcdff_la_SOURCES += module_netcdf4_nc_interfaces.f90		\
module_netcdf4_nf_interfaces.F90 module_netcdf4_f03.f90 nf_lib.c	\
nf_nc4.f90
endif USE_NETCDF4

# Add nf_logging to F77 API if needed.
if USE_LOGGING
libnetcdff_la_SOURCES += nf_logging.F90
endif USE_LOGGING

# The file netcdf.f90 includes all these code files.
libnetcdff_la_DEPENDENCIES = $(COMMON_CODES)

if USE_NETCDF4
libnetcdff_la_SOURCES += netcdf4.f90
libnetcdff_la_DEPENDENCIES += $(NETCDF4_CODES)
else !USE_NETCDF4
libnetcdff_la_SOURCES += netcdf.f90 netcdf3_file.f90
endif !USE_NETCDF4

# Add the V2 F77 API.
if BUILD_V2
libnetcdff_la_SOURCES += nf_v2compat.c			\
module_netcdf_fortv2_c_interfaces.f90 nf_fortv2.f90
endif

# These mod files for the F77 API are always built.
MODFILES = typesizes.mod netcdf.mod netcdf_nc_data.mod			\
netcdf_nc_interfaces.mod netcdf_nf_data.mod netcdf_nf_interfaces.mod	\
netcdf_f03.mod

# Mod files are dependant on their source.
netcdf.mod: $(NETCDF_O)
typesizes.mod: typeSizes.$(OBJEXT)
netcdf_nc_data.mod: module_netcdf_nc_data.$(OBJEXT)
netcdf_nc_interfaces.mod: module_netcdf_nc_interfaces.$(OBJEXT)
netcdf_nf_data.mod: module_netcdf_nf_data.$(OBJEXT)
netcdf_nf_interfaces.mod: module_netcdf_nf_interfaces.$(OBJEXT)
netcdf_f03.mod: module_netcdf_f03.$(OBJEXT)

# If v2 API is being built, build v2 F77 API mod file.
if BUILD_V2
MODFILES += netcdf_fortv2_c_interfaces.mod
netcdf_fortv2_c_interfaces.mod: module_netcdf_fortv2_c_interfaces.$(OBJEXT) netcdf_nc_interfaces.mod
endif BUILD_V2

# If netCDF-4 is being build, build the netCDF-4 F77 API mod files.
if USE_NETCDF4
MODFILES += netcdf4_nc_interfaces.mod netcdf4_nf_interfaces.mod	\
netcdf4_f03.mod
netcdf4_nc_interfaces.mod: module_netcdf4_nc_interfaces.$(OBJEXT) netcdf_nc_interfaces.mod
netcdf4_nf_interfaces.mod: module_netcdf4_nf_interfaces.$(OBJEXT)
netcdf4_f03.mod: module_netcdf4_f03.$(OBJEXT)
endif USE_NETCDF4

# The mod files and the netcdf.inc file are built on the user machine,
# and installed as headers.
BUILT_SOURCES = $(MODFILES) netcdf.inc
nodist_include_HEADERS = $(MODFILES) netcdf.inc
libnetcdff_la_DEPENDENCIES += $(MODFILES) netcdf.inc

# Build netcdf.inc file from netcdf2, netcdf3 and netcdf4 files
netcdf.inc: netcdf2.inc netcdf3.inc netcdf4.inc
	echo '!     NetCDF-3.' > netcdf.inc
	cat $(top_srcdir)/fortran/netcdf3.inc >> netcdf.inc
if USE_NETCDF4
	echo >> netcdf.inc
	echo '!     NetCDF-4.' >> netcdf.inc
	cat $(top_srcdir)/fortran/netcdf4.inc >> netcdf.inc
endif
if BUILD_V2
	echo >> netcdf.inc
	echo '!     NetCDF-2.' >> netcdf.inc
	cat $(top_srcdir)/fortran/netcdf2.inc >> netcdf.inc
endif
if USE_LOGGING
	echo >> netcdf.inc
	echo '!     This is to turn on netCDF internal logging.' >> netcdf.inc
	echo '      integer nf_set_log_level' >> netcdf.inc
	echo '      external nf_set_log_level' >> netcdf.inc
endif

EXTRA_DIST = $(COMMON_CODES) $(NETCDF4_CODES) CMakeLists.txt	\
netcdf2.inc netcdf3.inc netcdf4.inc

CLEANFILES = *.mod netcdf.inc
