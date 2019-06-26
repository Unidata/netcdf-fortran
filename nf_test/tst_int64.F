C     This program tests CDF-5 file format, with int64 data type

      subroutine check(err, message)
          implicit none
          include 'netcdf.inc'
          integer err
          character message*(*)

          if (err .NE. NF_NOERR) then
              write(6,*) message//' '//nf_strerror(err)
              stop 1
          end if
      end

      program tst_int64
      implicit none
      include 'netcdf.inc'

C     This is the name of the data file we will create.
      character*(*) FILE_NAME
      parameter (FILE_NAME='tst_int64.nc')

C     We are writing 2D data, a 6 x 12 grid.
      integer NDIMS
      parameter (NDIMS=2)
      integer NX, NY
      parameter (NX = 6, NY = 12)

C     NetCDF IDs.
      integer ncid, varid(2), dimids(NDIMS)
      integer x_dimid, y_dimid
      integer xtype, attr_len, cmode
      integer start(2), count(2), stride(2), imap(2)

C     This is the data array we will write, and a place to store it when
C     we read it back in.
      integer*8 i64buf_out(NY, NX), i64buf_in(NY, NX), attr(1), twoG

C     Loop indexes, and error handling.
      integer x, y, err

      twoG = 2147483647
      twoG = twoG + 1

      print *, ''
      print *,'*** Testing NF_INT64 data type for CDF-5 file.'

C     Check error code NF_EBADTYPE

C     Create a CDF-2 netCDF file.
      cmode = IOR(NF_CLOBBER, NF_64BIT_OFFSET)
      err = nf_create(FILE_NAME, cmode, ncid)
      call check(err, 'In nf_create: ')

C     Put a global attribute. Expect NF_EBADTYPE.
      attr(1) = twoG + 123456789
      err = nf_put_att_int64(ncid, NF_GLOBAL, "gatt", NF_INT64, 1, attr)
      if (err .NE. NF_EBADTYPE) then
          write(6,*) 'Error: expect NF_EBADTYPE but got ', err
          stop 2
      end if

C     Write a data of type integer*8 to a global attribute of type NF_INT.
      attr(1) = 123456789
      err = nf_put_att_int64(ncid, NF_GLOBAL, "gatt", NF_INT, 1, attr)
      call check(err, 'In nf_put_att_int64: ')

C     Define the dimensions.
      err = nf_def_dim(ncid, "x", NX, x_dimid)
      call check(err, 'In nf_def_dim: ')
      err = nf_def_dim(ncid, "y", NY, y_dimid)
      call check(err, 'In nf_def_dim: ')

      dimids(1) = y_dimid
      dimids(2) = x_dimid

C     Define a variable of type NF_INT64 in a CDF-2 file. Expect NF_EBADTYPE.
      dimids(1) = x_dimid
      err = nf_def_var(ncid, "data", NF_INT64, 1, dimids, varid(1))
      if (err .NE. NF_EBADTYPE) then
          write(6,*) 'Error: expect NF_EBADTYPE but got ', err
          stop 3
      end if

C     Define a variable of type NF_INT.
      err = nf_def_var(ncid, "var_int", NF_INT, NDIMS, dimids, varid(1))
      call check(err, 'In nf_def_var: ')

C     Since this is a classic model file, we must call enddef
      err = nf_enddef(ncid)
      call check(err, 'In nf_enddef: ')

C     Initialize write buffer
      do x = 1, NX
         do y = 1, NY
            i64buf_out(y, x) = x * y
         end do
      end do

C     Set start(:) and count(:)
      start(1) = 2
      start(2) = 3
      count(1) = 2
      count(2) = 2
      stride(1) = 2
      stride(2) = 2
      imap(1) = NX
      imap(2) = 1

C     Write to the file using all kinds of put APIs.
      err = nf_put_var1_int64(ncid, varid(1), start, i64buf_out)
      call check(err, 'In nf_put_var1_int64: ')

      err = nf_put_vara_int64(ncid, varid(1), start, count, i64buf_out)
      call check(err, 'In nf_put_vara_int64: ')

      err = nf_put_vars_int64(ncid, varid(1), start, count, stride,
     +                        i64buf_out)
      call check(err, 'In nf_put_vars_int64: ')

      err = nf_put_varm_int64(ncid, varid(1), start, count, stride,
     +                        imap, i64buf_out)
      call check(err, 'In nf_put_varm_int64: ')

      err = nf_put_var_int64(ncid, varid(1), i64buf_out)
      call check(err, 'In nf_put_var_int64: ')

C     Close the CDF-2 file.
      err = nf_close(ncid)
      call check(err, 'In nf_close: ')

#ifdef ENABLE_CDF5
C     Create a CDF-5 netCDF file.
      cmode = IOR(NF_CLOBBER, NF_64BIT_DATA)
      err = nf_create(FILE_NAME, cmode, ncid)
      call check(err, 'In nf_create: ')

