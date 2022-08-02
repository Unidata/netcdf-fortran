!                netCDF 4 specific FORTRAN functions

! Replacement for fort-nc4.c

! Written by: Richard Weed, Ph.D.
!             Center for Advanced Vehicular Systems  
!             Mississippi State University 
!             rweed@cavs.msstate.edu


! License (and other Lawyer Language)
 
! This software is released under the Apache 2.0 Open Source License. The
! full text of the License can be viewed at :
!
!   http:www.apache.org/licenses/LICENSE-2.0.html
!
! The author grants to the University Corporation for Atmospheric Research
! (UCAR), Boulder, CO, USA the right to revise and extend the software
! without restriction. However, the author retains all copyrights and
! intellectual property rights explicitly stated in or implied by the
! Apache license

! Version 1.- June  2006 - Based on netCDF 3.6.2 beta code and 4.0 alpha code
! Version 2.- July  2007 - Based on netCDF 3.6.2 snapshot and 4.0 beta code
! Version 3.- April 2009 - Based on NetCDF 4.0.1 release
! Version 4.- April 2010 - Based on NetCDF 4.1.1 release
! Version 5.- Aug.  2013 - Added nf_rename_grp to align with netCDF-C 4.3.1
! Version 6.- Sep.  2013 - Changed fill routines to support different types
! Version 7.- May   2014 - Ensure return error status checked from C API calls
! Version 8.- Jan.  2016 - General code cleanup. Replaced automatic arrays
!                          sized with NC_MAX_DIMS with allocatable arrays.
!                          Changed name processing to reflect change in
!                          addCNullChar

!-------------------------------- nf_inq_ncid ---------------------------------
 Function nf_inq_ncid(ncid, name, groupid) RESULT (status)

! inquire ncid  

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: ncid
 Character(LEN=*), Intent(IN)  :: name
 Integer,          Intent(OUT) :: groupid

 Integer                       :: status

 Integer(C_INT)             :: cncid, cgroupid, cstatus
 Character(LEN=LEN(name)+1) :: cname
 Integer                    :: ie

 cncid    = ncid
 cgroupid = 0
 cname    = REPEAT(" ",LEN(cname))
 cname    = addCNullChar(name, ie)

 cstatus = nc_inq_ncid(cncid, cname(1:ie), cgroupid)

 If (cstatus == NC_NOERR) Then
    groupid = cgroupid
 EndIf
 status  = cstatus

 End Function nf_inq_ncid
!-------------------------------- nf_inq_grps ---------------------------------
 Function nf_inq_grps( ncid, numgrps, ncids) RESULT (status)

! inquire number of grps and ncids

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)    :: ncid
 Integer, Intent(INOUT) :: ncids(*)
 Integer, Intent(OUT)   :: numgrps

 Integer                :: status

 Integer(C_INT) :: cncid, cnumgrps, cstatus, cstatus1

 Integer(C_INT), ALLOCATABLE :: cncids(:)

 cncid    = ncid
 cnumgrps = 0
 ncids(1) = 0
 numgrps  = 0

! Get cnumgrps first using utility from nc_lib.c which is not part
! of netCDF C.

 cstatus1 = nc_inq_numgrps(cncid, cnumgrps)

 If (cnumgrps > 0) Then 
   ALLOCATE(cncids(cnumgrps))
 Else
   ALLOCATE(cncids(1))
 EndIf

 cncids = 0
 
 cstatus  = nc_inq_grps(cncid, cnumgrps, cncids)
 If (cstatus == NC_NOERR) Then
   numgrps = cnumgrps
   If (numgrps > 0) Then
      ncids(1:numgrps) = cncids(1:numgrps)
   EndIf
 EndIf

 status  = cstatus

 If (ALLOCATED(cncids)) DEALLOCATE (cncids)

 End Function nf_inq_grps
!-------------------------------- nf_inq_grpname ------------------------------
 Function nf_inq_grpname( ncid, name) RESULT (status)

! inquire group name 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: ncid
 Character(LEN=*), Intent(OUT) :: name

 Integer                       :: status

 Integer(C_INT)             :: cncid, cstatus
 Character(LEN=NC_MAX_NAME) :: cname
 Integer                    :: nlen

 cncid = ncid
 nlen  = LEN(name)
 name  = REPEAT(" ",LEN(name))
 cname = REPEAT(" ",LEN(cname))
 
 cstatus = nc_inq_grpname(cncid, cname)

 If (cstatus == NC_NOERR) Then
    name = stripCNullChar(cname,nlen) ! Strip null char and trailing blanks 
 EndIf
 status = cstatus

 End Function nf_inq_grpname
!-------------------------------- nf_inq_grpname_full -------------------------
 Function nf_inq_grpname_full( ncid, nlen, name) RESULT (status)

! inquire full group name and length 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: ncid
 Character(LEN=*), Intent(OUT) :: name
 Integer,          Intent(OUT) :: nlen

 Integer                       :: status

 Integer(C_INT)             :: cncid, cstatus
 Integer(C_SIZE_T)          :: clen
 Character(LEN=LEN(name)+1) :: cname
 Integer                    :: nl

 cncid  = ncid
 nl     = LEN(name)
 name   = REPEAT(" ",LEN(name))
 cname  = REPEAT(" ",LEN(cname))
 
 cstatus = nc_inq_grpname_full(cncid, clen, cname)

 If (cstatus == NC_NOERR) Then
    nlen = int(clen)
    name = stripCNullChar(cname, nl)
 EndIf
 status = cstatus

 End Function nf_inq_grpname_full
!-------------------------------- nf_inq_grpname_len --------------------------
 Function nf_inq_grpname_len( ncid, nlen) RESULT (status)

! inquire length of full group name

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)  :: ncid
 Integer, Intent(OUT) :: nlen

 Integer              :: status

 Integer(C_INT)    :: cncid, cstatus
 Integer(C_SIZE_T) :: clen

 cncid  = ncid
 
 cstatus = nc_inq_grpname_len(cncid, clen)

 If (cstatus == NC_NOERR) Then
    ! Return name length 
     nlen = int(clen)
 EndIf
 status = cstatus

 End Function nf_inq_grpname_len
!-------------------------------- nf_inq_grp_parent ---------------------------
 Function nf_inq_grp_parent( ncid,parent_ncid) RESULT (status)

! inquire group parent number

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)    :: ncid
 Integer, Intent(INOUT) :: parent_ncid

 Integer                :: status

 Integer(C_INT) :: cncid, cparent_ncid, cstatus

 cncid  = ncid

 cstatus = nc_inq_grp_parent(cncid, cparent_ncid)

 If (cstatus == NC_NOERR) Then
    parent_ncid = cparent_ncid
 EndIf
 status  = cstatus

 End Function nf_inq_grp_parent
!-------------------------------- nf_inq_grp_ncid -----------------------------
 Function nf_inq_grp_ncid( ncid, grp_name, parent_ncid) RESULT (status)

! inquire parent_ncid given group name 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)    :: ncid
 Character(LEN=*), Intent(IN)    :: grp_name
 Integer,          Intent(INOUT) :: parent_ncid

 Integer                         :: status

 Integer(C_INT)                   :: cncid, cstatus, cparent_ncid
 Character(LEN=(LEN(grp_name)+1)) :: cgrp_name
 Integer                          :: ie

 cgrp_name = REPEAT(" ",LEN(cgrp_name))
 cgrp_name = addCNullChar(grp_name, ie)
 cncid     = ncid

 cstatus = nc_inq_grp_ncid(cncid, cgrp_name(1:ie), cparent_ncid)

 If (cstatus == NC_NOERR) Then
    parent_ncid = cparent_ncid
 EndIf
 status  = cstatus

 End Function nf_inq_grp_ncid
!-------------------------------- nf_inq_grp_full_ncid ------------------------
 Function nf_inq_grp_full_ncid( ncid, name, grp_ncid) RESULT (status)

