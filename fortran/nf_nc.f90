!-------------------------------- nf_create_par -------------------------------
 Function nf_create_par (path, cmode, comm, info, ncid) RESULT(status)

! create parallel file

 USE netcdf_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: cmode, comm, info
 Character(LEN=*), Intent(IN)  :: path
 Integer,          Intent(OUT) :: ncid

 Integer                       :: status

 Integer(C_INT)               :: ccmode, ccomm, cinfo, cncid, cstatus
 Character(LEN=(LEN(path)+1)) :: cpath
 Integer                      :: ie

 ccmode = cmode
 ccomm  = comm
 cinfo  = info
 cncid  = 0
 cpath  = addCNullChar(path, ie) ! add a C Null char and strip trailing blanks

 cstatus = nc_create_par_fortran(cpath(1:ie), ccmode, ccomm, cinfo, cncid)

 If (cstatus == NC_NOERR) Then
    ncid = cncid
 EndIf
 status = cstatus

 End Function nf_create_par
!-------------------------------- nf_open_par --------------------------------
 Function nf_open_par (path, mode, comm, info, ncid) RESULT(status)

! open a parallel file

 USE netcdf_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: mode, comm, info
 Character(LEN=*), Intent(IN)  :: path
 Integer,          Intent(OUT) :: ncid

 Integer                       :: status

 Integer(C_INT)               :: cmode, ccomm, cinfo, cncid, cstatus
 Character(LEN=(LEN(path)+1)) :: cpath
 Integer                      :: ie

 cmode = mode
 ccomm = comm
 cinfo = info
 cncid = 0
 cpath = addCNullChar(path, ie)

 cstatus = nc_open_par_fortran(cpath(1:ie), cmode, ccomm, cinfo, cncid)

 If (cstatus == NC_NOERR) Then
   ncid = cncid
 EndIf
 status = cstatus

 End Function nf_open_par
!-------------------------------- nf_var_par_access -------------------------
 Function nf_var_par_access( ncid, varid, iaccess) RESULT (status)

! set parallel variable access

 USE netcdf_nc_interfaces

 Implicit NONE

 Integer, Intent(IN) :: ncid, varid, iaccess

 Integer             :: status

 Integer(C_INT) :: cncid, cvarid, caccess, cstatus

 cncid   = ncid
 cvarid  = varid - 1
 caccess = iaccess

 cstatus = nc_var_par_access(cncid, cvarid, caccess)

 status = cstatus

 End Function nf_var_par_access
