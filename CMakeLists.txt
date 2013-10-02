cmake_minimum_required(VERSION 2.8)

# CMake project file for netcdf-fortran
PROJECT (netcdf-fortran Fortran C)

SET(netcdf-fortran_VERSION_MAJOR 4)
SET(netcdf-fortran_VERSION_MINOR 4)

SET(CMAKE_BUILD_TYPE Debug)
SET(CMAKE_Fortran_COMPILER gfortran)
SET(USE_LOGGING "OFF")

#####
# Some utility macros/scripts.
#####
# Macro to append files to the EXTRA_DIST files.
#####
SET(EXTRA_DIST "")
MACRO(ADD_EXTRA_DIST files)
  FOREACH(F ${files})
    SET(EXTRA_DIST ${EXTRA_DIST} ${CMAKE_CURRENT_SOURCE_DIR}/${F})
    SET(EXTRA_DIST ${EXTRA_DIST} PARENT_SCOPE)
  ENDFOREACH()
ENDMACRO()

# Tests which are binary, but depend on a particular environmental variable.
MACRO(add_bin_env_test prefix F)
	ADD_EXECUTABLE(${prefix}_${F} ${F}.c)
	TARGET_LINK_LIBRARIES(${prefix}_${F} netcdf)
	IF(MSVC)
		SET_TARGET_PROPERTIES(${prefix}_${F} 
			PROPERTIES LINK_FLAGS_DEBUG " /NODEFAULTLIB:MSVCRT"
			)
	ENDIF()


	ADD_TEST(${prefix}_${F} bash "-c" "TOPSRCDIR=${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}/${prefix}_${F}")
	IF(MSVC)
		SET_PROPERTY(TARGET ${prefix}_${F} PROPERTY FOLDER "tests")
	ENDIF()
ENDMACRO()

# Build a binary used by a script, but don't make a test out of it.
MACRO(build_bin_test F) 
	ADD_EXECUTABLE(${F} ${F}.c)
	TARGET_LINK_LIBRARIES(${F} netcdf)
	IF(MSVC)
		SET_TARGET_PROPERTIES(${F} 
			PROPERTIES LINK_FLAGS_DEBUG " /NODEFAULTLIB:MSVCRT"
		)
	ENDIF()
ENDMACRO()

# Binary tests which are used by a script looking for a specific name.
MACRO(add_bin_test_no_prefix F)
	build_bin_test(${F})
	ADD_TEST(${F} ${EXECUTABLE_OUTPUT_PATH}/${F})
	IF(MSVC)
		SET_PROPERTY(TEST ${F} PROPERTY FOLDER "tests/")
	ENDIF()	
ENDMACRO()

# Binary tests which are used by a script looking for a specific name.
MACRO(build_bin_test_no_prefix F)
	build_bin_test(${F})
	ADD_TEST(${F} ${EXECUTABLE_OUTPUT_PATH}/${F})
	IF(MSVC)
		SET_PROPERTY(TEST ${F} PROPERTY FOLDER "tests/")
	ENDIF()	
ENDMACRO()


#MACRO(add_bin_test prefix F)
#	ADD_EXECUTABLE(${prefix}_${F} ${F}.f)
#	TARGET_LINK_LIBRARIES(${prefix}_${F} netcdff netcdf)
#	IF(MSVC)
#		SET_TARGET_PROPERTIES(${prefix}_${F} 
#			PROPERTIES LINK_FLAGS_DEBUG " /NODEFAULTLIB:MSVCRT"
#			)
#	ENDIF()
#	ADD_TEST(${prefix}_${F} ${EXECUTABLE_OUTPUT_PATH}/${prefix}_${F})
#	IF(MSVC)
#		SET_PROPERTY(TEST ${prefix}_${F} PROPERTY FOLDER "tests/")
#	ENDIF()	
#ENDMACRO()

OPTION(BUILD_SHARED_LIBS "Configure netcdff as a shared library." ON)
OPTION(LARGE_FILE_TESTS "Run large file tests, which are slow and take lots of disk." OFF)
OPTION(BUILD_BENCHMARKS "Run F90 I/O Benchmarks" OFF)
OPTION(TEST_WITH_VALGRIND "Run extra tests with valgrind" OFF)
OPTION(TEST_PARALLEL "Run parallel I/O tests for F90 and F77" OFF)
OPTION (ENABLE_NETCDF_4 "Enable netCDF-4" ON)
IF(ENABLE_NETCDF_4)  # TODO: Seems like we should just use one of these
	SET(USE_NETCDF4 ON CACHE BOOL "")
	SET(ENABLE_NETCDF_4 ON CACHE BOOL "")
	SET(ENABLE_NETCDF4 ON CACHE BOOL "")
ENDIF()
OPTION (ENABLE_NETCDF_V2 "Support old netCDF version-2 Fortran API" ON)
IF(ENABLE_NETCDF_V2) # TODO: Can we just use one of these?
	SET(BUILD_V2 ON CACHE BOOL "")
ENDIF()
# Turn this on by default when it's working
OPTION(ENABLE_FORTRAN_TYPE_CHECKS 
  "Determine Fortran types corresponding to netCDF types" OFF)

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

# Support old version-2 API for backward compatibility
SET (ENABLE_LOGGING "OFF")
IF(ENABLE_LOGGING)
	SET(USE_LOGGING ON CACHE BOOL "")
ENDIF()

# Set the default fortran builds; default is to build f03
SET(BUILD_F90 "OFF")
SET(BUILD_V2 "ON")
SET(BUILD_F03 "ON")

IF(ENABLE_FORTRAN_TYPE_CHECKS)
  # Do tests to determine which Fortran types correspond to NCBYTE, NCSHORT, ...
  # The configure file got these by testing an F77 program, invoking
  # UD_FORTRAN_TYPES defined in acinclude.m4.  TODO: check the types
  # from the test program instead of assuming these defaults.
ELSE()
  # Set Fortran types to default.  
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
ENDIF(ENABLE_FORTRAN_TYPE_CHECKS)

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
  "${netcdf-fortran_BINARY_DIR}/tmp/nf-config" @ONLY)
FILE(COPY "${netcdf-fortran_BINARY_DIR}/tmp/nf-config"
  DESTINATION ${netcdf-fortran_BINARY_DIR}/
  FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

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

	SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")

	# add the automatically determined parts of the RPATH
	# which point to directories outside the build tree to the install RPATH
	SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

	# the RPATH to be used when installing, but only if it's not a system directory
	LIST(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CMAKE_INSTALL_PREFIX}/lib" isSystemDir)
	IF("${isSystemDir}" STREQUAL "-1")
		SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
	ENDIF("${isSystemDir}" STREQUAL "-1")
ENDIF()

##
# End configuration for post-install RPath
##

INSTALL(PROGRAMS ${netCDF_BINARY_DIR}/nf-config DESTINATION bin COMPONENT utilities)
INCLUDE_DIRECTORIES(${netcdf-fortran_BINARY_DIR})
# End autotools-style checks for config.h

# Recurse into other subdirectories.
ADD_SUBDIRECTORY(fortran)
TARGET_LINK_LIBRARIES(netcdff)
ADD_SUBDIRECTORY(libsrc)
ADD_SUBDIRECTORY(nf_test)
ADD_SUBDIRECTORY(nf03_test)
# Build the Fortran examples
ADD_SUBDIRECTORY(examples)
ADD_SUBDIRECTORY(man4)
print_conf_summary()
