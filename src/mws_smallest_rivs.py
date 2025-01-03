#!/usr/bin/env python3
# ******************************************************************************
# mws_smallest_rivs.py
# ******************************************************************************

# Purpose:
# Given a RAPID routing connectivity csv, corrected and uncorrected MeanDRS
# river reaches drainging to the coast, corrected and uncorrected MeanDRS river
# reaches, a shapefile of catchments from MERIT-Basins corresponding to each
# reach, identify rivers narrower than 100m draining to the coast.

# Author:
# Jeffrey Wade, Cedric H. David, 2025

# ******************************************************************************
# Import packages
# ******************************************************************************
import csv
import fiona
import sys


# ******************************************************************************
# Declaration of variables (given as command line arguments)
# ******************************************************************************
# 1 - con_csv
# 2 - riv_cst_cor_shp
# 3 - riv_cst_uncor_shp
# 4 - riv_cor_shp
# 5 - riv_uncor_shp
# 6 - cat_shp
# 7 - riv_out
# 8 - cat_out
# 9 - cat_dis_out


# ******************************************************************************
# Get command line arguments
# ******************************************************************************
IS_arg = len(sys.argv)
if IS_arg != 9:
    print('ERROR - 8 arguments must be used')
    raise SystemExit(22)

con_csv = sys.argv[1]
riv_cst_cor_shp = sys.argv[2]
riv_cst_uncor_shp = sys.argv[3]
riv_cor_shp = sys.argv[4]
riv_uncor_shp = sys.argv[5]
cat_shp = sys.argv[6]
riv_out = sys.argv[7]
cat_out = sys.argv[8]


# ******************************************************************************
# Check if files/folders exist
# ******************************************************************************
try:
    with open(con_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+con_csv)
    raise SystemExit(22)

try:
    with open(riv_cst_cor_shp) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+riv_cst_cor_shp)
    raise SystemExit(22)

try:
    with open(riv_cst_uncor_shp) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+riv_cst_uncor_shp)
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
    with open(cat_shp) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+cat_shp)
    raise SystemExit(22)


# ******************************************************************************
# Read files
# ******************************************************************************
print('- Reading files')
# ------------------------------------------------------------------------------
# Load river files discharging into ocean
# ------------------------------------------------------------------------------
riv_cst_cor = fiona.open(riv_cst_cor_shp, 'r')
riv_cst_uncor = fiona.open(riv_cst_uncor_shp, 'r')

# ------------------------------------------------------------------------------
# Load all river files
# ------------------------------------------------------------------------------
riv_cor = fiona.open(riv_cor_shp, 'r')
riv_uncor = fiona.open(riv_uncor_shp, 'r')

# ------------------------------------------------------------------------------
# Load catchment files
# ------------------------------------------------------------------------------
cat = fiona.open(cat_shp, 'r')


# ******************************************************************************
# Retrieve COMIDs and Qout of reaches draining to ocean
# ******************************************************************************
print('- Identify rivers draining to the ocean')
# Initialize list for storing features ids, Q, and width
riv_id = []
riv_uncor_Q = []
riv_cor_Q = []
riv_wid = []

# ------------------------------------------------------------------------------
# Loop through rivers, storing COMID and Q
# ------------------------------------------------------------------------------
for riv_fea in riv_cst_uncor:

    riv_id.append(riv_fea['properties']['COMID'])

    # Convert discharge to km3/yr
    riv_uncor_Q.append(riv_fea['properties']['meanQ'] * 0.031536)
    # Estimate river width my Moody & Troutman, 2002
    riv_wid.append(7.2*(riv_fea['properties']['meanQ'] ** 0.5))

for riv_fea in riv_cst_cor:
    # Convert discharge to km3/yr
    riv_cor_Q.append(riv_fea['properties']['meanQ'] * 0.031536)


# ******************************************************************************
# Trace upstream network of rivers narrow than 100m
# ******************************************************************************
print('- Tracing rivers upstream')
# See https://github.com/c-h-david/rrr/blob/master/src/rrr_riv_tot_net_nav.py

# ------------------------------------------------------------------------------
# Format river connectivity file of region
# ------------------------------------------------------------------------------
# Read and format connectivity file
IV_riv_tot_id = []  # COMID
IV_riv_dwn_id = []  # Next Downstream ID
IV_riv_ups_nb = []  # Number of upstream IDs
IM_riv_ups_id = []  # Upstream IDs 1-5

with open(con_csv, 'r') as csvfile:
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
# Initalize list to store reach hashes upstream of current index
riv_ups_hsh = []

# Loop through river reaches
for i in range(len(riv_id)):

    # Retrieve COMID of given reach
    IS_riv_id = riv_id[i]

    # Select hash of given river to trace
    JS_riv_tot = IM_hsh[IS_riv_id]

    # Add hash of starting coastal outlet
    riv_ups_hsh.append(JS_riv_tot)

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
            IV_riv_nxt_id = IV_riv_nxt_id +                                    \
                IM_riv_ups_id[JS_riv_ups_ix][0:IV_riv_ups_nb[JS_riv_ups_ix]]

        # If reaches exist, add to list
        if len(IV_riv_nxt_id) != 0:
            IV_riv_ups_id = IV_riv_nxt_id
        else:
            # This break statement exits the for loop if no more upstream
            # reaches exist
            break


# ******************************************************************************
# Write uncorrected traced reaches to shapefile
# ******************************************************************************
print('- Writing traced rivers to shapefile')
# Translate hashes into reach IDs
riv_ups_comid = [IV_riv_tot_id[x] for x in riv_ups_hsh]

# Remove duplicates (None should exist)
riv_ups_comid = list(set(riv_ups_comid))

# Copy schema and crs
meandrs_schema = riv_uncor.schema.copy()
meandrs_crs = riv_uncor.crs

# Write to file
with fiona.open(riv_out, 'w', schema=meandrs_schema,
                driver='ESRI Shapefile',
                crs=meandrs_crs) as output:
    for riv_fea in riv_uncor:
        if riv_fea['properties']['COMID'] in riv_ups_comid:
            output.write(riv_fea)


# ******************************************************************************
# Write corresponding catchments to file
# ******************************************************************************
print('- Writing traced catchments to shapefile')
# Copy schema and crs
cat_schema = cat.schema.copy()
cat_crs = cat.crs

# If crs is empty, set crs to WGS 84
if len(cat_crs) == 0:
    cat_crs = 'epsg:4326'

# Write to file
with fiona.open(cat_out, 'w', schema=cat_schema,
                driver='ESRI Shapefile',
                crs=cat_crs) as output:
    for cat_fea in cat:
        if cat_fea['properties']['COMID'] in riv_ups_comid:
            output.write(cat_fea)


