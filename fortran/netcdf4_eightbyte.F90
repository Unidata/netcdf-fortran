function nf90_put_var_1D_EightByteInt(ncid, varid, values, start, count, stride, map)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), dimension(:), intent( in) :: values
  integer, dimension(:), optional, intent( in) :: start, count, stride, map
  integer                                      :: nf90_put_var_1D_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localStart, localCount, localStride, localMap
  integer                               :: numDims, counter, format_num

  ! Set local arguments to default values
  numDims                 = size(shape(values))
  localStart (:         ) = 1
  localCount (:numDims  ) = shape(values)
  localCount (numDims+1:) = 1
  localStride(:         ) = 1
  localMap   (:numDims  ) = (/ 1, (product(localCount(:counter)), counter = 1, numDims - 1) /)

  if(present(start))  localStart (:size(start) )  = start(:)
  if(present(count))  localCount (:size(count) )  = count(:)
  if(present(stride)) localStride(:size(stride)) = stride(:)
  nf90_put_var_1D_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_put_var_1D_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_put_var_1D_EightByteInt = &
                nf_put_varm_int64(ncid, varid, localStart, localCount, localStride, localMap, values)
        else if(present(stride)) then
           nf90_put_var_1D_EightByteInt = &
                nf_put_vars_int64(ncid, varid, localStart, localCount, localStride, values)
        else
           nf90_put_var_1D_EightByteInt = &
                nf_put_vara_int64(ncid, varid, localStart, localCount, values)
        end if
     else
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_put_var_1D_EightByteInt = &
                nf_put_varm_int(ncid, varid, localStart, localCount, localStride, localMap, int(values))
        else if(present(stride)) then
           nf90_put_var_1D_EightByteInt = &
                nf_put_vars_int(ncid, varid, localStart, localCount, localStride, int(values))
        else
           nf90_put_var_1D_EightByteInt = &
                nf_put_vara_int(ncid, varid, localStart, localCount, int(values))
        end if
     endif
  endif
end function nf90_put_var_1D_EightByteInt

function nf90_put_var_2D_EightByteInt(ncid, varid, values, start, count, stride, map)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), dimension(:, :), &
       intent( in) :: values
  integer, dimension(:), optional, intent( in) :: start, count, stride, map
  integer                                      :: nf90_put_var_2D_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localStart, localCount, localStride, localMap
  integer                               :: numDims, counter, format_num

  ! Set local arguments to default values
  numDims                 = size(shape(values))
  localStart (:         ) = 1
  localCount (:numDims  ) = shape(values)
  localCount (numDims+1:) = 1
  localStride(:         ) = 1
  localMap   (:numDims  ) = (/ 1, (product(localCount(:counter)), counter = 1, numDims - 1) /)

  if(present(start))  localStart (:size(start) )  = start(:)
  if(present(count))  localCount (:size(count) )  = count(:)
  if(present(stride)) localStride(:size(stride)) = stride(:)
  nf90_put_var_2D_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_put_var_2D_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_put_var_2D_EightByteInt = &
                nf_put_varm_int64(ncid, varid, localStart, localCount, localStride, localMap, values)
        else if(present(stride)) then
           nf90_put_var_2D_EightByteInt = &
                nf_put_vars_int64(ncid, varid, localStart, localCount, localStride, values)
        else
           nf90_put_var_2D_EightByteInt = &
                nf_put_vara_int64(ncid, varid, localStart, localCount, values)
        end if
     else
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_put_var_2D_EightByteInt = &
                nf_put_varm_int(ncid, varid, localStart, localCount, localStride, localMap, int(values))
        else if(present(stride)) then
           nf90_put_var_2D_EightByteInt = &
                nf_put_vars_int(ncid, varid, localStart, localCount, localStride, int(values))
        else
           nf90_put_var_2D_EightByteInt = &
                nf_put_vara_int(ncid, varid, localStart, localCount, int(values))
        end if
     endif
  endif

end function nf90_put_var_2D_EightByteInt


