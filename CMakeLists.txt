cmake_minimum_required(VERSION 2.8)

# CMake project file for netcdf-fortran
PROJECT (netcdf-fortran Fortran C)

SET(netcdf-fortran_VERSION_MAJOR 4)
SET(netcdf-fortran_VERSION_MINOR 4)

SET(CMAKE_BUILD_TYPE Debug)
SET(CMAKE_Fortran_COMPILER gfortran)
SET(USE_LOGGING "OFF")

# Default to shared libs on
OPTION(BUILD_SHARED_LIBS "Configure netcdff as a shared library." ON)
OPTION(LARGE_FILE_TESTS "Run large file tests, which are slow and take lots of disk." OFF)
OPTION(BUILD_BENCHMARKS "Run F90 I/O Benchmarks" OFF)
OPTION(TEST_PARALLEL "Run parallel I/O tests for F90 and F77" OFF)

# A basic script used to convert m4 files
MACRO(GEN_m4 filename)
	IF(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${filename}.F)
	ADD_CUSTOM_COMMAND(
		OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/${filename}.F
		COMMAND m4 
		ARGS ${CMAKE_CURRENT_SOURCE_DIR}/${filename}.m4 > ${CMAKE_CURRENT_SOURCE_DIR}/${filename}.F
		VERBATIM
	)
	ENDIF()
ENDMACRO(GEN_m4)

# A script to print out information at the end of the configuration step.
MACRO(print_conf_summary)
	MESSAGE("")
	MESSAGE("")
	MESSAGE(STATUS "CMake Summary:")
	MESSAGE("")
	MESSAGE(STATUS "\tBuild Type:\t\t\t" ${CMAKE_BUILD_TYPE})
	MESSAGE(STATUS "\tBuilding Shared Libraries:\t" ${BUILD_SHARED_LIBS})
	MESSAGE(STATUS "\tBuilding netCDF-4:\t\t" ${ENABLE_NETCDF_4})
	MESSAGE(STATUS "\tBuilding DAP Support:\t\t" ${ENABLE_DAP})
	IF(CMAKE_PREFIX_PATH)
		MESSAGE(STATUS "\tCMake Prefix Path:\t\t" "${CMAKE_PREFIX_PATH}")
	ENDIF()
	MESSAGE(STATUS "\tUsing pnetcdf:\t\t\t" ${STATUS_PNETCDF})
	MESSAGE(STATUS "\tUsing Parallel IO:\t\t" ${STATUS_PARALLEL})
	MESSAGE(STATUS "\tLinking against:\t\t" "${ALL_TLL_LIBS}") 

	MESSAGE("")

ENDMACRO()

# Build netCDF4
OPTION (ENABLE_NETCDF_4 "Enable netCDF-4" ON)
IF(ENABLE_NETCDF_4)
	SET(USE_NETCDF4 ON CACHE BOOL "")
	SET(ENABLE_NETCDF_4 ON CACHE BOOL "")
	SET(ENABLE_NETCDF4 ON CACHE BOOL "")
ENDIF()

# Support old version-2 API for backward compatibility
# OPTION (ENABLE_NETCDF_V2 "Support old netCDF version-2 Fortran API" OFF)
OPTION (ENABLE_NETCDF_V2 "Support old netCDF version-2 Fortran API" ON)
IF(ENABLE_NETCDF_V2)
	SET(BUILD_V2 ON CACHE BOOL "")
ENDIF()

# Support old version-2 API for backward compatibility
SET (ENABLE_LOGGING "OFF")
IF(ENABLE_LOGGING)
	SET(USE_LOGGING ON CACHE BOOL "")
ENDIF()

# Set the default fortran builds; default is to build f03
SET(BUILD_F90 "OFF")
SET(BUILD_V2 "ON")
SET(BUILD_F03 "ON")

# Set Fortran types to default.  The configure file got these by testing an F77 program,
# invoking UD_FORTRAN_TYPES defined in acinclude.m4.  TODO: check the types from the test
# program instead of assuming these defaults.
SET(NCBYTE_T "byte")
SET(NCBYTE_T "byte")
SET(NCSHORT_T "integer*2")
SET(NF_INT1_T "byte")
SET(NF_INT2_T "integer*2")
# Default is for following to be true.  TODO: test instead
SET(NF_INT1_IS_C_SIGNED_CHAR "1")
SET(NF_INT2_IS_C_SHORT "1")
SET(NF_INT_IS_C_INT "1")
SET(NF_REAL_IS_C_FLOAT "1")
SET(NF_DOUBLEPRECISION_IS_C_DOUBLE "1")

ENABLE_TESTING()
INCLUDE(CTest)

# Create libsrc/nfconfig.inc (don't need nfconfig1.inc temporary file used with autoconf)
configure_file("${netcdf-fortran_SOURCE_DIR}/libsrc/nfconfig.in.cmake" 
  "${netcdf-fortran_BINARY_DIR}/libsrc/nfconfig.inc")
# Create config.h file
configure_file("${netcdf-fortran_SOURCE_DIR}/config.h.in.cmake"
	"${netcdf-fortran_BINARY_DIR}/config.h")
# Create nf-config file
FILE(MAKE_DIRECTORY ${netcdf-fortran_BINARY_DIR}/tmp)
configure_file("${netcdf-fortran_SOURCE_DIR}/nf-config.in.cmake"
  "${netcdf-fortran_BINARY_DIR}/tmp/nf-config")
FILE(COPY "${netcdf-fortran_BINARY_DIR}/tmp/nf-config"
  DESTINATION ${netcdf-fortran_BINARY_DIR}/
  FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

# Recurse into other subdirectories.
# Only use nfconfig.inc, built by configure from nf-config.in
ADD_SUBDIRECTORY(fortran)
TARGET_LINK_LIBRARIES(netcdff)
ADD_SUBDIRECTORY(libsrc)
ADD_SUBDIRECTORY(nf_test)
ADD_SUBDIRECTORY(nf03_test)
# Build the Fortran examples
# ADD_SUBDIRECTORY(examples)
# Build the old f77 API
# ADD_SUBDIRECTORY(F77)
# ADD_SUBDIRECTORY(F90)
# ADD_SUBDIRECTORY(man4)
print_conf_summary()
