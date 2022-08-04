## This is a automake file, part of Unidata's netCDF package.
# Copyright 2011-2019, see the COPYRIGHT file for more information.

# This file builds F77 examples.

# Ed Hartnett, Russ Rew, Dennis Heimbigner, Ward Fisher

AM_FCFLAGS = -I$(top_srcdir)/fortran ${AM_CPPFLAGS}
AM_FCFLAGS += $(FCFLAGS_f90)
AM_FCFLAGS += @MOD_FLAG@$(top_builddir)/fortran
AM_FFLAGS = ${AM_FCFLAGS}

AM_LDFLAGS = ${top_builddir}/fortran/libnetcdff.la -lnetcdf
LDADD = ${top_builddir}/fortran/libnetcdff.la -lnetcdf

# These are the example programs.
check_PROGRAMS = simple_xy_wr simple_xy_rd sfc_pres_temp_wr	\
sfc_pres_temp_rd pres_temp_4D_wr pres_temp_4D_rd

# Run all test programs.
TESTS = run_examples.sh

if USE_NETCDF4
check_PROGRAMS += simple_xy_nc4_wr simple_xy_nc4_rd
simple_xy_nc4_wr_SOURCES = simple_xy_nc4_wr.f
simple_xy_nc4_rd_SOURCES = simple_xy_nc4_rd.f
TESTS += run_examples_4.sh
endif

# Here's the source code for the programs.
simple_xy_wr_SOURCES = simple_xy_wr.f
simple_xy_rd_SOURCES = simple_xy_rd.f
sfc_pres_temp_wr_SOURCES = sfc_pres_temp_wr.f
sfc_pres_temp_rd_SOURCES = sfc_pres_temp_rd.f
pres_temp_4D_wr_SOURCES = pres_temp_4D_wr.f
pres_temp_4D_rd_SOURCES = pres_temp_4D_rd.f

# Cleaning up files created during the process.
CLEANFILES = simple_xy.nc sfc_pres_temp.nc pres_temp_4D.nc	\
simple_xy_nc4.nc

EXTRA_DIST = CMakeLists.txt run_examples.sh run_examples_4.sh