function nf90_put_var_3D_EightByteInt(ncid, varid, values, start, count, stride, map)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), dimension(:, :, :), &
       intent( in) :: values
  integer, dimension(:), optional, intent( in) :: start, count, stride, map
  integer                                      :: nf90_put_var_3D_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localStart, localCount, localStride, localMap
  integer                               :: numDims, counter, format_num

  ! Set local arguments to default values
  numDims                 = size(shape(values))
  localStart (:         ) = 1
  localCount (:numDims  ) = shape(values)
  localCount (numDims+1:) = 1
  localStride(:         ) = 1
  localMap   (:numDims  ) = (/ 1, (product(localCount(:counter)), counter = 1, numDims - 1) /)

  if(present(start))  localStart (:size(start) )  = start(:)
  if(present(count))  localCount (:size(count) )  = count(:)
  if(present(stride)) localStride(:size(stride)) = stride(:)
  nf90_put_var_3D_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_put_var_3D_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_put_var_3D_EightByteInt = &
                nf_put_varm_int64(ncid, varid, localStart, localCount, localStride, localMap, values)
        else if(present(stride)) then
           nf90_put_var_3D_EightByteInt = &
                nf_put_vars_int64(ncid, varid, localStart, localCount, localStride, values)
        else
           nf90_put_var_3D_EightByteInt = &
                nf_put_vara_int64(ncid, varid, localStart, localCount, values)
        end if
     else
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_put_var_3D_EightByteInt = &
                nf_put_varm_int(ncid, varid, localStart, localCount, localStride, localMap, int(values))
        else if(present(stride)) then
           nf90_put_var_3D_EightByteInt = &
                nf_put_vars_int(ncid, varid, localStart, localCount, localStride, int(values))
        else
           nf90_put_var_3D_EightByteInt = &
                nf_put_vara_int(ncid, varid, localStart, localCount, int(values))
        end if
     endif
  endif
end function nf90_put_var_3D_EightByteInt


function nf90_put_var_4D_EightByteInt(ncid, varid, values, start, count, stride, map)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), dimension(:, :, :, :), &
       intent( in) :: values
  integer, dimension(:), optional, intent( in) :: start, count, stride, map
  integer                                      :: nf90_put_var_4D_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localStart, localCount, localStride, localMap
  integer                               :: numDims, counter, format_num

  ! Set local arguments to default values
  numDims                 = size(shape(values))
  localStart (:         ) = 1
  localCount (:numDims  ) = shape(values)
  localCount (numDims+1:) = 1
  localStride(:         ) = 1
  localMap   (:numDims  ) = (/ 1, (product(localCount(:counter)), counter = 1, numDims - 1) /)

  if(present(start))  localStart (:size(start) )  = start(:)
  if(present(count))  localCount (:size(count) )  = count(:)
  if(present(stride)) localStride(:size(stride)) = stride(:)
  nf90_put_var_4D_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_put_var_4D_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_put_var_4D_EightByteInt = &
                nf_put_varm_int64(ncid, varid, localStart, localCount, localStride, localMap, values)
        else if(present(stride)) then
           nf90_put_var_4D_EightByteInt = &
                nf_put_vars_int64(ncid, varid, localStart, localCount, localStride, values)
        else
           nf90_put_var_4D_EightByteInt = &
                nf_put_vara_int64(ncid, varid, localStart, localCount, values)
        end if
     else
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_put_var_4D_EightByteInt = &
                nf_put_varm_int(ncid, varid, localStart, localCount, localStride, localMap, int(values))
        else if(present(stride)) then
           nf90_put_var_4D_EightByteInt = &
                nf_put_vars_int(ncid, varid, localStart, localCount, localStride, int(values))
        else
           nf90_put_var_4D_EightByteInt = &
                nf_put_vara_int(ncid, varid, localStart, localCount, int(values))
        end if
     end if
  end if
end function nf90_put_var_4D_EightByteInt


