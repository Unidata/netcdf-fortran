SET(CMAKE_VERBOSE_MAKEFILE OFF)

SET(netcdff_SOURCES
  typeSizes.F90 module_netcdf_nc_data.F90 module_netcdf_nc_interfaces.F90
  module_netcdf_nf_data.F90 module_netcdf_nf_interfaces.F90
  module_netcdf_f03.F90
  nf_attio.F90 nf_control.F90 nf_dim.F90 nf_misc.F90
  nf_genatt.F90 nf_geninq.F90 nf_genvar.F90
  nf_vario.F90 nf_var1io.F90 nf_varaio.F90
  nf_varmio.F90 nf_varsio.F90
)

# Check if netcdf-c has parallel I/O feature enabled
IF (NETCDF_C_INCLUDE_DIR)
   file(READ "${NETCDF_C_INCLUDE_DIR}/netcdf_meta.h" header)
   string(REGEX MATCH "#define NC_HAS_PARALLEL *[01]" macrodef "${header}")
   string(REGEX MATCH "[01]" HAVE_PARALLEL "${macrodef}")
   IF (HAVE_PARALLEL)
      SET(netcdff_SOURCES ${netcdff_SOURCES} nf_nc.F90)
      MESSAGE(STATUS "Whether NetCDF-C built with paralle I/O enabled: yes")
   ELSE()
      SET(netcdff_SOURCES ${netcdff_SOURCES} nf_nc_noparallel.F90)
      MESSAGE(STATUS "Whether NetCDF-C built with paralle I/O enabled: no")
   ENDIF(HAVE_PARALLEL)
ENDIF(NETCDF_C_INCLUDE_DIR)

IF (USE_NETCDF4)
  SET(netcdff_SOURCES ${netcdff_SOURCES}
    module_netcdf4_nc_interfaces.F90
    module_netcdf4_nf_interfaces.F90 module_netcdf4_f03.F90
    nf_nc4.F90
    )
  SET(netcdff_C_SOURCES ${netcdff_C_SOURCES} nf_lib.c)
ENDIF(USE_NETCDF4)


IF (${USE_LOGGING})
  SET(netcdff_SOURCES ${netcdff_SOURCES}
    nf_logging.F90
    )
ENDIF(${USE_LOGGING})

# SET(netcdff_DEPENDENCIES
#   netcdf_attributes.F90 netcdf_constants.F90 netcdf_dims.F90
#   netcdf_expanded.F90 netcdf_externals.F90 netcdf_file.F90
#   netcdf_overloads.F90 netcdf_text_variables.F90 netcdf_variables.F90
#   netcdf_visibility.F90 netcdf_eightbyte.F90
#   )

IF (${USE_NETCDF4})
  SET(netcdff_SOURCES ${netcdff_SOURCES}
    netcdf4.F90
    )
  # SET(netcdff_DEPENDENCIES ${netcdff_DEPENDENCIES}
  #   netcdf4_func.F90 netcdf4_externals.F90 netcdf4_visibility.F90
  #   netcdf4.F90 netcdf4_eightbyte.F90
  #   netcdf4_variables.F90 netcdf4_file.F90
  #   )
ELSE ()
  SET(netcdff_SOURCES ${netcdff_SOURCES}
    netcdf.F90 netcdf3_file.F90
    )
ENDIF(${USE_NETCDF4})

if (${BUILD_V2})
  SET(netcdff_SOURCES ${netcdff_SOURCES}
    module_netcdf_fortv2_c_interfaces.F90 nf_fortv2.F90
    )
  SET(netcdff_C_SOURCES ${netcdff_C_SOURCES} nf_v2compat.c )
endif (${BUILD_V2})

if (${BUILD_F03})
  SET(LCHEADERS
    netcdf_nc_data.mod netcdf_nc_interfaces.mod netcdf_nf_data.mod
    netcdf_nf_interfaces.mod netcdf_f03.mod
    )
  if (${BUILD_V2})
    SET(LCHEADERS ${LCHEADERS}
      netcdf_fortv2_c_interfaces.mod
      )
  endif (${BUILD_V2})
  if (${USE_NETCDF4})
    SET(LCHEADERS ${LCHEADERS}
      netcdf4_nc_interfaces.mod netcdf4_nf_interfaces.mod netcdf4_f03.mod
      )
  endif (${USE_NETCDF4})
endif (${BUILD_F03})

# These are always used
SET(LCCOMMON typesizes.mod netcdf.mod)
SET(COMMONHEADERS ${LCHEADERS} ${LCCOMMON})

# SET(netcdff_DEPENDENCIES ${netcdff_DEPENDENCIES} ${COMMONHEADERS} )
SET(BUILT_SOURCES ${LCHEADERS} ${LCCOMMON})

# A macro for appending file2 to file1
MACRO(APPENDFILE file1 file2)
  file(READ ${file2} file2_bytes)
  file(APPEND ${file1} ${file2_bytes})
ENDMACRO(APPENDFILE file1 file2)

SET(NETCDF_INC ${CMAKE_CURRENT_BINARY_DIR}/netcdf.inc)
SET_DIRECTORY_PROPERTIES (PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES ${NETCDF_INC})
if (EXISTS ${NETCDF_INC})
  FILE (REMOVE ${NETCDF_INC})
