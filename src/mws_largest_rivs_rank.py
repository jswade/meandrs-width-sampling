#!/usr/bin/env python3
# ******************************************************************************
# mws_largest_rivs_rank.py
# ******************************************************************************

# Purpose:
# Given corrected and uncorrected shapefiles of MeanDRS coastal river,
# corrected and uncorrected shapefiles of all MeanDRS rivers, and catchments
# from MERIT-Basins corresponding to each reach, identify the 10 largest global
# river basins based on discharge to coastal outlet

# Author:
# Jeffrey Wade, Cedric H. David, 2024

# ******************************************************************************
# Import packages
# ******************************************************************************
import pandas as pd
import fiona
import glob
import sys
import os


# ******************************************************************************
# Declaration of variables (given as command line arguments)
# ******************************************************************************
# 2 - riv_cst_cor_shp
# 3 - riv_cst_uncor_shp
# 3 - riv_cor_shp
# 4 - riv_uncor_shp
# 5 - cat_shp
# 6 - ranking_out


# ******************************************************************************
# Get command line arguments
# ******************************************************************************
IS_arg = len(sys.argv)
if IS_arg != 7:
    print('ERROR - 6 arguments must be used')
    raise SystemExit(22)

riv_cst_cor_shp = sys.argv[1]
riv_cst_uncor_shp = sys.argv[2]
riv_cor_shp = sys.argv[3]
riv_uncor_shp = sys.argv[4]
cat_shp = sys.argv[5]
ranking_out = sys.argv[6]


# ******************************************************************************
# Check if folders exist
# ******************************************************************************
try:
    if os.path.isdir(riv_cst_cor_shp):
        pass
except IOError:
    print('ERROR - '+riv_cst_cor_shp+' invalid folder path')
    raise SystemExit(22)

try:
    if os.path.isdir(riv_cst_uncor_shp):
        pass
except IOError:
    print('ERROR - '+riv_cst_uncor_shp+' invalid folder path')
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


# ******************************************************************************
# Read files
# ******************************************************************************
print('- Reading files')

# ------------------------------------------------------------------------------
# Load river files discharging into ocean
# ------------------------------------------------------------------------------
riv_cst_cor_files = list(glob.iglob(riv_cst_cor_shp+'*.shp'))
riv_cst_cor_files.sort()
riv_cst_cor = [fiona.open(j, 'r') for j in riv_cst_cor_files]

riv_cst_uncor_files = list(glob.iglob(riv_cst_uncor_shp+'*.shp'))
riv_cst_uncor_files.sort()
riv_cst_uncor = [fiona.open(j, 'r') for j in riv_cst_uncor_files]

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
# Retrieve COMIDs and Qout of reaches draining to ocean
# ******************************************************************************
print('- Identifying largest river basins')
# Initialize list for storing features ids, Q, pfaf, and width region
riv_id = []
riv_uncor_Q = []
riv_cor_Q = []
riv_pfaf = []

# Loop through regions
for j in range(len(riv_cor_files)):

    # Retrieve shapefile from selected region
    riv_uncor_sel = riv_cst_uncor[j]
    riv_cor_sel = riv_cst_cor[j]

    # --------------------------------------------------------------------------
    # Loop through rivers, storing COMID and Q
    # --------------------------------------------------------------------------
    for riv_fea in riv_uncor_sel:

        riv_id.append(riv_fea['properties']['COMID'])
        riv_pfaf.append(pfaf_list[j])
        # Convert discharge to km3/yr
        riv_uncor_Q.append(riv_fea['properties']['meanQ'] * 0.031536)

    for riv_fea in riv_cor_sel:
        # Convert discharge to km3/yr
        riv_cor_Q.append(riv_fea['properties']['meanQ'] * 0.031536)


# ------------------------------------------------------------------------------
# Identify largest coastal rivers
# ------------------------------------------------------------------------------
# Combine lists into dataframe
Q_df = pd.DataFrame({'COMID': riv_id, 'pfaf': riv_pfaf,
                     'Qout_uncor': riv_uncor_Q, 'Qout_cor': riv_cor_Q})

# Sort dataframe by Qout
Q_df = Q_df.sort_values(by='Qout_cor', ascending=False)
Q_df = Q_df.reset_index()

# Retrieve top 10 largest coastal outlets
Q_df_top10 = Q_df.copy().iloc[0:10, :]

# Add ranking column
Q_df_top10['ranking'] = list(range(1, 11))

# Write dataframe to CSV
Q_df_top10.to_csv(ranking_out, index=False)
