  !
  ! external netcdf data types:
  !
  integer, parameter, public :: &
    nf90_byte   = 1,            &
    nf90_int1   = nf90_byte,    &
    nf90_char   = 2,            &
    nf90_short  = 3,            &
    nf90_int2   = nf90_short,   &
    nf90_int    = 4,            &
    nf90_int4   = nf90_int,     &
    nf90_float  = 5,            &
    nf90_real   = nf90_float,   &
    nf90_real4  = nf90_float,   &
    nf90_double = 6,            &
    nf90_real8  = nf90_double
                        
  !
  ! default fill values:
  !
  character (len = 1),           parameter, public :: &
    nf90_fill_char  = achar(0)
  integer (kind =  OneByteInt),  parameter, public :: &
    nf90_fill_byte  = -127,                           &
    nf90_fill_int1  = nf90_fill_byte
  integer (kind =  TwoByteInt),  parameter, public :: &
    nf90_fill_short = -32767,                         &
    nf90_fill_int2  = nf90_fill_short
  integer (kind = FourByteInt),  parameter, public :: &
    nf90_fill_int   = -2147483647
  real   (kind =  FourByteReal), parameter, public :: &
    nf90_fill_float = 9.9692099683868690e+36,         &
    nf90_fill_real  = nf90_fill_float,                &
    nf90_fill_real4 = nf90_fill_float
  real   (kind = EightByteReal), parameter, public :: &
    nf90_fill_double = 9.9692099683868690e+36,        &
    nf90_fill_real8  = nf90_fill_double

  !
  ! mode flags for opening and creating a netcdf dataset:
  !
  integer, parameter, public :: &
    nf90_nowrite   = 0,         &
    nf90_write     = 1,         &
    nf90_clobber   = 0,         &
    nf90_noclobber = 4,         &
    nf90_fill      = 0,         &
    nf90_nofill    = 256,       &
    nf90_64bit_offset    = 512,       &
    nf90_lock      = 1024,      &
    nf90_share     = 2048 
  
  integer, parameter, public ::  &
    nf90_sizehint_default = 0,   & 
    nf90_align_chunk      = -1 

  !
  ! size argument for defining an unlimited dimension:
  !
  integer, parameter, public :: nf90_unlimited = 0

  !
  ! global attribute id:
  !
  integer, parameter, public :: nf90_global = 0

  !
  ! implementation limits:
  !
  integer, parameter, public :: &
    nf90_max_dims     = 1024,    &
    nf90_max_attrs    = 8192,   &
    nf90_max_vars     = 8192,   &
    nf90_max_name     = 256,    &
    nf90_max_var_dims = 1024
  
  !
  ! error codes:
  !
  integer, parameter, public :: &
    nf90_noerr        = 0,      &
    nf90_ebadid       = -33,    &
    nf90_eexist       = -35,    &
    nf90_einval       = -36,    &
    nf90_eperm        = -37,    &
    nf90_enotindefine = -38,    &
    nf90_eindefine    = -39,    &
    nf90_einvalcoords = -40,    &
    nf90_emaxdims     = -41,    &
    nf90_enameinuse   = -42,    &
    nf90_enotatt      = -43,    &
    nf90_emaxatts     = -44,    &
    nf90_ebadtype     = -45,    &
    nf90_ebaddim      = -46,    &
    nf90_eunlimpos    = -47,    &
    nf90_emaxvars     = -48,    &
    nf90_enotvar      = -49,    &
    nf90_eglobal      = -50,    &
    nf90_enotnc       = -51,    &
    nf90_ests         = -52,    &
    nf90_emaxname     = -53,    &
    nf90_eunlimit     = -54,    &
    nf90_enorecvars   = -55,    &
    nf90_echar        = -56,    &
    nf90_eedge        = -57,    &
    nf90_estride      = -58,    &
    nf90_ebadname     = -59,    &
    nf90_erange       = -60,    &
    nf90_enomem       = -61,    &
    nf90_evarsize     = -62,    &
    nf90_edimsize     = -63,    &
    nf90_etrunc       = -64

  !
  ! error handling modes:
  !
  integer, parameter, public :: &
    nf90_fatal   = 1,           &
    nf90_verbose = 2

  !
  ! format version numbers:
  !
  integer, parameter, public :: &
    nf90_format_classic = 1,    &
    nf90_format_64bit = 2,      &
    nf90_format_netcdf4 = 3,    &
    nf90_format_netcdf4_classic = 4

