SET(CMAKE_INCLUDE_CURRENT_DIR ON)

INCLUDE_DIRECTORIES(".")

SET(F03_TESTS nf03_test f03tst_vars f03tst_vars2 f03tst_vars3 f03tst_vars4 f03tst_vars5 f03tst_vars6 f03tst_types f03tst_types2 f03tst_types3 f03tst_groups f03tst_v2 f03test tst03_f77_v2)

# FILE(GLOB COPY_FILES ${CMAKE_CURRENT_SOURCE_DIR}/*.sh ${CMAKE_CURRENT_SOURCE_DIR}/*.cdl)
# FILE(COPY ${COPY_FILES} DESTINATION ${CMAKE_CURRENT_BINARY_DIR} FILE_PERMISSIONS OWNER_WRITE OWNER_READ OWNER_EXECUTE)

# FOREACH(F ${CDL_EXAMPLE_TESTS})
# 	add_sh_test(cdl ${F})
# ENDFOREACH()

SET(CLEANFILES scratch.nc test.nc copy.nc fills.nc ftst_vars.nc ftst_vars2.nc ftst_vars3.nc ftst_vars4.nc ftst_vars5.nc ftst_vars6.nc ftst_types.nc ftst_types2.nc ftst_types3.nc ftst_groups.nc ftst_v2.nc  test.nc tests.mod tst_f77_v2.nc *.o *.lo .libs/ _libs)
# SET_DIRECTORY_PROPERTIES(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "${CLEANFILES}")
