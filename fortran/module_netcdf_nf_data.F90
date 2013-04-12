Module netcdf_nf_data

! Module for Netcdf FORTRAN 2003 nf parameters. This includes all the
! error condition parameters, external data types, fill values etc.
! for netCDF2,3,4

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
! The author grants to UCAR the right to revise and extend the software
! without restriction. However, the author retains all copyrights and
! intellectual property rights explicit or implied by the Apache license

! Version 1. Sept. 2005 - initial Cray X1 version for netcdf 3.6,0
! Version 2. Apr.  2005 - updated to be consistent with netcdf 3.6.1
! Version 3. Apr.  2009 - updated for netCDF 4.0.1
! Version 4. Apr.  2010 - updated for netCDF 4.1.1

! This module is provided as a replacement for parts of the netcdf2.inc,
! netcdf3.inc and netcdf4.inc include file2. It does not include the 
! external statements for the nf_ functions. The latter are not needed
! if you use the interfaces in module_netcdf_nf_interfaces. If you
! want the externals, just use the include files.

 USE netcdf_nc_data, ONLY: RK4, RK8, IK4, IK8, NFINT1, NFINT2, &
                           NFINT, NFREAL                   
                                                         
 Implicit NONE

#include "nfconfig.inc"

! Define values found in netcdf2.inc, netcdf3.inc, and netcdf4.inc
! Also some additional values from the NC_DATA interfaces
!                
! Define enumerator nc_type data as integers

 Integer, Parameter ::  NF_NAT    = 0
 Integer, Parameter ::  NF_BYTE   = 1
 Integer, Parameter ::  NF_INT1   = NF_BYTE
 Integer, Parameter ::  NF_CHAR   = 2
 Integer, Parameter ::  NF_SHORT  = 3
 Integer, Parameter ::  NF_INT2   = NF_SHORT
 Integer, Parameter ::  NF_INT    = 4
 Integer, Parameter ::  NF_FLOAT  = 5
 Integer, Parameter ::  NF_REAL   = NF_FLOAT
 Integer, Parameter ::  NF_DOUBLE = 6

! Default fill values

 Integer, Parameter :: NF_FILL_CHAR    = 0 
 Integer, Parameter :: NF_FILL_BYTE    = -127
 Integer, Parameter :: NF_FILL_SHORT   = -32767
 Integer, Parameter :: NF_FILL_INT     = -2147483647

 Real(RK4), Parameter :: NF_FILL_FLOAT   = 9.9692099683868690E+36
 Real(RK4), Parameter :: NF_FILL_REAL    = NF_FILL_FLOAT
 Real(RK4), Parameter :: NF_FILL_REAL4   = NF_FILL_FLOAT 
 Real(RK8), Parameter :: NF_FILL_DOUBLE  = 9.9692099683868690D+36
 Real(RK8), Parameter :: NF_FILL_REAL8   = NF_FILL_DOUBLE 

! Mode flags for opening and creating datasets

 Integer, Parameter :: NF_NOWRITE          = 0
 Integer, Parameter :: NF_WRITE            = 1
 Integer, Parameter :: NF_CLOBBER          = 0
 Integer, Parameter :: NF_NOCLOBBER        = 4
 Integer, Parameter :: NF_FILL             = 0
 Integer, Parameter :: NF_NOFILL           = 256
 Integer, Parameter :: NF_LOCK             = 1024
 Integer, Parameter :: NF_SHARE            = 2048
 Integer, Parameter :: NF_STRICT_NC3       = 8
 Integer, Parameter :: NF_64BIT_OFFSET     = 512
 Integer, Parameter :: NF_SIZEHINT_DEFAULT = 0
 Integer, Parameter :: NF_ALIGN_CHUNK      = -1
 Integer, Parameter :: NF_FORMAT_CLASSIC   = 1
 Integer, Parameter :: NF_FORMAT_64BIT     = 2