! extra data types:
integer, parameter, public :: &
     nf90_ubyte = 7, &
     nf90_ushort = 8, &
     nf90_uint = 9, &
     nf90_int64 = 10, &
     nf90_uint64 = 11, &
     nf90_string = 12, &
     nf90_vlen = 13, &
     nf90_opaque = 14, &
     nf90_enum = 15, &
     nf90_compound = 16

                        
! extra default fill values:
integer (kind =  TwoByteInt),  parameter, public :: &
     nf90_fill_ubyte  = 255,                        &
     nf90_fill_uint1  = nf90_fill_ubyte
integer (kind =  FourByteInt),  parameter, public :: &
     nf90_fill_ushort = 65535,                      &
     nf90_fill_uint2  = nf90_fill_ushort
integer (kind = EightByteInt),  parameter, public :: &
     nf90_fill_uint   = 4294967295_8

! Extra file create mode flags.
integer, parameter, public :: &
     nf90_netcdf4 = 4096, &
     nf90_hdf5 = 4096, & ! deprecated
     nf90_classic_model = 256

! Flags for parallel I/O.
integer, parameter, public :: nf90_mpiio = 8192, nf90_mpiposix = 16384, &
     nf90_pnetcdf = 32768

! Flags for parallel access.
integer, parameter, public :: nf90_independent = 0, nf90_collective = 1
  
! Extra variable flags.
integer, parameter, public :: &
     nf90_chunk_seq = 0, &
     nf90_chunk_sub = 1, &
     nf90_chunk_sizes = 2, &
     nf90_endian_native = 0, &
     nf90_endian_little = 1, &
     nf90_endian_big = 2, &
     nf90_chunked = 0, &
     nf90_notcontiguous = 0, &
     nf90_contiguous = 1, &
     nf90_nochecksum = 0, &
     nf90_fletcher32 = 1, &
     nf90_noshuffle = 0, &
     nf90_shuffle = 1, &
     nf90_szip_ec_option_mask = 4, &
     nf90_szip_nn_option_mask = 32

! Extra error codes.
integer, parameter, public :: &
     nf90_ehdferr = -101, & ! Error at HDF5 layer. 
     nf90_ecantread = -102, & ! Can't read. 
     nf90_ecantwrite = -103, & ! Can't write. 
     nf90_ecantcreate = -104, & ! Can't create. 
     nf90_efilemeta = -105, & ! Problem with file metadata. 
     nf90_edimmeta = -106, & ! Problem with dimension metadata. 
     nf90_eattmeta = -107, & ! Problem with attribute metadata. 
     nf90_evarmeta = -108, & ! Problem with variable metadata. 
     nf90_enocompound = -109, & ! Not a compound type. 
     nf90_eattexists = -110, & ! Attribute already exists. 
     nf90_enotnc4 = -111, & ! Attempting netcdf-4 operation on netcdf-3 file.   
     nf90_estrictnc3 = -112, & ! Attempting netcdf-4 operation on strict nc3 netcdf-4 file.   
     nf90_enotnc3 = -113, & ! Attempting netcdf-3 operation on netcdf-4 file.   
     nf90_enopar = -114, & ! Parallel operation on file opened for non-parallel access.   
     nf90_eparinit = -115, & ! Error initializing for parallel access.   
     nf90_ebadgrpid = -116, & ! Bad group ID.   
     nf90_ebadtypid = -117, & ! Bad type ID.   
     nf90_etypdefined = -118, & ! Type has already been defined and may not be edited. 
     nf90_ebadfield = -119, & ! Bad field ID.   
     nf90_ebadclass = -120, & ! Bad class.   
     nf90_emaptype = -121, & ! Mapped access for atomic types only.   
     nf90_elatefill = -122, & ! Attempt to define fill value when data already exists. 
     nf90_elatedef = -122 ! Attempt to define var properties, like deflate, after enddef. 

! This is the position of NC_NETCDF4 in cmode, counting from the
! right, starting (uncharacteristically for fortran) at 0. It's needed
! for the BTEST function calls.
integer, parameter, private :: NETCDF4_BIT = 12
