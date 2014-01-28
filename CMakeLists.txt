## This is a CMake file, part of Unidata's netCDF Fortran package.
# Copyright 2012-2014, see the COPYRIGHT file for more information.

##################################
# Set Project Properties
##################################

#Minimum required CMake Version
cmake_minimum_required(VERSION 2.8)

#Project Name for netCDF-Fortran
PROJECT (NC4F Fortran C)
set(PACKAGE "netcdf-fortran" CACHE STRING "")
#Project Version
SET(NC4F_VERSION_MAJOR 4)
SET(NC4F_VERSION_MINOR 4)
SET(NC4F_VERSION_PATCH 0)
SET(NC4F_VERSION_NOTE "-rc1")
SET(NC4F_VERSION ${NC4F_VERSION_MAJOR}.${NC4F_VERSION_MINOR}.${NC4F_VERSION_PATCH}${NC4F_VERSION_NOTE})
SET(VERSION ${NC4F_VERSION})
SET(NC4F_SO_VERSION 0.0.0)

# Get system configuration,
# Use it to determine osname,
# os release, cpu. These will be used
# when committing to CDash.
find_program(UNAME NAMES uname)
IF(UNAME)
macro(getuname name flag)
        exec_program("${UNAME}" ARGS "${flag}" OUTPUT_VARIABLE "${name}")
endmacro(getuname)
getuname(osname -s)
getuname(osrel  -r)
getuname(cpu    -m)
set(BUILDNAME        "${osname}-${osrel}-${cpu}" CACHE STRING "Build name variable for CDash")
ENDIF()

# For CMAKE_INSTALL_LIBDIR
INCLUDE(GNUInstallDirs)

IF(MSVC)
  SET(GLOBAL PROPERTY USE_FOLDERS ON)
ENDIF()

# auto-configure style checks, other CMake modules.
INCLUDE (${CMAKE_ROOT}/Modules/CheckLibraryExists.cmake)
INCLUDE (${CMAKE_ROOT}/Modules/CheckIncludeFile.cmake)
INCLUDE (${CMAKE_ROOT}/Modules/CheckTypeSize.cmake)
INCLUDE (${CMAKE_ROOT}/Modules/CheckFunctionExists.cmake)
INCLUDE (${CMAKE_ROOT}/Modules/CheckCXXSourceCompiles.cmake)
INCLUDE (${CMAKE_ROOT}/Modules/TestBigEndian.cmake)
INCLUDE (${CMAKE_ROOT}/Modules/CheckSymbolExists.cmake)
INCLUDE (${CMAKE_ROOT}/Modules/GetPrerequisites.cmake)
FIND_PACKAGE(PkgConfig QUIET)

# Enable 'dist and distcheck'.
# File adapted from http://ensc.de/cmake/FindMakeDist.cmake
# TODO: this can't currently be found, need
# FIND_PACKAGE(MakeDist)
# End 'enable dist and distcheck'

# Set the build type.
IF (NOT CMAKE_BUILD_TYPE)
	SET (CMAKE_BUILD_TYPE DEBUG CACHE STRING "Choose the type of build, options are: None, Debug, Release."
		FORCE)
ENDIF()

get_filename_component (Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME)

################################
# End Project Properties
################################


################################
# Set CTest Properties
################################

ENABLE_TESTING()
INCLUDE(CTest)

# Copy the CTest customization file into binary directory, as required.
# TODO: need to provide suitable CTestCustom.cmake
# FILE(COPY ${CMAKE_SOURCE_DIR}/CTestCustom.cmake DESTINATION ${CMAKE_BINARY_DIR})

# Set Memory test program for non-MSVC based builds.
# Assume valgrind for now.
IF(NOT MSVC)
	SET (CTEST_MEMORYCHECK_COMMAND valgrind CACHE STRING "")
ENDIF()

# Set variable to define the build type.
INCLUDE(GenerateExportHeader)

################################
# End CTest Properties
################################


################################
# Compiler Configuration
################################


# Default to shared libs on.
OPTION(BUILD_SHARED_LIBS "Configure netCDF as a shared library." ON)
SET (LIB_TYPE STATIC)
IF (BUILD_SHARED_LIBS)
	SET(LIB_TYPE SHARED)
	IF(CMAKE_COMPILER_IS_GNUCC OR APPLE)
		SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
	ENDIF()
