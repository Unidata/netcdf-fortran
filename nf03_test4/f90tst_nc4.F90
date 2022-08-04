!     This is part of the netCDF package. Copyright 2006-2019
!     University Corporation for Atmospheric Research/Unidata. See
!     COPYRIGHT file for conditions of use.

!     Tests new nf90_inq_path function
!     Mimics tests in C tst_files5.c code

!     Ed Hartnett, 2011
program f90tst_nc4
  use typeSizes
  use netcdf
  implicit none
  integer :: fh, dimid, varid, ndim, nvar, fmt
  character (len = *), parameter :: FILE_NAME = "f90tst_nc4.nc"

  print *, ''
  print *,'*** testing simple netCDF-4 file.'

  call check(nf90_create(FILE_NAME, NF90_NETCDF4, fh))
  call check(nf90_inq_format(fh, fmt))
  if (fmt .ne. nf90_format_netcdf4) stop 4
  call check(nf90_def_dim(fh, 'fred', 10, dimid))
  call check(nf90_def_var(fh, 'john', NF90_INT, (/dimid/), varid))
  call check(nf90_close(fh))
  
  ! Check the file.
  call check(nf90_open(FILE_NAME, NF90_WRITE, fh))
  call check(nf90_inq_format(fh, fmt))
  if (fmt .ne. nf90_format_netcdf4) stop 5
  call check(nf90_inquire(fh, nDimensions = ndim, nVariables = nvar))
  if (nvar .ne. 1 .or. ndim .ne. 1) stop 3
  call check(nf90_close(fh))
  print *,'*** OK!'

  print *,'*** Testing simple classic file.'

  call check(nf90_create(FILE_NAME, NF90_CLOBBER, fh))
  call check(nf90_inq_format(fh, fmt))
  if (fmt .ne. nf90_format_classic) stop 6
  call check(nf90_def_dim(fh, 'fred', 10, dimid))
  call check(nf90_def_var(fh, 'john', NF90_INT, (/dimid/), varid))
  call check(nf90_close(fh))
  
  ! Check the file.
  call check(nf90_open(FILE_NAME, NF90_WRITE, fh))
  call check(nf90_inq_format(fh, fmt))
  if (fmt .ne. nf90_format_classic) stop 6
  call check(nf90_inquire(fh, nDimensions = ndim, nVariables = nvar))
  if (nvar .ne. 1 .or. ndim .ne. 1) stop 3
  call check(nf90_close(fh))
  print *,'*** OK!'

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
end program f90tst_nc4
