#                                               -*- Autoconf -*-
# This is part of Unidata's netCDF package. Copyright 2011-2019, see
# the COPYRIGHT file for more information.

# Ed Hartnett, Russ Rew, Dennis Heimbigner, Ward Fisher

# Running autoconf on this file will trigger a warning if
# autoconf is not at least the specified version.
AC_PREREQ([2.59])

# Initialize with name, version, and support email address.

AC_INIT([netCDF-Fortran], [4.6.3-development], [support-netcdf@unidata.ucar.edu])


# Create the VERSION file, which contains the package version from
# AC_INIT.
echo -n AC_PACKAGE_VERSION>VERSION
AC_SUBST(PACKAGE_VERSION)
AC_MSG_NOTICE([netCDF-Fortran AC_PACKAGE_VERSION])

# Configuration Date
if test "x$SOURCE_DATE_EPOCH" != "x" ; then
    AC_SUBST([CONFIG_DATE]) CONFIG_DATE="`date -u -d "${SOURCE_DATE_EPOCH}"`"
else
    AC_SUBST([CONFIG_DATE]) CONFIG_DATE="`date`"
fi

# Keep libtool macros in an m4 directory.
AC_CONFIG_MACRO_DIR([m4])

# Find out about the host we're building on.
AC_CANONICAL_HOST

# Find out about the target we're building for.
AC_CANONICAL_TARGET

# This call is required by automake.
AM_INIT_AUTOMAKE([1.13 foreign dist-zip subdir-objects])
#AM_MAINTAINER_MODE()

AC_MSG_NOTICE([checking user options])

