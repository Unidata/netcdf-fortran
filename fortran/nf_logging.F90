#ifdef LOGGING
! Function to turn on logging

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

! Version 1. May 2014 - initial implemenation
! Version 2. Jan 2016 - Fixed hanging comma in status definition

!-------------------------------- nf_set_log_level ----------------------------
 Function nf_set_log_level(new_level) Result(status)

 USE ISO_C_BINDING, ONLY: C_INT

 Implicit NONE

 Integer, Intent(IN) :: new_level

 Integer             :: status

 Integer(C_INT) :: cnew_level, cstatus

 Interface  ! define binding here instead of nc_interfaces since its conditional
  Function nc_set_log_level(new_level) BIND(C)
   USE ISO_C_BINDING, ONLY: C_INT

   Integer(C_INT), VALUE :: new_level
   Integer(C_INT)        :: nc_set_log_level
 End Function nc_set_log_level
End Interface

 cnew_level = new_level
 cstatus    = nc_set_log_level(cnew_level)

 status = cstatus

End Function nf_set_log_level

#endif
