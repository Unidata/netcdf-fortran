!     This is part of the netCDF package. Copyright 2006-2019
!     University Corporation for Atmospheric Research/Unidata. See
!     COPYRIGHT file for conditions of use.

!     This program tests the nf90_insert_enum and nf90_inq_enum_member
!     wrappers. Both hand the member value to nf_insert_enum /
!     nf_inq_enum_member, whose value dummy argument is a
!     character(kind=c_char) void * pass-through, so the wrappers move
!     the bit pattern through a character buffer with transfer(). This
!     test checks that the round trip preserves the member values.

program f90tst_enum
  use typeSizes
  use netcdf
  implicit none

  character (len = *), parameter :: FILE_NAME = "f90tst_enum.nc"
  character (len = *), parameter :: ENUM_TYPE_NAME = "cloud_class"
  character (len = *), parameter :: ZERO_NAME = "clear"
  character (len = *), parameter :: ONE_NAME = "cloudy"

  integer, parameter :: ZERO_VALUE = 0
  integer, parameter :: ONE_VALUE = 42

  integer :: ncid, enum_typeid
  integer :: base_nc_type, base_size, num_members
  integer :: num_types, typeids(1)
  integer :: member_value
  character (len = nf90_max_name) :: type_name, member_name

  print *, ''
  print *,'*** Testing nf90_insert_enum/nf90_inq_enum_member.'

  call handle_err(nf90_create(FILE_NAME, nf90_netcdf4, ncid))

  ! Define an enum type with two members.
  call handle_err(nf90_def_enum(ncid, nf90_int, ENUM_TYPE_NAME, enum_typeid))
  call handle_err(nf90_insert_enum(ncid, enum_typeid, ZERO_NAME, ZERO_VALUE))
  call handle_err(nf90_insert_enum(ncid, enum_typeid, ONE_NAME, ONE_VALUE))

  call handle_err(nf90_close(ncid))

  ! Reopen and check the members came back with the values we put in.
  call handle_err(nf90_open(FILE_NAME, nf90_nowrite, ncid))

  call handle_err(nf90_inq_typeids(ncid, num_types, typeids))
  if (num_types .ne. 1) stop 11

  call handle_err(nf90_inq_enum(ncid, typeids(1), type_name, base_nc_type, &
       base_size, num_members))
  if (type_name(1:len(ENUM_TYPE_NAME)) .ne. ENUM_TYPE_NAME .or. &
       base_nc_type .ne. nf90_int .or. num_members .ne. 2) stop 12

  member_value = -1
  call handle_err(nf90_inq_enum_member(ncid, typeids(1), 1, member_name, &
       member_value))
  if (member_name(1:len(ZERO_NAME)) .ne. ZERO_NAME .or. &
       member_value .ne. ZERO_VALUE) stop 13

  member_value = -1
  call handle_err(nf90_inq_enum_member(ncid, typeids(1), 2, member_name, &
       member_value))
  if (member_name(1:len(ONE_NAME)) .ne. ONE_NAME .or. &
       member_value .ne. ONE_VALUE) stop 14

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
end program f90tst_enum
