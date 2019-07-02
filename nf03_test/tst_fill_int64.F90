!
! This program tests Fortran 90 for adding attribute _FillValue to a variable
! of type NF90_INT64.
!
      subroutine check(err, message)
          use netcdf
          implicit none
          integer err
          character(len=*) message

          ! It is a good idea to check returned value for possible error
          if (err .NE. NF90_NOERR) then
              write(6,*) trim(message), trim(nf90_strerror(err))
              STOP 10
          end if
      end subroutine check

      integer function tst_fmt(filename, cmode)
          use netcdf
          implicit none

          character(LEN=256) filename
          integer i, err
          integer :: ncid, cmode, dimid(1), varid
          integer :: start(1)
          integer :: count(1)
          integer, parameter :: len = 3
          integer, parameter :: k = selected_int_kind(18)
          integer(kind=k) :: fourG, buf(len)

          tst_fmt = 0

          fourG = 1073741824
          fourG = fourG * 4

          do i=1,len
             buf(i) = i
          end do

          ! create netcdf file
          err = nf90_create(filename, IOR(cmode, NF90_CLOBBER), ncid)
          call check(err, 'In nf90_create: ')
          tst_fmt = tst_fmt + err

          err = nf90_def_dim(ncid, "dim", len, dimid(1))
          call check(err, 'In nf90_def_dim: ')
          tst_fmt = tst_fmt + err

          ! Make variable
          err = nf90_def_var(ncid, "var", NF90_INT64, dimid, varid)
          call check(err, 'In nf90_def_var: ')
          tst_fmt = tst_fmt + err

          ! new scalar attribute
          err = nf90_put_att(ncid, varid, 'att', fourG)
          call check(err, 'In nf90_put_att: ')

          ! add scalar attribute "_FillValue"
          err = nf90_put_att(ncid, varid, '_FillValue', fourG)
          call check(err, 'In nf90_put_att: ')
          tst_fmt = tst_fmt + err

          err = nf90_enddef(ncid)
          call check(err, 'In nf90_enddef: ')
          tst_fmt = tst_fmt + err

          ! Write buf
          start(1) = 1
          count(1) = len
          err = nf90_put_var(ncid, varid, buf, start, count)
          call check(err, 'In nf90_put_var: ')
          tst_fmt = tst_fmt + err

          err = nf90_close(ncid)
          call check(err, 'In nf90_close: ')
          tst_fmt = tst_fmt + err

      end function tst_fmt

      program main
          use netcdf
          implicit none
          character(LEN=256) filename
          integer err, nerrs, tst_fmt

          filename = 'tst_fill_int64.nc'

          nerrs = 0

#if defined(USE_NETCDF4) || defined(ENABLE_CDF5)
#ifdef USE_NETCDF4
          err = tst_fmt(filename, NF90_NETCDF4)
          nerrs = nerrs + err
#endif

#ifdef ENABLE_CDF5
          err = tst_fmt(filename, NF90_64BIT_DATA)
          nerrs = nerrs + err
#endif

          if (nerrs .eq. 0) then
              print *, '*** TESTING tst_fill passed'
          else
              print *, '*** TESTING tst_fill failed'
          endif
#else
          print *, '*** TESTING tst_fill skipped'
#endif
      end program main

