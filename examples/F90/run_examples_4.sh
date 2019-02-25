#!/bin/sh
# Copyright 1993 - 2019, University Corporation for Atmospheric
# Research/Unidata. See netcdf-c/COPYRIGHT file for more info.

# This shell script runs the netCDF classic F90 examples.
# Ed Hartnett

echo "*** Running F90 examples."
set -e

echo "*** running simple_xy examples..."
./nc4_simple_xy_wr
./simple_xy_rd

echo "*** running sfc_pres_temp examples..."
./nc4_sfc_pres_temp_wr
./sfc_pres_temp_rd

echo "*** running pres_temp_4D examples..."
./nc4_pres_temp_4D_wr
./pres_temp_4D_rd

echo "*** running simple_xy_nc4 examples..."
./simple_xy_nc4_wr
./simple_xy_nc4_rd

echo "*** Examples successful!"
exit 0
