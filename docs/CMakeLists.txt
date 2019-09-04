#####
# Build doxygen documentation, if need be.
#####
IF(ENABLE_DOXYGEN)

  FILE(GLOB COPY_FILES ${CMAKE_CURRENT_SOURCE_DIR}/*.html ${CMAKE_CURRENT_SOURCE_DIR}/images ${CMAKE_CURRENT_SOURCE_DIR}/*.doc ${CMAKE_CURRENT_SOURCE_DIR}/*.xml ${CMAKE_CURRENT_SOURCE_DIR}/*.m4 ${CMAKE_CURRENT_SOURCE_DIR}/*.texi)
  FILE(COPY ${COPY_FILES} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/)
  # Copy the image files used by markdown documentation
  # manually.
  FILE(GLOB IMG_FILES ${CMAKE_CURRENT_BINARY_DIR}/images/*.jpg)

  # Set abs_top_srcdir to work with autotools doxyfile template.
  SET(abs_top_srcdir "${CMAKE_SOURCE_DIR}")
  SET(abs_builddir "${CMAKE_CURRENT_BINARY_DIR}")

  CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in
    ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)
  ADD_CUSTOM_TARGET(doc ALL
    ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Generating API Documentation with Doxygen" VERBATIM
    )
  FILE(COPY ${IMG_FILES} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/html/)
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