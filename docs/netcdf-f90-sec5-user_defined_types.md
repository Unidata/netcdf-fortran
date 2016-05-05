5 User Defined Data Types {#f90-user-defined-data-types}
=========================

5.1 User Defined Types Introduction {#f90-user-defined-types-introduction}
=========================

[TOC]

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
NF90\_DEF\_VAR (see section [Create a Variable: `NF90_DEF_VAR`](#NF90_005fDEF_005fVAR)). Write to them with
NF90\_PUT\_VAR (see section [Writing Data Values: `NF90_PUT_VAR`](#NF90_005fPUT_005fVAR)). Read data of user-defined type
with NF90\_GET\_VAR (see section [Reading Data Values: `NF90_GET_VAR`](#NF90_005fGET_005fVAR)).

Create attributes of the new type with NF90\_PUT\_ATT (see section
[Create an Attribute: NF90\_PUT\_ATT](#NF90_005fPUT_005fATT)). Read
attributes of the new type with NF90\_GET\_ATT (see section [Get
Attribute’s Values: NF90\_GET\_ATT](#NF90_005fGET_005fATT)).


5.2 Learn the IDs of All Types in Group: NF90_INQ_TYPEIDS {#f90-learn-the-ids-of-all-types-in-group-nf90_inq_typeids}
=========================



Learn the number of types defined in a group, and their IDs.



## Usage



~~~~.fortran

  function nf90_inq_typeids(ncid, ntypes, typeids)
    integer, intent(in) :: ncid
    integer, intent(out) :: ntypes
    integer, intent(out) :: typeids
    integer :: nf90_inq_typeids



~~~~

`NCID`

:   The group id.

`NTYPES`

:   A pointer to int which will get the number of types defined in
    the group. If NULL, ignored.

`TYPEIDS`

:   A pointer to an int array which will get the typeids. If
    NULL, ignored.



## Errors

`NF90_NOERR`

:   No error.

`NF90_BADID`

:   Bad ncid.



## Example


5.3 Find a Typeid from Group and Name: nf90_inq_typeid {#f90-find-a-typeid-from-group-and-name-nf90_inq_typeid}
=========================



Given a group ID and a type name, find the ID of the type. If the type
is not found in the group, then the parents are searched. If still not
found, the entire file is searched.



## Usage




~~~~.fortran
int nf90_inq_typeid(int ncid, char *name, nf90_type *typeidp);


~~~~


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



## Example


5.4 Learn About a User Defined Type: NF90_INQ_TYPE {#f90-learn-about-a-user-defined-type-nf90_inq_type}
=========================


Given an ncid and a typeid, get the information about a type. This
function will work on any type, including atomic and any user defined
type, whether compound, opaque, enumeration, or variable length array.

For even more information about a user defined type [Learn About a User
Defined Type: NF90\_INQ\_USER\_TYPE](#NF90_005fINQ_005fUSER_005fTYPE).



## Usage

~~~~.fortran



  function nf90_inq_type(ncid, xtype, name, size)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(out) :: name
    integer, intent(out) :: size
    integer :: nf90_inq_type



~~~~

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



## Return Codes


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



## Example


5.5 Learn About a User Defined Type: NF90_INQ_USER_TYPE {#f90-learn-about-a-user-defined-type-nf90_inq_user_type}
=========================

Given an ncid and a typeid, get the information about a user defined
type. This function will work on any user defined type, whether
compound, opaque, enumeration, or variable length array.



## Usage



~~~~.fortran

  function nf90_inq_user_type(ncid, xtype, name, size, base_typeid, nfields, class)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(out) :: name
    integer, intent(out) :: size
    integer, intent(out) :: base_typeid
    integer, intent(out) :: nfields
    integer, intent(out) :: class
    integer :: nf90_inq_user_type
~~~~

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



## Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPEID`

:   Bad typeid.

`NF90_EBADFIELDID`

:   Bad fieldid.

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



## Example

## 5.5.1 Set a Variable Length Array with NF90_PUT_VLEN_ELEMENT {#f90-set-a-variable-length-array-with-nf90_put_vlen_element}



Use this to set the element of the (potentially) n-dimensional array of
VLEN. That is, this sets the data in one variable length array.



### Usage


~~~~.fortran


INTEGER FUNCTION NF90_PUT_VLEN_ELEMENT(INTEGER NCID, INTEGER XTYPE,
        CHARACTER*(*) VLEN_ELEMENT, INTEGER LEN, DATA)



~~~~

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



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPE`

:   Can’t find the typeid.

`NF90_EBADID`

:   ncid invalid.

`NF90_EBADGRPID`

:   Group ID part of ncid was invalid.



### Example

This example is from nf90\_test/ftst\_vars4.F.



~~~~.fortran

C     Set up the vlen with this helper function, since F90 can't deal
C     with pointers.
      retval = nf90_put_vlen_element(ncid, vlen_typeid, vlen,
     &     vlen_len, data1)
      if (retval .ne. nf90_noerr) call handle_err(retval)



~~~~


## 5.5.2 Set a Variable Length Array with NF90_GET_VLEN_ELEMENT {#f90-set-a-variable-length-array-with-nf90_get_vlen_element}



Use this to set the element of the (potentially) n-dimensional array of
VLEN. That is, this sets the data in one variable length array.



### Usage



~~~~.fortran

INTEGER FUNCTION NF90_GET_VLEN_ELEMENT(INTEGER NCID, INTEGER XTYPE,
        CHARACTER*(*) VLEN_ELEMENT, INTEGER LEN, DATA)


~~~~


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



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPE`

:   Can’t find the typeid.

`NF90_EBADID`

:   ncid invalid.

`NF90_EBADGRPID`

:   Group ID part of ncid was invalid.



### Example


5.6 Compound Types Introduction {#f90-compound-types-introduction}
=========================



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

## 5.6.1 Creating a Compound Type: NF90_DEF_COMPOUND {#f90-creating-a-compound-type-nf90_def_compound}



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



~~~~.fortran

  function nf90_def_compound(ncid, size, name, typeid)
    integer, intent(in) :: ncid
    integer, intent(in) :: size
    character (len = *), intent(in) :: name
    integer, intent(out) :: typeid
    integer :: nf90_def_compound

~~~~



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

## 5.6.2 Inserting a Field into a Compound Type: NF90_INSERT_COMPOUND {#f90-inserting-a-field-into-a-compound-type-nf90_insert_compound}



Insert a named field into a compound type.



### Usage



~~~~.fortran

  function nf90_insert_compound(ncid, xtype, name, offset, field_typeid)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(in) :: name
    integer, intent(in) :: offset
    integer, intent(in) :: field_typeid
    integer :: nf90_insert_compound


~~~~


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



### Errors

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



### Example





## 5.6.3 Inserting an Array Field into a Compound Type: NF90_INSERT_ARRAY_COMPOUND {#f90-inserting-an-array-field-into-a-compound-type-nf90_insert_array_compound}



Insert a named array field into a compound type.



### Usage



~~~~.fortran

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



~~~~

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



### Errors

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



### Example

## 5.6.4 Learn About a Compound Type: NF90_INQ_COMPOUND {#f90-learn-about-a-compound-type-nf90_inq_compound}



Get the number of fields, length in bytes, and name of a compound type.

In addtion to the NF90\_INQ\_COMPOUND function, three additional
functions are provided which get only the name, size, and number of
fields.



### Usage


~~~~.fortran


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



~~~~

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



### Return Codes

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



### Example

## 5.6.5 Learn About a Field of a Compound Type: NF90_INQ_COMPOUND_FIELD {#f90-learn-about-a-field-of-a-compound-type-nf90_inq_compound_field}



Get information about one of the fields of a compound type.



### Usage


~~~~.fortran


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


~~~~


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



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPEID`

:   Bad type id.

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



### Example

5.7 Variable Length Array Introduction {#f90-variable-length-array-introduction}
=========================



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

## 5.7.1 Define a Variable Length Array (VLEN): NF90_DEF_VLEN {#f90-define-a-variable-length-array-vlen-nf90_def_vlen}



Use this function to define a variable length array type.



### Usage


~~~~.fortran


  function nf90_def_vlen(ncid, name, base_typeid, xtypeid)
    integer, intent(in) :: ncid
    character (len = *), intent(in) :: name
    integer, intent(in) :: base_typeid
    integer, intent(out) :: xtypeid
    integer :: nf90_def_vlen


~~~~


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



### Errors

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



### Example

## 5.7.2 Learning about a Variable Length Array (VLEN) Type: NF90_INQ_VLEN {#f90-learning-about-a-variable-length-array-vlen-type-nf90_inq_vlen}



Use this type to learn about a vlen.



### Usage


~~~~.fortran


  function nf90_inq_vlen(ncid, xtype, name, datum_size, base_nc_type)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(out) :: name
    integer, intent(out) :: datum_size
    integer, intent(out) :: base_nc_type
    integer :: nf90_inq_vlen


~~~~


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



### Example


## 5.7.3 Releasing Memory for a Variable Length Array (VLEN) Type: NF90_FREE_VLEN {#f90-releasing-memory-for-a-variable-length-array-vlen-type-nf90_free_vlen}



When a VLEN is read into user memory from the file, the HDF5 library
performs memory allocations for each of the variable length arrays
contained within the VLEN structure. This memory must be freed by the
user to avoid memory leaks.

This violates the normal netCDF expectation that the user is responsible
for all memory allocation. But, with VLEN arrays, the underlying HDF5
library allocates the memory for the user, and the user is responsible
for deallocating that memory.



### Usage


~~~~.fortran


  function nf90_free_vlen(vl)
    character (len = *), intent(in) :: vlen
    integer :: nf90_free_vlen
  end function nf90_free_vlen


~~~~


`VL`

:   The variable length array structure which is to be freed.



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPE`

:   Can’t find the typeid.



### Example


5.8 Opaque Type Introduction {#f90-opaque-type-introduction}
=========================



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

## 5.8.1 Creating Opaque Types: NF90_DEF_OPAQUE {#f90-creating-opaque-types-nf90_def_opaque}



Create an opaque type. Provide a size and a name.



### Usage



~~~~.fortran

  function nf90_def_opaque(ncid, size, name, xtype)
    integer, intent(in) :: ncid
    integer, intent(in) :: size
    character (len = *), intent(in) :: name
    integer, intent(out) :: xtype
    integer :: nf90_def_opaque


~~~~


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

## 5.8.2 Learn About an Opaque Type: NF90_INQ_OPAQUE {#f90-learn-about-an-opaque-type-nf90_inq_opaque}



Given a typeid, get the information about an opaque type.



### Usage



~~~~.fortran

  function nf90_inq_opaque(ncid, xtype, name, size)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(out) :: name
    integer, intent(out) :: size
    integer :: nf90_inq_opaque



~~~~

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

5.9 Enum Type Introduction {#f90-enum-type-introduction}
=========================



NetCDF-4 added support for the enum type. This is not supported in
classic or 64-bit offset files.


## 5.9.1 Creating a Enum Type: NF90_DEF_ENUM {#f90-creating-a-enum-type-nf90_def_enum}



Create an enum type. Provide an ncid, a name, and a base integer type.

After calling this function, fill out the type with repeated calls to
NF90\_INSERT\_ENUM (see section [Inserting a Field into a Enum Type:
NF90\_INSERT\_ENUM](#NF90_005fINSERT_005fENUM)). Call NF90\_INSERT\_ENUM
once for each value you wish to make part of the enumeration.



### Usage



~~~~.fortran

  function nf90_def_enum(ncid, base_typeid, name, typeid)
    integer, intent(in) :: ncid
    integer, intent(in) :: base_typeid
    character (len = *), intent(in) :: name
    integer, intent(out) :: typeid
    integer :: nf90_def_enum


~~~~


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



## 5.9.2 Inserting a Field into a Enum Type: NF90_INSERT_ENUM {#f90-inserting-a-field-into-a-enum-type-nf90_insert_enum}



Insert a named member into a enum type.



### Usage



~~~~.fortran

  function nf90_insert_enum(ncid, xtype, name, value)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(in) :: name
    integer, intent(in) :: value
    integer :: nf90_insert_enum


~~~~


`NCID`

:   The ncid of the group which contains the type.

`TYPEID`

:   The typeid for this enum type, as returned by nf90\_def\_enum,
    or nf90\_inq\_var.

`IDENTIFIER`

:   The identifier of the new member.

`VALUE`

:   The value that is to be associated with this member.



### Errors

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



### Example

## 5.9.3 Learn About a Enum Type: NF90_INQ_ENUM {#f90-learn-about-a-enum-type-nf90_inq_enum}



Get information about a user-defined enumeration type.



### Usage


~~~~.fortran


  function nf90_inq_enum(ncid, xtype, name, base_nc_type, base_size, num_members)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    character (len = *), intent(out) :: name
    integer, intent(out) :: base_nc_type
    integer, intent(out) :: base_size
    integer, intent(out) :: num_members
    integer :: nf90_inq_enum



~~~~

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



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPEID`

:   Bad type id.

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



### Example


## 5.9.4 Learn the Name of a Enum Type: nf90_inq_enum_member {#f90-learn-the-name-of-a-enum-type-nf90_inq_enum_member}



Get information about a member of an enum type.



### Usage




~~~~.fortran
  function nf90_inq_enum_member(ncid, xtype, idx, name, value)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    integer, intent(in) :: idx
    character (len = *), intent(out) :: name
    integer, intent(in) :: value
    integer :: nf90_inq_enum_member

~~~~



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



### Errors

`NF90_NOERR`

:   No error.

`NF90_EBADTYPEID`

:   Bad type id.

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.



### Example



## 5.9.5 Learn the Name of a Enum Type: NF90_INQ_ENUM_IDENT {#f90-learn-the-name-of-a-enum-type-nf90_inq_enum_ident}



Get the name which is associated with an enum member value.

This is similar to NF90\_INQ\_ENUM\_MEMBER, but instead of using the
index of the member, you use the value of the member.



### Usage



~~~~.fortran

  function nf90_inq_enum_ident(ncid, xtype, value, idx)
    integer, intent(in) :: ncid
    integer, intent(in) :: xtype
    integer, intent(in) :: value
    integer, intent(out) :: idx
    integer :: nf90_inq_enum_ident


~~~~


`NCID`

:   The groupid where this enum type exists.

`XTYPE`

:   The typeid for this enum type.

`VALUE`

:   The value for which an identifier is sought.

`IDENTIFIER`

:   A character array that will get the identifier. It will have a
    maximum length of NF90\_MAX\_NAME.



### Return Code


`NF90_NOERR`

:   No error.

`NF90_EBADTYPEID`

:   Bad type id, or not an enum type.

`NF90_EHDFERR`

:   An error was reported by the HDF5 layer.

`NF90_EINVAL`

:   The value was not found in the enum.



### Example
