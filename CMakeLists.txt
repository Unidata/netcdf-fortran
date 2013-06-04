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
SET(NC_BUILD_F90 "OFF")
SET(NC_BUILD_V2 "ON")
SET(NC_BUILD_F03 "ON")

# Recurse into other subdirectories.
# Only use nfconfig.inc, built by configure from nfconfig.in
# ADD_SUBDIRECTORY(libsrc)
ADD_SUBDIRECTORY(fortran)
TARGET_LINK_LIBRARIES(netcdff)
# Build the Fortran examples
# ADD_SUBDIRECTORY(examples)
# Build the old f77 API
# ADD_SUBDIRECTORY(F77)
# ADD_SUBDIRECTORY(F90)
# ADD_SUBDIRECTORY(nf_test)
# ADD_SUBDIRECTORY(nf03_test)
# ADD_SUBDIRECTORY(man4)
print_conf_summary()
