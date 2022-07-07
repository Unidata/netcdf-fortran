!     This is part of the netCDF package. Copyright 2006-2022
!     University Corporation for Atmospheric Research/Unidata. See
!     COPYRIGHT file for conditions of use.

!     This program tests zstandard compression.

!     Ed Hartnett 7/6/22

program f90tst_zstandard
  use typeSizes
  use netcdf
  implicit none
  include "netcdf.inc"
  
  ! This is the name of the data file we will create.
  character (len = *), parameter :: FILE_NAME = "f90tst_zstandard.nc"

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
  integer (kind = EightByteInt), parameter :: BAM_BAM_VALUE = 2147483648_EightByteInt
  character (len = *), parameter :: VAR1_NAME = "Fred_Flintstone"
  character (len = *), parameter :: VAR2_NAME = "Barney_Rubble"
  integer :: ierr

  ! Information read back from the file to check correctness.
  integer :: varid1_in, varid2_in, varid3_in, varid4_in, varid5_in
  integer :: xtype_in, ndims_in, natts_in, dimids_in(NDIM1)
  character (len = nf90_max_name) :: name_in
  integer :: endianness_in, deflate_level_in
  logical :: shuffle_in, fletcher32_in, contiguous_in
  integer (kind = EightByteInt) :: bam_bam_in
  integer :: quantize_mode_in, nsd_in
  integer :: zstandard_in, zstandard_level_in
  real real_data_in(DIM_LEN_5)
  real*8 double_data_in(DIM_LEN_5)
  real diff
  real, parameter :: EPSILON  = .01

  integer :: m, cflags, s
  logical :: shuffle
  
  print *, ''
  print *,'*** Testing use of zstandard feature on netCDF-4 vars from Fortran 90.'

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

  ! Check without and with shuffle.
  do s = 0, 1
     shuffle = .false.
     
     ! Check with and without nf90_classic_model flag.
     cflags = ior(nf90_netcdf4, nf90_clobber)
     do m = 1, 2
        if (m .eq. 2) cflags = ior(cflags, nf90_classic_model)

        ! Create the netCDF file.
        call check(nf90_create(FILE_NAME, cflags, ncid))

        ! Define the dimension.
        call check(nf90_def_dim(ncid, "x", DIM_LEN_5, x_dimid))
        dimids =  (/ x_dimid /)

        ! Define some variables.
#ifdef ENABLE_ZSTD
        if (s .eq. 1) shuffle = .true.
        call check(nf90_def_var(ncid, VAR1_NAME, NF90_FLOAT, dimids, varid1, &
             zstandard_level = 4, shuffle = shuffle))
#else
        ! This will fail because we don't have zstandard. But the var will
        ! be created, only without zstandard compression.
        ierr = nf90_def_var(ncid, VAR1_NAME, NF90_FLOAT, dimids, varid1, &
             zstandard_level = 4)
        if (ierr .ne. nf90_enotbuilt) stop 55
#endif
        call check(nf90_def_var(ncid, VAR2_NAME, NF90_DOUBLE, dimids, varid2))
        call check(nf90_enddef(ncid))

        ! Write the pretend data to the file.
        call check(nf90_put_var(ncid, varid1, real_data))
        call check(nf90_put_var(ncid, varid2, double_data))

        ! Close the file. 
        call check(nf90_close(ncid))

        ! Reopen the file.
        call check(nf90_open(FILE_NAME, nf90_nowrite, ncid))

        ! Check some stuff out.
        call check(nf90_inquire(ncid, ndims, nvars, ngatts, unlimdimid, file_format))
        if (ndims /= 1 .or. nvars /= 2 .or. ngatts /= 0 .or. unlimdimid /= -1) stop 200
        if (m .eq. 1 .and. file_format /= nf90_format_netcdf4) stop 200
        if (m .eq. 2 .and. file_format /= nf90_format_netcdf4_classic) stop 200

        ! Get varids.
        call check(nf90_inq_varid(ncid, VAR1_NAME, varid1_in))
        call check(nf90_inq_varid(ncid, VAR2_NAME, varid2_in))

        ! Check variable 1.
        call check(nf90_inquire_variable(ncid, varid1_in, name_in, xtype_in, ndims_in, dimids_in, &
             natts_in, chunksizes = chunksizes_in, endianness = endianness_in, fletcher32 = fletcher32_in, &
             deflate_level = deflate_level_in, shuffle = shuffle_in, &
             zstandard = zstandard_in, zstandard_level = zstandard_level_in))
#ifdef ENABLE_ZSTD
        if (zstandard_in .eq. 0 .or. zstandard_level_in .ne. 4) stop 4
#else
        if (zstandard_in .ne. 0) stop 4
#endif
        if (natts_in .ne. 0) stop 301
        if (name_in .ne. VAR1_NAME .or. xtype_in .ne. NF90_FLOAT .or. ndims_in .ne. NDIM1 .or. &
             dimids_in(1) .ne. dimids(1)) stop 302

        ! Check variable 2.
        call check(nf90_inquire_variable(ncid, varid2_in, name_in, xtype_in, ndims_in, dimids_in, &
             natts_in, contiguous = contiguous_in, endianness = endianness_in, fletcher32 = fletcher32_in, &
             deflate_level = deflate_level_in, shuffle = shuffle_in, &
             quantize_mode = quantize_mode_in, nsd = nsd_in, zstandard = zstandard_in, &
             zstandard_level = zstandard_level_in))
        if (name_in .ne. VAR2_NAME .or. xtype_in .ne. NF90_DOUBLE .or. ndims_in .ne. NDIM1 .or. &
             natts_in .ne. 0 .or. dimids_in(1) .ne. dimids(1)) stop 6
        if (deflate_level_in .ne. 0 .or. .not. contiguous_in .or. fletcher32_in .or. shuffle_in) stop 7
        if (quantize_mode_in .ne. 0) stop 303
        if (zstandard_in .ne. 0) stop 14

        ! Check the data.
        call check(nf90_get_var(ncid, varid1_in, real_data_in))
        call check(nf90_get_var(ncid, varid2_in, double_data_in))

        ! Check the data. 
        do x = 1, DIM_LEN_5
           diff = abs(real_data_in(x) - real_data(x))
           if (diff .gt. EPSILON) stop 23
           diff = abs(double_data_in(x) - double_data(x))
           if (diff .gt. EPSILON) stop 24
        end do

        ! Close the file. 
        call check(nf90_close(ncid))
     end do
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
end program f90tst_zstandard

