#!/usr/bin/env python3
# ******************************************************************************
# mws_smallest_rivs_global.py
# ******************************************************************************

# Purpose:
# Given shapefiles of corrected and uncorrected MeanDRS coastal rivers and the
# the catchments of eaches contributing to coastal rivers narrower than 100m,
# calculate global summary terms for rivers smaller than 100m.

# Author:
# Jeffrey Wade, Cedric H. David, 2025

# ******************************************************************************
# Import packages
# ******************************************************************************
import pandas as pd
import sys
import glob
import fiona
from collections import OrderedDict
import shapely.geometry
import shapely.ops
import os


# ******************************************************************************
# Declaration of variables (given as command line arguments)
# ******************************************************************************
# 1 - Qout_cst_cor_shp
# 2 - Qout_cst_uncor_shp
# 3 - cat_small_shp
# 4 - Qout_small_out
# 5 - cat_gl_out


# ******************************************************************************
# Get command line arguments
# ******************************************************************************
IS_arg = len(sys.argv)
if IS_arg != 7:
    print('ERROR - 6 arguments must be used')
    raise SystemExit(22)

Qout_cst_cor_shp = sys.argv[1]
Qout_cst_uncor_shp = sys.argv[2]
cat_small_shp = sys.argv[3]
Qout_small_out = sys.argv[4]
cat_gl_out = sys.argv[5]
cat_str = sys.argv[6]


# ******************************************************************************
# Check if files/folders exist
# ******************************************************************************
try:
    if os.path.isdir(Qout_cst_cor_shp):
        pass
except IOError:
    print('ERROR - '+Qout_cst_cor_shp+' invalid folder path')
    raise SystemExit(22)

try:
    if os.path.isdir(Qout_cst_uncor_shp):
        pass
except IOError:
    print('ERROR - '+Qout_cst_uncor_shp+' invalid folder path')
    raise SystemExit(22)

try:
    if os.path.isdir(cat_small_shp):
        pass
except IOError:
    print('ERROR - '+cat_small_shp+' invalid folder path')
    raise SystemExit(22)

try:
    if cat_str == 'gl_dis' or cat_str == 'no_gl_dis':
        pass
except IOError:
    print('ERROR - '+cat_str+' not valid format')
    raise SystemExit(22)


# ******************************************************************************
# Read files
# ******************************************************************************
print('- Reading files')
# ------------------------------------------------------------------------------
# MeanDRS Coastal Rivers
# ------------------------------------------------------------------------------
Qout_cst_cor_files = list(glob.iglob(Qout_cst_cor_shp+'*.shp'))
Qout_cst_cor_files.sort()
Qout_cst_cor = [fiona.open(j, 'r', crs="EPSG:4326") for j in Qout_cst_cor_files]

Qout_cst_uncor_files = list(glob.iglob(Qout_cst_uncor_shp+'*.shp'))
Qout_cst_uncor_files.sort()
Qout_cst_uncor = [fiona.open(j, 'r', crs="EPSG:4326") for j in
                  Qout_cst_uncor_files]

# Retrieve numbers of pfafs
pfaf_list = pd.Series([x.partition("pfaf_")[-1][0:2] for x in
                       Qout_cst_cor_files]).sort_values(ignore_index=True)


# ******************************************************************************
# Identify all coastal rivers narrower than 100m
# ******************************************************************************
print('- Computing small rivers global summary')
# Initialize list for storing features ids, Q, pfaf, and width region
riv_id = []
riv_uncor_Q = []
riv_cor_Q = []
riv_pfaf = []
riv_wid = []

# Loop through catchments
for j in range(len(Qout_cst_cor)):

    # Retrieve shapefile from selected basin
    Qout_cst_cor_sel = Qout_cst_cor[j]
    Qout_cst_uncor_sel = Qout_cst_uncor[j]

    # --------------------------------------------------------------------------
    # Loop through rivers, storing COMID and Q
    # --------------------------------------------------------------------------
    for riv_fea in Qout_cst_cor_sel:

        riv_id.append(riv_fea['properties']['COMID'])
        riv_pfaf.append(pfaf_list[j])
        # Convert discharge to km3/yr
        riv_uncor_Q.append(riv_fea['properties']['meanQ'] * 0.031536)
        # Estimate river width my Moody & Troutman, 2002
        riv_wid.append(7.2*(riv_fea['properties']['meanQ'] ** 0.5))

    for riv_fea in Qout_cst_cor_sel:
        # Convert discharge to km3/yr
        riv_cor_Q.append(riv_fea['properties']['meanQ'] * 0.031536)

# Combine lists into dataframe
Q_df = pd.DataFrame({'COMID': riv_id, 'pfaf': riv_pfaf,
                     'Qout_uncor': riv_uncor_Q, 'Qout_cor': riv_cor_Q,
                     'wid': riv_wid})

# Filter Q_df by width
Q_wid_df = Q_df[Q_df.wid < 100]

# Write dataframe to CSV
Q_wid_df.to_csv(Qout_small_out, index=False)


# ******************************************************************************
#  Read and dissolve small rivers catchment files globally
# ******************************************************************************
if cat_str == 'gl_dis':

    print('- Dissolving small coastal river catchments')
    # Retrieve dissolved catchment file paths for each pfaf
    cat_gl_files = list(glob.iglob(cat_small_shp+'*.shp'))
    cat_gl_files.sort()

    # Read catchment files from each pfaf
    cat_gl_raw = [fiona.open(fp, 'r') for fp in cat_gl_files]

    # Transform to geometry object
    cat_gl_geom = []
    for j in range(len(cat_gl_raw)):
        cat_gl_geom.extend([shapely.geometry.shape(cat_gl_raw[j][i]['geometry'])
                            for i in range(len(cat_gl_raw[j]))])

    # Merge catchments
    cat_gl_merge = shapely.ops.unary_union(cat_gl_geom)

    # Dissolve catchments
    if cat_gl_merge.geom_type == 'Polygon':
        cat_gl_dis = shapely.geometry.Polygon(cat_gl_merge.exterior)

    if cat_gl_merge.geom_type == 'MultiPolygon':
        cat_gl_dis = shapely.geometry.MultiPolygon(
              shapely.geometry.Polygon(p.exterior)
              for p in cat_gl_merge.geoms)

    # Create new schema schema
    cat_gl_sch = {'properties': OrderedDict([('pfaf', 'str:18')]),
                  'geometry': 'Polygon'}

    # Set properties
    cat_gl_prp = OrderedDict([('pfaf', 'global')])
    cat_crs = cat_gl_raw[0].crs

    # Copy geometries
    cat_dis_gl_geom = shapely.geometry.mapping(cat_gl_dis)

    # Write shapefiles
    cat_dis_gl_lay = fiona.open(cat_gl_out, 'w',
                                crs=cat_crs,
                                driver='ESRI Shapefile',
                                schema=cat_gl_sch
                                )

    cat_dis_gl_lay.write({'properties': cat_gl_prp,
                          'geometry': cat_dis_gl_geom,
                          })
    cat_dis_gl_lay.close()

else:
    print('- Skipping global catchment dissolve')
