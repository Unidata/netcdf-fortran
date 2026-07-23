! Copyright 2026 University Corporation for Atmospheric Research/Unidata.
! See COPYRIGHT file for conditions of use.
!
! Test nf90_set_meta_block_size and nf90_get_meta_block_size.
!
! Ward Fisher

program f90tst_meta_block_size
  use netcdf
  implicit none

  character(len=*), parameter :: FILE_NAME = 'f90tst_meta_block_size.nc'

  integer, parameter :: META_BLOCK_SIZE = 1048576
  integer, parameter :: DIM_LEN = 64

  integer :: ncid, dimid, varid
  integer :: retrieved
  integer :: i
  real    :: data_out(DIM_LEN), data_in(DIM_LEN)
  integer :: chunks(1)

  print *, ''
  print *, '*** Testing nf90_set_meta_block_size and nf90_get_meta_block_size.'

  ! Test 1: round-trip set/get.
  print *, '*** Test 1: round-trip nf90_set/get_meta_block_size...'
  if (nf90_set_meta_block_size(META_BLOCK_SIZE) .ne. nf90_noerr) stop 2
  if (nf90_get_meta_block_size(retrieved) .ne. nf90_noerr) stop 2
  if (retrieved .ne. META_BLOCK_SIZE) stop 3
  print *, '*** PASS'

  ! Test 2: create a netCDF-4 file while override is set.
  print *, '*** Test 2: create file with meta_block_size set...'
  if (nf90_set_meta_block_size(META_BLOCK_SIZE) .ne. nf90_noerr) stop 2
  if (nf90_create(FILE_NAME, NF90_NETCDF4, ncid) .ne. nf90_noerr) stop 2
  if (nf90_def_dim(ncid, 'd0', DIM_LEN, dimid) .ne. nf90_noerr) stop 2
  if (nf90_def_var(ncid, 'v0', NF90_FLOAT, dimid, varid) .ne. nf90_noerr) stop 2
  chunks(1) = DIM_LEN
  if (nf90_def_var_chunking(ncid, varid, NF90_CHUNKED, chunks) .ne. nf90_noerr) stop 2
  if (nf90_enddef(ncid) .ne. nf90_noerr) stop 2
  do i = 1, DIM_LEN
    data_out(i) = real(i - 1)
  end do
  if (nf90_put_var(ncid, varid, data_out) .ne. nf90_noerr) stop 2
  if (nf90_close(ncid) .ne. nf90_noerr) stop 2
  print *, '*** PASS'

  ! Test 3: data written with the override active is readable.
  print *, '*** Test 3: read back data from that file...'
  if (nf90_open(FILE_NAME, NF90_NOWRITE, ncid) .ne. nf90_noerr) stop 2
  if (nf90_inq_varid(ncid, 'v0', varid) .ne. nf90_noerr) stop 2
  if (nf90_get_var(ncid, varid, data_in) .ne. nf90_noerr) stop 2
  do i = 1, DIM_LEN
    if (data_in(i) .ne. data_out(i)) stop 4
  end do
  if (nf90_close(ncid) .ne. nf90_noerr) stop 2
  print *, '*** PASS'

  ! Test 4: setting size to 0 disables the override.
  print *, '*** Test 4: nf90_set_meta_block_size(0) disables...'
  if (nf90_set_meta_block_size(0) .ne. nf90_noerr) stop 2
  if (nf90_get_meta_block_size(retrieved) .ne. nf90_noerr) stop 2
  if (retrieved .ne. 0) stop 3
  print *, '*** PASS'

  print *, '*** SUCCESS'
end program f90tst_meta_block_size