ENDIF()

# Supress unused variable and parameter warnings, for the time being,
# on GCC.
#
# Also, set some other default compiler flags.
IF(CMAKE_COMPILER_IS_GNUCC OR APPLE)
  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -Wall -Wno-unused-variable -Wno-unused-parameter")
ENDIF()

IF(NOT ENABLE_COVERAGE_TESTS)
  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2")
ENDIF()


ADD_DEFINITIONS()

# Supress CRT Warnings.
# Only necessary for Windows
IF(MSVC)
	ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS)
ENDIF()


################################
# End Compiler Configuration
################################


################################
# Define Utility Macros
################################

# Macro to append files to the EXTRA_DIST files.
SET(EXTRA_DIST "")
MACRO(ADD_EXTRA_DIST files)
  FOREACH(F ${files})
    SET(EXTRA_DIST ${EXTRA_DIST} ${CMAKE_CURRENT_SOURCE_DIR}/${F})
    SET(EXTRA_DIST ${EXTRA_DIST} PARENT_SCOPE)
  ENDFOREACH()
ENDMACRO()

# A basic script used to convert m4 files
FIND_PROGRAM(NC4F_M4 NAMES m4)
MACRO(GEN_m4 filename)
	IF(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${filename}.c)
	ADD_CUSTOM_COMMAND(
		OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/${filename}.c
		COMMAND ${NC4F_M4} 
		ARGS ${CMAKE_CURRENT_SOURCE_DIR}/${filename}.m4 > ${CMAKE_CURRENT_SOURCE_DIR}/${filename}.c
		VERBATIM
	)
	ENDIF()
ENDMACRO(GEN_m4)

# [LEFT OFF HERE] replacing macros with ones from netcdf-c macros using NC4F_prefix

# Binary tests, but ones which depend on value of 'TEMP_LARGE' being defined.
MACRO(add_bin_env_temp_large_test prefix F)
	ADD_EXECUTABLE(${prefix}_${F} ${F}.c)
	TARGET_LINK_LIBRARIES(${prefix}_${F} netcdf)
	IF(MSVC)
		SET_TARGET_PROPERTIES(${prefix}_${F} 
			PROPERTIES LINK_FLAGS_DEBUG " /NODEFAULTLIB:MSVCRT"
			)
	ENDIF()


	ADD_TEST(${prefix}_${F} bash "-c" "TEMP_LARGE=${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}/${prefix}_${F}")
	IF(MSVC)
		SET_PROPERTY(TARGET ${prefix}_${F} PROPERTY FOLDER "tests")
	ENDIF()
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


MACRO(add_bin_test prefix F)
	ADD_EXECUTABLE(${prefix}_${F} ${F}.c)
	TARGET_LINK_LIBRARIES(${prefix}_${F} netcdf)
	IF(MSVC)
		SET_TARGET_PROPERTIES(${prefix}_${F} 
			PROPERTIES LINK_FLAGS_DEBUG " /NODEFAULTLIB:MSVCRT"
			)
	ENDIF()
	ADD_TEST(${prefix}_${F} ${EXECUTABLE_OUTPUT_PATH}/${prefix}_${F})
	IF(MSVC)
		SET_PROPERTY(TEST ${prefix}_${F} PROPERTY FOLDER "tests/")
	ENDIF()	
ENDMACRO()

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
	MESSAGE(STATUS "\tBuilding Utilities:\t\t" ${BUILD_UTILITIES})
	IF(CMAKE_PREFIX_PATH)
		MESSAGE(STATUS "\tCMake Prefix Path:\t\t" "${CMAKE_PREFIX_PATH}")
	ENDIF()
	MESSAGE(STATUS "\tUsing pnetcdf:\t\t\t" ${STATUS_PNETCDF})
	MESSAGE(STATUS "\tUsing Parallel IO:\t\t" ${STATUS_PARALLEL})
	MESSAGE(STATUS "\tLinking against:\t\t" "${ALL_TLL_LIBS}") 

	MESSAGE("")

ENDMACRO()
# Shell script Macro
MACRO(add_sh_test prefix F)
	IF(NOT MSVC)
		ADD_TEST(${prefix}_${F} bash "-c" "export srcdir=${CMAKE_CURRENT_SOURCE_DIR};export TOPSRCDIR=${CMAKE_SOURCE_DIR};${CMAKE_CURRENT_BINARY_DIR}/${F}.sh")
	ENDIF()

