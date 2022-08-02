Module netcdf_nc_data

! Data types and flags for Fortran2003 interfaces to NetCDF C routines
!
! Written by: Richard Weed, Ph.D.
!             Center for Advanced Vehicular Systems     
!             Mississippi State University
!             rweed@cavs.msstate.edu


! License (and other Lawyer Language)
 
! This software is released under the Apache 2.0 Open Source License. The
! full text of the License can be viewed at :
!
!   http:www.apache.org/licenses/LICENSE-2.0.html
!
! The author grants to the University Corporation for Atmospheric Research
! (UCAR), Boulder, CO, USA the right to revise and extend the software
! without restriction. However, the author retains all copyrights and
! intellectual property rights explicitly stated in or implied by the
! Apache license

! Version 1.:  Sept. 2005 - Initial Cray X1 version
! Version 2.:  May 2006   - Updated to support g95
! Version 3.:  June 2006  - Updated to include netCDF 4 functions
! Version 4.:  July 2007  - Modified to work with 3.6.2 build system
! Version 5.:  April 2009 - Updated to NetCDF 4.0.1
! Version 6.:  April 2010 - Updated to NetCDF 4.1.1
! Version 7.:  Feb.  2012 - Added support for F2008 Intrinsic kinds
! Version 8.:  Feb.  2013 - Updated for netcdf fortran-4.4
! Version 9.:  April 2014 - Changed C_PTRDIFF_T to UCAR definitions
! Version 10.: Jan.  2016 - General code cleanup. Added a definition
!                           for a C_ENUM kind paramater for future
!                           code mods. Added several new parameters
!                           to include all of the values supported
!                           in netcdf_constant.f90

 USE ISO_C_BINDING ! All subsequent USE associations of netcdf_nc_data
                   ! will inherit ISO_C_BINDING data

! The following will allow us to use the Fortran 2008 default intrinsic
! kind variables contained in Fortran 2008 ISO_FORTRAN_ENV module when
! compilers support it. Actually most of the major compilers (and even
! the latest gfortran) support these now (Feb. 2012)
 
#ifdef HAVE_F2008
 USE ISO_FORTRAN_ENV, ONLY: REAL32, REAL64, INT8, INT16, INT32, INT64
#endif
 Implicit NONE

! All of the stuff inside this ifndef black needs to be moved to a
! stantdalone module and combined with the f90 interfaces typesizes
! module

#ifndef HAVE_F2008
 
! Create our own REAL32, REAL64, INT8, INT16, INT32, INT64 if we don't have F2008
! ISO_FORTRAN_ENV module

 Integer, Parameter, PRIVATE :: REAL32 = SELECTED_REAL_KIND(P=6,  R=37)   ! float 
 Integer, Parameter, PRIVATE :: REAL64 = SELECTED_REAL_KIND(P=13, R=307)  ! double
 Integer, Parameter, PRIVATE :: INT8   = SELECTED_INT_KIND( 2)
 Integer, Parameter, PRIVATE :: INT16  = SELECTED_INT_KIND( 4)
 Integer, Parameter, PRIVATE :: INT32  = SELECTED_INT_KIND( 9)            ! int
 Integer, Parameter, PRIVATE :: INT64  = SELECTED_INT_KIND(18)            ! long long
#endif

! Set KIND parameters to shorter names used in f03 interface routines etc.

 Integer, Parameter :: RK4 = REAL32
 Integer, Parameter :: RK8 = REAL64
 Integer, Parameter :: IK1 = INT8
 Integer, Parameter :: IK2 = INT16
 Integer, Parameter :: IK4 = INT32
 Integer, Parameter :: IK8 = INT64
 
