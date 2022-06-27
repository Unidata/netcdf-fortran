! -- This file provides functions for parallel I/O when 
! -- netCDF is built without parallel support
!
! -- C functions return NC_ENOPAR when built without parallel support
! -- so do the same here

! Parallel I/O access is only available in library build which support
! parallel I/O. To support parallel I/O, netCDF must be built with
! netCDF-4 enabled (configure options --enable-netcdf-4 and --enable-parallel4)
! and with a HDF5 library that supports parallel I/O, or with support for the
! PnetCDF library via the --enable-pnetcdf option.

!-------------------------------- nf_create_par -------------------------------
 Function nf_create_par (path, cmode, comm, info, ncid) RESULT(status)

! create parallel file

 USE netcdf_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: cmode, comm, info
 Character(LEN=*), Intent(IN)  :: path
 Integer,          Intent(OUT) :: ncid

 Integer                       :: status

 ncid = 0
 status = NC_ENOPAR

 End Function nf_create_par
!-------------------------------- nf_open_par --------------------------------
 Function nf_open_par (path, mode, comm, info, ncid) RESULT(status)

! open a parallel file

 USE netcdf_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: mode, comm, info
 Character(LEN=*), Intent(IN)  :: path
 Integer,          Intent(OUT) :: ncid

 Integer                       :: status

 ncid = 0
 status = NC_ENOPAR

 End Function nf_open_par
!-------------------------------- nf_var_par_access -------------------------
 Function nf_var_par_access( ncid, varid, iaccess) RESULT (status)

! set parallel variable access

 USE netcdf_nc_interfaces

 Implicit NONE

 Integer, Intent(IN) :: ncid, varid, iaccess

 Integer             :: status

 status = NC_ENOPAR

 End Function nf_var_par_access