function nf90_put_var_5D_EightByteInt(ncid, varid, values, start, count, stride, map)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), dimension(:, :, :, :, :), &
       intent( in) :: values
  integer, dimension(:), optional, intent( in) :: start, count, stride, map
  integer                                      :: nf90_put_var_5D_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localStart, localCount, localStride, localMap
  integer                               :: numDims, counter, format_num

  ! Set local arguments to default values
  numDims                 = size(shape(values))
  localStart (:         ) = 1
  localCount (:numDims  ) = shape(values)
  localCount (numDims+1:) = 1
  localStride(:         ) = 1
  localMap   (:numDims  ) = (/ 1, (product(localCount(:counter)), counter = 1, numDims - 1) /)

  if(present(start))  localStart (:size(start) )  = start(:)
  if(present(count))  localCount (:size(count) )  = count(:)
  if(present(stride)) localStride(:size(stride)) = stride(:)
  nf90_put_var_5D_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_put_var_5D_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_put_var_5D_EightByteInt = &
                nf_put_varm_int64(ncid, varid, localStart, localCount, localStride, localMap, values)
        else if(present(stride)) then
           nf90_put_var_5D_EightByteInt = &
                nf_put_vars_int64(ncid, varid, localStart, localCount, localStride, values)
        else
           nf90_put_var_5D_EightByteInt = &
                nf_put_vara_int64(ncid, varid, localStart, localCount, values)
        end if
     else
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_put_var_5D_EightByteInt = &
                nf_put_varm_int(ncid, varid, localStart, localCount, localStride, localMap, int(values))
        else if(present(stride)) then
           nf90_put_var_5D_EightByteInt = &
                nf_put_vars_int(ncid, varid, localStart, localCount, localStride, int(values))
        else
           nf90_put_var_5D_EightByteInt = &
                nf_put_vara_int(ncid, varid, localStart, localCount, int(values))
        end if
     end if
  end if
end function nf90_put_var_5D_EightByteInt


function nf90_put_var_6D_EightByteInt(ncid, varid, values, start, count, stride, map)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), dimension(:, :, :, :, :, :), &
       intent( in) :: values
  integer, dimension(:), optional, intent( in) :: start, count, stride, map
  integer                                      :: nf90_put_var_6D_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localStart, localCount, localStride, localMap
  integer                               :: numDims, counter, format_num

  ! Set local arguments to default values
  numDims                 = size(shape(values))
  localStart (:         ) = 1
  localCount (:numDims  ) = shape(values)
  localCount (numDims+1:) = 1
  localStride(:         ) = 1
  localMap   (:numDims  ) = (/ 1, (product(localCount(:counter)), counter = 1, numDims - 1) /)

  if(present(start))  localStart (:size(start) )  = start(:)
  if(present(count))  localCount (:size(count) )  = count(:)
  if(present(stride)) localStride(:size(stride)) = stride(:)
  nf90_put_var_6D_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_put_var_6D_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_put_var_6D_EightByteInt = &
                nf_put_varm_int64(ncid, varid, localStart, localCount, localStride, localMap, values)
        else if(present(stride)) then
           nf90_put_var_6D_EightByteInt = &
                nf_put_vars_int64(ncid, varid, localStart, localCount, localStride, values)
        else
           nf90_put_var_6D_EightByteInt = &
                nf_put_vara_int64(ncid, varid, localStart, localCount, values)
        end if
     else
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_put_var_6D_EightByteInt = &
                nf_put_varm_int(ncid, varid, localStart, localCount, localStride, localMap, int(values))
        else if(present(stride)) then
           nf90_put_var_6D_EightByteInt = &
                nf_put_vars_int(ncid, varid, localStart, localCount, localStride, int(values))
        else
           nf90_put_var_6D_EightByteInt = &
                nf_put_vara_int(ncid, varid, localStart, localCount, int(values))
        end if
     end if
  end if
end function nf90_put_var_6D_EightByteInt


function nf90_put_var_7D_EightByteInt(ncid, varid, values, start, count, stride, map)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), dimension(:, :, :, :, :, :, :), &
       intent( in) :: values
  integer, dimension(:), optional, intent( in) :: start, count, stride, map
  integer                                      :: nf90_put_var_7D_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localStart, localCount, localStride, localMap
  integer                               :: numDims, counter, format_num

  ! Set local arguments to default values
  numDims                 = size(shape(values))
  localStart (:         ) = 1
  localCount (:numDims  ) = shape(values)
  localCount (numDims+1:) = 1
  localStride(:         ) = 1
  localMap   (:numDims  ) = (/ 1, (product(localCount(:counter)), counter = 1, numDims - 1) /)

  if(present(start))  localStart (:size(start) )  = start(:)
  if(present(count))  localCount (:size(count) )  = count(:)
  if(present(stride)) localStride(:size(stride)) = stride(:)
  nf90_put_var_7D_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_put_var_7D_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_put_var_7D_EightByteInt = &
                nf_put_varm_int64(ncid, varid, localStart, localCount, localStride, localMap, values)
        else if(present(stride)) then
           nf90_put_var_7D_EightByteInt = &
                nf_put_vars_int64(ncid, varid, localStart, localCount, localStride, values)
        else
           nf90_put_var_7D_EightByteInt = &
                nf_put_vara_int64(ncid, varid, localStart, localCount, values)
        end if
     else
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_put_var_7D_EightByteInt = &
                nf_put_varm_int(ncid, varid, localStart, localCount, localStride, localMap, int(values))
        else if(present(stride)) then
           nf90_put_var_7D_EightByteInt = &
                nf_put_vars_int(ncid, varid, localStart, localCount, localStride, int(values))
        else
           nf90_put_var_7D_EightByteInt = &
                nf_put_vara_int(ncid, varid, localStart, localCount, int(values))
        end if
     end if
  end if