! Define processor/compiler dependent parameters for ptrdiff_t, signed char,
! and short types. Note prtdiff_t was not defined in the FORTRAN 2003
! standard as an interoperable type in ISO_C_BINDING but was added as part of
! the recent TS29113 Technical Specification "Futher Interoperability with C" 
! passed in 2012. For now we will make our own using C_INT32_T or C_INT64_T
! but allow users to use the default definition for compilers that support 
! TS29113 (like gfortran 4.8). Default will be C_INTPTR_T 

#ifndef HAVE_TS29113_SUPPORT
#if (SIZEOF_PTRDIFF_T == 4)
 Integer, Parameter :: C_PTRDIFF_T = C_INT32_T
#elif (SIZEOF_PTRDIFF_T == 8)
 Integer, Parameter :: C_PTRDIFF_T = C_INT64_T
#else
 Integer, Parameter :: C_PTRDIFF_T = C_INTPTR_T
#endif
#endif

! Set KIND parameters for 1 and 2 byte integers if the system 
! supports them based on what is set by configure in nfconfig.inc.
! The routines that use these values will issue an EBADTYPE error
! and exit if C_SIGNED_CHAR and C_SHORT are not supported in
! ISO_C_BINDING

! Set the KINDs to default integers otherwise.

! INT1 KINDs

#ifdef NF_INT1_IS_C_SIGNED_CHAR
 Integer, Parameter :: CINT1 = C_SIGNED_CHAR
 Integer, Parameter :: NFINT1 = IK1
#elif NF_INT1_IS_C_SHORT
 Integer, Parameter :: CINT1 = C_SHORT
 Integer, Parameter :: NFINT1 = IK2
#elif NF_INT1_IS_C_INT
 Integer, Parameter :: CINT1 = C_INT
 Integer, Parameter :: NFINT1 = IK4
#elif NF_INT1_IS_C_LONG
 Integer, Parameter :: CINT1 = C_LONG
 Integer, Parameter :: NFINT1 = IK8
#else
 Integer, Parameter :: CINT1 = C_SIGNED_CHAR
 Integer, Parameter :: NFINT1 = IK1
#endif

! INT2 KINDs

#ifdef NF_INT2_IS_C_SHORT
 Integer, Parameter :: CINT2 = C_SHORT
 Integer, Parameter :: NFINT2 = IK2
#elif NF_INT2_IS_C_INT
 Integer, Parameter :: CINT2 = C_INT
 Integer, Parameter :: NFINT2 = IK4
#elif NF_INT2_IS_C_LONG
 Integer, Parameter :: CINT2 = C_LONG
 Integer, Parameter :: NFINT2 = IK8
#else
 Integer, Parameter :: CINT2 = C_SHORT
 Integer, Parameter :: NFINT2 = IK2
#endif

! Set Fortran default integer kind. This
! should take care of the case were default
! integer is a 64 bit int (ala prehistoric
! CRAYS) 

#ifdef NF_INT_IS_C_LONG
 Integer, Parameter :: CINT = C_LONG
 Integer, Parameter :: NFINT = IK8 
#else
 Integer, Parameter :: CINT = C_INT
 Integer, Parameter :: NFINT = IK4
#endif

! INT8 KINDs

#ifdef NF_INT8_IS_C_SHORT
 Integer, Parameter :: CINT8 = C_SHORT
 Integer, Parameter :: NFINT8 = IK2
#elif NF_INT8_IS_C_INT
 Integer, Parameter :: CINT8 = C_INT
 Integer, Parameter :: NFINT8 = IK4
#else
 Integer, Parameter :: CINT8 = C_LONG_LONG
 Integer, Parameter :: NFINT8 = IK8
#endif

! Set Fortran default real kind. This should
! take care of the case were the default real
! type is a 64 bit real (ala prehistoric CRAYs) 

#ifdef NF_REAL_IS_C_DOUBLE
  Integer, Parameter :: NFREAL = RK8
#else
  Integer, Parameter :: NFREAL = RK4
#endif

! Create a C_ENUM kind which should be just C_INT (but you never know).
! Don't know why this wasn't included in the C Interop standard but it
! would have been nice to have.

