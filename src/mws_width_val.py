#!/usr/bin/env python3
# ******************************************************************************
# mws_width_val.py
# ******************************************************************************

# Purpose:
# Given uncorrected MeanDRS rivers, SWORD reaches, and MERIT-SWORD translations,
# compare MeanDRS estimated river widths to SWORD GRWL widths

# Author:
# Jeffrey Wade, Cedric H. David, 2025

# ******************************************************************************
# Import packages
# ******************************************************************************
import sys
import os
import pandas as pd
import numpy as np
import fiona
import xarray as xr


# ******************************************************************************
# Declaration of variables (given as command line arguments)
# ******************************************************************************
# 1 - ms_nc
# 2 - riv_uncor_shp
# 3 - sword_shp
# 4 - val_out


# ******************************************************************************
# Get command line arguments
# ******************************************************************************
IS_arg = len(sys.argv)
if IS_arg != 5:
    print('ERROR - 4 arguments must be used')
    raise SystemExit(22)

ms_nc = sys.argv[1]
riv_uncor_shp = sys.argv[2]
sword_shp = sys.argv[3]
val_out = sys.argv[4]


# ******************************************************************************
# Check if files/folders exist
# ******************************************************************************
try:
    if os.path.isdir(ms_nc):
        pass
except IOError:
    print('ERROR - '+ms_nc+' invalid folder path')
    raise SystemExit(22)

try:
    with open(riv_uncor_shp) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+riv_uncor_shp)
    raise SystemExit(22)

try:
    with open(sword_shp) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+sword_shp)
    raise SystemExit(22)


# ******************************************************************************
# Define function for adding key: value to dictionary
# ******************************************************************************
# Add key to dictionary if it is not yet present
# If key already exists, add value to existing value at that key
def add_to_dict(dictionary, key, value):
    # Add to the existing value
    if key in dictionary:
        dictionary[key] += value
    # Initialize the key with the value
    else:
        dictionary[key] = value


# ******************************************************************************
# Read files
# ******************************************************************************
print('Reading files')
# ------------------------------------------------------------------------------
# MeanDRS Uncorrected Rivers
# ------------------------------------------------------------------------------
# Read shapefile
riv_uncor = fiona.open(riv_uncor_shp, 'r')

# ------------------------------------------------------------------------------
# SWORD
# ------------------------------------------------------------------------------
# Read sword shapefile
riv_sword = fiona.open(sword_shp, 'r')

# ------------------------------------------------------------------------------
# MERIT-SWORD
# ------------------------------------------------------------------------------
# Read translations
ms_df = xr.open_dataset(ms_nc).to_dataframe()


# ******************************************************************************
# Retrieve river widths from SWORD and estimate river widths from GRWL
# ******************************************************************************
print('Retrieving GRWL river widths from SWORD')
# ------------------------------------------------------------------------------
# Calculate river width from mean discharge in each region
# ------------------------------------------------------------------------------
# Initialize dictionary to store widths
m_wid = {}

# Loop through river reaches
for riv_fea in riv_uncor:

    # Estimate mean river width by Moody & Troutman, 2002
    m_wid[riv_fea['properties']['COMID']] = \
        np.round(7.2*(riv_fea['properties']['meanQ']**0.5), 5)

# ------------------------------------------------------------------------------
# Retrieve river width from SWORD
# ------------------------------------------------------------------------------
# Initialize dictionaries to store widths
sw_wid = {}

# Loop through river reaches
for riv_fea in riv_sword:

    # Retrieve GRWL width from SWORD
    sw_wid[riv_fea['properties']['reach_id']] = \
        riv_fea['properties']['width']

# Retrieve unique SWORD reaches
sw_rch = sw_wid.keys()


# ******************************************************************************
# Pair MeanDRS and GRWL widths using MERIT-SWORD
# ******************************************************************************
print('Compare GRWL and MeanDRS widths')
# Initialize dataframe to store width comparisons
wid_df = pd.DataFrame(0., index=sw_rch, columns=["sw_wid", "m_wid"])

# Loop through SWORD reaches
for rch in sw_wid.keys():

    # Retrieve most overlapping MERIT reaches for each SWORD reach
    ms_trans = ms_df.loc[rch]

    # Retrieve sum of overlapping lengths
    overlap_sum = np.sum(ms_trans.iloc[40:])

    # If overlap_sum equals 0, skip to next reach
    if overlap_sum == 0:
        continue

    # If reach has no valid translation, skip to next reach
    if ms_trans.mb_1 == 0:
        continue

    # Initialize value to store weighted MeanDRS widths
    m_wid_weight = 0

    # Loop through valid translations and their corresponding partial lens
    for j in range(0, len(ms_trans)):

        # Retrieve translation
        trans_j = ms_trans.iloc[j]

        # If no valid translation, exit loop
        if trans_j <= 0:
            break

        # If reaches are from different regions, skip comparison
        if int(str(int(trans_j))[:2]) != int(str(rch)[:2]):
            break

        # Retrieve weighting frac of SWORD reach corresponding to MB reach
        weight = ms_trans.iloc[j + 40] / overlap_sum

        # Add weighted MeanDRS width
        m_wid_weight += weight * m_wid[trans_j]

    # Add weighted MeanDRS width and GRWL width to dataframe
    wid_df.loc[rch, 'sw_wid'] = sw_wid[rch]
    wid_df.loc[rch, 'm_wid'] = m_wid_weight

# Remove rows without valid translations
wid_df = wid_df.loc[~((wid_df["sw_wid"] == 0) & (wid_df["m_wid"] == 0))]

# Filter wid_df to type 1 reaches
sw_type = wid_df.index.values % 10
wid_df_t1 = wid_df.iloc[sw_type == 1, :]


# ******************************************************************************
# Write to file
# ******************************************************************************
print('Writing to file')
# Write to CSV
wid_df_t1.to_csv(val_out, index=False)
