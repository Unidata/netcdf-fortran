The NetCDF Fortran 90 Interface Guide {#f90_The-NetCDF-Fortran-90-Interface-Guide}
========================

[TOC]

This document describes the Fortran 90 interface to the netCDF library.

You can use the netCDF library without knowing about all of the netCDF
interface. If you are creating a netCDF dataset, only a handful of
routines are required to define the necessary dimensions, variables, and
attributes, and to write the data to the netCDF dataset. Similarly, if you are
writing software to access data stored in a particular netCDF object,
only a small subset of the netCDF library is required to open the netCDF
dataset and access the data. Authors of generic applications that access
arbitrary netCDF datasets need to be familiar with more of the netCDF
library.


* \subpage f90-use-of-the-netcdf-library
* \subpage f90_datasets
* \subpage f90_groups
* \subpage f90_dimensions
* \subpage f90-user-defined-data-types
* \subpage f90-variables
* \subpage f90-attributes
