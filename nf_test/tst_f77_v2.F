C     This is part of netCDF, Copyright 2006, UCAR

C     This test program uses the fortran 77 v2 API to create a simple
C     data file with some phony data in it. This program was originally
C     based on one contributed by Jeremy Kepner,
C     jvkepner@astro.Princeton.EDU.

C     Also test the char array bug reported in
C     https://github.com/Unidata/netcdf-fortran/issues/329.

C     This program will bail out in the event of a netcdf error.

C     Ed Hartnett, 2009

      PROGRAM tst_f77_v2
      IMPLICIT NONE
      include 'netcdf.inc'

      INTEGER n_dim, x_dim, y_dim, z_dim
      PARAMETER(n_dim = 3, x_dim = 20, y_dim = 10, z_dim = 5)
      INTEGER dim_array(n_dim)
      INTEGER start(n_dim), count(n_dim)
      integer char_len
      parameter(char_len = 14)
      character*14 char_string
      INTEGER start_1d(1), count_1d(1)      
      INTEGER ncid, errcode
      INTEGER x_id, y_id, z_id, arr_id, char_id, char_dim_id
      REAL array(x_dim,y_dim,z_dim)
      INTEGER i,j,k

      character*10 char_dim_name_in
      integer char_dim_size_in
      character*11 char_var_name_in
      integer var_type_in, nvdims_in
      integer vdims_in(3)
      integer natts_in
      character*14 char_string_in
      integer char_len_in
      char_len_in = 14

C     Put something into the array.
      DO i=1,x_dim
         DO j=1,y_dim
            DO k=1,z_dim
               array(i,j,k) = (i-1) + x_dim*(j-1) + x_dim*y_dim*(k-1)
            ENDDO
         ENDDO
      ENDDO

C     Put something into the character string.      
      char_string = 'dirty_old_town'

      print *, ''
      print *, ' *** Testing netCDF v2 api for F77.'

C     Create file.
      ncid = NCCRE('tst03_f77_v2.nc', NCCLOB, errcode)
      if (errcode .ne. 0) stop 2

C     Create Dimensions for floating point data.
      x_id = NCDDEF(ncid, 'X', x_dim, errcode)
      y_id = NCDDEF(ncid, 'Y', y_dim, errcode)
      z_id = NCDDEF(ncid, 'Z', z_dim, errcode)

C     Assign dimensions to array.
      dim_array(1) = z_id
      dim_array(2) = y_id
      dim_array(3) = x_id

C     Create a float variable.
      arr_id = NCVDEF(ncid, 'array', NCFLOAT, n_dim, dim_array, errcode)
      if (errcode .ne. 0) stop 2

C     Create Dimension for char array.
      char_dim_id = NCDDEF(ncid, 'string_len', char_len, errcode)
      if (errcode .ne. 0) stop 2
      
C     Assign dimensions to array.
      dim_array(1) = char_dim_id

C     Create a char variable.
      char_id = NCVDEF(ncid, 'Dublin_song', NCCHAR, 1, dim_array,
     &     errcode)
      if (errcode .ne. 0) stop 2

C     Leave define mode.
      CALL NCENDF(ncid, errcode)
      if (errcode .ne. 0) stop 2

C     Write float data to file.
      start(1) = 1
      start(2) = 1
      start(3) = 1
      count(1) = z_dim
      count(2) = y_dim
      count(3) = x_dim
      CALL NCVPT(ncid, arr_id, start, count, array, errcode)
      if (errcode .ne. 0) stop 2

C     Write char data to file.
      start_1d(1) = 1
      count_1d(1) = char_len
      CALL NCVPTC(ncid, char_id, start_1d, count_1d, char_string,
     &     char_len, errcode)
      if (errcode .ne. 0) stop 2

C     Close the file.
      CALL NCCLOS(ncid, errcode)
      if (errcode .ne. 0) stop 2

C     Reopen the file.
      ncid = NCOPN('tst03_f77_v2.nc', NCNOWRIT, errcode)
      if (errcode .ne. 0) stop 2

      
C     Learn about char array dimension.
      call NCDINQ(NCID, 4, char_dim_name_in, char_dim_size_in, errcode)
      if (errcode .ne. 0) stop 2
      if (char_dim_size_in .ne. char_len) stop 3
      if (char_dim_name_in .ne. 'string_len') stop 4

C     Learn about the char array data.
      call NCVINQ(NCID, 2, char_var_name_in, var_type_in, nvdims_in,
     &     vdims_in, natts_in, errcode)
      if (errcode .ne. 0) stop 2
      if (char_var_name_in .ne. 'Dublin_song') stop 5
      if (var_type_in .ne. NCCHAR) stop 6
      if (nvdims_in .ne. 1) stop 7
      if (vdims_in(1) .ne. 4) stop 8
      if (natts_in .ne. 0) stop 9

C     Read the data in the char array.
      start_1d(1) = 1
      count_1d(1) = char_len
      CALL NCVGTC(ncid, char_id, start_1d, count_1d, char_string_in,
     &     char_len_in, errcode)
      if (errcode .ne. 0) stop 2
      if (char_string_in .ne. 'dirty_old_town') stop 10
      
C     Close the file.
      CALL NCCLOS(ncid, errcode)
      if (errcode .ne. 0) stop 2

      print *, ' *** SUCCESS!'

      END
