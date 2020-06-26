!     This is part of the netCDF package.
!     Copyright 2020 University Corporation for Atmospheric Research/Unidata.
!     See COPYRIGHT file for conditions of use.

!     This program tests netCDF-4 parallel I/O with compression. It
!     was added to resolve this issue:
!     https://github.com/Unidata/netcdf-fortran/issues/264
!     This code matches the code here:
!     https://github.com/NOAA-EMC/fv3atm/blob/develop/io/module_write_netcdf_parallel.F90

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
  integer :: ideflate = 4
  real*8 :: value_time = 2.0, value_time_in
  real, allocatable :: value_grid_xt(:)
  real, allocatable :: value_grid_yt(:)
  real, allocatable :: value_lon(:,:)
  real, allocatable :: value_lat(:,:)
  real, allocatable :: value_clwmr(:,:,:,:)
  integer :: phalf_loc_size, phalf_start
  real, allocatable :: value_phalf_loc(:), value_phalf_loc_in(:)
  integer :: pfull_loc_size, pfull_start
  real, allocatable :: value_pfull_loc(:), value_pfull_loc_in(:)
  integer :: grid_xt_loc_size, grid_xt_start
  real, allocatable :: value_grid_xt_loc(:), value_grid_xt_loc_in(:)

  ! These are for checking file contents.
  character (len = 128) :: name_in
  integer :: dim_len_in, xtype_in, ndims_in
  integer :: nvars, ngatts, ndims, unlimdimid, file_format
  integer :: x, y, v
  integer :: npes, my_rank, i, j, k, ierr

  call MPI_Init(ierr)
  call MPI_Comm_rank(MPI_COMM_WORLD, my_rank, ierr)
  call MPI_Comm_size(MPI_COMM_WORLD, npes, ierr)

  if (my_rank .eq. 0) then
     print *, '*** Testing compressed data writes with parallel I/O.'
  endif

  ! There must be 4 or 40 procs for this test.
  if (npes .ne. 4 .and. npes .ne. 40) then
     print *, 'Sorry, this test program must be run on 4 or 40 processors.'
     stop 1
  endif

  ! Size of local (i.e. for this pe) pfull data.
  pfull_loc_size = dim_len(3)/npes;
  pfull_start = my_rank * pfull_loc_size + 1
  if (my_rank .eq. npes - 1) then
     pfull_loc_size = pfull_loc_size + mod(dim_len(3), npes)
  endif
  !print *, my_rank, 'pfull', dim_len(3), pfull_start, pfull_loc_size
  
  ! Size of local (i.e. for this pe) phalf data.
  phalf_loc_size = dim_len(4)/npes;
  phalf_start = my_rank * phalf_loc_size + 1
  if (my_rank .eq. npes - 1) then
     phalf_loc_size = phalf_loc_size + mod(dim_len(4), npes)
  endif
  !print *, my_rank, 'phalf', dim_len(4), phalf_start, phalf_loc_size

  ! Size of local (i.e. for this pe) grid_xt data.
  grid_xt_loc_size = dim_len(3)/npes;
  grid_xt_start = my_rank * grid_xt_loc_size + 1
  if (my_rank .eq. npes - 1) then
     grid_xt_loc_size = grid_xt_loc_size + mod(dim_len(3), npes)
  endif
  !print *, my_rank, 'grid_xt', dim_len(3), grid_xt_start, grid_xt_loc_size

  allocate(value_grid_xt_loc(grid_xt_loc_size))
  allocate(value_grid_xt_loc_in(grid_xt_loc_size))
  allocate(value_pfull_loc(pfull_loc_size))
  allocate(value_pfull_loc_in(pfull_loc_size))
  allocate(value_phalf_loc(phalf_loc_size))
  allocate(value_phalf_loc_in(phalf_loc_size))
  
  allocate(value_grid_xt(dim_len(1)))
  allocate(value_grid_yt(dim_len(2)))
  allocate(value_lat(dim_len(1), dim_len(2)))
  allocate(value_lon(dim_len(1), dim_len(2)))
  allocate(value_clwmr(dim_len(1), dim_len(2), dim_len(3), dim_len(5)))

  ! Some fake data to write.
  do i = 1, pfull_loc_size
     value_pfull_loc(i) = my_rank * 100 + i;
  end do
  do i = 1, phalf_loc_size
     value_phalf_loc(i) = my_rank * 100 + i;
  end do

  ! do i = 1, dim_len(1)
  !    value_grid_xt(i) = i
  ! end do
  ! do i = 1, dim_len(2)
  !    value_grid_yt(i) = i
  ! end do
  ! do i = 1, dim_len(1)
  !    do j = 1, dim_len(2)
  !       value_lat(i, j) = i + j
  !       value_lon(i, j) = i + j
  !       do k = 1, dim_len(3)
  !          value_clwmr(i, j, k, 1) = k
  !       end do
  !    end do
  ! end do

  ! Create the netCDF file using parallel I/O.
  call check(nf90_create(FILE_NAME, nf90_netcdf4, ncid, comm = MPI_COMM_WORLD, &
       info = MPI_INFO_NULL))

  ! Turn off fill mode.
  call check(nf90_set_fill(ncid, NF90_NOFILL, oldMode))

  ! Define dimension grid_xt.
  call check(nf90_def_dim(ncid, trim(dim_name(1)), dim_len(1), dimid(1)))

  ! Define dimension grid_yt.
  call check(nf90_def_dim(ncid, trim(dim_name(2)), dim_len(2), dimid(2)))

  ! Define variable grid_xt.
  call check(nf90_def_var(ncid, trim(var_name(1)), var_type(1), dimids=(/dimid(1)/), varid=varid(1)))
  call check(nf90_var_par_access(ncid, varid(1), NF90_INDEPENDENT))

  ! Define variable lon.
  call check(nf90_def_var(ncid, trim(var_name(2)), var_type(2), dimids=(/dimid(1),  dimid(2)/), varid=varid(2)))