ENDMACRO()


# Macro for replacing '/MD' with '/MT'.
# Used only on Windows, /MD tells VS to use the shared
# CRT libs, MT tells VS to use the static CRT libs.
#
# Taken From:
# 	http://www.cmake.org/Wiki/CMake_FAQ#How_can_I_build_my_MSVC_application_with_a_static_runtime.3F
#
MACRO(specify_static_crt_flag) 

  SET(vars 
    CMAKE_C_FLAGS
    CMAKE_C_FLAGS_DEBUG
    CMAKE_C_FLAGS_MINSIZEREL
    CMAKE_C_FLAGS_RELWITHDEBINFO
    CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG
    CMAKE_CXX_FLAGS_RELEASE CMAKE_CXX_FLAGS_MINSIZEREL
    CMAKE_CXX_FLAGS_RELWITHDEBINFO)
  
  FOREACH(flag_var ${vars})
    IF(${flag_var} MATCHES "/MD")
      STRING(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
    ENDIF()
  ENDFOREACH()			    
  
  FOREACH(flag_var ${vars})
    MESSAGE(STATUS " '${flag_var}': ${${flag_var}}")
  ENDFOREACH()
  MESSAGE(STATUS "")

ENDMACRO()

################################
# End Macro Definitions
################################


#Add custom CMake Module
SET (CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules/"
    CACHE INTERNAL "Location of our custom CMake modules.")

SET(CMAKE_BUILD_TYPE Debug)
SET(CMAKE_Fortran_COMPILER gfortran)
SET(USE_LOGGING "ON")

#####
# Some utility macros/scripts.

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

OPTION(BUILD_SHARED_LIBS "Configure netcdff as a shared library." ON)
OPTION(LARGE_FILE_TESTS "Run large file tests, which are slow and take lots of disk." OFF)
OPTION(BUILD_BENCHMARKS "Run F90 I/O Benchmarks" OFF)
OPTION(TEST_WITH_VALGRIND "Run extra tests with valgrind" OFF)
OPTION(TEST_PARALLEL "Run parallel I/O tests for F90 and F77" OFF)
OPTION (ENABLE_NETCDF_4 "Enable netCDF-4" ON)
IF(ENABLE_NETCDF_4)  # TODO: Seems like we should just use one of these
	SET(USE_NETCDF4 ON CACHE BOOL "")
	SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DUSE_NETCDF4")
	SET(ENABLE_NETCDF_4 ON CACHE BOOL "")
	SET(ENABLE_NETCDF4 ON CACHE BOOL "")
ENDIF()
IF (UNIX AND ${CMAKE_SIZEOF_VOID_P} MATCHES "8")
	SET (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DLONGLONG_IS_LONG -fmacro-backtrace-limit=0")
ENDIF()
# assume gfortran. Intel and nag don't seem to be supported in cfortran.h
if (Fortran_COMPILER_NAME MATCHES "^gfortran*" OR Fortran_COMPILER_NAME MATCHES "^f95")
#  gFortran is used in cfortran.h
   SET (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DgFortran ")
   
   SET(TEST_C_PTRDIFF_T_F90 
     "${CMAKE_CURRENT_SOURCE_DIR}/CMakeExtras/test_c_ptrdiff_t.f90")
   SET(TEST_C_PTRDIFF_T_OBJ 
     "${CMAKE_CURRENT_BINARY_DIR}/test_c_ptrdiff_t")
   EXECUTE_PROCESS (
	COMMAND ${CMAKE_Fortran_COMPILER} -o ${TEST_C_PTRDIFF_T_OBJ} ${TEST_C_PTRDIFF_T_F90}
    RESULT_VARIABLE COMPILE_FAILED ERROR_QUIET)
    FILE (REMOVE ${TEST_C_PTRDIFF_T_OBJ})    
    IF (COMPILE_FAILED)
        # if the compile returns 1 - the compile failed => C_PTRDIFF_T is not defined
    	# get sizeof of ptrdiff_t
    	SET (SIZEOF_PTRDIFF_T_C 
    	  "${CMAKE_CURRENT_SOURCE_DIR}/CMakeExtras/sizeof_ptrdiff_t.c")
    	SET (SIZEOF_PTRDIFF_T_OBJ 
    	  "${CMAKE_CURRENT_BINARY_DIR}/sizeof_ptrdiff_t")
	   EXECUTE_PROCESS (
		COMMAND ${CMAKE_C_COMPILER} -o ${SIZEOF_PTRDIFF_T_OBJ} ${SIZEOF_PTRDIFF_T_C})
	   EXECUTE_PROCESS (COMMAND ${SIZEOF_PTRDIFF_T_OBJ} 
	     OUTPUT_VARIABLE SIZEOF_PTRDIFF_T 
	     RESULT_VARIABLE SIZEOF_RESULT)
		IF (SIZEOF_RESULT)
			MESSAGE (ERROR "UNABLE TO DETERMINE SIZEOF PTRDIFF_T")	
		ELSE (SIZEOF_RESULT)
			SET (CMAKE_Fortran_FLAGS 
				"-DSIZEOF_PTRDIFF_T=${SIZEOF_PTRDIFF_T} ${CMAKE_Fortran_FLAGS}")
		ENDIF (SIZEOF_RESULT)
		FILE (REMOVE ${SIZEOF_PTRDIFF_T_OBJ})
	else (COMPILE_FAILED)
		SET (CMAKE_Fortran_FLAGS "-DHAVE_TS29113_SUPPORT ${CMAKE_Fortran_FLAGS}")
    endif(COMPILE_FAILED)
endif ()

OPTION (ENABLE_NETCDF_V2 "Support old netCDF version-2 Fortran API" OFF)
IF(ENABLE_NETCDF_V2) # TODO: Can we just use one of these?
	SET(BUILD_V2 ON CACHE BOOL "")
ENDIF()
# Turn this on by default when it's working
OPTION(ENABLE_FORTRAN_TYPE_CHECKS 
  "Determine Fortran types corresponding to netCDF types" OFF)

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
SET (ENABLE_LOGGING "ON")
IF(ENABLE_LOGGING)
	SET(USE_LOGGING ON CACHE BOOL "")
ENDIF()

# Set the default fortran builds; default is to build f03
SET(BUILD_F90 "ON")
SET(BUILD_V2 "ON")
SET(BUILD_F03 "OFF")

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
configure_file("${NC4F_SOURCE_DIR}/libsrc/nfconfig.in.cmake" 
  "${NC4F_BINARY_DIR}/libsrc/nfconfig.inc")
# Create config.h file
configure_file("${NC4F_SOURCE_DIR}/config.h.in.cmake"
	"${NC4F_BINARY_DIR}/config.h")

# Create nf-config file: TODO
# FILE(MAKE_DIRECTORY ${NC4F_BINARY_DIR}/tmp)
# configure_file("${NC4F_SOURCE_DIR}/nf-config.in.cmake"
#   "${NC4F_BINARY_DIR}/tmp/nf-config" @ONLY)
# FILE(COPY "${NC4F_BINARY_DIR}/tmp/nf-config"
#    DESTINATION ${NC4F_BINARY_DIR}/
#    FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
# For now, just copy a stub file
FILE(COPY "${NC4F_SOURCE_DIR}/nf-config.in.cmake"
   DESTINATION "${NC4F_BINARY_DIR}"
   FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
FILE(RENAME "${NC4F_BINARY_DIR}/nf-config.in.cmake" "${NC4F_BINARY_DIR}/nf-config")

# make sure previous two files get cleaned up...
SET_DIRECTORY_PROPERTIES (DIRECTORY PROPERTY ADDITIONAL_MAKE_CLEAN_FILES ${netcdf-fortran_BINARY_DIR}/config.h ${netcdf-fortran_BINARY_DIR}/nf-config)

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

INSTALL(PROGRAMS ${NC4F_BINARY_DIR}/nf-config DESTINATION bin COMPONENT utilities)

INCLUDE_DIRECTORIES(${NC4F_BINARY_DIR})
# End autotools-style checks for config.h

# Recurse into other subdirectories.
ADD_SUBDIRECTORY(fortran)
#TARGET_LINK_LIBRARIES(netcdff netcdf)
ADD_SUBDIRECTORY(libsrc)
ADD_SUBDIRECTORY(nf_test)
ADD_SUBDIRECTORY(nf03_test)
# Build the Fortran examples
ADD_SUBDIRECTORY(examples)
ADD_SUBDIRECTORY(man4)
print_conf_summary()
