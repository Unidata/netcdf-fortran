The NetCDF Fortran 90 Interface Guide {#f90_The-NetCDF-Fortran-90-Interface-Guide}
========================

[TOC]

This document describes the Fortran 90 interface to the netCDF library.

You can use the netCDF library without knowing about all of the netCDF
interface. If you are creating a netCDF dataset, only a handful of
routines are required to define the necessary dimensions, variables, and
attributes, and to write the data to the netCDF dataset. (Even less are
needed if you use the ncgen utility to create the dataset before running
a program using netCDF library calls to write data. See
[ncgen](netcdf.html#ncgen) in NetCDF Users Guide.) Similarly, if you are
writing software to access data stored in a particular netCDF object,
only a small subset of the netCDF library is required to open the netCDF
dataset and access the data. Authors of generic applications that access
arbitrary netCDF datasets need to be familiar with more of the netCDF
library.


* \subpage f90-use-of-the-netcdf-library
* \subpage f90_datasets



3 Groups {#f90-groups}
========



NetCDF-4 added support for hierarchical groups within netCDF datasets.

Groups are identified with a ncid, which identifies both the open file,
and the group within that file. When a file is opened with NF90\_OPEN or
NF90\_CREATE, the ncid for the root group of that file is provided.
Using that as a starting point, users can add new groups, or list and
navigate existing groups.

All netCDF calls take a ncid which determines where the call will take
its action. For example, the NF90\_DEF\_VAR function takes a ncid as its
first parameter. It will create a variable in whichever group its ncid
refers to. Use the root ncid provided by NF90\_CREATE or NF90\_OPEN to
create a variable in the root group. Or use NF90\_DEF\_GRP to create a
group and use its ncid to define a variable in the new group.

Variable are only visible in the group in which they are defined. The
same applies to attributes. “Global” attributes are defined in whichever
group is refered to by the ncid.

Dimensions are visible in their groups, and all child groups.

Group operations are only permitted on netCDF-4 files - that is, files
created with the HDF5 flag in nf90\_create. (see section
[NF90\_CREATE](#NF90_005fCREATE)). Groups are not compatible with the
netCDF classic data model, so files created with the
NF90\_CLASSIC\_MODEL file cannot contain groups (except the root group).


3.1 Find a Group ID: NF90_INQ_NCID {#f90-find-a-group-id-nf90_inq_ncid}
------------------------------------

Given an ncid and group name (NULL or "" gets root group), return ncid
of the named group.

### Usage




  function nf90_inq_ncid(ncid, name, grp_ncid)
    integer, intent(in) :: ncid
    character (len = *), intent(in) :: name
    integer, intent(out) :: grp_ncid
    integer :: nf90_inq_ncid




`NCID`

:   The group id for this operation.

`NAME`

:   A character array that holds the name of the desired group. Must be
    less then NF90\_MAX\_NAME.

`GRPID`

:   The ID of the group will go here.



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



### Example

This example is from nf90\_test/ftst\_groups.F.


3.2 Get a List of Groups in a Group: NF90_INQ_GRPS {#f90-get-a-list-of-groups-in-a-group-nf90_inq_grps}
----------------------------------------------------



Given a location id, return the number of groups it contains, and an
array of their ncids.



### Usage




  function nf90_inq_grps(ncid, numgrps, ncids)
    integer, intent(in) :: ncid
    integer, intent(out) :: numgrps
    integer, intent(out) :: ncids
    integer :: nf90_inq_grps




`NCID`

:   The group id for this operation.

`NUMGRPS`

:   An integer which will get number of groups in this group.

`NCIDS`

:   An array of ints which will receive the IDs of all the groups in
    this group.



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



### Example

3.3 Find all the Variables in a Group: NF90_INQ_VARIDS {#f90-find-all-the-variables-in-a-group-nf90_inq_varids}
--------------------------------------------------------

Find all varids for a location.



### Usage




  function nf90_inq_varids(ncid, nvars, varids)
    integer, intent(in) :: ncid
    integer, intent(out) :: nvars
    integer, intent(out) :: varids
    integer :: nf90_inq_varids




`NCID`

:   The group id for this operation.

`VARIDS`

:   An already allocated array to store the list of varids. Use
    nf90\_inq\_nvars to find out how many variables there are. (see
    section [Get Information about a Variable from Its ID:
    NF90\_INQUIRE\_VARIABLE](#NF90_005fINQUIRE_005fVARIABLE)).



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



### Example

3.4 Find all Dimensions Visible in a Group: NF90_INQ_DIMIDS {#f90-find-all-dimensions-visible-in-a-group-nf90_inq_dimids}
-------------------------------------------------------------



Find all dimids for a location. This finds all dimensions in a group, or
any of its parents.



### Usage




  function nf90_inq_dimids(ncid, ndims, dimids, include_parents)
    integer, intent(in) :: ncid
    integer, intent(out) :: ndims
    integer, intent(out) :: dimids
    integer, intent(out) :: include_parents
    integer :: nf90_inq_dimids




`NCID`

:   The group id for this operation.

`NDIMS`

:   Returned number of dimensions for this location. If include\_parents
    is non-zero, number of dimensions visible from this group, which
    includes dimensions in parent groups.

`DIMIDS`

:   An array of ints when the dimids of the visible dimensions will
    be stashed. Use nf90\_inq\_ndims to find out how many dims are
    visible from this group. (see section [Get Information about a
    Variable from Its ID:
    NF90\_INQUIRE\_VARIABLE](#NF90_005fINQUIRE_005fVARIABLE)).

`INCLUDE_PARENTS`

:   If zero, only the group specified by NCID will be searched
    for dimensions. Otherwise parent groups will be searched too.



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



### Example

3.5 Find the Length of a Group’s Full Name: NF90_INQ_GRPNAME_LEN {#f90-find-the-length-of-a-groups-full-name-nf90_inq_grpname_len}
-------------------------------------------------------------------

Given ncid, find length of the full name. (Root group is named "/", with
length 1.)

### Usage




  function nf90_inq_grpname_len(ncid, len)
    integer, intent(in) :: ncid
    integer, intent(out) :: len
    integer :: nf90_inq_grpname_len
  end function nf90_inq_grpname_len




`NCID`

:   The group id for this operation.

`LEN`

:   An integer where the length will be placed.



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



### Example


3.6 Find a Group’s Name: NF90_INQ_GRPNAME {#f90-find-a-groups-name-nf90_inq_grpname}
-------------------------------------------



Given ncid, find relative name of group. (Root group is named "/").

The name provided by this function is relative to the parent group. For
a full path name for the group is, with all parent groups included,
separated with a forward slash (as in Unix directory names) See section
[Find a Group’s Full Name:
NF90\_INQ\_GRPNAME\_FULL](#NF90_005fINQ_005fGRPNAME_005fFULL).



### Usage




  function nf90_inq_grpname(ncid, name)
    integer, intent(in) :: ncid
    character (len = *), intent(out) :: name
    integer :: nf90_inq_grpname




`NCID`

:   The group id for this operation.

`NAME`

:   The name of the group will be copied to this character array. The
    name will be less than NF90\_MAX\_NAME in length.



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



### Example


3.7 Find a Group’s Full Name: NF90_INQ_GRPNAME_FULL {#f90-find-a-groups-full-name-nf90_inq_grpname_full}
------------------------------------------------------



Given ncid, find complete name of group. (Root group is named "/").

The name provided by this function is a full path name for the group is,
with all parent groups included, separated with a forward slash (as in
Unix directory names). For a name relative to the parent group See
section [Find a Group’s Name:
NF90\_INQ\_GRPNAME](#NF90_005fINQ_005fGRPNAME).

To find the length of the full name See section [Find the Length of a
Group’s Full Name:
NF90\_INQ\_GRPNAME\_LEN](#NF90_005fINQ_005fGRPNAME_005fLEN).



### Usage




  function nf90_inq_grpname_full(ncid, len, name)
    integer, intent(in) :: ncid
    integer, intent(out) :: len
    character (len = *), intent(out) :: name
    integer :: nf90_inq_grpname_full




`NCID`

:   The group id for this operation.

`LEN`

:   The length of the full group name will go here.

`NAME`

:   The name of the group will be copied to this character array.



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



### Example

This example is from test program nf\_test/f90tst\_grps.f90.




  call check(nf90_inq_grpname_full(grpid1, len, name_in))
  if (name_in .ne. grp1_full_name) stop 62




3.8 Find a Group’s Parent: NF90_INQ_GRP_PARENT {#f90-find-a-groups-parent-nf90_inq_grp_parent}
-------------------------------------------------



Given ncid, find the ncid of the parent group.

When used with the root group, this function returns the NF90\_ENOGRP
error (since the root group h has no parent.)



### Usage




  function nf90_inq_grp_parent(ncid, parent_ncid)
    integer, intent(in) :: ncid
    integer, intent(out) :: parent_ncid
    integer :: nf90_inq_grp_parent




`NCID`

:   The group id.

`PARENT_NCID`

:   The ncid of the parent group will be copied here.



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENOGRP`

:   No parent group found (i.e. this is the root group).

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



### Example

3.9 Find a Group by Name: NF90_INQ_GRP_NCID {#f90-find-a-group-by-name-nf90_inq_grp_ncid}
----------------------------------------------

Given a group name an an ncid, find the ncid of the group id.

### Usage




  function nf90_inq_grp_ncid(ncid, name, grpid)
    integer, intent(in) :: ncid
    character (len = *), intent(in) :: name
    integer, intent(out) :: grpid
    integer :: nf90_inq_grp_ncid

    nf90_inq_grp_ncid = nf_inq_grp_ncid(ncid, name, grpid)
  end function nf90_inq_grp_ncid




`NCID`

:   The group id to look in.

`GRP_NAME`

:   The name of the group that should be found.

`GRP_NCID`

:   This will get the group id, if it is found.



### Return Codes


The following return codes may be returned by this function.

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_EINVAL`

:   No name provided or name longer than NF90\_MAX\_NAME.

`NF90_ENOGRP`

:   Named group not found.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



### Example

This example is from test program nf\_test/f90tst\_grps.f90.




  ! Get the group ids for the newly reopened file.
  call check(nf90_inq_grp_ncid(ncid, GRP1_NAME, grpid1))
  call check(nf90_inq_grp_ncid(grpid1, GRP2_NAME, grpid2))
  call check(nf90_inq_grp_ncid(grpid2, GRP3_NAME, grpid3))
  call check(nf90_inq_grp_ncid(grpid3, GRP4_NAME, grpid4))




3.10 Find a Group by its Fully-qualified Name: NF90_INQ_GRP_FULL_NCID {#f90-find-a-group-by-its-fully-qualified-name-nf90_inq_grp_full_ncid}
------------------------------------------
Given a fully qualified group name an an ncid, find the ncid of the
group id.



### Usage




  function nf90_inq_grpname_full(ncid, len, name)
    integer, intent(in) :: ncid
    integer, intent(out) :: len
    character (len = *), intent(out) :: name
    integer :: nf90_inq_grpname_full

    nf90_inq_grpname_full = nf_inq_grpname_full(ncid, len, name)
  end function nf90_inq_grpname_full




`NCID`

:   The group id to look in.

`FULL_NAME`

:   The fully-qualified group name.

`GRP_NCID`

:   This will get the group id, if it is found.



### Return Codes

The following return codes may be returned by this function.

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_EINVAL`

:   No name provided or name longer than NF90\_MAX\_NAME.

`NF90_ENOGRP`

:   Named group not found.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



### Example

This example is from test program nf\_test/tstf90\_grps.f90.




  ! Check for the groups with full group names.
  write(grp1_full_name, '(AA)') '/', GRP1_NAME
  call check(nf90_inq_grp_full_ncid(ncid, grp1_full_name, grpid1))




3.11 Create a New Group: NF90_DEF_GRP {#f90-create-a-new-group-nf90_def_grp}
---------------------------------------



Create a group. Its location id is returned in new\_ncid.



### Usage




  function nf90_def_grp(parent_ncid, name, new_ncid)
    integer, intent(in) :: parent_ncid
    character (len = *), intent(in) :: name
    integer, intent(out) :: new_ncid
    integer :: nf90_def_grp




`PARENT_NCID`

:   The group id of the parent group.

`NAME`

:   The name of the new group, which must be different from the name of
    any variable within the same parent group.

`NEW_NCID`

:   The ncid of the new group will be placed there.



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENAMEINUSE`

:   That name is in use. Group names must be unique within a group.

`NF90_EMAXNAME`

:   Name exceed max length NF90\_MAX\_NAME.

`NF90_EBADNAME`

:   Name contains illegal characters.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.

`NF90_EPERM`

:   Attempt to write to a read-only file.

`NF90_ENOTINDEFINE`

:   Not in define mode.



### Example




C     Create the netCDF file.
      retval = nf90_create(file_name, NF90_NETCDF4, ncid)
      if (retval .ne. nf90_noerr) call handle_err(retval)

C     Create a group and a subgroup.
      retval = nf90_def_grp(ncid, group_name, grpid)
      if (retval .ne. nf90_noerr) call handle_err(retval)
      retval = nf90_def_grp(grpid, sub_group_name, sub_grpid)
      if (retval .ne. nf90_noerr) call handle_err(retval)




4 Dimensions {#f90-dimensions}
============

4.1 Dimensions Introduction {#f90-dimensions-introduction}
---------------------------

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
------------------



The function NF90\_DEF\_DIM adds a new dimension to an open netCDF
dataset in define mode. It returns (as an argument) a dimension ID,
given the netCDF ID, the dimension name, and the dimension length. At
most one unlimited length dimension, called the record dimension, may be
defined for each netCDF dataset.



### Usage




 function nf90_def_dim(ncid, name, len, dimid)
   integer,             intent( in) :: ncid
   character (len = *), intent( in) :: name
   integer,             intent( in) :: len
   integer,             intent(out) :: dimid
   integer                          :: nf90_def_dim




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



### Errors

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



### Example

Here is an example using NF90\_DEF\_DIM to create a dimension named lat
of length 18 and a unlimited dimension named rec in a new netCDF dataset
named foo.nc:




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





4.3 NF90_INQ_DIMID {#f90-nf90_inq_dimid}
--------------------



The function NF90\_INQ\_DIMID returns (as an argument) the ID of a
netCDF dimension, given the name of the dimension. If ndims is the
number of dimensions defined for a netCDF dataset, each dimension has an
ID between 1 and ndims.



### Usage




 function nf90_inq_dimid(ncid, name, dimid)
   integer,             intent( in) :: ncid
   character (len = *), intent( in) :: name
   integer,             intent(out) :: dimid
   integer                          :: nf90_inq_dimid




`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`name`

:   Dimension name.

`dimid`

:   Returned dimension ID.



### Errors

NF90\_INQ\_DIMID returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The name that was specified is not the name of a dimension in the
    netCDF dataset.
-   The specified netCDF ID does not refer to an open netCDF dataset.



### Example

Here is an example using NF90\_INQ\_DIMID to determine the dimension ID
of a dimension named lat, assumed to have been defined previously in an
existing netCDF dataset named foo.nc:




 use netcdf
 implicit none
 integer :: ncid, status, LatDimID
 ...
 status = nf90_open("foo.nc", nf90_nowrite, ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...  
 status = nf90_inq_dimid(ncid, "Lat", LatDimID)
 if (status /= nf90_noerr) call handle_err(status)




4.4 NF90_INQUIRE_DIMENSION {#f90-nf90_inquire_dimension}
----------------------------



This function information about a netCDF dimension. Information about a
dimension includes its name and its length. The length for the unlimited
dimension, if any, is the number of records written so far.



### Usage




 function nf90_inquire_dimension(ncid, dimid, name, len)
   integer,                       intent( in) :: ncid, dimid
   character (len = *), optional, intent(out) :: name
   integer,             optional, intent(out) :: len
   integer                                    :: nf90_inquire_dimension




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



### Errors

These functions return the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The dimension ID is invalid for the specified netCDF dataset.
-   The specified netCDF ID does not refer to an open netCDF dataset.



### Example

Here is an example using NF90\_INQ\_DIM to determine the length of a
dimension named lat, and the name and current maximum length of the
unlimited dimension for an existing netCDF dataset named foo.nc:




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





4.5 NF90_RENAME_DIM {#f90-nf90_rename_dim}
---------------------



The function NF90\_RENAME\_DIM renames an existing dimension in a netCDF
dataset open for writing. If the new name is longer than the old name,
the netCDF dataset must be in define mode. You cannot rename a dimension
to have the same name as another dimension.



### Usage




 function nf90_rename_dim(ncid, dimid, name)
   integer,             intent( in) :: ncid
   character (len = *), intent( in) :: name
   integer,             intent( in) :: dimid
   integer                          :: nf90_rename_dim




`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`dimid`

:   Dimension ID, from a previous call to NF90\_INQ\_DIMID
    or NF90\_DEF\_DIM.

`name`

:   New dimension name.



### Errors

NF90\_RENAME\_DIM returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The new name is the name of another dimension.
-   The dimension ID is invalid for the specified netCDF dataset.
-   The specified netCDF ID does not refer to an open netCDF dataset.
-   The new name is longer than the old name and the netCDF dataset is
    not in define mode.



### Example

Here is an example using NF90\_RENAME\_DIM to rename the dimension lat
to latitude in an existing netCDF dataset named foo.nc:




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





5 User Defined Data Types {#f90-user-defined-data-types}
=========================

5.1 User Defined Types Introduction {#f90-user-defined-types-introduction}
-----------------------------------



NetCDF-4 has added support for four different user defined data types.

`compound type`

:   Like a C struct, a compound type is a collection of types, including
    other user defined types, in one package.

`variable length array type`

:   The variable length array may be used to store ragged arrays.

`opaque type`

:   This type has only a size per element, and no other
    type information.

`enum type`

:   Like an enumeration in C, this type lets you assign text values to
    integer values, and store the integer values.

Users may construct user defined type with the various NF90\_DEF\_\*
functions described in this section. They may learn about user defined
types by using the NF90\_INQ\_ functions defined in this section.

Once types are constructed, define variables of the new type with
NF90\_DEF\_VAR (see section [Create a Variable:
`NF90_DEF_VAR`](#NF90_005fDEF_005fVAR)). Write to them with
NF90\_PUT\_VAR (see section [Writing Data Values:
NF90\_PUT\_VAR](#NF90_005fPUT_005fVAR)). Read data of user-defined type
with NF90\_GET\_VAR (see section [Reading Data Values:
NF90\_GET\_VAR](#NF90_005fGET_005fVAR)).

Create attributes of the new type with NF90\_PUT\_ATT (see section
[Create an Attribute: NF90\_PUT\_ATT](#NF90_005fPUT_005fATT)). Read
attributes of the new type with NF90\_GET\_ATT (see section [Get
Attribute’s Values: NF90\_GET\_ATT](#NF90_005fGET_005fATT)).


5.2 Learn the IDs of All Types in Group: NF90_INQ_TYPEIDS {#f90-learn-the-ids-of-all-types-in-group-nf90_inq_typeids}
-----------------------------------------------------------



Learn the number of types defined in a group, and their IDs.



### Usage




  function nf90_inq_typeids(ncid, ntypes, typeids)
    integer, intent(in) :: ncid
    integer, intent(out) :: ntypes
    integer, intent(out) :: typeids
    integer :: nf90_inq_typeids




`NCID`

:   The group id.

`NTYPES`

:   A pointer to int which will get the number of types defined in
    the group. If NULL, ignored.

`TYPEIDS`

:   A pointer to an int array which will get the typeids. If
    NULL, ignored.



### Errors

`NF90_NOERR`

:   No error.

`NF90_BADID`

:   Bad ncid.



### Example


5.3 Find a Typeid from Group and Name: nf90_inq_typeid {#f90-find-a-typeid-from-group-and-name-nf90_inq_typeid}
--------------------------------------------------------



Given a group ID and a type name, find the ID of the type. If the type
is not found in the group, then the parents are searched. If still not
found, the entire file is searched.



### Usage




int nf90_inq_typeid(int ncid, char *name, nf90_type *typeidp);




`ncid`

:   The group id.

`name`

:   The name of a type.

`typeidp`

:   The typeid, if found.



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad ncid.

`NF90_EBADTYPE`

:   Can’t find type.



### Example


5.4 Learn About a User Defined Type: NF90_INQ_TYPE {#f90-learn-about-a-user-defined-type-nf90_inq_type}
----------------------------------------------------



Given an ncid and a typeid, get the information about a type. This
function will work on any type, including atomic and any user defined
type, whether compound, opaque, enumeration, or variable length array.

For even more information about a user defined type [Learn About a User
Defined Type: NF90\_INQ\_USER\_TYPE](#NF90_005fINQ_005fUSER_005fTYPE).



### Usage




  function nf90_inq_type(ncid, xtype, name, size)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(out) :: name
    integer, intent(out) :: size
    integer :: nf90_inq_type




`NCID`

:   The ncid for the group containing the type (ignored for
    atomic types).

`XTYPE`

:   The typeid for this type, as returned by NF90\_DEF\_COMPOUND,
    NF90\_DEF\_OPAQUE, NF90\_DEF\_ENUM, NF90\_DEF\_VLEN, or
    NF90\_INQ\_VAR, or as found in netcdf.inc in the list of atomic
    types (NF90\_CHAR, NF90\_INT, etc.).

`NAME`

:   The name of the user defined type will be copied here. It will be
    NF90\_MAX\_NAME bytes or less. For atomic types, the type name from
    CDL will be given.

`SIZEP`

:   The (in-memory) size of the type (in bytes) will be copied here.
    VLEN type size is the size of one element of the VLEN. String size
    is returned as the size of one char.



### Return Codes


`NF90_NOERR`

:   No error.

`NF90_EBADTYPEID`

:   Bad typeid.

`NF90_ENOTNC4`

:   Seeking a user-defined type in a netCDF-3 file.

`NF90_ESTRICTNC3`

:   Seeking a user-defined type in a netCDF-4 file for which classic
    model has been turned on.

`NF90_EBADGRPID`

:   Bad group ID in ncid.

`NF90_EBADID`

:   Type ID not found.

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



### Example


5.5 Learn About a User Defined Type: NF90_INQ_USER_TYPE {#f90-learn-about-a-user-defined-type-nf90_inq_user_type}
----------------------------------------------------------

Given an ncid and a typeid, get the information about a user defined
type. This function will work on any user defined type, whether
compound, opaque, enumeration, or variable length array.



### Usage




  function nf90_inq_user_type(ncid, xtype, name, size, base_typeid, nfields, class)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(out) :: name
    integer, intent(out) :: size
    integer, intent(out) :: base_typeid
    integer, intent(out) :: nfields
    integer, intent(out) :: class
    integer :: nf90_inq_user_type




`NCID`

:   The ncid for the group containing the user defined type.

`XTYPE`

:   The typeid for this type, as returned by NF90\_DEF\_COMPOUND,
    NF90\_DEF\_OPAQUE, NF90\_DEF\_ENUM, NF90\_DEF\_VLEN,
    or NF90\_INQ\_VAR.

`NAME`

:   The name of the user defined type will be copied here. It will be
    NF90\_MAX\_NAME bytes or less.

`SIZE`

:   The (in-memory) size of the user defined type will be copied here.

`BASE_NF90_TYPE`

:   The base typeid will be copied here for vlen and enum types.

`NFIELDS`

:   The number of fields will be copied here for enum and
    compound types.

`CLASS`

:   The class of the user defined type, NF90\_VLEN, NF90\_OPAQUE,
    NF90\_ENUM, or NF90\_COMPOUND, will be copied here.



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPEID`

:   Bad typeid.

`NF90_EBADFIELDID`

:   Bad fieldid.

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



### Example

### 5.5.1 Set a Variable Length Array with NF90_PUT_VLEN_ELEMENT {#f90-set-a-variable-length-array-with-nf90_put_vlen_element}



Use this to set the element of the (potentially) n-dimensional array of
VLEN. That is, this sets the data in one variable length array.



#### Usage




INTEGER FUNCTION NF90_PUT_VLEN_ELEMENT(INTEGER NCID, INTEGER XTYPE,
        CHARACTER*(*) VLEN_ELEMENT, INTEGER LEN, DATA)




`NCID`

:   The ncid of the file that contains the VLEN type.

`XTYPE`

:   The type of the VLEN.

`VLEN_ELEMENT`

:   The VLEN element to be set.

`LEN`

:   The number of entries in this array.

`DATA`

:   The data to be stored. Must match the base type of this VLEN.



#### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPE`

:   Can’t find the typeid.

`NF90_EBADID`

:   ncid invalid.

`NF90_EBADGRPID`

:   Group ID part of ncid was invalid.



#### Example

This example is from nf90\_test/ftst\_vars4.F.




C     Set up the vlen with this helper function, since F90 can't deal
C     with pointers.
      retval = nf90_put_vlen_element(ncid, vlen_typeid, vlen,
     &     vlen_len, data1)
      if (retval .ne. nf90_noerr) call handle_err(retval)





### 5.5.2 Set a Variable Length Array with NF90_GET_VLEN_ELEMENT {#f90-set-a-variable-length-array-with-nf90_get_vlen_element}



Use this to set the element of the (potentially) n-dimensional array of
VLEN. That is, this sets the data in one variable length array.



#### Usage




INTEGER FUNCTION NF90_GET_VLEN_ELEMENT(INTEGER NCID, INTEGER XTYPE,
        CHARACTER*(*) VLEN_ELEMENT, INTEGER LEN, DATA)




`NCID`

:   The ncid of the file that contains the VLEN type.

`XTYPE`

:   The type of the VLEN.

`VLEN_ELEMENT`

:   The VLEN element to be set.

`LEN`

:   This will be set to the number of entries in this array.

`DATA`

:   The data will be copied here. Sufficient storage must be available
    or bad things will happen to you.



#### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPE`

:   Can’t find the typeid.

`NF90_EBADID`

:   ncid invalid.

`NF90_EBADGRPID`

:   Group ID part of ncid was invalid.



#### Example


5.6 Compound Types Introduction {#f90-compound-types-introduction}
-------------------------------



NetCDF-4 added support for compound types, which allow users to
construct a new type - a combination of other types, like a C struct.

Compound types are not supported in classic or 64-bit offset format
files.

To write data in a compound type, first use nf90\_def\_compound to
create the type, multiple calls to nf90\_insert\_compound to add to the
compound type, and then write data with the appropriate nf90\_put\_var1,
nf90\_put\_vara, nf90\_put\_vars, or nf90\_put\_varm call.

To read data written in a compound type, you must know its structure.
Use the NF90\_INQ\_COMPOUND functions to learn about the compound type.

In Fortran a character buffer must be used for the compound data. The
user must read the data from within that buffer in the same way that the
C compiler which compiled netCDF would store the structure.

The use of compound types introduces challenges and portability issues
for Fortran users.

### 5.6.1 Creating a Compound Type: NF90_DEF_COMPOUND {#f90-creating-a-compound-type-nf90_def_compound}



Create a compound type. Provide an ncid, a name, and a total size (in
bytes) of one element of the completed compound type.

After calling this function, fill out the type with repeated calls to
NF90\_INSERT\_COMPOUND (see section [Inserting a Field into a Compound
Type: NF90\_INSERT\_COMPOUND](#NF90_005fINSERT_005fCOMPOUND)). Call
NF90\_INSERT\_COMPOUND once for each field you wish to insert into the
compound type.

Note that there does not seem to be a fully portable way to read such
types into structures in Fortran 90 (and there are no structures in
Fortran 77). Dozens of top-notch programmers are swarming over this
problem in a sub-basement of Unidata’s giant underground bunker in
Wyoming.

Fortran users may use character buffers to read and write compound
types. User are invited to try classic Fortran features such as the
equivilence and the common block statment.



### Usage




  function nf90_def_compound(ncid, size, name, typeid)
    integer, intent(in) :: ncid
    integer, intent(in) :: size
    character (len = *), intent(in) :: name
    integer, intent(out) :: typeid
    integer :: nf90_def_compound




`NCID`

:   The groupid where this compound type will be created.

`SIZE`

:   The size, in bytes, of the compound type.

`NAME`

:   The name of the new compound type.

`TYPEIDP`

:   The typeid of the new type will be placed here.



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENAMEINUSE`

:   That name is in use. Compound type names must be unique in the
    data file.

`NF90_EMAXNAME`

:   Name exceeds max length NF90\_MAX\_NAME.

`NF90_EBADNAME`

:   Name contains illegal characters.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag NF90\_NETCDF4. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.

`NF90_EPERM`

:   Attempt to write to a read-only file.

`NF90_ENOTINDEFINE`

:   Not in define mode.



### Example

### 5.6.2 Inserting a Field into a Compound Type: NF90_INSERT_COMPOUND {#f90-inserting-a-field-into-a-compound-type-nf90_insert_compound}



Insert a named field into a compound type.



#### Usage




  function nf90_insert_compound(ncid, xtype, name, offset, field_typeid)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(in) :: name
    integer, intent(in) :: offset
    integer, intent(in) :: field_typeid
    integer :: nf90_insert_compound




`TYPEID`

:   The typeid for this compound type, as returned by
    NF90\_DEF\_COMPOUND, or NF90\_INQ\_VAR.

`NAME`

:   The name of the new field.

`OFFSET`

:   Offset in byte from the beginning of the compound type for
    this field.

`FIELD_TYPEID`

:   The type of the field to be inserted.



#### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENAMEINUSE`

:   That name is in use. Field names must be unique within a
    compound type.

`NF90_EMAXNAME`

:   Name exceed max length NF90\_MAX\_NAME.

`NF90_EBADNAME`

:   Name contains illegal characters.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag NF90\_NETCDF4. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.

`NF90_ENOTINDEFINE`

:   Not in define mode.



#### Example





### 5.6.3 Inserting an Array Field into a Compound Type: NF90_INSERT_ARRAY_COMPOUND {#f90-inserting-an-array-field-into-a-compound-type-nf90_insert_array_compound}



Insert a named array field into a compound type.



#### Usage




  function nf90_insert_array_compound(ncid, xtype, name, offset, field_typeid, &
       ndims, dim_sizes)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(in) :: name
    integer, intent(in) :: offset
    integer, intent(in) :: field_typeid
    integer, intent(in) :: ndims
    integer, intent(in) :: dim_sizes
    integer :: nf90_insert_array_compound




`NCID`

:   The ID of the file that contains the array type and the
    compound type.

`XTYPE`

:   The typeid for this compound type, as returned by
    nf90\_def\_compound, or nf90\_inq\_var.

`NAME`

:   The name of the new field.

`OFFSET`

:   Offset in byte from the beginning of the compound type for
    this field.

`FIELD_TYPEID`

:   The base type of the array to be inserted.

`NDIMS`

:   The number of dimensions for the array to be inserted.

`DIM_SIZES`

:   An array containing the sizes of each dimension.



#### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENAMEINUSE`

:   That name is in use. Field names must be unique within a
    compound type.

`NF90_EMAXNAME`

:   Name exceed max length NF90\_MAX\_NAME.

`NF90_EBADNAME`

:   Name contains illegal characters.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag NF90\_NETCDF4. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.

`NF90_ENOTINDEFINE`

:   Not in define mode.

`NF90_ETYPEDEFINED`

:   Attempt to change type that has already been committed. The first
    time the file leaves define mode, all defined types are committed,
    and can’t be changed. If you wish to add an array to a compound
    type, you must do so before the compound type is committed.



#### Example

### 5.6.4 Learn About a Compound Type: NF90_INQ_COMPOUND {#f90-learn-about-a-compound-type-nf90_inq_compound}



Get the number of fields, length in bytes, and name of a compound type.

In addtion to the NF90\_INQ\_COMPOUND function, three additional
functions are provided which get only the name, size, and number of
fields.



#### Usage




  function nf90_inq_compound(ncid, xtype, name, size, nfields)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(out) :: name
    integer, intent(out) :: size
    integer, intent(out) :: nfields
    integer :: nf90_inq_compound

  function nf90_inq_compound_name(ncid, xtype, name)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(out) :: name
    integer :: nf90_inq_compound_name

  function nf90_inq_compound_size(ncid, xtype, size)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    integer, intent(out) :: size
    integer :: nf90_inq_compound_size

  function nf90_inq_compound_nfields(ncid, xtype, nfields)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    integer, intent(out) :: nfields
    integer :: nf90_inq_compound_nfields




`NCID`

:   The ID of any group in the file that contains the compound type.

`XTYPE`

:   The typeid for this compound type, as returned by
    NF90\_DEF\_COMPOUND, or NF90\_INQ\_VAR.

`NAME`

:   Character array which will get the name of the compound type. It
    will have a maximum length of NF90\_MAX\_NAME.

`SIZEP`

:   The size of the compound type in bytes will be put here.

`NFIELDSP`

:   The number of fields in the compound type will be placed here.



#### Return Codes

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Couldn’t find this ncid.

`NF90_ENOTNC4`

:   Not a netCDF-4/HDF5 file.

`NF90_ESTRICTNC3`

:   A netCDF-4/HDF5 file, but with CLASSIC\_MODEL. No user defined types
    are allowed in the classic model.

`NF90_EBADTYPE`

:   This type not a compound type.

`NF90_EBADTYPEID`

:   Bad type id.

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



#### Example

### 5.6.5 Learn About a Field of a Compound Type: NF90_INQ_COMPOUND_FIELD {#f90-learn-about-a-field-of-a-compound-type-nf90_inq_compound_field}



Get information about one of the fields of a compound type.



#### Usage




  function nf90_inq_compound_field(ncid, xtype, fieldid, name, offset, &
       field_typeid, ndims, dim_sizes)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    integer, intent(in) :: fieldid
    character (len = *), intent(out) :: name
    integer, intent(out) :: offset
    integer, intent(out) :: field_typeid
    integer, intent(out) :: ndims
    integer, intent(out) :: dim_sizes
    integer :: nf90_inq_compound_field

  function nf90_inq_compound_fieldname(ncid, xtype, fieldid, name)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    integer, intent(in) :: fieldid
    character (len = *), intent(out) :: name
    integer :: nf90_inq_compound_fieldname

  function nf90_inq_compound_fieldindex(ncid, xtype, name, fieldid)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(in) :: name
    integer, intent(out) :: fieldid
    integer :: nf90_inq_compound_fieldindex

  function nf90_inq_compound_fieldoffset(ncid, xtype, fieldid, offset)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    integer, intent(in) :: fieldid
    integer, intent(out) :: offset
    integer :: nf90_inq_compound_fieldoffset

  function nf90_inq_compound_fieldtype(ncid, xtype, fieldid, field_typeid)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    integer, intent(in) :: fieldid
    integer, intent(out) :: field_typeid
    integer :: nf90_inq_compound_fieldtype

  function nf90_inq_compound_fieldndims(ncid, xtype, fieldid, ndims)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    integer, intent(in) :: fieldid
    integer, intent(out) :: ndims
    integer :: nf90_inq_compound_fieldndims

  function nf90_inq_cmp_fielddim_sizes(ncid, xtype, fieldid, dim_sizes)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    integer, intent(in) :: fieldid
    integer, intent(out) :: dim_sizes
    integer :: nf90_inq_cmp_fielddim_sizes




`NCID`

:   The groupid where this compound type exists.

`XTYPE`

:   The typeid for this compound type, as returned by
    NF90\_DEF\_COMPOUND, or NF90\_INQ\_VAR.

`FIELDID`

:   A one-based index number specifying a field in the compound type.

`NAME`

:   A character array which will get the name of the field. The name
    will be NF90\_MAX\_NAME characters, at most.

`OFFSETP`

:   An integer which will get the offset of the field.

`FIELD_TYPEID`

:   An integer which will get the typeid of the field.

`NDIMSP`

:   An integer which will get the number of dimensions of the field.

`DIM_SIZESP`

:   An integer array which will get the dimension sizes of the field.



#### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPEID`

:   Bad type id.

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



#### Example

5.7 Variable Length Array Introduction {#f90-variable-length-array-introduction}
--------------------------------------



NetCDF-4 added support for a variable length array type. This is not
supported in classic or 64-bit offset files, or in netCDF-4 files which
were created with the NF90\_CLASSIC\_MODEL flag.

A variable length array is represented in C as a structure from HDF5,
the nf90\_vlen\_t structure. It contains a len member, which contains
the length of that array, and a pointer to the array.

So an array of VLEN in C is an array of nc\_vlen\_t structures. The only
way to handle this in Fortran is with a character buffer sized correctly
for the platform.

VLEN arrays are handled differently with respect to allocation of
memory. Generally, when reading data, it is up to the user to malloc
(and subsequently free) the memory needed to hold the data. It is up to
the user to ensure that enough memory is allocated.

With VLENs, this is impossible. The user cannot know the size of an
array of VLEN until after reading the array. Therefore when reading VLEN
arrays, the netCDF library will allocate the memory for the data within
each VLEN.

It is up to the user, however, to eventually free this memory. This is
not just a matter of one call to free, with the pointer to the array of
VLENs; each VLEN contains a pointer which must be freed.

Compression is permitted but may not be effective for VLEN data, because
the compression is applied to the nc\_vlen\_t structures, rather than
the actual data.

  ------------------------------------- ---- --
  [5.7.1 Define a Variable Length Array (VLEN): NF90\_DEF\_VLEN](#NF90_005fDEF_005fVLEN)                             
  [5.7.2 Learning about a Variable Length Array (VLEN) Type: NF90\_INQ\_VLEN](#NF90_005fINQ_005fVLEN)                
  [5.7.3 Releasing Memory for a Variable Length Array (VLEN) Type: NF90\_FREE\_VLEN](#NF90_005fFREE_005fVLEN)        
  ------------------------------------- ---- --


### 5.7.1 Define a Variable Length Array (VLEN): NF90_DEF_VLEN {#f90-define-a-variable-length-array-vlen-nf90_def_vlen}



Use this function to define a variable length array type.



#### Usage




  function nf90_def_vlen(ncid, name, base_typeid, xtypeid)
    integer, intent(in) :: ncid
    character (len = *), intent(in) :: name
    integer, intent(in) :: base_typeid
    integer, intent(out) :: xtypeid
    integer :: nf90_def_vlen




`NCID`

:   The ncid of the file to create the VLEN type in.

`NAME`

:   A name for the VLEN type.

`BASE_TYPEID`

:   The typeid of the base type of the VLEN. For example, for a VLEN of
    shorts, the base type is NF90\_SHORT. This can be a user
    defined type.

`XTYPEP`

:   The typeid of the new VLEN type will be set here.



#### Errors

`NF90_NOERR`

:   No error.

`NF90_EMAXNAME`

:   NF90\_MAX\_NAME exceeded.

`NF90_ENAMEINUSE`

:   Name is already in use.

`NF90_EBADNAME`

:   Attribute or variable name contains illegal characters.

`NF90_EBADID`

:   ncid invalid.

`NF90_EBADGRPID`

:   Group ID part of ncid was invalid.

`NF90_EINVAL`

:   Size is invalid.

`NF90_ENOMEM`

:   Out of memory.



#### Example

### 5.7.2 Learning about a Variable Length Array (VLEN) Type: NF90_INQ_VLEN {#f90-learning-about-a-variable-length-array-vlen-type-nf90_inq_vlen}



Use this type to learn about a vlen.



#### Usage




  function nf90_inq_vlen(ncid, xtype, name, datum_size, base_nc_type)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(out) :: name
    integer, intent(out) :: datum_size
    integer, intent(out) :: base_nc_type
    integer :: nf90_inq_vlen




`NCID`

:   The ncid of the file that contains the VLEN type.

`XTYPE`

:   The type of the VLEN to inquire about.

`NAME`

:   The name of the VLEN type. The name will be NF90\_MAX\_NAME
    characters or less.

`DATUM_SIZEP`

:   A pointer to a size\_t, this will get the size of one element of
    this vlen.

`BASE_NF90_TYPEP`

:   An integer that will get the type of the VLEN base type. (In other
    words, what type is this a VLEN of?)



#### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPE`

:   Can’t find the typeid.

`NF90_EBADID`

:   ncid invalid.

`NF90_EBADGRPID`

:   Group ID part of ncid was invalid.



#### Example


### 5.7.3 Releasing Memory for a Variable Length Array (VLEN) Type: NF90_FREE_VLEN {#f90-releasing-memory-for-a-variable-length-array-vlen-type-nf90_free_vlen}



When a VLEN is read into user memory from the file, the HDF5 library
performs memory allocations for each of the variable length arrays
contained within the VLEN structure. This memory must be freed by the
user to avoid memory leaks.

This violates the normal netCDF expectation that the user is responsible
for all memory allocation. But, with VLEN arrays, the underlying HDF5
library allocates the memory for the user, and the user is responsible
for deallocating that memory.



#### Usage




  function nf90_free_vlen(vl)
    character (len = *), intent(in) :: vlen
    integer :: nf90_free_vlen
  end function nf90_free_vlen




`VL`

:   The variable length array structure which is to be freed.



#### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPE`

:   Can’t find the typeid.



#### Example


5.8 Opaque Type Introduction {#f90-opaque-type-introduction}
----------------------------



NetCDF-4 added support for the opaque type. This is not supported in
classic or 64-bit offset files.

The opaque type is a type which is a collection of objects of a known
size. (And each object is the same size). Nothing is known to netCDF
about the contents of these blobs of data, except their size in bytes,
and the name of the type.

To use an opaque type, first define it with [Creating Opaque Types:
NF90\_DEF\_OPAQUE](#NF90_005fDEF_005fOPAQUE). If encountering an enum
type in a new data file, use [Learn About an Opaque Type:
NF90\_INQ\_OPAQUE](#NF90_005fINQ_005fOPAQUE) to learn its name and size.

#### 5.8.1 Creating Opaque Types: NF90_DEF_OPAQUE {#f90-creating-opaque-types-nf90_def_opaque}



Create an opaque type. Provide a size and a name.



#### Usage




  function nf90_def_opaque(ncid, size, name, xtype)
    integer, intent(in) :: ncid
    integer, intent(in) :: size
    character (len = *), intent(in) :: name
    integer, intent(out) :: xtype
    integer :: nf90_def_opaque




`NCID`

:   The groupid where the type will be created. The type may be used
    anywhere in the file, no matter what group it is in.

`NAME`

:   The name for this type. Must be shorter than NF90\_MAX\_NAME.

`SIZE`

:   The size of each opaque object.

`TYPEIDP`

:   Pointer where the new typeid for this type is returned. Use this
    typeid when defining variables of this type with [Create a Variable:
    `NF90_DEF_VAR`](#NF90_005fDEF_005fVAR).



#### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPEID`

:   Bad typeid.

`NF90_EBADFIELDID`

:   Bad fieldid.

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



#### Example

### 5.8.2 Learn About an Opaque Type: NF90_INQ_OPAQUE {#f90-learn-about-an-opaque-type-nf90_inq_opaque}



Given a typeid, get the information about an opaque type.



#### Usage




  function nf90_inq_opaque(ncid, xtype, name, size)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(out) :: name
    integer, intent(out) :: size
    integer :: nf90_inq_opaque




`NCID`

:   The ncid for the group containing the opaque type.

`XTYPE`

:   The typeid for this opaque type, as returned by NF90\_DEF\_COMPOUND,
    or NF90\_INQ\_VAR.

`NAME`

:   The name of the opaque type will be copied here. It will be
    NF90\_MAX\_NAME bytes or less.

`SIZEP`

:   The size of the opaque type will be copied here.



#### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPEID`

:   Bad typeid.

`NF90_EBADFIELDID`

:   Bad fieldid.

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



#### Example

5.9 Enum Type Introduction {#f90-enum-type-introduction}
--------------------------



NetCDF-4 added support for the enum type. This is not supported in
classic or 64-bit offset files.


### 5.9.1 Creating a Enum Type: NF90_DEF_ENUM {#f90-creating-a-enum-type-nf90_def_enum}



Create an enum type. Provide an ncid, a name, and a base integer type.

After calling this function, fill out the type with repeated calls to
NF90\_INSERT\_ENUM (see section [Inserting a Field into a Enum Type:
NF90\_INSERT\_ENUM](#NF90_005fINSERT_005fENUM)). Call NF90\_INSERT\_ENUM
once for each value you wish to make part of the enumeration.



#### Usage




  function nf90_def_enum(ncid, base_typeid, name, typeid)
    integer, intent(in) :: ncid
    integer, intent(in) :: base_typeid
    character (len = *), intent(in) :: name
    integer, intent(out) :: typeid
    integer :: nf90_def_enum




`NCID`

:   The groupid where this compound type will be created.

`BASE_TYPEID`

:   The base integer type for this enum. Must be one of: NF90\_BYTE,
    NF90\_UBYTE, NF90\_SHORT, NF90\_USHORT, NF90\_INT, NF90\_UINT,
    NF90\_INT64, NF90\_UINT64.

`NAME`

:   The name of the new enum type.

`TYPEIDP`

:   The typeid of the new type will be placed here.



#### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENAMEINUSE`

:   That name is in use. Compound type names must be unique in the
    data file.

`NF90_EMAXNAME`

:   Name exceeds max length NF90\_MAX\_NAME.

`NF90_EBADNAME`

:   Name contains illegal characters.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag NF90\_NETCDF4. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.

`NF90_EPERM`

:   Attempt to write to a read-only file.

`NF90_ENOTINDEFINE`

:   Not in define mode.



#### Example



### 5.9.2 Inserting a Field into a Enum Type: NF90_INSERT_ENUM {#f90-inserting-a-field-into-a-enum-type-nf90_insert_enum}



Insert a named member into a enum type.



#### Usage




  function nf90_insert_enum(ncid, xtype, name, value)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(in) :: name
    integer, intent(in) :: value
    integer :: nf90_insert_enum




`NCID`

:   The ncid of the group which contains the type.

`TYPEID`

:   The typeid for this enum type, as returned by nf90\_def\_enum,
    or nf90\_inq\_var.

`IDENTIFIER`

:   The identifier of the new member.

`VALUE`

:   The value that is to be associated with this member.



#### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENAMEINUSE`

:   That name is in use. Field names must be unique within a enum type.

`NF90_EMAXNAME`

:   Name exceed max length NF90\_MAX\_NAME.

`NF90_EBADNAME`

:   Name contains illegal characters.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag NF90\_NETCDF4. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90\_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.

`NF90_ENOTINDEFINE`

:   Not in define mode.



#### Example

### 5.9.3 Learn About a Enum Type: NF90_INQ_ENUM {#f90-learn-about-a-enum-type-nf90_inq_enum}



Get information about a user-defined enumeration type.



#### Usage




  function nf90_inq_enum(ncid, xtype, name, base_nc_type, base_size, num_members)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(out) :: name
    integer, intent(out) :: base_nc_type
    integer, intent(out) :: base_size
    integer, intent(out) :: num_members
    integer :: nf90_inq_enum




`NCID`

:   The group ID of the group which holds the enum type.

`XTYPE`

:   The typeid for this enum type, as returned by NF90\_DEF\_ENUM,
    or NF90\_INQ\_VAR.

`NAME`

:   Character array which will get the name. It will have a maximum
    length of NF90\_MAX\_NAME.

`BASE_NF90_TYPE`

:   An integer which will get the base integer type of this enum.

`BASE_SIZE`

:   An integer which will get the size (in bytes) of the base integer
    type of this enum.

`NUM_MEMBERS`

:   An integer which will get the number of members defined for this
    enumeration type.



#### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPEID`

:   Bad type id.

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



#### Example


### 5.9.4 Learn the Name of a Enum Type: nf90_inq_enum_member {#f90-learn-the-name-of-a-enum-type-nf90_inq_enum_member}



Get information about a member of an enum type.



#### Usage




  function nf90_inq_enum_member(ncid, xtype, idx, name, value)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    integer, intent(in) :: idx
    character (len = *), intent(out) :: name
    integer, intent(in) :: value
    integer :: nf90_inq_enum_member




`NCID`

:   The groupid where this enum type exists.

`XTYPE`

:   The typeid for this enum type.

`IDX`

:   The one-based index number for the member of interest.

`NAME`

:   A character array which will get the name of the member. It will
    have a maximum length of NF90\_MAX\_NAME.

`VALUE`

:   An integer that will get the value associated with this member.



#### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPEID`

:   Bad type id.

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



#### Example



### 5.9.5 Learn the Name of a Enum Type: NF90_INQ_ENUM_IDENT {#f90-learn-the-name-of-a-enum-type-nf90_inq_enum_ident}



Get the name which is associated with an enum member value.

This is similar to NF90\_INQ\_ENUM\_MEMBER, but instead of using the
index of the member, you use the value of the member.



#### Usage




  function nf90_inq_enum_ident(ncid, xtype, value, idx)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    integer, intent(in) :: value
    integer, intent(out) :: idx
    integer :: nf90_inq_enum_ident




`NCID`

:   The groupid where this enum type exists.

`XTYPE`

:   The typeid for this enum type.

`VALUE`

:   The value for which an identifier is sought.

`IDENTIFIER`

:   A character array that will get the identifier. It will have a
    maximum length of NF90\_MAX\_NAME.



Return Code {#f90-return-code}
-----------

`NF90_NOERR`

:   No error.

`NF90_EBADTYPEID`

:   Bad type id, or not an enum type.

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.

`NF90_EINVAL`

:   The value was not found in the enum.



#### Example


6 Variables {#f90-variables}
===========

6.1 Variables Introduction {#f90-variables-introduction}
--------------------------

Variables for a netCDF dataset are defined when the dataset is created,
while the netCDF dataset is in define mode. Other variables may be added
later by reentering define mode. A netCDF variable has a name, a type,
and a shape, which are specified when it is defined. A variable may also
have values, which are established later in data mode.

Ordinarily, the name, type, and shape are fixed when the variable is
first defined. The name may be changed, but the type and shape of a
variable cannot be changed. However, a variable defined in terms of the
unlimited dimension can grow without bound in that dimension.

A netCDF variable in an open netCDF dataset is referred to by a small
integer called a variable ID.

Variable IDs reflect the order in which variables were defined within a
netCDF dataset. Variable IDs are 1, 2, 3,..., in the order in which the
variables were defined. A function is available for getting the variable
ID from the variable name and vice-versa.

Attributes (see [Attributes](#Attributes)) may be associated with a
variable to specify such properties as units.

Operations supported on variables are:

-   Create a variable, given its name, data type, and shape.
-   Get a variable ID from its name.
-   Get a variable’s name, data type, shape, and number of attributes
    from its ID.
-   Put a data value into a variable, given variable ID, indices,
    and value.
-   Put an array of values into a variable, given variable ID, corner
    indices, edge lengths, and a block of values.
-   Put a subsampled or mapped array-section of values into a variable,
    given variable ID, corner indices, edge lengths, stride vector,
    index mapping vector, and a block of values.
-   Get a data value from a variable, given variable ID and indices.
-   Get an array of values from a variable, given variable ID, corner
    indices, and edge lengths.
-   Get a subsampled or mapped array-section of values from a variable,
    given variable ID, corner indices, edge lengths, stride vector, and
    index mapping vector.
-   Rename a variable.


6.2 Language Types Corresponding to netCDF external data types {#f90-language-types-corresponding-to-netcdf-external-data-types}
--------------------------------------------------------------

The following table gives the netCDF external data types and the
corresponding type constants for defining variables in the FORTRAN
interface:

  -------- ---------------------- ------
  Type     FORTRAN API Mnemonic   Bits
  byte     NF90\_BYTE             8
  char     NF90\_CHAR             8
  short    NF90\_SHORT            16
  int      NF90\_INT              32
  float    NF90\_FLOAT            32
  double   NF90\_DOUBLE           64
  -------- ---------------------- ------

The first column gives the netCDF external data type, which is the same
as the CDL data type. The next column gives the corresponding Fortran 90
parameter for use in netCDF functions (the parameters are defined in the
netCDF Fortran 90 module netcdf.f90). The last column gives the number
of bits used in the external representation of values of the
corresponding type.

Note that there are no netCDF types corresponding to 64-bit integers or
to characters wider than 8 bits in the current version of the netCDF
library.


6.3 Create a Variable: `NF90_DEF_VAR` {#f90-create-a-variable-nf90_def_var}
-------------------------------------



The function NF90\_DEF\_VAR adds a new variable to an open netCDF
dataset in define mode. It returns (as an argument) a variable ID, given
the netCDF ID, the variable name, the variable type, the number of
dimensions, and a list of the dimension IDs.

Optional arguments allow additional settings for variables in
netCDF-4/HDF5 files. These parameters allow data compression and control
of the layout of the data on disk for performance tuning. These
parameters may also be used to set the chunk sizes to get chunked
storage, or to set the contiguous flag to get contiguous storage.

Variables that make use of one or more unlimited dimensions,
compression, or checksums must use chunking. Such variables are created
with default chunk sizes of 1 for each unlimited dimension and the
dimension length for other dimensions, except that if the resulting
chunks are too large, the default chunk sizes for non-record dimensions
are reduced.

All parameters after the varid are optional, and only supported if
netCDF was built with netCDF-4 features enabled, and if the variable is
in a netCDF-4/HDF5 file.



### Usage




 function nf90_def_var(ncid, name, xtype, dimids, varid, contiguous, &
       chunksizes, deflate_level, shuffle, fletcher32, endianness, &
       cache_size, cache_nelems, cache_preemption)
   integer, intent(in) :: ncid
   character (len = *), intent(in) :: name
   integer, intent( in) :: xtype
   integer, scalar or dimension(:), intent(in), optional :: dimids
   integer, intent(out) :: varid
   logical, optional, intent(in) :: contiguous
   integer, optional, dimension(:), intent(in) :: chunksizes
   integer, optional, intent(in) :: deflate_level
   logical, optional, intent(in) :: shuffle, fletcher32
   integer, optional, intent(in) :: endianness
    integer, optional, intent(in) :: cache_size, cache_nelems, cache_preemption
   integer                                      :: nf90_def_var




`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`name`

:   Variable name.

`xtype`

:   One of the set of predefined netCDF external data types. The type of
    this parameter, NF90\_TYPE, is defined in the netCDF header file.
    The valid netCDF external data types are NF90\_BYTE, NF90\_CHAR,
    NF90\_SHORT, NF90\_INT, NF90\_FLOAT, and NF90\_DOUBLE. If the file
    is a NetCDF-4/HDF5 file, the additional types NF90\_UBYTE,
    NF90\_USHORT, NF90\_UINT, NF90\_INT64, NF90\_UINT64, and
    NF90\_STRING may be used, as well as a user defined type ID.

`dimids`

:   Scalar or vector of dimension IDs corresponding to the
    variable dimensions. For example, a vector of 2 dimension IDs
    specifies a 2-dimensional matrix.

    If an integer is passed for this parameter, a 1-D variable
    is created.

    If this parameter is not passed (or is a 1D array of size zero) it
    means the variable is a scalar with no dimensions.

    For classic data model files, if the ID of the unlimited dimension
    is included, it must be first. In expanded model netCDF4/HDF5 files,
    there may be any number of unlimited dimensions, and they may be
    used in any element of the dimids array.

    This argument is optional, and if absent specifies a scalar with
    no dimensions.

`varid`

:   Returned variable ID.

`storage`

:   If NF90\_CONTIGUOUS, then contiguous storage is used for
    this variable. Variables that use deflation, shuffle filter, or
    checksums, or that have one or more unlimited dimensions cannot use
    contiguous storage.

    If NF90\_CHUNKED, then chunked storage is used for this variable.
    Chunk sizes may be specified with the chunksizes parameter. Default
    sizes will be used if chunking is required and this function is
    not called.

    By default contiguous storage is used for fix-sized variables when
    conpression, chunking, shuffle, and checksums are not used.

`chunksizes`

:   An array of chunk number of elements. This array has the number of
    elements along each dimension of the data chunk. The array must have
    the one chunksize for each dimension in the variable.

    The total size of a chunk must be less than 4 GiB. That is, the
    product of all chunksizes and the size of the data (or the size of
    nc\_vlen\_t for VLEN types) must be less than 4 GiB. (This is a very
    large chunk size in any case.)

    If not provided, but chunked data are needed, then default
    chunksizes will be chosen. For more information see [{No value for
    ‘n-man’}](netcdf.html#Chunking) in {No value for ‘n-man’}.

`shuffle`

:   If non-zero, turn on the shuffle filter.

`deflate_level`

:   If the deflate parameter is non-zero, set the deflate level to
    this value. Must be between 1 and 9.

`fletcher32`

:   Set to true to turn on fletcher32 checksums for this variable.

`endianness`

:   Set to NF90\_ENDIAN\_LITTLE for little-endian format,
    NF90\_ENDIAN\_BIG for big-endian format, and NF90\_ENDIAN\_NATIVE
    (the default) for the native endianness of the platform.

`cache_size`

:   The size of the per-variable cache in MegaBytes.

`cache_nelems`

:   The number slots in the per-variable chunk cache (should be a prime
    number larger than the number of chunks in the cache).

`cache_preemption`

:   The preemtion value must be between 0 and 100 inclusive and
    indicates how much chunks that have been fully read are favored
    for preemption. A value of zero means fully read chunks are treated
    no differently than other chunks (the preemption is strictly LRU)
    while a value of 100 means fully read chunks are always preempted
    before other chunks.



### Return Codes

NF90\_DEF\_VAR returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error.

-   NF90\_EBADNAME The specified variable name is the name of another
    existing variable.
-   NF90\_EBADTYPE The specified type is not a valid netCDF type.
-   NF90\_EMAXDIMS The specified number of dimensions is negative or
    more than the constant NF90\_MAX\_VAR\_DIMS, the maximum number of
    dimensions permitted for a netCDF variable. (Does not apply to
    netCDF-4/HDF5 files unless they were created with the
    CLASSIC\_MODE flag.)
-   NF90\_EBADDIM One or more of the dimension IDs in the list of
    dimensions is not a valid dimension ID for the netCDF dataset.
-   NF90\_EMAXVARS The number of variables would exceed the constant
    NF90\_MAX\_VARS, the maximum number of variables permitted in a
    classic netCDF dataset. (Does not apply to netCDF-4/HDF5 files
    unless they were created with the CLASSIC\_MODE flag.)
-   NF90\_BADID The specified netCDF ID does not refer to an open
    netCDF dataset.
-   NF90\_ENOTNC4 NetCDF-4 operation attempted on a files that is not a
    netCDF-4/HDF5 file. Only variables in NetCDF-4/HDF5 files may use
    compression, chunking, and endianness control.
-   NF90\_ENOTVAR Can’t find this variable.
-   NF90\_EINVAL Invalid input. This may be because contiguous storage
    is requested for a variable that has compression, checksums,
    chunking, or one or more unlimited dimensions.
-   NF90\_ELATEDEF This variable has already been the subject of a
    NF90\_ENDDEF call. Once enddef has been called, it is impossible to
    set the chunking for a variable. (In netCDF-4/HDF5 files
    NF90\_ENDDEF will be called automatically for any data read
    or write.)
-   NF90\_ENOTINDEFINE Not in define mode. This is returned for netCDF
    classic or 64-bit offset files, or for netCDF-4 files, when they
    were been created with NF90\_STRICT\_NC3 flag. (see section
    [NF90\_CREATE](#NF90_005fCREATE)).
-   NF90\_ESTRICTNC3 Trying to create a var some place other than the
    root group in a netCDF file with NF90\_STRICT\_NC3 turned on.



### Example

Here is an example using NF90\_DEF\_VAR to create a variable named rh of
type double with three dimensions, time, lat, and lon in a new netCDF
dataset named foo.nc:




 use netcdf
 implicit none
 integer :: status, ncid
 integer :: LonDimId, LatDimId, TimeDimId
 integer :: RhVarId
 ...
 status = nf90_create("foo.nc", nf90_NoClobber, ncid)
 if(status /= nf90_NoErr) call handle_error(status)
 ...
 ! Define the dimensions
 status = nf90_def_dim(ncid, "lat", 5, LatDimId)
 if(status /= nf90_NoErr) call handle_error(status)
 status = nf90_def_dim(ncid, "lon", 10, LonDimId)
 if(status /= nf90_NoErr) call handle_error(status)
 status = nf90_def_dim(ncid, "time", nf90_unlimited, TimeDimId)
 if(status /= nf90_NoErr) call handle_error(status)
 ...
 ! Define the variable
 status = nf90_def_var(ncid, "rh", nf90_double, &
                       (/ LonDimId, LatDimID, TimeDimID /), RhVarId)
 if(status /= nf90_NoErr) call handle_error(status)




In the following example, from nf\_test/f90tst\_vars2.f90, chunking,
checksums, and endianness control are all used in a netCDF-4/HDF5 file.




  ! Create the netCDF file.
  call check(nf90_create(FILE_NAME, nf90_netcdf4, ncid, cache_nelems = CACHE_NELEMS, &
       cache_size = CACHE_SIZE))

  ! Define the dimensions.
  call check(nf90_def_dim(ncid, "x", NX, x_dimid))
  call check(nf90_def_dim(ncid, "y", NY, y_dimid))
  dimids =  (/ y_dimid, x_dimid /)

  ! Define some variables.
  chunksizes = (/ NY, NX /)
  call check(nf90_def_var(ncid, VAR1_NAME, NF90_INT, dimids, varid1, chunksizes = chunksizes, &
       shuffle = .TRUE., fletcher32 = .TRUE., endianness = nf90_endian_big, deflate_level = DEFLATE_LEVEL))
  call check(nf90_def_var(ncid, VAR2_NAME, NF90_INT, dimids, varid2, contiguous = .TRUE.))
  call check(nf90_def_var(ncid, VAR3_NAME, NF90_INT64, varid3))
  call check(nf90_def_var(ncid, VAR4_NAME, NF90_INT, x_dimid, varid4, contiguous = .TRUE.))




6.4 Define Fill Parameters for a Variable: `nf90_def_var_fill` {#f90-define-fill-parameters-for-a-variable-nf90_def_var_fill}
--------------------------------------------------------------



The function NF90\_DEF\_VAR\_FILL sets the fill parameters for a
variable in a netCDF-4 file.

This function must be called after the variable is defined, but before
NF90\_ENDDEF is called.



### Usage




NF90_DEF_VAR_FILL(INTEGER NCID, INTEGER VARID, INTEGER NO_FILL, FILL_VALUE);




`NCID`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`VARID`

:   Variable ID.

`NO_FILL`

:   Set to non-zero value to set no\_fill mode on a variable. When this
    mode is on, fill values will not be written for the variable. This
    is helpful in high performance applications. For netCDF-4/HDF5 files
    (whether classic model or not), this may only be changed after the
    variable is defined, but before it is committed to disk (i.e. before
    the first NF90\_ENDDEF after the NF90\_DEF\_VAR.) For classic and
    64-bit offset file, the no\_fill mode may be turned on and off at
    any time.

`FILL_VALUE`

:   A value which will be used as the fill value for the variable. Must
    be the same type as the variable. This will be written to a
    \_FillValue attribute, created for this purpose. If NULL, this
    argument will be ignored.



### Return Codes

`NF90_NOERR`

:   No error.

`NF90_BADID`

:   Bad ncid.

`NF90_ENOTNC4`

:   Not a netCDF-4 file.

`NF90_ENOTVAR`

:   Can’t find this variable.

`NF90_ELATEDEF`

:   This variable has already been the subject of a NF90\_ENDDEF call.
    In netCDF-4 files NF90\_ENDDEF will be called automatically for any
    data read or write. Once enddef has been called, it is impossible to
    set the fill for a variable.

`NF90_ENOTINDEFINE`

:   Not in define mode. This is returned for netCDF classic or 64-bit
    offset files, or for netCDF-4 files, when they were been created
    with NF90\_STRICT\_NC3 flag. (see section
    [NF90\_CREATE](#NF90_005fCREATE)).

`NF90_EPERM`

:   Attempt to create object in read-only file.



### Example


6.5 Learn About Fill Parameters for a Variable: `NF90_INQ_VAR_FILL` {#f90-learn-about-fill-parameters-for-a-variable-nf90_inq_var_fill}
-------------------------------------------------------------------



The function NF90\_INQ\_VAR\_FILL returns the fill settings for a
variable in a netCDF-4 file.



### Usage




NF90_INQ_VAR_FILL(INTEGER NCID, INTEGER VARID, INTEGER NO_FILL, FILL_VALUE)




`NCID`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`VARID`

:   Variable ID.

`NO_FILL`

:   An integer which will get a 1 if no\_fill mode is set for this
    variable, and a zero if it is not set

`FILL_VALUE`

:   This will get the fill value for this variable. This parameter will
    be ignored if it is NULL.



### Return Codes

`NF90_NOERR`

:   No error.

`NF90_BADID`

:   Bad ncid.

`NF90_ENOTNC4`

:   Not a netCDF-4 file.

`NF90_ENOTVAR`

:   Can’t find this variable.



### Example

6.6 Get Information about a Variable from Its ID: NF90_INQUIRE_VARIABLE {#f90-get-information-about-a-variable-from-its-id-nf90_inquire_variable}

NF90\_INQUIRE\_VARIABLE returns information about a netCDF variable
given its ID. Information about a variable includes its name, type,
number of dimensions, a list of dimension IDs describing the shape of
the variable, and the number of variable attributes that have been
assigned to the variable.

All parameters after nAtts are optional, and only supported if netCDF
was built with netCDF-4 features enabled, and if the variable is in a
netCDF-4/HDF5 file.



### Usage




  function nf90_inquire_variable(ncid, varid, name, xtype, ndims, dimids, nAtts, &
       contiguous, chunksizes, deflate_level, shuffle, fletcher32, endianness)
    integer, intent(in) :: ncid, varid
    character (len = *), optional, intent(out) :: name
    integer, optional, intent(out) :: xtype, ndims
    integer, dimension(:), optional, intent(out) :: dimids
    integer, optional, intent(out) :: nAtts
    logical, optional, intent(out) :: contiguous
    integer, optional, dimension(:), intent(out) :: chunksizes
    integer, optional, intent(out) :: deflate_level
    logical, optional, intent(out) :: shuffle, fletcher32
    integer, optional, intent(out) :: endianness
    integer :: nf90_inquire_variable




`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`varid`

:   Variable ID.

`name`

:   Returned variable name. The caller must allocate space for the
    returned name. The maximum possible length, in characters, of a
    variable name is given by the predefined constant NF90\_MAX\_NAME.

`xtype`

:   Returned variable type, one of the set of predefined netCDF external
    data types. The valid netCDF external data types are NF90\_BYTE,
    NF90\_CHAR, NF90\_SHORT, NF90\_INT, NF90\_FLOAT, AND NF90\_DOUBLE.

`ndims`

:   Returned number of dimensions the variable was defined as using. For
    example, 2 indicates a matrix, 1 indicates a vector, and 0 means the
    variable is a scalar with no dimensions.

`dimids`

:   Returned vector of \*ndimsp dimension IDs corresponding to the
    variable dimensions. The caller must allocate enough space for a
    vector of at least \*ndimsp integers to be returned. The maximum
    possible number of dimensions for a variable is given by the
    predefined constant NF90\_MAX\_VAR\_DIMS.

`natts`

:   Returned number of variable attributes assigned to this variable.

`contiguous`

:   On return, set to NF90\_CONTIGUOUS if this variable uses contiguous
    storage, NF90\_CHUNKED if it uses chunked storage.

`chunksizes`

:   An array of chunk sizes. The array must have the one element for
    each dimension in the variable.

`shuffle`

:   True if the shuffle filter is turned on for this variable.

`deflate_level`

:   The deflate\_level from 0 to 9. A value of zero indicates no
    deflation is in use.

`fletcher32`

:   Set to true if the fletcher32 checksum filter is turned on for
    this variable.

`endianness`

:   Will be set to NF90\_ENDIAN\_LITTLE if this variable is stored in
    little-endian format, NF90\_ENDIAN\_BIG if it is stored in
    big-endian format, and NF90\_ENDIAN\_NATIVE if the endianness is not
    set, and the variable is not created yet.

These functions return the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The variable ID is invalid for the specified netCDF dataset.
-   The specified netCDF ID does not refer to an open netCDF dataset.



### Example

Here is an example using NF90\_INQ\_VAR to find out about a variable
named rh in an existing netCDF dataset named foo.nc:




    use netcdf
    implicit none
    integer                            :: status, ncid, &
                                          RhVarId       &
                                          numDims, numAtts
 integer, dimension(nf90_max_var_dims) :: rhDimIds
 ...
 status = nf90_open("foo.nc", nf90_NoWrite, ncid)
 if(status /= nf90_NoErr) call handle_error(status)
 ...
 status = nf90_inq_varid(ncid, "rh", RhVarId)
 if(status /= nf90_NoErr) call handle_err(status)
 status = nf90_inquire_variable(ncid, RhVarId, ndims = numDims, natts = numAtts)
 if(status /= nf90_NoErr) call handle_err(status)
 status = nf90_inquire_variable(ncid, RhVarId, dimids = rhDimIds(:numDims))
 if(status /= nf90_NoErr) call handle_err(status)




6.7 Get the ID of a variable from the name: NF90_INQ_VARID {#f90-get-the-id-of-a-variable-from-the-name-nf90_inq_varid}
------------------------------------------------------------



Given the name of a varaible, nf90\_inq\_varid finds the variable ID.



### Usage




  function nf90_inq_varid(ncid, name, varid)
    integer, intent(in) :: ncid
    character (len = *), intent( in) :: name
    integer, intent(out) :: varid
    integer :: nf90_inq_varid




`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`name`

:   The variable name. The maximum possible length, in characters, of a
    variable name is given by the predefined constant NF90\_MAX\_NAME.

`varid`

:   Variable ID.

These functions return the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   Variable not found.
-   The specified netCDF ID does not refer to an open netCDF dataset.



### Example

Here is an example using NF90\_INQ\_VARID to find out about a variable
named rh in an existing netCDF dataset named foo.nc:




    use netcdf
    implicit none
    integer                            :: status, ncid, &
                                          RhVarId       &
                                          numDims, numAtts
 integer, dimension(nf90_max_var_dims) :: rhDimIds
 ...
 status = nf90_open("foo.nc", nf90_NoWrite, ncid)
 if(status /= nf90_NoErr) call handle_error(status)
 ...
 status = nf90_inq_varid(ncid, "rh", RhVarId)
 if(status /= nf90_NoErr) call handle_err(status)
 status = nf90_inquire_variable(ncid, RhVarId, ndims = numDims, natts = numAtts)
 if(status /= nf90_NoErr) call handle_err(status)
 status = nf90_inquire_variable(ncid, RhVarId, dimids = rhDimIds(:numDims))
 if(status /= nf90_NoErr) call handle_err(status)





6.8 Writing Data Values: NF90_PUT_VAR {#f90-writing-data-values-nf90_put_var}
---------------------------------------



The function NF90\_PUT\_VAR puts one or more data values into the
variable of an open netCDF dataset that is in data mode. Required inputs
are the netCDF ID, the variable ID, and one or more data values.
Optional inputs may indicate the starting position of the data values in
the netCDF variable (argument start), the sampling frequency with which
data values are written into the netCDF variable (argument stride), and
a mapping between the dimensions of the data array and the netCDF
variable (argument map). The values to be written are associated with
the netCDF variable by assuming that the first dimension of the netCDF
variable varies fastest in the Fortran 90 interface. Data values are
converted to the external type of the variable, if necessary.

Take care when using the simplest forms of this interface with record
variables (variables that use the NF90\_UNLIMITED dimension) when you
don’t specify how many records are to be written. If you try to write
all the values of a record variable into a netCDF file that has no
record data yet (hence has 0 records), nothing will be written.
Similarly, if you try to write all the values of a record variable from
an array but there are more records in the file than you assume, more
in-memory data will be accessed than you expect, which may cause a
segmentation violation. To avoid such problems, it is better to specify
start and count arguments for variables that use the NF90\_UNLIMITED
dimension.



### Usage




 function nf90_put_var(ncid, varid, values, start, count, stride, map)
   integer,                         intent( in) :: ncid, varid
   any valid type, scalar or array of any rank, &
                                    intent( in) :: values
   integer, dimension(:), optional, intent( in) :: start, count, stride, map
   integer                                      :: nf90_put_var




`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`varid`

:   Variable ID.

`values`

:   The data value(s) to be written. The data may be of any type, and
    may be a scalar or an array of any rank. You cannot put CHARACTER
    data into a numeric variable or numeric data into a text variable.
    For numeric data, if the type of data differs from the netCDF
    variable type, type conversion will occur. See [Type
    Conversion](netcdf.html#Type-Conversion) in NetCDF Users Guide.

`start`

:   A vector of integers specifying the index in the variable where the
    first (or only) of the data values will be written. The indices are
    relative to 1, so for example, the first data value of a variable
    would have index (1, 1, ..., 1). The elements of start correspond,
    in order, to the variable’s dimensions. Hence, if the variable is a
    record variable, the last index would correspond to the starting
    record number for writing the data values.

    By default, start(:) = 1.

`count`

:   A vector of integers specifying the number of indices selected along
    each dimension. To write a single value, for example, specify count
    as (1, 1, ..., 1). The elements of count correspond, in order, to
    the variable’s dimensions. Hence, if the variable is a record
    variable, the last element of count corresponds to a count of the
    number of records to write.

    By default, count(:numDims) = shape(values) and count(numDims + 1:)
    = 1, where numDims = size(shape(values)).

`stride`

:   A vector of integers that specifies the sampling interval along each
    dimension of the netCDF variable. The elements of the stride vector
    correspond, in order, to the netCDF variable’s dimensions (stride(1)
    gives the sampling interval along the most rapidly varying dimension
    of the netCDF variable). Sampling intervals are specified in
    type-independent units of elements (a value of 1 selects consecutive
    elements of the netCDF variable along the corresponding dimension, a
    value of 2 selects every other element, etc.).

    By default, stride(:) = 1.

`imap`

:   A vector of integers that specifies the mapping between the
    dimensions of a netCDF variable and the in-memory structure of the
    internal data array. The elements of the index mapping vector
    correspond, in order, to the netCDF variable’s dimensions (map(1)
    gives the distance between elements of the internal array
    corresponding to the most rapidly varying dimension of the
    netCDF variable). Distances between elements are specified in units
    of elements.

    By default, edgeLengths = shape(values), and map = (/ 1,
    (product(edgeLengths(:i)), i = 1, size(edgeLengths) - 1) /), that
    is, there is no mapping.

    Use of Fortran 90 intrinsic functions (including reshape, transpose,
    and spread) may let you avoid using this argument.



### Errors

NF90\_PUT\_VAR1\_ type returns the value NF90\_NOERR if no errors
occurred. Otherwise, the returned status indicates an error. Possible
causes of errors include:

-   The variable ID is invalid for the specified netCDF dataset.
-   The specified indices were out of range for the rank of the
    specified variable. For example, a negative index or an index that
    is larger than the corresponding dimension length will cause
    an error.
-   The specified value is out of the range of values representable by
    the external data type of the variable.
-   The specified netCDF is in define mode rather than data mode.
-   The specified netCDF ID does not refer to an open netCDF dataset.



### Example

Here is an example using NF90\_PUT\_VAR to set the (4,3,2) element of
the variable named rh to 0.5 in an existing netCDF dataset named foo.nc.
For simplicity in this example, we assume that we know that rh is
dimensioned with lon, lat, and time, so we want to set the value of rh
that corresponds to the fourth lon value, the third lat value, and the
second time value:




 use netcdf
 implicit none
 integer :: ncId, rhVarId, status
 ...
 status = nf90_open("foo.nc", nf90_Write, ncid)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_inq_varid(ncid, "rh", rhVarId)
 if(status /= nf90_NoErr) call handle_err(status)
 status = nf90_put_var(ncid, rhVarId, 0.5, start = (/ 4, 3, 2 /) )
 if(status /= nf90_NoErr) call handle_err(status)




In this example we use NF90\_PUT\_VAR to add or change all the values of
the variable named rh to 0.5 in an existing netCDF dataset named foo.nc.
We assume that we know that rh is dimensioned with lon, lat, and time.
In this example we query the netCDF file to discover the lengths of the
dimensions, then use the Fortran 90 intrinsic function reshape to create
a temporary array of data values which is the same shape as the netCDF
variable.




 use netcdf
 implicit none
 integer                               :: ncId, rhVarId,status,          &
                                          lonDimID, latDimId, timeDimId, &
                                          numLons, numLats, numTimes,    &
                                          i
 integer, dimension(nf90_max_var_dims) :: dimIDs
 ...
 status = nf90_open("foo.nc", nf90_Write, ncid)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_inq_varid(ncid, "rh", rhVarId)
 if(status /= nf90_NoErr) call handle_err(status)
 ! How big is the netCDF variable, that is, what are the lengths of
 !   its constituent dimensions?
 status = nf90_inquire_variable(ncid, rhVarId, dimids = dimIDs)
 if(status /= nf90_NoErr) call handle_err(status)
 status = nf90_inquire_dimension(ncid, dimIDs(1), len = numLons)
 if(status /= nf90_NoErr) call handle_err(status)
 status = nf90_inquire_dimension(ncid, dimIDs(2), len = numLats)
 if(status /= nf90_NoErr) call handle_err(status)
 status = nf90_inquire_dimension(ncid, dimIDs(3), len = numTimes)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 ! Make a temporary array the same shape as the netCDF variable.
 status = nf90_put_var(ncid, rhVarId, &
                       reshape( &
                         (/ (0.5, i = 1, numLons * numLats * numTimes) /) , &
                        shape = (/ numLons, numLats, numTimes /) )
 if(status /= nf90_NoErr) call handle_err(status)




Here is an example using NF90\_PUT\_VAR to add or change a section of
the variable named rh to 0.5 in an existing netCDF dataset named foo.nc.
For simplicity in this example, we assume that we know that rh is
dimensioned with lon, lat, and time, that there are ten lon values, five
lat values, and three time values, and that we want to replace all the
values at the last time.




 use netcdf
 implicit none
 integer            :: ncId, rhVarId, status
 integer, parameter :: numLons = 10, numLats = 5, numTimes = 3
 real, dimension(numLons, numLats) &
                    :: rhValues
 ...
 status = nf90_open("foo.nc", nf90_Write, ncid)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_inq_varid(ncid, "rh", rhVarId)
 if(status /= nf90_NoErr) call handle_err(status)
 ! Fill in all values at the last time
 rhValues(:, :) = 0.5
 status = nf90_put_var(ncid, rhVarId,rhvalues,       &
                       start = (/ 1, 1, numTimes /), &
                       count = (/ numLats, numLons, 1 /))
 if(status /= nf90_NoErr) call handle_err(status)




Here is an example of using NF90\_PUT\_VAR to write every other point of
a netCDF variable named rh having dimensions (6, 4).




 use netcdf
 implicit none
 integer            :: ncId, rhVarId, status
 integer, parameter :: numLons = 6, numLats = 4
 real, dimension(numLons, numLats) &
                    :: rhValues = 0.5
 ...
 status = nf90_open("foo.nc", nf90_Write, ncid)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_inq_varid(ncid, "rh", rhVarId)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 ! Fill in every other value using an array section
 status = nf90_put_var(ncid, rhVarId, rhValues(::2, ::2), &
                       stride = (/ 2, 2 /))
 if(status /= nf90_NoErr) call handle_err(status)




The following map vector shows the default mapping between a 2x3x4
netCDF variable and an internal array of the same shape:




 real,    dimension(2, 3, 4):: a  ! same shape as netCDF variable
 integer, dimension(3)      :: map  = (/ 1, 2, 6 /)
                     ! netCDF dimension inter-element distance
                     ! ---------------- ----------------------
                     ! most rapidly varying       1
                     ! intermediate               2 (= map(1)*2)
                     ! most slowly varying        6 (= map(2)*3)




Using the map vector above obtains the same result as simply not passing
a map vector at all.

Here is an example of using nf90\_put\_var to write a netCDF variable
named rh whose dimensions are the transpose of the Fortran 90 array:




 use netcdf
 implicit none
 integer                           :: ncId, rhVarId, status
 integer, parameter                :: numLons = 6, numLats = 4
 real, dimension(numLons, numLats) :: rhValues
 ! netCDF variable has dimensions (numLats, numLons)
 ...
 status = nf90_open("foo.nc", nf90_Write, ncid)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_inq_varid(ncid, "rh", rhVarId)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 !Write transposed values: map vector would be (/ 1, numLats /) for
 !   no transposition
 status = nf90_put_var(ncid, rhVarId,rhValues, map = (/ numLons, 1 /))
 if(status /= nf90_NoErr) call handle_err(status)




The same effect can be obtained more simply using Fortran 90 intrinsic
functions:




 use netcdf
 implicit none
 integer                           :: ncId, rhVarId, status
 integer, parameter                :: numLons = 6, numLats = 4
 real, dimension(numLons, numLats) :: rhValues
 ! netCDF variable has dimensions (numLats, numLons)
 ...
 status = nf90_open("foo.nc", nf90_Write, ncid)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_inq_varid(ncid, "rh", rhVarId)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_put_var(ncid, rhVarId, transpose(rhValues))
 if(status /= nf90_NoErr) call handle_err(status)





6.9 Reading Data Values: NF90_GET_VAR {#f90-reading-data-values-nf90_get_var}
---------------------------------------



The function NF90\_GET\_VAR gets one or more data values from a netCDF
variable of an open netCDF dataset that is in data mode. Required inputs
are the netCDF ID, the variable ID, and a specification for the data
values into which the data will be read. Optional inputs may indicate
the starting position of the data values in the netCDF variable
(argument start), the sampling frequency with which data values are read
from the netCDF variable (argument stride), and a mapping between the
dimensions of the data array and the netCDF variable (argument map). The
values to be read are associated with the netCDF variable by assuming
that the first dimension of the netCDF variable varies fastest in the
Fortran 90 interface. Data values are converted from the external type
of the variable, if necessary.

Take care when using the simplest forms of this interface with record
variables (variables that use the NF90\_UNLIMITED dimension) when you
don’t specify how many records are to be read. If you try to read all
the values of a record variable into an array but there are more records
in the file than you assume, more data will be read than you expect,
which may cause a segmentation violation. To avoid such problems, it is
better to specify the optional start and count arguments for variables
that use the NF90\_UNLIMITED dimension.

In netCDF classic model the maximum integer size is NF90\_INT, the
4-byte signed integer. Reading variables into an eight-byte integer
array from a classic model file will read from an NF90\_INT. Reading
variables into an eight-byte integer in a netCDF-4/HDF5 (without classic
model flag) will read from an NF90\_INT64



### Usage




 function nf90_get_var(ncid, varid, values, start, count, stride, map)
   integer,                         intent( in) :: ncid, varid
   any valid type, scalar or array of any rank, &
                                    intent(out) :: values
   integer, dimension(:), optional, intent( in) :: start, count, stride, map
   integer                                      :: nf90_get_var




`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`varid`

:   Variable ID.

`values`

:   The data value(s) to be read. The data may be of any type, and may
    be a scalar or an array of any rank. You cannot read CHARACTER data
    from a numeric variable or numeric data from a text variable. For
    numeric data, if the type of data differs from the netCDF variable
    type, type conversion will occur. See [Type
    Conversion](netcdf.html#Type-Conversion) in NetCDF Users Guide.

`start`

:   A vector of integers specifying the index in the variable from which
    the first (or only) of the data values will be read. The indices are
    relative to 1, so for example, the first data value of a variable
    would have index (1, 1, ..., 1). The elements of start correspond,
    in order, to the variable’s dimensions. Hence, if the variable is a
    record variable, the last index would correspond to the starting
    record number for writing the data values.

    By default, start(:) = 1.

`count`

:   A vector of integers specifying the number of indices selected along
    each dimension. To read a single value, for example, specify count
    as (1, 1, ..., 1). The elements of count correspond, in order, to
    the variable’s dimensions. Hence, if the variable is a record
    variable, the last element of count corresponds to a count of the
    number of records to read.

    By default, count(:numDims) = shape(values) and count(numDims + 1:)
    = 1, where numDims = size(shape(values)).

`stride`

:   A vector of integers that specifies the sampling interval along each
    dimension of the netCDF variable. The elements of the stride vector
    correspond, in order, to the netCDF variable’s dimensions (stride(1)
    gives the sampling interval along the most rapidly varying dimension
    of the netCDF variable). Sampling intervals are specified in
    type-independent units of elements (a value of 1 selects consecutive
    elements of the netCDF variable along the corresponding dimension, a
    value of 2 selects every other element, etc.).

    By default, stride(:) = 1.

`map`

:   A vector of integers that specifies the mapping between the
    dimensions of a netCDF variable and the in-memory structure of the
    internal data array. The elements of the index mapping vector
    correspond, in order, to the netCDF variable’s dimensions (map(1)
    gives the distance between elements of the internal array
    corresponding to the most rapidly varying dimension of the
    netCDF variable). Distances between elements are specified in units
    of elements.

    By default, edgeLengths = shape(values), and map = (/ 1,
    (product(edgeLengths(:i)), i = 1, size(edgeLengths) - 1) /), that
    is, there is no mapping.

    Use of Fortran 90 intrinsic functions (including reshape, transpose,
    and spread) may let you avoid using this argument.



### Errors

NF90\_GET\_VAR returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The variable ID is invalid for the specified netCDF dataset.
-   The assumed or specified start, count, and stride generate an index
    which is out of range. Note that no error checking is possible on
    the map vector.
-   One or more of the specified values are out of the range of values
    representable by the desired type.
-   The specified netCDF is in define mode rather than data mode.
-   The specified netCDF ID does not refer to an open netCDF dataset.

(As noted above, another possible source of error is using this
interface to read all the values of a record variable without specifying
the number of records. If there are more records in the file than you
assume, more data will be read than you expect!)



### Example

Here is an example using NF90\_GET\_VAR to read the (4,3,2) element of
the variable named rh from an existing netCDF dataset named foo.nc. For
simplicity in this example, we assume that we know that rh is
dimensioned with lon, lat, and time, so we want to read the value of rh
that corresponds to the fourth lon value, the third lat value, and the
second time value:




 use netcdf
 implicit none
 integer :: ncId, rhVarId, status
 real    :: rhValue
 ...
 status = nf90_open("foo.nc", nf90_NoWrite, ncid)
 if(status /= nf90_NoErr) call handle_err(status)
 -
 status = nf90_inq_varid(ncid, "rh", rhVarId)
 if(status /= nf90_NoErr) call handle_err(status)
 status = nf90_get_var(ncid, rhVarId, rhValue, start = (/ 4, 3, 2 /) )
 if(status /= nf90_NoErr) call handle_err(status)




In this example we use NF90\_GET\_VAR to read all the values of the
variable named rh from an existing netCDF dataset named foo.nc. We
assume that we know that rh is dimensioned with lon, lat, and time. In
this example we query the netCDF file to discover the lengths of the
dimensions, then allocate a Fortran 90 array the same shape as the
netCDF variable.




 use netcdf
 implicit none
 integer                               :: ncId, rhVarId, &
                                          lonDimID, latDimId, timeDimId, &
                                          numLons, numLats, numTimes,    &
                                          status
 integer, dimension(nf90_max_var_dims) :: dimIDs
 real, dimension(:, :, :), allocatable :: rhValues
 ...
 status = nf90_open("foo.nc", nf90_NoWrite, ncid)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_inq_varid(ncid, "rh", rhVarId)
 if(status /= nf90_NoErr) call handle_err(status)
 ! How big is the netCDF variable, that is, what are the lengths of
 !   its constituent dimensions?
 status = nf90_inquire_variable(ncid, rhVarId, dimids = dimIDs)
 if(status /= nf90_NoErr) call handle_err(status)
 status = nf90_inquire_dimension(ncid, dimIDs(1), len = numLons)
 if(status /= nf90_NoErr) call handle_err(status)
 status = nf90_inquire_dimension(ncid, dimIDs(2), len = numLats)
 if(status /= nf90_NoErr) call handle_err(status)
 status = nf90_inquire_dimension(ncid, dimIDs(3), len = numTimes)
 if(status /= nf90_NoErr) call handle_err(status)
 allocate(rhValues(numLons, numLats, numTimes))
 ...
 status = nf90_get_var(ncid, rhVarId, rhValues)
 if(status /= nf90_NoErr) call handle_err(status)




Here is an example using NF90\_GET\_VAR to read a section of the
variable named rh from an existing netCDF dataset named foo.nc. For
simplicity in this example, we assume that we know that rh is
dimensioned with lon, lat, and time, that there are ten lon values, five
lat values, and three time values, and that we want to replace all the
values at the last time.




 use netcdf
 implicit none
 integer            :: ncId, rhVarId, status
 integer, parameter :: numLons = 10, numLats = 5, numTimes = 3
 real, dimension(numLons, numLats, numTimes) &
                    :: rhValues
 ...
 status = nf90_open("foo.nc", nf90_NoWrite, ncid)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_inq_varid(ncid, "rh", rhVarId)
 if(status /= nf90_NoErr) call handle_err(status)
 !Read the values at the last time by passing an array section
 status = nf90_get_var(ncid, rhVarId, rhValues(:, :, 3), &
                       start = (/ 1, 1, numTimes /),     &
                       count = (/ numLons, numLats, 1 /))
 if(status /= nf90_NoErr) call handle_err(status)




Here is an example of using NF90\_GET\_VAR to read every other point of
a netCDF variable named rh having dimensions (6, 4).




 use netcdf
 implicit none
 integer            :: ncId, rhVarId, status
 integer, parameter :: numLons = 6, numLats = 4
 real, dimension(numLons, numLats) &
                    :: rhValues
 ...
 status = nf90_open("foo.nc", nf90_NoWrite, ncid)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_inq_varid(ncid, "rh", rhVarId)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 ! Read every other value into an array section
 status = nf90_get_var(ncid, rhVarId, rhValues(::2, ::2) &
                       stride = (/ 2, 2 /))
 if(status /= nf90_NoErr) call handle_err(status)




The following map vector shows the default mapping between a 2x3x4
netCDF variable and an internal array of the same shape:




 real,    dimension(2, 3, 4):: a  ! same shape as netCDF variable
 integer, dimension(3)      :: map  = (/ 1, 2, 6 /)
                     ! netCDF dimension inter-element distance
                     ! ---------------- ----------------------
                     ! most rapidly varying       1
                     ! intermediate               2 (= map(1)*2)
                     ! most slowly varying        6 (= map(2)*3)




Using the map vector above obtains the same result as simply not passing
a map vector at all.

Here is an example of using nf90\_get\_var to read a netCDF variable
named rh whose dimensions are the transpose of the Fortran 90 array:




 use netcdf
 implicit none
 integer                           :: ncId, rhVarId, status
 integer, parameter                :: numLons = 6, numLats = 4
 real, dimension(numLons, numLats) :: rhValues
 ! netCDF variable has dimensions (numLats, numLons)
 ...
 status = nf90_open("foo.nc", nf90_NoWrite, ncid)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_inq_varid(ncid, "rh", rhVarId)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 ! Read transposed values: map vector would be (/ 1, numLats /) for
 !   no transposition
 status = nf90_get_var(ncid, rhVarId,rhValues, map = (/ numLons, 1 /))
 if(status /= nf90_NoErr) call handle_err(status)




The same effect can be obtained more simply, though using more memory,
using Fortran 90 intrinsic functions:




 use netcdf
 implicit none
 integer                           :: ncId, rhVarId, status
 integer, parameter                :: numLons = 6, numLats = 4
 real, dimension(numLons, numLats) :: rhValues
 ! netCDF variable has dimensions (numLats, numLons)
 real, dimension(numLons, numLats) :: tempValues
 ...
 status = nf90_open("foo.nc", nf90_NoWrite, ncid)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_inq_varid(ncid, "rh", rhVarId)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_get_var(ncid, rhVarId, tempValues))
 if(status /= nf90_NoErr) call handle_err(status)
 rhValues(:, :) = transpose(tempValues)






6.10 Reading and Writing Character String Values {#f90-reading-and-writing-character-string-values}
------------------------------------------------

Character strings are not a primitive netCDF external data type under
the classic netCDF data model, in part because FORTRAN does not support
the abstraction of variable-length character strings (the FORTRAN LEN
function returns the static length of a character string, not its
dynamic length). As a result, a character string cannot be written or
read as a single object in the netCDF interface. Instead, a character
string must be treated as an array of characters, and array access must
be used to read and write character strings as variable data in netCDF
datasets. Furthermore, variable-length strings are not supported by the
netCDF classic interface except by convention; for example, you may
treat a zero byte as terminating a character string, but you must
explicitly specify the length of strings to be read from and written to
netCDF variables.

Character strings as attribute values are easier to use, since the
strings are treated as a single unit for access. However, the value of a
character-string attribute in the classic netCDF interface is still an
array of characters with an explicit length that must be specified when
the attribute is defined.

When you define a variable that will have character-string values, use a
character-position dimension as the most quickly varying dimension for
the variable (the first dimension for the variable in Fortran 90). The
length of the character-position dimension will be the maximum string
length of any value to be stored in the character-string variable. Space
for maximum-length strings will be allocated in the disk representation
of character-string variables whether you use the space or not. If two
or more variables have the same maximum length, the same
character-position dimension may be used in defining the variable
shapes.

To write a character-string value into a character-string variable, use
either entire variable access or array access. The latter requires that
you specify both a corner and a vector of edge lengths. The
character-position dimension at the corner should be one for Fortran 90.
If the length of the string to be written is n, then the vector of edge
lengths will specify n in the character-position dimension, and one for
all the other dimensions: (n, 1, 1, ..., 1).

In Fortran 90, fixed-length strings may be written to a netCDF dataset
without a terminating character, to save space. Variable-length strings
should follow the C convention of writing strings with a terminating
zero byte so that the intended length of the string can be determined
when it is later read by either C or Fortran 90 programs. It is the
users responsibility to provide such null termination.

If you are writing data in the default prefill mode (see next section),
you can ensure that simple strings represented as 1-dimensional
character arrays are null terminated in the netCDF file by writing fewer
characters than the length declared when the variable was defined. That
way, the extra unwritten characters will be filled with the default
character fill value, which is a null byte. The Fortran intrinsic TRIM
function can be used to trim trailing blanks from the character string
argument to NF90\_PUT\_VAR to make the argument shorter than the
declared length. If prefill is not on, the data writer must explicitly
provide a null terminating byte.

Here is an example illustrating this way of writing strings to character
array variables:




 use netcdf
 implicit none
 integer status
 integer                           :: ncid, oceanStrLenID, oceanId
 integer, parameter                :: MaxOceanNameLen = 20
 character, (len = MaxOceanNameLen):: ocean
 ...
 status = nf90_create("foo.nc", nf90_NoClobber, ncid)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_def_dim(ncid, "oceanStrLen", MaxOceanNameLen, oceanStrLenId)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_def_var(ncid, "ocean", nf90_char, (/ oceanStrLenId /), oceanId)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 ! Leave define mode, which prefills netCDF variables with fill values
 status = nf90_enddef(ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...
 ! Note that this assignment adds blank fill
 ocean = "Pacific"
 ! Using trim removes trailing blanks, prefill provides null
 ! termination, so C programs can later get intended string.
 status = nf90_put_var(ncid, oceanId, trim(ocean))
 if(status /= nf90_NoErr) call handle_err(status)




6.11 Fill Values {#f90-fill-values}
----------------

What happens when you try to read a value that was never written in an
open netCDF dataset? You might expect that this should always be an
error, and that you should get an error message or an error status
returned. You do get an error if you try to read data from a netCDF
dataset that is not open for reading, if the variable ID is invalid for
the specified netCDF dataset, or if the specified indices are not
properly within the range defined by the dimension lengths of the
specified variable. Otherwise, reading a value that was not written
returns a special fill value used to fill in any undefined values when a
netCDF variable is first written.

You may ignore fill values and use the entire range of a netCDF external
data type, but in this case you should make sure you write all data
values before reading them. If you know you will be writing all the data
before reading it, you can specify that no prefilling of variables with
fill values will occur by calling writing. This may provide a
significant performance gain for netCDF writes.

The variable attribute \_FillValue may be used to specify the fill value
for a variable. There are default fill values for each type, defined in
module netcdf: NF90\_FILL\_CHAR, NF90\_FILL\_INT1 (same as
NF90\_FILL\_BYTE), NF90\_FILL\_INT2 (same as NF90\_FILL\_SHORT),
NF90\_FILL\_INT, NF90\_FILL\_REAL (same as NF90\_FILL\_FLOAT), and
NF90\_FILL\_DOUBLE

The netCDF byte and character types have different default fill values.
The default fill value for characters is the zero byte, a useful value
for detecting the end of variable-length C character strings. If you
need a fill value for a byte variable, it is recommended that you
explicitly define an appropriate \_FillValue attribute, as generic
utilities such as ncdump will not assume a default fill value for byte
variables.

Type conversion for fill values is identical to type conversion for
other values: attempting to convert a value from one type to another
type that can’t represent the value results in a range error. Such
errors may occur on writing or reading values from a larger type (such
as double) to a smaller type (such as float), if the fill value for the
larger type cannot be represented in the smaller type.


6.12 NF90_RENAME_VAR {#f90-nf90_rename_var}
----------------------



The function NF90\_RENAME\_VAR changes the name of a netCDF variable in
an open netCDF dataset. If the new name is longer than the old name, the
netCDF dataset must be in define mode. You cannot rename a variable to
have the name of any existing variable.



### Usage




 function nf90_rename_var(ncid, varid, newname)
   integer,             intent( in) :: ncid, varid
   character (len = *), intent( in) :: newname
   integer                          :: nf90_rename_var




`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`varid`

:   Variable ID.

`newname`

:   New name for the specified variable.



### Errors

NF90\_RENAME\_VAR returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The new name is in use as the name of another variable.
-   The variable ID is invalid for the specified netCDF dataset.
-   The specified netCDF ID does not refer to an open netCDF dataset.



### Example

Here is an example using NF90\_RENAME\_VAR to rename the variable rh to
rel\_hum in an existing netCDF dataset named foo.nc:




 use netcdf
 implicit none
 integer :: ncId, rhVarId, status
 ...
 status = nf90_open("foo.nc", nf90_Write, ncid)
 if(status /= nf90_NoErr) call handle_err(status)
 ...
 status = nf90_inq_varid(ncid, "rh", rhVarId)
 if(status /= nf90_NoErr) call handle_err(status)
 status = nf90_redef(ncid)  ! Enter define mode to change variable name
 if(status /= nf90_NoErr) call handle_err(status)
 status = nf90_rename_var(ncid, rhVarId, "rel_hum")
 if(status /= nf90_NoErr) call handle_err(status)
 status = nf90_enddef(ncid) ! Leave define mode
 if(status /= nf90_NoErr) call handle_err(status)





6.13 Change between Collective and Independent Parallel Access: NF90_VAR_PAR_ACCESS {#f90-change-between-collective-and-independent-parallel-access-nf90_var_par_access}
--------------



The function NF90\_VAR\_PAR\_ACCESS changes whether read/write
operations on a parallel file system are performed collectively or
independently (the default) on the variable. This function can only be
called if the file was created (see [NF90\_CREATE](#NF90_005fCREATE)) or
opened (see [NF90\_OPEN](#NF90_005fOPEN)) for parallel I/O.

This function is only available if the netCDF library was built with
parallel I/O enabled.

Calling this function affects only the open file - information about
whether a variable is to be accessed collectively or independently is
not written to the data file. Every time you open a file on a parallel
file system, all variables default to independent operations. The change
of a variable to collective access lasts only as long as that file is
open.

The variable can be changed from collective to independent, and back, as
often as desired.

Classic and 64-bit offset files, when opened for parallel access, use
the parallel-netcdf (a.k.a. pnetcdf) library, which does not allow
per-variable changes of access mode - the entire file must be access
independently or collectively. For classic and 64-bit offset files, the
nf90\_var\_par\_access function changes the access for all variables in
the file.



### Usage




  function nf90_var_par_access(ncid, varid, access)
    integer, intent(in) :: ncid
    integer, intent(in) :: varid
    integer, intent(in) :: access
    integer :: nf90_var_par_access
  end function nf90_var_par_access




`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN (see
    [NF90\_OPEN](#NF90_005fOPEN)) or NF90\_CREATE (see
    [NF90\_CREATE](#NF90_005fCREATE)).

`varid`

:   Variable ID.

`access`

:   NF90\_INDEPENDENT to set this variable to independent operations.
    NF90\_COLLECTIVE to set it to collective operations.



Return Values {#f90-return-values}
-------------

`NF90_NOERR`

:   No error.

`NF90_ENOTVAR`

:   No variable found.

`NF90_NOPAR`

:   File not opened for parallel access.



### Example

This example comes from test program nf\_test/f90tst\_parallel.f90. For
this test to be run, netCDF must have been built with a parallel-enabled
HDF5, and –enable-parallel-tests must have been used when configuring
netcdf.




  ! Reopen the file.
  call handle_err(nf90_open(FILE_NAME, nf90_nowrite, ncid, comm = MPI_COMM_WORLD, &
       info = MPI_INFO_NULL))

  ! Set collective access on this variable. This will cause all
  ! reads/writes to happen together on every processor.
  call handle_err(nf90_var_par_access(ncid, varid, nf90_collective))

  ! Read this processor's data.
  call handle_err(nf90_get_var(ncid, varid, data_in, start = start, count = count))





7 Attributes {#f90-attributes}
============

7.1 Attributes Introduction {#f90-attributes-introduction}
---------------------------

Attributes may be associated with each netCDF variable to specify such
properties as units, special values, maximum and minimum valid values,
scaling factors, and offsets. Attributes for a netCDF dataset are
defined when the dataset is first created, while the netCDF dataset is
in define mode. Additional attributes may be added later by reentering
define mode. A netCDF attribute has a netCDF variable to which it is
assigned, a name, a type, a length, and a sequence of one or more
values. An attribute is designated by its variable ID and name. When an
attribute name is not known, it may be designated by its variable ID and
number in order to determine its name, using the function
NF90\_INQ\_ATTNAME.

The attributes associated with a variable are typically defined
immediately after the variable is created, while still in define mode.
The data type, length, and value of an attribute may be changed even
when in data mode, as long as the changed attribute requires no more
space than the attribute as originally defined.

It is also possible to have attributes that are not associated with any
variable. These are called global attributes and are identified by using
NF90\_GLOBAL as a variable pseudo-ID. Global attributes are usually
related to the netCDF dataset as a whole and may be used for purposes
such as providing a title or processing history for a netCDF dataset.

Attributes are much more useful when they follow established community
conventions. See [Attribute
Conventions](netcdf.html#Attribute-Conventions) in {No value for
‘n-man’}.

Operations supported on attributes are:

-   Create an attribute, given its variable ID, name, data type, length,
    and value.
-   Get attribute’s data type and length from its variable ID and name.
-   Get attribute’s value from its variable ID and name.
-   Copy attribute from one netCDF variable to another.
-   Get name of attribute from its number.
-   Rename an attribute.
-   Delete an attribute.



7.2 Create an Attribute: NF90_PUT_ATT {#f90-create-an-attribute-nf90_put_att}
---------------------------------------



The function NF90\_PUT\_ATTadds or changes a variable attribute or
global attribute of an open netCDF dataset. If this attribute is new, or
if the space required to store the attribute is greater than before, the
netCDF dataset must be in define mode.



### Usage

Although it’s possible to create attributes of all types, text and
double attributes are adequate for most purposes.




 function nf90_put_att(ncid, varid, name, values)
   integer,            intent( in) :: ncid, varid
   character(len = *), intent( in) :: name
   scalar character string or any numeric type, scalar, or array of rank 1, &
                       intent( in) :: values
   integer                         :: nf90_put_att




`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`varid`

:   Variable ID of the variable to which the attribute will be assigned
    or NF90\_GLOBAL for a global attribute.

`name`

:   Attribute name. Attribute name conventions are assumed by some
    netCDF generic applications, e.g., ‘units’ as the name for a string
    attribute that gives the units for a netCDF variable. See [Attribute
    Conventions](netcdf.html#Attribute-Conventions) in {No value
    for ‘n-man’}.

`values`

:   A numeric rank 1 array of attribute values or a scalar. The external
    data type of the attribute is set to match the internal
    representation of the argument, that is if values is a two byte
    integer array, the attribute will be of type NF90\_INT2. Fortran 90
    intrinsic functions can be used to convert attributes to the
    desired type.



### Errors

NF90\_PUT\_ATT returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The variable ID is invalid for the specified netCDF dataset.
-   The specified netCDF type is invalid.
-   The specified length is negative.
-   The specified open netCDF dataset is in data mode and the specified
    attribute would expand.
-   The specified open netCDF dataset is in data mode and the specified
    attribute does not already exist.
-   The specified netCDF ID does not refer to an open netCDF dataset.
-   The number of attributes for this variable exceeds NF90\_MAX\_ATTRS.



### Example

Here is an example using NF90\_PUT\_ATT to add a variable attribute
named valid\_range for a netCDF variable named rh and a global attribute
named title to an existing netCDF dataset named foo.nc:




 use netcdf
 implicit none
 integer :: ncid, status, RHVarID
 ...
 status = nf90_open("foo.nc", nf90_write, ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...  
 ! Enter define mode so we can add the attribute
 status = nf90_redef(ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ! Get the variable ID for "rh"...
 status = nf90_inq_varid(ncid, "rh", RHVarID)
 if (status /= nf90_noerr) call handle_err(status)
 ! ...  put the range attribute, setting it to eight byte reals...
 status = nf90_put_att(ncid, RHVarID, "valid_range", real((/ 0, 100 /))
 ! ... and the title attribute.
 if (status /= nf90_noerr) call handle_err(status)
 status = nf90_put_att(ncid, RHVarID, "title", "example netCDF dataset") )
 if (status /= nf90_noerr) call handle_err(status)
 ! Leave define mode
 status = nf90_enddef(ncid)
 if (status /= nf90_noerr) call handle_err(status)





7.3 Get Information about an Attribute: NF90_INQUIRE_ATTRIBUTE and NF90_INQ_ATTNAME {#f90-get-information-about-an-attribute-nf90_inquire_attribute-and-nf90_inq_attname}
---------------



The function NF90\_INQUIRE\_ATTRIBUTE returns information about a netCDF
attribute given the variable ID and attribute name. Information about an
attribute includes its type, length, name, and number. See
NF90\_GET\_ATT for getting attribute values.

The function NF90\_INQ\_ATTNAME gets the name of an attribute, given its
variable ID and number. This function is useful in generic applications
that need to get the names of all the attributes associated with a
variable, since attributes are accessed by name rather than number in
all other attribute functions. The number of an attribute is more
volatile than the name, since it can change when other attributes of the
same variable are deleted. This is why an attribute number is not called
an attribute ID.



### Usage




 function nf90_inquire_attribute(ncid, varid, name, xtype, len, attnum)
   integer,             intent( in)           :: ncid, varid
   character (len = *), intent( in)           :: name
   integer,             intent(out), optional :: xtype, len, attnum
   integer                                    :: nf90_inquire_attribute
 function nf90_inq_attname(ncid, varid, attnum, name)
   integer,             intent( in) :: ncid, varid, attnum
   character (len = *), intent(out) :: name
   integer                          :: nf90_inq_attname




`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`varid`

:   Variable ID of the attribute’s variable, or NF90\_GLOBAL for a
    global attribute.

`name`

:   Attribute name. For NF90\_INQ\_ATTNAME, this is a pointer to the
    location for the returned attribute name.

`xtype`

:   Returned attribute type, one of the set of predefined netCDF
    external data types. The valid netCDF external data types are
    NF90\_BYTE, NF90\_CHAR, NF90\_SHORT, NF90\_INT, NF90\_FLOAT,
    and NF90\_DOUBLE.

`len`

:   Returned number of values currently stored in the attribute. For a
    string-valued attribute, this is the number of characters in
    the string.

`attnum`

:   For NF90\_INQ\_ATTNAME, the input attribute number; for
    NF90\_INQ\_ATTID, the returned attribute number. The attributes for
    each variable are numbered from 1 (the first attribute) to NATTS,
    where NATTS is the number of attributes for the variable, as
    returned from a call to NF90\_INQ\_VARNATTS.

    (If you already know an attribute name, knowing its number is not
    very useful, because accessing information about an attribute
    requires its name.)



### Errors

Each function returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The variable ID is invalid for the specified netCDF dataset.
-   The specified attribute does not exist.
-   The specified netCDF ID does not refer to an open netCDF dataset.
-   For NF90\_INQ\_ATTNAME, the specified attribute number is negative
    or more than the number of attributes defined for the
    specified variable.



### Example

Here is an example using NF90\_INQUIRE\_ATTRIBUTE to inquire about the
lengths of an attribute named valid\_range for a netCDF variable named
rh and a global attribute named title in an existing netCDF dataset
named foo.nc:




 use netcdf
 implicit none
 integer :: ncid, status
 integer :: RHVarID                       ! Variable ID
 integer :: validRangeLength, titleLength ! Attribute lengths
 ...
 status = nf90_open("foo.nc", nf90_nowrite, ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...  
 ! Get the variable ID for "rh"...
 status = nf90_inq_varid(ncid, "rh", RHVarID)
 if (status /= nf90_noerr) call handle_err(status)
 ! ...  get the length of the "valid_range" attribute...
 status = nf90_inquire_attribute(ncid, RHVarID, "valid_range", &
                           len = validRangeLength)
 if (status /= nf90_noerr) call handle_err(status)
 ! ... and the global title attribute.
 status = nf90_inquire_attribute(ncid, nf90_global, "title", len = titleLength)
 if (status /= nf90_noerr) call handle_err(status)




7.4 Get Attribute’s Values: NF90_GET_ATT {#f90-get-attributes-values-nf90_get_att}
------------------------------------------



Function nf90\_get\_att gets the value(s) of a netCDF attribute, given
its variable ID and name.



### Usage




 function nf90_get_att(ncid, varid, name, values)
   integer,            intent( in) :: ncid, varid
   character(len = *), intent( in) :: name
   any valid type, scalar or array of rank 1, &
                       intent(out) :: values
   integer                         :: nf90_get_att




`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`varid`

:   Variable ID of the attribute’s variable, or NF90\_GLOBAL for a
    global attribute.

`name`

:   Attribute name.

`values`

:   Returned attribute values. All elements of the vector of attribute
    values are returned, so you must provide enough space to hold them.
    If you don’t know how much space to reserve, call
    NF90\_INQUIRE\_ATTRIBUTE first to find out the length of
    the attribute. If there is only a single attribute values may be
    a scalar. If the attribute is of type character values should be a
    varble of type character with the len Fortran 90 attribute set to
    an appropriate value (i.e. character (len = 80) :: values). You
    cannot read character data from a numeric variable or numeric data
    from a text variable. For numeric data, if the type of data differs
    from the netCDF variable type, type conversion will occur. See [Type
    Conversion](netcdf.html#Type-Conversion) in NetCDF Users Guide.



### Errors

NF90\_GET\_ATT\_ type returns the value NF90\_NOERR if no errors
occurred. Otherwise, the returned status indicates an error. Possible
causes of errors include:

-   The variable ID is invalid for the specified netCDF dataset.
-   The specified attribute does not exist.
-   The specified netCDF ID does not refer to an open netCDF dataset.
-   One or more of the attribute values are out of the range of values
    representable by the desired type.



### Example

Here is an example using NF90\_GET\_ATT to determine the values of an
attribute named valid\_range for a netCDF variable named rh and a global
attribute named title in an existing netCDF dataset named foo.nc. In
this example, it is assumed that we don’t know how many values will be
returned, so we first inquire about the length of the attributes to make
sure we have enough space to store them:




 use netcdf
 implicit none
 integer              :: ncid, status
 integer              :: RHVarID                       ! Variable ID
 integer              :: validRangeLength, titleLength ! Attribute lengths
 real, dimension(:), allocatable, &
                      :: validRange
 character (len = 80) :: title                          
 ...
 status = nf90_open("foo.nc", nf90_nowrite, ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...
 ! Find the lengths of the attributes
 status = nf90_inq_varid(ncid, "rh", RHVarID)
 if (status /= nf90_noerr) call handle_err(status)
 status = nf90_inquire_attribute(ncid, RHVarID, "valid_range", &
                           len = validRangeLength)
 if (status /= nf90_noerr) call handle_err(status)
 status = nf90_inquire_attribute(ncid, nf90_global, "title", len = titleLength)
 if (status /= nf90_noerr) call handle_err(status)
 ...
 !Allocate space to hold attribute values, check string lengths
 allocate(validRange(validRangeLength), stat = status)
 if(status /= 0 .or. len(title) < titleLength)
   print *, "Not enough space to put attribute values."
   exit
 end if
 ! Read the attributes.
 status = nf90_get_att(ncid, RHVarID, "valid_range", validRange)
 if (status /= nf90_noerr) call handle_err(status)
 status = nf90_get_att(ncid, nf90_global, "title", title)
 if (status /= nf90_noerr) call handle_err(status)





7.5 Copy Attribute from One NetCDF to Another: NF90_COPY_ATT {#f90-copy-attribute-from-one-netcdf-to-another-nf90_copy_att}
--------------------------------------------------------------



The function NF90\_COPY\_ATT copies an attribute from one open netCDF
dataset to another. It can also be used to copy an attribute from one
variable to another within the same netCDF dataset.

If used to copy an attribute of user-defined type, then that
user-defined type must already be defined in the target file. In the
case of user-defined attributes, enddef/redef is called for ncid\_in and
ncid\_out if they are in define mode. (This is the ensure that all
user-defined types are committed to the file(s) before the copy is
attempted.)



### Usage




 function nf90_copy_att(ncid_in, varid_in, name, ncid_out, varid_out)
   integer,             intent( in) :: ncid_in,  varid_in
   character (len = *), intent( in) :: name
   integer,             intent( in) :: ncid_out, varid_out
   integer                          :: nf90_copy_att




`ncid_in`

:   The netCDF ID of an input netCDF dataset from which the attribute
    will be copied, from a previous call to NF90\_OPEN or NF90\_CREATE.

`varid_in`

:   ID of the variable in the input netCDF dataset from which the
    attribute will be copied, or NF90\_GLOBAL for a global attribute.

`name`

:   Name of the attribute in the input netCDF dataset to be copied.

`ncid_out`

:   The netCDF ID of the output netCDF dataset to which the attribute
    will be copied, from a previous call to NF90\_OPEN or NF90\_CREATE.
    It is permissible for the input and output netCDF IDs to be
    the same. The output netCDF dataset should be in define mode if the
    attribute to be copied does not already exist for the target
    variable, or if it would cause an existing target attribute to grow.

`varid_out`

:   ID of the variable in the output netCDF dataset to which the
    attribute will be copied, or NF90\_GLOBAL to copy to a
    global attribute.



### Errors

NF90\_COPY\_ATT returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The input or output variable ID is invalid for the specified
    netCDF dataset.
-   The specified attribute does not exist.
-   The output netCDF is not in define mode and the attribute is new for
    the output dataset is larger than the existing attribute.
-   The input or output netCDF ID does not refer to an open
    netCDF dataset.



### Example

Here is an example using NF90\_COPY\_ATT to copy the variable attribute
units from the variable rh in an existing netCDF dataset named foo.nc to
the variable avgrh in another existing netCDF dataset named bar.nc,
assuming that the variable avgrh already exists, but does not yet have a
units attribute:




 use netcdf
 implicit none
 integer :: ncid1, ncid2, status
 integer :: RHVarID, avgRHVarID    ! Variable ID
 ...
 status = nf90_open("foo.nc", nf90_nowrite, ncid1)
 if (status /= nf90_noerr) call handle_err(status)
 status = nf90_open("bar.nc", nf90_write, ncid2)
 if (status /= nf90_noerr) call handle_err(status)
 ...
 ! Find the IDs of the variables
 status = nf90_inq_varid(ncid1, "rh", RHVarID)
 if (status /= nf90_noerr) call handle_err(status)
 status = nf90_inq_varid(ncid1, "avgrh", avgRHVarID)
 if (status /= nf90_noerr) call handle_err(status)
 ...
 status = nf90_redef(ncid2)   ! Enter define mode
 if (status /= nf90_noerr) call handle_err(status)
 ! Copy variable attribute from "rh" in file 1 to "avgrh" in file 1
 status = nf90_copy_att(ncid1, RHVarID, "units", ncid2, avgRHVarID)
 if (status /= nf90_noerr) call handle_err(status)
 status = nf90_enddef(ncid2)
 if (status /= nf90_noerr) call handle_err(status)




7.6 Rename an Attribute: NF90_RENAME_ATT {#f90-rename-an-attribute-nf90_rename_att}
------------------------------------------



The function NF90\_RENAME\_ATT changes the name of an attribute. If the
new name is longer than the original name, the netCDF dataset must be in
define mode. You cannot rename an attribute to have the same name as
another attribute of the same variable.



### Usage




 function nf90_rename_att(ncid, varid, curname, newname)
   integer,             intent( in) :: ncid,  varid
   character (len = *), intent( in) :: curname, newname
   integer                          :: nf90_rename_att




`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE

`varid`

:   ID of the attribute’s variable, or NF90\_GLOBAL for a global
    attribute

`curname`

:   The current attribute name.

`newname`

:   The new name to be assigned to the specified attribute. If the new
    name is longer than the current name, the netCDF dataset must be in
    define mode.



### Errors

NF90\_RENAME\_ATT returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The specified variable ID is not valid.
-   The new attribute name is already in use for another attribute of
    the specified variable.
-   The specified netCDF dataset is in data mode and the new name is
    longer than the old name.
-   The specified attribute does not exist.
-   The specified netCDF ID does not refer to an open netCDF dataset.



### Example

Here is an example using NF90\_RENAME\_ATT to rename the variable
attribute units to Units for a variable rh in an existing netCDF dataset
named foo.nc:




 use netcdf
 implicit none
 integer :: ncid1, status
 integer :: RHVarID         ! Variable ID
 ...
 status = nf90_open("foo.nc", nf90_nowrite, ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...
 ! Find the IDs of the variables
 status = nf90_inq_varid(ncid, "rh", RHVarID)
 if (status /= nf90_noerr) call handle_err(status)
 ...
 status = nf90_rename_att(ncid, RHVarID, "units", "Units")
 if (status /= nf90_noerr) call handle_err(status)




7.7 NF90_DEL_ATT {#f90-nf90_del_att}
------------------



The function NF90\_DEL\_ATT deletes a netCDF attribute from an open
netCDF dataset. The netCDF dataset must be in define mode.



### Usage




 function nf90_del_att(ncid, varid, name)
   integer,             intent( in) :: ncid, varid
   character (len = *), intent( in) :: name
   integer                          :: nf90_del_att




`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`varid`

:   ID of the attribute’s variable, or NF90\_GLOBAL for a
    global attribute.

`name`

:   The name of the attribute to be deleted.



### Errors

NF90\_DEL\_ATT returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The specified variable ID is not valid.
-   The specified netCDF dataset is in data mode.
-   The specified attribute does not exist.
-   The specified netCDF ID does not refer to an open netCDF dataset.



### Example

Here is an example using NF90\_DEL\_ATT to delete the variable attribute
Units for a variable rh in an existing netCDF dataset named foo.nc:




 use netcdf
 implicit none
 integer :: ncid1, status
 integer :: RHVarID         ! Variable ID
 ...
 status = nf90_open("foo.nc", nf90_nowrite, ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...
 ! Find the IDs of the variables
 status = nf90_inq_varid(ncid, "rh", RHVarID)
 if (status /= nf90_noerr) call handle_err(status)
 ...
 status = nf90_redef(ncid)   ! Enter define mode
 if (status /= nf90_noerr) call handle_err(status)
 status = nf90_del_att(ncid, RHVarID, "Units")
 if (status /= nf90_noerr) call handle_err(status)
 status = nf90_enddef(ncid)
 if (status /= nf90_noerr) call handle_err(status)







Appendix A Appendix A - Summary of Fortran 90 Interface {#f90-appendix-a-appendix-a---summary-of-fortran-90-interface .appendix}
=======================================================

Dataset Functions




 function nf90_inq_libvers()
   character(len = 80) :: nf90_inq_libvers
 function nf90_strerror(ncerr)
   integer, intent( in) :: ncerr
   character(len = 80)  :: nf90_strerror
 function nf90_create(path, cmode, ncid)
   character (len = *), intent(in   ) :: path
   integer,             intent(in   ) :: cmode
   integer, optional,   intent(in   ) :: initialsize
   integer, optional,   intent(inout) :: chunksize
   integer,             intent(  out) :: ncid
   integer                            :: nf90_create
 function nf90_open(path, mode, ncid, chunksize)
   character (len = *), intent(in   ) :: path
   integer,             intent(in   ) :: mode
   integer,             intent(  out) :: ncid
   integer, optional,   intent(inout) :: chunksize
   integer                            :: nf90_open
 function nf90_set_fill(ncid, fillmode, old_mode)
   integer, intent( in) :: ncid, fillmode
   integer, intent(out) :: old_mode
   integer              :: nf90_set_fill
 function nf90_redef(ncid)
   integer, intent( in) :: ncid
   integer              :: nf90_redef
 function nf90_enddef(ncid, h_minfree, v_align, v_minfree, r_align)
   integer,           intent( in) :: ncid
   integer, optional, intent( in) :: h_minfree, v_align, v_minfree, r_align
   integer                        :: nf90_enddef
 function nf90_sync(ncid)
   integer, intent( in) :: ncid
   integer              :: nf90_sync
 function nf90_abort(ncid)
   integer, intent( in) :: ncid
   integer              :: nf90_abort
 function nf90_close(ncid)
   integer, intent( in) :: ncid
   integer              :: nf90_close
 function nf90_Inquire(ncid, nDimensions, nVariables, nAttributes, &
                      unlimitedDimId)
   integer,           intent( in) :: ncid
   integer, optional, intent(out) :: nDimensions, nVariables, nAttributes, &  
                               unlimitedDimId
   integer                        :: nf90_Inquire




Dimension functions




 function nf90_def_dim(ncid, name, len, dimid)
   integer,             intent( in) :: ncid
   character (len = *), intent( in) :: name
   integer,             intent( in) :: len
   integer,             intent(out) :: dimid
   integer                          :: nf90_def_dim
 function nf90_inq_dimid(ncid, name, dimid)
   integer,             intent( in) :: ncid
   character (len = *), intent( in) :: name
   integer,             intent(out) :: dimid
   integer                          :: nf90_inq_dimid
 function nf90_inquire_dimension(ncid, dimid, name, len)
   integer,                       intent( in) :: ncid, dimid
   character (len = *), optional, intent(out) :: name
   integer,             optional, intent(out) :: len
   integer                                    :: nf90_inquire_dimension
 function nf90_rename_dim(ncid, dimid, name)
   integer,             intent( in) :: ncid
   character (len = *), intent( in) :: name
   integer,             intent( in) :: dimid
   integer                          :: nf90_rename_dim




Variable functions




 function nf90_def_var(ncid, name, xtype, dimids, varid)
   integer,               intent( in) :: ncid
   character (len = *),   intent( in) :: name
   integer,               intent( in) :: xtype
   integer, dimension(:), intent( in) :: dimids ! May be omitted, scalar,
                                             ! vector
   integer                            :: nf90_def_var
 function nf90_inq_varid(ncid, name, varid)
   integer,             intent( in) :: ncid
   character (len = *), intent( in) :: name
   integer,             intent(out) :: varid
   integer                          :: nf90_inq_varid
 function nf90_inquire_variable(ncid, varid, name, xtype, ndims, &
                                dimids, nAtts)
   integer,                         intent( in) :: ncid, varid
   character (len = *),   optional, intent(out) :: name
   integer,               optional, intent(out) :: xtype, ndims
   integer, dimension(*), optional, intent(out) :: dimids
   integer,               optional, intent(out) :: nAtts
   integer                                      :: nf90_inquire_variable
 function nf90_put_var(ncid, varid, values, start, stride, map)
   integer,                         intent( in) :: ncid, varid
   any valid type, scalar or array of any rank, &
                                    intent( in) :: values
   integer, dimension(:), optional, intent( in) :: start, count, stride, map
   integer                                      :: nf90_put_var
 function nf90_get_var(ncid, varid, values, start, stride, map)
   integer,                         intent( in) :: ncid, varid
   any valid type, scalar or array of any rank, &
                                    intent(out) :: values
   integer, dimension(:), optional, intent( in) :: start, count, stride, map
   integer                                      :: nf90_get_var
 function nf90_rename_var(ncid, varid, newname)
   integer,             intent( in) :: ncid, varid
   character (len = *), intent( in) :: newname
   integer                          :: nf90_rename_var




Attribute functions




 function nf90_inquire_attribute(ncid, varid, name, xtype, len, attnum)
   integer,             intent( in)           :: ncid, varid
   character (len = *), intent( in)           :: name
   integer,             intent(out), optional :: xtype, len, attnum
   integer                                    :: nf90_inquire_attribute
 function nf90_inq_attname(ncid, varid, attnum, name)
   integer,             intent( in) :: ncid, varid, attnum
   character (len = *), intent(out) :: name
   integer                          :: nf90_inq_attname
 function nf90_put_att(ncid, varid, name, values)
   integer,            intent( in) :: ncid, varid
   character(len = *), intent( in) :: name
   scalar character string or any numeric type, scalar, or array of rank 1, &
                       intent( in) :: values
   integer                         :: nf90_put_att
 function nf90_get_att(ncid, varid, name, values)
   integer,            intent( in) :: ncid, varid
   character(len = *), intent( in) :: name
   any valid type, scalar or array of rank 1, &
                       intent(out) :: values
   integer                          :: nf90_get_att
 function nf90_copy_att(ncid_in, varid_in, name, ncid_out, varid_out)
   integer,             intent( in) :: ncid_in,  varid_in
   character (len = *), intent( in) :: name
   integer,             intent( in) :: ncid_out, varid_out
   integer                          :: nf90_copy_att
 function nf90_rename_att(ncid, varid, curname, newname)
   integer,             intent( in) :: ncid,  varid
   character (len = *), intent( in) :: curname, newname
   integer                          :: nf90_rename_att
 function nf90_del_att(ncid, varid, name)
   integer,             intent( in) :: ncid, varid
   character (len = *), intent( in) :: name
   integer                          :: nf90_del_att





Appendix B Appendix B - FORTRAN 77 to Fortran 90 Transition Guide {#f90-appendix-b-appendix-b---fortran-77-to-fortran-90-transition-guide .appendix}
=================================================================





  ------------------------------------ -------------------- ------------------------------------------------------------------- --- ------------------------------------------------ --- --- --- --- ------------------------------------------- -------------- -------------------------------------- ------------------------------------
  \[[&lt;&lt;](#FORTRAN-77-to-Fortran-90-Transition-Guide "Beginning of this chapter or previous chapter")\]   \[[&lt;](#FORTRAN-77-to-Fortran-90-Transition-Guide "Previous section in reading order")\]   \[[Up](#FORTRAN-77-to-Fortran-90-Transition-Guide "Up section")\]   \[[&gt;](#Changes-to-Inquiry-functions "Next section in reading order")\]   \[[&gt;&gt;](#Combined-Index "Next chapter")\]                   \[[Top](#Top "Cover (top) of document")\]   \[Contents\]   \[[Index](#Combined-Index "Index")\]   \[[?](#SEC_About "About (help)")\]
  ------------------------------------ -------------------- ------------------------------------------------------------------- --- ------------------------------------------------ --- --- --- --- ------------------------------------------- -------------- -------------------------------------- ------------------------------------

The new Fortran 90 interface {#f90-the-new-fortran-90-interface}
----------------------------

The Fortran 90 interface to the netCDF library closely follows the
FORTRAN 77 interface. In most cases, function and constant names and
argument lists are the same, except that nf90\_ replaces nf\_ in names.
The Fortran 90 interface is much smaller than the FORTRAN 77 interface,
however. This has been accomplished by using optional arguments and
overloaded functions wherever possible.

Because FORTRAN 77 is a subset of Fortran 90, there is no reason to
modify working FORTRAN code to use the Fortran 90 interface. New code,
however, can easily be patterned after existing FORTRAN while taking
advantage of the simpler interface. Some compilers may provide
additional support when using Fortran 90. For example, compilers may
issue warnings if arguments with intent( in) are not set before they are
passed to a procedure.

The Fortran 90 interface is currently implemented as a set of wrappers
around the base FORTRAN subroutines in the netCDF distribution. Future
versions may be implemented entirely in Fortran 90, adding additional
error checking possibilities.

Changes to Inquiry functions {#f90-changes-to-inquiry-functions}
----------------------------

In the Fortran 90 interface there are two inquiry functions each for
dimensions, variables, and attributes, and a single inquiry function for
datasets. These functions take optional arguments, allowing users to
request only the information they need. These functions replace the
many-argument and single-argument inquiry functions in the FORTRAN
interface.

As an example, compare the attribute inquiry functions in the Fortran 90
interface




 function nf90_inquire_attribute(ncid, varid, name, xtype, len, attnum)
   integer,             intent( in)           :: ncid, varid
   character (len = *), intent( in)           :: name
   integer,             intent(out), optional :: xtype, len, attnum
   integer                                    :: nf90_inquire_attribute
 function nf90_inq_attname(ncid, varid, attnum, name)
   integer,             intent( in) :: ncid, varid, attnum
   character (len = *), intent(out) :: name
   integer                          :: nf90_inq_attname




with those in the FORTRAN interface




 INTEGER FUNCTION  NF_INQ_ATT        (NCID, VARID, NAME, xtype, len)
 INTEGER FUNCTION  NF_INQ_ATTID      (NCID, VARID, NAME, attnum)
 INTEGER FUNCTION  NF_INQ_ATTTYPE    (NCID, VARID, NAME, xtype)
 INTEGER FUNCTION  NF_INQ_ATTLEN     (NCID, VARID, NAME, len)
 INTEGER FUNCTION  NF_INQ_ATTNAME    (NCID, VARID, ATTNUM, name)






Changes to put and get function {#f90-changes-to-put-and-get-function}
-------------------------------

The biggest simplification in the Fortran 90 is in the nf90\_put\_var
and nf90\_get\_var functions. Both functions are overloaded: the values
argument can be a scalar or an array any rank (7 is the maximum rank
allowed by Fortran 90), and may be of any numeric type or the default
character type. The netCDF library provides transparent conversion
between the external representation of the data and the desired internal
representation.

The start, count, stride, and map arguments to nf90\_put\_var and
nf90\_get\_var are optional. By default, data is read from or written to
consecutive values of starting at the origin of the netCDF variable; the
shape of the argument determines how many values are read from or
written to each dimension. Any or all of these arguments may be supplied
to override the default behavior.

Note also that Fortran 90 allows arbitrary array sections to be passed
to any procedure, which may greatly simplify programming. For examples
see [Writing Data Values: NF90\_PUT\_VAR](#NF90_005fPUT_005fVAR) and
[Reading Data Values: NF90\_GET\_VAR](#NF90_005fGET_005fVAR).


Index {#f90-index}
=====

  ------------ -----------
  Jump to:     [**A**](#Index_cp_letter-A){.summary-letter}   [**C**](#Index_cp_letter-C){.summary-letter}   [**D**](#Index_cp_letter-D){.summary-letter}   [**E**](#Index_cp_letter-E){.summary-letter}   [**F**](#Index_cp_letter-F){.summary-letter}   [**G**](#Index_cp_letter-G){.summary-letter}   [**I**](#Index_cp_letter-I){.summary-letter}   [**L**](#Index_cp_letter-L){.summary-letter}   [**N**](#Index_cp_letter-N){.summary-letter}   [**O**](#Index_cp_letter-O){.summary-letter}   [**R**](#Index_cp_letter-R){.summary-letter}   [**U**](#Index_cp_letter-U){.summary-letter}   [**V**](#Index_cp_letter-V){.summary-letter}   [**W**](#Index_cp_letter-W){.summary-letter}  
  ------------ -----------

Index Entry

 

Section



[A]()

[attributes, adding](#index-attributes_002c-adding)

 

[1.5 Adding New Dimensions, Variables,
Attributes](#Adding-New-Dimensions)



[C]()

[common netcdf commands](#index-common-netcdf-commands)

 

[1 Use of the NetCDF Library](#Use-of-the-NetCDF-Library)

[compiling with netCDF library](#index-compiling-with-netCDF-library)

 

[1.7 Compiling and Linking with the NetCDF
Library](#Compiling-and-Linking-with-the-NetCDF-Library)

[compound types, overview](#index-compound-types_002c-overview)

 

[5.6 Compound Types Introduction](#Compound-Types)



[D]()

[dataset, creating](#index-dataset_002c-creating)

 

[1.1 Creating a NetCDF Dataset](#Creating-a-NetCDF-Dataset)

[datasets, overview](#index-datasets_002c-overview)

 

[2.1 Datasets Introduction](#Datasets-Introduction)

[dimensions, adding](#index-dimensions_002c-adding)

 

[1.5 Adding New Dimensions, Variables,
Attributes](#Adding-New-Dimensions)



[E]()

[enum type](#index-enum-type)

 

[5.9 Enum Type Introduction](#Enum-Type)

[error handling](#index-error-handling)

 

[1.6 Error Handling](#Error-Handling)



[F]()

[fill](#index-fill)

 

[6.4 Define Fill Parameters for a Variable:
`nf90_def_var_fill`](#NF90_005fDEF_005fVAR_005fFILL)



[G]()

[groups, overview](#index-groups_002c-overview)

 

[3 Groups](#Groups)



[I]()

[interface descriptions](#index-interface-descriptions)

 

[2.2 NetCDF Library Interface
Descriptions](#NetCDF-Library-Interface-Descriptions)



[L]()

[linking to netCDF library](#index-linking-to-netCDF-library)

 

[1.7 Compiling and Linking with the NetCDF
Library](#Compiling-and-Linking-with-the-NetCDF-Library)



[N]()

[nf-config](#index-nf_002dconfig)

 

[1.7 Compiling and Linking with the NetCDF
Library](#Compiling-and-Linking-with-the-NetCDF-Library)

[NF90\_ABORT](#index-NF90_005fABORT)

 

[2.12 NF90\_ABORT](#NF90_005fABORT)

[NF90\_ABORT , example](#index-NF90_005fABORT-_002c-example)

 

[2.12 NF90\_ABORT](#NF90_005fABORT)

[NF90\_CLOSE](#index-NF90_005fCLOSE)

 

[2.9 NF90\_CLOSE](#NF90_005fCLOSE)

[NF90\_CLOSE , example](#index-NF90_005fCLOSE-_002c-example)

 

[2.9 NF90\_CLOSE](#NF90_005fCLOSE)

[NF90\_CLOSE, typical use](#index-NF90_005fCLOSE_002c-typical-use)

 

[1.1 Creating a NetCDF Dataset](#Creating-a-NetCDF-Dataset)

[NF90\_COPY\_ATT](#index-NF90_005fCOPY_005fATT)

 

[7.5 Copy Attribute from One NetCDF to Another:
NF90\_COPY\_ATT](#NF90_005fCOPY_005fATT)

[NF90\_COPY\_ATT, example](#index-NF90_005fCOPY_005fATT_002c-example)

 

[7.5 Copy Attribute from One NetCDF to Another:
NF90\_COPY\_ATT](#NF90_005fCOPY_005fATT)

[NF90\_CREATE](#index-NF90_005fCREATE)

 

[2.5 NF90\_CREATE](#NF90_005fCREATE)

[NF90\_CREATE , example](#index-NF90_005fCREATE-_002c-example)

 

[2.5 NF90\_CREATE](#NF90_005fCREATE)

[NF90\_CREATE, typical use](#index-NF90_005fCREATE_002c-typical-use)

 

[1.1 Creating a NetCDF Dataset](#Creating-a-NetCDF-Dataset)

[NF90\_DEF\_COMPOUND](#index-NF90_005fDEF_005fCOMPOUND)

 

[5.6.1 Creating a Compound Type:
NF90\_DEF\_COMPOUND](#NF90_005fDEF_005fCOMPOUND)

[NF90\_DEF\_DIM](#index-NF90_005fDEF_005fDIM)

 

[4.2 NF90\_DEF\_DIM](#NF90_005fDEF_005fDIM)

[NF90\_DEF\_DIM, example](#index-NF90_005fDEF_005fDIM_002c-example)

 

[4.2 NF90\_DEF\_DIM](#NF90_005fDEF_005fDIM)

[NF90\_DEF\_DIM, typical
use](#index-NF90_005fDEF_005fDIM_002c-typical-use)

 

[1.1 Creating a NetCDF Dataset](#Creating-a-NetCDF-Dataset)

[NF90\_DEF\_ENUM](#index-NF90_005fDEF_005fENUM)

 

[5.9.1 Creating a Enum Type: NF90\_DEF\_ENUM](#NF90_005fDEF_005fENUM)

[NF90\_DEF\_GRP](#index-NF90_005fDEF_005fGRP)

 

[3.11 Create a New Group: NF90\_DEF\_GRP](#NF90_005fDEF_005fGRP)

[NF90\_DEF\_OPAQUE](#index-NF90_005fDEF_005fOPAQUE)

 

[5.8.1 Creating Opaque Types:
NF90\_DEF\_OPAQUE](#NF90_005fDEF_005fOPAQUE)

[NF90\_DEF\_VAR](#index-NF90_005fDEF_005fVAR)

 

[6.3 Create a Variable: `NF90_DEF_VAR`](#NF90_005fDEF_005fVAR)

[NF90\_DEF\_VAR, example](#index-NF90_005fDEF_005fVAR_002c-example)

 

[6.3 Create a Variable: `NF90_DEF_VAR`](#NF90_005fDEF_005fVAR)

[NF90\_DEF\_VAR, typical
use](#index-NF90_005fDEF_005fVAR_002c-typical-use)

 

[1.1 Creating a NetCDF Dataset](#Creating-a-NetCDF-Dataset)

[NF90\_DEF\_VAR\_FILL](#index-NF90_005fDEF_005fVAR_005fFILL)

 

[6.4 Define Fill Parameters for a Variable:
`nf90_def_var_fill`](#NF90_005fDEF_005fVAR_005fFILL)

[NF90\_DEF\_VLEN](#index-NF90_005fDEF_005fVLEN)

 

[5.7.1 Define a Variable Length Array (VLEN):
NF90\_DEF\_VLEN](#NF90_005fDEF_005fVLEN)

[NF90\_DEL\_ATT](#index-NF90_005fDEL_005fATT)

 

[7.7 NF90\_DEL\_ATT](#NF90_005fDEL_005fATT)

[NF90\_DEL\_ATT , example](#index-NF90_005fDEL_005fATT-_002c-example)

 

[7.7 NF90\_DEL\_ATT](#NF90_005fDEL_005fATT)

[NF90\_ENDDEF](#index-NF90_005fENDDEF)

 

[2.8 NF90\_ENDDEF](#NF90_005fENDDEF)

[NF90\_ENDDEF , example](#index-NF90_005fENDDEF-_002c-example)

 

[2.8 NF90\_ENDDEF](#NF90_005fENDDEF)

[NF90\_ENDDEF, typical use](#index-NF90_005fENDDEF_002c-typical-use)

 

[1.1 Creating a NetCDF Dataset](#Creating-a-NetCDF-Dataset)

[NF90\_FREE\_VLEN](#index-NF90_005fFREE_005fVLEN)

 

[5.7.3 Releasing Memory for a Variable Length Array (VLEN) Type:
NF90\_FREE\_VLEN](#NF90_005fFREE_005fVLEN)

[NF90\_GET\_ATT](#index-NF90_005fGET_005fATT)

 

[7.4 Get Attribute’s Values: NF90\_GET\_ATT](#NF90_005fGET_005fATT)

[NF90\_GET\_ATT, example](#index-NF90_005fGET_005fATT_002c-example)

 

[7.4 Get Attribute’s Values: NF90\_GET\_ATT](#NF90_005fGET_005fATT)

[NF90\_GET\_ATT, typical
use](#index-NF90_005fGET_005fATT_002c-typical-use)

 

[1.2 Reading a NetCDF Dataset with Known
Names](#Reading-a-NetCDF-Dataset-with-Known-Names)

[NF90\_GET\_ATT, typical
use](#index-NF90_005fGET_005fATT_002c-typical-use-1)

 

[1.3 Reading a netCDF Dataset with Unknown
Names](#Reading-a-netCDF-Dataset-with-Unknown-Names)

[NF90\_GET\_VAR](#index-NF90_005fGET_005fVAR)

 

[6.9 Reading Data Values: NF90\_GET\_VAR](#NF90_005fGET_005fVAR)

[NF90\_GET\_VAR, example](#index-NF90_005fGET_005fVAR_002c-example)

 

[6.9 Reading Data Values: NF90\_GET\_VAR](#NF90_005fGET_005fVAR)

[NF90\_GET\_VAR, typical
use](#index-NF90_005fGET_005fVAR_002c-typical-use)

 

[1.2 Reading a NetCDF Dataset with Known
Names](#Reading-a-NetCDF-Dataset-with-Known-Names)

[NF90\_GET\_VLEN\_ELEMENT](#index-NF90_005fGET_005fVLEN_005fELEMENT)

 

[5.5.2 Set a Variable Length Array with
NF90\_GET\_VLEN\_ELEMENT](#NF90_005fGET_005fVLEN_005fELEMENT)

[NF90\_INQUIRE, typical use](#index-NF90_005fINQUIRE_002c-typical-use)

 

[1.3 Reading a netCDF Dataset with Unknown
Names](#Reading-a-netCDF-Dataset-with-Unknown-Names)

[NF90\_INQUIRE\_ATTRIBUTE](#index-NF90_005fINQUIRE_005fATTRIBUTE)

 

[7.3 Get Information about an Attribute: NF90\_INQUIRE\_ATTRIBUTE and
NF90\_INQ\_ATTNAME](#NF90_005fINQUIRE_005fATTRIBUTE)

[NF90\_INQUIRE\_ATTRIBUTE,
example](#index-NF90_005fINQUIRE_005fATTRIBUTE_002c-example)

 

[7.3 Get Information about an Attribute: NF90\_INQUIRE\_ATTRIBUTE and
NF90\_INQ\_ATTNAME](#NF90_005fINQUIRE_005fATTRIBUTE)

[NF90\_INQUIRE\_ATTRIBUTE, typical
use](#index-NF90_005fINQUIRE_005fATTRIBUTE_002c-typical-use)

 

[1.3 Reading a netCDF Dataset with Unknown
Names](#Reading-a-netCDF-Dataset-with-Unknown-Names)

[NF90\_INQUIRE\_DIMENSION](#index-NF90_005fINQUIRE_005fDIMENSION)

 

[4.4 NF90\_INQUIRE\_DIMENSION](#NF90_005fINQUIRE_005fDIMENSION)

[NF90\_INQUIRE\_DIMENSION ,
example](#index-NF90_005fINQUIRE_005fDIMENSION-_002c-example)

 

[4.4 NF90\_INQUIRE\_DIMENSION](#NF90_005fINQUIRE_005fDIMENSION)

[NF90\_INQUIRE\_DIMENSION, typical
use](#index-NF90_005fINQUIRE_005fDIMENSION_002c-typical-use)

 

[1.3 Reading a netCDF Dataset with Unknown
Names](#Reading-a-netCDF-Dataset-with-Unknown-Names)

[NF90\_INQUIRE\_VARIABLE](#index-NF90_005fINQUIRE_005fVARIABLE)

 

[6.6 Get Information about a Variable from Its ID:
NF90\_INQUIRE\_VARIABLE](#NF90_005fINQUIRE_005fVARIABLE)

[NF90\_INQUIRE\_VARIABLE ,
example](#index-NF90_005fINQUIRE_005fVARIABLE-_002c-example)

 

[6.6 Get Information about a Variable from Its ID:
NF90\_INQUIRE\_VARIABLE](#NF90_005fINQUIRE_005fVARIABLE)

[NF90\_INQUIRE\_VARIABLE, typical
use](#index-NF90_005fINQUIRE_005fVARIABLE_002c-typical-use)

 

[1.3 Reading a netCDF Dataset with Unknown
Names](#Reading-a-netCDF-Dataset-with-Unknown-Names)

[NF90\_INQ\_ATTNAME](#index-NF90_005fINQ_005fATTNAME)

 

[7.3 Get Information about an Attribute: NF90\_INQUIRE\_ATTRIBUTE and
NF90\_INQ\_ATTNAME](#NF90_005fINQUIRE_005fATTRIBUTE)

[NF90\_INQ\_ATTNAME,
example](#index-NF90_005fINQ_005fATTNAME_002c-example)

 

[7.3 Get Information about an Attribute: NF90\_INQUIRE\_ATTRIBUTE and
NF90\_INQ\_ATTNAME](#NF90_005fINQUIRE_005fATTRIBUTE)

[NF90\_INQ\_ATTNAME, typical
use](#index-NF90_005fINQ_005fATTNAME_002c-typical-use)

 

[1.3 Reading a netCDF Dataset with Unknown
Names](#Reading-a-netCDF-Dataset-with-Unknown-Names)

[NF90\_INQ\_CMP\_FIELDDIM\_SIZES](#index-NF90_005fINQ_005fCMP_005fFIELDDIM_005fSIZES)

 

[5.6.5 Learn About a Field of a Compound Type:
NF90\_INQ\_COMPOUND\_FIELD](#NF90_005fINQ_005fCOMPOUND_005fFIELD)

[NF90\_INQ\_COMPOUND](#index-NF90_005fINQ_005fCOMPOUND)

 

[5.6.4 Learn About a Compound Type:
NF90\_INQ\_COMPOUND](#NF90_005fINQ_005fCOMPOUND)

[NF90\_INQ\_COMPOUND\_FIELD](#index-NF90_005fINQ_005fCOMPOUND_005fFIELD)

 

[5.6.5 Learn About a Field of a Compound Type:
NF90\_INQ\_COMPOUND\_FIELD](#NF90_005fINQ_005fCOMPOUND_005fFIELD)

[NF90\_INQ\_COMPOUND\_FIELDINDEX](#index-NF90_005fINQ_005fCOMPOUND_005fFIELDINDEX)

 

[5.6.5 Learn About a Field of a Compound Type:
NF90\_INQ\_COMPOUND\_FIELD](#NF90_005fINQ_005fCOMPOUND_005fFIELD)

[NF90\_INQ\_COMPOUND\_FIELDNAME](#index-NF90_005fINQ_005fCOMPOUND_005fFIELDNAME)

 

[5.6.5 Learn About a Field of a Compound Type:
NF90\_INQ\_COMPOUND\_FIELD](#NF90_005fINQ_005fCOMPOUND_005fFIELD)

[NF90\_INQ\_COMPOUND\_FIELDNDIMS](#index-NF90_005fINQ_005fCOMPOUND_005fFIELDNDIMS)

 

[5.6.5 Learn About a Field of a Compound Type:
NF90\_INQ\_COMPOUND\_FIELD](#NF90_005fINQ_005fCOMPOUND_005fFIELD)

[NF90\_INQ\_COMPOUND\_FIELDOFFSET](#index-NF90_005fINQ_005fCOMPOUND_005fFIELDOFFSET)

 

[5.6.5 Learn About a Field of a Compound Type:
NF90\_INQ\_COMPOUND\_FIELD](#NF90_005fINQ_005fCOMPOUND_005fFIELD)

[NF90\_INQ\_COMPOUND\_FIELDTYPE](#index-NF90_005fINQ_005fCOMPOUND_005fFIELDTYPE)

 

[5.6.5 Learn About a Field of a Compound Type:
NF90\_INQ\_COMPOUND\_FIELD](#NF90_005fINQ_005fCOMPOUND_005fFIELD)

[NF90\_INQ\_COMPOUND\_NAME](#index-NF90_005fINQ_005fCOMPOUND_005fNAME)

 

[5.6.4 Learn About a Compound Type:
NF90\_INQ\_COMPOUND](#NF90_005fINQ_005fCOMPOUND)

[NF90\_INQ\_COMPOUND\_NFIELDS](#index-NF90_005fINQ_005fCOMPOUND_005fNFIELDS)

 

[5.6.4 Learn About a Compound Type:
NF90\_INQ\_COMPOUND](#NF90_005fINQ_005fCOMPOUND)

[NF90\_INQ\_COMPOUND\_SIZE](#index-NF90_005fINQ_005fCOMPOUND_005fSIZE)

 

[5.6.4 Learn About a Compound Type:
NF90\_INQ\_COMPOUND](#NF90_005fINQ_005fCOMPOUND)

[NF90\_INQ\_DIMID](#index-NF90_005fINQ_005fDIMID)

 

[4.3 NF90\_INQ\_DIMID](#NF90_005fINQ_005fDIMID)

[NF90\_INQ\_DIMID ,
example](#index-NF90_005fINQ_005fDIMID-_002c-example)

 

[4.3 NF90\_INQ\_DIMID](#NF90_005fINQ_005fDIMID)

[NF90\_INQ\_DIMID, typical
use](#index-NF90_005fINQ_005fDIMID_002c-typical-use)

 

[1.2 Reading a NetCDF Dataset with Known
Names](#Reading-a-NetCDF-Dataset-with-Known-Names)

[NF90\_INQ\_DIMIDS](#index-NF90_005fINQ_005fDIMIDS)

 

[3.4 Find all Dimensions Visible in a Group:
NF90\_INQ\_DIMIDS](#NF90_005fINQ_005fDIMIDS)

[NF90\_INQ\_ENUM](#index-NF90_005fINQ_005fENUM)

 

[5.9.3 Learn About a Enum Type: NF90\_INQ\_ENUM](#NF90_005fINQ_005fENUM)

[NF90\_INQ\_ENUM\_IDENT](#index-NF90_005fINQ_005fENUM_005fIDENT)

 

[5.9.5 Learn the Name of a Enum Type:
NF90\_INQ\_ENUM\_IDENT](#NF90_005fINQ_005fENUM_005fIDENT)

[nf90\_inq\_enum\_member](#index-nf90_005finq_005fenum_005fmember)

 

[5.9.4 Learn the Name of a Enum Type:
nf90\_inq\_enum\_member](#NF90_005fINQ_005fENUM_005fMEMBER)

[NF90\_INQ\_GRPNAME](#index-NF90_005fINQ_005fGRPNAME)

 

[3.6 Find a Group’s Name: NF90\_INQ\_GRPNAME](#NF90_005fINQ_005fGRPNAME)

[NF90\_INQ\_GRPNAME\_FULL](#index-NF90_005fINQ_005fGRPNAME_005fFULL)

 

[3.7 Find a Group’s Full Name:
NF90\_INQ\_GRPNAME\_FULL](#NF90_005fINQ_005fGRPNAME_005fFULL)

[NF90\_INQ\_GRPNAME\_LEN](#index-NF90_005fINQ_005fGRPNAME_005fLEN)

 

[3.5 Find the Length of a Group’s Full Name:
NF90\_INQ\_GRPNAME\_LEN](#NF90_005fINQ_005fGRPNAME_005fLEN)

[NF90\_INQ\_GRPS](#index-NF90_005fINQ_005fGRPS)

 

[3.2 Get a List of Groups in a Group:
NF90\_INQ\_GRPS](#NF90_005fINQ_005fGRPS)

[NF90\_INQ\_GRP\_PARENT](#index-NF90_005fINQ_005fGRP_005fPARENT)

 

[3.8 Find a Group’s Parent:
NF90\_INQ\_GRP\_PARENT](#NF90_005fINQ_005fGRP_005fPARENT)

[NF90\_INQ\_GRP\_PARENT](#index-NF90_005fINQ_005fGRP_005fPARENT-1)

 

[3.9 Find a Group by Name:
NF90\_INQ\_GRP\_NCID](#NF90_005fINQ_005fGRP_005fNCID)

[NF90\_INQ\_GRP\_PARENT](#index-NF90_005fINQ_005fGRP_005fPARENT-2)

 

[3.10 Find a Group by its Fully-qualified Name:
NF90\_INQ\_GRP\_FULL\_NCID](#NF90_005fINQ_005fGRP_005fFULL_005fNCID)

[NF90\_INQ\_LIBVERS](#index-NF90_005fINQ_005fLIBVERS)

 

[2.4 Get netCDF library version:
NF90\_INQ\_LIBVERS](#NF90_005fINQ_005fLIBVERS)

[NF90\_INQ\_LIBVERS,
example](#index-NF90_005fINQ_005fLIBVERS_002c-example)

 

[2.4 Get netCDF library version:
NF90\_INQ\_LIBVERS](#NF90_005fINQ_005fLIBVERS)

[NF90\_INQ\_NCID](#index-NF90_005fINQ_005fNCID)

 

[3.1 Find a Group ID: NF90\_INQ\_NCID](#NF90_005fINQ_005fNCID)

[NF90\_INQ\_OPAQUE](#index-NF90_005fINQ_005fOPAQUE)

 

[5.8.2 Learn About an Opaque Type:
NF90\_INQ\_OPAQUE](#NF90_005fINQ_005fOPAQUE)

[NF90\_INQ\_TYPE](#index-NF90_005fINQ_005fTYPE)

 

[5.4 Learn About a User Defined Type:
NF90\_INQ\_TYPE](#NF90_005fINQ_005fTYPE)

[nf90\_inq\_typeid](#index-nf90_005finq_005ftypeid)

 

[5.3 Find a Typeid from Group and Name:
nf90\_inq\_typeid](#nf90_005finq_005ftypeid)

[NF90\_INQ\_TYPEIDS](#index-NF90_005fINQ_005fTYPEIDS)

 

[5.2 Learn the IDs of All Types in Group:
NF90\_INQ\_TYPEIDS](#NF90_005fINQ_005fTYPEIDS)

[NF90\_INQ\_USER\_TYPE](#index-NF90_005fINQ_005fUSER_005fTYPE)

 

[5.5 Learn About a User Defined Type:
NF90\_INQ\_USER\_TYPE](#NF90_005fINQ_005fUSER_005fTYPE)

[NF90\_INQ\_VARID](#index-NF90_005fINQ_005fVARID)

 

[6.7 Get the ID of a variable from the name:
NF90\_INQ\_VARID](#NF90_005fINQ_005fVARID)

[NF90\_INQ\_VARID, example](#index-NF90_005fINQ_005fVARID_002c-example)

 

[6.7 Get the ID of a variable from the name:
NF90\_INQ\_VARID](#NF90_005fINQ_005fVARID)

[NF90\_INQ\_VARID, typical
use](#index-NF90_005fINQ_005fVARID_002c-typical-use)

 

[1.2 Reading a NetCDF Dataset with Known
Names](#Reading-a-NetCDF-Dataset-with-Known-Names)

[NF90\_INQ\_VARID, typical
use](#index-NF90_005fINQ_005fVARID_002c-typical-use-1)

 

[1.4 Writing Data in an Existing NetCDF
Dataset](#Writing-Data-in-an-Existing-NetCDF-Dataset)

[NF90\_INQ\_VARIDS](#index-NF90_005fINQ_005fVARIDS)

 

[3.3 Find all the Variables in a Group:
NF90\_INQ\_VARIDS](#NF90_005fINQ_005fVARIDS)

[NF90\_INQ\_VAR\_FILL](#index-NF90_005fINQ_005fVAR_005fFILL)

 

[6.5 Learn About Fill Parameters for a Variable:
`NF90_INQ_VAR_FILL`](#NF90_005fINQ_005fVAR_005fFILL)

[NF90\_INQ\_VLEN](#index-NF90_005fINQ_005fVLEN)

 

[5.7.2 Learning about a Variable Length Array (VLEN) Type:
NF90\_INQ\_VLEN](#NF90_005fINQ_005fVLEN)

[NF90\_INSERT\_ARRAY\_COMPOUND](#index-NF90_005fINSERT_005fARRAY_005fCOMPOUND)

 

[5.6.3 Inserting an Array Field into a Compound Type:
NF90\_INSERT\_ARRAY\_COMPOUND](#NF90_005fINSERT_005fARRAY_005fCOMPOUND)

[NF90\_INSERT\_COMPOUND](#index-NF90_005fINSERT_005fCOMPOUND)

 

[5.6.2 Inserting a Field into a Compound Type:
NF90\_INSERT\_COMPOUND](#NF90_005fINSERT_005fCOMPOUND)

[NF90\_INSERT\_ENUM](#index-NF90_005fINSERT_005fENUM)

 

[5.9.2 Inserting a Field into a Enum Type:
NF90\_INSERT\_ENUM](#NF90_005fINSERT_005fENUM)

[NF90\_OPEN](#index-NF90_005fOPEN)

 

[2.6 NF90\_OPEN](#NF90_005fOPEN)

[NF90\_OPEN , example](#index-NF90_005fOPEN-_002c-example)

 

[2.6 NF90\_OPEN](#NF90_005fOPEN)

[NF90\_OPEN, typical use](#index-NF90_005fOPEN_002c-typical-use)

 

[1.2 Reading a NetCDF Dataset with Known
Names](#Reading-a-NetCDF-Dataset-with-Known-Names)

[NF90\_PUT\_ATT](#index-NF90_005fPUT_005fATT)

 

[7.2 Create an Attribute: NF90\_PUT\_ATT](#NF90_005fPUT_005fATT)

[NF90\_PUT\_ATT, example](#index-NF90_005fPUT_005fATT_002c-example)

 

[7.2 Create an Attribute: NF90\_PUT\_ATT](#NF90_005fPUT_005fATT)

[NF90\_PUT\_ATT, typical
use](#index-NF90_005fPUT_005fATT_002c-typical-use)

 

[1.1 Creating a NetCDF Dataset](#Creating-a-NetCDF-Dataset)

[NF90\_PUT\_ATT, typical
use](#index-NF90_005fPUT_005fATT_002c-typical-use-1)

 

[1.4 Writing Data in an Existing NetCDF
Dataset](#Writing-Data-in-an-Existing-NetCDF-Dataset)

[NF90\_PUT\_VAR](#index-NF90_005fPUT_005fVAR)

 

[6.8 Writing Data Values: NF90\_PUT\_VAR](#NF90_005fPUT_005fVAR)

[NF90\_PUT\_VAR, example](#index-NF90_005fPUT_005fVAR_002c-example)

 

[6.8 Writing Data Values: NF90\_PUT\_VAR](#NF90_005fPUT_005fVAR)

[NF90\_PUT\_VAR, typical
use](#index-NF90_005fPUT_005fVAR_002c-typical-use)

 

[1.1 Creating a NetCDF Dataset](#Creating-a-NetCDF-Dataset)

[NF90\_PUT\_VAR, typical
use](#index-NF90_005fPUT_005fVAR_002c-typical-use-1)

 

[1.4 Writing Data in an Existing NetCDF
Dataset](#Writing-Data-in-an-Existing-NetCDF-Dataset)

[NF90\_PUT\_VLEN\_ELEMENT](#index-NF90_005fPUT_005fVLEN_005fELEMENT)

 

[5.5.1 Set a Variable Length Array with
NF90\_PUT\_VLEN\_ELEMENT](#NF90_005fPUT_005fVLEN_005fELEMENT)

[NF90\_REDEF](#index-NF90_005fREDEF)

 

[2.7 NF90\_REDEF](#NF90_005fREDEF)

[NF90\_REDEF , example](#index-NF90_005fREDEF-_002c-example)

 

[2.7 NF90\_REDEF](#NF90_005fREDEF)

[NF90\_REDEF, typical use](#index-NF90_005fREDEF_002c-typical-use)

 

[1.5 Adding New Dimensions, Variables,
Attributes](#Adding-New-Dimensions)

[NF90\_RENAME\_ATT](#index-NF90_005fRENAME_005fATT)

 

[7.6 Rename an Attribute: NF90\_RENAME\_ATT](#NF90_005fRENAME_005fATT)

[NF90\_RENAME\_ATT,
example](#index-NF90_005fRENAME_005fATT_002c-example)

 

[7.6 Rename an Attribute: NF90\_RENAME\_ATT](#NF90_005fRENAME_005fATT)

[NF90\_RENAME\_DIM](#index-NF90_005fRENAME_005fDIM)

 

[4.5 NF90\_RENAME\_DIM](#NF90_005fRENAME_005fDIM)

[NF90\_RENAME\_DIM ,
example](#index-NF90_005fRENAME_005fDIM-_002c-example)

 

[4.5 NF90\_RENAME\_DIM](#NF90_005fRENAME_005fDIM)

[NF90\_RENAME\_VAR](#index-NF90_005fRENAME_005fVAR)

 

[6.12 NF90\_RENAME\_VAR](#NF90_005fRENAME_005fVAR)

[NF90\_RENAME\_VAR ,
example](#index-NF90_005fRENAME_005fVAR-_002c-example)

 

[6.12 NF90\_RENAME\_VAR](#NF90_005fRENAME_005fVAR)

[NF90\_SET\_FILL](#index-NF90_005fSET_005fFILL)

 

[2.13 NF90\_SET\_FILL](#NF90_005fSET_005fFILL)

[NF90\_SET\_FILL , example](#index-NF90_005fSET_005fFILL-_002c-example)

 

[2.13 NF90\_SET\_FILL](#NF90_005fSET_005fFILL)

[NF90\_STRERROR](#index-NF90_005fSTRERROR)

 

[2.3 NF90\_STRERROR](#NF90_005fSTRERROR)

[NF90\_STRERROR, example](#index-NF90_005fSTRERROR_002c-example)

 

[2.3 NF90\_STRERROR](#NF90_005fSTRERROR)

[NF90\_STRERROR,
introduction](#index-NF90_005fSTRERROR_002c-introduction)

 

[1.6 Error Handling](#Error-Handling)

[NF90\_SYNC](#index-NF90_005fSYNC)

 

[2.11 NF90\_SYNC](#NF90_005fSYNC)

[NF90\_SYNC , example](#index-NF90_005fSYNC-_002c-example)

 

[2.11 NF90\_SYNC](#NF90_005fSYNC)

[NF90\_VAR\_PAR\_ACCESS](#index-NF90_005fVAR_005fPAR_005fACCESS)

 

[6.13 Change between Collective and Independent Parallel Access:
NF90\_VAR\_PAR\_ACCESS](#NF90_005fVAR_005fPAR_005fACCESS)

[NF90\_VAR\_PAR\_ACCESS,
example](#index-NF90_005fVAR_005fPAR_005fACCESS_002c-example)

 

[6.13 Change between Collective and Independent Parallel Access:
NF90\_VAR\_PAR\_ACCESS](#NF90_005fVAR_005fPAR_005fACCESS)



[O]()

[opaque type](#index-opaque-type)

 

[5.8 Opaque Type Introduction](#Opaque-Type)



[R]()

[reading dataset with unknown
names](#index-reading-dataset-with-unknown-names)

 

[1.3 Reading a netCDF Dataset with Unknown
Names](#Reading-a-netCDF-Dataset-with-Unknown-Names)



[U]()

[user defined types](#index-user-defined-types)

 

[5 User Defined Data Types](#User-Defined-Data-Types)

[user defined types, overview](#index-user-defined-types_002c-overview)

 

[5.1 User Defined Types Introduction](#User-Defined-Types)

[users’ guide, netcdf](#index-users_0027-guide_002c-netcdf)

 

[1 Use of the NetCDF Library](#Use-of-the-NetCDF-Library)



[V]()

[variable length array type,
overview](#index-variable-length-array-type_002c-overview)

 

[5 User Defined Data Types](#User-Defined-Data-Types)

[variable length arrays](#index-variable-length-arrays)

 

[5.7 Variable Length Array Introduction](#Variable-Length-Array)

[variables, adding](#index-variables_002c-adding)

 

[1.5 Adding New Dimensions, Variables,
Attributes](#Adding-New-Dimensions)

[variables, fill](#index-variables_002c-fill)

 

[6.4 Define Fill Parameters for a Variable:
`nf90_def_var_fill`](#NF90_005fDEF_005fVAR_005fFILL)

[VLEN](#index-VLEN)

 

[5.7 Variable Length Array Introduction](#Variable-Length-Array)

[VLEN, defining](#index-VLEN_002c-defining)

 

[5.7.1 Define a Variable Length Array (VLEN):
NF90\_DEF\_VLEN](#NF90_005fDEF_005fVLEN)

[VLEN, defining](#index-VLEN_002c-defining-1)

 

[5.7.2 Learning about a Variable Length Array (VLEN) Type:
NF90\_INQ\_VLEN](#NF90_005fINQ_005fVLEN)

[VLEN, defining](#index-VLEN_002c-defining-2)

 

[5.7.3 Releasing Memory for a Variable Length Array (VLEN) Type:
NF90\_FREE\_VLEN](#NF90_005fFREE_005fVLEN)



[W]()

[writing to existing dataset](#index-writing-to-existing-dataset)

 

[1.4 Writing Data in an Existing NetCDF
Dataset](#Writing-Data-in-an-Existing-NetCDF-Dataset)
