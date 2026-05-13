#####
# Build doxygen documentation, if need be.
#####
IF(ENABLE_DOXYGEN)

  file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/
    DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/
    FILES_MATCHING
    PATTERN ".html"
    PATTERN ".doc"
    PATTERN ".xml"
    PATTERN ".m4"
    PATTERN ".texi"
    PATTERN "images/")

  # Set abs_top_srcdir to work with autotools doxyfile template.
  SET(abs_top_srcdir "${NC4F_SOURCE_DIR}")
  SET(abs_builddir "${CMAKE_CURRENT_BINARY_DIR}")

  CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in
    ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)
  ADD_CUSTOM_TARGET(doc ALL
    ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Generating API Documentation with Doxygen" VERBATIM
    )

  # Copy the image files used by markdown documentation
  # manually.
  file(COPY ${CMAKE_CURRENT_BINARY_DIR}/images/
    DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/html/
    FILES_MATCHING PATTERN ".jpg")
ENDIF()

IF(HAVE_M4)
IF(NOT MSVC)
       ADD_CUSTOM_TARGET(manpage ALL
         COMMAND ${NF_M4} '${CMAKE_CURRENT_SOURCE_DIR}/netcdf.m4' > '${CMAKE_CURRENT_BINARY_DIR}/netcdf_fortran.3'
         WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
         )

  INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/netcdf_fortran.3 DESTINATION "share/man/man3" COMPONENT documentation)
ENDIF(NOT MSVC)
ENDIF(HAVE_M4)
