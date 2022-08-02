C     This is part of the netCDF package.
C     Copyright 2008 University Corporation for Atmospheric Research/Unidata.
C     See COPYRIGHT file for conditions of use.

C     This program tests netCDF-4 variable functions from fortran,
C     checking the quantize and zstandard features.

C     Ed Hartnett, 9/3/21

      program ftst_vars7
      implicit none
      include 'netcdf.inc'

C     This is the name of the data file we will create.
      character*(*) FILE_NAME
      parameter (FILE_NAME='ftst_vars7.nc')
      integer NDIM1
      parameter (NDIM1 = 1)
      integer DIM_LEN_5
      parameter (DIM_LEN_5 = 5)
      integer NVARS
      parameter (NVARS = 2)
      integer check_file
      integer NSD_3
      parameter (NSD_3 = 3)
      integer ZSTD_LEVEL
      parameter (ZSTD_LEVEL = 3)

      integer ncid, varid(NVARS), dimids(NDIM1)
      character*(10) var_name(NVARS)
      integer var_type(NVARS)
      character*(4) dim_name
      parameter (dim_name = 'dim1')
      integer start(NDIM1), count(NDIM1)
      real real_data(DIM_LEN_5)
      real*8 double_data(DIM_LEN_5)

C     Loop index and error handling.
      integer x, retval

      print *, ''
      print *,'*** Testing quantize feature.'
#ifdef ENABLE_ZSTD
      print *,'*** (and zstandard compression)'
#endif

C     Set up var names.
      var_name(1) = 'var__float'
      var_type(1) = NF_FLOAT
      var_name(2) = 'var_double'
      var_type(2) = NF_DOUBLE

C     Set up data.
C     float real_data[DIM_LEN_5] = {1.11111111, 1.0, 9.99999999, 12345.67, .1234567};
C     double double_data[DIM_LEN_5] = {1.1111111, 1.0, 9.999999999, 1234567890.12345, 123456789012345.0};
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

C     Create the netCDF file.
      retval = nf_create(FILE_NAME, NF_NETCDF4, ncid)
      if (retval .ne. nf_noerr) stop 1

C     Create a dimension.
      retval = nf_def_dim(ncid, dim_name, DIM_LEN_5, dimids(1))
      if (retval .ne. nf_noerr) stop 2

C     Create some variables.
      do x = 1, NVARS
         retval = nf_def_var(ncid, var_name(x), var_type(x), NDIM1,
     $        dimids, varid(x))
         if (retval .ne. nf_noerr) stop 3

C     Turn on quantize.
         retval = nf_def_var_quantize(ncid, varid(x),
     $        NF_QUANTIZE_BITGROOM, NSD_3)
         if (retval .ne. nf_noerr) stop 4


C     Turn on zstandard compression if available, zlib otherwise.
#ifdef ENABLE_ZSTD
         retval = nf_def_var_zstandard(ncid, varid(x), ZSTD_LEVEL)
         if (retval .ne. nf_noerr) then
            if (retval .eq. nf_enofilter) then
               print *, 'Zstandard filter not found.'
               print *, 'Set HDF5_PLUGIN_PATH and try again.'
            else
               print *, nf_strerror(retval)
            endif
            stop 5
         endif
#else
         retval = nf_def_var_deflate(ncid, varid(x), 0, 1, 1)
         if (retval .ne. nf_noerr) stop 6
#endif

      end do

C     Write some data (which automatically calls nf_enddef).
      start(1) = 1
      count(1) = DIM_LEN_5
      retval = nf_put_vara_real(ncid, varid(1), start, count,
     $     real_data)
      if (retval .ne. 0) stop 7
      retval = nf_put_vara_double(ncid, varid(2), start, count,
     $     double_data)
      if (retval .ne. 0) stop 8

C     Check it out.
      retval = check_file(ncid, var_name, var_type, dim_name)
      if (retval .ne. 0) stop 9

C     Close the file.
      retval = nf_close(ncid)
      if (retval .ne. nf_noerr) stop 20

C     Reopen the file.
      retval = nf_open(FILE_NAME, NF_NOWRITE, ncid)
      if (retval .ne. nf_noerr) stop 21

C     Check it out.
      retval = check_file(ncid, var_name, var_type, dim_name)
      if (retval .ne. 0) stop 22

C     Close the file.
      retval = nf_close(ncid)
      if (retval .ne. nf_noerr) stop 23

      print *,'*** SUCCESS!'
      end

