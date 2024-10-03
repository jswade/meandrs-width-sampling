#!/usr/bin/env python3
# ******************************************************************************
# mws_largest_rivs_trace.py
# ******************************************************************************

# Purpose:
# Given a csv ranking the 10 largest basins, a RAPID routing connectivity csv,
# corrected and uncorrected MeanDRS river reaches, a shapefile of catchments
# from MERIT-Basins corresponding to each reach, and a desired basin rank,
# identify contributing reaches and catchments from largest basin of interest.

# Author:
# Jeffrey Wade, Cedric H. David, 2024

# ******************************************************************************
# Import packages
# ******************************************************************************
import pandas as pd
import csv
import fiona
import glob
import shapely.geometry
import shapely.ops
from collections import OrderedDict
import sys
import os


# ******************************************************************************
# Declaration of variables (given as command line arguments)
# ******************************************************************************
# 1 - ranking_csv
# 2 - con_csv
# 3 - riv_cor_shp
# 4 - riv_uncor_shp
# 5 - cat_shp
# 6 - rank
# 7 - riv_out
# 8 - cat_out
# 9 - cat_dis_out


# ******************************************************************************
# Get command line arguments
# ******************************************************************************
IS_arg = len(sys.argv)
if IS_arg != 10:
    print('ERROR - 9 arguments must be used')
    raise SystemExit(22)

ranking_csv = sys.argv[1]
con_csv = sys.argv[2]
riv_cor_shp = sys.argv[3]
riv_uncor_shp = sys.argv[4]
cat_shp = sys.argv[5]
rank = sys.argv[6]
riv_out = sys.argv[7]
cat_out = sys.argv[8]
cat_dis_out = sys.argv[9]


# ******************************************************************************
# Check if files/folders exist
# ******************************************************************************
try:
    with open(ranking_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+ranking_csv)
    raise SystemExit(22)

try:
    if os.path.isdir(con_csv):
        pass
except IOError:
    print('ERROR - '+con_csv+' invalid folder path')
    raise SystemExit(22)

try:
    if os.path.isdir(riv_cor_shp):
        pass
except IOError:
    print('ERROR - '+riv_cor_shp+' invalid folder path')
    raise SystemExit(22)

try:
    if os.path.isdir(riv_uncor_shp):
        pass
except IOError:
    print('ERROR - '+riv_uncor_shp+' invalid folder path')
    raise SystemExit(22)

try:
    if os.path.isdir(cat_shp):
        pass
except IOError:
    print('ERROR - '+cat_shp+' invalid folder path')
    raise SystemExit(22)

try:
    if (int(rank) >= 1) & (int(rank) <= 10):
        pass
except IOError:
    print('ERROR - '+rank+' not within range 1-10')
    raise SystemExit(22)


# ******************************************************************************
# Read files
# ******************************************************************************
print('- Reading files')
# ------------------------------------------------------------------------------
# Load largest rivers ranking file
# ------------------------------------------------------------------------------
Q_df_top10 = pd.read_csv(ranking_csv)

# ------------------------------------------------------------------------------
# Load MeanDRS RAPID river connectivity files
# ------------------------------------------------------------------------------
# Columns of connectivity files
# 0: COMID
# 1: Next Downstream
# 2: Upstream number of reaches
# 3-7: Upstream reaches 1-5

# Read connectivity files
con_files = list(glob.iglob(con_csv+'*'))
con_files.sort()
con = [pd.read_csv(j, header=None) for j in con_files]

# ------------------------------------------------------------------------------
# Load all river files
# ------------------------------------------------------------------------------
riv_cor_files = list(glob.iglob(riv_cor_shp+'*.shp'))
riv_cor_files.sort()
riv_cor = [fiona.open(j, 'r') for j in riv_cor_files]

riv_uncor_files = list(glob.iglob(riv_uncor_shp+'*.shp'))
riv_uncor_files.sort()
riv_uncor = [fiona.open(j, 'r') for j in riv_uncor_files]

# Retrieve numbers of pfafs
pfaf_list = pd.Series([x.partition("pfaf_")[-1][0:2] for x in
                       riv_cor_files]).sort_values(ignore_index=True)

# ------------------------------------------------------------------------------
# Load catchment files
# ------------------------------------------------------------------------------
cat_files = list(glob.iglob(cat_shp+'*.shp'))
cat_files.sort()
cat = [fiona.open(j, 'r') for j in cat_files]


# ******************************************************************************
# Trace upstream network of each largest river
# ******************************************************************************
print('- Tracing largest rivers upstream')
# See https://github.com/c-h-david/rrr/blob/master/src/rrr_riv_tot_net_nav.py

# Get index of desired ranking
rank_ind = Q_df_top10[Q_df_top10.ranking == int(rank)].index[0]

# Retrieve COMID and pfaf of given reach
IS_riv_id = Q_df_top10.COMID[rank_ind]
pfaf_sel = Q_df_top10.pfaf[rank_ind]

# ------------------------------------------------------------------------------
# For given reach, format river connectivity file of region
# ------------------------------------------------------------------------------

# Retrieve pfaf index for given reach
ind = pfaf_list[pfaf_list == str(pfaf_sel)].index[0]

# Read and format connectivity file for given region
IV_riv_tot_id = []  # COMID
IV_riv_dwn_id = []  # Next Downstream ID
IV_riv_ups_nb = []  # Number of upstream IDs
IM_riv_ups_id = []  # Upstream IDs 1-5

