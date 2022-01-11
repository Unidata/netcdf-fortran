## This is an automake file, part of Unidata's netCDF package.
# Copyright 2005-2006, see the COPYRIGHT file for more information.

# This file controls the building of the fortran 90 API.

# Ed Hartnett, Russ Rew, Dennis Heimbigner, Ward Fisher

AM_FCFLAGS = -I.

# This is what we are building: the netCDF fortran library, containing
# the F77 and the F90 APIs.
lib_LTLIBRARIES = libnetcdff.la

# These linker flags specify libtool version info.
# See http://www.gnu.org/software/libtool/manual/libtool.html#Libtool-versioning
# for information regarding incrementing `-version-info`.
libnetcdff_la_LDFLAGS = -version-info 8:0:1

# These f90 codes are used for either netCDF classic or netCDF-4 F90
# API.
COMMON_CODES = netcdf_constants.f90 netcdf_externals.f90	\
netcdf_dims.f90 netcdf_attributes.f90 netcdf_overloads.f90	\
netcdf_visibility.f90 netcdf_file.f90 netcdf_text_variables.f90	\
netcdf_expanded.f90

# These f90 codes are used for the netCDF-4 F90 API.
NETCDF4_CODES = netcdf4_externals.f90 netcdf4_visibility.f90	\
netcdf4_func.f90 netcdf4_overloads.f90 netcdf4_file.f90		\
netcdf4_eightbyte.f90 netcdf4_variables.f90

# These f90 codes are used in the netCDF classic API, when netCDF/HDF5
# is not being built.
NETCDF3_CODES = netcdf_eightbyte.f90 netcdf3_file.f90	\
netcdf_variables.f90

# Build these uninstalled convenience libraries.
noinst_LTLIBRARIES = libtypeSizes.la libnetcdf_nc_data.la	\
libnetcdf_nf_data.la libnetcdf_nc_interfaces.la			\
libnetcdf_nf_interfaces.la libnetcdfm.la libnetcdf_f03.la

# These are the ource for the F77 API.
libnetcdff_la_SOURCES = nf_attio.F90 nf_control.F90 nf_dim.f90		\
nf_misc.f90 nf_genatt.f90 nf_geninq.f90 nf_genvar.f90 nf_vario.F90	\
nf_var1io.F90 nf_varaio.F90 nf_varmio.F90 nf_varsio.F90			\
nf_logging.F90 nf_nc.f90

# The respective objects depend on the netcdf_nc_interfaces module.
nf_attio.lo nf_control.lo nf_dim.lo nf_genatt.lo nf_geninq.lo nf_genvar.lo    \
nf_misc.lo nf_var1io.lo nf_varaio.lo nf_vario.lo nf_varmio.lo                 \
nf_varsio.lo: netcdf_nc_interfaces.mod

# Different source for the netcdf.mod is used for netcdf classic
# vs. netcdf4.
if USE_NETCDF4

# Use the netCDF-4 F90 code.
libnetcdfm_la_SOURCES = netcdf4.f90
netcdf4.lo: typesizes.mod $(COMMON_CODES) $(NETCDF4_CODES)
netcdf.mod: netcdf4.lo

else # classic-only build

# Use the netCDF classic F90 code.
libnetcdfm_la_SOURCES = netcdf.f90
netcdf.lo: typesizes.mod $(COMMON_CODES) $(NETCDF3_CODES)
netcdf.mod: netcdf.lo
libnetcdff_la_SOURCES += netcdf3_file.f90

endif # USE_NETCDF4

# Each convenience library depends on its source.
libtypeSizes_la_SOURCES = typeSizes.f90
libnetcdf_nc_data_la_SOURCES = module_netcdf_nc_data.F90
libnetcdf_nf_data_la_SOURCES = module_netcdf_nf_data.F90
libnetcdf_nc_interfaces_la_SOURCES = module_netcdf_nc_interfaces.f90
libnetcdf_nf_interfaces_la_SOURCES = module_netcdf_nf_interfaces.F90
libnetcdf_f03_la_SOURCES = module_netcdf_f03.f90

# Each mod file depends on the .lo file.
typesizes.mod: typeSizes.lo
netcdf_nc_data.mod: module_netcdf_nc_data.lo
netcdf_nf_data.mod: module_netcdf_nf_data.lo
netcdf_nc_interfaces.mod: module_netcdf_nc_interfaces.lo
netcdf_nf_interfaces.mod: module_netcdf_nf_interfaces.lo
netcdf_f03.mod: module_netcdf_f03.lo

# Some mods are dependant on other mods in this dir.
module_netcdf_nf_data.lo: netcdf_nc_data.mod
module_netcdf_nc_interfaces.lo: netcdf_nc_data.mod
module_netcdf_nf_interfaces.lo: netcdf_nf_data.mod
module_netcdf_f03.lo: netcdf_nf_data.mod netcdf_nf_interfaces.mod
nf_nc.lo: netcdf_nc_interfaces.mod