! inquire grp ncid given full group name 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)    :: ncid
 Character(LEN=*), Intent(INOUT) :: name
 Integer,          Intent(INOUT) :: grp_ncid

 Integer                         :: status

 Integer(C_INT)               :: cncid, cstatus, cgrp_ncid
 Character(LEN=(LEN(name)+1)) :: cgrp_name
 Integer                      :: ie

 cncid     = ncid
 cgrp_name = REPEAT(" ",LEN(cgrp_name))
 cgrp_name = addCNullChar(name, ie)

 cstatus = nc_inq_grp_full_ncid(cncid, cgrp_name(1:ie), cgrp_ncid)

 If (cstatus == NC_NOERR) Then
    grp_ncid = cgrp_ncid
 EndIf
 status  = cstatus

 End Function nf_inq_grp_full_ncid
!-------------------------------- nf_inq_varids -------------------------------
 Function nf_inq_varids( ncid, nvars, varids) RESULT (status)

! inquire number of vars and varids 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)    :: ncid
 Integer, Intent(OUT)   :: nvars 
 Integer, Intent(INOUT) :: varids(*)

 Integer                :: status

 Integer(C_INT) :: cncid, cnvars, cstatus
 
 cncid     = ncid
 varids(1) = 0
 
 cstatus = nc_inq_varids_f(cncid, cnvars, varids)

 If (cstatus == NC_NOERR) Then
    nvars  = cnvars 
 EndIf
 status = cstatus

 End Function nf_inq_varids
!-------------------------------- nf_inq_dimids -------------------------------
 Function nf_inq_dimids( ncid, ndims, dimids, parent) RESULT (status)

! inquire number of dimids 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)    :: ncid, parent
 Integer, Intent(OUT)   :: ndims
 Integer, Intent(INOUT) :: dimids(*)

 Integer                :: status

 Integer(C_INT) :: cncid, cndims, cparent, cstatus

 cncid     = ncid
 dimids(1) = 0
 cparent = parent

 cstatus = nc_inq_dimids_f(cncid, cndims, dimids, cparent)

 If (cstatus == NC_NOERR) Then
    ndims  = cndims
 EndIf
 status = cstatus

 End Function nf_inq_dimids
!-------------------------------- nf_inq_typeids ------------------------------
 Function nf_inq_typeids( ncid, ntypes, typeids) RESULT (status)

! inquire number of types and typeids 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)    :: ncid
 Integer, Intent(OUT)   :: ntypes
 Integer, Intent(INOUT) :: typeids(*)

 Integer                :: status

 Integer(C_INT) :: cncid, cntypes, cstatus, cstatus1

 Integer(C_INT), ALLOCATABLE :: ctypeids(:)

 cncid      = ncid
 typeids(1) = 0

 cstatus1 = 0
 cstatus1 = nc_inq_numtypes(cncid, cntypes)

 If (cntypes > 0) Then
   ALLOCATE(ctypeids(cntypes))
 Else
   ALLOCATE(ctypeids(1))
 EndIf

 ctypeids = 0

 cstatus = nc_inq_typeids(cncid, cntypes, ctypeids)
 If (cstatus == NC_NOERR) Then
   ntypes            = cntypes
   If (ntypes > 0) Then
     typeids(1:ntypes) = ctypeids(1:ntypes)
   EndIf
 EndIf

 status  = cstatus

 If(ALLOCATED(ctypeids)) DEALLOCATE(ctypeids)

 End Function nf_inq_typeids
!-------------------------------- nf_inq_typeid -------------------------------
 Function nf_inq_typeid(ncid, name, typeid) RESULT (status)

! inquire typeid for given name 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: ncid
 Character(LEN=*), Intent(IN)  :: name
 Integer,          Intent(OUT) :: typeid

 Integer                       :: status

 Integer(C_INT)             :: cncid, ctypeid, cstatus
 Character(LEN=LEN(name)+1) :: cname
 Integer                    :: ie

 cncid    = ncid
 ctypeid  = 0
 cname    = REPEAT(" ",LEN(cname))
 cname    = addCNullChar(name, ie)

 cstatus = nc_inq_typeid(cncid, cname(1:ie), ctypeid)

 If (cstatus == NC_NOERR) Then
    typeid = ctypeid
 EndIf
 status = cstatus

 End Function nf_inq_typeid
!-------------------------------- nf_def_grp ---------------------------------
 Function nf_def_grp( parent_ncid, name, new_ncid) RESULT (status)

! define new group given name 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: parent_ncid
 Character(LEN=*), Intent(IN)  :: name
 Integer,          Intent(OUT) :: new_ncid

 Integer                       :: status

 Integer(C_INT)               :: cncid, cnew_ncid, cstatus
 Character(LEN=(LEN(name)+1)) :: cname
 Integer                      :: ie

 cncid = parent_ncid
 cname = REPEAT(" ",LEN(cname))
 cname = addCNullChar(name, ie)

 cstatus = nc_def_grp(cncid, cname(1:ie), cnew_ncid)

 If (cstatus == NC_NOERR) Then
    new_ncid = cnew_ncid 
 EndIf
 status   = cstatus

 End Function nf_def_grp
!-------------------------------- nf_rename_grp -------------------------------
 Function nf_rename_grp( grpid, name) RESULT (status)

! rename previously defined group

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: grpid
 Character(LEN=*), Intent(IN)  :: name

 Integer                       :: status

 Integer(C_INT)               :: cgrpid, cstatus
 Character(LEN=(LEN(name)+1)) :: cname
 Integer                      :: ie

 cgrpid = grpid
 cname  = REPEAT(" ",LEN(cname))
 cname  = addCNullChar(name, ie)

 cstatus = nc_rename_grp(cgrpid, cname(1:ie))

 status   = cstatus

 End Function nf_rename_grp
!-------------------------------- nf_def_compound -----------------------------
 Function nf_def_compound( ncid, isize, name, typeid) RESULT (status)

! define a compound variable given name and size 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: ncid, isize
 Integer,          Intent(OUT) :: typeid 
 Character(LEN=*), Intent(IN)  :: name

 Integer                       :: status

 Integer(C_INT)               :: cncid, ctypeid, cstatus
 Integer(C_SIZE_T)            :: csize
 Character(LEN=(LEN(name)+1)) :: cname
 Integer                      :: ie

 cncid = ncid
 csize = isize
 cname = REPEAT(" ",LEN(cname))
 cname = addCNullChar(name, ie)

 cstatus = nc_def_compound(cncid, csize, cname(1:ie), ctypeid)

 If (cstatus == NC_NOERR) Then
    typeid = ctypeid
 EndIf
 
 status = cstatus

 End Function nf_def_compound
!-------------------------------- nf_insert_compound --------------------------
 Function nf_insert_compound( ncid, xtype, name, offset, field_typeid) &
                              RESULT (status)

! Insert compound name offset field_typeid etc 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN) :: ncid, xtype, field_typeid, offset 
 Character(LEN=*), Intent(IN) :: name

 Integer                      :: status

 Integer(C_INT)               :: cncid, cxtype, ctypeid, cstatus
 Integer(C_SIZE_T)            :: coffset
 Character(LEN=(LEN(name)+1)) :: cname
 Integer                      :: ie

 cncid   = ncid
 cxtype  = xtype
 ctypeid = field_typeid
 coffset = offset
 cname   = REPEAT(" ",LEN(cname))
 cname   = addCNullChar(name, ie)

 cstatus = nc_insert_compound(cncid, cxtype, cname(1:ie), &
                              coffset, ctypeid)

 status = cstatus

 End Function nf_insert_compound
!-------------------------------- nf_insert_array_compound --------------------
 Function nf_insert_array_compound( ncid, xtype, name, offset, field_typeid, &
                                    ndims, dim_sizes) RESULT (status)