end function nf90_put_var_7D_EightByteInt


function nf90_get_var_1D_EightByteInt(ncid, varid, values, start, count, stride, map)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), dimension(:), &
       intent(out) :: values
  integer, dimension(:), optional, intent( in) :: start, count, stride, map
  integer                                      :: nf90_get_var_1D_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localStart, localCount, localStride, localMap
  integer                               :: numDims, counter, format_num, shapeValues(1)
  integer, dimension(:), allocatable    :: defaultIntArray
  integer (kind = EightByteInt), dimension(:), allocatable :: defaultInt8Array

  ! Set local arguments to default values
  shapeValues             = shape(values)
  numDims                 = size(shapeValues)
  localStart (:         ) = 1
  localCount (:numDims  ) = shapeValues
  localCount (numDims+1:) = 1
  localStride(:         ) = 1
  localMap   (:numDims  ) = (/ 1, (product(localCount(:counter)), counter = 1, numDims - 1) /)

  if(present(start))  localStart (:size(start) )  = start(:)
  if(present(count))  localCount (:size(count) )  = count(:)
  if(present(stride)) localStride(:size(stride)) = stride(:)
  nf90_get_var_1D_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_get_var_1D_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        allocate(defaultInt8Array(size(values)))
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_get_var_1D_EightByteInt = &
                nf_get_varm_int64(ncid, varid, localStart, localCount, localStride, localMap, defaultInt8Array)
        else if(present(stride)) then
           nf90_get_var_1D_EightByteInt = &
                nf_get_vars_int64(ncid, varid, localStart, localCount, localStride, defaultInt8Array)
        else
           nf90_get_var_1D_EightByteInt = &
                nf_get_vara_int64(ncid, varid, localStart, localCount, defaultInt8Array)
        end if
        values(:) = reshape(defaultInt8Array(:), shapeValues)
        if (allocated(defaultInt8Array)) deallocate(defaultInt8Array)
     else
        allocate(defaultIntArray(size(values)))
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_get_var_1D_EightByteInt = &
                nf_get_varm_int(ncid, varid, localStart, localCount, localStride, localMap, defaultIntArray)
        else if(present(stride)) then
           nf90_get_var_1D_EightByteInt = &
                nf_get_vars_int(ncid, varid, localStart, localCount, localStride, defaultIntArray)
        else
           nf90_get_var_1D_EightByteInt = &
                nf_get_vara_int(ncid, varid, localStart, localCount, defaultIntArray)
        end if
        values(:) = reshape(defaultIntArray(:), shapeValues)
        if (allocated(defaultIntArray)) deallocate(defaultIntArray)
     endif
  endif
end function nf90_get_var_1D_EightByteInt


