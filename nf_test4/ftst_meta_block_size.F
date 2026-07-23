C     Copyright 2026 University Corporation for Atmospheric Research/Unidata.
C     See COPYRIGHT file for conditions of use.
C
C     Test nf_set_meta_block_size and nf_get_meta_block_size.
C
C     Ward Fisher

      program ftst_meta_block_size
      implicit none
      include 'netcdf.inc'

      character*(*) FILE_NAME
      parameter (FILE_NAME='ftst_meta_block_size.nc')

      integer META_BLOCK_SIZE
      parameter (META_BLOCK_SIZE = 1048576)

      integer DIM_LEN
      parameter (DIM_LEN = 64)

      integer ncid, dimid, varid
      integer retrieved
      integer retval
      integer i
      real data_out(64), data_in(64)
      integer chunks(1)

      print *, ''
      print *, '*** Testing nf_set_meta_block_size and
     &nf_get_meta_block_size.'

C     Test 1: round-trip set/get.
      print *, '*** Test 1: round-trip nf_set/get_meta_block_size...'
      retval = nf_set_meta_block_size(META_BLOCK_SIZE)
      if (retval .ne. nf_noerr) stop 2
      retval = nf_get_meta_block_size(retrieved)
      if (retval .ne. nf_noerr) stop 2
      if (retrieved .ne. META_BLOCK_SIZE) stop 3
      print *, '*** PASS'

C     Test 2: create a netCDF-4 file while override is set.
      print *, '*** Test 2: create file with meta_block_size set...'
      retval = nf_set_meta_block_size(META_BLOCK_SIZE)
      if (retval .ne. nf_noerr) stop 2
      retval = nf_create(FILE_NAME, NF_NETCDF4, ncid)
      if (retval .ne. nf_noerr) stop 2
      retval = nf_def_dim(ncid, 'd0', DIM_LEN, dimid)
      if (retval .ne. nf_noerr) stop 2
      retval = nf_def_var(ncid, 'v0', NF_FLOAT, 1, dimid, varid)
      if (retval .ne. nf_noerr) stop 2
      chunks(1) = DIM_LEN
      retval = nf_def_var_chunking(ncid, varid, NF_CHUNKED, chunks)
      if (retval .ne. nf_noerr) stop 2
      retval = nf_enddef(ncid)
      if (retval .ne. nf_noerr) stop 2
      do i = 1, DIM_LEN
        data_out(i) = real(i - 1)
      end do
      retval = nf_put_var_real(ncid, varid, data_out)
      if (retval .ne. nf_noerr) stop 2
      retval = nf_close(ncid)
      if (retval .ne. nf_noerr) stop 2
      print *, '*** PASS'

C     Test 3: data written with the override active is readable.
      print *, '*** Test 3: read back data from that file...'
      retval = nf_open(FILE_NAME, NF_NOWRITE, ncid)
      if (retval .ne. nf_noerr) stop 2
      retval = nf_inq_varid(ncid, 'v0', varid)
      if (retval .ne. nf_noerr) stop 2
      retval = nf_get_var_real(ncid, varid, data_in)
      if (retval .ne. nf_noerr) stop 2
      do i = 1, DIM_LEN
        if (data_in(i) .ne. data_out(i)) stop 4
      end do
      retval = nf_close(ncid)
      if (retval .ne. nf_noerr) stop 2
      print *, '*** PASS'

C     Test 4: setting size to 0 disables the override.
      print *, '*** Test 4: nf_set_meta_block_size(0) disables...'
      retval = nf_set_meta_block_size(0)
      if (retval .ne. nf_noerr) stop 2
      retval = nf_get_meta_block_size(retrieved)
      if (retval .ne. nf_noerr) stop 2
      if (retrieved .ne. 0) stop 3
      print *, '*** PASS'

      print *, '*** SUCCESS'
      end