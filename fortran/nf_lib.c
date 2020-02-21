/*
  Copyright 2006-2019, University Corporation for Atmospheric
  Research. See the COPYRIGHT file for copying and redistribution
  conditions.
*/

/**
 * @file
 * This file contains C functions needed to convert C to Fortran
 * indexing (0-based to 1-based), the reversing the order of
 * dimensions between C and Fortran.
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
 * Get the varids for a fortran function (i.e. add 1 to each
 * varid.)
 *
 * @param ncid The ncid of the open file.
 * @param nvars Pointer that gets number of vars. Ignored if NULL.
 * @param fvarids Pointer that gets varids in Fortran indexing
 * (i.e. with 1 added to them).
 *
 * @return ::NC_NOERR No error.
 * @return ::NC_ENOMEM Out of memory.
 * @author Richard Weed
 */
extern int
nc_inq_varids_f(int ncid, int *nvars, int *fvarids)
{
    int *varids, nvars1;
    int i, ret = NC_NOERR;

    /* Get the information from the C library. */
    if ((ret = nc_inq_varids(ncid, &nvars1, NULL)))
        return ret;
    if (!(varids = malloc(nvars1 * sizeof(int))))
        return NC_ENOMEM;
    if ((ret = nc_inq_varids(ncid, NULL, varids)))
        goto exit;

    /* Add one to each, for fortran. */
    for (i = 0; i < nvars1; i++)
        fvarids[i] = varids[i] + 1;

    /* Tell the user how many there are. */
    if (nvars)
        *nvars = nvars1;

exit:
    free(varids);
    return ret;
}

/**
 * Get the dimids for a fortran function (i.e. add 1 to each
 * dimid.)
 *
 * @param ncid The ncid of the open file.
 * @param ndims Pointer that gets number of dims. Ignored if NULL.
 * @param fdimids Pointer that gets dimids in Fortran indexing
 * (i.e. with 1 added to them).
 * @param parent If non-zero, then also fetch dimsids from parent
 * groups.
 *
 * @return ::NC_NOERR No error.
 * @return ::NC_ENOMEM Out of memory.
 * @author Richard Weed
 */
extern int
nc_inq_dimids_f(int ncid, int *ndims, int *fdimids, int parent)
{
    int *dimids, ndims1;
    int i, ret = NC_NOERR;

    /* Get the information from the C library. */
    if ((ret = nc_inq_dimids(ncid, &ndims1, NULL, parent)))
        return ret;
    if (!(dimids = malloc(ndims1 * sizeof(int))))
        return NC_ENOMEM;
    if ((ret = nc_inq_dimids(ncid, NULL, dimids, parent)))
        goto exit;

    /* Add one to each, for fortran. */
    for (i = 0; i < ndims1; i++)
        fdimids[i] = dimids[i] + 1;

    /* Tell the user how many there are. */
    if (ndims)
        *ndims = ndims1;

exit:
    free(dimids);
    return ret;
}

/**
 * Insert an array into a compound type. Swap the dim sizes for
 * fortran.
 *
 * @param ncid The ncid of the open file.
 * @oaran typeid Type if the compound type.
 * @param name Name of the array to insert.
 * @param offset Offset into the compound type.
 * @param field_typeid Type of the array.
 * @param ndims Number of dimensions in array.
 * @param dim_sizesp Pointer to array of dim sizes.
 *
 * @return ::NC_NOERR No error.
 * @return ::NC_ENOMEM Out of memory.
 * @author Richard Weed
 */
extern int
nc_insert_array_compound_f(int ncid, int typeid, char *name,
                           size_t offset, nc_type field_typeid,
                           int ndims, int *dim_sizesp)
{
    int *dim_sizes_f;
    int i, ret;

    if (ndims <= 0)
        return NC_EINVAL;

    /* Allocate some storage to hold ids. */
    if (!(dim_sizes_f = malloc(ndims * sizeof(int))))
        return NC_ENOMEM;

    /* Create a backwards list of dimension sizes. */
    for (i = 0; i < ndims; i++)
        dim_sizes_f[i] = dim_sizesp[ndims - i - 1];

    /* Call with backwards list. */
    ret = nc_insert_array_compound(ncid, typeid, name, offset, field_typeid,
                                   ndims, dim_sizes_f);

    /* Clean up. */
    free(dim_sizes_f);
    return ret;
}

/**
 *
 * @param ncid The ncid of the open file.
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
 * Learn about a field in a compound type. Order of dimsizes is
 * swapped for the Fortran API.
 *
 * @param ncid The ncid of the open file.
 * @param xtype The typeid.
 * @param fieldid The fieldid.
 * @param name Pointer that gets name of the field. Ignored if NULL.
 * @param offsetp Pointer that gets the offset of the field. Ignored
 * if NULL.
 * @param field_typeidp Pointer that gets the typeid of the
 * field. Ignored if NULL.
 * @param ndimsp Pointer that gets the number of dims of the
 * field. Ignored if NULL.
 * @param dim_sizesp Pointer that gets array of sizes of the
 * dims. Ignored if NULL.

 *
 * @return ::NC_NOERR No error.
 * @return ::NC_ENOMEM Out of memory.
 * @author Richard Weed
 */
extern int
nc_inq_compound_field_f(int ncid, nc_type xtype, int fieldid, char *name,
                        size_t *offsetp, nc_type *field_typeidp, int *ndimsp,
                        int *dim_sizesp)
{
    int ndims;
    int ret;

    /* Find out how many dims. */
    if ((ret = nc_inq_compound_field(ncid, xtype, fieldid, NULL, NULL,
                                     NULL, &ndims, NULL)))
        return ret;

    /* Call the function. */
    if ((ret = nc_inq_compound_field(ncid, xtype, fieldid, name, offsetp,
                                     field_typeidp, ndimsp, dim_sizesp)))
        return ret;

    /* Swap the order of the dimsizes. */
    if (ndims)
    {
        int *f, *b, temp;
        for (f = dim_sizesp, b = &dim_sizesp[ndims - 1]; f < b; f++, b--)
        {
            temp = *f;
            *f = *b;
            *b = temp;
        }
    }

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