! Insert name type fieldid and dim_sizes array into compound 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)    :: ncid, xtype, field_typeid, offset, ndims
 Character(LEN=*), Intent(IN)    :: name
 Integer,          Intent(INOUT) :: dim_sizes(*)

 Integer                         :: status

 Integer(C_INT)               :: cncid, cxtype, ctypeid, cndims, cstatus
 Integer(C_SIZE_T)            :: coffset
 Character(LEN=(LEN(name)+1)) :: cname
 Integer                      :: ie

 cncid   = ncid
 cxtype  = xtype
 ctypeid = field_typeid
 coffset = offset
 cndims  = ndims
 cname   = REPEAT(" ",LEN(cname))
 cname   = addCNullChar(name, ie)

 cstatus = nc_insert_array_compound_f(cncid, cxtype, cname(1:ie), &
                                      coffset, ctypeid, cndims, dim_sizes)

 status = cstatus

 End Function nf_insert_array_compound
!-------------------------------- nf_inq_type ---------------------------------
 Function nf_inq_type( ncid, xtype, name, isize) RESULT (status)

! Inquire type size for given name and type

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: ncid, xtype
 Character(LEN=*), Intent(IN)  :: name
 Integer,          Intent(OUT) :: isize

 Integer                       :: status

 Integer(C_INT)               :: cncid, cxtype, cstatus
 Integer(C_SIZE_T)            :: csize
 Character(LEN=(LEN(name)+1)) :: cname
 Integer                      :: ie

 cncid  = ncid
 cxtype = xtype
 cname  = REPEAT(" ",LEN(cname))
 cname  = addCNullChar(name, ie)

 cstatus = nc_inq_type(cncid, cxtype, cname(1:ie), csize)

 If (cstatus == NC_NOERR) Then
    isize  = int(csize)
 EndIf
 status = cstatus

 End Function nf_inq_type
!-------------------------------- nf_inq_compound -----------------------------
 Function nf_inq_compound( ncid, xtype, name, isize, nfields) RESULT (status)

! return size and nfield for compound given ncid, xtype, and name

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)    :: ncid, xtype
 Character(LEN=*), Intent(INOUT) :: name
 Integer,          Intent(INOUT) :: isize, nfields

 Integer                         :: status

 Integer(C_INT)               :: cncid, cxtype, cstatus
 Integer(C_SIZE_T)            :: csize, cnfieldsp
 Character(LEN=NC_MAX_NAME+1) :: cname
 Integer                      :: nlen

 cncid  = ncid
 cxtype = xtype
 nlen   = LEN(name)
 name   = REPEAT(" ", nlen)
 cname  = REPEAT(" ", LEN(cname))

 cstatus = nc_inq_compound(cncid, cxtype, cname, csize, cnfieldsp)

 If (cstatus == NC_NOERR) Then
    name       = stripCNullChar(cname, nlen)
    isize      = int(csize)
    nfields    = int(cnfieldsp)
 EndIf
 status  = cstatus

 End Function nf_inq_compound
!-------------------------------- nf_inq_compound_name ------------------------
 Function nf_inq_compound_name( ncid, xtype, name) RESULT (status)

! inquire compound name 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: ncid, xtype
 Character(LEN=*), Intent(OUT) :: name

 Integer                       :: status

 Integer(C_INT)               :: cncid, cxtype, cstatus
 Character(LEN=NC_MAX_NAME+1) :: cname
 Integer                      :: nlen

 cncid  = ncid
 cxtype = xtype
 nlen   = LEN(name)
 name   = REPEAT(" ",LEN(name))
 cname  = REPEAT(" ",LEN(cname))
 
 cstatus = nc_inq_compound_name(cncid, cxtype, cname)

 If (cstatus == NC_NOERR) Then
     name = stripCNullChar(cname, nlen)
 EndIf
 status = cstatus

 End Function nf_inq_compound_name
!-------------------------------- nf_inq_compound_size -------------------------
 Function nf_inq_compound_size( ncid, xtype, isize) RESULT (status)

! return size compound given ncid, xtype

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)    :: ncid, xtype
 Integer, Intent(INOUT) :: isize

 Integer                :: status

 Integer(C_INT)    :: cncid, cxtype, cstatus
 Integer(C_SIZE_T) :: csize

 cncid  = ncid
 cxtype = xtype

 cstatus = nc_inq_compound_size(cncid, cxtype, csize)

 If (cstatus == NC_NOERR) Then
    isize  = int(csize)
 EndIf

 status = cstatus

 End Function nf_inq_compound_size
!-------------------------------- nf_inq_compound_nfields ----------------------
 Function nf_inq_compound_nfields( ncid, xtype, nfields) RESULT (status)

! return number of fields for compound 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)    :: ncid, xtype
 Integer, Intent(INOUT) :: nfields 

 Integer                :: status

 Integer(C_INT)    :: cncid, cxtype, cstatus
 Integer(C_SIZE_T) :: cnfields

 cncid  = ncid
 cxtype = xtype

 cstatus = nc_inq_compound_nfields(cncid, cxtype, cnfields)

 If (cstatus == NC_NOERR) Then
    nfields = int(cnfields)
 EndIf

 status  = cstatus

 End Function nf_inq_compound_nfields
!-------------------------------- nf_inq_compound_field -----------------------
 Function nf_inq_compound_field( ncid, xtype, fieldid, name, offset, &
                                field_typeid, ndims, dim_sizes) RESULT (status)

! inquire compound field info. Use Fortran specific version of C interface

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: ncid, xtype, fieldid
 Character(LEN=*), Intent(OUT) :: name
 Integer,          Intent(OUT) :: offset, field_typeid, ndims
 Integer,          Intent(OUT) :: dim_sizes(*)

 Integer                       :: status

 Integer(C_INT)               :: cncid, cxtype, cfieldid, cfield_typeid, &
                                 cndims, cstatus, cstatus1
 Integer(C_SIZE_T)            :: coffset
 Character(LEN=NC_MAX_NAME+1) :: cname
 Integer                      :: nlen

 Integer(C_INT), ALLOCATABLE :: cdim_sizes(:)

 cncid    = ncid
 cxtype   = xtype
 cfieldid = fieldid-1
 nlen     = LEN(name)
 name     = REPEAT(" ",LEN(name))
 cname    = REPEAT(" ",LEN(cname))
 dim_sizes(1) = 0

 cstatus1 = nc_inq_compound_field_ndims(cncid, cxtype, cfieldid, cndims)

 If (cndims > 0) Then
   ALLOCATE(cdim_sizes(cndims))
 Else
   ALLOCATE(cdim_sizes(1))
 EndIf

 cdim_sizes = 0

 cstatus = nc_inq_compound_field_f(cncid, cxtype, cfieldid, cname, coffset, &
                                   cfield_typeid, cndims, cdim_sizes)
 If (cstatus == NC_NOERR) Then
   name               = stripCNullChar(cname, nlen)
   offset             = int(coffset)
   field_typeid       = cfield_typeid
   ndims              = cndims
   If (ndims > 0) Then
     dim_sizes(1:ndims) = cdim_sizes(1:ndims)
   EndIf
 EndIf

 status = cstatus

 If (ALLOCATED(cdim_sizes)) DEALLOCATE(cdim_sizes)

 End Function nf_inq_compound_field
!-------------------------------- nf_inq_compound_fieldname -------------------
 Function nf_inq_compound_fieldname(ncid, xtype, fieldid, name) RESULT(status)

! inquire compound field name 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: ncid, xtype, fieldid
 Character(LEN=*), Intent(OUT) :: name

 Integer                       :: status

 Integer(C_INT)               :: cncid, cxtype, cfieldid, cstatus
 Character(LEN=NC_MAX_NAME+1) :: cname
 Integer                      :: nlen

 cncid    = ncid
 cxtype   = xtype
 cfieldid = fieldid - 1
 nlen     = LEN(name)
 name     = REPEAT(" ",LEN(name))
 cname    = REPEAT(" ",LEN(cname))
 
 cstatus = nc_inq_compound_fieldname(cncid, cxtype, cfieldid, cname)

 If (cstatus == NC_NOERR) Then
    name = stripCNullChar(cname, nlen)
 EndIf

 status = cstatus

 End Function nf_inq_compound_fieldname
