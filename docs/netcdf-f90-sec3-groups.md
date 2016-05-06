3 Groups {#f90_groups}
========

[TOC]

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
[NF90_CREATE](#NF90_005fCREATE)). Groups are not compatible with the
netCDF classic data model, so files created with the
NF90\_CLASSIC\_MODEL file cannot contain groups (except the root group).


3.1 Find a Group ID: NF90_INQ_NCID {#f90-find-a-group-id-nf90_inq_ncid}
=========================

Given an ncid and group name (NULL or "" gets root group), return ncid
of the named group.

## Usage


~~~~.fortran


  function nf90_inq_ncid(ncid, name, grp_ncid)
    integer, intent(in) :: ncid
    character (len = *), intent(in) :: name
    integer, intent(out) :: grp_ncid
    integer :: nf90_inq_ncid


~~~~


`NCID`

:   The group id for this operation.

`NAME`

:   A character array that holds the name of the desired group. Must be
    less then NF90\_MAX\_NAME.

`GRPID`

:   The ID of the group will go here.



## Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



## Example

This example is from nf90\_test/ftst\_groups.F.


3.2 Get a List of Groups in a Group: NF90_INQ_GRPS {#f90-get-a-list-of-groups-in-a-group-nf90_inq_grps}
=========================



Given a location id, return the number of groups it contains, and an
array of their ncids.



## Usage

~~~~.fortran



  function nf90_inq_grps(ncid, numgrps, ncids)
    integer, intent(in) :: ncid
    integer, intent(out) :: numgrps
    integer, intent(out) :: ncids
    integer :: nf90_inq_grps



~~~~

`NCID`

:   The group id for this operation.

`NUMGRPS`

:   An integer which will get number of groups in this group.

`NCIDS`

:   An array of ints which will receive the IDs of all the groups in
    this group.



## Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



## Example

3.3 Find all the Variables in a Group: NF90_INQ_VARIDS {#f90-find-all-the-variables-in-a-group-nf90_inq_varids}
=========================

Find all varids for a location.



## Usage


~~~~.fortran


  function nf90_inq_varids(ncid, nvars, varids)
    integer, intent(in) :: ncid
    integer, intent(out) :: nvars
    integer, intent(out) :: varids
    integer :: nf90_inq_varids


~~~~


`NCID`

:   The group id for this operation.

`VARIDS`

:   An already allocated array to store the list of varids. Use
    nf90\_inq\_nvars to find out how many variables there are. (see
    section [Get Information about a Variable from Its ID:
    NF90_INQUIRE_VARIABLE](#NF90_005fINQUIRE_005fVARIABLE)).



## Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



## Example

3.4 Find all Dimensions Visible in a Group: NF90_INQ_DIMIDS {#f90-find-all-dimensions-visible-in-a-group-nf90_inq_dimids}
=========================



Find all dimids for a location. This finds all dimensions in a group, or
any of its parents.



## Usage


~~~~.fortran


  function nf90_inq_dimids(ncid, ndims, dimids, include_parents)
    integer, intent(in) :: ncid
    integer, intent(out) :: ndims
    integer, intent(out) :: dimids
    integer, intent(out) :: include_parents
    integer :: nf90_inq_dimids


~~~~


`NCID`

:   The group id for this operation.

`NDIMS`

:   Returned number of dimensions for this location. If include\_parents
    is non-zero, number of dimensions visible from this group, which
    includes dimensions in parent groups.

`DIMIDS`

:   An array of ints when the dimids of the visible dimensions will
    be stashed. Use nf90\_inq\_ndims to find out how many dims are
    visible from this group. (see section [Get Information about a Variable from Its ID: NF90_INQUIRE_VARIABLE](#f90-get-information-about-a-variable-from-its-id-nf90_inquire_variable) ).

`INCLUDE_PARENTS`

:   If zero, only the group specified by NCID will be searched
    for dimensions. Otherwise parent groups will be searched too.



## Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



## Example

3.5 Find the Length of a Group’s Full Name: NF90_INQ_GRPNAME_LEN {#f90-find-the-length-of-a-groups-full-name-nf90_inq_grpname_len}
=========================

Given ncid, find length of the full name. (Root group is named "/", with
length 1.)

## Usage


~~~~.fortran


  function nf90_inq_grpname_len(ncid, len)
    integer, intent(in) :: ncid
    integer, intent(out) :: len
    integer :: nf90_inq_grpname_len
  end function nf90_inq_grpname_len


~~~~


`NCID`

:   The group id for this operation.

`LEN`

:   An integer where the length will be placed.



## Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



## Example


3.6 Find a Group’s Name: NF90_INQ_GRPNAME {#f90-find-a-groups-name-nf90_inq_grpname}
=========================



Given ncid, find relative name of group. (Root group is named "/").

The name provided by this function is relative to the parent group. For
a full path name for the group is, with all parent groups included,
separated with a forward slash (as in Unix directory names) See section
[Find a Group’s Full Name:
NF90_INQ_GRPNAME_FULL](#f90-find-a-groups-full-name-nf90_inq_grpname_full).



## Usage



~~~~.fortran

  function nf90_inq_grpname(ncid, name)
    integer, intent(in) :: ncid
    character (len = *), intent(out) :: name
    integer :: nf90_inq_grpname


~~~~


`NCID`

:   The group id for this operation.

`NAME`

:   The name of the group will be copied to this character array. The
    name will be less than NF90\_MAX\_NAME in length.



## Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



## Example


3.7 Find a Group’s Full Name: NF90_INQ_GRPNAME_FULL {#f90-find-a-groups-full-name-nf90_inq_grpname_full}
=========================



Given ncid, find complete name of group. (Root group is named "/").

The name provided by this function is a full path name for the group is,
with all parent groups included, separated with a forward slash (as in
Unix directory names). For a name relative to the parent group See
section [Find a Group’s Name:
NF90_INQ_GRPNAME](#f90-find-a-groups-name-nf90_inq_grpname).

## Usage


~~~~.fortran


  function nf90_inq_grpname_full(ncid, len, name)
    integer, intent(in) :: ncid
    integer, intent(out) :: len
    character (len = *), intent(out) :: name
    integer :: nf90_inq_grpname_full


~~~~


`NCID`

:   The group id for this operation.

`LEN`

:   The length of the full group name will go here.

`NAME`

:   The name of the group will be copied to this character array.



## Errors

`NF90_NOERR`

:   No error.

`NF90_EBADID`

:   Bad group id.

`NF90_ENOTNC4`

:   Attempting a netCDF-4 operation on a netCDF-3 file. NetCDF-4
    operations can only be performed on files defined with a create mode
    which includes flag HDF5. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



## Example

This example is from test program nf\_test/f90tst\_grps.f90.


~~~~.fortran


  call check(nf90_inq_grpname_full(grpid1, len, name_in))
  if (name_in .ne. grp1_full_name) stop 62

~~~~



3.8 Find a Group’s Parent: NF90_INQ_GRP_PARENT {#f90-find-a-groups-parent-nf90_inq_grp_parent}
=========================



Given ncid, find the ncid of the parent group.

When used with the root group, this function returns the NF90\_ENOGRP
error (since the root group h has no parent.)



## Usage

~~~~.fortran



  function nf90_inq_grp_parent(ncid, parent_ncid)
    integer, intent(in) :: ncid
    integer, intent(out) :: parent_ncid
    integer :: nf90_inq_grp_parent


~~~~


`NCID`

:   The group id.

`PARENT_NCID`

:   The ncid of the parent group will be copied here.



## Errors

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
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



## Example

3.9 Find a Group by Name: NF90_INQ_GRP_NCID {#f90-find-a-group-by-name-nf90_inq_grp_ncid}
=========================

Given a group name an an ncid, find the ncid of the group id.

## Usage


~~~~.fortran


  function nf90_inq_grp_ncid(ncid, name, grpid)
    integer, intent(in) :: ncid
    character (len = *), intent(in) :: name
    integer, intent(out) :: grpid
    integer :: nf90_inq_grp_ncid

    nf90_inq_grp_ncid = nf_inq_grp_ncid(ncid, name, grpid)
  end function nf90_inq_grp_ncid

~~~~



`NCID`

:   The group id to look in.

`GRP_NAME`

:   The name of the group that should be found.

`GRP_NCID`

:   This will get the group id, if it is found.



## Return Codes


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
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



## Example

This example is from test program nf\_test/f90tst\_grps.f90.


~~~~.fortran


  ! Get the group ids for the newly reopened file.
  call check(nf90_inq_grp_ncid(ncid, GRP1_NAME, grpid1))
  call check(nf90_inq_grp_ncid(grpid1, GRP2_NAME, grpid2))
  call check(nf90_inq_grp_ncid(grpid2, GRP3_NAME, grpid3))
  call check(nf90_inq_grp_ncid(grpid3, GRP4_NAME, grpid4))


~~~~


3.10 Find a Group by its Fully-qualified Name: NF90_INQ_GRP_FULL_NCID {#f90-find-a-group-by-its-fully-qualified-name-nf90_inq_grp_full_ncid}
=========================
Given a fully qualified group name an an ncid, find the ncid of the
group id.



## Usage


~~~~.fortran


  function nf90_inq_grpname_full(ncid, len, name)
    integer, intent(in) :: ncid
    integer, intent(out) :: len
    character (len = *), intent(out) :: name
    integer :: nf90_inq_grpname_full

    nf90_inq_grpname_full = nf_inq_grpname_full(ncid, len, name)
  end function nf90_inq_grpname_full


~~~~


`NCID`

:   The group id to look in.

`FULL_NAME`

:   The fully-qualified group name.

`GRP_NCID`

:   This will get the group id, if it is found.



## Return Codes

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
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



## Example

This example is from test program nf\_test/tstf90\_grps.f90.


~~~~.fortran


  ! Check for the groups with full group names.
  write(grp1_full_name, '(AA)') '/', GRP1_NAME
  call check(nf90_inq_grp_full_ncid(ncid, grp1_full_name, grpid1))


~~~~


3.11 Create a New Group: NF90_DEF_GRP {#f90-create-a-new-group-nf90_def_grp}
=========================



Create a group. Its location id is returned in new\_ncid.



## Usage


~~~~.fortran


  function nf90_def_grp(parent_ncid, name, new_ncid)
    integer, intent(in) :: parent_ncid
    character (len = *), intent(in) :: name
    integer, intent(out) :: new_ncid
    integer :: nf90_def_grp



~~~~

`PARENT_NCID`

:   The group id of the parent group.

`NAME`

:   The name of the new group, which must be different from the name of
    any variable within the same parent group.

`NEW_NCID`

:   The ncid of the new group will be placed there.



## Errors

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
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_ESTRICTNC3`

:   This file was created with the strict netcdf-3 flag, therefore
    netcdf-4 operations are not allowed. (see section
    [NF90_OPEN](#NF90_005fOPEN)).

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.

`NF90_EPERM`

:   Attempt to write to a read-only file.

`NF90_ENOTINDEFINE`

:   Not in define mode.



## Example


~~~~.fortran


C     Create the netCDF file.
      retval = nf90_create(file_name, NF90_NETCDF4, ncid)
      if (retval .ne. nf90_noerr) call handle_err(retval)

C     Create a group and a subgroup.
      retval = nf90_def_grp(ncid, group_name, grpid)
      if (retval .ne. nf90_noerr) call handle_err(retval)
      retval = nf90_def_grp(grpid, sub_group_name, sub_grpid)
      if (retval .ne. nf90_noerr) call handle_err(retval)

~~~~
