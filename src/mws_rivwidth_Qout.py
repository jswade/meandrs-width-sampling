#!/usr/bin/env python3
# ******************************************************************************
# mws_rivwidth_Qout.py
# ******************************************************************************

# Purpose:
# Given a shapefile of uncorrected MeanDRS river reaches and a NetCDF of
# corrected MeanDRS discharge, calculate discharge to the ocean for estimated
# river width scenarios.

# Author:
# Jeffrey Wade, Cedric H. David, 2024


# ******************************************************************************
# Import Python modules
# ******************************************************************************
import pandas as pd
import numpy as np
import fiona
import datetime
import netCDF4 as nc
import sys


# ******************************************************************************
# Declaration of variables (given as command line arguments)
# ******************************************************************************
# 1 - riv_cst_uncor_shp
# 2 - Qout_cor_nc
# 3 - Qout_cst_out


# ******************************************************************************
# Get command line arguments
# ******************************************************************************
IS_arg = len(sys.argv)
if IS_arg != 4:
    print('ERROR - 3 arguments must be used')
    raise SystemExit(22)

riv_cst_uncor_shp = sys.argv[1]
Qout_cor_nc = sys.argv[2]
Qout_cst_out = sys.argv[3]


# ******************************************************************************
# Check if files exist
# ******************************************************************************
try:
    with open(riv_cst_uncor_shp) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+riv_cst_uncor_shp)
    raise SystemExit(22)

try:
    with open(Qout_cor_nc) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_cor_nc)
    raise SystemExit(22)

# Confirm files refer to same region
riv_cst_uncor_reg = riv_cst_uncor_shp.split('pfaf_')[1][0:2]
Qout_cor_nc_reg = Qout_cor_nc.split('pfaf_')[1][0:2]
Qout_cst_out_reg = Qout_cst_out.split('pfaf_')[1][0:2]

if not (riv_cst_uncor_reg == Qout_cor_nc_reg == Qout_cst_out_reg):
    print('ERROR - Input files correspond to different regions')
    raise SystemExit(22)


# ******************************************************************************
# Read shapefiles
# ******************************************************************************
print('- Reading shapefiles')
# ------------------------------------------------------------------------------
# MeanDRS Coastal Rivers: Uncorrected
# ------------------------------------------------------------------------------
# Read shapefile
riv_uncor = fiona.open(riv_cst_uncor_shp, 'r', crs="EPSG:4326")

# ------------------------------------------------------------------------------
# MeanDRS Corrected Discharge
# ------------------------------------------------------------------------------
Qout_cor = nc.Dataset(Qout_cor_nc, 'r')


# ******************************************************************************
# Sample MeanDRS dataset by river widths to calculate Q to ocean
# ******************************************************************************
print('- Sample MeanDRS rivers by estimated river width')
# ------------------------------------------------------------------------------
# Sample MeanDRS rivers by estimated river width
# ------------------------------------------------------------------------------
# Set max river width scenario
n_s = 500

# Set river width step size
step = 5

# Set river width scenario values
wid_scen = list(range(n_s, -1, -step))

# Initialize dataframes to store ID, meanQ, and river width
meandrs_df = pd.DataFrame(index=np.arange(len(riv_uncor)),
                          columns=['COMID', 'meanQ', 'width'])

# Initialize columns for Q dataframe
wid_col = ["wid_" + str(x) for x in (wid_scen)]

Q_df = pd.DataFrame(np.zeros((360, len(wid_col))))
Q_df.columns = wid_col

# ------------------------------------------------------------------------------
# Store values from MeanDRS and calculate river width with uncor Q
# ------------------------------------------------------------------------------
for i in range(len(riv_uncor)):

    # Retrieve uncorrected river feature
    riv_fea = riv_uncor[i]

    # Store values
    meandrs_df['COMID'].iloc[i] = riv_fea['properties']['COMID']
    meandrs_df['meanQ'].iloc[i] = riv_fea['properties']['meanQ']

    # Calculate river width by Moody and Troutman, 2002 using uncor data
    meandrs_df['width'].iloc[i] = 7.2*(riv_fea['properties']['meanQ']**0.5)

# ------------------------------------------------------------------------------
# Retrieve values from netCDF file
# ------------------------------------------------------------------------------
# Retrieve Q, ID, and time variables from netcdf
Qout_nc = Qout_cor.variables['Qout'][:]
rivid_nc = Qout_cor.variables['rivid'][:]
time_nc = Qout_cor.variables['time'][:]

# ------------------------------------------------------------------------------
# Select rivers filtered by river width scenario and extract cor Q values
# ------------------------------------------------------------------------------
print('- Calculate discharge to ocean from width samples')
for i in range(len(wid_scen)):

    # For first iteration, retrieve values larger than first width
    if i == 0:

        # Filter rivers by width scenarios
        riv_id = meandrs_df['COMID'][meandrs_df['width'] > wid_scen[i]]

    # For all other iterations, retrieve reaches added by that scenario
    else:

        # Filter rivers by width scenarios of additional reaches
        riv_id = meandrs_df['COMID'][
                 (meandrs_df['width'] >= wid_scen[i]).values &
                 (meandrs_df['width'] < wid_scen[i-1]).values]

    # Filter corrected Q netcdf by selected reach ids that drain to coast
    Qout_rch = Qout_nc[:, np.isin(rivid_nc, riv_id)]

    # Calculate sum of all reaches at each time step, convert to km3/yr
    Qout_cst = np.sum(Qout_rch, axis=1) * 0.031536

    # Store in dataframe, equal to current scenario Q plus previous scenario
    Q_df.iloc[:, i] = Qout_cst + Q_df.iloc[:, i-1].values


# ******************************************************************************
# Write model Q values to csv for each pfaf
# ******************************************************************************
print('- Write Qout to CSV')
# Set index and column names (times are in arbitrary PST to match Zenodo)
time_nc_series = pd.Series(time_nc).apply(lambda x:
                                          datetime.datetime.utcfromtimestamp(x))
time_nc_series = time_nc_series.dt.tz_localize('UTC').\
    dt.tz_convert('America/Los_Angeles')
Q_df.index = time_nc_series.dt.tz_localize(None)
Q_df.index.name = 'time'

# Write to csv
Q_df.to_csv(Qout_cst_out)