!-------------------------------- nf_inq_compound_fieldindex ------------------
 Function nf_inq_compound_fieldindex( ncid, xtype, name, fieldid) RESULT (status)

! inquire compound field index id 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: ncid, xtype
 Character(LEN=*), Intent(IN)  :: name
 Integer,          Intent(OUT) :: fieldid

 Integer                       :: status

 Integer(C_INT)               :: cncid, cxtype, cfieldid, cstatus
 Character(LEN=(LEN(name)+1)) :: cname
 Integer                      :: ie

 cncid  = ncid
 cxtype = xtype
 cname  = REPEAT(" ",LEN(cname))
 cname  = addCNullChar(name, ie)

 cstatus = nc_inq_compound_fieldindex(cncid, cxtype, cname(1:ie), cfieldid)

 If (cstatus == NC_NOERR) Then
    fieldid = cfieldid + 1
 EndIf

 status  = cstatus

 End Function nf_inq_compound_fieldindex
!-------------------------------- nf_inq_compound_fieldoffset ----------------
 Function nf_inq_compound_fieldoffset( ncid, xtype, fieldid, offset)&
                                       RESULT (status)

! inquire compound field offset 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)  :: ncid, xtype, fieldid
 Integer, Intent(OUT) :: offset

 Integer              :: status

 Integer(C_INT)    :: cncid, cxtype, cfieldid, cstatus
 Integer(C_SIZE_T) :: coffset

 cncid    = ncid
 cxtype   = xtype
 cfieldid = fieldid - 1

 cstatus = nc_inq_compound_fieldoffset(cncid, cxtype, cfieldid, coffset)

 If (cstatus == NC_NOERR) Then
    offset = int(coffset)
 EndIf

 status = cstatus

 End Function nf_inq_compound_fieldoffset
!-------------------------------- nf_inq_compound_fieldtype -------------------
 Function nf_inq_compound_fieldtype( ncid, xtype, fieldid, field_typeid) &
                                    RESULT (status)

! inquire compound field typeid 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)  :: ncid, xtype, fieldid
 Integer, Intent(OUT) :: field_typeid

 Integer              :: status

 Integer(C_INT) :: cncid, cxtype, cfieldid, cfield_typeid, cstatus

 cncid    = ncid
 cxtype   = xtype
 cfieldid = fieldid -1 

 cstatus = nc_inq_compound_fieldtype(cncid, cxtype, cfieldid, cfield_typeid)

 If (cstatus == NC_NOERR) Then
    field_typeid = cfield_typeid
 EndIf

 status  = cstatus

 End Function nf_inq_compound_fieldtype
!-------------------------------- nf_inq_compound_fieldndims ------------------
 Function nf_inq_compound_fieldndims( ncid, xtype, fieldid, ndims) RESULT (status)

! Inquire compound field dim_size ndims 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)  :: ncid, xtype, fieldid
 Integer, Intent(OUT) :: ndims

 Integer              :: status

 Integer(C_INT) :: cncid, cxtype, cfieldid, cndims, cstatus

 cncid    = ncid
 cxtype   = xtype
 cfieldid = fieldid -1

 cstatus = nc_inq_compound_fieldndims(cncid, cxtype, cfieldid, cndims)

 If (cstatus == NC_NOERR) Then
    ndims = cndims 
 EndIf

 status = cstatus

 End Function nf_inq_compound_fieldndims
!-------------------------------- nf_inq_compound_fielddim_sizes --------------
 Function nf_inq_compound_fielddim_sizes( ncid, xtype, fieldid, dim_sizes) &
                                          RESULT (status)

! inq compound field dimension sizes 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)    :: ncid, xtype, fieldid
 Integer, Intent(INOUT) :: dim_sizes(*)

 Integer                :: status

 Integer(C_INT) :: cncid, cxtype, cfieldid, cstatus 

 cncid    = ncid
 cxtype   = xtype
 cfieldid = fieldid - 1 

 cstatus = nc_inq_compound_fielddim_sizes(cncid, cxtype, cfieldid, dim_sizes)

 status = cstatus

 End Function nf_inq_compound_fielddim_sizes
!-------------------------------- nf_def_vlen ---------------------------------
 Function nf_def_vlen( ncid, name, base_typeid, xtype) RESULT (status)

! define variable length data 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: ncid, base_typeid 
 Character(LEN=*), Intent(IN)  :: name
 Integer,          Intent(OUT) :: xtype

 Integer                       :: status

 Integer(C_INT)               :: cncid, cxtype, cbase_typeid, cstatus
 Character(LEN=(LEN(name)+1)) :: cname
 Integer                      :: ie

 cncid        = ncid
 cxtype       = xtype
 cbase_typeid = base_typeid
 cname        = REPEAT(" ",LEN(cname))
 cname        = addCNullChar(name, ie)

 cstatus = nc_def_vlen(cncid, cname(1:ie), cbase_typeid, cxtype)

 If (cstatus == NC_NOERR) Then
    xtype  = cxtype
 EndIf

 status = cstatus

 End Function nf_def_vlen
!-------------------------------- nf_inq_vlen ---------------------------------
 Function nf_inq_vlen( ncid, xtype, name, datum_size, base_type) RESULT(status) 

! inquire variable length array info 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: ncid, xtype
 Character(LEN=*), Intent(OUT) :: name
 Integer,          Intent(OUT) :: datum_size, base_type

 Integer                       :: status

 Integer(C_INT)               :: cncid, cxtype, cbase_type, cstatus
 Integer(C_SIZE_T)            :: cdatum_size
 Character(LEN=NC_MAX_NAME+1) :: cname
 Integer                      :: nlen

 cncid  = ncid
 cxtype = xtype
 nlen   = LEN(name)
 name   = REPEAT(" ",LEN(name))
 cname  = REPEAT(" ",LEN(cname))
 
 cstatus = nc_inq_vlen(cncid, cxtype, cname, cdatum_size, cbase_type)

 If (cstatus == NC_NOERR) Then
    name       = stripCNullChar(cname, nlen)
    datum_size = int(cdatum_size)
    base_type  = cbase_type 
 EndIf

 status = cstatus

 End Function nf_inq_vlen
!-------------------------------- nf_inq_user_type ----------------------------
 Function nf_inq_user_type( ncid, xtype, name, isize, base_type, nfields, &
                            iclass) RESULT (status)

! return size and nfield, class, and base type for user type given 
! ncid, xtype, and name

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)    :: ncid, xtype
 Character(LEN=*), Intent(INOUT) :: name
 Integer,          Intent(OUT)   :: isize, nfields, base_type, iclass

 Integer                         :: status

 Integer(C_INT)               :: cncid, cxtype, cbase_type, cclass, cstatus
 Integer(C_SIZE_T)            :: csize, cnfields
 Character(LEN=NC_MAX_NAME+1) :: cname
 Integer                      :: nlen

 cncid  = ncid
 cxtype = xtype
 nlen   = LEN(name)
 name   = REPEAT(" ",LEN(name))
 cname  = REPEAT(" ",LEN(cname))
 

 cstatus = nc_inq_user_type(cncid, cxtype, cname, csize, cbase_type, cnfields, &
                           cclass)

 If (cstatus == NC_NOERR) Then
    name       = stripCNullChar(cname, nlen)
    isize      = int(csize)
    nfields    = int(cnfields)
    iclass     = cclass
    base_type  = cbase_type
 EndIf

 status = cstatus

 End Function nf_inq_user_type
!-------------------------------- nf_def_enum ---------------------------------
 Function nf_def_enum( ncid, base_typeid, name, typeid) RESULT (status)

! define an enumerator typeid 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: ncid, base_typeid 
 Character(LEN=*), Intent(IN)  :: name
 Integer,          Intent(OUT) :: typeid

 Integer                       :: status

 Integer(C_INT)               :: cncid, cbase_typeid, ctypeid, cstatus
 Character(LEN=(LEN(name)+1)) :: cname
 Integer                      :: ie

 cncid        = ncid
 cbase_typeid = base_typeid
 cname        = REPEAT(" ",LEN(cname))
 cname        = addCNullChar(name, ie)

 cstatus = nc_def_enum(cncid, cbase_typeid, cname(1:ie), ctypeid)

 If (cstatus == NC_NOERR) Then
    typeid = ctypeid
 EndIf

 status = cstatus

 End Function nf_def_enum
