6 Variables {#f90-variables}
===========

[TOC]

6.1 Variables Introduction {#f90-variables-introduction}
===========

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
===========

The following table gives the netCDF external data types and the
corresponding type constants for defining variables in the FORTRAN
interface:

Type   |  FORTRAN API Mnemonic |  Bits
-------| ----------------------| ------
byte   |  NF90_BYTE           |  8
char   |  NF90_CHAR           |  8
short  |  NF90_SHORT          |  16
int    |  NF90_INT            |  32
float  |  NF90_FLOAT          |  32
double |  NF90_DOUBLE         |  64


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
===========



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



## Usage


~~~~.fortran


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



~~~~

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



## Return Codes

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



~~~~.fortran

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


~~~~


In the following example, from nf\_test/f90tst\_vars2.f90, chunking,
checksums, and endianness control are all used in a netCDF-4/HDF5 file.


~~~~.fortran


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


~~~~


6.4 Define Fill Parameters for a Variable: `nf90_def_var_fill` {#f90-define-fill-parameters-for-a-variable-nf90_def_var_fill}
===========



The function NF90\_DEF\_VAR\_FILL sets the fill parameters for a
variable in a netCDF-4 file.

This function must be called after the variable is defined, but before
NF90\_ENDDEF is called.



## Usage



~~~~.fortran

NF90_DEF_VAR_FILL(INTEGER NCID, INTEGER VARID, INTEGER NO_FILL, FILL_VALUE);

~~~~



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



## Return Codes

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



## Example


6.5 Learn About Fill Parameters for a Variable: `NF90_INQ_VAR_FILL` {#f90-learn-about-fill-parameters-for-a-variable-nf90_inq_var_fill}
===========



The function NF90\_INQ\_VAR\_FILL returns the fill settings for a
variable in a netCDF-4 file.



## Usage



~~~~.fortran

NF90_INQ_VAR_FILL(INTEGER NCID, INTEGER VARID, INTEGER NO_FILL, FILL_VALUE)

~~~~



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



## Return Codes

`NF90_NOERR`

:   No error.

`NF90_BADID`

:   Bad ncid.

`NF90_ENOTNC4`

:   Not a netCDF-4 file.

`NF90_ENOTVAR`

:   Can’t find this variable.



## Example

6.6 Get Information about a Variable from Its ID: NF90_INQUIRE_VARIABLE {#f90-get-information-about-a-variable-from-its-id-nf90_inquire_variable}
===========

NF90\_INQUIRE\_VARIABLE returns information about a netCDF variable
given its ID. Information about a variable includes its name, type,
number of dimensions, a list of dimension IDs describing the shape of
the variable, and the number of variable attributes that have been
assigned to the variable.

All parameters after nAtts are optional, and only supported if netCDF
was built with netCDF-4 features enabled, and if the variable is in a
netCDF-4/HDF5 file.



## Usage


~~~~.fortran


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



~~~~

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



## Example

Here is an example using NF90\_INQ\_VAR to find out about a variable
named rh in an existing netCDF dataset named foo.nc:


~~~~.fortran


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


~~~~


6.7 Get the ID of a variable from the name: NF90_INQ_VARID {#f90-get-the-id-of-a-variable-from-the-name-nf90_inq_varid}
===========



Given the name of a varaible, nf90\_inq\_varid finds the variable ID.



## Usage


~~~~.fortran


  function nf90_inq_varid(ncid, name, varid)
    integer, intent(in) :: ncid
    character (len = *), intent( in) :: name
    integer, intent(out) :: varid
    integer :: nf90_inq_varid


~~~~


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



## Example

Here is an example using NF90\_INQ\_VARID to find out about a variable
named rh in an existing netCDF dataset named foo.nc:



~~~~.fortran

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



~~~~


6.8 Writing Data Values: NF90_PUT_VAR {#f90-writing-data-values-nf90_put_var}
===========



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



~~~~.fortran

 function nf90_put_var(ncid, varid, values, start, count, stride, map)
   integer,                         intent( in) :: ncid, varid
   any valid type, scalar or array of any rank, &
                                    intent( in) :: values
   integer, dimension(:), optional, intent( in) :: start, count, stride, map
   integer                                      :: nf90_put_var


~~~~


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



## Errors

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



## Example

Here is an example using NF90\_PUT\_VAR to set the (4,3,2) element of
the variable named rh to 0.5 in an existing netCDF dataset named foo.nc.
For simplicity in this example, we assume that we know that rh is
dimensioned with lon, lat, and time, so we want to set the value of rh
that corresponds to the fourth lon value, the third lat value, and the
second time value:



~~~~.fortran

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


~~~~


In this example we use NF90\_PUT\_VAR to add or change all the values of
the variable named rh to 0.5 in an existing netCDF dataset named foo.nc.
We assume that we know that rh is dimensioned with lon, lat, and time.
In this example we query the netCDF file to discover the lengths of the
dimensions, then use the Fortran 90 intrinsic function reshape to create
a temporary array of data values which is the same shape as the netCDF
variable.


~~~~.fortran


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


~~~~


Here is an example using NF90\_PUT\_VAR to add or change a section of
the variable named rh to 0.5 in an existing netCDF dataset named foo.nc.
For simplicity in this example, we assume that we know that rh is
dimensioned with lon, lat, and time, that there are ten lon values, five
lat values, and three time values, and that we want to replace all the
values at the last time.



~~~~.fortran

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


~~~~


Here is an example of using NF90\_PUT\_VAR to write every other point of
a netCDF variable named rh having dimensions (6, 4).



~~~~.fortran

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


~~~~


The following map vector shows the default mapping between a 2x3x4
netCDF variable and an internal array of the same shape:


~~~~.fortran


 real,    dimension(2, 3, 4):: a  ! same shape as netCDF variable
 integer, dimension(3)      :: map  = (/ 1, 2, 6 /)
                     ! netCDF dimension inter-element distance
                     ! ---------------- ----------------------
                     ! most rapidly varying       1
                     ! intermediate               2 (= map(1)*2)
                     ! most slowly varying        6 (= map(2)*3)


~~~~


Using the map vector above obtains the same result as simply not passing
a map vector at all.

Here is an example of using nf90\_put\_var to write a netCDF variable
named rh whose dimensions are the transpose of the Fortran 90 array:


~~~~.fortran


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


~~~~


The same effect can be obtained more simply using Fortran 90 intrinsic
functions:



~~~~.fortran

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


~~~~



6.9 Reading Data Values: NF90_GET_VAR {#f90-reading-data-values-nf90_get_var}
===========



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



## Usage



~~~~.fortran

 function nf90_get_var(ncid, varid, values, start, count, stride, map)
   integer,                         intent( in) :: ncid, varid
   any valid type, scalar or array of any rank, &
                                    intent(out) :: values
   integer, dimension(:), optional, intent( in) :: start, count, stride, map
   integer                                      :: nf90_get_var


~~~~


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



## Errors

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



## Example

Here is an example using NF90\_GET\_VAR to read the (4,3,2) element of
the variable named rh from an existing netCDF dataset named foo.nc. For
simplicity in this example, we assume that we know that rh is
dimensioned with lon, lat, and time, so we want to read the value of rh
that corresponds to the fourth lon value, the third lat value, and the
second time value:



~~~~.fortran

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


~~~~


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


~~~~.fortran


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


~~~~


Here is an example of using NF90\_GET\_VAR to read every other point of
a netCDF variable named rh having dimensions (6, 4).


~~~~.fortran


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



~~~~

The following map vector shows the default mapping between a 2x3x4
netCDF variable and an internal array of the same shape:


~~~~.fortran


 real,    dimension(2, 3, 4):: a  ! same shape as netCDF variable
 integer, dimension(3)      :: map  = (/ 1, 2, 6 /)
                     ! netCDF dimension inter-element distance
                     ! ---------------- ----------------------
                     ! most rapidly varying       1
                     ! intermediate               2 (= map(1)*2)
                     ! most slowly varying        6 (= map(2)*3)




~~~~

Using the map vector above obtains the same result as simply not passing
a map vector at all.

Here is an example of using nf90\_get\_var to read a netCDF variable
named rh whose dimensions are the transpose of the Fortran 90 array:



~~~~.fortran

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


~~~~


The same effect can be obtained more simply, though using more memory,
using Fortran 90 intrinsic functions:


~~~~.fortran


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


~~~~




6.10 Reading and Writing Character String Values {#f90-reading-and-writing-character-string-values}
===========

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



~~~~.fortran

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


~~~~


6.11 Fill Values {#f90-fill-values}
===========

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
===========



The function NF90\_RENAME\_VAR changes the name of a netCDF variable in
an open netCDF dataset. If the new name is longer than the old name, the
netCDF dataset must be in define mode. You cannot rename a variable to
have the name of any existing variable.



## Usage



~~~~.fortran

 function nf90_rename_var(ncid, varid, newname)
   integer,             intent( in) :: ncid, varid
   character (len = *), intent( in) :: newname
   integer                          :: nf90_rename_var

~~~~



`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`varid`

:   Variable ID.

`newname`

:   New name for the specified variable.



## Errors

NF90\_RENAME\_VAR returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The new name is in use as the name of another variable.
-   The variable ID is invalid for the specified netCDF dataset.
-   The specified netCDF ID does not refer to an open netCDF dataset.



## Example

Here is an example using NF90\_RENAME\_VAR to rename the variable rh to
rel\_hum in an existing netCDF dataset named foo.nc:


~~~~.fortran


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



~~~~


6.13 Change between Collective and Independent Parallel Access: NF90_VAR_PAR_ACCESS {#f90-change-between-collective-and-independent-parallel-access-nf90_var_par_access}
===========



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



## Usage



~~~~.fortran

  function nf90_var_par_access(ncid, varid, access)
    integer, intent(in) :: ncid
    integer, intent(in) :: varid
    integer, intent(in) :: access
    integer :: nf90_var_par_access
  end function nf90_var_par_access

~~~~



`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN (see
    [NF90\_OPEN](#NF90_005fOPEN)) or NF90\_CREATE (see
    [NF90\_CREATE](#NF90_005fCREATE)).

`varid`

:   Variable ID.

`access`

:   NF90\_INDEPENDENT to set this variable to independent operations.
    NF90\_COLLECTIVE to set it to collective operations.



## Return Values

`NF90_NOERR`

:   No error.

`NF90_ENOTVAR`

:   No variable found.

`NF90_NOPAR`

:   File not opened for parallel access.



## Example

This example comes from test program nf\_test/f90tst\_parallel.f90. For
this test to be run, netCDF must have been built with a parallel-enabled
HDF5, and –enable-parallel-tests must have been used when configuring
netcdf.



~~~~.fortran

  ! Reopen the file.
  call handle_err(nf90_open(FILE_NAME, nf90_nowrite, ncid, comm = MPI_COMM_WORLD, &
       info = MPI_INFO_NULL))

  ! Set collective access on this variable. This will cause all
  ! reads/writes to happen together on every processor.
  call handle_err(nf90_var_par_access(ncid, varid, nf90_collective))

  ! Read this processor's data.
  call handle_err(nf90_get_var(ncid, varid, data_in, start = start, count = count))

~~~~