with open(con_files[ind], 'r') as csvfile:
    csvreader = csv.reader(csvfile)
    for row in csvreader:
        IV_riv_tot_id.append(int(row[0]))
        IV_riv_dwn_id.append(int(row[1]))
        IV_riv_ups_nb.append(int(row[2]))
        IM_riv_ups_id.append([int(rivid) for rivid in row[3:]])

# Number of reaches in connectivity file
IS_riv_tot = len(IV_riv_tot_id)

# Create hash table for connectivity
IM_hsh = {}

for JS_riv_tot in range(IS_riv_tot):
    IM_hsh[IV_riv_tot_id[JS_riv_tot]] = JS_riv_tot

# ------------------------------------------------------------------------------
# Find upstream reaches of coastal outlets
# ------------------------------------------------------------------------------
# Select hash of given river to trace
JS_riv_tot = IM_hsh[IS_riv_id]

# Create list of all indexes upstream of current index
# Start with hash of coastal outlet
riv_ups_hsh = [JS_riv_tot]

# Retrieve IDs of river that are directly upstream of current index
IV_riv_ups_id = IM_riv_ups_id[JS_riv_tot][0:IV_riv_ups_nb[JS_riv_tot]]

# Initialize counter
JS_riv_ups = 0

# Effectively infinite loop continues until no reaches returned
while JS_riv_ups < 1e7:

    # Increment counter
    JS_riv_ups = JS_riv_ups+1

    # Initialize list for storing next upstream id
    IV_riv_nxt_id = []

    # Loop through ids in next upstream ID for given reach
    for JS_riv_ups_id in IV_riv_ups_id:

        # Retrieve hash value for next ID
        JS_riv_ups_ix = IM_hsh[JS_riv_ups_id]

        # Append hash value to list
        riv_ups_hsh.append(JS_riv_ups_ix)

        # Get values of existing upstream IDs of IV_riv_ups_id reaches
        IV_riv_nxt_id = IV_riv_nxt_id +                                        \
            IM_riv_ups_id[JS_riv_ups_ix][0:IV_riv_ups_nb[JS_riv_ups_ix]]

    # If reaches exist, add to list
    if len(IV_riv_nxt_id) != 0:
        IV_riv_ups_id = IV_riv_nxt_id
    else:
        # This break statement exits the for loop if no more upstream
        # reaches exist
        break


# ******************************************************************************
# Write traced reaches to shapefile
# ******************************************************************************
print('- Writing traced reaches to shapefile')
# Translate hashes into reach IDs
riv_ups_comid = [IV_riv_tot_id[x] for x in riv_ups_hsh]

# Load full network MERIT-Hydro reaches: Uncorrected to calculate width
riv_sel = riv_uncor[ind]

# Copy schema and crs
meandrs_schema = riv_uncor[0].schema.copy()
meandrs_crs = riv_uncor[0].crs

# Write to file
with fiona.open(riv_out, 'w', schema=meandrs_schema,
                driver='ESRI Shapefile',
                crs=meandrs_crs) as output:
    for riv_fea in riv_sel:
        if riv_fea['properties']['COMID'] in riv_ups_comid:
            output.write(riv_fea)


# ******************************************************************************
# Write corresponding catchments to file
# ******************************************************************************
print('- Writing traced catchments to file')
# Load MERIT-Hydro catchments
cat_sel = cat[ind]

# Copy schema and crs
cat_schema = cat[0].schema.copy()
cat_crs = cat[0].crs

# If crs is empty, set crs to WGS 84
if len(cat_crs) == 0:
    cat_crs = 'epsg:4326'

# Write to file
with fiona.open(cat_out, 'w', schema=cat_schema,
                driver='ESRI Shapefile',
                crs=cat_crs) as output:
    for cat_fea in cat_sel:
        if cat_fea['properties']['COMID'] in riv_ups_comid:
            output.write(cat_fea)


# ******************************************************************************
# Dissolve catchment files
# ******************************************************************************
print('- Dissolved traced catchments')
# Read undissolved catchment files
cat_raw = fiona.open(cat_out, 'r')

# Transform to geometry object
cat_geom = [shapely.geometry.shape(cat_raw[j]['geometry']) for j in
            range(len(cat_raw))]

# Merge catchments
cat_merge = shapely.ops.unary_union(cat_geom)

# Dissolve catchments
if cat_merge.geom_type == 'Polygon':
    cat_dis = shapely.geometry.Polygon(cat_merge.exterior)

if cat_merge.geom_type == 'MultiPolygon':
    cat_dis = shapely.geometry.MultiPolygon(shapely.geometry.Polygon(p.exterior)
                                            for p in cat_merge.geoms)

# Create new schema schema
cat_sch = {'properties': OrderedDict([('outlet_id', 'str:18')]),
           'geometry': 'Polygon'}

# Set properties
cat_prp = OrderedDict([('outlet_id', str(IS_riv_id))])

# Copy geometries
cat_dis_geom = shapely.geometry.mapping(cat_dis)

# Write shapefiles
cat_dis_lay = fiona.open(cat_dis_out, 'w', crs=cat_crs, driver='ESRI Shapefile',
                         schema=cat_sch)

cat_dis_lay.write({'properties': cat_prp, 'geometry': cat_dis_geom})
cat_dis_lay.close()
