#! /usr/bin/env python3

from jinja2 import Environment

class collectionCase():

    def __init__(self, dim, dimname, f_type, fc_type, c_type, a_type, colons): 
         self.dim = dim
         self.dimname = dimname
         self.f_type = f_type
         self.fc_type = fc_type
         self.c_type = c_type
         self.a_type = a_type 
         self.colons = colons
         self.function_name = "nf90_get_var_{0}_{1}".format(dimname, f_type) 

    def __repr__(self):
        return "{7:20s} {0:d} {1} {2} {3} {4} {5} {6}\n".format(
            self.dim, self.dimname, self.f_type, self.fc_type, self.c_type, self.a_type, self.colons, self.function_name
        )
              
#_____________________________________________________________________________
# Definitions

maxdims = 7
dimnames = []

f_types = [ 'OneByteInt', 'TwoByteInt', 'FourByteInt', 'EightByteInt', 'FourByteReal', 'EightByteReal' ]

fc_types = { 'OneByteInt':'c_int8_t', 'TwoByteInt':'c_int16_t', 'FourByteInt':'c_int32_t', 'EightByteInt':'c_int64_t',
             'FourByteReal':'c_float', 'EightByteReal':'c_double'
}
c_types = { 'OneByteInt':'schar', 'TwoByteInt':'short', 'FourByteInt':'int', 'EightByteInt':'long',
            'FourByteReal':'float', 'EightByteReal':'double'
}
array_types = { 'OneByteInt':'integer(c_int8_t)', 'TwoByteInt':'integer(c_int16_t)',
                'FourByteInt':'integer(c_int32_t)', 'EightByteInt':'integer(c_int64_t)',
                'FourByteReal':'real(c_float)', 'EightByteReal':'real(c_double)'
}

colons_of_dim = []
for dim in range(1, maxdims+1):
    commas = []
    for i in range(1, dim+1): 
        commas.append(":")
    colons_of_dim.append(",".join(commas))
    
for dim in range(1, maxdims+1):
    dimnames.append("{}D".format(dim))

#_____________________________________________________________________________
# Make the cases

cases_to_create = []

for f_type in fc_types:
    for dim in range(1, maxdims+1):
        idx = dim-1
        fc_type = fc_types[f_type]
        c_type = c_types[f_type]
        a_type = array_types[f_type]
        cases_to_create.append(collectionCase(dim, dimnames[idx], f_type, fc_type, c_type, a_type, colons_of_dim[idx]))

#_____________________________________________________________________________
# Template definition

# 0/ test case

# template_string = '''
# name       {{ replace_by.function_name }}
# dim        {{ replace_by.dim }}
# dimname    {{ replace_by.dimname }}
# f type     {{ replace_by.f_type }}
# fc type    {{ replace_by.fc_type }}
# c type     {{ replace_by.c_type }}
# colons     {{ replace_by.colons }}
# '''

# template = Environment().from_string(template_string)

# for case in cases_to_create:
#     output = template.render(dict(replace_by=case))
#     print(output)

# 1/ get, multi-dimensional, multi-type cases


nf90_get_template = '''
function {{ replace_by.function_name }}(ncid, varid, values, start, count, stride, map)

  use, intrinsic :: iso_c_binding

  implicit none

  integer :: {{ replace_by.function_name }}

  integer, intent(in) :: ncid, varid
  {{ replace_by.a_type }}, target, dimension({{ replace_by.colons }}), intent(out) :: values
  integer, dimension(:), optional, intent(in) :: start, count, stride, map

  interface

    function my_get_vara_{{ replace_by.c_type }}(ncid, varid, startp, countp, ip) bind(c, name='nc_get_vara_{{ replace_by.c_type }}')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_{{ replace_by.c_type }}
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: ip
    end function my_get_vara_{{ replace_by.c_type }}

    function my_get_varm_{{ replace_by.c_type }}(ncid, varid, startp, countp, stridep, mapp, ip) bind(c, name='nc_get_varm_{{ replace_by.c_type }}')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vara_{{ replace_by.c_type }}
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: mapp
      type(c_ptr), value    :: ip
    end function my_get_varm_{{ replace_by.c_type }}

    function my_get_vars_{{ replace_by.c_type }}(ncid, varid, startp, countp, stridep, ip) bind(c, name='nc_get_vars_{{ replace_by.c_type }}')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int)        :: my_get_vars_{{ replace_by.c_type }}
      integer(c_int), value :: ncid
      integer(c_int), value :: varid
      type(c_ptr), value    :: startp
      type(c_ptr), value    :: countp
      type(c_ptr), value    :: stridep
      type(c_ptr), value    :: ip
    end function my_get_vars_{{ replace_by.c_type }}

  end interface

  integer(c_int) :: cncid, cvarid, cstatus

  {{ replace_by.a_type }}, dimension({{ replace_by.colons }}), pointer :: farrayp
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
      cstatus = my_get_varm_{{ replace_by.c_type }}(cncid, cvarid, startp, countp, stridep, mapp, carrayp)
    else
      cstatus = my_get_vars_{{ replace_by.c_type }}(cncid, cvarid, startp, countp, stridep, carrayp)
    endif
  else
    cstatus = my_get_vara_{{ replace_by.c_type }}(cncid, cvarid, startp, countp, carrayp)
  end if

  call c_f_pointer(carrayp, farrayp, shape(values))

  {{ replace_by.function_name }} = cstatus

end function {{ replace_by.function_name }}
'''

template = Environment().from_string(nf90_get_template)
for case in cases_to_create:
    output = template.render(dict(replace_by=case))
    print(output)