!-------------------------------- nf_insert_enum -------------------------------
 Function nf_insert_enum( ncid, xtype, name, value) RESULT (status)

! define a value for an enum. We used a C_CHAR string to pass the data
! into nf_insert_enum and a C_PTR type to pass the address of value
! into nc_insert_enum which is expecting a void pointer. Don't use
! an explicit interface to nf_insert_enum in the calling program
! for any data type other than character. Just declare it external

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,                Intent(IN)         :: ncid, xtype 
 Character(LEN=*),       Intent(IN)         :: name
 Character(KIND=C_CHAR), Intent(IN), TARGET :: value(*)

 Integer                                    :: status

 Integer(C_INT)               :: cncid, cxtype, cstatus
 Type(C_PTR)                  :: cvalueptr
 Character(LEN=(LEN(name)+1)) :: cname
 Integer                      :: ie

 cncid  = ncid
 cxtype = xtype
 cname  = REPEAT(" ",LEN(cname))
 cname  = addCNullChar(name, ie)

 cvalueptr = C_LOC(value)

 cstatus = nc_insert_enum(cncid, cxtype, cname(1:ie), cvalueptr)

 status = cstatus

 End Function nf_insert_enum
!-------------------------------- nf_inq_enum ------------------------------
 Function nf_inq_enum( ncid, xtype, name, base_nf_type, base_size, &
                       num_members) RESULT (status)

! get information about an enum. 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)    :: ncid, xtype
 Character(LEN=*), Intent(INOUT) :: name
 Integer,          Intent(INOUT) :: base_nf_type, base_size, num_members

 Integer                         :: status

 Integer(C_INT)               :: cncid, cxtype, c_base_nf_type, cstatus
 Integer(C_SIZE_T)            :: c_base_size, c_num_members
 Character(LEN=NC_MAX_NAME+1) :: cname
 Integer                      :: nlen

 cncid  = ncid
 cxtype = xtype
 nlen   = LEN(name)
 name   = REPEAT(" ",LEN(name))
 cname  = REPEAT(" ",LEN(cname))

 cstatus = nc_inq_enum (cncid, cxtype, cname, c_base_nf_type, c_base_size, &
                        c_num_members)

 If (cstatus == NC_NOERR) Then
    name         = stripCNullChar(cname, nlen)
    base_nf_type = c_base_nf_type
    base_size    = int(c_base_size)
    num_members  = int(c_num_members)
 EndIf

 status = cstatus

 End Function nf_inq_enum
!-------------------------------- nf_inq_enum_member ---------------------------
 Function nf_inq_enum_member( ncid, xtype, idx, name, value) RESULT (status)

! Get name and value for an enum. We use a C_CHAR string to pass data
! from nc_inq_enum_member to the calling routine. Value is a void
! pointer in nc_inq_enum_member. Don't use an explicit interface in
! the calling program. Declare nf_inq_enum_member external

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,                Intent(IN)  :: ncid, xtype, idx 
 Character(LEN=*),       Intent(OUT) :: name
 Character(KIND=C_CHAR), Intent(OUT) :: value(*)

 Integer                             :: status

 Integer(C_INT)               :: cncid, cxtype, cidx, cstatus
 Character(LEN=NC_MAX_NAME+1) :: cname
 Integer                      :: nlen

 cncid  = ncid
 cxtype = xtype
 cidx   = idx - 1
 nlen   = LEN(name)
 name  = REPEAT(" ",LEN(name))
 cname = REPEAT(" ",LEN(cname))

 cstatus = nc_inq_enum_member(cncid, cxtype, cidx, cname, value)

 If (cstatus == NC_NOERR) Then
    name = stripCNullChar(cname, nlen)
 EndIf

 status = cstatus

 End Function nf_inq_enum_member
!-------------------------------- nf_inq_enum_ident ---------------------------
 Function nf_inq_enum_ident( ncid, xtype, value, name) RESULT (status)

! get name of enum identifier given value, type.

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)    :: ncid, xtype, value
 Character(LEN=*), Intent(INOUT) :: name

 Integer                         :: status

 Integer(C_INT)               :: cncid, cxtype, cstatus
 Integer(C_LONG_LONG)         :: cvalue  
 Character(LEN=NC_MAX_NAME+1) :: cname
 Integer                      :: nlen

 cncid  = ncid
 cxtype = xtype
 cvalue = value
 nlen   = LEN(name)
 name   = REPEAT(" ",LEN(name))
 cname  = REPEAT(" ",LEN(cname))

 cstatus = nc_inq_enum_ident(cncid, cxtype, cvalue, cname)

 If (cstatus == NC_NOERR) Then
    name = stripCNullChar(cname, nlen)
 EndIf

 status = cstatus

 End Function nf_inq_enum_ident
!-------------------------------- nf_def_opaque -------------------------------
 Function nf_def_opaque( ncid, isize, name, xtype) RESULT (status)

! define opaque type info

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)  :: ncid, isize
 Character(LEN=*), Intent(IN)  :: name
 Integer,          Intent(OUT) :: xtype

 Integer                       :: status

 Integer(C_INT)               :: cncid, cxtype, cstatus
 Integer(C_SIZE_T)            :: csize
 Character(LEN=(LEN(name)+1)) :: cname
 Integer                      :: ie

 cncid  = ncid
 csize  = isize
 cxtype = xtype
 cname  = REPEAT(" ",LEN(cname))
 cname  = addCNullChar(name, ie)

 cstatus = nc_def_opaque(cncid, csize, cname(1:ie), cxtype)

 If (cstatus == NC_NOERR) Then
    xtype  = cxtype 
 EndIf

 status = cstatus

 End Function nf_def_opaque
!-------------------------------- nf_inq_opaque -------------------------------
 Function nf_inq_opaque( ncid, xtype, name, isize) RESULT (status)

! Inquire about opaque type info

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,          Intent(IN)    :: ncid, xtype
 Character(LEN=*), Intent(INOUT) :: name
 Integer,          Intent(OUT)   :: isize

 Integer                         :: status

 Integer(C_INT)               :: cncid, cxtype, cstatus
 Integer(C_SIZE_T)            :: csize
 Character(LEN=NC_MAX_NAME+1) :: cname
 Integer                      :: nlen

 cncid  = ncid
 cxtype = xtype
 nlen   = LEN(name)
 name   = REPEAT(" ",LEN(name))
 cname  = REPEAT(" ",LEN(cname))

 cstatus = nc_inq_opaque(cncid, cxtype, cname, csize)

 If (cstatus == NC_NOERR) Then
    name   = stripCNullChar(cname, nlen)
    isize  = int(csize)
 EndIf

 status = cstatus

 End Function nf_inq_opaque
!-------------------------------- nf_def_var_chunking -------------------------
 Function nf_def_var_chunking( ncid, varid, contiguous, chunksizes) &
                               RESULT(status)

! define variable chunking

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)    :: ncid, varid, contiguous
 Integer, Intent(INOUT) :: chunksizes(*)

 Integer                :: status

 Integer(C_INT) :: cncid, cvarid, ccontiguous, cstat1, cstatus, &
                   cndims
 Type(C_PTR)    :: cchunksizeptr
 Integer        :: ndims

 Integer(C_INT), ALLOCATABLE, TARGET :: cchunksizes(:)

 cncid       = ncid
 cvarid      = varid-1
 ccontiguous = contiguous

 cstat1 = nc_inq_varndims(cncid, cvarid, cndims)

 ndims         = cndims
 cchunksizeptr = C_NULL_PTR

 If (cstat1 == NC_NOERR) Then
   If (ndims > 0) Then
     ALLOCATE(cchunksizes(ndims))
     cchunksizes(1:ndims) = chunksizes(ndims:1:-1)
     cchunksizeptr        = C_LOC(cchunksizes)
   EndIf
 EndIf

 cstatus = nc_def_var_chunking_ints(cncid, cvarid, ccontiguous, cchunksizeptr)

 status = cstatus

