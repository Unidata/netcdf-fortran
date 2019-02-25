#!/bin/sh
# Copyright 2019, University Corporation for Atmospheric
# Research/Unidata. See netcdf-c/COPYRIGHT file for more info.

# This shell script runs the F90 API parallel I/O tests.

# Ed Hartnett

echo "*** Running F90 API parallel I/O test."
set -e
mpiexec -n 4 ./f03tst_parallel
