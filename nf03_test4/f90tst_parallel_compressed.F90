!     This is part of the netCDF package.
!     Copyright 2020 University Corporation for Atmospheric Research/Unidata.
!     See COPYRIGHT file for conditions of use.

!     This program tests netCDF-4 parallel I/O with compression. It
!     was added to resolve this issue:
!     https://github.com/Unidata/netcdf-fortran/issues/264

!     Ed Hartnett, 6/16/20

program f90tst_parallel_compressed
  use typeSizes
  use netcdf
  implicit none
  include 'mpif.h'

  ! File info.
  character (len = *), parameter :: FILE_NAME = "f90tst_parallel_compressed.nc"
  integer :: ncid, oldMode

  ! Dimensions
  integer, parameter :: NUM_DIMS = 5
  character (len = *), parameter :: dim_name(NUM_DIMS) = &
       (/ 'grid_xt', 'grid_yt', 'pfull  ', 'phalf  ', 'time   ' /)
  integer, dimension(NUM_DIMS) :: dim_len = (/ 3072, 1536, 127, 128, 1 /)
  integer :: dimid(NUM_DIMS)

  ! Variables.
  integer, parameter :: NUM_VARS = 8
  character (len = *), parameter :: var_name(NUM_VARS) = &
       (/ 'grid_xt', 'lon    ', 'grid_yt', 'lat    ', 'pfull  ', 'phalf  ', 'time   ', 'clwmr  ' /)
  integer ::varid(NUM_VARS)
  integer :: var_type(NUM_VARS) = (/ nf90_double, nf90_double, nf90_double, &
       nf90_double, nf90_float, nf90_float, nf90_double, nf90_float /)
  integer :: var_ndims(NUM_VARS) = (/ 1, 2, 1, 2, 1, 1, 1, 4 /)
  real, allocatable :: value_phalf(:)
  real, allocatable :: value_pfull(:)
  real, allocatable :: value_grid_xt(:)
  real, allocatable :: value_grid_yt(:)
  real, allocatable :: value_lon(:,:)
  real, allocatable :: value_lat(:,:)

  ! These are for checking file contents.
  character (len = 128) :: name_in
  integer :: dim_len_in, xtype_in, ndims_in
  integer :: nvars, ngatts, ndims, unlimdimid, file_format
  integer :: x, y, v
  integer :: p, my_rank, i, j, ierr

  call MPI_Init(ierr)
  call MPI_Comm_rank(MPI_COMM_WORLD, my_rank, ierr)
  call MPI_Comm_size(MPI_COMM_WORLD, p, ierr)

  if (my_rank .eq. 0) then
     print *, '*** Testing compressed data writes with parallel I/O.'
  endif

  ! There must be 4 procs for this test.
  ! if (p .ne. 4) then
  !    print *, 'Sorry, this test program must be run on four processors.'
  !    stop 1
  ! endif

  allocate(value_pfull(dim_len(3)))
  allocate(value_phalf(dim_len(4)))
  allocate(value_grid_xt(dim_len(1)))
  allocate(value_grid_yt(dim_len(2)))
  allocate(value_lat(dim_len(1), dim_len(2)))
  allocate(value_lon(dim_len(1), dim_len(2)))

  ! Some fake data to write.
  do i = 1, dim_len(3)
     value_pfull(i) = i
  end do
  do i = 1, dim_len(4)
     value_phalf(i) = i
  end do
  do i = 1, dim_len(1)
     value_grid_xt(i) = i
  end do
  do i = 1, dim_len(2)
     value_grid_yt(i) = i
  end do
  do i = 1, dim_len(1)
     do j = 1, dim_len(2)
        value_lat(i, j) = i + j
        value_lon(i, j) = i + j
     end do
  end do

  ! Create the netCDF file.
  call check(nf90_create(FILE_NAME, nf90_netcdf4, ncid, comm = MPI_COMM_WORLD, &
       info = MPI_INFO_NULL))
  call check(nf90_set_fill(ncid, NF90_NOFILL, oldMode))

  ! Define dimension grid_xt.
  call check(nf90_def_dim(ncid, trim(dim_name(1)), dim_len(1), dimid(1)))

  ! Define variable grid_xt and write data.
  call check(nf90_def_var(ncid, trim(var_name(1)), var_type(1), dimids=(/dimid(1)/), varid=varid(1)))
  call check(nf90_var_par_access(ncid, varid(1), NF90_INDEPENDENT))
  call check(nf90_enddef(ncid))
  call check(nf90_put_var(ncid, varid(1), values=value_grid_xt))
  call check(nf90_redef(ncid))

  ! Define dimension grid_yt.
  call check(nf90_def_dim(ncid, trim(dim_name(2)), dim_len(2), dimid(2)))

  ! Define variable lat and write data(?)
  call check(nf90_def_var(ncid, trim(var_name(2)), var_type(2), dimids=(/dimid(1),  dimid(2)/), varid=varid(2)))
  call check(nf90_var_par_access(ncid, varid(2), NF90_INDEPENDENT))
  call check(nf90_enddef(ncid))
  call check(nf90_put_var(ncid, varid(2), values=value_lat))
  call check(nf90_redef(ncid))

  ! Define variable grid_yt and write data.
  call check(nf90_def_var(ncid, trim(var_name(3)), var_type(3), dimids=(/dimid(2)/), varid=varid(3)))
  call check(nf90_var_par_access(ncid, varid(3), NF90_INDEPENDENT))
  call check(nf90_enddef(ncid))
  call check(nf90_put_var(ncid, varid(3), values=value_grid_yt))
  call check(nf90_redef(ncid))

  ! Define variable lon and write data (?)
  call check(nf90_def_var(ncid, trim(var_name(4)), var_type(4), dimids=(/dimid(1), dimid(2)/), varid=varid(4)))
  call check(nf90_var_par_access(ncid, varid(4), NF90_INDEPENDENT))
  call check(nf90_enddef(ncid))
  call check(nf90_put_var(ncid, varid(1), values=value_lon))
  call check(nf90_redef(ncid))

  ! Define dimension pfull.
  call check(nf90_def_dim(ncid, trim(dim_name(3)), dim_len(3), dimid(3)))

  ! Define variable pfull and write data.
  call check(nf90_def_var(ncid, trim(var_name(5)), var_type(5), dimids=(/dimid(3)/), varid=varid(5)))
  call check(nf90_var_par_access(ncid, varid(5), NF90_INDEPENDENT))
  call check(nf90_enddef(ncid))
  call check(nf90_put_var(ncid, varid(5), values=value_pfull))
  call check(nf90_redef(ncid))

  ! Define dimension phalf.
  call check(nf90_def_dim(ncid, trim(dim_name(4)), dim_len(4), dimid(4)))

  ! Define variable phalf and write data.
  call check(nf90_def_var(ncid, trim(var_name(6)), var_type(6), dimids=(/dimid(4)/), varid=varid(6)))
  call check(nf90_var_par_access(ncid, varid(6), NF90_INDEPENDENT))
  call check(nf90_enddef(ncid))
  call check(nf90_put_var(ncid, varid(6), values=value_phalf))
  call check(nf90_redef(ncid))

  ! Define dimension time.
  call check(nf90_def_dim(ncid, trim(dim_name(5)), dim_len(5), dimid(5)))

  ! Define variable time and write data.
  call check(nf90_def_var(ncid, trim(var_name(7)), var_type(7), dimids=(/dimid(5)/), varid=varid(7)))
  call check(nf90_var_par_access(ncid, varid(7), NF90_INDEPENDENT))
  call check(nf90_enddef(ncid))
  call check(nf90_redef(ncid))

  ! Define variable clwmr and write data (?)
  call check(nf90_def_var(ncid, trim(var_name(8)), var_type(8), dimids=(/dimid(1), dimid(2), dimid(3), dimid(5)/), varid=varid(8)))
  call check(nf90_var_par_access(ncid, varid(8), NF90_INDEPENDENT))

  ! Close the file.
  call check(nf90_close(ncid))

  ! Reopen the file.
  call check(nf90_open(FILE_NAME, nf90_nowrite, ncid, comm = MPI_COMM_WORLD, &
       info = MPI_INFO_NULL))

  ! Check some stuff out.
  call check(nf90_inquire(ncid, ndims, nvars, ngatts, unlimdimid, file_format))
  if (ndims /= NUM_DIMS) stop 20

  ! Check the dimensions for correctness.
  do i = 1, NUM_DIMS
     call check(nf90_inquire_dimension(ncid, i, name_in, dim_len_in))
     if (name_in .ne. trim(dim_name(i))) stop 101
     if (dim_len_in .ne. dim_len(i)) stop 102
  end do

  ! Check the variables for correctness.
  do i = 1, NUM_VARS
     call check(nf90_inquire_variable(ncid, i, name_in, xtype=xtype_in, ndims=ndims_in))
     if (name_in .ne. trim(var_name(i))) stop 110
     if (xtype_in .ne. var_type(i)) stop 111
     if (ndims_in .ne. var_ndims(i)) stop 112
  end do

  ! Close the file.
  call check(nf90_close(ncid))

  ! Free resources.
  deallocate(value_pfull)
  deallocate(value_phalf)
  deallocate(value_grid_xt)
  deallocate(value_grid_yt)
  deallocate(value_lat)
  deallocate(value_lon)

  if (my_rank .eq. 0) print *,'*** SUCCESS!'

  call MPI_Finalize(ierr)

contains
  !     This subroutine handles errors by printing an error message and
  !     exiting with a non-zero status.
  subroutine check(errcode)
    use netcdf
    implicit none
    integer, intent(in) :: errcode

    if(errcode /= nf90_noerr) then
       print *, 'Error: ', trim(nf90_strerror(errcode))
       stop 99
    endif
  end subroutine check

end program f90tst_parallel_compressed