! Make sure there are no dangling pointers or allocated arrays

  cchunksizeptr = C_NULL_PTR
  If (ALLOCATED(cchunksizes)) DEALLOCATE(cchunksizes)

 End Function nf_def_var_chunking
!-------------------------------- nf_inq_var_chunking -------------------------
 Function nf_inq_var_chunking( ncid, varid, contiguous, chunksizes) RESULT(status)

! inquire variable chunking 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)    :: ncid, varid
 Integer, Intent(INOUT) :: contiguous
 Integer, Intent(INOUT) :: chunksizes(*)

 Integer                :: status

 Integer(C_INT) :: cncid, cvarid, ccontiguous, cstatus, cstat1, cndims
 Integer        :: ndims

 Integer(C_INT), ALLOCATABLE :: cchunksizes(:)

 cncid         = ncid
 cvarid        = varid-1
 chunksizes(1) = 0
 contiguous    = 0

 cstat1  = nc_inq_varndims(cncid, cvarid, cndims)
 status  = cstat1

 If (cndims > 0) Then 
   ALLOCATE(cchunksizes(cndims))
 Else
   ALLOCATE(cchunksizes(1))
 EndIf 

 cchunksizes = 0

 cstatus = nc_inq_var_chunking_ints(cncid, cvarid, ccontiguous, &
                                    cchunksizes) 
 ndims = cndims
 If (cstatus == NC_NOERR) Then
   If (ndims > 0) Then
     chunksizes(ndims:1:-1) = cchunksizes(1:ndims)
   EndIf
   contiguous = ccontiguous
 EndIf

 status     = cstatus

 If (ALLOCATED(cchunksizes)) DEALLOCATE(cchunksizes)

 End Function nf_inq_var_chunking
!-------------------------------- nf_def_var_deflate --------------------------
 Function nf_def_var_deflate( ncid, varid, shuffle, deflate, deflate_level) &
                               RESULT (status)

! define variable deflation 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN) :: ncid, varid, shuffle, deflate, deflate_level

 Integer             :: status

 Integer(C_INT) :: cncid, cvarid, cshuffle, cdeflate, cdeflate_level, &
                   cstatus

 cncid          = ncid
 cvarid         = varid-1
 cshuffle       = shuffle
 cdeflate       = deflate
 cdeflate_level = deflate_level

 cstatus = nc_def_var_deflate(cncid, cvarid, cshuffle, cdeflate, cdeflate_level) 
 status = cstatus

 End Function nf_def_var_deflate
!-------------------------------- nf_inq_var_deflate -------------------------
 Function nf_inq_var_deflate( ncid, varid, shuffle, deflate, deflate_level) &
                               RESULT (status)

! inquire variable deflation 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)  :: ncid, varid
 Integer, Intent(OUT) :: shuffle, deflate, deflate_level

 Integer              :: status

 Integer(C_INT) :: cncid, cvarid, cshuffle, cdeflate, cdeflate_level, &
                   cstatus

 cncid  = ncid
 cvarid = varid-1

 cstatus = nc_inq_var_deflate(cncid, cvarid, cshuffle, cdeflate, cdeflate_level) 

 If (cstatus == NC_NOERR) Then
    shuffle       = cshuffle
    deflate       = cdeflate
    deflate_level = cdeflate_level
 EndIf

 status = cstatus
 
 End Function nf_inq_var_deflate

 !-------------------------------- nf_def_var_zstandard --------------------------
 Function nf_def_var_zstandard( ncid, varid, zstandard_level) RESULT (status)
   ! Define variable zstandard compression.
   USE netcdf4_nc_interfaces
   Implicit NONE

   Integer, Intent(IN) :: ncid, varid, zstandard_level
   Integer :: status
   Integer(C_INT) :: cncid, cvarid, czstandard_level, cstatus

   cncid = ncid
   cvarid = varid - 1
   czstandard_level = zstandard_level

#ifdef ENABLE_ZSTD
   cstatus = nc_def_var_zstandard(cncid, cvarid, czstandard_level)
#else
   cstatus = nc_enotbuilt
#endif

   status = cstatus

 End Function nf_def_var_zstandard
 !-------------------------------- nf_inq_var_zstandard -------------------------
 Function nf_inq_var_zstandard( ncid, varid, zstandard, zstandard_level) RESULT (status)
   ! inquire variable deflation
   USE netcdf4_nc_interfaces
   Implicit NONE

   Integer, Intent(IN)  :: ncid, varid
   Integer, Intent(OUT) :: zstandard, zstandard_level
   Integer :: status
   Integer(C_INT) :: cncid, cvarid, czstandard, czstandard_level, cstatus

   cncid = ncid
   cvarid = varid - 1

#ifdef ENABLE_ZSTD
   cstatus = nc_inq_var_zstandard(cncid, cvarid, czstandard, czstandard_level)
#else
   cstatus = nc_enotbuilt
#endif

   If (cstatus == NC_NOERR) Then
      zstandard = czstandard
      zstandard_level = czstandard_level
   EndIf
   status = cstatus

 End Function nf_inq_var_zstandard

!-------------------------------- nf_def_var_szip --------------------------
 Function nf_def_var_szip(ncid, varid, options_mask, pixels_per_block) &
      RESULT (status)
! define variable deflation
 USE netcdf4_nc_interfaces
 Implicit NONE
 Integer, Intent(IN) :: ncid, varid, options_mask, pixels_per_block
 Integer :: status
 Integer(C_INT) :: cncid, cvarid, coptions_mask, cpixels_per_block, cstatus

 cncid = ncid
 cvarid = varid-1
 coptions_mask = options_mask
 cpixels_per_block = pixels_per_block

 cstatus = nc_def_var_szip(cncid, cvarid, coptions_mask, cpixels_per_block)
 status = cstatus

 End Function nf_def_var_szip
!-------------------------------- nf_inq_var_szip -----------------------------
 Function nf_inq_var_szip(ncid, varid, options_mask, pixels_per_block) RESULT(status)

! get szip variables
 
 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)    :: ncid, varid
 Integer, Intent(INOUT) :: options_mask, pixels_per_block

 Integer                :: status

 Integer(C_INT) :: cncid, cvarid, coptions_mask, cpixels_per_block, cstatus

 cncid  = ncid
 cvarid = varid-1

 cstatus = nc_inq_var_szip(cncid, cvarid, coptions_mask, cpixels_per_block)

 If (cstatus == NC_NOERR) Then
    options_mask     = coptions_mask
    pixels_per_block = cpixels_per_block
 EndIf

 status = cstatus

 End Function nf_inq_var_szip

!-------------------------------- nf_def_var_quantize --------------------------
 Function nf_def_var_quantize(ncid, varid, quantize_mode, nsd) &
      RESULT (status)
! define variable deflation
 USE netcdf4_nc_interfaces
 Implicit NONE
 Integer, Intent(IN) :: ncid, varid, quantize_mode, nsd
 Integer :: status
 Integer(C_INT) :: cncid, cvarid, cquantize_mode, cnsd, cstatus

 cncid = ncid
 cvarid = varid-1
 cquantize_mode = quantize_mode
 cnsd = nsd

#ifdef NF_HAS_QUANTIZE 
 cstatus = nc_def_var_quantize(cncid, cvarid, cquantize_mode, cnsd)
#else
 cstatus = nc_enotbuilt
#endif
 status = cstatus

 End Function nf_def_var_quantize
!-------------------------------- nf_inq_var_quantize -----------------------------
 Function nf_inq_var_quantize(ncid, varid, quantize_mode, nsd) RESULT(status)

! get quantize variables
 
 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)    :: ncid, varid
 Integer, Intent(INOUT) :: quantize_mode, nsd

 Integer                :: status

 Integer(C_INT) :: cncid, cvarid, cquantize_mode, cnsd, cstatus

 cncid  = ncid
 cvarid = varid-1