AC_COMPILE_IFELSE([AC_LANG_PROGRAM([], [[
#include <netcdf_meta.h>
#if !defined(NC_RELAX_COORD_BOUND) || NC_RELAX_COORD_BOUND == 0
      choke me
#endif]])], [nc_relax_coord_bound=yes], [nc_relax_coord_bound=no])
if test "x$nc_relax_coord_bound" = xyes; then
   AC_DEFINE([NF_RELAX_COORD_BOUND], [1], [Enable a more relaxed boundary error check NF_EINVALCOORDS])
fi

AC_MSG_CHECKING([if netCDF was built with CDF5])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([], [[
#include <netcdf_meta.h>
#if !defined(NC_HAS_CDF5) || NC_HAS_CDF5 == 0
      choke me
#endif]])], [nc_has_cdf5=yes], [nc_has_cdf5=no])
if test "x$nc_has_cdf5" = xyes; then
   AC_DEFINE([ENABLE_CDF5], [1], [Enable CDF-5 file format])
fi
AC_MSG_RESULT([$nc_has_cdf5])

###
# Zstandard logic stanza
###
AC_ARG_ENABLE([zstandard_plugin],
               [AS_HELP_STRING([--disable-zstandard-plugin],
                               [disable zstandard detection and functionality, even if libnetcdf was compiled with plugin support])])

test "x$enable_zstandard_plugin" = xno || enable_zstandard_plugin=yes

if test "x$enable_zstandard_plugin" = xyes; then

   AC_MSG_CHECKING([if netCDF was built with Zstandard compression])
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([], [[
   #include <netcdf_meta.h>
   #if !defined(NC_HAS_ZSTD) || NC_HAS_ZSTD == 0
         choke me
   #endif]])], [nc_has_zstd=yes], [nc_has_zstd=no])

   AC_MSG_RESULT([$nc_has_zstd])

   if test "x$nc_has_zstd" = xyes; then
      if test "x${HDF5_PLUGIN_PATH}" = "x"; then
         AC_MSG_WARN([ ])
         AC_MSG_WARN([------------------------------------------])
         AC_MSG_WARN([libnetcdf was built with zstd support, but HDF5_PLUGIN_PATH is not set.  Either set the HDF5_PLUGIN_PATH environmental variable if zstandard tests fail, or use --disable-zstandard-plugin when running configure.])
         AC_MSG_WARN([------------------------------------------])
         AC_MSG_WARN([ ])
         nf_has_zstd=no
         nc_hdf5_plugin_path=""
      else
         nf_has_zstd=yes
         nc_hdf5_plugin_path="(HDF5_PLUGIN_PATH: ${HDF5_PLUGIN_PATH})"
         AC_DEFINE([ENABLE_ZSTD], [1], [Enable Zstandard compression support])   
      fi
   else
      nf_has_zstd=no
   fi
else
   nf_has_zstd=no
fi
###
# End Zstandard logic stanza
###

AC_MSG_CHECKING([if netCDF was built with pnetcdf])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([], [[
#include <netcdf_meta.h>
#if !defined(NC_HAS_PNETCDF) || NC_HAS_PNETCDF == 0
      choke me
#endif]])], [nc_has_pnetcdf=yes], [nc_has_pnetcdf=no])
if test "x$nc_has_pnetcdf" = xyes; then
   AC_DEFINE([NF_HAS_PNETCDF], [1], [Enable parallel I/O support via PnetCDF])
fi
AC_MSG_RESULT([$nc_has_pnetcdf])

AC_MSG_CHECKING([if netCDF was built with HDF5 parallel I/O features])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([], [[
#include <netcdf_meta.h>
#if !defined(NC_HAS_PARALLEL4) || NC_HAS_PARALLEL4 == 0
      choke me
#endif]])], [nc_has_parallel4=yes], [nc_has_parallel4=no])
AC_MSG_RESULT([$nc_has_parallel4])

AC_MSG_CHECKING([if netCDF was built with any parallel I/O features])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([], [[
#include <netcdf_meta.h>
#if !defined(NC_HAS_PARALLEL) || NC_HAS_PARALLEL == 0
      choke me
#endif]])], [nc_has_parallel=yes], [nc_has_parallel=no])
AC_MSG_RESULT([$nc_has_parallel])


# Version 4.6.1 does not have NC_HAS_PARALLEL4 but does have
# NC_HAS_PARALLEL.
AC_MSG_CHECKING([if netCDF-fortran should be built with HDF5 parallel I/O features])
if test "x$nc_has_parallel" = xyes -a "x$nc_has_parallel4" = xno -a "x$nc_has_pnetcdf" = xno; then
   nc_has_parallel4=yes
fi
if test "x$nc_has_parallel4" = xyes; then
   AC_DEFINE([NF_HAS_PARALLEL4], [1], [Enable parallel I/O support via HDF5])
fi
AC_MSG_RESULT([$nc_has_parallel4])

AC_MSG_CHECKING([if netCDF was built with support for szip writes])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([], [[
#include <netcdf_meta.h>
#if !(NC_HAS_SZIP_WRITE)
      choke me
#endif]])], [nc_has_szip_write=yes], [nc_has_szip_write=no])
AC_MSG_RESULT([$nc_has_szip_write])
AM_CONDITIONAL(TEST_SZIP_WRITE, [test "x$nc_has_szip_write" = xyes])

AC_MSG_CHECKING([if netCDF was built with support for quantize])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([], [[
#include <netcdf_meta.h>
#if !defined(NC_HAS_QUANTIZE) || NC_HAS_QUANTIZE == 0
      choke me
#endif]])], [nc_has_quantize=yes], [nc_has_quantize=no])
if test "x$nc_has_quantize" = xyes; then
   AC_DEFINE([NF_HAS_QUANTIZE], [1], [Support for quantize feature.])
fi
AC_MSG_RESULT([$nc_has_quantize])

AM_CONDITIONAL(TEST_QUANTIZE, [test "x$nc_has_quantize" = xyes])

# Find valgrind, if available, and add targets for it (ex:
# check-valgrind).
AX_VALGRIND_DFLT([sgcheck], [off])
AX_VALGRIND_CHECK
AM_CONDITIONAL(ENABLE_VALGRIND, [test "x$VALGRIND_ENABLED" = xyes])

# Does the user want to run extra parallel tests when parallel
# netCDF-4 is built?
AC_MSG_CHECKING([whether parallel IO tests should be run])
AC_ARG_ENABLE([parallel-tests],
              [AS_HELP_STRING([--enable-parallel-tests],
                              [Run extra parallel IO tests. Ignored if \
                               netCDF-4 is not enabled, or built on a system \
                               without parallel I/O support.])])
test "x$enable_parallel_tests" = xyes || enable_parallel_tests=no
AC_MSG_RESULT($enable_parallel_tests)
if test $enable_parallel_tests = yes -a "x$nc_has_pnetcdf" = xno -a "x$nc_has_parallel4" = xno ; then
   # paralle I/O is not enabled
   AC_MSG_ERROR([Parallel I/O tests requested, but netcdf-c does not support parallel I/O.])
fi
AM_CONDITIONAL(TEST_PARALLEL, [test "x$enable_parallel_tests" = xyes])

# Did the user specify an MPI launcher other than mpiexec?
AC_MSG_CHECKING([whether a user specified program to run mpi programs])
AC_ARG_WITH([mpiexec],
              [AS_HELP_STRING([--with-mpiexec=<command>],
                              [Specify command to launch MPI parallel tests.])],
            [MPIEXEC=$with_mpiexec], [MPIEXEC=mpiexec])
AC_MSG_RESULT([$MPIEXEC])
AC_SUBST([MPIEXEC], [$MPIEXEC])

# Determine if we want to enable doxygen-generated documentation. Any
# new documentation input files should be inserted into
# docs/Doxyfile.in and possibly docs/Makefile.am
AC_MSG_CHECKING([whether netCDF documentation should be generated])
AC_ARG_ENABLE([doxygen],
	[AS_HELP_STRING([--enable-doxygen],
	[Enable generation of documentation with doxygen.])])
test "x$enable_doxygen" = xyes || enable_doxygen=no
AC_MSG_RESULT($enable_doxygen)
AM_CONDITIONAL([BUILD_DOCS], [test "x$enable_doxygen" = xyes])

# Does the user want to generate dot-based documentation?
AC_ARG_ENABLE([dot],
	[AS_HELP_STRING([--enable-dot],
	[Use dot (provided by graphviz) to generate charts and graphs \
        in the doxygen-based documentation.])])
	test "x$enable_dot" = xyes || enable_dot=no

# Does the user want to generate internal documentation?
AC_ARG_ENABLE([internal-docs],
  [AS_HELP_STRING([--enable-internal-docs],
    [Include documentation of library internals. This is of interest \
    only to those developing the netCDF library.])])
test "x$enable_internal_docs" = xyes || enable_internal_docs=no
AC_SUBST([BUILD_INTERNAL_DOCS], [$enable_internal_docs])

# Is doxygen installed? If so, have configure construct the Doxyfile.
AC_CHECK_PROGS([DOXYGEN], [doxygen])
if test -z "$DOXYGEN"; then
   AC_MSG_WARN([Doxygen not found - documentation will not be built])
fi

# Is graphviz/dot installed? If so, we'll use dot to create
# graphs in the documentation.
AC_CHECK_PROGS([DOT], [dot])
if test -z "$DOT"; then
   AC_MSG_WARN([dot not found - will use simple charts in documentation])
   HAVE_DOT=NO
elif test "x$enable_dot" = xno; then
   HAVE_DOT=NO
else
   HAVE_DOT=YES
fi

# If we have doxygen, and it's enabled, then process the file.
if test "x$enable_doxygen" != xno; then
   if test -n "$DOXYGEN"; then
        AC_SUBST(HAVE_DOT)
        AC_CONFIG_FILES([docs/Doxyfile])
   fi
fi

# Find the C compiler.
AC_MSG_NOTICE([finding C compiler])

AC_PROG_CC
AM_PROG_CC_C_O
AC_C_CONST

# Sed is needed to construct tests.
AC_PROG_SED
if test -z "$SED"; then
   AC_MSG_WARN([sed not found - some tests will not be built])
fi
AM_CONDITIONAL(USE_SED, [test -n "${SED+1}"])

# Find fortran compiler. If FC isn't set after AC_PROG_FC, we couldn't
# find a fortran compiler. If the user requested the fortran API, and
# has told us not to recover from a missing compiler, then bail out
# right here.
AC_MSG_NOTICE([finding Fortran compiler])

AC_PROG_FC
AC_PROG_F77($FC)

## Compiler with version information. This consists of the full path
## name of the compiler and the reported version number.
AC_SUBST([FC_VERSION])
## Strip anything that looks like a flag off of $FC
FC_NOFLAGS=`echo $FC | sed 's/ -.*//'`

if `echo $FC_NOFLAGS | grep ^/ >/dev/null 2>&1`; then
  FC_VERSION="$FC"
else
  FC_VERSION="$FC"
  FC_VERSION="$(dirname $(which $FC))/$FC"
fi
if test -n "$fc_version_info"; then
  FC_VERSION="$FC_VERSION ( $fc_version_info)"
fi


# If we couldn't find an F90 compiler, deal with it.
if test "${FC+set}" = set && test "x$FC" = x; then
   AC_MSG_FAILURE([Can't find F90 compiler.])
fi

# Does the user want to test for Fortran 2003 compiler.
# Added to get around NAG evaluation compiler error turning off F03
AC_MSG_CHECKING([whether Fortran compiler is checked for ISO_C_BINDING support])
AC_ARG_ENABLE([f03-compiler-check],
              [AS_HELP_STRING([--disable-f03-compiler-check],
                              [disable check of ISO_C_BINDING support in Fortran compiler])])
test "x$enable_f03_compiler_check" = xno || enable_f03_compiler_check=yes
AC_MSG_RESULT($enable_f03_compiler_check)

# next check to see if the Fortran compiler will support
# ISO_C_BINDING
nc_iso_c_binding=yes

# Some f90 compilers change the case of the mod file names. Others
# require special flags to be set to deal with .f90 files. Find out
# about this compiler.
AC_LANG_PUSH(Fortran)
AC_FC_SRCEXT(f90)
AC_LANG_POP(Fortran)
AX_F90_MODULE_FLAG
AC_SUBST(MOD_FLAG, ${ax_cv_f90_modflag})
if test "x$enable_f03_compiler_check" = xyes; then
  AC_MSG_CHECKING([if Fortran compiler supports Fortran 2003 ISO_C_BINDING])
  cat <<EOF >conftest.f90
module conftest_module
USE ISO_C_BINDING
end module conftest_module
EOF
  doit='$FC -c ${FCFLAGS} ${FCFLAGS_f90} conftest.f90'
  if AC_TRY_EVAL(doit); then
     nc_iso_c_binding=yes
  else
     nc_iso_c_binding=no
  fi
  AC_MSG_RESULT([$nc_iso_c_binding])

  AC_MSG_CHECKING([if Fortran compiler supports Fortran 2008 ISO_FORTRAN_ENV additions])
  cat <<EOF >conftest.f90
Program test
USE ISO_FORTRAN_ENV, ONLY: REAL32, REAL64, INT8, INT16, INT32, INT64
End Program
EOF
  doit='$FC -c ${FCFLAGS} ${FCFLAGS_f90} conftest.f90'
  if AC_TRY_EVAL(doit); then
     nc_f2008_is0_env_additions=yes
     AC_DEFINE([HAVE_F2008], 1, [if true, use Fortran 2008 ISO_FORTRAN_ENV additions])
  else
     nc_f2008_is0_env_additions=no
  fi
  AC_MSG_RESULT([$nc_f2008_is0_env_additions])

  AC_MSG_CHECKING([if Fortran compiler supports TS29113 standard extension])
  cat <<EOF >conftest.f90
Program test
USE ISO_C_BINDING, ONLY: C_PTRDIFF_T
End Program
EOF
  doit='$FC -c ${FCFLAGS} ${FCFLAGS_f90} conftest.f90'
  if AC_TRY_EVAL(doit); then
     nc_ts29113_support=yes
     AC_DEFINE([HAVE_TS29113_SUPPORT], 1, [if true, Fortran compiler supports TS29113 extension])
  else
     nc_ts29113_support=no
  fi
  AC_MSG_RESULT([$nc_ts29113_support])

  if test "x$nc_iso_c_binding" = xno; then
    AC_MSG_FAILURE([Can't use build F03 interfaces])
  fi
fi

# Test to see if fortran compiler supports the flag
# -fallow-argument-mismatch flag introduced in gfortran 10.
#
# Also allow support for NAG compiler using the -mismatch_all flag.
#
# See https://github.com/Unidata/netcdf-fortran/issues/212
# See https://github.com/Unidata/netcdf-fortran/issues/218
ac_save_FCFLAGS="$FCFLAGS"
ac_save_FFLAGS="$FFLAGS"
AC_MSG_CHECKING([if Fortran compiler supports allow-mismatch flag])
cat <<EOF >conftest.f90
Program test
USE ISO_C_BINDING, ONLY: C_PTRDIFF_T
End Program
EOF
doit='$FC -c ${FCFLAGS} ${FCFLAGS_f90} -fallow-argument-mismatch conftest.f90'
if AC_TRY_EVAL(doit); then
   nf_allow_mismatch=yes
   FCFLAGS="${FCFLAGS} -fallow-argument-mismatch"
   FFLAGS="${FFLAGS} -fallow-argument-mismatch"
else
   nf_allow_mismatch=no
fi
AC_MSG_RESULT([$nf_allow_mismatch])
# End testing of gfortan allow-mismatch flags.

AC_MSG_CHECKING([if Fortran compiler supports mismatch_all flag])
cat <<EOF >conftest.f90
Program test
USE ISO_C_BINDING, ONLY: C_PTRDIFF_T
End Program
EOF
doit='$FC -c ${FCFLAGS} ${FCFLAGS_f90} -mismatch_all conftest.f90'
if AC_TRY_EVAL(doit); then
   nf_mismatch_all=yes
   FCFLAGS="${FCFLAGS} -mismatch_all"
   FFLAGS="${FFLAGS} -mismatch_all"
else
   nf_mismatch_all=no
fi
AC_MSG_RESULT([$nf_mismatch_all])

#end testing of NAG mismatch_all flag.

##
# End mismatch checks
##


# We must have F2003 ISO bindings to build.
if test "x$nc_iso_c_binding" = xno; then
  AC_MSG_FAILURE([Fortran 2003 interface not supported])
fi
nc_build_f03=yes


# Does the user want to check into fortran type information?
AC_MSG_CHECKING([whether fortran type sizes should be checked])
AC_ARG_ENABLE([fortran-type-check],
              [AS_HELP_STRING([--disable-fortran-type-check],
                              [cause the Fortran type sizes checks to be skipped])])
test "x$enable_fortran_type_check" = xno || enable_fortran_type_check=yes
AC_MSG_RESULT($enable_fortran_type_check)

# Does the user want to run tests for large files (> 2GiB)?
AC_MSG_CHECKING([whether large file (> 2GB) tests should be run])
AC_ARG_ENABLE([large-file-tests],
              [AS_HELP_STRING([--enable-large-file-tests],
                              [Run tests which create very large data files (~13 GB disk space
                              required, but it will be recovered when tests are complete). See
                              option --with-temp-large to specify temporary directory])])
test "x$enable_large_file_tests" = xyes || enable_large_file_tests=no
AC_MSG_RESULT($enable_large_file_tests)
AM_CONDITIONAL(LARGE_FILE_TESTS, [test x$enable_large_file_tests = xyes])
if test "x$enable_large_file_tests" = xyes; then
   AC_DEFINE([LARGE_FILE_TESTS], [1], [do large file tests])
fi

# Does the user want to run benchmarks?
AC_MSG_CHECKING([whether benchmarks should be run])
AC_ARG_ENABLE([benchmarks],
              [AS_HELP_STRING([--enable-benchmarks],
                              [Run benchmarks.])])
test "x$enable_benchmarks" = xno || enable_benchmarks=yes
AC_MSG_RESULT($enable_benchmarks)
AM_CONDITIONAL(BUILD_BENCHMARKS, [test x$enable_benchmarks = xyes])

# If the env. variable TEMP_LARGE is set, or if
# --with-temp-large=<directory>, use it as a place for the large
# (i.e. > 2 GiB) files created during the large file testing.
AC_MSG_CHECKING([where to put large temp files if large file tests are run])
AC_ARG_WITH([temp-large],
            [AS_HELP_STRING([--with-temp-large=<directory>],
                            [specify directory where large files (i.e. >2 GB) \
                            will be written, if large files tests are run with
                            --enable-large-file-tests])],
            [TEMP_LARGE=$with_temp_large])
TEMP_LARGE=${TEMP_LARGE-.}
AC_MSG_RESULT($TEMP_LARGE)
AC_DEFINE_UNQUOTED([TEMP_LARGE], ["$TEMP_LARGE"], [Place to put very large netCDF test files.])

# Allow setting the fortran module install dir
AC_ARG_WITH([fmoddir],
  [AS_HELP_STRING([--with-fmoddir=DIR], [Fortran module install directory])],
  [fmoddir=$withval],
  [fmoddir="\${includedir}"])
AC_SUBST([fmoddir], [$fmoddir])

# Set up libtool.
AC_MSG_NOTICE([setting up libtool])
LT_PREREQ([2.2])
LT_INIT

AC_MSG_NOTICE([finding other utilities])

# Find the install program.
AC_PROG_INSTALL

AC_MSG_NOTICE([trying to set fortran flags for this platform])
AC_MSG_CHECKING([what FC is set to])
AC_MSG_RESULT([$FC])

# Check to see if any macros must be set to enable large (>2GB) files.
AC_SYS_LARGEFILE

# This will test the f77 compiler, as well as check some fortran types.
if test "$enable_fortran_type_check" = yes; then
   UD_FORTRAN_TYPES
   if test "x$ud_fc_failed" = xyes; then
      AC_MSG_ERROR([F77 compiler doesn't work.])
   fi
else
   AC_DEFINE(NCBYTE_T, byte)
   AC_DEFINE(NCSHORT_T, integer*2)
   AC_DEFINE(NF_INT1_T, byte)
   AC_DEFINE(NF_INT2_T, integer*2)
   AC_DEFINE(NF_INT8_T, integer*8)
   AC_DEFINE(NF_INT1_IS_C_SIGNED_CHAR, 1, [default])
   AC_DEFINE(NF_INT2_IS_C_SHORT, 1, [default])
   AC_DEFINE(NF_INT_IS_C_INT, 1, [default])
   AC_DEFINE(NF_INT8_IS_C_LONG_LONG, 1, [default])
   AC_DEFINE(NF_REAL_IS_C_FLOAT, 1, [default])
   AC_DEFINE(NF_DOUBLEPRECISION_IS_C_DOUBLE, 1, [default])
fi

AC_MSG_NOTICE([checking types, headers, and functions])

# We must check for all these, because they may be used by the netCDF
# C library.
# Removing the checks for some of the libraries because of issues
# observed when they are detected, are not needed, and an attempt to
# link against is made anyways.
# See https://github.com/Unidata/netcdf-fortran/issues/164
#
# Specifying LDFLAGS="$(nc-config --libs [--static])" should
# let downstream developers link more reliably against libnetcdf.

AC_CHECK_LIB([m], [floor], [], [])
AC_SEARCH_LIBS([dlopen], [dl dld], [], [])

# When the underneath NetCDF C library was built with parallel I/O enables,
# check if the Fortran compiler supports parallel I/O. Abort if not.
#if test "x$nc_has_parallel4" = xyes -o "x$nc_has_pnetcdf" = xyes; then
#   AC_LANG_PUSH([Fortran])
#   AC_CHECK_FUNC([MPI_File_open], [],
#      [AC_SEARCH_LIBS([MPI_File_open], [], [],
#                      [AC_MSG_ERROR([
#      -----------------------------------------------------------------------
#        The NetCDF C library is built with parallel I/O feature enabled, but
#        the Fortran compiler '$FC' supplied in this configure command
#        does not support MPI-IO. Please use one that does. If parallel I/O
#        feature is not desired, please use a NetCDF C library with parallel
#        I/O feature disabled. Abort.
#      -----------------------------------------------------------------------])
# ])])
#   AC_LANG_POP([Fortran])
#fi

# Find the netCDF header and library.
AC_CHECK_HEADERS([netcdf.h], [], [AC_MSG_ERROR([netcdf.h could not be found. Please set CPPFLAGS.])])
AC_SEARCH_LIBS([nc_open], [netcdf], [],
			  [AC_MSG_ERROR([Could not link to netcdf C library. Please set LDFLAGS; for static builds set LIBS to the results of nc-config --libs.])])

# See if various functions are available
AC_CHECK_FUNCS([nc_def_opaque nccreate nc_set_log_level oc_open nc_def_var_szip])

# Starting with version 4.7.4, netcdf-c has function nc_def_var_szip().
if test "x$ac_cv_func_nc_def_var_szip" != xyes; then
   AC_MSG_ERROR([netcdf-c version 4.7.4 or greater is required, built with underlying szip support.])
fi

nc_build_v2=no
nc_build_v4=no
nc_has_logging=no
nc_has_dap=no

AC_COMPUTE_INT([nc_has_hdf5], [NC_HAS_HDF5], [[#include <netcdf_meta.h>]])
if test "x$nc_has_hdf5" = x1; then
   nc_build_v4=yes
fi
test "x$ac_cv_func_nccreate" = xyes && nc_build_v2=yes
test "x$ac_cv_func_nc_set_log_level" = xyes && nc_has_logging=yes
test "x$ac_cv_func_oc_open" = xyes && nc_has_dap=yes

if test "x$nc_build_v4" = xyes; then
   AC_DEFINE([USE_NETCDF4], [1], [if true, build netCDF-4])
fi

if test "x$nc_has_logging" = xyes; then
   AC_DEFINE([LOGGING], [1], [if true, C library contains logging])
fi
AC_MSG_CHECKING([netCDF logging present])
AC_MSG_RESULT([$nc_has_logging])

AC_MSG_CHECKING([netCDF v2 API present])
AC_MSG_RESULT([$nc_build_v2])
AC_MSG_CHECKING([netCDF-4 present])
AC_MSG_RESULT([$nc_build_v4])

AC_MSG_CHECKING([whether to test the filter API])
AC_ARG_ENABLE([filter-test],
              [AS_HELP_STRING([--enable-filter-test],
                              [Run filter tests: requires access to the plugins directory in a netcdf-c build.])])
test "x$enable_filter_test" = xyes || enable_filter_test=no
AC_MSG_RESULT($enable_filter_test)

AM_CONDITIONAL([USE_NETCDF4], [test "x$nc_build_v4" = xyes])
AM_CONDITIONAL([BUILD_V2], [test "x$nc_build_v2" = xyes])
AM_CONDITIONAL([HAS_LOGGING], [test "x$nc_has_logging" = xyes])
AM_CONDITIONAL([USE_LOGGING], [test "x$nc_has_logging" = xyes])
AM_CONDITIONAL([BUILD_DAP], [test "x$nc_has_dap" = xyes])
AM_CONDITIONAL([BUILD_PNETCDF], [test "x$nc_has_pnetcdf" = xyes])
AM_CONDITIONAL([BUILD_PARALLEL4], [test "x$nc_has_parallel4" = xyes])
AM_CONDITIONAL([BUILD_PARALLEL], [test "x$nc_has_pnetcdf" = xyes -o "x$nc_has_parallel4" = xyes])
AM_CONDITIONAL([TEST_FILTERS], [test "x$enable_filter_test" = xyes])


AC_CHECK_HEADER(stdlib.h, ,AC_DEFINE([NO_STDLIB_H], [], [no stdlib.h]))
AC_CHECK_HEADER(sys/types.h, ,AC_DEFINE([NO_SYS_TYPES_H], [], [no sys_types.h]))
AC_CHECK_HEADERS([sys/param.h])
AC_CHECK_HEADERS([locale.h stdio.h stdarg.h errno.h ctype.h fcntl.h malloc.h stdlib.h string.h \
			   strings.h unistd.h sys/stat.h getopt.h sys/time.h sys/resource.h])
AC_HEADER_DIRENT
AC_HEADER_STDC
AC_HEADER_SYS_WAIT
AC_HEADER_TIME

AC_FUNC_VPRINTF

# Check for <stdbool.h> that conforms to C99 requirements
AC_HEADER_STDBOOL

# Check for these functions...
AC_FUNC_ALLOCA
AC_TYPE_SIZE_T
AC_TYPE_OFF_T
AC_CHECK_TYPES([ssize_t, ptrdiff_t, uchar, longlong])
AC_C_CHAR_UNSIGNED
AC_CHECK_SIZEOF(short)
AC_CHECK_SIZEOF(int)
AC_CHECK_SIZEOF(long)
AC_CHECK_SIZEOF(float)
AC_CHECK_SIZEOF(double)
AC_CHECK_SIZEOF(off_t)
AC_CHECK_SIZEOF(size_t)
AC_CHECK_SIZEOF(ptrdiff_t)
AC_COMPUTE_INT([longlong_is_long],[sizeof(long long) == sizeof(long)],[],[longlong_is_long=0])
if test $longlong_is_long = 1; then
   CFLAGS="$CFLAGS -DLONGLONG_IS_LONG"
fi

# Flags for nf-config script; by design $prefix, $includir, $libdir,
# etc.  are left as shell variables in the script so as to facilitate
# relocation
NC_LIBS="-lnetcdf"
NC_LIBS="$LDFLAGS $NC_LIBS $LIBS"

case "x$target_os" in
xsolaris*)
  NEWNCLIBS=""
  for x in $NC_LIBS ; do
    case "$x" in
    -L*) r=`echo "$x" | sed -e 's|^-L|-R|'`
	 NEWNCLIBS="$NEWNCLIBS $x $r"
	 ;;
    *)	 NEWNCLIBS="$NEWNCLIBS $x" ;;
    esac
  done
  NC_LIBS="$NEWNCLIBS"
  ;;
*);;
esac

NC_FLIBS="-lnetcdff $NC_LIBS"

AC_SUBST([enable_shared])
AC_SUBST([enable_static])
AC_SUBST(NC_LIBS,[$NC_LIBS])
AC_SUBST(NC_FLIBS,[$NC_FLIBS])
AC_SUBST(HAS_F90,[$nc_build_f90])
AC_SUBST(HAS_F03,[$nc_build_f03])
AC_SUBST(HAS_DAP,[$nc_has_dap])
AC_SUBST(HAS_NC2,[$nc_build_v2])
AC_SUBST(HAS_NC4,[$nc_build_v4])
AC_SUBST(HAS_SZIP_WRITE,[$nc_has_szip_write])
AC_SUBST(HAS_ZSTD,[$nf_has_zstd])
AC_SUBST(HAS_QUANTIZE,[$nc_has_quantize])
AC_SUBST(HAS_LOGGING,[$nc_has_logging])
AC_SUBST(HAS_CDF5,[$nc_has_cdf5])
AC_SUBST(HAS_PNETCDF,[$nc_has_pnetcdf])
AC_SUBST(HAS_NC4_PARALLEL,[$nc_has_parallel4])
AC_SUBST(HAS_PARALLEL,[$nc_has_parallel])
AC_SUBST(NF_HDF5_PLUGIN_PATH, [$nc_hdf5_plugin_path])

# Some files need to exist in build directories that do not correspond
# to their source directory, or the test program makes an assumption
# about where files live.  AC_CONFIG_LINKS provides a mechanism to
# link/copy files if an out-of-source build is happening.
AC_CONFIG_LINKS([nf_test/fills.nc:nf_test/ref_fills.nc])

if test "x$nc_has_parallel" = xyes; then
   AC_CONFIG_FILES([nf03_test4/run_f90_par_test.sh], [chmod ugo+x nf03_test4/run_f90_par_test.sh])
fi

AC_MSG_NOTICE([generating header files and makefiles])

AC_CONFIG_FILES([Makefile
                 nf-config
                 netcdf-fortran.pc
                 libnetcdff.settings
                 docs/Makefile
                 fortran/Makefile
                 nf_test/Makefile
                 nf_test4/Makefile
                 nf03_test/Makefile
                 nf03_test4/Makefile
                 CMakeExtras/Makefile
                 libsrc/Makefile
                 examples/Makefile
                 examples/F90/Makefile
                 examples/F77/Makefile],
		 [test -f  nf-config && chmod 755 nf-config ])

AC_OUTPUT()

cat libnetcdff.settings

##
# This can be done more elegantly, but for the sake of expediency
# we will do it this way.
##
if test "x$nc_has_zstd" = xyes; then
   if test "x$nf_has_zstd" = xno; then
      if test "x${HDF5_PLUGIN_PATH}" = "x"; then
         echo ""
         AC_MSG_WARN([ ])
         AC_MSG_WARN([------------------------------------------])
         AC_MSG_WARN([libnetcdf was built with zstd support, but HDF5_PLUGIN_PATH is not set, so zstd support is not enabled in libnetcdff. Set HDF5_PLUGIN_PATH and re-run configure if you want to enable zstd support.])
         echo ""
         AC_MSG_WARN([You can use `nc-config --plugindir` to determine the appropriate value for HDF5_PLUGIN_PATH])
         AC_MSG_WARN([------------------------------------------])
         AC_MSG_WARN([ ])
      fi
   fi
fi