C     Put a value of type integer*8 to a global attribute of type NF_INT64.
      attr(1) = twoG + 123456789
      err = nf_put_att_int64(ncid, NF_GLOBAL, "gatt", NF_INT64, 1, attr)
      call check(err, 'In nf_put_att_int64: ')

C     Define the dimensions.
      err = nf_def_dim(ncid, "x", NX, x_dimid)
      call check(err, 'In nf_def_dim: ')
      err = nf_def_dim(ncid, "y", NY, y_dimid)
      call check(err, 'In nf_def_dim: ')

      dimids(1) = y_dimid
      dimids(2) = x_dimid

C     Define a variable of type NF_INT64.
      err = nf_def_var(ncid, "var_int64",NF_INT64,NDIMS,dimids,varid(1))
      call check(err, 'In nf_def_var: ')

C     Define a variable of type NF_INT.
      err = nf_def_var(ncid, "var_int", NF_INT, NDIMS, dimids, varid(2))
      call check(err, 'In nf_def_var: ')

C     Since this is a classic model file, we must call enddef
      err = nf_enddef(ncid)
      call check(err, 'In nf_enddef: ')

C     Write a buffer of type integer*8 to a variable of type NF_INT.
      err = nf_put_var_int64(ncid, varid(2), i64buf_out)
      call check(err, 'In nf_put_var_int64: ')

C     Use large values for write data.
      do x = 1, NX
         do y = 1, NY
            i64buf_out(y, x) = twoG + x * y
         end do
      end do

C     Write the data to the file using different kinds of put APIs.
      err = nf_put_var1_int64(ncid, varid(1), start, i64buf_out)
      call check(err, 'In nf_put_var1_int64: ')

      err = nf_put_vara_int64(ncid, varid(1), start, count, i64buf_out)
      call check(err, 'In nf_put_vara_int64: ')

      err = nf_put_vars_int64(ncid, varid(1), start, count, stride,
     +                        i64buf_out)
      call check(err, 'In nf_put_vars_int64: ')

      err = nf_put_varm_int64(ncid, varid(1), start, count, stride,
     +                        imap, i64buf_out)
      call check(err, 'In nf_put_varm_int64: ')

      err = nf_put_var_int64(ncid, varid(1), i64buf_out)
      call check(err, 'In nf_put_var_int64: ')

C     Close the CDF-5 file.
      err = nf_close(ncid)
      call check(err, 'In nf_close: ')

C     Reopen the CDF-5 file and check again.
      err = nf_open(FILE_NAME, NF_NOWRITE, ncid)
      call check(err, 'In nf_open: ')

C     read the global attribute and check value
      err = nf_inq_att(ncid, NF_GLOBAL, "gatt", xtype, attr_len)
      call check(err, 'In nf_inq_att: ')

      if (xtype .NE. NF_INT64) then
          print *,'Error: unepected xtype ', xtype
      end if

      if (attr_len .NE. 1) then
          print *,'Error: unepected attribute length ', attr_len
      end if

      attr(1) = 0
      err = nf_get_att_int64(ncid, NF_GLOBAL, "gatt", attr)
      call check(err, 'In nf_get_att_int64: ')

      if (attr(1) .NE. twoG + 123456789) then
          print *,'Error: unepected attribute value ', attr(1)
      end if

C     Find variable ID.
      err = nf_inq_varid(ncid, "var_int64", varid(1))
      call check(err, 'In nf_inq_varid: ')
      if (varid(1) .ne. 1) stop 4

C     Read the data
      err = nf_get_var1_int64(ncid, varid(1), start, i64buf_in)
      call check(err, 'In nf_get_var1_int64: ')

      err = nf_get_vara_int64(ncid, varid(1), start, count, i64buf_in)
      call check(err, 'In nf_get_vara_int64: ')

      err = nf_get_vars_int64(ncid, varid(1), start, count, stride,
     +                        i64buf_in)
      call check(err, 'In nf_get_vars_int64: ')

      err = nf_get_varm_int64(ncid, varid(1), start, count, stride,
     +                        imap, i64buf_in)
      call check(err, 'In nf_get_varm_int64: ')

C     Read the whole data and check it.
      err = nf_get_var_int64(ncid, varid(1), i64buf_in)
      call check(err, 'In nf_get_var_int64: ')
      do x = 1, NX
         do y = 1, NY
            if (i64buf_in(y, x) .ne. i64buf_out(y, x)) stop 5
         end do
      end do

C     Find variable ID of type NF_INT.
      err = nf_inq_varid(ncid, "var_int", varid(2))
      call check(err, 'In nf_inq_varid: ')
      if (varid(2) .ne. 2) stop 6

C     Read the whole data of type NF_INT into a buffer of type integer*8.
      err = nf_get_var_int64(ncid, varid(2), i64buf_in)
      call check(err, 'In nf_get_var_int64: ')
      do x = 1, NX
         do y = 1, NY
            if (i64buf_in(y, x) .ne. x * y) stop 7
         end do
      end do

C     Close the file.
      err = nf_close(ncid)
      call check(err, 'In nf_close: ')
#endif
      print *,'*** SUCCESS!'
      end
