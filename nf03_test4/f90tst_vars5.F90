!     This is part of the netCDF package. Copyright 2006-2019
!     University Corporation for Atmospheric Research/Unidata. See
!     COPYRIGHT file for conditions of use.

!     This program tests netCDF-4 variable functions from fortran.

!     Ed Hartnett 2010/01/25

program f90tst_vars5
  use typeSizes
  use netcdf
  implicit none
  include "netcdf.inc"
  
  ! This is the name of the data file we will create.
  character (len = *), parameter :: FILE_NAME = "f90tst_vars5.nc"

  ! We are writing 2D data, a 6 x 12 grid. 
  integer, parameter :: NDIM1 = 1
  integer, parameter :: DIM_LEN_5 = 5
  integer start(NDIM1), count(NDIM1)
  real real_data(DIM_LEN_5)
  real*8 double_data(DIM_LEN_5)

  ! We need these ids and other gunk for netcdf.
  integer :: ncid, varid1, varid2, varid3, varid4, varid5, dimids(NDIM1)
  integer :: chunksizes(NDIM1), chunksizes_in(NDIM1)
  integer :: x_dimid, y_dimid
  integer :: nvars, ngatts, ndims, unlimdimid, file_format
  integer :: x, y
  integer, parameter :: DEFLATE_LEVEL = 4
  integer (kind = EightByteInt), parameter :: TOE_SAN_VALUE = 2147483648_EightByteInt
  character (len = *), parameter :: VAR1_NAME = "Chon-Ji"
  character (len = *), parameter :: VAR2_NAME = "Tan-Gun"
  character (len = *), parameter :: VAR3_NAME = "Toe-San"
  character (len = *), parameter :: VAR4_NAME = "Won-Hyo"
  character (len = *), parameter :: VAR5_NAME = "Yul-Guk"
  integer, parameter :: CACHE_SIZE = 8, CACHE_NELEMS = 571
  integer, parameter :: CACHE_PREEMPTION = 66
  integer :: ierr

  ! Information read back from the file to check correctness.
  integer :: varid1_in, varid2_in, varid3_in, varid4_in, varid5_in
  integer :: xtype_in, ndims_in, natts_in, dimids_in(NDIM1)
  character (len = nf90_max_name) :: name_in
  integer :: endianness_in, deflate_level_in
  logical :: shuffle_in, fletcher32_in, contiguous_in
  integer (kind = EightByteInt) :: toe_san_in
  integer :: cache_size_in, cache_nelems_in, cache_preemption_in
  integer :: quantize_mode_in, nsd_in
  real real_data_in(DIM_LEN_5)
  real*8 double_data_in(DIM_LEN_5)
  real diff
  real, parameter :: EPSILON  = .01
  ! Because values 4 and 5 of our data array are so large, a large
  ! epsilon is needed.
  real, parameter :: EPSILON_LARGE  = 1450000
  integer :: t, qmode, qnsd

  print *, ''
  print *,'*** Testing use of quantize feature on netCDF-4 vars from Fortran 90.'

  ! Create some pretend data.
  real_data(1) = 1.11111111
  real_data(2) = 1.0
  real_data(3) = 9.99999999
  real_data(4) = 12345.67
  real_data(5) = .1234567
  double_data(1) = 1.1111111
  double_data(2) = 1.0
  double_data(3) = 9.999999999
  double_data(4) = 1234567890.12345
  double_data(5) = 1234567890
  
  do t = 1, 3
     
     ! Create the netCDF file. 
     call check(nf90_create(FILE_NAME, nf90_netcdf4, ncid, cache_nelems = CACHE_NELEMS, &
          cache_size = CACHE_SIZE))

     ! Define the dimension.
     call check(nf90_def_dim(ncid, "x", DIM_LEN_5, x_dimid))
     dimids =  (/ x_dimid /)

     ! Test with all three quantize modes.
     if (t .eq. 1) then
        qmode = nf90_quantize_bitgroom
        qnsd = 3
     else if (t .eq. 2) then
        qmode = nf90_quantize_granularbr
        qnsd = 3
     else
        qmode = nf90_quantize_bitround
        qnsd = 10
     endif

     print *,'\t*** testing with quantize_mode ',qmode
     
     ! Define some variables.
     call check(nf90_def_var(ncid, VAR1_NAME, NF90_FLOAT, dimids, varid1&
          &, deflate_level = DEFLATE_LEVEL, quantize_mode =&
          & qmode, nsd = qnsd))
     call check(nf90_def_var(ncid, VAR2_NAME, NF90_DOUBLE, dimids,&
          & varid2, contiguous = .TRUE., quantize_mode =&
          & qmode, nsd = qnsd))

     ! Write the pretend data to the file.
     call check(nf90_put_var(ncid, varid1, real_data))
     call check(nf90_put_var(ncid, varid2, double_data))

     ! Close the file. 
     call check(nf90_close(ncid))

     ! Reopen the file.
     call check(nf90_open(FILE_NAME, nf90_nowrite, ncid))

     ! Check some stuff out.
     call check(nf90_inquire(ncid, ndims, nvars, ngatts, unlimdimid, file_format))
     if (ndims /= 1 .or. nvars /= 2 .or. ngatts /= 0 .or. unlimdimid /= -1 .or. &
          file_format /= nf90_format_netcdf4) stop 2

     ! Get varids.
     call check(nf90_inq_varid(ncid, VAR1_NAME, varid1_in))
     call check(nf90_inq_varid(ncid, VAR2_NAME, varid2_in))

     ! Check variable 1.
     call check(nf90_inquire_variable(ncid, varid1_in, name_in, xtype_in, ndims_in, dimids_in, &
          natts_in, chunksizes = chunksizes_in, endianness = endianness_in, fletcher32 = fletcher32_in, &
          deflate_level = deflate_level_in, shuffle = shuffle_in, cache_size = cache_size_in, &
          cache_nelems = cache_nelems_in, cache_preemption = cache_preemption_in, &
          quantize_mode = quantize_mode_in, nsd = nsd_in))
     if (name_in .ne. VAR1_NAME .or. xtype_in .ne. NF90_FLOAT .or. ndims_in .ne. NDIM1 .or. &
          natts_in .ne. 1 .or. dimids_in(1) .ne. dimids(1)) stop 3
     if (quantize_mode_in .ne. qmode .or. nsd_in .ne. qnsd) stop 3

     ! Check variable 2.
     call check(nf90_inquire_variable(ncid, varid2_in, name_in, xtype_in, ndims_in, dimids_in, &
          natts_in, contiguous = contiguous_in, endianness = endianness_in, fletcher32 = fletcher32_in, &
          deflate_level = deflate_level_in, shuffle = shuffle_in, &
          quantize_mode = quantize_mode_in, nsd = nsd_in))
     if (name_in .ne. VAR2_NAME .or. xtype_in .ne. NF90_DOUBLE .or. ndims_in .ne. NDIM1 .or. &
          natts_in .ne. 1 .or. dimids_in(1) .ne. dimids(1)) stop 6
     if (deflate_level_in .ne. 0 .or. .not. contiguous_in .or. fletcher32_in .or. shuffle_in) stop 7
     if (quantize_mode_in .ne. qmode .or. nsd_in .ne. qnsd) stop 3

     ! Check the data.
     call check(nf90_get_var(ncid, varid1_in, real_data_in))
     call check(nf90_get_var(ncid, varid2_in, double_data_in))

     ! Check the data. 
     do x = 1, DIM_LEN_5
        ! Check the real.
        print *, 'real: ', real_data_in(x), real_data(x)
        diff = abs(real_data_in(x) - real_data(x))
        print *, 'x = ', x, ' diff = ', diff
        if (x < 4) then
           if (diff .gt. EPSILON) stop 23
        else
           if (diff .gt. EPSILON_LARGE) stop 24
        endif

        ! Check the double.
        diff = abs(double_data_in(x) - double_data(x))
        print *, 'double:', double_data_in(x), double_data(x)
        print *, 'x = ', x, ' diff = ', diff
        if (x < 4) then
           if (diff .gt. EPSILON) stop 25
        else
           if (diff .gt. EPSILON_LARGE) stop 26
        endif
     end do

     ! Close the file. 
     call check(nf90_close(ncid))
  end do
  
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
end program f90tst_vars5