! This will eventually be used to replace the current integer values in the
! interfaces with something that should be consistent with C enum data
! types. Mostly this is cosmetic to identify in the code that we are 
! passing something that is a enumerator member in C. 

 Enum, BIND(C)
   Enumerator :: dummy
 End Enum

 Private :: dummy

 Integer, Parameter :: C_ENUM = KIND(dummy)

 
!--------- Define default C interface parameters from netcdf.h   ---------------

! This is not a complete impementation of the C header files but 
! defines NC_ values equivalent to the values in the netcdf.inc files
! excluding the V2 values

!                     NETCDF3 data
!               
! Define enumerator nc_type data as integers

 Integer(C_INT), Parameter :: NC_NAT    = 0
 Integer(C_INT), Parameter :: NC_BYTE   = 1
 Integer(C_INT), Parameter :: NC_CHAR   = 2
 Integer(C_INT), Parameter :: NC_SHORT  = 3
 Integer(C_INT), Parameter :: NC_INT    = 4
 Integer(C_INT), Parameter :: NC_FLOAT  = 5
 Integer(C_INT), Parameter :: NC_DOUBLE = 6

! Default fill values

 Character(KIND=C_CHAR), Parameter :: NC_FILL_CHAR   = C_NULL_CHAR 
 Integer(C_SIGNED_CHAR), Parameter :: NC_FILL_BYTE   = -127_C_SIGNED_CHAR
 Integer(C_SHORT),       Parameter :: NC_FILL_SHORT  = -32767_C_SHORT
 Integer(C_INT),         Parameter :: NC_FILL_INT    = -2147483647_C_INT
 Real(C_FLOAT),          Parameter :: NC_FILL_FLOAT  = 9.9692099683868690E+36
 Real(C_DOUBLE),         Parameter :: NC_FILL_DOUBLE = 9.9692099683868690D+36

! Mode flags for opening and creating datasets

 Integer(C_INT), Parameter :: NC_NOWRITE          = 0
 Integer(C_INT), Parameter :: NC_WRITE            = 1
 Integer(C_INT), Parameter :: NC_CLOBBER          = 0
 Integer(C_INT), Parameter :: NC_NOCLOBBER        = 4
 Integer(C_INT), Parameter :: NC_FILL             = 0
 Integer(C_INT), Parameter :: NC_NOFILL           = 256
 Integer(C_INT), Parameter :: NC_LOCK             = 1024
 Integer(C_INT), Parameter :: NC_SHARE            = 2048
 Integer(C_INT), Parameter :: NC_STRICT_NC3       = 8
 Integer(C_INT), Parameter :: NC_64BIT_OFFSET     = 512
 Integer(C_INT), Parameter :: NC_64BIT_DATA       = 32
 Integer(C_INT), Parameter :: NC_CDF5             = NC_64BIT_DATA
 Integer(C_INT), Parameter :: NC_SIZEHINT_DEFAULT = 0
 Integer(C_INT), Parameter :: NC_ALIGN_CHUNK      = -1
 Integer(C_INT), Parameter :: NC_FORMAT_CLASSIC   = 1
 Integer(C_INT), Parameter :: NC_FORMAT_64BIT     = 2
 Integer(C_INT), Parameter :: NC_FORMAT_64BIT_OFFSET = NC_FORMAT_64BIT
 Integer(C_INT), Parameter :: NC_FORMAT_64BIT_DATA   = 5
 Integer(C_INT), Parameter :: NC_FORMAT_CDF5         = NC_FORMAT_64BIT_DATA
 Integer(C_INT), Parameter :: NC_DISKLESS         = 8
 Integer(C_INT), Parameter :: NC_MMAP             = 16
 Integer(C_INT), Parameter :: NC_INMEMORY         = 32768

