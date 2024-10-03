#!/usr/bin/env python3
# ******************************************************************************
# mws_rivwidth_V.py
# ******************************************************************************

# Purpose:
# Given a netcdf of uncorrected MeanDRS discharge and NetCDFs of
# corrected MeanDRS volume, calculate total river storage for estimated
# river width scenarios.

# Author:
# Jeffrey Wade, Cedric H. David, 2024


# ******************************************************************************
# Import Python modules
# ******************************************************************************
import pandas as pd
import numpy as np
import datetime
import netCDF4 as nc
import sys


# ******************************************************************************
# Declaration of variables (given as command line arguments)
# ******************************************************************************
# 1 - Qout_uncor_nc
# 2 - V_low_cor_nc
# 3 - V_nrm_cor_nc
# 4 - V_hig_cor_nc
# 5 - V_low_out
# 6 - V_nrm_out
# 7 - V_hig_out


# ******************************************************************************
# Get command line arguments
# ******************************************************************************
IS_arg = len(sys.argv)
if IS_arg != 8:
    print('ERROR - 7 arguments must be used')
    raise SystemExit(22)

Qout_uncor_nc = sys.argv[1]
V_low_cor_nc = sys.argv[2]
V_nrm_cor_nc = sys.argv[3]
V_hig_cor_nc = sys.argv[4]
V_low_out = sys.argv[5]
V_nrm_out = sys.argv[6]
V_hig_out = sys.argv[7]


# ******************************************************************************
# Check if files exist
# ******************************************************************************
try:
    with open(Qout_uncor_nc) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_uncor_nc)
    raise SystemExit(22)

try:
    with open(V_low_cor_nc) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_low_cor_nc)
    raise SystemExit(22)

try:
    with open(V_nrm_cor_nc) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_nrm_cor_nc)
    raise SystemExit(22)

try:
    with open(V_hig_cor_nc) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_hig_cor_nc)
    raise SystemExit(22)

# Confirm files refer to same region
Qout_uncor_reg = Qout_uncor_nc.split('pfaf_')[1][0:2]
V_low_cor_nc_reg = V_low_cor_nc.split('pfaf_')[1][0:2]
V_nrm_cor_nc_reg = V_nrm_cor_nc.split('pfaf_')[1][0:2]
V_hig_cor_nc_reg = V_hig_cor_nc.split('pfaf_')[1][0:2]
V_low_out_reg = V_low_out.split('pfaf_')[1][0:2]
V_nrm_out_reg = V_nrm_out.split('pfaf_')[1][0:2]
V_hig_out_reg = V_hig_out.split('pfaf_')[1][0:2]

if not (Qout_uncor_reg == V_low_cor_nc_reg == V_nrm_cor_nc_reg ==
        V_hig_cor_nc_reg == V_low_out_reg == V_nrm_out_reg == V_hig_out_reg):
    print('ERROR - Input files correspond to different regions')
    raise SystemExit(22)


# ******************************************************************************
# Read shapefiles
# ******************************************************************************
print('- Reading shapefiles')
# ------------------------------------------------------------------------------
# MeanDRS Qout: Uncorrected
# ------------------------------------------------------------------------------
# Read NC
Qout_uncor = nc.Dataset(Qout_uncor_nc, 'r')


# ******************************************************************************
# Store values from MeanDRS and calculate river width with uncor Q
# ******************************************************************************
# Retrieve variables from Qout_uncor
Qout_rivid = Qout_uncor.variables['rivid'][:]
Qout = Qout_uncor.variables['Qout'][:]

# Calculate mean discharge at each reach
Qout_mean = np.mean(Qout, axis=0).compressed()

# Initialize dataframes to store ID, meanQ, and river width
meandrs_df = pd.DataFrame(index=np.arange(len(Qout_mean)),
                          columns=['COMID', 'meanQ', 'width'])
meandrs_df['COMID'] = Qout_rivid
meandrs_df['meanQ'] = Qout_mean

# Calculate river width by Moody and Troutman, 2002 using uncor data
meandrs_df['width'] = 7.2 * (meandrs_df['meanQ'] ** 0.5)


# ******************************************************************************
# Define function to calculate volume for river width scenarios
# ******************************************************************************
def calcV(fp_in, fp_out):

    # --------------------------------------------------------------------------
    # Sample rivers by estimate width
    # --------------------------------------------------------------------------
    # Set max river width scenario
    n_s = 500

    # Set river width step size
    step = 5

    # Set river width scenario values
    wid_scen = list(range(n_s, -1, -step))

    # Initialize columns for V dataframe
    wid_col = ["wid_" + str(x) for x in (wid_scen)]

    # Create dataframe to store V values for each region
    V_df = pd.DataFrame(np.zeros((360, len(wid_col))))
    V_df.columns = wid_col

    # --------------------------------------------------------------------------
    # Load volume netCDF files
    # --------------------------------------------------------------------------
    # Open V netcdf corresponding to residence time scenario
    V_cor_in = nc.Dataset(fp_in, 'r')

    # Retrieve V, ID, and time variables from netcdfs
    V_cor_nc = V_cor_in.variables['V'][:]
    rivid_nc = V_cor_in.variables['rivid'][:]
    time_nc = V_cor_in.variables['time'][:]

    # --------------------------------------------------------------------------
    # Select rivers filtered by river width scenario and extract V values
    # --------------------------------------------------------------------------
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

        # Filter V netcdf by selected reach ids
        V_rch = V_cor_nc[:, np.isin(rivid_nc, riv_id)]

        # Calculate sum of all reaches at each time step, convert to km3/yr
        V_tot = np.sum(V_rch, axis=1) * 1e-9

        # New column equal to current scenario V plus previous scenario
        V_df.iloc[:, i] = V_tot + V_df.iloc[:, i-1].values

    # --------------------------------------------------------------------------
    # Write model V values to csv for each pfaf
    # --------------------------------------------------------------------------
    # Set index and column names
    time_nc_ser = pd.Series(time_nc)
    V_df.index = time_nc_ser.apply(lambda x: datetime.datetime.fromtimestamp(x))
    V_df.index.name = 'time'

    # Write to csv
    V_df.to_csv(fp_out)


# ******************************************************************************
# Run function
# ******************************************************************************
print('- Calculating river volume: Low')
calcV(V_low_cor_nc, V_low_out)
print('- Calculating river volume: Nrm')
calcV(V_nrm_cor_nc, V_nrm_out)
print('- Calculating river volume: Hig')
calcV(V_hig_cor_nc, V_hig_out)