!  call check(nf90_var_par_access(ncid, varid(2), NF90_INDEPENDENT))

  ! Define variable grid_yt.
  call check(nf90_def_var(ncid, trim(var_name(3)), var_type(3), dimids=(/dimid(2)/), varid=varid(3)))
  call check(nf90_var_par_access(ncid, varid(3), NF90_INDEPENDENT))

  ! Define variable lat.
  call check(nf90_def_var(ncid, trim(var_name(4)), var_type(4), dimids=(/dimid(1), dimid(2)/), varid=varid(4)))
  call check(nf90_var_par_access(ncid, varid(4), NF90_INDEPENDENT))

  ! Define dimension pfull.
  call check(nf90_def_dim(ncid, trim(dim_name(3)), dim_len(3), dimid(3)))

  ! Define variable pfull and write data.
  call check(nf90_def_var(ncid, trim(var_name(5)), var_type(5), dimids=(/dimid(3)/), varid=varid(5)))
  call check(nf90_var_par_access(ncid, varid(5), NF90_INDEPENDENT))
  call check(nf90_enddef(ncid))
  call check(nf90_put_var(ncid, varid(5), start=(/pfull_start/), count=(/pfull_loc_size/), values=value_pfull_loc))
  call check(nf90_redef(ncid))

  ! Define dimension phalf.
  call check(nf90_def_dim(ncid, trim(dim_name(4)), dim_len(4), dimid(4)))

  ! Define variable phalf and write data.
  call check(nf90_def_var(ncid, trim(var_name(6)), var_type(6), dimids=(/dimid(4)/), varid=varid(6)))
  call check(nf90_var_par_access(ncid, varid(6), NF90_INDEPENDENT))
  call check(nf90_enddef(ncid))
!  call check(nf90_put_var(ncid, varid(6), values=value_phalf))
  call check(nf90_put_var(ncid, varid(6), start=(/phalf_start/), count=(/phalf_loc_size/), values=value_phalf_loc))
  call check(nf90_redef(ncid))

  ! Define dimension time.
  call check(nf90_def_dim(ncid, trim(dim_name(5)), dim_len(5), dimid(5)))

  ! Define variable time and write data.
  call check(nf90_def_var(ncid, trim(var_name(7)), var_type(7), dimids=(/dimid(5)/), varid=varid(7)))
  call check(nf90_var_par_access(ncid, varid(7), NF90_INDEPENDENT))
  call check(nf90_enddef(ncid))
  ! In NOAA code, do all processors write the single time value?
  if (my_rank .eq. 0) then
     call check(nf90_put_var(ncid, varid(7), values=value_time))
  endif
  call check(nf90_redef(ncid))

  ! Write variable grid_xt data.
  call check(nf90_enddef(ncid))
  call check(nf90_put_var(ncid, varid(1), values=value_grid_xt))
  call check(nf90_redef(ncid))

  ! Write lon data.
  call check(nf90_enddef(ncid))
  call check(nf90_put_var(ncid, varid(2), values=value_lon))
  call check(nf90_redef(ncid))

  ! Write grid_yt data.
  call check(nf90_enddef(ncid))
  call check(nf90_put_var(ncid, varid(3), values=value_grid_yt))
  call check(nf90_redef(ncid))

  ! Write lat data.
  call check(nf90_enddef(ncid))
  call check(nf90_put_var(ncid, varid(4), values=value_lat))
  call check(nf90_redef(ncid))

  ! Define variable clwmr and write data (?)
  call check(nf90_def_var(ncid, trim(var_name(8)), var_type(8), dimids=(/dimid(1), dimid(2), dimid(3), dimid(5)/), &
       varid=varid(8), shuffle=.true., deflate_level=ideflate))
  call check(nf90_var_par_access(ncid, varid(8), NF90_COLLECTIVE))
  call check(nf90_enddef(ncid))
!  call check(nf90_put_var(ncid, varid(8), values=value_clwmr))  
  call check(nf90_redef(ncid))

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

  ! Check the pfull data.
  call check(nf90_get_var(ncid, varid(5), start=(/pfull_start/), count=(/pfull_loc_size/), values=value_pfull_loc_in))
  do i = 1, pfull_loc_size
     !print *, value_pfull_loc_in(i), value_pfull_loc(i)
     if (value_pfull_loc_in(i) .ne. value_pfull_loc(i)) stop 199
  end do

  ! Check the phalf data.
  call check(nf90_get_var(ncid, varid(6), start=(/phalf_start/), count=(/phalf_loc_size/), values=value_phalf_loc_in))
  do i = 1, phalf_loc_size
     if (value_phalf_loc_in(i) .ne. value_phalf_loc(i)) stop 200
  end do

  ! Check the time value.
  call check(nf90_get_var(ncid, varid(7), values=value_time_in))
  if (value_time_in .ne. value_time) stop 300

  ! Close the file.
  call check(nf90_close(ncid))

  ! Free resources.
  deallocate(value_grid_xt_loc)
  deallocate(value_grid_xt_loc_in)
  deallocate(value_pfull_loc)
  deallocate(value_pfull_loc_in)
  deallocate(value_phalf_loc)
  deallocate(value_phalf_loc_in)
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