function nf90_get_var_2D_EightByteInt(ncid, varid, values, start, count, stride, map)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), dimension(:, :), &
       intent(out) :: values
  integer, dimension(:), optional, intent( in) :: start, count, stride, map
  integer                                      :: nf90_get_var_2D_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localStart, localCount, localStride, localMap
  integer                               :: numDims, counter, format_num, shapeValues(2)
  integer, dimension(:), allocatable    :: defaultIntArray
  integer (kind = EightByteInt), dimension(:), allocatable :: defaultInt8Array

  ! Set local arguments to default values
  shapeValues             = shape(values)
  numDims                 = size(shapeValues)
  localStart (:         ) = 1
  localCount (:numDims  ) = shapeValues
  localCount (numDims+1:) = 1
  localStride(:         ) = 1
  localMap   (:numDims  ) = (/ 1, (product(localCount(:counter)), counter = 1, numDims - 1) /)

  if(present(start))  localStart (:size(start) )  = start(:)
  if(present(count))  localCount (:size(count) )  = count(:)
  if(present(stride)) localStride(:size(stride)) = stride(:)
  nf90_get_var_2D_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_get_var_2D_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        allocate(defaultInt8Array(size(values)))
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_get_var_2D_EightByteInt = &
                nf_get_varm_int64(ncid, varid, localStart, localCount, localStride, localMap, defaultInt8Array)
        else if(present(stride)) then
           nf90_get_var_2D_EightByteInt = &
                nf_get_vars_int64(ncid, varid, localStart, localCount, localStride, defaultInt8Array)
        else
           nf90_get_var_2D_EightByteInt = &
                nf_get_vara_int64(ncid, varid, localStart, localCount, defaultInt8Array)
        end if
        values(:, :) = reshape(defaultInt8Array(:), shapeValues)
        if (allocated(defaultInt8Array)) deallocate(defaultInt8Array)
     else
        allocate(defaultIntArray(size(values)))
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_get_var_2D_EightByteInt = &
                nf_get_varm_int(ncid, varid, localStart, localCount, localStride, localMap, defaultIntArray)
        else if(present(stride)) then
           nf90_get_var_2D_EightByteInt = &
                nf_get_vars_int(ncid, varid, localStart, localCount, localStride, defaultIntArray)
        else
           nf90_get_var_2D_EightByteInt = &
                nf_get_vara_int(ncid, varid, localStart, localCount, defaultIntArray)
        end if
        values(:, :) = reshape(defaultIntArray(:), shapeValues)
        if (allocated(defaultIntArray)) deallocate(defaultIntArray)
     end if
  end if
end function nf90_get_var_2D_EightByteInt


function nf90_get_var_3D_EightByteInt(ncid, varid, values, start, count, stride, map)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), dimension(:, :, :), &
       intent(out) :: values
  integer, dimension(:), optional, intent( in) :: start, count, stride, map
  integer                                      :: nf90_get_var_3D_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localStart, localCount, localStride, localMap
  integer                               :: numDims, counter, format_num, shapeValues(3)
  integer, dimension(:), allocatable    :: defaultIntArray
  integer (kind = EightByteInt), dimension(:), allocatable :: defaultInt8Array

  ! Set local arguments to default values
  shapeValues             = shape(values)
  numDims                 = size(shapeValues)
  localStart (:         ) = 1
  localCount (:numDims  ) = shapeValues
  localCount (numDims+1:) = 1
  localStride(:         ) = 1
  localMap   (:numDims  ) = (/ 1, (product(localCount(:counter)), counter = 1, numDims - 1) /)

  if(present(start))  localStart (:size(start) )  = start(:)
  if(present(count))  localCount (:size(count) )  = count(:)
  if(present(stride)) localStride(:size(stride)) = stride(:)
  nf90_get_var_3D_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_get_var_3D_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        allocate(defaultInt8Array(size(values)))
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_get_var_3D_EightByteInt = &
                nf_get_varm_int64(ncid, varid, localStart, localCount, localStride, localMap, defaultInt8Array)
        else if(present(stride)) then
           nf90_get_var_3D_EightByteInt = &
                nf_get_vars_int64(ncid, varid, localStart, localCount, localStride, defaultInt8Array)
        else
           nf90_get_var_3D_EightByteInt = &
                nf_get_vara_int64(ncid, varid, localStart, localCount, defaultInt8Array)
        end if
        values(:, :, :) = reshape(defaultInt8Array(:), shapeValues)
        if (allocated(defaultInt8Array)) deallocate(defaultInt8Array)
     else
        allocate(defaultIntArray(size(values)))
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_get_var_3D_EightByteInt = &
                nf_get_varm_int(ncid, varid, localStart, localCount, localStride, localMap, defaultIntArray)
        else if(present(stride)) then
           nf90_get_var_3D_EightByteInt = &
                nf_get_vars_int(ncid, varid, localStart, localCount, localStride, defaultIntArray)
        else
           nf90_get_var_3D_EightByteInt = &
                nf_get_vara_int(ncid, varid, localStart, localCount, defaultIntArray)
        end if
        values(:, :, :) = reshape(defaultIntArray(:), shapeValues)
        if (allocated(defaultIntArray)) deallocate(defaultIntArray)
     end if
  end if