! Unlimited dimension size argument and global attibute ID

 Integer,  Parameter :: NF_UNLIMITED = 0
 Integer,  Parameter :: NF_GLOBAL    = 0

! Implementation limits (WARNING!  SHOULD BE THE SAME AS C INTERFACE)

 Integer, Parameter :: NF_MAX_DIMS     = 1024 
 Integer, Parameter :: NF_MAX_ATTRS    = 8192 
 Integer, Parameter :: NF_MAX_VARS     = 8192 
 Integer, Parameter :: NF_MAX_NAME     = 256 
 Integer, Parameter :: NF_MAX_VAR_DIMS = NF_MAX_DIMS

! Error codes

 Integer, Parameter :: NF_NOERR        =  0
 Integer, Parameter :: NC2_ERR         = -1
 Integer, Parameter :: NF_SYSERR       = -31
 Integer, Parameter :: NF_EXDR         = -32
 Integer, Parameter :: NF_EBADID       = -33
 Integer, Parameter :: NF_EBFILE       = -34
 Integer, Parameter :: NF_EEXIST       = -35
 Integer, Parameter :: NF_EINVAL       = -36
 Integer, Parameter :: NF_EPERM        = -37
 Integer, Parameter :: NF_ENOTINDEFINE = -38
 Integer, Parameter :: NF_EINDEFINE    = -39
 Integer, Parameter :: NF_EINVALCOORDS = -40
 Integer, Parameter :: NF_EMAXDIMS     = -41
 Integer, Parameter :: NF_ENAMEINUSE   = -42
 Integer, Parameter :: NF_ENOTATT      = -43
 Integer, Parameter :: NF_EMAXATTS     = -44
 Integer, Parameter :: NF_EBADTYPE     = -45
 Integer, Parameter :: NF_EBADDIM      = -46
 Integer, Parameter :: NF_EUNLIMPOS    = -47
 Integer, Parameter :: NF_EMAXVARS     = -48
 Integer, Parameter :: NF_ENOTVAR      = -49
 Integer, Parameter :: NF_EGLOBAL      = -50
 Integer, Parameter :: NF_ENOTNC       = -51
 Integer, Parameter :: NF_ESTS         = -52
 Integer, Parameter :: NF_EMAXNAME     = -53
 Integer, Parameter :: NF_EUNLIMIT     = -54
 Integer, Parameter :: NF_ENORECVARS   = -55
 Integer, Parameter :: NF_ECHAR        = -56
 Integer, Parameter :: NF_EEDGE        = -57
 Integer, Parameter :: NF_ESTRIDE      = -58
 Integer, Parameter :: NF_EBADNAME     = -59
 Integer, Parameter :: NF_ERANGE       = -60
 Integer, Parameter :: NF_ENOMEM       = -61
 Integer, Parameter :: NF_EVARSIZE     = -62
 Integer, Parameter :: NF_EDIMSIZE     = -63
 Integer, Parameter :: NF_ETRUNC       = -64

! Error handling codes

 Integer, Parameter :: NF_FATAL   = 1
 Integer, Parameter :: NF_VERBOSE = 2

#if USE_NETCDF4
! NETCDF4 parameters 

! data types

 Integer, Parameter :: NF_LONG     = NF_INT
 Integer, Parameter :: NF_UBYTE    = 7
 Integer, Parameter :: NF_USHORT   = 8 
 Integer, Parameter :: NF_UINT     = 9
 Integer, Parameter :: NF_INT64    = 10 
 Integer, Parameter :: NF_UINT64   = 11 
 Integer, Parameter :: NF_STRING   = 12
 Integer, Parameter :: NF_VLEN     = 13
 Integer, Parameter :: NF_OPAQUE   = 14
 Integer, Parameter :: NF_ENUM     = 15
 Integer, Parameter :: NF_COMPOUND = 16

