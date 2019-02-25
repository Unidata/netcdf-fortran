#!/bin/sh
# Copyright 2019, University Corporation for Atmospheric
# Research/Unidata. See netcdf-c/COPYRIGHT file for more info.

# This shell script runs the netCDF netCDF-4 parallel I/O F90
# examples.

# Ed Hartnett

echo "*** Running netCDF-4 F90 parallel I/O examples."
set -e
mpiexec -n 4 ./simple_xy_par_wr
mpiexec -n 4 ./simple_xy_par_rd
mpiexec -n 4 ./simple_xy_par_wr2