end function nf90_get_var_3D_EightByteInt


function nf90_get_var_4D_EightByteInt(ncid, varid, values, start, count, stride, map)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), dimension(:, :, :, :), &
       intent(out) :: values
  integer, dimension(:), optional, intent( in) :: start, count, stride, map
  integer                                      :: nf90_get_var_4D_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localStart, localCount, localStride, localMap
  integer                               :: numDims, counter, format_num, shapeValues(4)
  integer, dimension(:), allocatable    :: defaultIntArray
  integer (kind = EightByteInt), dimension(:), allocatable :: defaultInt8Array

  ! Set local arguments to default values
  shapeValues             = shape(values)
  numDims                 = size(shapeValues)
  localStart (:         ) = 1
  localCount (:numDims  ) = shapeValues
  localCount (numDims+1:) = 1
  localStride(:         ) = 1
  localMap   (:numDims  ) = (/ 1, (product(localCount(:counter)), counter = 1, numDims - 1) /)

  if(present(start))  localStart (:size(start) )  = start(:)
  if(present(count))  localCount (:size(count) )  = count(:)
  if(present(stride)) localStride(:size(stride)) = stride(:)
  nf90_get_var_4D_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_get_var_4D_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        allocate(defaultInt8Array(size(values)))
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_get_var_4D_EightByteInt = &
                nf_get_varm_int64(ncid, varid, localStart, localCount, localStride, localMap, defaultInt8Array)
        else if(present(stride)) then
           nf90_get_var_4D_EightByteInt = &
                nf_get_vars_int64(ncid, varid, localStart, localCount, localStride, defaultInt8Array)
        else
           nf90_get_var_4D_EightByteInt = &
                nf_get_vara_int64(ncid, varid, localStart, localCount, defaultInt8Array)
        end if
        values(:, :, :, :) = reshape(defaultInt8Array(:), shapeValues)
        if (allocated(defaultInt8Array)) deallocate(defaultInt8Array)
     else
        allocate(defaultIntArray(size(values)))
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_get_var_4D_EightByteInt = &
                nf_get_varm_int(ncid, varid, localStart, localCount, localStride, localMap, defaultIntArray)
        else if(present(stride)) then
           nf90_get_var_4D_EightByteInt = &
                nf_get_vars_int(ncid, varid, localStart, localCount, localStride, defaultIntArray)
        else
           nf90_get_var_4D_EightByteInt = &
                nf_get_vara_int(ncid, varid, localStart, localCount, defaultIntArray)
        end if
        values(:, :, :, :) = reshape(defaultIntArray(:), shapeValues)
        if (allocated(defaultIntArray)) deallocate(defaultIntArray)
     end if
  end if
end function nf90_get_var_4D_EightByteInt


function nf90_get_var_5D_EightByteInt(ncid, varid, values, start, count, stride, map)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), dimension(:, :, :, :, :), &
       intent(out) :: values
  integer, dimension(:), optional, intent( in) :: start, count, stride, map
  integer                                      :: nf90_get_var_5D_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localStart, localCount, localStride, localMap
  integer                               :: numDims, counter, format_num, shapeValues(5)
  integer, dimension(:), allocatable    :: defaultIntArray
  integer (kind = EightByteInt), dimension(:), allocatable :: defaultInt8Array

  ! Set local arguments to default values
  shapeValues             = shape(values)
  numDims                 = size(shapeValues)
  localStart (:         ) = 1
  localCount (:numDims  ) = shapeValues
  localCount (numDims+1:) = 1
  localStride(:         ) = 1
  localMap   (:numDims  ) = (/ 1, (product(localCount(:counter)), counter = 1, numDims - 1) /)

  if(present(start))  localStart (:size(start) )  = start(:)
  if(present(count))  localCount (:size(count) )  = count(:)
  if(present(stride)) localStride(:size(stride)) = stride(:)
  nf90_get_var_5D_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_get_var_5D_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        allocate(defaultInt8Array(size(values)))
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_get_var_5D_EightByteInt = &
                nf_get_varm_int64(ncid, varid, localStart, localCount, localStride, localMap, defaultInt8Array)
        else if(present(stride)) then
           nf90_get_var_5D_EightByteInt = &
                nf_get_vars_int64(ncid, varid, localStart, localCount, localStride, defaultInt8Array)
        else
           nf90_get_var_5D_EightByteInt = &
                nf_get_vara_int64(ncid, varid, localStart, localCount, defaultInt8Array)
        end if
        values(:, :, :, :, :) = reshape(defaultInt8Array(:), shapeValues)
        if (allocated(defaultInt8Array)) deallocate(defaultInt8Array)
     else
        allocate(defaultIntArray(size(values)))
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_get_var_5D_EightByteInt = &
                nf_get_varm_int(ncid, varid, localStart, localCount, localStride, localMap, defaultIntArray)
        else if(present(stride)) then
           nf90_get_var_5D_EightByteInt = &
                nf_get_vars_int(ncid, varid, localStart, localCount, localStride, defaultIntArray)
        else
           nf90_get_var_5D_EightByteInt = &
                nf_get_vara_int(ncid, varid, localStart, localCount, defaultIntArray)
        end if
        values(:, :, :, :, :) = reshape(defaultIntArray(:), shapeValues)
        if (allocated(defaultIntArray)) deallocate(defaultIntArray)
     end if
  end if
