#!/usr/bin/env python3
# ******************************************************************************
# mws_coastal_rivs.py
# ******************************************************************************

# Purpose:
# Given a shapefile of dissolved MERIT-Basins catchment, a global perimeter
# of MERIT-Basins region, corrected MeanDRS river shapefiles, and uncorrected
# MeanDRS river shapefiles, identify rivers draining to the coast for corrected
# and uncorrected scenarios.

# Author:
# Jeffrey Wade, Cedric H. David, 2025


# ******************************************************************************
# Import Python modules
# ******************************************************************************
import fiona
import shapely.geometry
import shapely.ops
import netCDF4 as nc
import numpy as np
import sys


# ******************************************************************************
# Declaration of variables (given as command line arguments)
# ******************************************************************************
# 1 - cat_dis_shp
# 2 - cat_perim_shp
# 3 - riv_cor_shp
# 4 - riv_uncor_shp
# 5 - Qout_uncor_shp
# 6 - riv_cst_cor_out
# 7 - riv_cst_uncor_out


# ******************************************************************************
# Get command line arguments
# ******************************************************************************
IS_arg = len(sys.argv)
if (IS_arg < 7) or (IS_arg > 8):
    print('ERROR - 6 or 7 arguments must be used')
    raise SystemExit(22)

# Allow option of producing corrected coastal rivers
if IS_arg == 7:
    cat_dis_shp = sys.argv[1]
    cat_perim_shp = sys.argv[2]
    riv_cor_shp = sys.argv[3]
    riv_uncor_shp = sys.argv[4]
    Qout_uncor_nc = sys.argv[5]
    riv_cst_uncor_out = sys.argv[6]

elif IS_arg == 8:
    cat_dis_shp = sys.argv[1]
    cat_perim_shp = sys.argv[2]
    riv_cor_shp = sys.argv[3]
    riv_uncor_shp = sys.argv[4]
    Qout_uncor_nc = sys.argv[5]
    riv_cst_uncor_out = sys.argv[6]
    riv_cst_cor_out = sys.argv[7]


# ******************************************************************************
# Check if files exist
# ******************************************************************************
try:
    with open(cat_dis_shp) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+cat_dis_shp)
    raise SystemExit(22)

try:
    with open(cat_perim_shp) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+cat_perim_shp)
    raise SystemExit(22)

try:
    with open(riv_cor_shp) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+riv_cor_shp)
    raise SystemExit(22)

try:
    with open(riv_uncor_shp) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+riv_uncor_shp)
    raise SystemExit(22)

try:
    with open(Qout_uncor_nc) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_uncor_nc)
    raise SystemExit(22)

# Confirm files refer to same region
cat_dis_reg = cat_dis_shp.split('pfaf_')[1][0:2]
riv_cor_reg = riv_cor_shp.split('pfaf_')[1][0:2]
riv_uncor_reg = riv_uncor_shp.split('pfaf_')[1][0:2]
Qout_uncor_reg = Qout_uncor_nc.split('pfaf_')[1][0:2]

if not (cat_dis_reg == riv_cor_reg == riv_uncor_reg == Qout_uncor_reg):
    print('ERROR - Input files correspond to different regions')
    raise SystemExit(22)


# ******************************************************************************
# Read shapefiles
# ******************************************************************************
print('- Reading shapefiles')
# ------------------------------------------------------------------------------
# MERIT-Basins Dissolved Catchments
# ------------------------------------------------------------------------------
# Read shapefile
cat_dis = fiona.open(cat_dis_shp, 'r', crs="EPSG:4326")

# Retrieve geometry
cat_dis_geom = shapely.geometry.shape(cat_dis[0]['geometry'])

# ------------------------------------------------------------------------------
# MERIT-Basins Global Perimeter
# ------------------------------------------------------------------------------
# Read shapefile
cat_perim = fiona.open(cat_perim_shp, 'r', crs="EPSG:4326")

# Retrieve geometry
cat_perim_geom = shapely.geometry.shape(cat_perim[0]['geometry'])

# ------------------------------------------------------------------------------
# MeanDRS Corrected Rivers
# ------------------------------------------------------------------------------
# Read to shapefile
riv_cor = fiona.open(riv_cor_shp, 'r', crs="EPSG:4326")

# ------------------------------------------------------------------------------
# MeanDRS Uncorrected Rivers
# ------------------------------------------------------------------------------
# Read to shapefile
riv_uncor = fiona.open(riv_uncor_shp, 'r', crs="EPSG:4326")

