#!/bin/sh

# This shell runs some parallel I/O tests for the F77 API.

# Ed Hartnett, 2019

set -e
echo "Testing netCDF parallel I/O through the F77 API with 03 interface..."

mpiexec -n 4 ./f03tst_parallel

echo "SUCCESS!!!"
exit 0