end function nf90_get_var_5D_EightByteInt


function nf90_get_var_6D_EightByteInt(ncid, varid, values, start, count, stride, map)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), dimension(:, :, :, :, :, :), &
       intent(out) :: values
  integer, dimension(:), optional, intent( in) :: start, count, stride, map
  integer                                      :: nf90_get_var_6D_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localStart, localCount, localStride, localMap
  integer                               :: numDims, counter, format_num, shapeValues(6)
  integer, dimension(:), allocatable    :: defaultIntArray
  integer (kind = EightByteInt), dimension(:), allocatable :: defaultInt8Array

  ! Set local arguments to default values
  shapeValues             = shape(values)
  numDims                 = size(shapeValues)
  localStart (:         ) = 1
  localCount (:numDims  ) = shapeValues
  localCount (numDims+1:) = 1
  localStride(:         ) = 1
  localMap   (:numDims  ) = (/ 1, (product(localCount(:counter)), counter = 1, numDims - 1) /)

  if(present(start))  localStart (:size(start) )  = start(:)
  if(present(count))  localCount (:size(count) )  = count(:)
  if(present(stride)) localStride(:size(stride)) = stride(:)
  nf90_get_var_6D_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_get_var_6D_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        allocate(defaultInt8Array(size(values)))
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_get_var_6D_EightByteInt = &
                nf_get_varm_int64(ncid, varid, localStart, localCount, localStride, localMap, defaultInt8Array)
        else if(present(stride)) then
           nf90_get_var_6D_EightByteInt = &
                nf_get_vars_int64(ncid, varid, localStart, localCount, localStride, defaultInt8Array)
        else
           nf90_get_var_6D_EightByteInt = &
                nf_get_vara_int64(ncid, varid, localStart, localCount, defaultInt8Array)
        end if
        values(:, :, :, :, :, :) = reshape(defaultInt8Array(:), shapeValues)
        if (allocated(defaultInt8Array)) deallocate(defaultInt8Array)
     else
        allocate(defaultIntArray(size(values)))
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_get_var_6D_EightByteInt = &
                nf_get_varm_int(ncid, varid, localStart, localCount, localStride, localMap, defaultIntArray)
        else if(present(stride)) then
           nf90_get_var_6D_EightByteInt = &
                nf_get_vars_int(ncid, varid, localStart, localCount, localStride, defaultIntArray)
        else
           nf90_get_var_6D_EightByteInt = &
                nf_get_vara_int(ncid, varid, localStart, localCount, defaultIntArray)
        end if
        values(:, :, :, :, :, :) = reshape(defaultIntArray(:), shapeValues)
        if (allocated(defaultIntArray)) deallocate(defaultIntArray)
     end if
  end if
end function nf90_get_var_6D_EightByteInt