endif ()

# Build netcdf.inc file from selected netcdf2, netcdf3 and netcdf4 apis
file(APPEND ${NETCDF_INC} "!     NetCDF-3.")
APPENDFILE(${NETCDF_INC} "netcdf3.inc")

if (${USE_NETCDF4})
  file(APPEND ${NETCDF_INC} "\n")
  file(APPEND ${NETCDF_INC} "!     NetCDF-4.")
  APPENDFILE(${NETCDF_INC} "netcdf4.inc")
endif (${USE_NETCDF4})

if (${BUILD_V2})
  file(APPEND ${NETCDF_INC} "\n")
  file(APPEND ${NETCDF_INC} "!     NetCDF-2.")
  APPENDFILE(${NETCDF_INC} "netcdf2.inc")
endif (${BUILD_V2})

if (${USE_LOGGING})
  file(APPEND ${NETCDF_INC} "\n")
  file(APPEND ${NETCDF_INC} "!     This is to turn on netCDF internal logging.")
  file(APPEND ${NETCDF_INC} "      integer nf_set_log_level")
  file(APPEND ${NETCDF_INC} "      external nf_set_log_level")
endif (${USE_LOGGING})

SET(BUILT_SOURCES ${BUILT_SOURCES} netcdf.inc)

include_directories(${CMAKE_SOURCE_DIR} ${CMAKE_SOURCE_DIR}/libsrc)

# Default to shared libs on
OPTION(BUILD_SHARED_LIBS "Configure netCDF as a shared library." ON)
SET (LIB_TYPE STATIC)
IF (BUILD_SHARED_LIBS)
  SET(LIB_TYPE SHARED)
  set(CMAKE_POSITION_INDEPENDENT_CODE ON)
ENDIF()

# This is what we are building: a convenience library of Fortran 2003 functions.
# This just builds SHARED, even though STATIC is also specified
# ADD_LIBRARY(netcdff STATIC SHARED ${netcdff_SOURCES})
# Builds only static, not shared
# Compile C-code to object, then link with Fortran
ADD_LIBRARY(netcdff_c OBJECT ${netcdff_C_SOURCES})
install(TARGETS netcdff_c OBJECTS DESTINATION lib)
# or is this better?   list(APPEND NETCDF_C_LIBRARY netcdff_c)
SET(NETCDF_C_LIBRARY ${NETCDF_C_LIBRARY} netcdff_c)
set_target_properties(netcdff_c PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${NETCDF_C_INCLUDE_DIR}"
  )
target_include_directories(netcdff_c PUBLIC "${NETCDF_C_INCLUDE_DIR}")

ADD_LIBRARY(netcdff ${netcdff_SOURCES})
TARGET_LINK_LIBRARIES(netcdff PUBLIC netCDF::netcdf)
TARGET_LINK_LIBRARIES(netcdff PRIVATE ${NETCDF_C_LIBRARY})
TARGET_LINK_LIBRARIES(netcdff PUBLIC ${EXTRA_DEPS})
SET_TARGET_PROPERTIES(netcdff PROPERTIES
                      VERSION ${NC4F_LIB_VERSION}
                      SOVERSION ${NC4F_SO_VERSION}
                      )
target_include_directories(netcdff PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
  $<INSTALL_INTERFACE:include>
  )

if (HAVE_NC_USE_PARALLEL_ENABLED)
  target_link_libraries(netcdff PUBLIC MPI::MPI_Fortran)
endif()

# copied from netcdf-c... Changed from ADD_DEFINITIONS to TARGET_COMPILE_DEFINITIONS
# Option to Build DLL
IF(WIN32)
  OPTION(LINK_TO_SHARED_LIBS "Link to netcdf-c shared library" ON)
  IF(LINK_TO_SHARED_LIBS)
    TARGET_COMPILE_DEFINITIONS(netcdff_c PRIVATE DLL_NETCDF)
  ENDIF()
ENDIF()

##
# Configuration for post-install RPath
# Adapted from http://www.cmake.org/Wiki/CMake_RPATH_handling
##
IF(NOT MSVC)
  # use, i.e. don't skip the full RPATH for the build tree
  SET(CMAKE_SKIP_BUILD_RPATH  FALSE)

  # when building, don't use the install RPATH already
  # (but later on when installing)
  SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

  SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}")

  # add the automatically determined parts of the RPATH
  # which point to directories outside the build tree to the install RPATH
  SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

  # the RPATH to be used when installing, but only if it's not a system directory
  LIST(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}" isSystemDir)
  IF("${isSystemDir}" STREQUAL "-1")
    SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}")
  ENDIF("${isSystemDir}" STREQUAL "-1")
ENDIF()

# Installation of the program
INSTALL(TARGETS netcdff netcdff_c
    EXPORT netcdffTargets
    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}" COMPONENT bin
    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}" COMPONENT shlib
    ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}" COMPONENT shlib
    )
INSTALL(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/
        DESTINATION "${Fortran_INSTALL_MODDIR}"
        FILES_MATCHING PATTERN "*.mod" PATTERN "netcdf.inc"
        )
