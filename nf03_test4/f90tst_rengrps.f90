!     This is part of the netCDF package. Copyright 2006-2019
!     University Corporation for Atmospheric Research/Unidata. See
!     COPYRIGHT file for conditions of use.

!     Modified version of f90tst_grps to add test for rename_grps.

!     Russ Rew, 2014

program f90tst_rengrps
  use typeSizes
  use netcdf
  implicit none

  ! This is the name of the data file we will create.
  character (len = *), parameter :: FILE_NAME = "f90tst_rengrps.nc"

  ! We are writing 2D data, a 6 x 12 grid. 
  integer, parameter :: MAX_DIMS = 2
  integer, parameter :: NX = 6, NY = 12
  integer :: chunksizes(MAX_DIMS)
  integer, parameter :: CACHE_NELEMS = 10000, CACHE_SIZE = 1000000
  integer, parameter :: DEFLATE_LEVEL = 4
  ! We need these ids and other gunk for netcdf.
  integer :: ncid, varid1, varid2, dimids(MAX_DIMS)
  integer :: x_dimid, y_dimid
  character (len = *), parameter :: VAR1_NAME = "VarName1"
  character (len = *), parameter :: VAR2_NAME = "VarName2"
  character (len = *), parameter :: GRP1_NAME = "Old_Grp1_name"
  character (len = *), parameter :: GRP2_NAME = "Old_Grp2_name"
  character (len = *), parameter :: NEW_GRP1_NAME = "new_Grp1_name"
  character (len = *), parameter :: NEW_GRP2_NAME = "new_Grp2_name"

  character (len = NF90_MAX_NAME) :: grp1_full_name
  integer :: ilen

  ! Information read back from the file to check correctness.
  integer :: grpid1, grpid2
  integer :: deflate_level_in, endianness_in
  logical :: shuffle_in, fletcher32_in
  integer :: xtype_in, ndims_in, natts_in, dimids_in(MAX_DIMS)
  character (len = nf90_max_name) :: name_in
  integer :: chunksizes_in(MAX_DIMS)

  print *, ''
  print *,'*** Testing netCDF-4 rename groups from Fortran 90.'

  ! Create the netCDF file. 
  call check(nf90_create(FILE_NAME, nf90_netcdf4, ncid))

  ! Define the dimensions.
  call check(nf90_def_dim(ncid, "x", NX, x_dimid))
  call check(nf90_def_dim(ncid, "y", NY, y_dimid))
  dimids =  (/ y_dimid, x_dimid /)

  ! Define some nested groups.
  call check(nf90_def_grp(ncid, GRP1_NAME, grpid1))
  call check(nf90_def_grp(grpid1, GRP2_NAME, grpid2))

  ! Define some variables. 
  chunksizes = (/ NY, NX /)
  call check(nf90_def_var(ncid, VAR1_NAME, NF90_INT, dimids, varid1, chunksizes = chunksizes, &
       shuffle = .TRUE., fletcher32 = .TRUE., endianness = nf90_endian_big, deflate_level = DEFLATE_LEVEL))
  call check(nf90_def_var(grpid1, VAR2_NAME, NF90_INT, dimids, varid2, contiguous = .TRUE.))

  ! Close the file. 
  call check(nf90_close(ncid))

  ! Reopen the file.
  call check(nf90_open(FILE_NAME, nf90_write, ncid))
  
  ! Get the group ids for the newly reopened file.
  call check(nf90_inq_grp_ncid(ncid, GRP1_NAME, grpid1))
  call check(nf90_inq_grp_ncid(grpid1, GRP2_NAME, grpid2))

  ! Check for the groups with full group names. 
  write(grp1_full_name, '(A,A)') '/', GRP1_NAME
  call check(nf90_inq_grp_full_ncid(ncid, grp1_full_name, grpid1))
  call check(nf90_inq_grpname(grpid1, name_in))
  if (name_in .ne. GRP1_NAME) stop 61
  call check(nf90_inq_grpname_full(grpid1, ilen, name_in))
  if (name_in .ne. grp1_full_name) stop 62

  Call check(nf90_rename_grp(grpid1, NEW_GRP1_NAME))
  name_in=REPEAT(" ", LEN(name_in))
  Call check(nf90_inq_grpname(grpid1, name_in))
  If (name_in /= NEW_GRP1_NAME) Call check(-1)

  ! Check variable 1.
  call check(nf90_inquire_variable(ncid, varid1, name_in, xtype_in, ndims_in, dimids_in, &
       natts_in, chunksizes = chunksizes_in, endianness = endianness_in, fletcher32 = fletcher32_in, &
       deflate_level = deflate_level_in, shuffle = shuffle_in))
  if (name_in .ne. VAR1_NAME .or. xtype_in .ne. NF90_INT .or. ndims_in .ne. MAX_DIMS .or. &
       natts_in .ne. 0 .or. dimids_in(1) .ne. dimids(1) .or. dimids_in(2) .ne. dimids(2)) stop 3
  if (chunksizes_in(1) /= chunksizes(1) .or. chunksizes_in(2) /= chunksizes(2)) &
       stop 4
  if (endianness_in .ne. nf90_endian_big) stop 5

  ! Close the file. 
  call check(nf90_close(ncid))

  print *,'*** SUCCESS!'

contains
!     This subroutine handles errors by printing an error message and
!     exiting with a non-zero status.
  subroutine check(errcode)
    use netcdf
    implicit none
    integer, intent(in) :: errcode
    
    if(errcode /= nf90_noerr) then
       print *, 'Error: ', trim(nf90_strerror(errcode))
       stop 2
    endif
  end subroutine check
end program f90tst_rengrps

