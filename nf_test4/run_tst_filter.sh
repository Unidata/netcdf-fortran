#!/bin/sh

# Assume that netcdf-c installed bzip2 plugin
PLUGINDIR=`../nf-config --prefix`
export HDF5_PLUGIN_PATH="${PLUGINDIR}/lib"
./ftst_filter


