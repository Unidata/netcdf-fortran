
1 Use of the NetCDF Library {#f90-use-of-the-netcdf-library}
=====================

[TOC]

In this chapter we provide templates of common sequences of netCDF calls
needed for common uses. For clarity we present only the names of
routines; omit declarations and error checking; omit the type-specific
suffixes of routine names for variables and attributes; indent
statements that are typically invoked multiple times; and use ... to
represent arbitrary sequences of other statements. Full parameter lists
are described in later chapters.

1.1 Creating a NetCDF Dataset {#f90-creating-a-netcdf-dataset}
=====================

Here is a typical sequence of netCDF calls used to create a new netCDF
dataset:

~~~~.fortran


     NF90_CREATE           ! create netCDF dataset: enter define mode
          ...
        NF90_DEF_DIM       ! define dimensions: from name and length
          ...
        NF90_DEF_VAR       ! define variables: from name, type, dims
          ...
        NF90_PUT_ATT       ! assign attribute values
          ...
     NF90_ENDDEF           ! end definitions: leave define mode
          ...
        NF90_PUT_VAR       ! provide values for variable
          ...
     NF90_CLOSE            ! close: save new netCDF dataset

~~~~


Only one call is needed to create a netCDF dataset, at which point you
will be in the first of two netCDF modes. When accessing an open netCDF
dataset, it is either in define mode or data mode. In define mode, you
can create dimensions, variables, and new attributes, but you cannot
read or write variable data. In data mode, you can access data and
change existing attributes, but you are not permitted to create new
dimensions, variables, or attributes.

One call to NF90\_DEF\_DIM is needed for each dimension created.
Similarly, one call to NF90\_DEF\_VAR is needed for each variable
creation, and one call to a member of the NF90\_PUT\_ATT family is
needed for each attribute defined and assigned a value. To leave define
mode and enter data mode, call NF90\_ENDDEF.

Once in data mode, you can add new data to variables, change old values,
and change values of existing attributes (so long as the attribute
changes do not require more storage space). Data of all types is written
to a netCDF variable using the NF90\_PUT\_VAR subroutine. Single values,
arrays, or array sections may be supplied to NF90\_PUT\_VAR; optional
arguments allow the writing of subsampled or mapped portions of the
variable. (Subsampled and mapped access are general forms of data access
that are explained later.)

Finally, you should explicitly close all netCDF datasets that have been
opened for writing by calling NF90\_CLOSE. By default, access to the
file system is buffered by the netCDF library. If a program terminates
abnormally with netCDF datasets open for writing, your most recent
modifications may be lost. This default buffering of data is disabled by
setting the NF90\_SHARE flag when opening the dataset. But even if this
flag is set, changes to attribute values or changes made in define mode
are not written out until NF90\_SYNC or NF90\_CLOSE is called.

1.2 Reading a NetCDF Dataset with Known Names {#f90-reading-a-netcdf-dataset-with-known-names}
=====================
Here we consider the case where you know the names of not only the
netCDF datasets, but also the names of their dimensions, variables, and
attributes. (Otherwise you would have to do "inquire" calls.) The order
of typical C calls to read data from those variables in a netCDF dataset
is:

~~~~.fortran




     NF90_OPEN               ! open existing netCDF dataset
          ...
        NF90_INQ_DIMID       ! get dimension IDs
          ...
        NF90_INQ_VARID       ! get variable IDs
          ...
        NF90_GET_ATT         ! get attribute values
          ...
        NF90_GET_VAR         ! get values of variables
          ...
     NF90_CLOSE              ! close netCDF dataset



~~~~


First, a single call opens the netCDF dataset, given the dataset name,
and returns a netCDF ID that is used to refer to the open netCDF dataset
in all subsequent calls.

Next, a call to NF90\_INQ\_DIMID for each dimension of interest gets the
dimension ID from the dimension name. Similarly, each required variable
ID is determined from its name by a call to NF90\_INQ\_VARID. Once
variable IDs are known, variable attribute values can be retrieved using
the netCDF ID, the variable ID, and the desired attribute name as input
to NF90\_GET\_ATT for each desired attribute. Variable data values can
be directly accessed from the netCDF dataset with calls to
NF90\_GET\_VAR.

Finally, the netCDF dataset is closed with NF90\_CLOSE. There is no need
to close a dataset open only for reading.

1.3 Reading a netCDF Dataset with Unknown Names {#f90-reading-a-netcdf-dataset-with-unknown-names}
=====================

It is possible to write programs (e.g., generic software) which do such
things as processing every variable, without needing to know in advance
the names of these variables. Similarly, the names of dimensions and
attributes may be unknown.

Names and other information about netCDF objects may be obtained from
netCDF datasets by calling inquire functions. These return information
about a whole netCDF dataset, a dimension, a variable, or an attribute.
The following template illustrates how they are used:



~~~~.fortran

     NF90_OPEN                 ! open existing netCDF dataset
       ...
     NF90_INQUIRE              ! find out what is in it
          ...
        NF90_INQUIRE_DIMENSION ! get dimension names, lengths
          ...
        NF90_INQUIRE_VARIABLE  ! get variable names, types, shapes
             ...
           NF90_INQ_ATTNAME    ! get attribute names
             ...
           NF90_INQUIRE_ATTRIBUTE ! get other attribute information
             ...
           NF90_GET_ATT        ! get attribute values
             ...
        NF90_GET_VAR           ! get values of variables
          ...
     NF90_CLOSE                ! close netCDF dataset


~~~~


As in the previous example, a single call opens the existing netCDF
dataset, returning a netCDF ID. This netCDF ID is given to the
NF90\_INQUIRE routine, which returns the number of dimensions, the
number of variables, the number of global attributes, and the ID of the
unlimited dimension, if there is one.

All the inquire functions are inexpensive to use and require no I/O,
since the information they provide is stored in memory when a netCDF
dataset is first opened.

Dimension IDs use consecutive integers, beginning at 1. Also dimensions,
once created, cannot be deleted. Therefore, knowing the number of
dimension IDs in a netCDF dataset means knowing all the dimension IDs:
they are the integers 1, 2, 3, ...up to the number of dimensions. For
each dimension ID, a call to the inquire function
NF90\_INQUIRE\_DIMENSION returns the dimension name and length.

Variable IDs are also assigned from consecutive integers 1, 2, 3, ... up
to the number of variables. These can be used in NF90\_INQUIRE\_VARIABLE
calls to find out the names, types, shapes, and the number of attributes
assigned to each variable.

Once the number of attributes for a variable is known, successive calls
to NF90\_INQ\_ATTNAME return the name for each attribute given the
netCDF ID, variable ID, and attribute number. Armed with the attribute
name, a call to NF90\_INQUIRE\_ATTRIBUTE returns its type and length.
Given the type and length, you can allocate enough space to hold the
attribute values. Then a call to NF90\_GET\_ATT returns the attribute
values.

Once the IDs and shapes of netCDF variables are known, data values can
be accessed by calling NF90\_GET\_VAR.


1.4 Writing Data in an Existing NetCDF Dataset {#f90-writing-data-in-an-existing-netcdf-dataset}
=====================

With write access to an existing netCDF dataset, you can overwrite data
values in existing variables or append more data to record variables
along the unlimited (record) dimension. To append more data to
non-record variables requires changing the shape of such variables,
which means creating a new netCDF dataset, defining new variables with
the desired shape, and copying data. The netCDF data model was not
designed to make such "schema changes" efficient or easy, so it is best
to specify the shapes of variables correctly when you create a netCDF
dataset, and to anticipate which variables will later grow by using the
unlimited dimension in their definition.

The following code template lists a typical sequence of calls to
overwrite some existing values and add some new records to record
variables in an existing netCDF dataset with known variable names:


~~~~.fortran


     NF90_OPEN             ! open existing netCDF dataset
       ...
       NF90_INQ_VARID      ! get variable IDs
       ...
       NF90_PUT_VAR        ! provide new values for variables, if any
       ...
       NF90_PUT_ATT        ! provide new values for attributes, if any
         ...
     NF90_CLOSE            ! close netCDF dataset



~~~~

A netCDF dataset is first opened by the NF90\_OPEN call. This call puts
the open dataset in data mode, which means existing data values can be
accessed and changed, existing attributes can be changed, but no new
dimensions, variables, or attributes can be added.

Next, calls to NF90\_INQ\_VARID get the variable ID from the name, for
each variable you want to write. Then each call to NF90\_PUT\_VAR writes
data into a specified variable, either a single value at a time, or a
whole set of values at a time, depending on which variant of the
interface is used. The calls used to overwrite values of non-record
variables are the same as are used to overwrite values of record
variables or append new data to record variables. The difference is
that, with record variables, the record dimension is extended by writing
values that don’t yet exist in the dataset. This extends all record
variables at once, writing "fill values" for record variables for which
the data has not yet been written (but see section [Fill
Values](#Fill-Values) to specify different behavior).

Calls to NF90\_PUT\_ATT may be used to change the values of existing
attributes, although data that changes after a file is created is
typically stored in variables rather than attributes.

Finally, you should explicitly close any netCDF datasets into which data
has been written by calling NF90\_CLOSE before program termination.
Otherwise, modifications to the dataset may be lost.

1.5 Adding New Dimensions, Variables, Attributes {#f90-adding-new-dimensions-variables-attributes}
=====================

An existing netCDF dataset can be extensively altered. New dimensions,
variables, and attributes can be added or existing ones renamed, and
existing attributes can be deleted. Existing dimensions, variables, and
attributes can be renamed. The following code template lists a typical
sequence of calls to add new netCDF components to an existing dataset:


~~~~.fortran


     NF90_OPEN             ! open existing netCDF dataset
       ...
     NF90_REDEF            ! put it into define mode
         ...
       NF90_DEF_DIM        ! define additional dimensions (if any)
         ...
       NF90_DEF_VAR        ! define additional variables (if any)
         ...
       NF90_PUT_ATT        ! define other attributes (if any)
         ...
     NF90_ENDDEF           ! check definitions, leave define mode
         ...
       NF90_PUT_VAR        ! provide new variable values
         ...
     NF90_CLOSE            ! close netCDF dataset


~~~~


A netCDF dataset is first opened by the NF90\_OPEN call. This call puts
the open dataset in data mode, which means existing data values can be
accessed and changed, existing attributes can be changed (so long as
they do not grow), but nothing can be added. To add new netCDF
dimensions, variables, or attributes you must enter define mode, by
calling NF90\_REDEF. In define mode, call NF90\_DEF\_DIM to define new
dimensions, NF90\_DEF\_VAR to define new variables, and NF90\_PUT\_ATT
to assign new attributes to variables or enlarge old attributes.

You can leave define mode and reenter data mode, checking all the new
definitions for consistency and committing the changes to disk, by
calling NF90\_ENDDEF. If you do not wish to reenter data mode, just call
NF90\_CLOSE, which will have the effect of first calling NF90\_ENDDEF.

Until the NF90\_ENDDEF call, you may back out of all the redefinitions
made in define mode and restore the previous state of the netCDF dataset
by calling NF90\_ABORT. You may also use the NF90\_ABORT call to restore
the netCDF dataset to a consistent state if the call to NF90\_ENDDEF
fails. If you have called NF90\_CLOSE from definition mode and the
implied call to NF90\_ENDDEF fails, NF90\_ABORT will automatically be
called to close the netCDF dataset and leave it in its previous
consistent state (before you entered define mode).

At most one process should have a netCDF dataset open for writing at one
time. The library is designed to provide limited support for multiple
concurrent readers with one writer, via disciplined use of the
NF90\_SYNC function and the NF90\_SHARE flag. If a writer makes changes
in define mode, such as the addition of new variables, dimensions, or
attributes, some means external to the library is necessary to prevent
readers from making concurrent accesses and to inform readers to call
NF90\_SYNC before the next access.


1.6 Error Handling {#f90-error-handling}
=====================

The netCDF library provides the facilities needed to handle errors in a
flexible way. Each netCDF function returns an integer status value. If
the returned status value indicates an error, you may handle it in any
way desired, from printing an associated error message and exiting to
ignoring the error indication and proceeding (not recommended!). For
simplicity, the examples in this guide check the error status and call a
separate function to handle any errors.

The NF90\_STRERROR function is available to convert a returned integer
error status into an error message string.

Occasionally, low-level I/O errors may occur in a layer below the netCDF
library. For example, if a write operation causes you to exceed disk
quotas or to attempt to write to a device that is no longer available,
you may get an error from a layer below the netCDF library, but the
resulting write error will still be reflected in the returned status
value.

1.7 Compiling and Linking with the NetCDF Library {#f90-compiling-and-linking-with-the-netcdf-library}
=====================
Details of how to compile and link a program that uses the netCDF C or
Fortran interfaces differ, depending on the operating system, the
available compilers, and where the netCDF library and include files are
installed. Nevertheless, we provide here examples of how to compile and
link a program that uses the netCDF library on a Unix platform, so that
you can adjust these examples to fit your installation.

Every Fortran 90 procedure or module which references netCDF constants
or procedures must have access to the module information created when
the netCDF module was compiled. The suffix for this file is “MOD” (or
sometimes “mod”).

Most F90 compilers allow the user to specify the location of .MOD files,
usually with the -I flag.




    $ f90 -c -I/usr/local/include mymodule.f90




Starting with version 3.6.2, another method of building the netCDF
fortran libraries became available. With the –enable-separate-fortran
option to configure, the user can specify that the C library should not
contain the fortran functions. In these cases an additional library,
libnetcdff.a (note the extra “f”) will be built. This library contains
the Fortran functions. Since verion 4.1.3, the netCDF Fortran software
and library is always distinct from the netCDF C library, but depends on
it. If it is installed as a shared library, you need only use
‘-lnetcdff’ to specify the Fortran library for linking.

For more information about configure options, See [Specifying the
Environment for Building](netcdf-install.html#Specifying-the-Environment-for-Building)
in {No value for ‘i-man’}.

If installed as a shared library, link, using something like:




    $ f90 -o myprogram myprogram.o -L/usr/local/lib -lnetcdff




If installed as a static library, you will at least need to mention the
netCDF C library and perhaps other libraries, such as hdf5 or curl,
depending on how the C library was built. For example:




    $ f90 -o myprogram myprogram.o -L/usr/local/lib -lnetcdff -lnetcdf




Use of the nf-config utility program, installed as part of the
netcdf-fortran software, provides an easier way to compile and link,
without needing to know the details of where the library has been
installed, or whether it is installed as a shared or static library.

To see all the options for ‘nf-config’, invoke it with the ‘–help’
argument.

Here’s an example of how you could use ‘nf-config’ to compile and link a
Fortran program in one step:




    $ f90 myprogram.f90 -o myprogram `nf-config --fflags --flibs`




If it is installed on your system, you could also use the ‘pkg-config’
utility to compile and link Fortran programs with the netCDF libraries.
This is especially useful in Makefiles, to insulate them from changes to
library versions and dependencies. Here is an example of how you could
compile and link a Fortran program with netCDF libraries using
pkg-config:




    $ export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
    $ f90 myprogram.f90 -o myprogram `pkg-config --cflags --libs netcdf-fortran`




where here ‘–cflags’ means compiler flags and ‘libs’ requests that the
approriate libraries be linked in.