function nf90_get_var_7D_EightByteInt(ncid, varid, values, start, count, stride, map)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), dimension(:, :, :, :, :, :, :), &
       intent(out) :: values
  integer, dimension(:), optional, intent( in) :: start, count, stride, map
  integer                                      :: nf90_get_var_7D_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localStart, localCount, localStride, localMap
  integer                               :: numDims, counter, format_num, shapeValues(7)
  integer, dimension(:), allocatable    :: defaultIntArray
  integer (kind = EightByteInt), dimension(:), allocatable :: defaultInt8Array

  ! Set local arguments to default values
  shapeValues             = shape(values)
  numDims                 = size(shapeValues)
  localStart (:         ) = 1
  localCount (:numDims  ) = shapeValues
  localCount (numDims+1:) = 1
  localStride(:         ) = 1
  localMap   (:numDims  ) = (/ 1, (product(localCount(:counter)), counter = 1, numDims - 1) /)

  if(present(start))  localStart (:size(start) )  = start(:)
  if(present(count))  localCount (:size(count) )  = count(:)
  if(present(stride)) localStride(:size(stride)) = stride(:)
  nf90_get_var_7D_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_get_var_7D_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        allocate(defaultInt8Array(size(values)))
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_get_var_7D_EightByteInt = &
                nf_get_varm_int64(ncid, varid, localStart, localCount, localStride, localMap, defaultInt8Array)
        else if(present(stride)) then
           nf90_get_var_7D_EightByteInt = &
                nf_get_vars_int64(ncid, varid, localStart, localCount, localStride, defaultInt8Array)
        else
           nf90_get_var_7D_EightByteInt = &
                nf_get_vara_int64(ncid, varid, localStart, localCount, defaultInt8Array)
        end if
        values(:, :, :, :, :, :, :) = reshape(defaultInt8Array(:), shapeValues)
        if (allocated(defaultInt8Array)) deallocate(defaultInt8Array)
     else
        allocate(defaultIntArray(size(values)))
        if(present(map))  then
           localMap   (:size(map))    = map(:)
           nf90_get_var_7D_EightByteInt = &
                nf_get_varm_int(ncid, varid, localStart, localCount, localStride, localMap, defaultIntArray)
        else if(present(stride)) then
           nf90_get_var_7D_EightByteInt = &
                nf_get_vars_int(ncid, varid, localStart, localCount, localStride, defaultIntArray)
        else
           nf90_get_var_7D_EightByteInt = &
                nf_get_vara_int(ncid, varid, localStart, localCount, defaultIntArray)
        end if
        values(:, :, :, :, :, :, :) = reshape(defaultIntArray(:), shapeValues)
        if (allocated(defaultIntArray)) deallocate(defaultIntArray)
     end if
  end if

end function nf90_get_var_7D_EightByteInt


function nf90_put_var_EightByteInt(ncid, varid, values, start)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), intent( in) :: values
  integer, dimension(:), optional, intent( in) :: start
  integer                                      :: nf90_put_var_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localIndex
  integer                               :: format_num

  ! Set local arguments to default values
  localIndex(:) = 1
  if(present(start)) localIndex(:size(start)) = start(:)

  nf90_put_var_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_put_var_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        nf90_put_var_EightByteInt = nf_put_var1_int64(ncid, varid, localIndex, values)
     else
        nf90_put_var_EightByteInt = nf_put_var1_int(ncid, varid, localIndex, int(values))
     endif
  endif
end function nf90_put_var_EightByteInt


function nf90_get_var_EightByteInt(ncid, varid, values, start)
  integer,                         intent( in) :: ncid, varid
  integer (kind = EightByteInt), intent(out) :: values
  integer, dimension(:), optional, intent( in) :: start
  integer                                      :: nf90_get_var_EightByteInt

  integer, dimension(nf90_max_var_dims) :: localIndex
  integer                               :: format_num
  integer                               :: defaultInteger
  integer (kind = EightByteInt)         :: defaultInteger8

  ! Set local arguments to default values
  localIndex(:) = 1
  if(present(start)) localIndex(:size(start)) = start(:)

  nf90_get_var_EightByteInt = nf_inq_format(ncid, format_num)
  if (nf90_get_var_EightByteInt .eq. nf90_noerr) then
     if (format_num .eq. nf90_format_netcdf4 .OR. &
         format_num .eq. nf90_format_cdf5) then
        nf90_get_var_EightByteInt = nf_get_var1_int64(ncid, varid, localIndex, defaultInteger8)
        values = defaultInteger8
     else
        nf90_get_var_EightByteInt = nf_get_var1_int(ncid, varid, localIndex, defaultInteger)
        values = defaultInteger
     endif
  endif
end function nf90_get_var_EightByteInt


