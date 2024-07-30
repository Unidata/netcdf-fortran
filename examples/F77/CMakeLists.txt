SET(example_F77_tests simple_xy_wr simple_xy_rd sfc_pres_temp_wr sfc_pres_temp_rd pres_temp_4D_wr pres_temp_4D_rd)
SET(example_F77_tests_source "")
FOREACH(F ${example_F77_tests}) 
  SET(example_F77_tests_source ${example_F77_test_source} ${F}.F)
ENDFOREACH()

SET(prefix F77_tests)
FOREACH(F ${example_F77_tests})
  ADD_EXECUTABLE(${prefix}_${F} ${F}.F)
  TARGET_LINK_LIBRARIES(${prefix}_${F} netcdff)
  IF(MSVC)
    SET_TARGET_PROPERTIES(${prefix}_${F} 
      PROPERTIES LINK_FLAGS_DEBUG " /NODEFAULTLIB:MSVCRT"
      )
  ENDIF()
  ADD_TEST(${prefix}_${F} ${EXECUTABLE_OUTPUT_PATH}/${prefix}_${F})
  IF(MSVC)
    SET_PROPERTY(TEST ${prefix}_${F} PROPERTY FOLDER "tests/")
  ENDIF()	
ENDFOREACH()

# Set some order dependencies on tests
set_tests_properties(F77_tests_simple_xy_rd PROPERTIES DEPENDS "F77_tests_simple_xy_wr")
set_tests_properties(F77_tests_sfc_pres_temp_rd PROPERTIES DEPENDS "F77_tests_sfc_pres_temp_wr")
set_tests_properties(F77_tests_pres_temp_4D_rd PROPERTIES DEPENDS "F77_tests_pres_temp_4D_wr")


SET(CLEANFILES sfc_pres_temp.nc simple_xy.nc pres_temp_4D.nc simple_nc4.nc simple_xy_nc4.nc)
SET_DIRECTORY_PROPERTIES(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "${CLEANFILES}")

