#!/bin/sh
# This shell script which copies the fill.nc file from the source dist.

echo
echo "*** Copying file with fill values."
set -e
cp $srcdir/ref_fills.nc fills.nc
echo "*** SUCCESS!"
exit 0