! Netcdf4 fill flags - for some reason the F90 values are different
 Integer, Parameter :: NF_FILL_UBYTE   = 255
 Integer, Parameter :: NF_FILL_UINT1   = NF_FILL_UBYTE 
 Integer, Parameter :: NF_FILL_USHORT  = 65535
 Integer, Parameter :: NF_FILL_UINT2   = NF_FILL_USHORT

! new format types
 Integer, Parameter :: NF_FORMAT_NETCDF4   = 3
 Integer, Parameter :: NF_FORMAT_NETCDF4_CLASSIC = 4
! Netcdf4 create mode flags
 Integer, Parameter :: NF_NETCDF4          = 4096
 Integer, Parameter :: NF_HDF5             = 4096 ! deprecated
 Integer, Parameter :: NF_CLASSIC_MODEL    = 256
! Netcdf4 variable flags
 Integer, Parameter :: NF_CHUNK_SEQ      = 0 
 Integer, Parameter :: NF_CHUNK_SUB      = 1 
 Integer, Parameter :: NF_CHUNK_SIZES    = 2 
 Integer, Parameter :: NF_ENDIAN_NATIVE  = 0 
 Integer, Parameter :: NF_ENDIAN_LITTLE  = 1 
 Integer, Parameter :: NF_ENDIAN_BIG     = 2 
 Integer, Parameter :: NF_CHUNKED        = 0
 Integer, Parameter :: NF_NOTCONTIGUOS   = 0
 Integer, Parameter :: NF_CONTIGUOUS     = 1
 Integer, Parameter :: NF_NOCHECKSUM     = 0
 Integer, Parameter :: NF_FLETCHER32     = 1
 Integer, Parameter :: NF_NOSHUFFLE      = 0
 Integer, Parameter :: NF_SHUFFLE        = 1
 Integer, Parameter :: NF_INDEPENDENT    = 0
 Integer, Parameter :: NF_COLLECTIVE     = 1

 Integer, Parameter :: NF_SZIP_EC_OPTION_MASK = 4
 Integer, Parameter :: NF_SZIP_NN_OPTION_MASK = 32

! Netcdf4 error flags
 Integer, Parameter :: NF_EHDFERR        = -101
 Integer, Parameter :: NF_ECANTREAD      = -102
 Integer, Parameter :: NF_ECANTWRITE     = -103
 Integer, Parameter :: NF_ECANTCREATE    = -104
 Integer, Parameter :: NF_EFILEMETA      = -105
 Integer, Parameter :: NF_EDIMMETA       = -106
 Integer, Parameter :: NF_EATTMETA       = -107
 Integer, Parameter :: NF_EVARMETA       = -108
 Integer, Parameter :: NF_ENOCOMPOUND    = -109
 Integer, Parameter :: NF_EATTEXISTS     = -110
 Integer, Parameter :: NF_ENOTNC4        = -111
 Integer, Parameter :: NF_ESTRICTNC3     = -112
 Integer, Parameter :: NF_ENOTNC3        = -113
 Integer, Parameter :: NF_ENOPAR         = -114
 Integer, Parameter :: NF_EPARINIT       = -115
 Integer, Parameter :: NF_EBADGRPID      = -116
 Integer, Parameter :: NF_EBADTYPID      = -117
 Integer, Parameter :: NF_ETYPDEFINED    = -118
 Integer, Parameter :: NF_EBADFIELD      = -119
 Integer, Parameter :: NF_EBADCLASS      = -120
 Integer, Parameter :: NF_EMAPTYPE       = -121
 Integer, Parameter :: NF_ELATEFILL      = -122
 Integer, Parameter :: NF_ELATEDEF       = -123
 Integer, Parameter :: NF_EDIMSCALE      = -124
 Integer, Parameter :: NF_ENOGRP         = -125
#endif

