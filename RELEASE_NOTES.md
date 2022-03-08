Release Notes {#nf_release_notes}
==============================

\brief Release notes file for the netcdf-fortran package.

This file contains a high-level description of this package's evolution.
Entries are in reverse chronological order (most recent first).

## 4.6.0 - Release TBD

### Requirements

* netCDF-C: 4.8.1+

### Changes

* Introduction of quantize functionality (this description line is a placeholder)

## 4.5.4 - January 7, 2022

### Requirements

* netCDF-C: 4.7.4+

### Changes

* Various bug fixes and updates.
* Now allow setting of parallel I/O test launcher to something other than mpiexec with the --with-mpiexec= option on configure. See [Github #262](https://github.com/Unidata/netcdf-fortran/issues/262).
* Added nf90_inq_format to the F90 API. See [Github #263](https://github.com/Unidata/netcdf-fortran/issues/263).
* Avoid compilation failure with -Werror=implicit-function-declaration by @opoplawski in https://github.com/Unidata/netcdf-fortran/pull/57
* F90 parallel wr2 test: collective writes by @marshallward in https://github.com/Unidata/netcdf-fortran/pull/56
* got doxygen build working by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/77
* Updates to netCDF fortran in support of the upcoming release. by @WardF in https://github.com/Unidata/netcdf-fortran/pull/79
* Github #67 plus a couple other small changes by @WardF in https://github.com/Unidata/netcdf-fortran/pull/83
* CMakeLists.txt: check for the C types that match Fortran ones. by @multiplemonomials in https://github.com/Unidata/netcdf-fortran/pull/67
* check error string for prefix 'Unknown Error' only by @wkliao in https://github.com/Unidata/netcdf-fortran/pull/87
* Combine multiple pull requests by @WardF in https://github.com/Unidata/netcdf-fortran/pull/93
* consistent error out for nf_test.F and nf03_test.F by @wkliao in https://github.com/Unidata/netcdf-fortran/pull/88
* add missing cdf2 and cdf5 flags by @wkliao in https://github.com/Unidata/netcdf-fortran/pull/89
* add dependency of relax_coord_bound set in netcdf-c by @wkliao in https://github.com/Unidata/netcdf-fortran/pull/90
* Updated to travis testing for netcdf-fortran. by @WardF in https://github.com/Unidata/netcdf-fortran/pull/95
* Add parallel I/O tests for PnetCDF and serial I/O for CDF5 files by @wkliao in https://github.com/Unidata/netcdf-fortran/pull/91
* Update CMake Options by @WardF in https://github.com/Unidata/netcdf-fortran/pull/97
* Fix use of diskless in Fortran test. by @DennisHeimbigner in https://github.com/Unidata/netcdf-fortran/pull/98
* Oops wrong flag for nc_open_mem by @DennisHeimbigner in https://github.com/Unidata/netcdf-fortran/pull/99
* fixed configure.ac for static builds by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/102
* Add filter support to the netcdf-fortram API by @DennisHeimbigner in https://github.com/Unidata/netcdf-fortran/pull/105
* Fix compiler issue on OSX by @WardF in https://github.com/Unidata/netcdf-fortran/pull/110
* remove legacy cfortran.h build, change valgrind use by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/120
* Fix some build issues (remove unused scripts, get make -j working, remove unused option, stop setting FC in configure) by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/116
* Detect inability to link to netcdf-c library at configure time by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/124
* fixed spacing to accommodate punch cards, fixed parallel builds in example dirs, added comments to build files by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/125
* bugfix in nf-config.in by @aerorahul in https://github.com/Unidata/netcdf-fortran/pull/137
* Remove unused files, fix detection of parallel I/O by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/135
* Next round of clean up of build system, also fixed some warnings and added some docs by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/145
* fix cache preemption issue, also some warnings by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/149
* Fix parallel I/O test not running, remove nfconfig.inc. by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/156
* Fix 2 broken parallel tests, clean out some remaining support for legacy cfortran build and upper-case mod file names by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/162
* Fix for remaining parallel I/O tests by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/163
* starting to eliminate duplicate tests by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/166
* next round of test cleanup by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/167
* Moving the rest of F77 API netcdf-4 tests to nf_test4 by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/168
* move neetcdf-4 f90 API tests to nf03_test4 by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/170
* More test cleanup, also adding CDF5 to F90 API constants by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/173
* More test work by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/175
* Final round of test cleanup by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/176
* fix dependency tracking in fortran directory, enabling parallel (make -j) builds by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/178
* fixing some dependencies by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/179
* Correct linking issue on OSX by @WardF in https://github.com/Unidata/netcdf-fortran/pull/171
* Get filter test to work with Fortran by @DennisHeimbigner in https://github.com/Unidata/netcdf-fortran/pull/180
* fix compile error: NC_CLASSIC_MODEL by @wkliao in https://github.com/Unidata/netcdf-fortran/pull/189
* duplicated module_netcdf4_nc_interfaces.$(OBJEXT) by @wkliao in https://github.com/Unidata/netcdf-fortran/pull/186
* Add $(srcdir) when doing VPATH build by @wkliao in https://github.com/Unidata/netcdf-fortran/pull/187
* Support 64-bit integer memory type by @wkliao in https://github.com/Unidata/netcdf-fortran/pull/190
* Use of "stop retval" is not portable by @wkliao in https://github.com/Unidata/netcdf-fortran/pull/188
* added logging source to autotools build by @edhartnett in https://github.com/Unidata/netcdf-fortran/pull/191
* 64-bit integer: missing the case for --disable-fortran-type-check by @wkliao in https://github.com/Unidata/netcdf-fortran/pull/195
* Check FC supports MPI-IO at configure time by @wkliao in https://github.com/Unidata/netcdf-fortran/pull/194
* remove an unused variable 'counter' by @wkliao in https://github.com/Unidata/netcdf-fortran/pull/193
* Merge selected changes from v4.5.0 upstream. by @WardF in https://github.com/Unidata/netcdf-fortran/pull/196
* v4.5.1 wellspring.wif by @WardF in https://github.com/Unidata/netcdf-fortran/pull/197
* Fixes distribution of cmake-based large file tests by @WardF in https://github.com/Unidata/netcdf-fortran/pull/199
* Correct issue when building against nc3-only libnetcdf by @WardF in https://github.com/Unidata/netcdf-fortran/pull/201
* Merge back upstream to master by @WardF in https://github.com/Unidata/netcdf-fortran/pull/202
* Fixes an issue with Intel Compiler 19 by @WardF in https://github.com/Unidata/netcdf-fortran/pull/204
* Spelling fix in docs for cache_preemption by @mathomp4 in https://github.com/Unidata/netcdf-fortran/pull/206
* Correct failure to compile on some mpi systems. by @WardF in https://github.com/Unidata/netcdf-fortran/pull/210
* Turn off parallel builds for this directory until a more suitable sol… by @WardF in https://github.com/Unidata/netcdf-fortran/pull/211
* support nc_def_var_szip in Fortran APIs by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/216
* correctly detect absence of szip write capability by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/220
* Allow installing Fortran modules into alternate location by @opoplawski in https://github.com/Unidata/netcdf-fortran/pull/224
* Fix a warning in v2 code by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/226
* Now run szip test from CMake build, if szip write capability is present in netcdf-c by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/227
* Adds support and test for compact storage by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/231
* Fix warnings and documentation in examples by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/234
* Add missing build dependencies for Fortran by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/235
* fixed warning in f90tst_io.f90 by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/237
* Removed reference to NF90_TYPE in documentation by @WardF in https://github.com/Unidata/netcdf-fortran/pull/230
* Fix parallel builds by @skosukhin in https://github.com/Unidata/netcdf-fortran/pull/238
* Tests to confirm get/set var cache working in F77 and F90 APIs by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/239
* Autotools build improvements by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/245
* Merge 217 by @WardF in https://github.com/Unidata/netcdf-fortran/pull/243
* commented out cache value test because it doesnt work on parallel by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/254
* Change error message to mention LIBS and static builds by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/257
* Install CMake config/target files by @ZedThree in https://github.com/Unidata/netcdf-fortran/pull/259
* Add summary file libnetcdff.settings by @WardF in https://github.com/Unidata/netcdf-fortran/pull/261
* CMake: Fail if nc_def_var_szip missing by @ZedThree in https://github.com/Unidata/netcdf-fortran/pull/260
* Merge wellspring back upstream by @WardF in https://github.com/Unidata/netcdf-fortran/pull/250
* testing parallel writes just as NOAA does them by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/265
* Fix missing file by @WardF in https://github.com/Unidata/netcdf-fortran/pull/267
* Added missing nf90_inq_format() function by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/273
* Add CC, CFLAGS, CPPFLAGS to build summary, remove AM_LDFLAGS by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/271
* Allow user to select different parallel I/O launcher at configure by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/272
* Windows compile by @brucenairn in https://github.com/Unidata/netcdf-fortran/pull/268
* Tweak Travis-CI Settings by @WardF in https://github.com/Unidata/netcdf-fortran/pull/282
* Fix for nf-config using autotools by @mathomp4 in https://github.com/Unidata/netcdf-fortran/pull/281
* Fix typo in readme by @mflehmig in https://github.com/Unidata/netcdf-fortran/pull/290
* Add quantize feature to F77 and F90 APIs, with tests and documentation by @edwardhartnett in https://github.com/Unidata/netcdf-fortran/pull/304
* Revert "Add quantize feature to F77 and F90 APIs, with tests and docu… by @WardF in https://github.com/Unidata/netcdf-fortran/pull/305
* First pass at adding github actions support. by @WardF in https://github.com/Unidata/netcdf-fortran/pull/297
* Docs migration by @oxelson in https://github.com/Unidata/netcdf-fortran/pull/307
* Add quantize feature to F77 and F90 APIs, with tests and documentation by @WardF in https://github.com/Unidata/netcdf-fortran/pull/306
* Attempt to correct an issue being observed under linux and OSX with gfortran by @WardF in https://github.com/Unidata/netcdf-fortran/pull/316
* Revert "Add quantize feature to F77 and F90 APIs, with tests and documentation" by @WardF in https://github.com/Unidata/netcdf-fortran/pull/317

## 4.5.3 - June 2, 2020

### Requirements

* netCDF-C: 4.7.4+

### Changes

* Adds a `libnetcdff.settings` file similar to libnetcdf.settings.  See [Github #256](https://github.com/Unidata/netcdf-fortran/issues/256) for more information.
* Added support for gcc/gfortran 10.  The `-fallow_argument_mismatch` flag is passed to the underlying compiler when the flag is found to be supported.  This change has been added to the `autotools` and `cmake` based builds.  See [GitHub #212](https://github.com/Unidata/netcdf-fortran/issues/212) for more information.
* Added support for HDF5 compact storage. See [Github #213](https://github.com/Unidata/netcdf-fortran/issues/207).
* Added support for creating netCDF/HDF5 files with szip compression with new functions nf90_def_var_szip() and nf_def_var_szip(). See [Github #213](https://github.com/Unidata/netcdf-fortran/issues/213).
* Corrected an issue where parallel netCDF-Fortran builds would fail despite the presense of MPI libraries/compiler/infrastructure. See [Github #208](https://github.com/Unidata/netcdf-fortran/issues/208) for more information.

## 4.5.2 - September 18, 2019

### Requirements

* netCDF-C: 4.6.0 or greater

### Changes

* Corrected an issue where netCDF-Fortran would fail to build correctly on some platforms when the underlying `libnetcdf` lacked netCDF-4 support. See [GitHub #200](https://github.com/Unidata/netcdf-fortran/issues/200) for more information.
* Corrected an issue where cmake-specific large file tests weren't being captured by `make dist`. See [Github #198](https://github.com/Unidata/netcdf-fortran/issues/198) for more details.

## 4.5.1 - September 4, 2019

### Requirements

* netCDF-C: 4.6.0 or greater

### Changes

* Corrected an issue where a cmake-specific file wasn't being captured by `make dist`.
* Corrected an issue where nf-config wasn't being generated by cmake-based builds.  Corrected a couple of other missing files.  See [Github #108](https://github.com/Unidata/netcdf-fortran/issues/108) for more information.

## 4.5.0 - August 28, 2019

### Requirements

* netCDF-C: 4.6.0 or greater

### Changes

* Moved netCDF classic F90 API tests to new subdirectory nf03_test.
* Moved netCDF-4 F77 API tests to new subdirectory nf_test4.
* Moved netCDF-4 F90 API tests to new subdirectory nf03_test4.
* Fixed bug which caused parallel I/O tests to not be run. See [#155](https://github.com/Unidata/netcdf-fortran/issues/155) and [#157](https://github.com/Unidata/netcdf-fortran/issues/157).
* Fixed bug in the setting of file cache preemption for netCDF-4 files. See [#146](https://github.com/Unidata/netcdf-fortran/issues/146).
* Removed many near-duplicate tests files, now they are created at build time with sed. See [#165](https://github.com/Unidata/netcdf-fortran/issues/165).
* Removed no longer needed configure options --enable-dll (see [#161](https://github.com/Unidata/netcdf-fortran/issues/161)), `--enable-extra-tests` (see [#114](https://github.com/Unidata/netcdf-fortran/issues/114)), `--enable-extra-example-tests` (see [#126](https://github.com/Unidata/netcdf-fortran/issues/126)), and `--enable-valgrind` (see [#118](https://github.com/Unidata/netcdf-fortran/issues/118)).
* Moved handling of F77 man page to the docs directory. See [#141](https://github.com/Unidata/netcdf-fortran/issues/141).

## 4.4.5 - Release Jan 9, 2019

### Requirements

* netCDF-C: 4.6.0 or greater

### Changes

* Removed legacy cfortran.h based build, which allowed F77-only compilers to build the F77 API (only). Since all compilers now support F2003, we can use F2003 features to build the F77 API. Full backwards-compatibility with all existing F77 API code is assured.   See [#85](https://github.com/Unidata/netcdf-fortran/issues/85) for more information.
* Added an option in cmake builds, `BUILD_EXAMPLES`, `TRUE` by default. When disabled, the examples will not be built.  See [#93](https://github.com/Unidata/netcdf-fortran/issues/92) for more information.
* Misc. Bugfixes to bring netCDF-Fortran in line with the features in netCDF-C.
* Updated CMakeLists.txt to check for C types that match Fortran ones. See [GitHub #67](https://github.com/Unidata/netcdf-fortran/pull/67) for more information.

## 4.4.4 Released May 13, 2016

* Corrected an issue where cmake-based builds specifying `USE_LOGGING` were not seeing expected behavior.  The issue was reported, and subsequently fixed, by Neil Carlson at Los Alamos Nat'l Laboratory. See [Github Pull Request #44](https://github.com/Unidata/netcdf-fortran/pull/44) for more information.
* Integrated improvements provided by Richard Weed.  For a *complete* list of modifications, see the file `docs/netcdf_fortran_4.4.2dev_notes_RW.pdf`.  **It is highly detailed and worth reading!**

    The highlights of the improvements are as follows:

  * Explicit dependencies on `NC_MAX_DIM` constant for arrays has been removed and replaced with dynamically-allocated arrays.
  * Support for `nc_open_mem()` in the C library, allowing for the creation of "in memory" files.
  * General clean up.

## 4.4.3 Released 2016-01-20

* Corrected a bug which would return a false-positive in `nf_test` when using netCDF-C `4.4.0`.

* Updated the `cfortran.doc` license document for the `cfortran.h` library.  The most recent version was pulled from http://cfortran.sourceforge.net.  The previous version did not reflect that the author had released cfortran under the LGPL.  See [Github Issue 27](https://github.com/Unidata/netcdf-fortran/issues/27) for more information.

## 4.4.2 Released 2015-02-02

* Added infrastructure to support the new `netcdf-c` option, `ENABLE_REMOTE_FORTRAN_BOOTSTRAP`.

* Incorporated changes submitted by Nico Schlomer which extends the cmake compatibility between `netcdf-c` and `netcdf-fortran`.

* Incorporated a patch submitted by Thomas Jahns which fixed `FC` being unconditionally overwritten by `F77` when `Fortran 90` was disabled.

## 4.4.1 Released 2014-09-09

* No significant changes from RC1.

### 4.4.1-RC1 Released 2014-08-05

* Added a new variable for cmake-based builds, `NC_EXTRA_DEPS`.  Use this to specify additional dependencies when linking against a static `netcdf-c` library, e.g.

```.fortran
netcdf-fortran/build$ cmake .. -DNC_EXTRA_DEPS="-lhdf5 -lhdf5_hl -lcurl"
```

* Fixed to build correctly with netCDF-3-only C library, for example C library configured with --disable-netcdf-4 (R. Weed).

## 4.4 Released 2014-07-08

* For 32-bit platforms fixed integer fill parameters, initialized potentially
  unitialized variables, and provided some missing defaults (R. Weed).

* Fixed CMake builds on 32-bit platforms.

* Added new `inq_path` and `rename_grps` functions analogous to
  corresponding C functions. Added associated tests (R. Weed).

* Added support for NF\_MPIIO, `NF_MPIPOSIX`, `NF_PNETCDF` flags and
  `NF_FILL_UINT`. (R. Weed)

* Fixed potential bug in attribute functions for integer values when
  Fortran `INTEGER*1` or `INTEGER*2` types are the same size as C
  long (R. Weed).

* Added test for compiler support of Fortran 2008 `ISO_FORTRAN_ENV`
  additions and TS29113 standard extension.

* Fixed `C_PTR_DIFF_T` issue reported by Orion Poplowski (R. Weed).

### 4.4-rc1 	Released 2013-10-06

* Added doxygen-generated documentation, using the `--enable-doxygen` and `-DENABLE_DOXYGEN` flags for autotools and cmake-based builds, respectively.

* Added missing error codes for DAP and some netCDF-4 errors

* Fixed some documentation for F77 API, added make rule for creating netcdf-f77 HTML files.

### 4.4-beta5 	Released 2013-08-27

* Added configuration files to github distribution.

### 4.4-beta4

* Moved to GitHub from Subversion, the location of the new GitHub repository is at: http://github.com/Unidata/netCDF-Fortran

* Parallel-build portability fixes, particularly for
		OpenMPI and gcc/gfortran-4.8.x on the Mac.  Also added
		test from Reto Stöckli for NCF-250 bug, demonstrating
		it was fixed in previous commit.

* Add support for NF\_MPIIO, NF\_MPIPOSIX, NF\_PNETCDF, and
		NF\_FILL\_UINT in the data files.

* Add support for nf\_inq\_path.

* Add a pre-processor macro that can be used to bypass
		the home-brew C_PTRDIFF_T definition and use the
		standard one for compilers that support it.

* Fix a potential bug in nf\_attio to call the \_long
		version of some puts/gets instead of the \_int
		version. These were inside INT1\_IS\_C\_LONG and
		INT2\_IS\_C\_LONG ifdef blocks so they would have only
		showed up when those macros were true.

### 4.4-beta3	Released 2012-12-07

* Fixed bug that "make -j check" fails, but "make check" works fine.

* Fixed build problems resulting from syncing with separate C distribution.

* Synchronize with all changes made to version 4.2 since ts release.

### 4.4-beta2	Released 2012-06-29

* Made handling of --disable-f03 more transparent.

* Fixed adding flags for parallel I/O for MPI from David Warren.

* Removed all the old C code that's not needed for this separate distribution.

* Inadvertently broke the build until syncing with C distribution in later beta release.

### 4.4-beta1	Released 2012-03-02

* `Fortran 2003 Support`

    Version 4.4 is the first release to support fortran 2003 and to use the ISO C Bindings available in fortran 2003 to replace the older C code wrappers.

    Congratulations and thanks to Richard Weed at Mississippi State University, who is the author of new code.

    See the file `README_F03_MODS` for a more complete description of the changes. Many changes to the build structure have been made at the same time as the new 2003 code has been inserted.

    As part of the fortran 2003 refactor, the directory structure has been significantly modified.  All the previous F90 C wrapper code has been moved to the "libsrc" directory.

    All of the fortran code has been moved to the "fortran" directory. The directories names F77 and F90 have been removed. The most important consequence of this refactor is that pure Fortran77 compilers are no longer supported. It is assumed that the compiler supports at least Fortran 90 and also Fortran 77.  If it also supports the ISO C Bindings, then the new 2003 code is used instead of the older C wrappers.