! Unlimited dimension size argument and global attibute ID

 Integer(C_INT),  Parameter :: NC_UNLIMITED = 0
 Integer(C_INT),  Parameter :: NC_GLOBAL    = 0 

! Implementation limits (WARNING!  SHOULD BE THE SAME AS C INTERFACE)

 Integer(C_INT), Parameter :: NC_MAX_DIMS     = 1024 
 Integer(C_INT), Parameter :: NC_MAX_ATTRS    = 8192 
 Integer(C_INT), Parameter :: NC_MAX_VARS     = 8192 
 Integer(C_INT), Parameter :: NC_MAX_NAME     = 256 
 Integer(C_INT), Parameter :: NC_MAX_VAR_DIMS = NC_MAX_DIMS

! Error codes

 Integer(C_INT), Parameter :: NC_NOERR        =  0
 Integer(C_INT), Parameter :: NC2_ERR         = -1
 Integer(C_INT), Parameter :: NC_SYSERR       = -31
 Integer(C_INT), Parameter :: NC_EXDR         = -32
 Integer(C_INT), Parameter :: NC_EBADID       = -33
 Integer(C_INT), Parameter :: NC_EBFILE       = -34
 Integer(C_INT), Parameter :: NC_EEXIST       = -35
 Integer(C_INT), Parameter :: NC_EINVAL       = -36
 Integer(C_INT), Parameter :: NC_EPERM        = -37
 Integer(C_INT), Parameter :: NC_ENOTINDEFINE = -38
 Integer(C_INT), Parameter :: NC_EINDEFINE    = -39
 Integer(C_INT), Parameter :: NC_EINVALCOORDS = -40
 Integer(C_INT), Parameter :: NC_EMAXDIMS     = -41
 Integer(C_INT), Parameter :: NC_ENAMEINUSE   = -42
 Integer(C_INT), Parameter :: NC_ENOTATT      = -43
 Integer(C_INT), Parameter :: NC_EMAXATTS     = -44
 Integer(C_INT), Parameter :: NC_EBADTYPE     = -45
 Integer(C_INT), Parameter :: NC_EBADDIM      = -46
 Integer(C_INT), Parameter :: NC_EUNLIMPOS    = -47
 Integer(C_INT), Parameter :: NC_EMAXVARS     = -48
 Integer(C_INT), Parameter :: NC_ENOTVAR      = -49
 Integer(C_INT), Parameter :: NC_EGLOBAL      = -50
 Integer(C_INT), Parameter :: NC_ENOTNC       = -51
 Integer(C_INT), Parameter :: NC_ESTS         = -52
 Integer(C_INT), Parameter :: NC_EMAXNAME     = -53
 Integer(C_INT), Parameter :: NC_EUNLIMIT     = -54
 Integer(C_INT), Parameter :: NC_ENORECVARS   = -55
 Integer(C_INT), Parameter :: NC_ECHAR        = -56
 Integer(C_INT), Parameter :: NC_EEDGE        = -57
 Integer(C_INT), Parameter :: NC_ESTRIDE      = -58
 Integer(C_INT), Parameter :: NC_EBADNAME     = -59
 Integer(C_INT), Parameter :: NC_ERANGE       = -60
 Integer(C_INT), Parameter :: NC_ENOMEM       = -61
 Integer(C_INT), Parameter :: NC_EVARSIZE     = -62
 Integer(C_INT), Parameter :: NC_EDIMSIZE     = -63
 Integer(C_INT), Parameter :: NC_ETRUNC       = -64
 Integer(C_INT), Parameter :: NC_EAXISTYPE    = -65