#ifndef NO_NETCDF_2
! V2 interface values

 Integer, Parameter :: NCBYTE     = 1
 Integer, Parameter :: NCCHAR     = 2
 Integer, Parameter :: NCSHORT    = 3
 Integer, Parameter :: NCLONG     = 4
 Integer, Parameter :: NCFLOAT    = 5
 Integer, Parameter :: NCDOUBLE   = 6

 Integer, Parameter :: NCRDWR     = 1
 Integer, Parameter :: NCCREATE   = 2
 Integer, Parameter :: NCEXCL     = 4
 Integer, Parameter :: NCINDEF    = 8
 Integer, Parameter :: NCNSYNC    = 16
 Integer, Parameter :: NCHSYNC    = 32
 Integer, Parameter :: NCNDIRTY   = 64
 Integer, Parameter :: NCHDIRTY   = 128
 Integer, Parameter :: NCFILL     = 0
 Integer, Parameter :: NCNOFILL   = 256
 Integer, Parameter :: NCLINK     = 32768

 Integer, Parameter :: NCNOWRIT   = 0
 Integer, Parameter :: NCWRITE    = NCRDWR
 Integer, Parameter :: NCCLOB     = NF_CLOBBER
 Integer, Parameter :: NCNOCLOB   = NF_NOCLOBBER

 Integer, Parameter :: NCUNLIM    = 0
 Integer, Parameter :: NCGLOBAL   = 0

 Integer, Parameter :: MAXNCOP    = 64
 Integer, Parameter :: MAXNCDIM   = 1024
 Integer, Parameter :: MAXNCATT   = 8192
 Integer, Parameter :: MAXNCVAR   = 8192
 Integer, Parameter :: MAXNCNAM   = 256
 Integer, Parameter :: MAXVDIMS   = MAXNCDIM

 Integer, Parameter :: NCNOERR    = NF_NOERR
 Integer, Parameter :: NCEBADID   = NF_EBADID
 Integer, Parameter :: NCENFILE   = -31
 Integer, Parameter :: NCEEXIST   = NF_EEXIST
 Integer, Parameter :: NCEINVAL   = NF_EINVAL
 Integer, Parameter :: NCEPERM    = NF_EPERM
 Integer, Parameter :: NCENOTIN   = NF_ENOTINDEFINE
 Integer, Parameter :: NCEINDEF   = NF_EINDEFINE
 Integer, Parameter :: NCECOORD   = NF_EINVALCOORDS
 Integer, Parameter :: NCEMAXDS   = NF_EMAXDIMS
 Integer, Parameter :: NCENAME    = NF_ENAMEINUSE
 Integer, Parameter :: NCEMAXAT   = NF_EMAXATTS
 Integer, Parameter :: NCEBADTY   = NF_EBADTYPE
 Integer, Parameter :: NCEBADD    = NF_EBADDIM
 Integer, Parameter :: NCEUNLIM   = NF_EUNLIMPOS
 Integer, Parameter :: NCEMAXVS   = NF_EMAXVARS
 Integer, Parameter :: NCENOTVR   = NF_ENOTVAR
 Integer, Parameter :: NCEGLOB    = NF_EGLOBAL
 Integer, Parameter :: NCNOTNC    = NF_ENOTNC
 Integer, Parameter :: NCESTC     = NF_ESTS
 Integer, Parameter :: NCENTOOL   = NF_EMAXNAME
 Integer, Parameter :: NCFOOBAR   = 32
 Integer, Parameter :: NCSYSERR   = -31

 Integer, Parameter :: NCFATAL    = 1
 Integer, Parameter :: NCVERBOS   = 2

 Integer, Parameter :: FILBYTE    = -127
 Integer, Parameter :: FILCHAR    = 0
 Integer, Parameter :: FILSHORT   = -32767
 Integer, Parameter :: FILLONG    = -2147483647

 Real(RK4), Parameter :: FILFLOAT   = 9.9692099683868690E+36
 Real(RK8), Parameter :: FILDOUB    = 9.9692099683868690D+36
#endif

!------------------------------------------------------------------------------
End Module netcdf_nf_data
