!     This is part of the netCDF package.
!     Copyright 2006 University Corporation for Atmospheric Research/Unidata.
!     See COPYRIGHT file for conditions of use.

!     This program tests netCDF-4 fill values.

!     Russ Rew, 2009

program f90tst_fill
  use typeSizes
  use netcdf
  implicit none
  
  ! This is the name of the data file we will create.
  character (len = *), parameter :: FILE_NAME = "f90tst_fill2.nc"
  integer, parameter :: MAX_DIMS = 2
  integer, parameter :: NX = 16, NY = 16
  integer, parameter :: HALF_NX = NX / 2, HALF_NY = NY / 2
  integer, parameter :: ZERO_COUNT = 0
  integer, parameter :: NUM_VARS = 8
  character (len = *), parameter :: var_name(NUM_VARS) = &
       (/ 'byte  ', 'short ', 'int   ', 'float ', 'double', 'ubyte ', &
          'ushort', 'uint  ' /)
  integer :: ncid, varid(NUM_VARS), dimids(MAX_DIMS)
  integer :: var_type(NUM_VARS) = (/ nf90_byte, nf90_short, nf90_int, &
       nf90_float, nf90_double, nf90_ubyte, nf90_ushort, nf90_uint /)
  integer :: x_dimid, y_dimid
  integer :: byte_out(HALF_NY, HALF_NX), byte_in(NY, NX)
  integer :: short_out(HALF_NY, HALF_NX), short_in(NY, NX)
  integer :: int_out(HALF_NY, HALF_NX), int_in(NY, NX)
  real :: areal_out(HALF_NY, HALF_NX), areal_in(NY, NX)
  real :: double_out(HALF_NY, HALF_NX), double_in(NY, NX)
  integer :: ubyte_out(HALF_NY, HALF_NX), ubyte_in(NY, NX)
  integer :: ushort_out(HALF_NY, HALF_NX), ushort_in(NY, NX)
  integer (kind = EightByteInt) :: uint_out(HALF_NY, HALF_NX), uint_in(NY, NX)
  integer :: nvars, ngatts, ndims, unlimdimid, file_format
  integer :: x, y, v
  integer :: start_out(MAX_DIMS), count_out(MAX_DIMS)
  integer :: start_in(MAX_DIMS), count_in(MAX_DIMS)

  print *
  print *, '*** Testing netCDF-4 fill values with unlimited dimension.'

  ! Create some pretend data.
  do x = 1, HALF_NX
     do y = 1, HALF_NY
        byte_out(y, x) = -1
        short_out(y, x) =  -2
        int_out(y, x) = -4
        areal_out(y, x) = 2.5
        double_out(y, x) = -4.5
        ubyte_out(y, x) = 1
        ushort_out(y, x) = 2
        uint_out(y, x) = 4
     end do
  end do

  ! Create the netCDF file. 
  call handle_err(nf90_create(FILE_NAME, nf90_netcdf4, ncid))

  ! Define the dimensions.
  call handle_err(nf90_def_dim(ncid, "x", NF90_UNLIMITED, x_dimid))
  call handle_err(nf90_def_dim(ncid, "y", NY, y_dimid))
  dimids =  (/ y_dimid, x_dimid /)

  ! Define the variables. 
  do v = 1, NUM_VARS
     call handle_err(nf90_def_var(ncid, var_name(v), var_type(v), dimids, varid(v)))
  end do

  ! Write one-quarter of the data.
  count_out = (/ HALF_NX, HALF_NY /)
  start_out = (/ HALF_NX + 1, HALF_NY + 1 /)
  call handle_err(nf90_put_var(ncid, varid(1), byte_out, start = start_out, count = count_out))
  call handle_err(nf90_put_var(ncid, varid(2), short_out, start = start_out, count = count_out))
  call handle_err(nf90_put_var(ncid, varid(3), int_out, start = start_out, count = count_out))
  call handle_err(nf90_put_var(ncid, varid(4), areal_out, start = start_out, count = count_out))
  call handle_err(nf90_put_var(ncid, varid(5), double_out, start = start_out, count = count_out))
  call handle_err(nf90_put_var(ncid, varid(6), ubyte_out, start = start_out, count = count_out))
  call handle_err(nf90_put_var(ncid, varid(7), ushort_out, start = start_out, count = count_out))
  call handle_err(nf90_put_var(ncid, varid(8), uint_out, start = start_out, count = count_out))

  ! Test when one dimension of count is 0
  count_out = (/ HALF_NX, ZERO_COUNT /)
  call handle_err(nf90_put_var(ncid, varid(3), int_out, start = start_out, count = count_out))
  count_out = (/ HALF_NX, HALF_NY /)

  ! Close the file. 
  call handle_err(nf90_close(ncid))

  ! Reopen the file.
  call handle_err(nf90_open(FILE_NAME, nf90_nowrite, ncid))
  
  ! Check some stuff out.
  call handle_err(nf90_inquire(ncid, ndims, nvars, ngatts, unlimdimid, file_format))
  if (ndims /= 2 .or. nvars /= NUM_VARS .or. ngatts /= 0 .or. unlimdimid /= 1 .or. &
       file_format /= nf90_format_netcdf4) stop 2

  ! Read all the data.
  start_in = (/ 1, 1 /)
  count_in = (/ NX, NY /)
  call handle_err(nf90_get_var(ncid, varid(1), byte_in, start = start_in, count = count_in))
  call handle_err(nf90_get_var(ncid, varid(2), short_in, start = start_in, count = count_in))
  call handle_err(nf90_get_var(ncid, varid(3), int_in, start = start_in, count = count_in))
  call handle_err(nf90_get_var(ncid, varid(4), areal_in, start = start_in, count = count_in))
  call handle_err(nf90_get_var(ncid, varid(5), double_in, start = start_in, count = count_in))
  call handle_err(nf90_get_var(ncid, varid(6), ubyte_in, start = start_in, count = count_in))
  call handle_err(nf90_get_var(ncid, varid(7), ushort_in, start = start_in, count = count_in))
  call handle_err(nf90_get_var(ncid, varid(8), uint_in, start = start_in, count = count_in))

  ! Check the data. All the data except the third quadrant are fill
  ! value.
  do x = 1, NX
     do y = 1, NY
        if ((x .gt. HALF_NX) .and. (y .gt. HALF_NY)) then
           if (byte_in(y, x) .ne. -1) stop 13
           if (short_in(y, x) .ne. -2) stop 14
           if (int_in(y, x) .ne. -4) stop 15
           if (areal_in(y, x) .ne. 2.5) stop 16
           if (double_in(y, x) .ne. -4.5) stop 17
           if (ubyte_in(y, x) .ne. 1) stop 18
           if (ushort_in(y, x) .ne. 2) stop 19
           if (uint_in(y, x) .ne. 4) stop 20
        else 
           if (byte_in(y, x) .ne. nf90_fill_byte) stop 3
           if (short_in(y, x) .ne. nf90_fill_short) stop 4
           if (int_in(y, x) .ne. nf90_fill_int) stop 5
           if (areal_in(y, x) .ne. nf90_fill_real) stop 6
           if (double_in(y, x) .ne. nf90_fill_double) stop 7
           if (ubyte_in(y, x) .ne. nf90_fill_ubyte) stop 8
           if (ushort_in(y, x) .ne. nf90_fill_ushort) stop 9
           if (uint_in(y, x) .ne. nf90_fill_uint) stop 10
        endif
     end do
  end do

  ! Close the file. 
  call handle_err(nf90_close(ncid))

  print *,'*** SUCCESS!'

contains
!     This subroutine handles errors by printing an error message and
!     exiting with a non-zero status.
  subroutine handle_err(errcode)
    use netcdf
    implicit none
    integer, intent(in) :: errcode
    
    if(errcode /= nf90_noerr) then
       print *, 'Error: ', trim(nf90_strerror(errcode))
       stop 99
    endif
  end subroutine handle_err
end program f90tst_fill

