2 Datasets {#f90_datasets}
===========================

[TOC]

2.1 Datasets Introduction {#f90-datasets-introduction}
=========================

This chapter presents the interfaces of the netCDF functions that deal
with a netCDF dataset or the whole netCDF library.

A netCDF dataset that has not yet been opened can only be referred to by
its dataset name. Once a netCDF dataset is opened, it is referred to by
a netCDF ID, which is a small nonnegative integer returned when you
create or open the dataset. A netCDF ID is much like a file descriptor
in C or a logical unit number in FORTRAN. In any single program, the
netCDF IDs of distinct open netCDF datasets are distinct. A single
netCDF dataset may be opened multiple times and will then have multiple
distinct netCDF IDs; however at most one of the open instances of a
single netCDF dataset should permit writing. When an open netCDF dataset
is closed, the ID is no longer associated with a netCDF dataset.

Functions that deal with the netCDF library include:

-   Get version of library.
-   Get error message corresponding to a returned error code.

The operations supported on a netCDF dataset as a single object are:

-   Create, given dataset name and whether to overwrite or not.
-   Open for access, given dataset name and read or write intent.
-   Put into define mode, to add dimensions, variables, or attributes.
-   Take out of define mode, checking consistency of additions.
-   Close, writing to disk if required.
-   Inquire about the number of dimensions, number of variables, number
    of global attributes, and ID of the unlimited dimension, if any.
-   Synchronize to disk to make sure it is current.
-   Set and unset nofill mode for optimized sequential writes.
-   After a summary of conventions used in describing the netCDF
    interfaces, the rest of this chapter presents a detailed description
    of the interfaces for these operations.

2.2 NetCDF Library Interface Descriptions {#f90-netcdf-library-interface-descriptions}
=========================

Each interface description for a particular netCDF function in this and
later chapters contains:

-   a description of the purpose of the function;
-   a Fortran 90 interface block that presents the type and order of the
    formal parameters to the function;
-   a description of each formal parameter in the C interface;
-   a list of possible error conditions; and
-   an example of a Fortran 90 program fragment calling the netCDF
    function (and perhaps other netCDF functions).

The examples follow a simple convention for error handling, always
checking the error status returned from each netCDF function call and
calling a handle\_error function in case an error was detected. For an
example of such a function, see Section 5.2 "Get error message
corresponding to error status: nf90\_strerror".

2.3 NF90_STRERROR {#f90-nf90_strerror}
=========================

The function NF90\_STRERROR returns a static reference to an error
message string corresponding to an integer netCDF error status or to a
system error number, presumably returned by a previous call to some
other netCDF function. The list of netCDF error status codes is
available in the appropriate include file for each language binding.



## Usage


~~~~.fortran


 function nf90_strerror(ncerr)
   integer, intent( in) :: ncerr
   character(len = 80)  :: nf90_strerror

~~~~



`NCERR`

:   An error status that might have been returned from a previous call
    to some netCDF function.

## Errors

If you provide an invalid integer error status that does not correspond
to any netCDF error message or or to any system error message (as
understood by the system strerror function), NF90\_STRERROR returns a
string indicating that there is no such error status.

## Example

Here is an example of a simple error handling function that uses
NF90\_STRERROR to print the error message corresponding to the netCDF
error status returned from any netCDF function call and then exit:


~~~~.fortran


 subroutine handle_err(status)
   integer, intent ( in) :: status

   if(status /= nf90_noerr) then
     print *, trim(nf90_strerror(status))
     stop "Stopped"
   end if
 end subroutine handle_err



~~~~

2.4 Get netCDF library version: NF90_INQ_LIBVERS {#f90-get-netcdf-library-version-nf90_inq_libvers}
=========================

The function NF90\_INQ\_LIBVERS returns a string identifying the version
of the netCDF library, and when it was built.



## Usage




~~~~.fortran

 function nf90_inq_libvers()
   character(len = 80) :: nf90_inq_libvers



~~~~



## Errors

This function takes no arguments, and returns no error status.



## Example

Here is an example using nf90\_inq\_libvers to print the version of the
netCDF library with which the program is linked:



~~~~.fortran
print *, trim(nf90_inq_libvers())

~~~~




2.5 NF90_CREATE {#f90-nf90_create}
=========================



This function creates a new netCDF dataset, returning a netCDF ID that
can subsequently be used to refer to the netCDF dataset in other netCDF
function calls. The new netCDF dataset opened for write access and
placed in define mode, ready for you to add dimensions, variables, and
attributes.

A creation mode flag specifies whether to overwrite any existing dataset
with the same name and whether access to the dataset is shared.



## Usage



~~~~.fortran

  function nf90_create(path, cmode, ncid, initialsize, bufrsize, cache_size, &
       cache_nelems, cache_preemption, comm, info)
    implicit none
    character (len = *), intent(in) :: path
    integer, intent(in) :: cmode
    integer, intent(out) :: ncid
    integer, optional, intent(in) :: initialsize
    integer, optional, intent(inout) :: bufrsize
    integer, optional, intent(in) :: cache_size, cache_nelems
    real, optional, intent(in) :: cache_preemption
    integer, optional, intent(in) :: comm, info
    integer :: nf90_create


~~~~


`path`

:   The file name of the new netCDF dataset.

`cmode`

:   The creation mode flag. The following flags are available:
    NF90\_CLOBBER, NF90\_NOCLOBBER, NF90\_SHARE, NF90\_64BIT\_OFFSET,
    NF90\_NETCDF4, and NF90\_CLASSIC\_MODEL. (NF90\_HDF5 is deprecated,
    use NF90\_NETCDF4 instead).

    A zero value (defined for convenience as NF90\_CLOBBER) specifies:
    overwrite any existing dataset with the same file name, and buffer
    and cache accesses for efficiency. The dataset will be in netCDF
    classic format. See [NetCDF Classic Format
    Limitations](netcdf.html#NetCDF-Classic-Format-Limitations) in
    NetCDF Users’ Guide.

    Setting NF90\_NOCLOBBER means you do not want to clobber (overwrite)
    an existing dataset; an error (NF90\_EEXIST) is returned if the
    specified dataset already exists.

    The NF90\_SHARE flag is appropriate when one process may be writing
    the dataset and one or more other processes reading the dataset
    concurrently; it means that dataset accesses are not buffered and
    caching is limited. Since the buffering scheme is optimized for
    sequential access, programs that do not access data sequentially may
    see some performance improvement by setting the NF90\_SHARE flag.
    (This only applies to netCDF-3 classic or 64-bit offset files.)

    Setting NF90\_64BIT\_OFFSET causes netCDF to create a 64-bit offset
    format file, instead of a netCDF classic format file. The 64-bit
    offset format imposes far fewer restrictions on very large (i.e.
    over 2 GB) data files. See [Large File
    Support](netcdf.html#Large-File-Support) in NetCDF Users’ Guide.

    Setting the NF90\_NETCDF4 flag causes netCDF to create a
    netCDF-4/HDF5 format output file.

    Oring the NF90\_CLASSIC\_MODEL flag with the NF90\_NETCDF4 flag
    causes the resulting netCDF-4/HDF5 file to restrict itself to the
    classic model - none of the new netCDF-4 data model features, such
    as groups or user-defined types, are allowed in such a file.

`ncid`

:   Returned netCDF ID.

The following optional arguments allow additional performance tuning.

`initialsize`

:   The initial size of the file (in bytes) at creation time. A value of
    0 causes the file size to be computed when nf90\_enddef is called.
    This is ignored for NetCDF-4/HDF5 files.

`bufrsize`

:   Controls a space versus time trade-off, memory allocated in the
    netcdf library versus number of system calls. Because of internal
    requirements, the value may not be set to exactly the
    value requested. The actual value chosen is returned.

    The library chooses a system-dependent default value if
    NF90\_SIZEHINT\_DEFAULT is supplied as input. If the "preferred I/O
    block size" is available from the stat() system call as member
    st\_blksize this value is used. Lacking that, twice the system
    pagesize is used. Lacking a call to discover the system pagesize,
    the default bufrsize is set to 8192 bytes.

    The bufrsize is a property of a given open netcdf descriptor ncid,
    it is not a persistent property of the netcdf dataset.

    This is ignored for NetCDF-4/HDF5 files.

`cache_size`

:   If the cache\_size is provided when creating a netCDF-4/HDF5 file,
    it will be used instead of the default (32000000) as the size, in
    bytes, of the HDF5 chunk cache.

`cache_nelems`

:   If cache\_nelems is provided when creating a netCDF-4/HDF5 file, it
    will be used instead of the default (1000) as the maximum number of
    elements in the HDF5 chunk cache.

`cache_premtion`

:   If cache\_preemption is provided when creating a netCDF-4/HDF5 file,
    it will be used instead of the default (0.75) as the preemption
    value for the HDF5 chunk cache.

`comm`

:   If the comm and info parameters are provided the file is created and
    opened for parallel I/O. Set the comm parameter to the MPI
    communicator (of type MPI\_Comm). If this parameter is provided the
    info parameter must also be provided.

`info`

:   If the comm and info parameters are provided the file is created and
    opened for parallel I/O. Set the comm parameter to the MPI
    information value (of type MPI\_Info). If this parameter is provided
    the comm parameter must also be provided.



## Errors

NF90\_CREATE returns the value NF90\_NOERR if no errors occurred.
Possible causes of errors include:

-   Passing a dataset name that includes a directory that does
    not exist.
-   Specifying a dataset name of a file that exists and also
    specifying NF90\_NOCLOBBER.
-   Specifying a meaningless value for the creation mode.
-   Attempting to create a netCDF dataset in a directory where you don’t
    have permission to create files.



## Example

In this example we create a netCDF dataset named foo.nc; we want the
dataset to be created in the current directory only if a dataset with
that name does not already exist:



~~~~.fortran

 use netcdf
 implicit none
 integer :: ncid, status
 ...
 status = nf90_create(path = "foo.nc", cmode = nf90_noclobber, ncid = ncid)
 if (status /= nf90_noerr) call handle_err(status)


~~~~



2.6 NF90_OPEN {#f90-nf90_open}
=========================

The function NF90\_OPEN opens an existing netCDF dataset for access.

## Usage


~~~~.fortran


  function nf90_open(path, mode, ncid, bufrsize, cache_size, cache_nelems, &
                     cache_preemption, comm, info)
    implicit none
    character (len = *), intent(in) :: path
    integer, intent(in) :: mode
    integer, intent(out) :: ncid
    integer, optional, intent(inout) :: bufrsize
    integer, optional, intent(in) :: cache_size, cache_nelems
    real, optional, intent(in) :: cache_preemption
    integer, optional, intent(in) :: comm, info
    integer :: nf90_open


~~~~


`path`

:   File name for netCDF dataset to be opened. This may be an OPeNDAP
    URL if DAP support is enabled.

`mode`

:   A zero value (or NF90\_NOWRITE) specifies: open the dataset with
    read-only access, buffering and caching accesses for efficiency

    Otherwise, the open mode is NF90\_WRITE, NF90\_SHARE,
    or NF90\_WRITE|NF90\_SHARE. Setting the NF90\_WRITE flag opens the
    dataset with read-write access. ("Writing" means any kind of change
    to the dataset, including appending or changing data, adding or
    renaming dimensions, variables, and attributes, or
    deleting attributes.) The NF90\_SHARE flag is appropriate when one
    process may be writing the dataset and one or more other processes
    reading the dataset concurrently (note that this is not the same as
    parallel I/O); it means that dataset accesses are not buffered and
    caching is limited. Since the buffering scheme is optimized for
    sequential access, programs that do not access data sequentially may
    see some performance improvement by setting the NF90\_SHARE flag.

`ncid`

:   Returned netCDF ID.

The following optional argument allows additional performance tuning.

`bufrsize`

:   This parameter applies only when opening classic format or 64-bit
    offset files. It is ignored for netCDF-4/HDF5 files.

    It Controls a space versus time trade-off, memory allocated in the
    netcdf library versus number of system calls. Because of internal
    requirements, the value may not be set to exactly the
    value requested. The actual value chosen is returned.

    The library chooses a system-dependent default value if
    NF90\_SIZEHINT\_DEFAULT is supplied as input. If the "preferred I/O
    block size" is available from the stat() system call as member
    st\_blksize this value is used. Lacking that, twice the system
    pagesize is used. Lacking a call to discover the system pagesize,
    the default bufrsize is set to 8192 bytes.

    The bufrsize is a property of a given open netcdf descriptor ncid,
    it is not a persistent property of the netcdf dataset.

`cache_size`

:   If the cache\_size is provided when opening a netCDF-4/HDF5 file, it
    will be used instead of the default (32000000) as the size, in
    bytes, of the HDF5 chunk cache.

`cache_nelems`

:   If cache\_nelems is provided when opening a netCDF-4/HDF5 file, it
    will be used instead of the default (1000) as the maximum number of
    elements in the HDF5 chunk cache.

`cache_premtion`

:   If cache\_preemption is provided when opening a netCDF-4/HDF5 file,
    it will be used instead of the default (0.75) as the preemption
    value for the HDF5 chunk cache.

`comm`

:   If the comm and info parameters are provided the file is opened for
    parallel I/O. Set the comm parameter to the MPI communicator (of
    type MPI\_Comm). If this parameter is provided the info parameter
    must also be provided.

`info`

:   If the comm and info parameters are provided the file is opened for
    parallel I/O. Set the comm parameter to the MPI information value
    (of type MPI\_Info). If this parameter is provided the comm
    parameter must also be provided.



## Errors

NF90\_OPEN returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The specified netCDF dataset does not exist.
-   A meaningless mode was specified.

## Example

Here is an example using NF90\_OPEN to open an existing netCDF dataset
named foo.nc for read-only, non-shared access:


~~~~.fortran


 use netcdf
 implicit none
 integer :: ncid, status
 ...
 status = nf90_open(path = "foo.nc", mode = nf90_nowrite, ncid = ncid)
 if (status /= nf90_noerr) call handle_err(status)


~~~~


## Example

Here is an example using NF90\_OPEN to open an existing netCDF dataset
for parallel I/O access. (Note the use of the comm and info parameters).
This example is from test program nf\_test/f90tst\_parallel.f90.


~~~~.fortran


 use netcdf
 implicit none
 integer :: ncid, status
 ...
  ! Reopen the file.
  call handle_err(nf90_open(FILE_NAME, nf90_nowrite, ncid, comm = MPI_COMM_WORLD, &
       info = MPI_INFO_NULL))



~~~~

2.7 NF90_REDEF {#f90-nf90_redef}
=========================



The function NF90\_REDEF puts an open netCDF dataset into define mode,
so dimensions, variables, and attributes can be added or renamed and
attributes can be deleted.



## Usage


~~~~.fortran


 function nf90_redef(ncid)
   integer, intent( in) :: ncid
   integer              :: nf90_redef



~~~~

`ncid`

:   netCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.



## Errors

NF90\_REDEF returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The specified netCDF dataset is already in define mode.
-   The specified netCDF dataset was opened for read-only.
-   The specified netCDF ID does not refer to an open netCDF dataset.



## Example

Here is an example using NF90\_REDEF to open an existing netCDF dataset
named foo.nc and put it into define mode:



~~~~.fortran

 use netcdf
 implicit none
 integer :: ncid, status
 ...
 status = nf90_open("foo.nc", nf90_write, ncid) ! Open dataset
 if (status /= nf90_noerr) call handle_err(status)
 ...
 status = nf90_redef(ncid)                       ! Put the file in define mode
 if (status /= nf90_noerr) call handle_err(status)



~~~~

2.8 NF90_ENDDEF {#f90-nf90_enddef}
=========================



The function NF90\_ENDDEF takes an open netCDF dataset out of define
mode. The changes made to the netCDF dataset while it was in define mode
are checked and committed to disk if no problems occurred. Non-record
variables may be initialized to a "fill value" as well (see section
[NF90_SET_FILL](#NF90_005fSET_005fFILL)). The netCDF dataset is then
placed in data mode, so variable data can be read or written.

This call may involve copying data under some circumstances. For a more
extensive discussion See [File Structure and
Performance](netcdf.html#File-Structure-and-Performance) in NetCDF Users
Guide.

## Usage


~~~~.fortran


 function nf90_enddef(ncid, h_minfree, v_align, v_minfree, r_align)
   integer,           intent( in) :: ncid
   integer, optional, intent( in) :: h_minfree, v_align, v_minfree, r_align
   integer                        :: nf90_enddef

~~~~



`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

The following arguments allow additional performance tuning. Note: these
arguments expose internals of the netcdf version 1 file format, and may
not be available in future netcdf implementations.

The current netcdf file format has three sections: the "header" section,
the data section for fixed size variables, and the data section for
variables which have an unlimited dimension (record variables). The
header begins at the beginning of the file. The index (offset) of the
beginning of the other two sections is contained in the header.
Typically, there is no space between the sections. This causes copying
overhead to accrue if one wishes to change the size of the sections, as
may happen when changing the names of things, text attribute values,
adding attributes or adding variables. Also, for buffered i/o, there may
be advantages to aligning sections in certain ways.

The minfree parameters allow one to control costs of future calls to
nf90\_redef or nf90\_enddef by requesting that some space be available
at the end of the section. The default value for both h\_minfree and
v\_minfree is 0.

The align parameters allow one to set the alignment of the beginning of
the corresponding sections. The beginning of the section is rounded up
to an index which is a multiple of the align parameter. The flag value
NF90\_ALIGN\_CHUNK tells the library to use the bufrsize (see above) as
the align parameter. The default value for both v\_align and r\_align is
4 bytes.

`h_minfree`

:   Size of the pad (in bytes) at the end of the "header" section.

`v_minfree`

:   Size of the pad (in bytes) at the end of the data section for fixed
    size variables.

`v_align`

:   The alignment of the beginning of the data section for fixed
    size variables.

`r_align`

:   The alignment of the beginning of the data section for variables
    which have an unlimited dimension (record variables).

## Errors

NF90\_ENDDEF returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The specified netCDF dataset is not in define mode.
-   The specified netCDF ID does not refer to an open netCDF dataset.
-   The size of one or more variables exceed the size constraints for
    whichever variant of the file format is in use).

## Example

Here is an example using NF90\_ENDDEF to finish the definitions of a new
netCDF dataset named foo.nc and put it into data mode:



~~~~.fortran

 use netcdf
 implicit none
 integer :: ncid, status
 ...
 status = nf90_create("foo.nc", nf90_noclobber, ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...  !  create dimensions, variables, attributes
 status = nf90_enddef(ncid)
 if (status /= nf90_noerr) call handle_err(status)


~~~~




2.9 NF90_CLOSE {#f90-nf90_close}
=========================

The function NF90\_CLOSE closes an open netCDF dataset. If the dataset
is in define mode, NF90\_ENDDEF will be called before closing. (In this
case, if NF90\_ENDDEF returns an error, NF90\_ABORT will automatically
be called to restore the dataset to the consistent state before define
mode was last entered.) After an open netCDF dataset is closed, its
netCDF ID may be reassigned to the next netCDF dataset that is opened or
created.



## Usage



~~~~.fortran

 function nf90_close(ncid)
   integer, intent( in) :: ncid
   integer              :: nf90_close


~~~~


`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.



## Errors

NF90\_CLOSE returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   Define mode was entered and the automatic call made to
    NF90\_ENDDEF failed.
-   The specified netCDF ID does not refer to an open netCDF dataset.



## Example

Here is an example using NF90\_CLOSE to finish the definitions of a new
netCDF dataset named foo.nc and release its netCDF ID:


~~~~.fortran


 use netcdf
 implicit none
 integer :: ncid, status
 ...
 status = nf90_create("foo.nc", nf90_noclobber, ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...  !  create dimensions, variables, attributes
 status = nf90_close(ncid)
 if (status /= nf90_noerr) call handle_err(status)

~~~~



2.10 NF90_INQUIRE Family {#f90-nf90_inquire-family}
=========================

The NF90\_INQUIRE subroutine returns information about an open netCDF
dataset, given its netCDF ID. The subroutine can be called from either
define mode or data mode, and returns values for any or all of the
following: the number of dimensions, the number of variables, the number
of global attributes, and the dimension ID of the dimension defined with
unlimited length, if any. An additional function, NF90\_INQ\_FORMAT,
returns the (rarely needed) format version.

No I/O is performed when NF90\_INQUIRE is called, since the required
information is available in memory for each open netCDF dataset.

## Usage


~~~~.fortran


 function nf90_inquire(ncid, nDimensions, nVariables, nAttributes, &
                       unlimitedDimId, formatNum)
   integer,           intent( in) :: ncid
   integer, optional, intent(out) :: nDimensions, nVariables, &
                                     nAttributes, unlimitedDimId, &
                                     formatNum
   integer                        :: nf90_inquire



~~~~

`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`nDimensions`

:   Returned number of dimensions defined for this netCDF dataset.

`nVariables`

:   Returned number of variables defined for this netCDF dataset.

`nAttributes`

:   Returned number of global attributes defined for this
    netCDF dataset.

`unlimitedDimID`

:   Returned ID of the unlimited dimension, if there is one for this
    netCDF dataset. If no unlimited length dimension has been defined,
    -1 is returned.

`format`

:   Returned integer indicating format version for this dataset, one of
    nf90\_format\_classic, nf90\_format\_64bit, nf90\_format\_netcdf4,
    or nf90\_format\_netcdf4\_classic. These are rarely needed by users
    or applications, since thhe library recognizes the format of a file
    it is accessing and handles it accordingly.



## Errors

Function NF90\_INQUIRE returns the value NF90\_NOERR if no errors
occurred. Otherwise, the returned status indicates an error. Possible
causes of errors include:

-   The specified netCDF ID does not refer to an open netCDF dataset.

## Example

Here is an example using NF90\_INQUIRE to find out about a netCDF
dataset named foo.nc:


~~~~.fortran


 use netcdf
 implicit none
 integer :: ncid, status, nDims, nVars, nGlobalAtts, unlimDimID
 ...
 status = nf90_open("foo.nc", nf90_nowrite, ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...  
 status = nf90_inquire(ncid, nDims, nVars, nGlobalAtts, unlimdimid)
 if (status /= nf90_noerr) call handle_err(status)
 status = nf90_inquire(ncid, nDimensions = nDims, &
                       unlimitedDimID = unlimdimid)
 if (status /= nf90_noerr) call handle_err(status)


~~~~


2.11 NF90_SYNC {#f90-nf90_sync}
=========================



The function NF90\_SYNC offers a way to synchronize the disk copy of a
netCDF dataset with in-memory buffers. There are two reasons you might
want to synchronize after writes:

-   To minimize data loss in case of abnormal termination, or
-   To make data available to other processes for reading immediately
    after it is written. But note that a process that already had the
    dataset open for reading would not see the number of records
    increase when the writing process calls NF90\_SYNC; to accomplish
    this, the reading process must call NF90\_SYNC.

This function is backward-compatible with previous versions of the
netCDF library. The intent was to allow sharing of a netCDF dataset
among multiple readers and one writer, by having the writer call
NF90\_SYNC after writing and the readers call NF90\_SYNC before each
read. For a writer, this flushes buffers to disk. For a reader, it makes
sure that the next read will be from disk rather than from previously
cached buffers, so that the reader will see changes made by the writing
process (e.g., the number of records written) without having to close
and reopen the dataset. If you are only accessing a small amount of
data, it can be expensive in computer resources to always synchronize to
disk after every write, since you are giving up the benefits of
buffering.

An easier way to accomplish sharing (and what is now recommended) is to
have the writer and readers open the dataset with the NF90\_SHARE flag,
and then it will not be necessary to call NF90\_SYNC at all. However,
the NF90\_SYNC function still provides finer granularity than the
NF90\_SHARE flag, if only a few netCDF accesses need to be synchronized
among processes.

It is important to note that changes to the ancillary data, such as
attribute values, are not propagated automatically by use of the
NF90\_SHARE flag. Use of the NF90\_SYNC function is still required for
this purpose.

Sharing datasets when the writer enters define mode to change the data
schema requires extra care. In previous releases, after the writer left
define mode, the readers were left looking at an old copy of the
dataset, since the changes were made to a new copy. The only way readers
could see the changes was by closing and reopening the dataset. Now the
changes are made in place, but readers have no knowledge that their
internal tables are now inconsistent with the new dataset schema. If
netCDF datasets are shared across redefinition, some mechanism external
to the netCDF library must be provided that prevents access by readers
during redefinition and causes the readers to call NF90\_SYNC before any
subsequent access.

When calling NF90\_SYNC, the netCDF dataset must be in data mode. A
netCDF dataset in define mode is synchronized to disk only when
NF90\_ENDDEF is called. A process that is reading a netCDF dataset that
another process is writing may call NF90\_SYNC to get updated with the
changes made to the data by the writing process (e.g., the number of
records written), without having to close and reopen the dataset.

Data is automatically synchronized to disk when a netCDF dataset is
closed, or whenever you leave define mode.


## Usage


~~~~.fortran


 function nf90_sync(ncid)
   integer, intent( in) :: ncid
   integer              :: nf90_sync



~~~~

`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.



## Errors

NF90\_SYNC returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The netCDF dataset is in define mode.
-   The specified netCDF ID does not refer to an open netCDF dataset.



## Example

Here is an example using NF90\_SYNC to synchronize the disk writes of a
netCDF dataset named foo.nc:



~~~~.fortran

 use netcdf
 implicit none
 integer :: ncid, status
 ...
 status = nf90_open("foo.nc", nf90_write, ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...  
 ! write data or change attributes
 ...  
 status = NF90_SYNC(ncid)
 if (status /= nf90_noerr) call handle_err(status)


~~~~


2.12 NF90_ABORT {#f90-nf90_abort}
=========================



You no longer need to call this function, since it is called
automatically by NF90\_CLOSE in case the dataset is in define mode and
something goes wrong with committing the changes. The function
NF90\_ABORT just closes the netCDF dataset, if not in define mode. If
the dataset is being created and is still in define mode, the dataset is
deleted. If define mode was entered by a call to NF90\_REDEF, the netCDF
dataset is restored to its state before definition mode was entered and
the dataset is closed.



## Usage


~~~~.fortran


 function nf90_abort(ncid)
   integer, intent( in) :: ncid
   integer              :: nf90_abort


~~~~


`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.



## Errors

NF90\_ABORT returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   When called from define mode while creating a netCDF dataset,
    deletion of the dataset failed.
-   The specified netCDF ID does not refer to an open netCDF dataset.



## Example

Here is an example using NF90\_ABORT to back out of redefinitions of a
dataset named foo.nc:


~~~~.fortran


 use netcdf
 implicit none
 integer :: ncid, status, LatDimID
 ...
 status = nf90_open("foo.nc", nf90_write, ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...  
 status = nf90_redef(ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...  
 status = nf90_def_dim(ncid, "Lat", 18, LatDimID)
 if (status /= nf90_noerr) then ! Dimension definition failed
   call handle_err(status)
   status = nf90_abort(ncid) ! Abort redefinitions
   if (status /= nf90_noerr) call handle_err(status)
 end if
...


~~~~



2.13 NF90_SET_FILL {#f90-nf90_set_fill}
=========================



This function is intended for advanced usage, to optimize writes under
some circumstances described below. The function NF90\_SET\_FILL sets
the fill mode for a netCDF dataset open for writing and returns the
current fill mode in a return parameter. The fill mode can be specified
as either NF90\_FILL or NF90\_NOFILL. The default behavior corresponding
to NF90\_FILL is that data is pre-filled with fill values, that is fill
values are written when you create non-record variables or when you
write a value beyond data that has not yet been written. This makes it
possible to detect attempts to read data before it was written. See
section [Fill Values](#Fill-Values), for more information on the use of
fill values. See [Attribute
Conventions](netcdf.html#Attribute-Conventions) in {No value for
‘n-man’}, for information about how to define your own fill values.

The behavior corresponding to NF90\_NOFILL overrides the default
behavior of prefilling data with fill values. This can be used to
enhance performance, because it avoids the duplicate writes that occur
when the netCDF library writes fill values that are later overwritten
with data.

A value indicating which mode the netCDF dataset was already in is
returned. You can use this value to temporarily change the fill mode of
an open netCDF dataset and then restore it to the previous mode.

After you turn on NF90\_NOFILL mode for an open netCDF dataset, you must
be certain to write valid data in all the positions that will later be
read. Note that nofill mode is only a transient property of a netCDF
dataset open for writing: if you close and reopen the dataset, it will
revert to the default behavior. You can also revert to the default
behavior by calling NF90\_SET\_FILL again to explicitly set the fill
mode to NF90\_FILL.

There are three situations where it is advantageous to set nofill mode:

1.  Creating and initializing a netCDF dataset. In this case, you should
    set nofill mode before calling NF90\_ENDDEF and then write
    completely all non-record variables and the initial records of all
    the record variables you want to initialize.
2.  Extending an existing record-oriented netCDF dataset. Set nofill
    mode after opening the dataset for writing, then append the
    additional records to the dataset completely, leaving no intervening
    unwritten records.
3.  Adding new variables that you are going to initialize to an existing
    netCDF dataset. Set nofill mode before calling NF90\_ENDDEF then
    write all the new variables completely.

If the netCDF dataset has an unlimited dimension and the last record was
written while in nofill mode, then the dataset may be shorter than if
nofill mode was not set, but this will be completely transparent if you
access the data only through the netCDF interfaces.

The use of this feature may not be available (or even needed) in future
releases. Programmers are cautioned against heavy reliance upon this
feature.



## Usage


~~~~.fortran


 function nf90_set_fill(ncid, fillmode, old_mode)
   integer, intent( in) :: ncid, fillmode
   integer, intent(out) :: old_mode
   integer              :: nf90_set_fill



~~~~

`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`fillmode`

:   Desired fill mode for the dataset, either NF90\_NOFILL
    or NF90\_FILL.

`old_mode`

:   Returned current fill mode of the dataset before this call, either
    NF90\_NOFILL or NF90\_FILL.



## Errors

NF90\_SET\_FILL returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The specified netCDF ID does not refer to an open netCDF dataset.
-   The specified netCDF ID refers to a dataset open for
    read-only access.
-   The fill mode argument is neither NF90\_NOFILL nor NF90\_FILL..

## Example

Here is an example using NF90\_SET\_FILL to set nofill mode for
subsequent writes of a netCDF dataset named foo.nc:


~~~~.fortran


 use netcdf
 implicit none
 integer :: ncid, status, oldMode
 ...
 status = nf90_open("foo.nc", nf90_write, ncid)
 if (status /= nf90_noerr) call handle_err(status)
 ...  
 ! Write data with prefilling behavior
 ...  
 status = nf90_set_fill(ncid, nf90_nofill, oldMode)
 if (status /= nf90_noerr) call handle_err(status)
 ...
 !  Write data with no prefilling
 ...

~~~~