# ------------------------------------------------------------------------------
# MeanDRS Uncorrected Discharge
# ------------------------------------------------------------------------------
# Read to shapefile
Qout_uncor = nc.Dataset(Qout_uncor_nc, 'r')


# ******************************************************************************
# Clip coastline by MERIT-Basins pfaf 2 region
# ******************************************************************************
print('- Clipping global coastline')
# Clip global coast to basin
# Catch non-intersectingregions, which return anomalous values in .intersection
if cat_perim_geom.intersects(cat_dis_geom):

    cst_perim_clip = cat_perim_geom.intersection(cat_dis_geom)

else:

    cst_perim_clip = 0


# ******************************************************************************
# Identify coastal rivers and write to file
# ******************************************************************************
print('- Identifying rivers draining to coast')
# Set buffer distance to coast in degrees (200m)
cst_buf = .0018

# Intialize list to store selected river reaches
riv_cst = []

# Copy schema and crs
mb_schema = riv_cor.schema.copy()
mb_crs = riv_cor.crs

# Check that region is not interior
if cst_perim_clip == 0:

    # --------------------------------------------------------------------------
    # If no coastal feature, write empty shapefile
    # --------------------------------------------------------------------------
    if IS_arg == 8:
        # Write coastal corrected rivers
        with fiona.open(riv_cst_cor_out, 'w', schema=mb_schema,
                        driver='ESRI Shapefile',
                        crs=mb_crs) as output:
            for riv_fea in riv_cor:
                if riv_fea['properties']['COMID'] in riv_cst:
                    output.write(riv_fea)

    # Write coastal uncorrected rivers
    with fiona.open(riv_cst_uncor_out, 'w', schema=mb_schema,
                    driver='ESRI Shapefile',
                    crs=mb_crs) as output:
        for riv_fea in riv_uncor:
            if riv_fea['properties']['COMID'] in riv_cst:
                output.write(riv_fea)

else:

    # --------------------------------------------------------------------------
    # Intersect reaches and coast by buffer distance
    # --------------------------------------------------------------------------
    # Loop through features in each catchment
    for riv_fea in riv_cor:

        # Retrieve next downstream ID
        riv_did = riv_fea['properties']['NextDownID']

        # If Next downstream ID = 0
        if riv_did == 0:

            # Retrieve geometry
            riv_fea_geom = shapely.geometry.shape(riv_fea['geometry'])

            # Calculate distance to coast
            cst_dis = cst_perim_clip.distance(riv_fea_geom)

            # ------------------------------------------------------------------
            # Current reach is within buffer distance of coast
            # ------------------------------------------------------------------
            if cst_dis < cst_buf:
                # Add id to list
                riv_cst.append(riv_fea['properties']['COMID'])

    # --------------------------------------------------------------------------
    # Retrieve mean uncorrected Qout values for coastal rivers
    # --------------------------------------------------------------------------
    # Retrieve values from netcdf
    rivid = Qout_uncor.variables['rivid'][:]
    Qout = Qout_uncor.variables['Qout'][:]

    # Find incides of riv_cst reaches
    cst_ind = np.isin(rivid, riv_cst)

    # Filter Qout by cst_ind
    Qout_cst = Qout[:, cst_ind]

    # Calculate mean discharge of Qout_cst
    Qout_cst_mean = np.round(np.mean(Qout_cst, axis=0).compressed(), 5)

    # --------------------------------------------------------------------------
    # Write coastal rivers to shapefile
    # --------------------------------------------------------------------------
    print('- Writing shapefiles')
    if IS_arg == 8:
        # Write coastal corrected rivers
        with fiona.open(riv_cst_cor_out, 'w', schema=mb_schema,
                        driver='ESRI Shapefile',
                        crs=mb_crs) as output:
            for riv_fea in riv_cor:
                if riv_fea['properties']['COMID'] in riv_cst:
                    output.write(riv_fea)

    # Write coastal uncorrected rivers with mean uncorrected meanQ values
    with fiona.open(riv_uncor_shp, 'r') as source:

        r_schema = source.schema
        r_crs = source.crs

        with fiona.open(riv_cst_uncor_out, 'w', schema=r_schema,
                        driver='ESRI Shapefile',
                        crs=r_crs) as output:
            for riv_fea in riv_uncor:
                if riv_fea['properties']['COMID'] in riv_cst:
                    # Get index of location in riv_cst
                    riv_ind = riv_cst.index(riv_fea['properties']['COMID'])
                    # Copy features
                    new_riv_fea = riv_fea.copy()
                    # Replace meanQ value
                    new_riv_fea['properties']['meanQ'] =                       \
                        float(Qout_cst_mean[riv_ind])
                    output.write(new_riv_fea)
