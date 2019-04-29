C********************************************************************
C   Copyright 1993, UCAR/Unidata
C   See netcdf/COPYRIGHT file for copying and redistribution conditions.
C   $Id: ftest.F,v 1.11 2009/01/25 14:33:45 ed Exp $
C********************************************************************

C     This is part of the netCDF package.
C     Copyright 2006 University Corporation for Atmospheric Research/Unidata.
C     See COPYRIGHT file for conditions of use.

C     This program tests netCDF-4 variable Filter support from fortran.

      program ftst_filter
      implicit none
      include 'netcdf.inc'

C     This is the name of the data file we will create.
      character*(*) FILE_NAME
      parameter (FILE_NAME='ftst_filter.nc')

C     We are writing 2D data, a 6 x 12 grid. 
      integer NDIMS
      parameter (NDIMS=2)
      integer NX, NY
      parameter (NX = 6, NY = 12)
      integer DATAOFFSET
C      parameter (DATAOFFSET = 2147483646)
      parameter (DATAOFFSET = 0)

C     NetCDF IDs.
      integer ncid, varid, dimids(NDIMS)
      integer x_dimid, y_dimid

C     This is the data array we will write, and a place to store it when
C     we read it back in.
      integer data_out(NY, NX), data_in(NY, NX)

C     For checking our data file to make sure it's correct.
      integer chunks(NDIMS), chunks_in(NDIMS)
      integer filterid, nparams, params(1)

C     Loop indexes, and error handling.
      integer x, y, retval

C     Create some pretend data.
      do x = 1, NX
         do y = 1, NY
            data_out(y, x) = DATAOFFSET + x * y
         end do
      end do

      print *, ''
      print *,'*** Testing definition netCDF-4 Filters'

C     Create the netCDF file.
      retval = nf_create(FILE_NAME, NF_CLOBBER+NF_NETCDF4, ncid)
      if (retval .ne. nf_noerr) stop 1

C     Define the dimensions.
      retval = nf_def_dim(ncid, "x", NX, x_dimid)
      if (retval .ne. nf_noerr) stop 1
      retval = nf_def_dim(ncid, "y", NY, y_dimid)
      if (retval .ne. nf_noerr) stop 1

C     Define the variable. 
      dimids(1) = y_dimid
      dimids(2) = x_dimid
      retval = nf_def_var(ncid, "data", NF_INT64, NDIMS, dimids, varid)
      if (retval .ne. nf_noerr) stop 1

C     Turn on chunking.
      chunks(1) = NY
      chunks(2) = NX
      retval = nf_def_var_chunking(ncid, varid, 0, chunks)
      if (retval .ne. nf_noerr) stop 1

C     Set bzip filter on variable
      params(1) = 9
      retval = nf_def_var_filter(ncid, varid, 307, 1, params)
      if (retval .ne. nf_noerr) stop 1

      retval = nf_enddef(ncid)
      if (retval .ne. nf_noerr) stop 1

C     Write the pretend data to the file.
      retval = nf_put_var_int(ncid, varid, data_out)
      if (retval .ne. nf_noerr) stop 1

C     Close the file. 
      retval = nf_close(ncid)
      if (retval .ne. nf_noerr) stop 1

C     Reopen the file and check again.
      retval = nf_open(FILE_NAME, NF_NOWRITE, ncid)
      if (retval .ne. nf_noerr) stop 1

C     Find our variable.
      retval = nf_inq_varid(ncid, "data", varid)
      if (retval .ne. nf_noerr) stop 1
      if (varid .ne. 1) stop 2

C     Check the filter
      params(1) = -1
      retval = nf_inq_var_filter(ncid, varid, filterid, nparams, params)
      if (retval .ne. nf_noerr) stop 1
      if (filterid .ne. 307) stop 2
      if (nparams .ne. 1) stop 2
      if (params(1) .ne. 9) stop 2

C     Read the data and check it.
      retval = nf_get_var_int(ncid, varid, data_in)
      if (retval .ne. nf_noerr) stop 1
      do x = 1, NX
         do y = 1, NY
            if (data_in(y, x) .ne. data_out(y, x)) stop 2
         end do
      end do

C     Close the file. 
      retval = nf_close(ncid)
      if (retval .ne. nf_noerr) stop 1

      print *,'*** SUCCESS!'
      end
