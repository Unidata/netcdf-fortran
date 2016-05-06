7 Attributes {#f90-attributes}
============

[TOC]

7.1 Attributes Introduction {#f90-attributes-introduction}
============

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
============



The function NF90\_PUT\_ATTadds or changes a variable attribute or
global attribute of an open netCDF dataset. If this attribute is new, or
if the space required to store the attribute is greater than before, the
netCDF dataset must be in define mode.



## Usage

Although it’s possible to create attributes of all types, text and
double attributes are adequate for most purposes.


~~~~.fortran


 function nf90_put_att(ncid, varid, name, values)
   integer,            intent( in) :: ncid, varid
   character(len = *), intent( in) :: name
   scalar character string or any numeric type, scalar, or array of rank 1, &
                       intent( in) :: values
   integer                         :: nf90_put_att


~~~~


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



## Errors

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



## Example

Here is an example using NF90\_PUT\_ATT to add a variable attribute
named valid\_range for a netCDF variable named rh and a global attribute
named title to an existing netCDF dataset named foo.nc:


~~~~.fortran


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



~~~~


7.3 Get Information about an Attribute: NF90_INQUIRE_ATTRIBUTE and NF90_INQ_ATTNAME {#f90-get-information-about-an-attribute-nf90_inquire_attribute-and-nf90_inq_attname}
============



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



## Usage



~~~~.fortran

 function nf90_inquire_attribute(ncid, varid, name, xtype, len, attnum)
   integer,             intent( in)           :: ncid, varid
   character (len = *), intent( in)           :: name
   integer,             intent(out), optional :: xtype, len, attnum
   integer                                    :: nf90_inquire_attribute
 function nf90_inq_attname(ncid, varid, attnum, name)
   integer,             intent( in) :: ncid, varid, attnum
   character (len = *), intent(out) :: name
   integer                          :: nf90_inq_attname


~~~~


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



## Errors

Each function returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The variable ID is invalid for the specified netCDF dataset.
-   The specified attribute does not exist.
-   The specified netCDF ID does not refer to an open netCDF dataset.
-   For NF90\_INQ\_ATTNAME, the specified attribute number is negative
    or more than the number of attributes defined for the
    specified variable.



## Example

Here is an example using NF90\_INQUIRE\_ATTRIBUTE to inquire about the
lengths of an attribute named valid\_range for a netCDF variable named
rh and a global attribute named title in an existing netCDF dataset
named foo.nc:



~~~~.fortran

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



~~~~

7.4 Get Attribute’s Values: NF90_GET_ATT {#f90-get-attributes-values-nf90_get_att}
============



Function nf90\_get\_att gets the value(s) of a netCDF attribute, given
its variable ID and name.



## Usage



~~~~.fortran

 function nf90_get_att(ncid, varid, name, values)
   integer,            intent( in) :: ncid, varid
   character(len = *), intent( in) :: name
   any valid type, scalar or array of rank 1, &
                       intent(out) :: values
   integer                         :: nf90_get_att



~~~~

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



## Errors

~~~~.fortran

NF90\_GET\_ATT\_ type returns the value NF90\_NOERR if no errors
occurred. Otherwise, the returned status indicates an error. Possible
causes of errors include:

-   The variable ID is invalid for the specified netCDF dataset.
-   The specified attribute does not exist.
-   The specified netCDF ID does not refer to an open netCDF dataset.
-   One or more of the attribute values are out of the range of values
    representable by the desired type.

~~~~


## Example

Here is an example using NF90\_GET\_ATT to determine the values of an
attribute named valid\_range for a netCDF variable named rh and a global
attribute named title in an existing netCDF dataset named foo.nc. In
this example, it is assumed that we don’t know how many values will be
returned, so we first inquire about the length of the attributes to make
sure we have enough space to store them:


~~~~.fortran


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


~~~~



7.5 Copy Attribute from One NetCDF to Another: NF90_COPY_ATT {#f90-copy-attribute-from-one-netcdf-to-another-nf90_copy_att}
============



The function NF90\_COPY\_ATT copies an attribute from one open netCDF
dataset to another. It can also be used to copy an attribute from one
variable to another within the same netCDF dataset.

If used to copy an attribute of user-defined type, then that
user-defined type must already be defined in the target file. In the
case of user-defined attributes, enddef/redef is called for ncid\_in and
ncid\_out if they are in define mode. (This is the ensure that all
user-defined types are committed to the file(s) before the copy is
attempted.)



## Usage

~~~~.fortran

 function nf90_copy_att(ncid_in, varid_in, name, ncid_out, varid_out)
   integer,             intent( in) :: ncid_in,  varid_in
   character (len = *), intent( in) :: name
   integer,             intent( in) :: ncid_out, varid_out
   integer                          :: nf90_copy_att




~~~~

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



## Errors

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



## Example

Here is an example using NF90\_COPY\_ATT to copy the variable attribute
units from the variable rh in an existing netCDF dataset named foo.nc to
the variable avgrh in another existing netCDF dataset named bar.nc,
assuming that the variable avgrh already exists, but does not yet have a
units attribute:


~~~~.fortran


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



~~~~

7.6 Rename an Attribute: NF90_RENAME_ATT {#f90-rename-an-attribute-nf90_rename_att}
============



The function NF90\_RENAME\_ATT changes the name of an attribute. If the
new name is longer than the original name, the netCDF dataset must be in
define mode. You cannot rename an attribute to have the same name as
another attribute of the same variable.



## Usage


~~~~.fortran


 function nf90_rename_att(ncid, varid, curname, newname)
   integer,             intent( in) :: ncid,  varid
   character (len = *), intent( in) :: curname, newname
   integer                          :: nf90_rename_att




~~~~

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



## Errors

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



## Example

Here is an example using NF90\_RENAME\_ATT to rename the variable
attribute units to Units for a variable rh in an existing netCDF dataset
named foo.nc:

~~~~.fortran

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


~~~~


7.7 NF90_DEL_ATT {#f90-nf90_del_att}
============



The function NF90\_DEL\_ATT deletes a netCDF attribute from an open
netCDF dataset. The netCDF dataset must be in define mode.



## Usage


~~~~.fortran


 function nf90_del_att(ncid, varid, name)
   integer,             intent( in) :: ncid, varid
   character (len = *), intent( in) :: name
   integer                          :: nf90_del_att

~~~~



`ncid`

:   NetCDF ID, from a previous call to NF90\_OPEN or NF90\_CREATE.

`varid`

:   ID of the attribute’s variable, or NF90\_GLOBAL for a
    global attribute.

`name`

:   The name of the attribute to be deleted.



## Errors

NF90\_DEL\_ATT returns the value NF90\_NOERR if no errors occurred.
Otherwise, the returned status indicates an error. Possible causes of
errors include:

-   The specified variable ID is not valid.
-   The specified netCDF dataset is in data mode.
-   The specified attribute does not exist.
-   The specified netCDF ID does not refer to an open netCDF dataset.



## Example

Here is an example using NF90\_DEL\_ATT to delete the variable attribute
Units for a variable rh in an existing netCDF dataset named foo.nc:



~~~~.fortran

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

~~~~