#ifdef NF_HAS_QUANTIZE
 cstatus = nc_inq_var_quantize(cncid, cvarid, cquantize_mode, cnsd)
#else
 cstatus = nc_enotbuilt
#endif

 If (cstatus == NC_NOERR) Then
    quantize_mode     = cquantize_mode
    nsd = cnsd
 EndIf

 status = cstatus

 End Function nf_inq_var_quantize

!-------------------------------- nf_def_var_fletcher32 -----------------------
 Function nf_def_var_fletcher32( ncid, varid, fletcher32) RESULT(status)

! define var for fletcher32 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN) :: ncid, varid, fletcher32

 Integer             :: status

 Integer(C_INT) :: cncid, cvarid, cfletcher32, cstatus

 cncid       = ncid
 cvarid      = varid-1
 cfletcher32 = fletcher32 

 cstatus = nc_def_var_fletcher32(cncid, cvarid, cfletcher32)
 
 status = cstatus

 End Function nf_def_var_fletcher32
!-------------------------------- nf_inq_var_fletcher32 ------------------------
 Function nf_inq_var_fletcher32( ncid, varid, fletcher32) RESULT(status)

! get var for fletcher 32 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)  :: ncid, varid
 Integer, Intent(OUT) :: fletcher32

 Integer              :: status

 Integer(C_INT) :: cncid, cvarid, cfletcher32, cstatus

 cncid  = ncid
 cvarid = varid-1

 cstatus = nc_inq_var_fletcher32(cncid, cvarid, cfletcher32)

 If (cstatus == NC_NOERR) Then
    fletcher32 = cfletcher32 
 EndIf
 
 status = cstatus

 End Function nf_inq_var_fletcher32
!-------------------------------- nf_def_var_fill -----------------------------
 Function nf_def_var_fill( ncid, varid, no_fill, fill_value) RESULT(status)

! define fill variable 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)                        :: ncid, varid, no_fill
 Character(KIND=C_CHAR), Intent(IN), TARGET :: fill_value(*)

 Integer                                    :: status

 Integer(C_INT) :: cncid, cvarid, cno_fill, cstatus
 Type(C_PTR)    :: cfill_value_p

 cncid    = ncid
 cvarid   = varid-1
 cno_fill = no_fill

 cfill_value_p = C_LOC(fill_value)

 cstatus       = nc_def_var_fill(cncid, cvarid, cno_fill, cfill_value_p)

 status        = cstatus

 End Function nf_def_var_fill
!-------------------------------- nf_inq_var_fill -----------------------------
 Function nf_inq_var_fill( ncid, varid, no_fill, fill_value) RESULT(status)

! get fill variable 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)                   :: ncid, varid
 Integer, Intent(OUT)                  :: no_fill
 Character(KIND=C_CHAR), Intent(INOUT) :: fill_value(*)

 Integer                               :: status

 Integer(C_INT) :: cncid, cvarid, cno_fill, cstatus

 cncid  = ncid
 cvarid = varid-1

 cstatus = nc_inq_var_fill(cncid, cvarid, cno_fill, fill_value)

 If (cstatus == NC_NOERR) Then
    no_fill = cno_fill 
 EndIf

 status  = cstatus

 End Function nf_inq_var_fill
!-------------------------------- nf_def_var_endian ---------------------------
 Function nf_def_var_endian( ncid, varid, endiann) RESULT(status)

! define variable endian 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN) :: ncid, varid, endiann

 Integer             :: status

 Integer(C_INT) :: cncid, cvarid, cendiann, cstatus

 cncid    = ncid
 cvarid   = varid-1
 cendiann = endiann

 cstatus = nc_def_var_endian(cncid, cvarid, cendiann)

 status = cstatus

 End Function nf_def_var_endian
!-------------------------------- nf_inq_var_endian ---------------------------
 Function nf_inq_var_endian( ncid, varid, endiann) RESULT(status)

! get variable endian 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)  :: ncid, varid
 Integer, Intent(OUT) ::  endiann

 Integer              :: status

 Integer(C_INT) :: cncid, cvarid, cendiann, cstatus

 cncid  = ncid
 cvarid = varid-1

 cstatus = nc_inq_var_endian(cncid, cvarid, cendiann)

 If (cstatus == NC_NOERR) Then
    endiann = cendiann
 EndIf

 status  = cstatus

 End Function nf_inq_var_endian
!-------------------------------- nf_def_var_filter ---------------------------
 Function nf_def_var_filter( ncid, varid, filterid, nparams, params) RESULT(status)

! define variable filter 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN) :: ncid, varid, filterid, nparams
 Integer, Intent(IN) :: params(*)

 Integer             :: status

 Integer(C_INT) :: cncid, cvarid, cfilterid, cstatus
 Integer(C_SIZE_T) :: cnparams

 cncid    = ncid
 cvarid   = varid-1
 cfilterid = filterid
 cnparams = nparams

 cstatus = nc_def_var_filter(cncid, cvarid, cfilterid, cnparams, params)

 status = cstatus

 End Function nf_def_var_filter
!-------------------------------- nf_inq_var_filter -----------------------------
 Function nf_inq_var_filter(ncid, varid, filterid, nparams, params) RESULT(status)

! get filter variables
 
 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)  :: ncid, varid
 Integer, Intent(OUT) :: filterid, nparams
 Integer, Intent(OUT) :: params(*)

 Integer                :: status

 Integer(C_INT) :: cncid, cvarid, cstatus, cstatus1, cfilterid
 Integer(C_SIZE_T) :: cnparams
 Integer(C_INT), ALLOCATABLE :: cparams(:)

 cncid  = ncid
 cvarid = varid-1
 params(1) = 0

 cstatus1 = nc_inq_varnparams(cncid, cvarid, cnparams)

 If (cstatus1 == NC_NOERR) Then
   ALLOCATE(cparams(cnparams))
 Else
   ALLOCATE(cparams(1))
 EndIf

 cstatus = nc_inq_var_filter(cncid, cvarid, cfilterid, cnparams, cparams)

 If (cstatus == NC_NOERR) Then
   filterid = cfilterid
   nparams = int(cnparams)
   If (cnparams > 0) Then
     params(1:nparams) = cparams(1:nparams)
   EndIf
 EndIf

 status = cstatus

 End Function nf_inq_var_filter
!--------------------------------- nf_put_vlen_element ------------------------
 Function nf_put_vlen_element(ncid, xtype, vlen_element, nlen, value) &
                              RESULT(status)

! Put in a variable length array element element for Netcdf . We use a C
! character string as the dummy arguments for the values. Don't supply calling
! program with an explicit interface. Just use external

! Note Users manual defines vlen_element to be a character string. We
! use the same here but pass it as a C_PTR type.

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,                Intent(IN)            :: ncid, xtype, nlen
 Character(KIND=C_CHAR), Intent(INOUT)         :: vlen_element(*)
 Character(KIND=C_CHAR), Intent(IN),   TARGET  :: value(*)

 Integer                                       :: status

 Integer(C_INT)    :: cncid, cxtype, cstatus
 Integer(C_SIZE_T) :: cnlen
 Type(C_PTR)       :: cvalueptr

 cncid     = ncid
 cxtype    = xtype
 cnlen     = nlen 
 cvalueptr = C_LOC(value)

 cstatus = nc_put_vlen_element(cncid, cxtype, vlen_element, cnlen,&
                               cvalueptr)

 status = cstatus

 End Function nf_put_vlen_element
!--------------------------------- nf_get_vlen_element ------------------------
 Function nf_get_vlen_element(ncid, xtype, vlen_element, nlen, value) RESULT(status)

! Get a variable length array element element for Netcdf . We use a C
! character string as the dummy arguments for the values. Don't supply calling
! program with an explicit interface. Just use external

