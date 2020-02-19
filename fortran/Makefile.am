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
libnetcdff_la_LDFLAGS = -version-info 7:0:0

# These variables store filnames of the Fortran modules.
if MOD_UPPERCASE

netcdf4_f03_mod = NETCDF4_F03.$(MODEXT)
netcdf4_nc_interfaces_mod = NETCDF4_NC_INTERFACES.$(MODEXT)
netcdf4_nf_interfaces_mod = NETCDF4_NF_INTERFACES.$(MODEXT)
netcdf_f03_mod = NETCDF_F03.$(MODEXT)
netcdf_fortv2_c_interfaces_mod = NETCDF_FORTV2_C_INTERFACES.$(MODEXT)
netcdf_mod = NETCDF.$(MODEXT)
netcdf_nc_data_mod = NETCDF_NC_DATA.$(MODEXT)
netcdf_nc_interfaces_mod = NETCDF_NC_INTERFACES.$(MODEXT)
netcdf_nf_data_mod = NETCDF_NF_DATA.$(MODEXT)
netcdf_nf_interfaces_mod = NETCDF_NF_INTERFACES.$(MODEXT)
typesizes_mod = TYPESIZES.$(MODEXT)

else !MOD_UPPERCASE

netcdf4_f03_mod = netcdf4_f03.$(MODEXT)
netcdf4_nc_interfaces_mod = netcdf4_nc_interfaces.$(MODEXT)
netcdf4_nf_interfaces_mod = netcdf4_nf_interfaces.$(MODEXT)
netcdf_f03_mod = netcdf_f03.$(MODEXT)
netcdf_fortv2_c_interfaces_mod = netcdf_fortv2_c_interfaces.$(MODEXT)
netcdf_mod = netcdf.$(MODEXT)
netcdf_nc_data_mod = netcdf_nc_data.$(MODEXT)
netcdf_nc_interfaces_mod = netcdf_nc_interfaces.$(MODEXT)
netcdf_nf_data_mod = netcdf_nf_data.$(MODEXT)
netcdf_nf_interfaces_mod = netcdf_nf_interfaces.$(MODEXT)
typesizes_mod = typesizes.$(MODEXT)

endif !MOD_UPPERCASE

# Common compiled source files.
libnetcdff_la_SOURCES = module_netcdf_f03.f90 module_netcdf_nc_data.F90      \
module_netcdf_nc_interfaces.f90 module_netcdf_nf_data.F90                    \
module_netcdf_nf_interfaces.F90 nf_nc.f90 typeSizes.f90

MODULES = $(netcdf_f03_mod) $(netcdf_nc_data_mod)                            \
$(netcdf_nc_interfaces_mod) $(netcdf_nf_data_mod)                            \
$(netcdf_nf_interfaces_mod) $(typesizes_mod)

# Module files depend on the object files that correspond to source files that
# declare the modules.
$(netcdf_f03_mod): module_netcdf_f03.lo
$(netcdf_nc_data_mod): module_netcdf_nc_data.lo
$(netcdf_nc_interfaces_mod): module_netcdf_nc_interfaces.lo
$(netcdf_nf_data_mod): module_netcdf_nf_data.lo
$(netcdf_nf_interfaces_mod): module_netcdf_nf_interfaces.lo
$(typesizes_mod): typeSizes.lo

# Object files that correspond to source files that USE modules depend on the
# module files.
module_netcdf_f03.lo: $(netcdf_nf_interfaces_mod) $(netcdf_nf_data_mod)
module_netcdf_nc_interfaces.lo: $(netcdf_nc_data_mod)
module_netcdf_nf_data.lo: $(netcdf_nc_data_mod)
module_netcdf_nf_interfaces.lo: $(netcdf_nf_data_mod)
nf_nc.lo: $(netcdf_nc_interfaces_mod)

# Compile nf_logging.F90 only when the corresponding feature is enabled.
# Otherwise, the file is empty, which makes some compilers to fail.
if USE_LOGGING
libnetcdff_la_SOURCES += nf_logging.F90
endif USE_LOGGING

# These are the source for the F77 API.
libnetcdff_la_SOURCES += nf_attio.F90 nf_control.F90 nf_dim.f90 nf_genatt.f90 \
nf_geninq.f90 nf_genvar.f90 nf_misc.f90 nf_var1io.F90 nf_varaio.F90           \
nf_vario.F90 nf_varmio.F90 nf_varsio.F90

# The respective objects depend on the netcdf_nc_interfaces module.
nf_attio.lo nf_control.lo nf_dim.lo nf_genatt.lo nf_geninq.lo nf_genvar.lo    \
nf_misc.lo nf_var1io.lo nf_varaio.lo nf_vario.lo nf_varmio.lo                 \
nf_varsio.lo: $(netcdf_nc_interfaces_mod)

# Add the V2 F77 API.
if BUILD_V2

libnetcdff_la_SOURCES += module_netcdf_fortv2_c_interfaces.f90 nf_fortv2.f90  \
nf_v2compat.c

MODULES += $(netcdf_fortv2_c_interfaces_mod)

$(netcdf_fortv2_c_interfaces_mod): module_netcdf_fortv2_c_interfaces.lo

