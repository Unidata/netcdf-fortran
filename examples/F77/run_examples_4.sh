#!/bin/sh
# Copyright 1993 - 2019, University Corporation for Atmospheric
# Research/Unidata. See netcdf-c/COPYRIGHT file for more info.

# This shell script runs the netCDF-4 F77 examples.
# Ed Hartnett

echo "*** Running NetCDF-4 F77 examples."
set -e

echo "*** running simple_xy netCDF-4 examples..."
./simple_xy_nc4_wr
./simple_xy_nc4_rd

echo "*** Examples successful!"
exit 0
