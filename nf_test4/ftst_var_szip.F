C     This is part of the netCDF package.
C     Copyright 2020 University Corporation for Atmospheric Research/Unidata.
C     See COPYRIGHT file for conditions of use.

C     This program tests netCDF-4 szip compression. This test is only
C     run if nc_def_var_szip() is found in netcdf-c, and also the HDF5
C     instance upon which the netcdf-c depends was built with szip.

C     Ed Hartnett, 1/31/20

      program ftst_var_szip
      implicit none
      include 'netcdf.inc'

C     This is the name of the data file we will create.
      character*(*) FILE_NAME
      parameter (FILE_NAME='ftst_var_szip.nc')
      integer NDIMS
      parameter (NDIMS = 1)
      integer DIM_LEN
      parameter (DIM_LEN = 22)
      integer NVARS
      parameter (NVARS = 3)
      integer DATA_LEN
      parameter (DATA_LEN = 22)
      integer check_file

      integer ncid, varid(NVARS), dimids(NDIMS)
      integer data_len_in, offset
      parameter (offset = 20)
      integer data1(DATA_LEN), data1_in(DATA_LEN)
      character*(4) var_name(NVARS)
      character*(4) dim_name
      parameter (dim_name = 'dim1')
      integer NO_FILL, MY_FILL_VALUE
      parameter (NO_FILL = 1)
      parameter (MY_FILL_VALUE = 42)

C     Loop index and error handling.
      integer x, retval

      print *, ''
      print *,'*** Testing szip compression.'

C     Prepare some data to write.
      do x = 1, DATA_LEN
         data1(x) = x
      end do

C     Set up var names.
      var_name(1) = 'var1'
      var_name(2) = 'var2'
      var_name(3) = 'var3'

C      retval = nf_set_log_level(3)

C     Create the netCDF file.
      retval = nf_create(FILE_NAME, NF_NETCDF4, ncid)
      if (retval .ne. nf_noerr) stop 1

C     Create a dimension.
      retval = nf_def_dim(ncid, dim_name, DIM_LEN, dimids(1))
      if (retval .ne. nf_noerr) stop 1

C     Create a few integer variables.
      do x = 1, NVARS      
         retval = nf_def_var(ncid, var_name(x), NF_INT, NDIMS, dimids,
     $        varid(x))
         if (retval .ne. nf_noerr) stop 1
      end do

C     Set an alternative fill value for the third variable.
      retval = nf_def_var_fill(ncid, varid(3), 0, MY_FILL_VALUE)
      if (retval .ne. 0) stop 3

C     Turn on szip compression for var 1.
      retval = nf_def_var_szip(ncid, varid(1),
     $     nf_szip_ec_option_mask, 4)
      if (retval .ne. 0) stop 3

C     Turn on szip compression for var 3.
      retval = nf_def_var_szip(ncid, varid(3),
     $     nf_szip_nn_option_mask, 4)
      if (retval .ne. 0) stop 3

C     Write some data.
      retval = nf_put_var_int(ncid, varid(1), data1)
      if (retval .ne. nf_noerr) stop 1

C     Close the file.
      retval = nf_close(ncid)
      if (retval .ne. nf_noerr) stop 1

C     Reopen the file.
      retval = nf_open(FILE_NAME, NF_NOWRITE, ncid)
      if (retval .ne. nf_noerr) stop 1

C     Check it out. 
      retval = check_file(ncid, var_name, dim_name)
      if (retval .ne. 0) stop 4

C     Close the file. 
      retval = nf_close(ncid)
      if (retval .ne. nf_noerr) stop 1

      print *,'*** SUCCESS!'
      end

C     This function check the file to make sure everything is OK.
      integer function check_file(ncid, var_name, dim_name)
      implicit none
      include 'netcdf.inc'

C     I need these in both here and the main program.
      integer NDIMS
      parameter (NDIMS = 1)
      integer DIM_LEN
      parameter (DIM_LEN = 22)
      integer NVARS
      parameter (NVARS = 3)
      integer DATA_LEN
      parameter (DATA_LEN = 22)
      integer MY_FILL_VALUE
      parameter (MY_FILL_VALUE = 42)

C     Parameters
      integer ncid
      character*(4) var_name(NVARS)
      character*(4) dim_name

C     Values that are read in, to check the file.
      integer ndims_in, nvars_in, ngatts_in, unlimdimid_in
      integer xtype_in, dimids_in(NDIMS), natts_in
      integer varid_in(NVARS), dimid_in, no_fill_in, fill_value_in
      character*(4) var_name_in
      integer int_data_in(DIM_LEN)
      integer options_mask_in, pixels_per_block_in

      integer x, retval

C     Check it out.
      retval = nf_inq(ncid, ndims_in, nvars_in, ngatts_in,
     $     unlimdimid_in)
      if (retval .ne. nf_noerr) stop 1
      if (ndims_in .ne. 1 .or. nvars_in .ne. NVARS .or. ngatts_in .ne. 0
     $     .or. unlimdimid_in .ne. -1) stop 5

C     Get the varids and the dimid.
      do x = 1, NVARS      
         retval = nf_inq_varid(ncid, var_name(x), varid_in(x))
         if (retval .ne. nf_noerr) stop 1
         if (varid_in(x) .ne. x) stop 6
      end do
      retval = nf_inq_dimid(ncid, dim_name, dimid_in)
      if (retval .ne. nf_noerr) stop 1
      if (dimid_in .ne. 1) stop 7

C     Get the data in var1. It will be values we have set.
      retval = nf_get_var_int(ncid, varid_in(1), int_data_in)
      if (retval .ne. nf_noerr) stop 1
      do x = 1, DIM_LEN
         if (int_data_in(x) .ne. x) stop 13
      end do

C     Get the szip settings for var1. H5Zszip code will sometimes bump
C     the bits_per_pixel from 32 to 64 and may add other flags to the
C     options_mask, so we don't check these values in this test.
      retval = nf_inq_var_szip(ncid, varid_in(1), options_mask_in,
     $     pixels_per_block_in)

C     Get the data in var2. It will be default fill value.
      retval = nf_get_var_int(ncid, varid_in(2), int_data_in)
      if (retval .ne. nf_noerr) stop 1
      do x = 1, DIM_LEN
         if (int_data_in(x) .ne. NF_FILL_INT) stop 13
      end do

C     Get the data in var3. It will be all the assigned fill value.
      retval = nf_get_var_int(ncid, varid_in(3), int_data_in)
      if (retval .ne. nf_noerr) stop 1
      do x = 1, DIM_LEN
         if (int_data_in(x) .ne. MY_FILL_VALUE) stop 14
      end do

      check_file = 0
      end 
