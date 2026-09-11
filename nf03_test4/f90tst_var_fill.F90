!     This is part of the netCDF package. Copyright 2006-2019
!     University Corporation for Atmospheric Research/Unidata. See
!     COPYRIGHT file for conditions of use.

!     This program tests the nf90_def_var_fill and nf90_inq_var_fill
!     generic interfaces for every kind they are overloaded for. These
!     wrappers hand the fill value to nf_def_var_fill/nf_inq_var_fill,
!     whose fill_value dummy argument is a character(kind=c_char)
!     void * pass-through, so the wrappers move the bit pattern through
!     a character buffer with transfer(). This test checks that the
!     round trip preserves the value for each kind.

program f90tst_var_fill
  use typeSizes
  use netcdf
  implicit none

  character (len = *), parameter :: FILE_NAME = "f90tst_var_fill.nc"

  ! Fill values written out, one per supported kind.
  integer(kind = OneByteInt),    parameter :: FILL_I1 = -3_OneByteInt
  integer(kind = TwoByteInt),    parameter :: FILL_I2 = -1234_TwoByteInt
  integer(kind = FourByteInt),   parameter :: FILL_I4 = -123456_FourByteInt
  integer(kind = EightByteInt),  parameter :: FILL_I8 = -1234567890123_EightByteInt
  real(kind = FourByteReal),     parameter :: FILL_R4 = -2.5_FourByteReal
  real(kind = EightByteReal),    parameter :: FILL_R8 = -3.25_EightByteReal

  ! Fill values read back in.
  integer(kind = OneByteInt)   :: in_i1
  integer(kind = TwoByteInt)   :: in_i2
  integer(kind = FourByteInt)  :: in_i4
  integer(kind = EightByteInt) :: in_i8
  real(kind = FourByteReal)    :: in_r4
  real(kind = EightByteReal)   :: in_r8

  integer :: ncid, dimid, no_fill
  integer :: varid_i1, varid_i2, varid_i4, varid_i8, varid_r4, varid_r8

  print *, ''
  print *,'*** Testing nf90_def_var_fill/nf90_inq_var_fill for all kinds.'

  call handle_err(nf90_create(FILE_NAME, nf90_netcdf4, ncid))
  call handle_err(nf90_def_dim(ncid, "x", 4, dimid))

  call handle_err(nf90_def_var(ncid, "v_i1", nf90_byte,   dimid, varid_i1))
  call handle_err(nf90_def_var(ncid, "v_i2", nf90_short,  dimid, varid_i2))
  call handle_err(nf90_def_var(ncid, "v_i4", nf90_int,    dimid, varid_i4))
  call handle_err(nf90_def_var(ncid, "v_i8", nf90_int64,  dimid, varid_i8))
  call handle_err(nf90_def_var(ncid, "v_r4", nf90_float,  dimid, varid_r4))
  call handle_err(nf90_def_var(ncid, "v_r8", nf90_double, dimid, varid_r8))

  ! Set an explicit fill value on each variable.
  call handle_err(nf90_def_var_fill(ncid, varid_i1, 0, FILL_I1))
  call handle_err(nf90_def_var_fill(ncid, varid_i2, 0, FILL_I2))
  call handle_err(nf90_def_var_fill(ncid, varid_i4, 0, FILL_I4))
  call handle_err(nf90_def_var_fill(ncid, varid_i8, 0, FILL_I8))
  call handle_err(nf90_def_var_fill(ncid, varid_r4, 0, FILL_R4))
  call handle_err(nf90_def_var_fill(ncid, varid_r8, 0, FILL_R8))

  call handle_err(nf90_close(ncid))

  ! Reopen and check that each fill value survived the round trip.
  call handle_err(nf90_open(FILE_NAME, nf90_nowrite, ncid))

  call handle_err(nf90_inq_varid(ncid, "v_i1", varid_i1))
  call handle_err(nf90_inq_varid(ncid, "v_i2", varid_i2))
  call handle_err(nf90_inq_varid(ncid, "v_i4", varid_i4))
  call handle_err(nf90_inq_varid(ncid, "v_i8", varid_i8))
  call handle_err(nf90_inq_varid(ncid, "v_r4", varid_r4))
  call handle_err(nf90_inq_varid(ncid, "v_r8", varid_r8))

  no_fill = -1
  call handle_err(nf90_inq_var_fill(ncid, varid_i1, no_fill, in_i1))
  if (no_fill .ne. 0 .or. in_i1 .ne. FILL_I1) stop 11

  no_fill = -1
  call handle_err(nf90_inq_var_fill(ncid, varid_i2, no_fill, in_i2))
  if (no_fill .ne. 0 .or. in_i2 .ne. FILL_I2) stop 12

  no_fill = -1
  call handle_err(nf90_inq_var_fill(ncid, varid_i4, no_fill, in_i4))
  if (no_fill .ne. 0 .or. in_i4 .ne. FILL_I4) stop 13

  no_fill = -1
  call handle_err(nf90_inq_var_fill(ncid, varid_i8, no_fill, in_i8))
  if (no_fill .ne. 0 .or. in_i8 .ne. FILL_I8) stop 14

  no_fill = -1
  call handle_err(nf90_inq_var_fill(ncid, varid_r4, no_fill, in_r4))
  if (no_fill .ne. 0 .or. in_r4 .ne. FILL_R4) stop 15

  no_fill = -1
  call handle_err(nf90_inq_var_fill(ncid, varid_r8, no_fill, in_r8))
  if (no_fill .ne. 0 .or. in_r8 .ne. FILL_R8) stop 16

  call handle_err(nf90_close(ncid))

  print *,'*** SUCCESS!'

contains
  subroutine handle_err(errcode)
    implicit none
    integer, intent(in) :: errcode

    if (errcode .ne. nf90_noerr) then
       print *, 'Error: ', trim(nf90_strerror(errcode))
       stop 2
    endif
  end subroutine handle_err
end program f90tst_var_fill
