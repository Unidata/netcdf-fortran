#!/bin/sh
# Copyright 2019, University Corporation for Atmospheric
# Research/Unidata. See netcdf-c/COPYRIGHT file for more info.

# This shell script which copies the fill.nc file from the nf_test
# directory. This data file is used by other tests.

# Ed Hartnett

echo
echo "*** Copying file with fill values."
set -e
cp ${TOPSRCDIR}/nf_test/ref_fills.nc ./fills.nc
echo "*** SUCCESS!"
exit 0
