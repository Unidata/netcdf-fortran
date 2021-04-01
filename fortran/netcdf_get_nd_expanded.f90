
function nf90_get_var_1D_OneByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_1D_OneByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int8_t), target, dimension(:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_schar(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_schar

    function my_get_varm_schar(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_schar

    function my_get_vars_schar(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_schar

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int8_t), dimension(:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_schar(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_schar(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_schar(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_1D_OneByteInt = cstatus

end function nf90_get_var_1D_OneByteInt

function nf90_get_var_2D_OneByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_2D_OneByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int8_t), target, dimension(:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_schar(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_schar

    function my_get_varm_schar(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_schar

    function my_get_vars_schar(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_schar

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int8_t), dimension(:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_schar(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_schar(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_schar(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_2D_OneByteInt = cstatus

end function nf90_get_var_2D_OneByteInt

function nf90_get_var_3D_OneByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_3D_OneByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int8_t), target, dimension(:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_schar(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_schar

    function my_get_varm_schar(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_schar

    function my_get_vars_schar(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_schar

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int8_t), dimension(:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_schar(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_schar(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_schar(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_3D_OneByteInt = cstatus

end function nf90_get_var_3D_OneByteInt

function nf90_get_var_4D_OneByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_4D_OneByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int8_t), target, dimension(:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_schar(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_schar

    function my_get_varm_schar(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_schar

    function my_get_vars_schar(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_schar

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int8_t), dimension(:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_schar(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_schar(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_schar(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_4D_OneByteInt = cstatus

end function nf90_get_var_4D_OneByteInt

function nf90_get_var_5D_OneByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_5D_OneByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int8_t), target, dimension(:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_schar(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_schar

    function my_get_varm_schar(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_schar

    function my_get_vars_schar(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_schar

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int8_t), dimension(:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_schar(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_schar(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_schar(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_5D_OneByteInt = cstatus

end function nf90_get_var_5D_OneByteInt

function nf90_get_var_6D_OneByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_6D_OneByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int8_t), target, dimension(:,:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_schar(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_schar

    function my_get_varm_schar(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_schar

    function my_get_vars_schar(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_schar

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int8_t), dimension(:,:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_schar(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_schar(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_schar(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_6D_OneByteInt = cstatus

end function nf90_get_var_6D_OneByteInt

function nf90_get_var_7D_OneByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_7D_OneByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int8_t), target, dimension(:,:,:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_schar(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_schar

    function my_get_varm_schar(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_schar

    function my_get_vars_schar(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_schar')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_schar
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_schar

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int8_t), dimension(:,:,:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_schar(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_schar(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_schar(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_7D_OneByteInt = cstatus

end function nf90_get_var_7D_OneByteInt

function nf90_get_var_1D_TwoByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_1D_TwoByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int16_t), target, dimension(:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_short(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_short

    function my_get_varm_short(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_short

    function my_get_vars_short(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_short

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int16_t), dimension(:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_short(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_short(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_short(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_1D_TwoByteInt = cstatus

end function nf90_get_var_1D_TwoByteInt

function nf90_get_var_2D_TwoByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_2D_TwoByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int16_t), target, dimension(:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_short(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_short

    function my_get_varm_short(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_short

    function my_get_vars_short(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_short

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int16_t), dimension(:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_short(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_short(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_short(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_2D_TwoByteInt = cstatus

end function nf90_get_var_2D_TwoByteInt

function nf90_get_var_3D_TwoByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_3D_TwoByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int16_t), target, dimension(:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_short(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_short

    function my_get_varm_short(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_short

    function my_get_vars_short(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_short

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int16_t), dimension(:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_short(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_short(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_short(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_3D_TwoByteInt = cstatus

end function nf90_get_var_3D_TwoByteInt

function nf90_get_var_4D_TwoByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_4D_TwoByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int16_t), target, dimension(:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_short(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_short

    function my_get_varm_short(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_short

    function my_get_vars_short(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_short

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int16_t), dimension(:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_short(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_short(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_short(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_4D_TwoByteInt = cstatus

end function nf90_get_var_4D_TwoByteInt

function nf90_get_var_5D_TwoByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_5D_TwoByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int16_t), target, dimension(:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_short(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_short

    function my_get_varm_short(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_short

    function my_get_vars_short(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_short

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int16_t), dimension(:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_short(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_short(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_short(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_5D_TwoByteInt = cstatus

end function nf90_get_var_5D_TwoByteInt

function nf90_get_var_6D_TwoByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_6D_TwoByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int16_t), target, dimension(:,:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_short(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_short

    function my_get_varm_short(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_short

    function my_get_vars_short(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_short

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int16_t), dimension(:,:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_short(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_short(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_short(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_6D_TwoByteInt = cstatus

end function nf90_get_var_6D_TwoByteInt

function nf90_get_var_7D_TwoByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_7D_TwoByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int16_t), target, dimension(:,:,:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_short(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_short

    function my_get_varm_short(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_short

    function my_get_vars_short(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_short')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_short
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_short

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int16_t), dimension(:,:,:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_short(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_short(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_short(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_7D_TwoByteInt = cstatus

end function nf90_get_var_7D_TwoByteInt

function nf90_get_var_1D_FourByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_1D_FourByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int32_t), target, dimension(:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_int(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_int

    function my_get_varm_int(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_int

    function my_get_vars_int(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_int

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int32_t), dimension(:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_int(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_int(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_int(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_1D_FourByteInt = cstatus

end function nf90_get_var_1D_FourByteInt

function nf90_get_var_2D_FourByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_2D_FourByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int32_t), target, dimension(:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_int(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_int

    function my_get_varm_int(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_int

    function my_get_vars_int(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_int

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int32_t), dimension(:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_int(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_int(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_int(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_2D_FourByteInt = cstatus

end function nf90_get_var_2D_FourByteInt

function nf90_get_var_3D_FourByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_3D_FourByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int32_t), target, dimension(:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_int(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_int

    function my_get_varm_int(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_int

    function my_get_vars_int(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_int

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int32_t), dimension(:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_int(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_int(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_int(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_3D_FourByteInt = cstatus

end function nf90_get_var_3D_FourByteInt

function nf90_get_var_4D_FourByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_4D_FourByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int32_t), target, dimension(:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_int(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_int

    function my_get_varm_int(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_int

    function my_get_vars_int(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_int

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int32_t), dimension(:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_int(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_int(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_int(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_4D_FourByteInt = cstatus

end function nf90_get_var_4D_FourByteInt

function nf90_get_var_5D_FourByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_5D_FourByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int32_t), target, dimension(:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_int(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_int

    function my_get_varm_int(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_int

    function my_get_vars_int(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_int

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int32_t), dimension(:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_int(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_int(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_int(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_5D_FourByteInt = cstatus

end function nf90_get_var_5D_FourByteInt

function nf90_get_var_6D_FourByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_6D_FourByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int32_t), target, dimension(:,:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_int(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_int

    function my_get_varm_int(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_int

    function my_get_vars_int(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_int

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int32_t), dimension(:,:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_int(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_int(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_int(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_6D_FourByteInt = cstatus

end function nf90_get_var_6D_FourByteInt

function nf90_get_var_7D_FourByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_7D_FourByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int32_t), target, dimension(:,:,:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_int(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_int

    function my_get_varm_int(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_int

    function my_get_vars_int(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_int')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_int
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_int

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int32_t), dimension(:,:,:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_int(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_int(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_int(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_7D_FourByteInt = cstatus

end function nf90_get_var_7D_FourByteInt

function nf90_get_var_1D_EightByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_1D_EightByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int64_t), target, dimension(:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_long(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_long

    function my_get_varm_long(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_long

    function my_get_vars_long(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_long

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int64_t), dimension(:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_long(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_long(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_long(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_1D_EightByteInt = cstatus

end function nf90_get_var_1D_EightByteInt

function nf90_get_var_2D_EightByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_2D_EightByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int64_t), target, dimension(:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_long(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_long

    function my_get_varm_long(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_long

    function my_get_vars_long(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_long

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int64_t), dimension(:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_long(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_long(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_long(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_2D_EightByteInt = cstatus

end function nf90_get_var_2D_EightByteInt

function nf90_get_var_3D_EightByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_3D_EightByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int64_t), target, dimension(:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_long(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_long

    function my_get_varm_long(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_long

    function my_get_vars_long(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_long

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int64_t), dimension(:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_long(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_long(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_long(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_3D_EightByteInt = cstatus

end function nf90_get_var_3D_EightByteInt

function nf90_get_var_4D_EightByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_4D_EightByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int64_t), target, dimension(:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_long(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_long

    function my_get_varm_long(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_long

    function my_get_vars_long(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_long

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int64_t), dimension(:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_long(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_long(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_long(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_4D_EightByteInt = cstatus

end function nf90_get_var_4D_EightByteInt

function nf90_get_var_5D_EightByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_5D_EightByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int64_t), target, dimension(:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_long(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_long

    function my_get_varm_long(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_long

    function my_get_vars_long(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_long

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int64_t), dimension(:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_long(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_long(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_long(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_5D_EightByteInt = cstatus

end function nf90_get_var_5D_EightByteInt

function nf90_get_var_6D_EightByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_6D_EightByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int64_t), target, dimension(:,:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_long(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_long

    function my_get_varm_long(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_long

    function my_get_vars_long(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_long

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int64_t), dimension(:,:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_long(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_long(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_long(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_6D_EightByteInt = cstatus

end function nf90_get_var_6D_EightByteInt

function nf90_get_var_7D_EightByteInt(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_7D_EightByteInt

  integer, intent(in) :: ncid, varid
  integer(c_int64_t), target, dimension(:,:,:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_long(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_long

    function my_get_varm_long(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_long

    function my_get_vars_long(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_long')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_long
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_long

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  integer(c_int64_t), dimension(:,:,:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_long(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_long(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_long(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_7D_EightByteInt = cstatus

end function nf90_get_var_7D_EightByteInt

function nf90_get_var_1D_FourByteReal(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_1D_FourByteReal

  integer, intent(in) :: ncid, varid
  real(c_float), target, dimension(:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_float(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_float

    function my_get_varm_float(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_float

    function my_get_vars_float(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_float

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  real(c_float), dimension(:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_float(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_float(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_float(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_1D_FourByteReal = cstatus

end function nf90_get_var_1D_FourByteReal

function nf90_get_var_2D_FourByteReal(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_2D_FourByteReal

  integer, intent(in) :: ncid, varid
  real(c_float), target, dimension(:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_float(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_float

    function my_get_varm_float(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_float

    function my_get_vars_float(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_float

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  real(c_float), dimension(:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_float(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_float(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_float(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_2D_FourByteReal = cstatus

end function nf90_get_var_2D_FourByteReal

function nf90_get_var_3D_FourByteReal(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_3D_FourByteReal

  integer, intent(in) :: ncid, varid
  real(c_float), target, dimension(:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_float(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_float

    function my_get_varm_float(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_float

    function my_get_vars_float(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_float

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  real(c_float), dimension(:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_float(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_float(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_float(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_3D_FourByteReal = cstatus

end function nf90_get_var_3D_FourByteReal

function nf90_get_var_4D_FourByteReal(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_4D_FourByteReal

  integer, intent(in) :: ncid, varid
  real(c_float), target, dimension(:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_float(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_float

    function my_get_varm_float(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_float

    function my_get_vars_float(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_float

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  real(c_float), dimension(:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_float(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_float(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_float(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_4D_FourByteReal = cstatus

end function nf90_get_var_4D_FourByteReal

function nf90_get_var_5D_FourByteReal(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_5D_FourByteReal

  integer, intent(in) :: ncid, varid
  real(c_float), target, dimension(:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_float(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_float

    function my_get_varm_float(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_float

    function my_get_vars_float(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_float

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  real(c_float), dimension(:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_float(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_float(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_float(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_5D_FourByteReal = cstatus

end function nf90_get_var_5D_FourByteReal

function nf90_get_var_6D_FourByteReal(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_6D_FourByteReal

  integer, intent(in) :: ncid, varid
  real(c_float), target, dimension(:,:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_float(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_float

    function my_get_varm_float(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_float

    function my_get_vars_float(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_float

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  real(c_float), dimension(:,:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_float(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_float(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_float(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_6D_FourByteReal = cstatus

end function nf90_get_var_6D_FourByteReal

function nf90_get_var_7D_FourByteReal(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_7D_FourByteReal

  integer, intent(in) :: ncid, varid
  real(c_float), target, dimension(:,:,:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_float(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_float

    function my_get_varm_float(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_float

    function my_get_vars_float(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_float')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_float
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_float

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  real(c_float), dimension(:,:,:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_float(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_float(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_float(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_7D_FourByteReal = cstatus

end function nf90_get_var_7D_FourByteReal

function nf90_get_var_1D_EightByteReal(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_1D_EightByteReal

  integer, intent(in) :: ncid, varid
  real(c_double), target, dimension(:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_double(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_double

    function my_get_varm_double(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_double

    function my_get_vars_double(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_double

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  real(c_double), dimension(:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_double(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_double(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_double(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_1D_EightByteReal = cstatus

end function nf90_get_var_1D_EightByteReal

function nf90_get_var_2D_EightByteReal(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_2D_EightByteReal

  integer, intent(in) :: ncid, varid
  real(c_double), target, dimension(:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_double(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_double

    function my_get_varm_double(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_double

    function my_get_vars_double(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_double

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  real(c_double), dimension(:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_double(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_double(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_double(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_2D_EightByteReal = cstatus

end function nf90_get_var_2D_EightByteReal

function nf90_get_var_3D_EightByteReal(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_3D_EightByteReal

  integer, intent(in) :: ncid, varid
  real(c_double), target, dimension(:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_double(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_double

    function my_get_varm_double(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_double

    function my_get_vars_double(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_double

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  real(c_double), dimension(:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_double(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_double(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_double(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_3D_EightByteReal = cstatus

end function nf90_get_var_3D_EightByteReal

function nf90_get_var_4D_EightByteReal(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_4D_EightByteReal

  integer, intent(in) :: ncid, varid
  real(c_double), target, dimension(:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_double(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_double

    function my_get_varm_double(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_double

    function my_get_vars_double(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_double

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  real(c_double), dimension(:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_double(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_double(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_double(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_4D_EightByteReal = cstatus

end function nf90_get_var_4D_EightByteReal

function nf90_get_var_5D_EightByteReal(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_5D_EightByteReal

  integer, intent(in) :: ncid, varid
  real(c_double), target, dimension(:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_double(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_double

    function my_get_varm_double(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_double

    function my_get_vars_double(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_double

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  real(c_double), dimension(:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_double(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_double(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_double(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_5D_EightByteReal = cstatus

end function nf90_get_var_5D_EightByteReal

function nf90_get_var_6D_EightByteReal(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_6D_EightByteReal

  integer, intent(in) :: ncid, varid
  real(c_double), target, dimension(:,:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_double(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_double

    function my_get_varm_double(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_double

    function my_get_vars_double(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_double

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  real(c_double), dimension(:,:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_double(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_double(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_double(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_6D_EightByteReal = cstatus

end function nf90_get_var_6D_EightByteReal

function nf90_get_var_7D_EightByteReal(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: nf90_get_var_7D_EightByteReal

  integer, intent(in) :: ncid, varid
  real(c_double), target, dimension(:,:,:,:,:,:,:), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_double(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_double

    function my_get_varm_double(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_double

    function my_get_vars_double(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_double')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_double
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_double

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  real(c_double), dimension(:,:,:,:,:,:,:), pointer :: farrayp
  type(c_ptr) :: carrayp

  integer(c_size_t), target, dimension(7) :: localStart, localCount
  integer(c_ptrdiff_t), target, dimension(7) :: localStride, localMap

  type(c_ptr) :: startp, countp, stridep, mapp

  integer :: numDims, numSize, numSizeP1, counter

  integer(c_size_t) :: totalLocalCount
  integer :: i, j
  integer(c_size_t) :: t1
  integer(c_ptrdiff_t) :: t2

  cstatus = 0

  cncid  = ncid
  cvarid = varid - 1 ! subtract 1 to get c varid

  ! Set local arguments to default values
  numDims = size(shape(values))
  if (present(start)) numDims = size(start)
  localStart(:) = 0
  localCount(:numDims) = shape(values)
  localCount(numDims+1:) = 1
  localStride(:) = 1

  totalLocalCount = 1
  do counter = 1, numDims
    localMap(counter) = totalLocalCount
    if (counter == numDims) exit
    totalLocalCount = totalLocalCount * localCount(counter)
  enddo

  if (present(start))  localStart (:numDims) = start(:)-1
  if (present(count))  localCount (:numDims) = count(:)
  if (present(stride)) localStride(:numDims) = stride(:)
  if (present(map))    localMap(:numDims) = map(:)

  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localStart(i)
    localStart(i) = localStart(j)
    localStart(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t1 = localCount(i)
    localCount(i) = localCount(j)
    localCount(j) = t1
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localStride(i)
    localStride(i) = localStride(j)
    localStride(j) = t2
  enddo
  do i = 1, numDims/2
    j = numDims - i + 1
    t2 = localMap(i)
    localMap(i) = localmap(j)
    localMap(j) = t2
  enddo

  farrayp => values
  carrayp = c_loc(farrayp) 

  startp = c_loc(localStart)
  countp = c_loc(localCount)

  if (present(stride)) then
    stridep = c_loc(localStride)
    if (present(map)) then
      mapp = c_loc(localMap)
      cstatus = my_get_varm_double(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_double(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_double(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  nf90_get_var_7D_EightByteReal = cstatus

end function nf90_get_var_7D_EightByteReal
