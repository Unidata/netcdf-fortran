/*
  Copyright 2006-2019, University Corporation for Atmospheric
  Research. See the COPYRIGHT file for copying and redistribution
  conditions.
*/

/**
 * @file
 * This file contains C functions not available in netcdf-c. The
 * C functions often require NULL parameters which cannot be
 * given in Fortran f77 directly.
 *
 * @author Richard Weed Ph.D. Center for Advanced Vehicular Systems,
 * Mississippi State University, Ed Hartnett, Dennis Heimbigner
 */

/* #include <config.h> */
#include <stddef.h>     /* for NULL */
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "netcdf.h"

#ifdef USE_NETCDF4

/**
 * Get the number of dimensions for a field.
 *
 * @param ncid The ncid of the open file.
 * @param xtype The typeid.
 * @param fieldid The fieldid.
 * @param ndims Pointer that gets the number of dims of the
 * field. Ignored if NULL.
 *
 * @return ::NC_NOERR No error.
 * @return ::NC_ENOMEM Out of memory.
 * @author Richard Weed
 */
extern int
nc_inq_compound_field_ndims(int ncid, nc_type xtype, int fieldid, int *ndims)
{
    int ret;

    /* Find out how many dims. */
    if ((ret = nc_inq_compound_field(ncid, xtype, fieldid, NULL, NULL,
                                     NULL, ndims, NULL)))
        return ret;
    return NC_NOERR;
}

/**
 * Get the number of groups.
 *
 * @param ncid The ncid of the open file.
 * @param numgrps Pointer that gets the number of groups. Ignored if
 * NULL.
 *
 * @return ::NC_NOERR No error.
 * @return ::NC_ENOMEM Out of memory.
 * @author Richard Weed
 */
extern int
nc_inq_numgrps(int ncid, int *numgrps)
{
    return nc_inq_grps(ncid, numgrps, NULL);
}

/**
 * Learn how may user-defined types are in a group.
 *
 * @param ncid The ncid of the open file.
 * @param ntypes Pointer that gets number of types. Ignored if NULL.
 *
 * @return ::NC_NOERR No error.
 * @return ::NC_ENOMEM Out of memory.
 * @author Richard Weed
 */
extern int
nc_inq_numtypes(int ncid, int *numtypes)
{
    return nc_inq_typeids(ncid, numtypes, NULL);
}

/**
 * Learn the number of filter paramters.
 *
 * @param ncid The ncid of the open file.
 * @param varid The variable ID.
 * @param nparamsp Pointer that gets number of parameters. Ignored if
 * NULL.
 *
 * @return ::NC_NOERR No error.
 * @return ::NC_ENOMEM Out of memory.
 * @author Dennis Heimbigner
 */
extern int
nc_inq_varnparams(int ncid, int varid, size_t *nparamsp)
{
    unsigned int id;
    size_t nparams;
    int ret;

    if ((ret = nc_inq_var_filter(ncid, varid, &id, &nparams, NULL)))
        return ret;
    if (nparamsp)
        *nparamsp = nparams;

    return NC_NOERR;
}

/**
 * Get the number of dimids.
 *
 * @param[in] ncid    The ncid of the group in question.
 * @param[out] ndims  Pointer to memory to contain the number of dimids associated with the group.
 * @param[in] include_parents If non-zero, parent groups are
 *       also traversed.
 *
 * @return Error code or ::NC_NOERR for no error.
 */
extern int
nc_inq_numdimids(int ncid, int *ndims, int include_parents)
{
  return nc_inq_dimids(ncid, ndims, NULL, include_parents);
}

#endif /*USE_NETCDF4*/

/*
  add a dummy nc_rename_grp function if it is not supported. This is include
  here so we can build/test with netCDF < version 4.3.1 without
*/

#ifndef NC_HAVE_RENAME_GRP
extern int
nc_rename_grp(int ncid, const char *name)
{
    printf("\n*** Warning - nc_rename_grp not supported in this netCDF version\n");
    printf("*** Update your netCDF C libraries to version 4.3.1 or higher\n");

    return NC_ENOGRP;

}
#endif