! Note Users manual defines vlen_element to be a character string. We
! use the same here but pass it as a C_PTR type.

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,                Intent(IN)            :: ncid, xtype
 Integer,                Intent(INOUT)         :: nlen
 Character(LEN=*),       Intent(INOUT), TARGET :: vlen_element
 Character(KIND=C_CHAR), Intent(INOUT)         :: value(*)

 Integer                                       :: status

 Integer(C_INT)    :: cncid, cxtype, cstatus
 Integer(C_SIZE_T) :: cnlen

 cncid  = ncid
 cxtype = xtype

 cstatus = nc_get_vlen_element(cncid, cxtype, vlen_element, cnlen,&
                               value)

 If (cstatus == NC_NOERR) Then
    nlen = int(cnlen)
 EndIf

 status = cstatus

 End Function nf_get_vlen_element
!--------------------------------- nf_free_vlen --------------------------------
 Function nf_free_vlen(vl) RESULT(status)

! Free memory for vlen array
! C_CHAR string is used as the dummy arguments for vl. Don't supply calling
! program with an explicit interface. Just use external

 USE netcdf4_nc_interfaces

 Implicit NONE

 Character(KIND=C_CHAR), Intent(IN), TARGET :: vl(*)

 Integer                                    :: status

 Integer(C_INT) :: cstatus
 Type(C_PTR)    :: cvl

 cvl = C_LOC(vl) !void pointer in C interface

 cstatus = nc_free_vlen(cvl)

 status = cstatus

End Function nf_free_vlen
!--------------------------------- nf_free_vlens ------------------------------
 Function nf_free_vlens(ilen, vl) RESULT(status)

! Free memory for vlens array
! C_CHAR string is used as the dummy arguments for vl. Don't supply calling
! program with an explicit interface. Just use external

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,                Intent(IN)         :: ilen
 Character(KIND=C_CHAR), Intent(IN), TARGET :: vl(*)

 Integer                                    :: status

 Integer(C_SIZE_T) :: clen
 Integer(C_INT)    :: cstatus
 Type(C_PTR)       :: cvl

 clen = ilen
 cvl  = C_LOC(vl) !void pointer in C interface

 cstatus = nc_free_vlens(clen, cvl)

 status = cstatus

End Function nf_free_vlens
!--------------------------------- nf_free_string -----------------------------
 Function nf_free_string(ilen, vl) RESULT(status)

! Free memory for string array 
! C_CHAR string is used as the dummy arguments for vl. Don't supply calling
! program with an explicit interface. Just use external

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,                Intent(IN)         :: ilen
 Character(KIND=C_CHAR), Intent(IN), TARGET :: vl(*)

 Integer                                    :: status

 Integer(C_SIZE_T) :: clen
 Integer(C_INT)    :: cstatus
 Type(C_PTR)       :: cvl

 clen = ilen
 cvl  = C_LOC(vl) !void pointer in C interface

 cstatus = nc_free_string(clen, cvl)

 status = cstatus

End Function nf_free_string

!--------------------------------- nf_put_var -------------------------------
 Function nf_put_var(ncid, varid, values) RESULT(status)

! Write out a variable of any type. We use a C_CHAR character string
! to hold values. Therefore, an explicit interface to nf_put_var should NOT 
! be used in the calling routine. Use an external instead. 
! Defined in  fort-vario.c but only used in 4.0.1 for NETCDF4 builds

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,                Intent(IN)         :: ncid, varid
 Character(KIND=C_CHAR), Intent(IN), TARGET :: values(*)

 Integer                                    :: status

 Integer(C_INT) :: cncid, cvarid,  cstatus
 Type(C_PTR)    :: cvaluesptr

 cncid  = ncid
 cvarid = varid - 1 ! Subtract 1 to get C varid

 cvaluesptr = C_LOC(values)

 cstatus = nc_put_var(cncid, cvarid, cvaluesptr)

 status = cstatus

 End Function nf_put_var
!--------------------------------- nf_get_var ----------------------------
 Function nf_get_var(ncid, varid, values) RESULT(status)

! Read in a variable of any type. We use a C_CHAR character string
! to hold values. Therefore, an explicit interface to nf_get_var should NOT
! be used in the calling routine. Just use external 
! Defined in  fort-vario.c but only used in 4.0.1 for NETCDF4 builds
  
 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer,                Intent(IN)    :: ncid, varid
 Character(KIND=C_CHAR), Intent(INOUT) :: values(*)

 Integer                               :: status

 Integer(C_INT) :: cncid, cvarid,  cstatus

 cncid  = ncid
 cvarid = varid - 1 ! Subtract 1 to get C varid

 cstatus = nc_get_var(cncid, cvarid, values)

 status = cstatus

 End Function nf_get_var
!--------------------------------- nf_set_chunk_cache ------------------------
 Function nf_set_chunk_cache(chunk_size, nelems, preemption) RESULT(status)

! Set chunk cache size. Note this follows the fort-nc4 version which uses
! uses nc_set_chunk_cache_ints to avoid size_t issues with fortran. F03
! does not have these issues so we could call nc_set_chunk_cache

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN) :: chunk_size, nelems, preemption 

 Integer             :: status

 Integer(C_INT) :: cchunk_size, cnelems, cpreemption, cstatus

 cchunk_size = chunk_size
 cnelems     = nelems
 cpreemption = preemption

 cstatus = nc_set_chunk_cache_ints(cchunk_size, cnelems, cpreemption)

 status = cstatus

 End Function nf_set_chunk_cache
!--------------------------------- nf_get_chunk_cache -------------------------
 Function nf_get_chunk_cache(chunk_size, nelems, preemption) RESULT(status)

! get chunk cache size. Note this follows the fort-nc4 version which uses
! uses nc_get_chunk_cache_ints to avoid size_t issues with fortran. F03
! does not have these issues so we could call nc_set_chunk_cache

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(INOUT) :: chunk_size, nelems, preemption 

 Integer                :: status

 Integer(C_INT) :: cchunk_size, cnelems, cpreemption, cstatus

 cstatus = nc_get_chunk_cache_ints(cchunk_size, cnelems, cpreemption)

 If (cstatus == NC_NOERR) Then
    chunk_size = cchunk_size
    nelems     = cnelems
    preemption = cpreemption
 EndIf
 status = cstatus

 End Function nf_get_chunk_cache
!--------------------------------- nf_set_var_chunk_cache ---------------------
 Function nf_set_var_chunk_cache(ncid, varid, chunk_size, nelems, preemption) RESULT(status)

! Set chunk cache size. Note this follows the fort-nc4 version which uses
! uses nc_set_var_chunk_cache_ints to avoid size_t issues with fortran.

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN) :: ncid, varid, chunk_size, nelems, preemption 

 Integer             :: status

 Integer(C_INT) :: cncid, cvarid, cchunk_size, cnelems, cpreemption, &
                   cstatus

 cncid       = ncid
 cvarid      = varid-1
 cchunk_size = chunk_size
 cnelems     = nelems
 cpreemption = preemption

 cstatus = nc_set_var_chunk_cache_ints(cncid, cvarid, cchunk_size, cnelems, &
                                       cpreemption)

 status = cstatus

 End Function nf_set_var_chunk_cache
!--------------------------------- nf_get_var_chunk_cache ---------------------
 Function nf_get_var_chunk_cache(ncid, varid, chunk_size, nelems, preemption) RESULT(status)

! get chunk cache size. Note this follows the fort-nc4 version which uses
! uses nc_get_var_chunk_cache_ints to avoid size_t issues with fortran. 

 USE netcdf4_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)    :: ncid, varid 
 Integer, Intent(INOUT) :: chunk_size, nelems, preemption 

 Integer                :: status

 Integer(C_INT) :: cncid, cvarid, cchunk_size, cnelems, cpreemption, &
                   cstatus

 cncid  = ncid
 cvarid = varid-1

 cstatus = nc_get_var_chunk_cache_ints(cncid, cvarid, cchunk_size, cnelems, &
                                       cpreemption)

 If (cstatus == NC_NOERR) Then
    chunk_size = cchunk_size
    nelems     = cnelems
    preemption = cpreemption
 EndIf
 status = cstatus

 End Function nf_get_var_chunk_cache
