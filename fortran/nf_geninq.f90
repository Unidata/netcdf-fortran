!------- Routines for obtaining info on dimensions, varible sizes, etc -------

! Replacement for fort-geninq.c

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
! The author grants to UCAR the right to revise and extend the software
! without restriction. However, the author retains all copyrights and
! intellectual property rights explicit or implied by the Apache license

! Version 1.: Sept. 2005  - Initial Cray X1 version
!             April 2006  - Updated to include 3.6.1 function nf_inq_format
! Version 2.: May   2006  - Updated to support g95
! Version 3.: April 2009  - Updated to Netcdf 4.0.1 
! Version 4.: April 2010  - Updated to Netcdf 4.1.1 

!          
!-------------------------------- nf_inq ----------------------------------
 Function nf_inq(ncid, ndims, nvars, ngatts, unlimdimid) RESULT(status)

! Inquire about number of dimensions, number of varibles, number of
! global attributes, and the id of the ulimited dimension for NetCDF file
! id ncid

 USE netcdf_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)  :: ncid
 Integer, Intent(OUT) :: ndims, nvars, ngatts, unlimdimid

 Integer              :: status

 Integer(KIND=C_INT) :: cncid, cndims, cnvars, cngatts, cunlimdimid, cstatus

 cncid = ncid

 cstatus = nc_inq(cncid, cndims, cnvars, cngatts, cunlimdimid)

 ndims  = cndims
 nvars  = cnvars
 ngatts = cngatts

! Shift C id by plus one to Fortran id if unlimdimid is not -1

 If (cunlimdimid == - 1) Then
   unlimdimid  = -1
 Else
   unlimdimid = cunlimdimid + 1
 EndIf

 status = cstatus

 End Function nf_inq
!-------------------------------- nf_inq_ndims -----------------------------
 Function nf_inq_ndims(ncid, ndims) RESULT(status)

! Inquire about number of dimensions for NetCDF file id ncid

 USE netcdf_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)  :: ncid
 Integer, Intent(OUT) :: ndims

 Integer               :: status

 Integer(KIND=C_INT) :: cncid, cndims, cstatus

 cncid = ncid

 cstatus = nc_inq_ndims(cncid, cndims)

 ndims  = cndims

 status = cstatus

 End Function nf_inq_ndims
!-------------------------------- nf_inq_nvars -----------------------------
 Function nf_inq_nvars(ncid, nvars) RESULT(status)

! Inquire about number of variables for NetCDF file id ncid

 USE netcdf_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)  :: ncid
 Integer, Intent(OUT) :: nvars

 Integer              :: status

 Integer(KIND=C_INT) :: cncid, cnvars, cstatus

 cncid = ncid

 cstatus = nc_inq_nvars(cncid, cnvars)

 nvars  = cnvars

 status = cstatus

 End Function nf_inq_nvars
!-------------------------------- nf_inq_natts -----------------------------
 Function nf_inq_natts(ncid, ngatts) RESULT(status)

! Inquire about number of global attributes for NetCDF file id ncid

 USE netcdf_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)  :: ncid
 Integer, Intent(OUT) :: ngatts

 Integer              :: status

 Integer(KIND=C_INT) :: cncid, cngatts, cstatus

 cncid = ncid

 cstatus = nc_inq_natts(cncid, cngatts)

 ngatts = cngatts

 status = cstatus

 End Function nf_inq_natts
!-------------------------------- nf_inq_unlimdim --------------------------
 Function nf_inq_unlimdim(ncid, unlimdimid) RESULT(status)

! Inquire about id of unlimited dimension for NetCDF file id ncid

 USE netcdf_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)  :: ncid
 Integer, Intent(OUT) :: unlimdimid

 Integer              :: status

 Integer(KIND=C_INT) :: cncid, cunlimdimid, cstatus

 cncid = ncid

 cstatus = nc_inq_unlimdim(cncid, cunlimdimid)

! Shift C id by plus one to Fortran id if unlimdimid is not -1

 If (cunlimdimid == -1) Then
   unlimdimid = -1
 Else
   unlimdimid = cunlimdimid + 1
 EndIf

 status = cstatus

 End Function nf_inq_unlimdim
!-------------------------------- nf_inq_format -------------------------------
 Function nf_inq_format(ncid, format_type) RESULT(status)

! Inquire about internal file format for NetCDF file id ncid

 USE netcdf_nc_interfaces

 Implicit NONE

 Integer, Intent(IN)  :: ncid
 Integer, Intent(OUT) :: format_type 

 Integer              :: status

 Integer(KIND=C_INT) :: cncid, cformatp, cstatus

 cncid = ncid

 cstatus = nc_inq_format(cncid, cformatp)

! Return format_type 

 format_type = cformatp

 status = cstatus

 End Function nf_inq_format