module_netcdf_fortv2_c_interfaces.lo: $(netcdf_nc_interfaces_mod)
nf_fortv2.lo: $(netcdf_fortv2_c_interfaces_mod) $(netcdf_nc_interfaces_mod)

endif BUILD_V2

# These f90 codes are not compiled directly but included by either netCDF
# classic or netCDF-4 F90 interface files.
COMMON_INCLUDES = netcdf_attributes.f90 netcdf_constants.f90 netcdf_dims.f90  \
netcdf_expanded.f90 netcdf_externals.f90 netcdf_file.f90 netcdf_overloads.f90 \
netcdf_text_variables.f90 netcdf_visibility.f90

# These f90 codes are not compiled directly but included by the netCDF classic
# interface file.
NETCDF3_INCLUDES = netcdf3_file.f90 netcdf_eightbyte.f90 netcdf_variables.f90

# These f90 codes are not compiled directly but included by the netCDF-4 F90
# interface file.
NETCDF4_INCLUDES = netcdf4_eightbyte.f90 netcdf4_externals.f90                \
netcdf4_file.f90 netcdf4_func.f90 netcdf4_overloads.f90 netcdf4_variables.f90 \
netcdf4_visibility.f90

EXTRA_DIST = $(COMMON_INCLUDES) $(NETCDF3_INCLUDES) $(NETCDF4_INCLUDES)

# Are we building netCDF-4?
if USE_NETCDF4

# Add additional source files to the library to support netCDF4.
libnetcdff_la_SOURCES += module_netcdf4_f03.f90                               \
module_netcdf4_nc_interfaces.f90 module_netcdf4_nf_interfaces.F90 netcdf4.f90 \
nf_lib.c nf_nc4.f90

# Install additional module files.
MODULES += $(netcdf4_f03_mod) $(netcdf4_nc_interfaces_mod)                    \
$(netcdf4_nf_interfaces_mod)

$(netcdf4_f03_mod): module_netcdf4_f03.lo
$(netcdf4_nc_interfaces_mod): module_netcdf4_nc_interfaces.lo
$(netcdf4_nf_interfaces_mod): module_netcdf4_nf_interfaces.lo
$(netcdf_mod): netcdf4.lo

module_netcdf4_f03.lo: $(netcdf_nf_interfaces_mod) $(netcdf4_nf_interfaces_mod) $(netcdf_nf_data_mod)
module_netcdf4_nc_interfaces.lo: $(netcdf_nc_interfaces_mod)
module_netcdf4_nf_interfaces.lo: $(netcdf4_nc_interfaces_mod) $(netcdf_nf_data_mod)
netcdf4.lo: $(COMMON_INCLUDES) $(NETCDF4_INCLUDES) $(typesizes_mod)
nf_nc4.lo: $(netcdf4_nc_interfaces_mod)

else !USE_NETCDF4

libnetcdff_la_SOURCES += netcdf.f90 netcdf3_file.f90

$(netcdf_mod): netcdf.lo

netcdf.lo: $(COMMON_INCLUDES) $(NETCDF3_INCLUDES) $(typesizes_mod)

endif !USE_NETCDF4

MODULES += $(netcdf_mod)

# If a module file is accidentally deleted, delete the corresponding object
# and rebuild it.
$(MODULES):
	@if test -z $<; then \
	  echo "Cannot find Fortran source file declaring module '$(basename $(@F))'." >&2; \
	elif test ! -f $@; then \
	  rm -f $<; $(MAKE) $(AM_MAKEFLAGS) $<; \
	fi

# If the rule above rebuilds an object in a subprocess of make, the current
# process might not know about it. Therefore, to enforce regeneration of the
# library, we introduce the following dependency.
EXTRA_libnetcdff_la_DEPENDENCIES = $(MODULES)

# Build netcdf.inc file from netcdf2, netcdf3 and netcdf4 files
netcdf.inc: netcdf2.inc netcdf3.inc netcdf4.inc
	echo '!     NetCDF-3.' > netcdf.inc
	cat $(top_srcdir)/fortran/netcdf3.inc >> netcdf.inc
if USE_NETCDF4
	echo >> netcdf.inc
	echo '!     NetCDF-4.' >> netcdf.inc
	cat $(top_srcdir)/fortran/netcdf4.inc >> netcdf.inc
endif USE_NETCDF4
if BUILD_V2
	echo >> netcdf.inc
	echo '!     NetCDF-2.' >> netcdf.inc
	cat $(top_srcdir)/fortran/netcdf2.inc >> netcdf.inc
endif BUILD_V2
if USE_LOGGING
	echo >> netcdf.inc
	echo '!     This is to turn on netCDF internal logging.' >> netcdf.inc
	echo '      integer nf_set_log_level' >> netcdf.inc
	echo '      external nf_set_log_level' >> netcdf.inc
endif USE_LOGGING

EXTRA_DIST += netcdf2.inc netcdf3.inc netcdf4.inc CMakeLists.txt

# Install modules and the header file.
nodist_fmod_DATA = $(MODULES)
nodist_include_HEADERS = netcdf.inc

# Delete module files together with the corresponding objects, i.e. at
# 'mostlyclean' time.
MOSTLYCLEANFILES = $(MODULES)

CLEANFILES = netcdf.inc