! DAP error codes

 Integer(C_INT), Parameter :: NC_EDAP           = -66
 Integer(C_INT), Parameter :: NC_ECURL          = -67
 Integer(C_INT), Parameter :: NC_EIO            = -68
 Integer(C_INT), Parameter :: NC_ENODATA        = -69
 Integer(C_INT), Parameter :: NC_EDAPSVC        = -70
 Integer(C_INT), Parameter :: NC_EDAS           = -71
 Integer(C_INT), Parameter :: NC_EDDS           = -72
 Integer(C_INT), Parameter :: NC_EDATADDS       = -73
 Integer(C_INT), Parameter :: NC_EDAPURL        = -74
 Integer(C_INT), Parameter :: NC_EDAPCONSTRAINT = -75
 Integer(C_INT), Parameter :: NC_ETRANSLATION   = -76

! Error handling codes

 Integer(C_INT), Parameter :: NC_FATAL   = 1
 Integer(C_INT), Parameter :: NC_VERBOSE = 2

#ifdef USE_NETCDF4

!                          NETCDF4 data

 Integer(C_INT), Parameter :: NC_FORMAT_NETCDF4         = 3
 Integer(C_INT), Parameter :: NC_FORMAT_NETCDF4_CLASSIC = 4
 Integer(C_INT), Parameter :: NC_NETCDF4                = 4096
 Integer(C_INT), Parameter :: NC_CLASSIC_MODEL          = 256

! extra netcdf4 types

 Integer(C_INT), Parameter :: NC_LONG     = NC_INT
 Integer(C_INT), Parameter :: NC_UBYTE    = 7
 Integer(C_INT), Parameter :: NC_USHORT   = 8 
 Integer(C_INT), Parameter :: NC_UINT     = 9
 Integer(C_INT), Parameter :: NC_INT64    = 10 
 Integer(C_INT), Parameter :: NC_UINT64   = 11 
 Integer(C_INT), Parameter :: NC_STRING   = 12
 Integer(C_INT), Parameter :: NC_VLEN     = 13
 Integer(C_INT), Parameter :: NC_OPAQUE   = 14
 Integer(C_INT), Parameter :: NC_ENUM     = 15
 Integer(C_INT), Parameter :: NC_COMPOUND = 16

! extra netcd4 fill values

 Integer(C_INT),       Parameter :: NC_FILL_UBYTE  = 255
 Integer(C_INT),       Parameter :: NC_FILL_USHORT = 65535
 Integer(C_LONG_LONG), Parameter :: NC_FILL_UINT   = 4294967295_C_LONG_LONG
 Integer(C_LONG_LONG), Parameter :: NC_FILL_INT64  = -9223372036854775806_C_LONG_LONG

! extra netcdf4 variable flags 

 Integer(C_INT), Parameter :: NC_CHUNK_SEQ      = 0 
 Integer(C_INT), Parameter :: NC_CHUNK_SUB      = 1 
 Integer(C_INT), Parameter :: NC_CHUNK_SIZES    = 2 
 Integer(C_INT), Parameter :: NC_ENDIAN_NATIVE  = 0 
 Integer(C_INT), Parameter :: NC_ENDIAN_LITTLE  = 1 
 Integer(C_INT), Parameter :: NC_ENDIAN_BIG     = 2 
 Integer(C_INT), Parameter :: NC_CHUNKED        = 0
 Integer(C_INT), Parameter :: NC_NOTCONTIGUOUS  = 0
 Integer(C_INT), Parameter :: NC_CONTIGUOUS     = 1
 Integer(C_INT), Parameter :: NC_NOCHECKSUM     = 0
 Integer(C_INT), Parameter :: NC_FLETCHER32     = 1
 Integer(C_INT), Parameter :: NC_NOSHUFFLE      = 0
 Integer(C_INT), Parameter :: NC_SHUFFLE        = 1
 Integer(C_INT), Parameter :: NC_INDEPENDENT    = 0
 Integer(C_INT), Parameter :: NC_COLLECTIVE     = 1

