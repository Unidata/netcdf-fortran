#!/bin/sh
# Copyright 1993 - 2019, University Corporation for Atmospheric
# Research/Unidata. See netcdf-c/COPYRIGHT file for more info.

# This shell script runs the netCDF classic F90 examples.
# Ed Hartnett

echo "*** Running F90 examples."
set -e

echo "*** running simple_xy examples..."
./simple_xy_wr
./simple_xy_rd

echo "*** running sfc_pres_temp examples..."
./sfc_pres_temp_wr
./sfc_pres_temp_rd

echo "*** running pres_temp_4D examples..."
./pres_temp_4D_wr
./pres_temp_4D_rd

echo "*** Examples successful!"
exit 0
