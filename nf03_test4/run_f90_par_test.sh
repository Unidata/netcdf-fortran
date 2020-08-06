#!/bin/sh

# This shell runs some parallel I/O tests for the F90 API.

# Ed Hartnett, 2009

set -e
echo "Testing netCDF parallel I/O through the F90 API."
mpirun -n 4 ./f90tst_parallel
mpirun -n 4 ./f90tst_parallel2
mpirun -n 4 ./f90tst_parallel3
mpirun -n 8 ./f90tst_nc4_par
mpirun -n 4 ./f90tst_parallel_fill
mpirun -n 4 ./f90tst_parallel_compressed

echo "SUCCESS!!!"
exit 0