! flags for parallel i/o

 Integer(C_INT), Parameter :: NC_MPIIO          = 8192
 Integer(C_INT), Parameter :: NC_MPIPOSIX       = 16384
 Integer(C_INT), Parameter :: NC_PNETCDF        = NC_MPIIO 

 Integer(C_INT), Parameter :: NC_SZIP_EC_OPTION_MASK = 4
 Integer(C_INT), Parameter :: NC_SZIP_NN_OPTION_MASK = 32

! extra netcdf4 error flags

 Integer(C_INT), Parameter :: NC_EHDFERR        = -101
 Integer(C_INT), Parameter :: NC_ECANTREAD      = -102
 Integer(C_INT), Parameter :: NC_ECANTWRITE     = -103
 Integer(C_INT), Parameter :: NC_ECANTCREATE    = -104
 Integer(C_INT), Parameter :: NC_EFILEMETA      = -105
 Integer(C_INT), Parameter :: NC_EDIMMETA       = -106
 Integer(C_INT), Parameter :: NC_EATTMETA       = -107
 Integer(C_INT), Parameter :: NC_EVARMETA       = -108
 Integer(C_INT), Parameter :: NC_ENOCOMPOUND    = -109
 Integer(C_INT), Parameter :: NC_EATTEXISTS     = -110
 Integer(C_INT), Parameter :: NC_ENOTNC4        = -111
 Integer(C_INT), Parameter :: NC_ESTRICTNC3     = -112
 Integer(C_INT), Parameter :: NC_ENOTNC3        = -113
 Integer(C_INT), Parameter :: NC_ENOPAR         = -114
 Integer(C_INT), Parameter :: NC_EPARINIT       = -115
 Integer(C_INT), Parameter :: NC_EBADGRPID      = -116
 Integer(C_INT), Parameter :: NC_EBADTYPID      = -117
 Integer(C_INT), Parameter :: NC_ETYPDEFINED    = -118
 Integer(C_INT), Parameter :: NC_EBADFIELD      = -119
 Integer(C_INT), Parameter :: NC_EBADCLASS      = -120
 Integer(C_INT), Parameter :: NC_EMAPTYPE       = -121
 Integer(C_INT), Parameter :: NC_ELATEFILL      = -122
 Integer(C_INT), Parameter :: NC_ELATEDEF       = -123
 Integer(C_INT), Parameter :: NC_EDIMSCALE      = -124
 Integer(C_INT), Parameter :: NC_ENOGRP         = -125
 Integer(C_INT), Parameter :: NC_ESTORAGE       = -126
 Integer(C_INT), Parameter :: NC_EBADCHUNK      = -127
 Integer(C_INT), Parameter :: NC_ENOTBUILT      = -128
 Integer(C_INT), Parameter :: NC_EDISKLESS      = -129
 Integer(C_INT), Parameter :: NC_ECANTEXTEND    = -130
 Integer(C_INT), Parameter :: NC_EMPI           = -131
 Integer(C_INT), Parameter :: NC_EFILTER        = -132
 Integer(C_INT), Parameter :: NC_ERCFILE        = -133
 Integer(C_INT), Parameter :: NC_ENULLPAD       = -134
 Integer(C_INT), Parameter :: NC_EINMEMORY      = -135
 Integer(C_INT), Parameter :: NC_ENOFILTER      = -136
 Integer(C_INT), Parameter :: NC_ENCZARR        = -137
 Integer(C_INT), Parameter :: NC_ES3            = -138
 Integer(C_INT), Parameter :: NC_EEMPTY         = -139
 Integer(C_INT), Parameter :: NC_EOBJECT        = -140
 Integer(C_INT), Parameter :: NC_ENOOBJECT      = -141
 Integer(C_INT), Parameter :: NC_EPLUGIN        = -142

! Quantize feature 
 Integer(C_INT), Parameter :: NC_NOQUANTIZE           = 0
 Integer(C_INT), Parameter :: NC_QUANTIZE_BITGROOM    = 1

#endif

!------------------------------------------------------------------------------
End Module netcdf_nc_data