# Mod files are built and then installed as headers.
MODFILES = typesizes.mod netcdf_nc_data.mod netcdf_nf_data.mod		\
netcdf_nc_interfaces.mod netcdf_nf_interfaces.mod netcdf_f03.mod

# Add our convenience libraries to the netCDF fortran library.
libnetcdff_la_LIBADD = libtypeSizes.la libnetcdf_nc_data.la	\
libnetcdf_nf_data.la libnetcdf_nc_interfaces.la			\
libnetcdf_nf_interfaces.la libnetcdfm.la libnetcdf_f03.la

# Add the V2 F77 API.
if BUILD_V2
noinst_LTLIBRARIES += libnetcdf_fortv2_c_interfaces.la
libnetcdf_fortv2_c_interfaces_la_SOURCES = module_netcdf_fortv2_c_interfaces.f90
netcdf_fortv2_c_interfaces.mod: module_netcdf_fortv2_c_interfaces.lo
module_netcdf_fortv2_c_interfaces.lo: netcdf_nc_interfaces.mod
nf_fortv2.lo: netcdf_fortv2_c_interfaces.mod netcdf_nc_interfaces.mod
MODFILES += netcdf_fortv2_c_interfaces.mod
libnetcdff_la_SOURCES += nf_v2compat.c nf_fortv2.f90
libnetcdff_la_LIBADD += libnetcdf_fortv2_c_interfaces.la
endif # BUILD_V2

# Are we building netCDF-4?
if USE_NETCDF4

# Add additional source files to the library to support netCDF4.
libnetcdff_la_SOURCES += nf_lib.c nf_nc4.f90
nf_nc4.$(OBJEXT): netcdf4_nc_interfaces.mod

# Add these uninstalled convenience libraries for netcdf-4.
noinst_LTLIBRARIES += libnetcdf4_nc_interfaces.la	\
libnetcdf4_nf_interfaces.la libnetcdf4_f03.la

# Each convenience library depends on its source.
libnetcdf4_nc_interfaces_la_SOURCES = module_netcdf4_nc_interfaces.f90
libnetcdf4_nf_interfaces_la_SOURCES = module_netcdf4_nf_interfaces.F90
libnetcdf4_f03_la_SOURCES = module_netcdf4_f03.f90

# Each mod file depends on the .lo file.
netcdf4_nc_interfaces.mod: module_netcdf4_nc_interfaces.lo
netcdf4_nf_interfaces.mod: module_netcdf4_nf_interfaces.lo
netcdf4_f03.mod: module_netcdf4_f03.lo

# Some mods are dependant on other mods in this dir.
module_netcdf4_nf_interfaces.lo: netcdf4_nc_interfaces.mod netcdf_nf_data.mod
module_netcdf4_nc_interfaces.lo: netcdf_nc_interfaces.mod
module_netcdf4_f03.lo: netcdf_nf_data.mod netcdf_nf_interfaces.mod netcdf4_nf_interfaces.mod

# Add the netcdf4 mod files to the list.
MODFILES += netcdf4_nc_interfaces.mod netcdf4_nf_interfaces.mod	\
netcdf4_f03.mod

# Add the netcdf4 convenience libraries to the netcdf fortran library.
libnetcdff_la_LIBADD += libnetcdf4_nc_interfaces.la	\
libnetcdf4_nf_interfaces.la libnetcdf4_f03.la

endif # USE_NETCDF4

# This must come last in the list of MODFILES.
MODFILES += netcdf.mod

# Mod files are build sources.
BUILT_SOURCES = $(MODFILES)

# Mod files are installed, but not distrubuted.
nodist_fmod_DATA = $(MODFILES)

# If a module file is accidentally deleted, delete the corresponding
# object and rebuild it.
$(MODFILES):
	@if test -z $<; then \
	  echo "Cannot find Fortran source file declaring module '$(basename $(@F))'." >&2; \
	elif test ! -f $@; then \
	  rm -f $<; $(MAKE) $(AM_MAKEFLAGS) $<; \
	fi

# If the rule above rebuilds an object in a subprocess of make, the
# current process might not know about it. Therefore, to enforce
# regeneration of the library, we introduce the following dependency.
EXTRA_libnetcdff_la_DEPENDENCIES = $(MODFILES)

# The netcdf.inc file is built on the user machine, and installed as
# a header.
BUILT_SOURCES += netcdf.inc
nodist_include_HEADERS = netcdf.inc

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

EXTRA_DIST = $(COMMON_CODES) $(NETCDF4_CODES) $(NETCDF3_CODES) CMakeLists.txt	\
netcdf2.inc netcdf3.inc netcdf4.inc

MOSTLYCLEANFILES = *.mod netcdf.inc
