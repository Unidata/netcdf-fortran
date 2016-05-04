4 Dimensions {#f90_dimensions}
============

[TOC]

4.1 Dimensions Introduction {#f90-dimensions-introduction}
============

Dimensions for a netCDF dataset are defined when it is created, while
the netCDF dataset is in define mode. Additional dimensions may be added
later by reentering define mode. A netCDF dimension has a name and a
length. At most one dimension in a netCDF dataset can have the unlimited
length, which means variables using this dimension can grow along this
dimension.

There is a suggested limit (512) to the number of dimensions that can be
defined in a single netCDF dataset. The limit is the value of the
constant NF90\_MAX\_DIMS. The purpose of the limit is to make writing
generic applications simpler. They need only provide an array of
NF90\_MAX\_DIMS dimensions to handle any netCDF dataset. The
implementation of the netCDF library does not enforce this advisory
maximum, so it is possible to use more dimensions, if necessary, but
netCDF utilities that assume the advisory maximums may not be able to
handle the resulting netCDF datasets.

Ordinarily, the name and length of a dimension are fixed when the
dimension is first defined. The name may be changed later, but the
length of a dimension (other than the unlimited dimension) cannot be
changed without copying all the data to a new netCDF dataset with a
redefined dimension length.

A netCDF dimension in an open netCDF dataset is referred to by a small
integer called a dimension ID. In the Fortran 90 interface, dimension
IDs are 1, 2, 3, ..., in the order in which the dimensions were defined.

Operations supported on dimensions are:

-   Create a dimension, given its name and length.
-   Get a dimension ID from its name.
-   Get a dimension’s name and length from its ID.
-   Rename a dimension.

4.2 NF90_DEF_DIM {#f90-nf90_def_dim}
============



The function NF90\_DEF\_DIM adds a new dimension to an open netCDF
dataset in define mode. It returns (as an argument) a dimension ID,
given the netCDF ID, the dimension name, and the dimension length. At
most one unlimited length dimension, called the record dimension, may be
defined for each netCDF dataset.



## Usage


~~~~.fortran

 function nf90_def_dim(ncid, name, len, dimid)
   integer,             intent( in) :: ncid
   character (len = *), intent( in) :: name
   integer,             intent( in) :: len
   integer,             intent(out) :: dimid
   integer                          :: nf90_def_dim

~~~~


`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`name`

:   Dimension name.

`len`

:   Length of dimension; that is, number of values for this dimension as
    an index to variables that use it. This should be either a positive
    integer or the predefined constant NF90\_UNLIMITED.

`dimid`

:   Returned dimension ID.



## Errors

NF90\_DEF\_DIM returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The netCDF dataset is not in definition mode.
-   The specified dimension name is the name of another
    existing dimension.
-   The specified length is not greater than zero.
-   The specified length is unlimited, but there is already an unlimited
    length dimension defined for this netCDF dataset.
-   The specified netCDF ID does not refer to an open netCDF dataset.



## Example

Here is an example using NF90\_DEF\_DIM to create a dimension named lat
of length 18 and a unlimited dimension named rec in a new netCDF dataset
named foo.nc:


~~~~.fortran

 use netcdf
 implicit none
 integer :: ncid, status, LatDimID, RecordDimID
 ...
 status = nf90_create("foo.nc", nf90_noclobber, ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...
 status = nf90_def_dim(ncid, "Lat", 18, LatDimID)
 if (status /= nf90_noerr) call handle_err(status)
 status = nf90_def_dim(ncid, "Record", nf90_unlimited, RecordDimID)
 if (status /= nf90_noerr) call handle_err(status)

~~~~



4.3 NF90_INQ_DIMID {#f90-nf90_inq_dimid}
============



The function NF90\_INQ\_DIMID returns (as an argument) the ID of a
netCDF dimension, given the name of the dimension. If ndims is the
number of dimensions defined for a netCDF dataset, each dimension has an
ID between 1 and ndims.



## Usage


~~~~.fortran

 function nf90_inq_dimid(ncid, name, dimid)
   integer,             intent( in) :: ncid
   character (len = *), intent( in) :: name
   integer,             intent(out) :: dimid
   integer                          :: nf90_inq_dimid

~~~~



`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`name`

:   Dimension name.

`dimid`

:   Returned dimension ID.



## Errors

NF90\_INQ\_DIMID returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The name that was specified is not the name of a dimension in the
    netCDF dataset.
-   The specified netCDF ID does not refer to an open netCDF dataset.



## Example

Here is an example using NF90\_INQ\_DIMID to determine the dimension ID
of a dimension named lat, assumed to have been defined previously in an
existing netCDF dataset named foo.nc:


~~~~.fortran

 use netcdf
 implicit none
 integer :: ncid, status, LatDimID
 ...
 status = nf90_open("foo.nc", nf90_nowrite, ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...
 status = nf90_inq_dimid(ncid, "Lat", LatDimID)
 if (status /= nf90_noerr) call handle_err(status)

~~~~


4.4 NF90_INQUIRE_DIMENSION {#f90-nf90_inquire_dimension}
============



This function information about a netCDF dimension. Information about a
dimension includes its name and its length. The length for the unlimited
dimension, if any, is the number of records written so far.



## Usage


~~~~.fortran

 function nf90_inquire_dimension(ncid, dimid, name, len)
   integer,                       intent( in) :: ncid, dimid
   character (len = *), optional, intent(out) :: name
   integer,             optional, intent(out) :: len
   integer                                    :: nf90_inquire_dimension

~~~~



`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`dimid`

:   Dimension ID, from a previous call to NF90\_INQ\_DIMID
    or NF90\_DEF\_DIM.

`name`

:   Returned dimension name. The caller must allocate space for the
    returned name. The maximum possible length, in characters, of a
    dimension name is given by the predefined constant NF90\_MAX\_NAME.

`len`

:   Returned length of dimension. For the unlimited dimension, this is
    the current maximum value used for writing any variables with this
    dimension, that is the maximum record number.



## Errors

These functions return the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The dimension ID is invalid for the specified netCDF dataset.
-   The specified netCDF ID does not refer to an open netCDF dataset.



## Example

Here is an example using NF90\_INQ\_DIM to determine the length of a
dimension named lat, and the name and current maximum length of the
unlimited dimension for an existing netCDF dataset named foo.nc:


~~~~.fortran

 use netcdf
 implicit none
 integer :: ncid, status, LatDimID, RecordDimID
 integer :: nLats, nRecords
 character(len = nf90_max_name) :: RecordDimName
 ...
 status = nf90_open("foo.nc", nf90_nowrite, ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ! Get ID of unlimited dimension
 status = nf90_inquire(ncid, unlimitedDimId = RecordDimID)
 if (status /= nf90_noerr) call handle_err(status)
 ...
 status = nf90_inq_dimid(ncid, "Lat", LatDimID)
 if (status /= nf90_noerr) call handle_err(status)
 ! How many values of "lat" are there?
 status = nf90_inquire_dimension(ncid, LatDimID, len = nLats)
 if (status /= nf90_noerr) call handle_err(status)
 ! What is the name of the unlimited dimension, how many records are there?
 status = nf90_inquire_dimension(ncid, RecordDimID, &
                                 name = RecordDimName, len = Records)
 if (status /= nf90_noerr) call handle_err(status)

~~~~



4.5 NF90_RENAME_DIM {#f90-nf90_rename_dim}
============



The function NF90\_RENAME\_DIM renames an existing dimension in a netCDF
dataset open for writing. If the new name is longer than the old name,
the netCDF dataset must be in define mode. You cannot rename a dimension
to have the same name as another dimension.



## Usage


~~~~.fortran

 function nf90_rename_dim(ncid, dimid, name)
   integer,             intent( in) :: ncid
   character (len = *), intent( in) :: name
   integer,             intent( in) :: dimid
   integer                          :: nf90_rename_dim

~~~~



`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`dimid`

:   Dimension ID, from a previous call to NF90\_INQ\_DIMID
    or NF90\_DEF\_DIM.

`name`

:   New dimension name.



## Errors

NF90\_RENAME\_DIM returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The new name is the name of another dimension.
-   The dimension ID is invalid for the specified netCDF dataset.
-   The specified netCDF ID does not refer to an open netCDF dataset.
-   The new name is longer than the old name and the netCDF dataset is
    not in define mode.



## Example

Here is an example using NF90\_RENAME\_DIM to rename the dimension lat
to latitude in an existing netCDF dataset named foo.nc:


~~~~~~.fortran

use netcdf
implicit none
integer :: ncid, status, LatDimID
...
status = nf90_open("foo.nc", nf90_write, ncid)
if (status /= nf90_noerr) call handle_err(status)
...
! Put in define mode so we can rename the dimension
status = nf90_redef(ncid)
if (status /= nf90_noerr) call handle_err(status)
! Get the dimension ID for "Lat"...
status = nf90_inq_dimid(ncid, "Lat", LatDimID)
if (status /= nf90_noerr) call handle_err(status)
! ... and change the name to "Latitude".
status = nf90_rename_dim(ncid, LatDimID, "Latitude")
if (status /= nf90_noerr) call handle_err(status)
! Leave define mode
status = nf90_enddef(ncid)
if (status /= nf90_noerr) call handle_err(status)

~~~~~~
