CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

# Tell make to install these as a header file.
#SET(include_HEADERS nfconfig.inc)
#SET(CMAKE_INCLUDE_CURRENT_DIR ON)

#INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR} ${CMAKE_CPP_FLAGS})

# The nfconfig.in file is turned into nfconfig.inc by the configure
# script. The man page is generated on the developers machine for the
# dist.
#SET(EXTRA_DIST nfconfig.in nfconfig.inc)

# These files need to be cleaned up my make.
SET(CLEANFILES nfconfig1.inc netcdf.inc)
SET(DISTCLEANFILES nfconfig.inc )
