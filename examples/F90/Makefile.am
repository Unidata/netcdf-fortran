## This is a automake file, part of Unidata's netCDF package.
# Copyright 2006-2019, see the COPYRIGHT file for more information.

# This file builds F90 examples.

# Ed Hartnett, Russ Rew, Dennis Heimbigner, Ward Fisher

# Turn off parallel builds in this directory.
.NOTPARALLEL:

AM_FCFLAGS = -I$(top_srcdir)/fortran ${AM_CPPFLAGS}
AM_FCFLAGS += $(FCFLAGS_f90)
AM_FCFLAGS += @MOD_FLAG@$(top_builddir)/fortran
AM_FFLAGS = ${AM_FCFLAGS}

AM_LDFLAGS = ${top_builddir}/fortran/libnetcdff.la -lnetcdf
LDADD = ${top_builddir}/fortran/libnetcdff.la -lnetcdf

# These are the netCDF classic example programs.
check_PROGRAMS = simple_xy_wr simple_xy_rd sfc_pres_temp_wr	\
sfc_pres_temp_rd pres_temp_4D_wr pres_temp_4D_rd

# Add the script to run the classic examples.
TESTS = run_examples.sh

# Here's the source code for the classic example programs.
simple_xy_wr_SOURCES = simple_xy_wr.f90
simple_xy_rd_SOURCES = simple_xy_rd.f90
sfc_pres_temp_wr_SOURCES = sfc_pres_temp_wr.f90
sfc_pres_temp_rd_SOURCES = sfc_pres_temp_rd.f90
pres_temp_4D_wr_SOURCES = pres_temp_4D_wr.f90
pres_temp_4D_rd_SOURCES = pres_temp_4D_rd.f90

# Does C library have netCDF-4? If so, build netCDF-4 examples.
if USE_NETCDF4
# In a fit of past cleverness I decided to re-purpose the classic
# examples and use sed to turn them into netCDF-4 examples. This may
# have been a bit too clever.
BUILT_SOURCES = nc4_simple_xy_wr.f90 nc4_sfc_pres_temp_wr.f90	\
nc4_pres_temp_4D_wr.f90
nc4_simple_xy_wr_SOURCES = nc4_simple_xy_wr.f90
nc4_sfc_pres_temp_wr_SOURCES = nc4_sfc_pres_temp_wr.f90
nc4_pres_temp_4D_wr_SOURCES = nc4_pres_temp_4D_wr.f90

# These are the netCDF-4 examples, created from classic examples.
check_PROGRAMS += nc4_simple_xy_wr nc4_sfc_pres_temp_wr	\
nc4_pres_temp_4D_wr

# These are additional netCDF-4 examples.
check_PROGRAMS += simple_xy_nc4_wr simple_xy_nc4_rd
simple_xy_nc4_wr_SOURCES = simple_xy_nc4_wr.f90
simple_xy_nc4_rd_SOURCES = simple_xy_nc4_rd.f90

# Add the script to run netCDF-4 examples.
TESTS += run_examples_4.sh

# Optionally add parallel i/o examples.
if TEST_PARALLEL
check_PROGRAMS += simple_xy_par_wr simple_xy_par_rd simple_xy_par_wr2
simple_xy_par_wr_SOURCES = simple_xy_par_wr.f90
simple_xy_par_wr2_SOURCES = simple_xy_par_wr2.f90
simple_xy_par_rd_SOURCES = simple_xy_par_rd.f90
TESTS += run_f90_par_examples.sh
endif # TEST_PARALLEL

endif #USE_NETCDF4

# Build netCDf-4 example from netCDF classic example.
# Note old version used sed -i, but -i is not universally recognized
nc4_simple_xy_wr.f90:
	sed -e 's/nf90_clobber/nf90_netcdf4/' $(srcdir)/simple_xy_wr.f90 \
	| sed -e 's/simple_xy/nc4_simple_xy/' > nc4_simple_xy_wr.f90

# Build netCDf-4 example from netCDF classic example.
nc4_sfc_pres_temp_wr.f90:
	sed -e 's/nf90_clobber/nf90_netcdf4/' $(srcdir)/sfc_pres_temp_wr.f90 \
	| sed -e 's/sfc_pres_temp/nc4_sfc_pres_temp/' > nc4_sfc_pres_temp_wr.f90

# Build netCDf-4 example from netCDF classic example.
nc4_pres_temp_4D_wr.f90:
	sed -e 's/nf90_clobber/nf90_netcdf4/' $(srcdir)/pres_temp_4D_wr.f90 \
	| sed -e 's/pres_temp_4D/nc4_pres_temp_4D/' > nc4_pres_temp_4D_wr.f90

# Cleaning up files created during the process.
CLEANFILES = simple_xy.nc sfc_pres_temp.nc pres_temp_4D.nc		\
simple_xy_nc4.nc simple_xy_par.nc nc4_simple_xy_wr.f90 simple_xy.cdl	\
nc4_sfc_pres_temp_wr.f90 sfc_pres_temp.cdl nc4_pres_temp_4d_wr.f90	\
pres_temp_4d.cdl nc4_simple_xy.nc nc4_pres_temp_4D.nc			\
nc4_sfc_pres_temp.nc 

EXTRA_DIST = run_examples.sh run_examples_4.sh	\
run_f90_par_examples.sh CMakeLists.txt