C     This function check the file to make sure everything is OK.
      integer function check_file(ncid, var_name, var_type, dim_name)
      implicit none
      include 'netcdf.inc'

C     I need these in both here and the main program.
      integer NDIM1
      parameter (NDIM1 = 1)
      integer DIM_LEN_5
      parameter (DIM_LEN_5 = 5)
      integer NVARS
      parameter (NVARS = 2)
      integer NSD_3
      parameter (NSD_3 = 3)
      real EPSILON
      parameter (EPSILON  = .01)

C     Parameters
      integer ncid
      character*(10) var_name(NVARS)
      integer var_type(NVARS)
      character*(4) dim_name

C     Values that are read in, to check the file.
      integer ndims_in, nvars_in, ngatts_in, unlimdimid_in
      integer xtype_in, dimids_in(NDIM1), natts_in
      integer varid_in(NVARS), dimid_in, quantize_mode_in, nsd_in
      integer zstandard, zstandard_level_in
      character*(10) var_name_in
      real real_data_in(DIM_LEN_5)
      real*8 double_data_in(DIM_LEN_5)
      real real_data_expected(DIM_LEN_5)
      real*8 double_data_expected(DIM_LEN_5)
      real diff
      real*8 diff8

      integer x, retval

C     What we expect to get back.
      real_data_expected(1) = 1.11084
      real_data_expected(2) = 1.000488
      real_data_expected(3) = 10
      real_data_expected(4) = 12348
      real_data_expected(5) = 0.1234436
      double_data_expected(1) = 1.11083984375
      double_data_expected(2) = 1.00048828125
      double_data_expected(3) = 10
      double_data_expected(4) = 1234698240
      double_data_expected(5) = 1234173952

C     Check it out.
      retval = nf_inq(ncid, ndims_in, nvars_in, ngatts_in,
     $     unlimdimid_in)
      if (retval .ne. nf_noerr) stop 30
      if (ndims_in .ne. 1 .or. nvars_in .ne. NVARS .or. ngatts_in .ne. 0
     $     .or. unlimdimid_in .ne. -1) stop 31

C     Get the varids and the dimid.
      do x = 1, NVARS
         retval = nf_inq_varid(ncid, var_name(x), varid_in(x))
         if (retval .ne. nf_noerr) stop 32
         if (varid_in(x) .ne. x) stop 33
      end do
      retval = nf_inq_dimid(ncid, dim_name, dimid_in)
      if (retval .ne. nf_noerr) stop 34
      if (dimid_in .ne. 1) stop 35

C     These things are the same for all variables, except natts_in is
C     different for quantize vars after the file is written, there is an
C     extra attribute.
      do x = 1, NVARS
C     Check quantize settings.
         retval = nf_inq_var(ncid, varid_in(x), var_name_in, xtype_in,
     $        ndims_in, dimids_in, natts_in)
         if (retval .ne. nf_noerr) stop 40
         if (ndims_in .ne. 1 .or. xtype_in .ne. var_type(x) .or.
     $        dimids_in(1).ne. dimid_in) stop 41
         retval = nf_inq_var_quantize(ncid, varid_in(x),
     $        quantize_mode_in, nsd_in)
         if (retval .ne. nf_noerr) stop 42
         if (quantize_mode_in .ne. nf_quantize_bitgroom) stop 43
         if (nsd_in .ne. NSD_3) stop 44

C     Check compression settings.
#ifdef ENABLE_ZSTD
         retval = nf_inq_var_zstandard(ncid, varid_in(x), zstandard,
     $        zstandard_level_in)
         if (retval .ne. nf_noerr) stop 50
         if (zstandard_level_in .ne. 3 .or. zstandard .eq. 0) stop 51
#endif

      end do

C     Get the data.
      retval = nf_get_var_real(ncid, varid_in(1), real_data_in)
      if (retval .ne. nf_noerr) stop 60
      retval = nf_get_var_double(ncid, varid_in(2), double_data_in)
      if (retval .ne. nf_noerr) stop 61

C     Check the data.
      do x = 1, DIM_LEN_5
         diff = abs(real_data_in(x) - real_data_expected(x))
         if (diff .gt. EPSILON) stop 70
         diff = abs(double_data_in(x) - double_data_expected(x))
c$$$  print *, double_data_in(x), double_data_expected(x)
c$$$  print *, 'x = ', x, ' diff = ', diff
         if (diff .gt. EPSILON) stop 71
      end do

      check_file = 0
      end
