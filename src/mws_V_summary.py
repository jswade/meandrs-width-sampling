#!/usr/bin/env python3
# ******************************************************************************
# mws_V_summary.py
# ******************************************************************************

# Purpose:
# Given river volume output files from previous scripts, calculate global V
# summary terms for each sampling scenario.

# Author:
# Jeffrey Wade, Cedric H. David, 2024

# ******************************************************************************
# Import packages
# ******************************************************************************
import pandas as pd
import numpy as np
import glob
import sys
import os


# ******************************************************************************
# Declaration of variables (given as command line arguments)
# ******************************************************************************
# 1 - V_rivwid_low_csv
# 2 - V_rivwid_nrm_csv
# 3 - V_rivwid_hig_csv
# 4 - V_low_out
# 5 - V_nrm_out
# 6 - V_hig_out
# 7 - V_low_prop_out
# 8 - V_nrm_prop_out
# 9 - V_hig_prop_out
# 10 - V_low_range_out
# 11 - V_nrm_range_out
# 12 - V_hig_range_out
# 13 - V_low_range_prop_out
# 14 - V_nrm_range_prop_out
# 15 - V_hig_range_prop_out


# ******************************************************************************
# Get command line arguments
# ******************************************************************************
IS_arg = len(sys.argv)
if IS_arg != 16:
    print('ERROR - 15 arguments must be used')
    raise SystemExit(22)

V_rivwid_low_csv = sys.argv[1]
V_rivwid_nrm_csv = sys.argv[2]
V_rivwid_hig_csv = sys.argv[3]
V_low_out = sys.argv[4]
V_nrm_out = sys.argv[5]
V_hig_out = sys.argv[6]
V_low_prop_out = sys.argv[7]
V_nrm_prop_out = sys.argv[8]
V_hig_prop_out = sys.argv[9]
V_low_range_out = sys.argv[10]
V_nrm_range_out = sys.argv[11]
V_hig_range_out = sys.argv[12]
V_low_range_prop_out = sys.argv[13]
V_nrm_range_prop_out = sys.argv[14]
V_hig_range_prop_out = sys.argv[15]


# ******************************************************************************
# Check if files/folders exist
# ******************************************************************************
try:
    if os.path.isdir(V_rivwid_low_csv):
        pass
except IOError:
    print('ERROR - '+V_rivwid_low_csv+' invalid folder path')
    raise SystemExit(22)

try:
    if os.path.isdir(V_rivwid_nrm_csv):
        pass
except IOError:
    print('ERROR - '+V_rivwid_nrm_csv+' invalid folder path')
    raise SystemExit(22)

try:
    if os.path.isdir(V_rivwid_hig_csv):
        pass
except IOError:
    print('ERROR - '+V_rivwid_hig_csv+' invalid folder path')
    raise SystemExit(22)


# ******************************************************************************
# Read files
# ******************************************************************************
print('- Reading files')
# ------------------------------------------------------------------------------
# Total V: Rivwidth
# ------------------------------------------------------------------------------
V_rivwid_low_files = list(glob.iglob(V_rivwid_low_csv+'*'))
V_rivwid_low_files.sort()
V_rivwid_low = [pd.read_csv(j) for j in V_rivwid_low_files]

V_rivwid_nrm_files = list(glob.iglob(V_rivwid_nrm_csv+'*'))
V_rivwid_nrm_files.sort()
V_rivwid_nrm = [pd.read_csv(j) for j in V_rivwid_nrm_files]

V_rivwid_hig_files = list(glob.iglob(V_rivwid_hig_csv+'*'))
V_rivwid_hig_files.sort()
V_rivwid_hig = [pd.read_csv(j) for j in V_rivwid_hig_files]

# Retrieve numbers of pfafs
pfaf_list = pd.Series([x.partition("pfaf_")[-1][0:2] for x in
                       V_rivwid_low_files]).sort_values(ignore_index=True)

# ******************************************************************************
# Generate V summary files
# ******************************************************************************
print('- Computing global V summary')
# ------------------------------------------------------------------------------
# V Global Summary
# ------------------------------------------------------------------------------
# Set max river width scenario
n_s = 500

# Set river width step size
step = 5

# Set river width scenario values
wid_scen = list(range(n_s, -1, -step))


def Vsum(V_in, V_out, V_prop_out, V_range_out, V_range_prop_out):    

    # Create dataframe to store V values for each region
    V_df = pd.DataFrame(index=["wid_" + str(x) for x in
                               (wid_scen)], columns=range(len(V_in)))

    # Give column names
    pfaf_str = ('pfaf_' + pfaf_list).tolist()
    V_df.columns = pfaf_str

    # Calculate mean of each scenario across times steps and store in V_df
    for i in range(len(V_in)):
        temp_df = V_in[i].select_dtypes(include=['float64'])
        V_df.iloc[:, i] = np.mean(temp_df, axis=0)

    # Write file to csv
    V_df.to_csv(V_out)

    # --------------------------------------------------------------------------
    # Calculate proportion of V to ocean captured by each scenario
    # --------------------------------------------------------------------------
    V_sum_global = np.sum(V_df, axis=1)
    V_prop = 100 * V_sum_global/V_sum_global.iloc[len(wid_scen)-1]

    # Write to file
    V_prop.to_csv(V_prop_out)

    # --------------------------------------------------------------------------
    # Calculate total global V at each time step for each scenario
    # --------------------------------------------------------------------------
    # Initialize dataframe to store global V values
    V_global = pd.DataFrame(np.zeros(V_in[0].shape))

    # Set column names
    V_global.columns = V_in[0].columns

    # Set time column
    V_global.time = V_in[0].time

    # Loop through pfaf regions
    for j in range(len(V_in)):

        # Sum V at each time step for each river width scenario
        V_global.iloc[:, 1:] = V_global.iloc[:, 1:] +                          \
            V_in[j].iloc[:, 1:]

    # --------------------------------------------------------------------------
    # Calculate standard deviation of each river width scenario
    # --------------------------------------------------------------------------
    # Summarize V range for river width scenarios
    V_range = []
    chunk = 12
    for i in range(1, V_global.shape[1]):
        V_slice = V_global.iloc[:, i].values.reshape(-1, chunk)
        V_range.append(np.mean(V_slice.max(axis=1) - V_slice.min(axis=1)))

    # Calculate proportion of V range of each scenario compared to global range
    V_range_prop = 100 * pd.Series(V_range/V_range[-1])
    V_range = pd.Series(V_range)

    # --------------------------------------------------------------------------
    # Write files
    # --------------------------------------------------------------------------
    V_range.to_csv(V_range_out)
    V_range_prop.to_csv(V_range_prop_out)


# ------------------------------------------------------------------------------
# Run volume summary functions
# ------------------------------------------------------------------------------
# V_low
Vsum(V_rivwid_low, V_low_out, V_low_prop_out, V_low_range_out,
     V_low_range_prop_out)

# V_nrm
Vsum(V_rivwid_nrm, V_nrm_out, V_nrm_prop_out, V_nrm_range_out,
     V_nrm_range_prop_out)

# V_hig
Vsum(V_rivwid_hig, V_hig_out, V_hig_prop_out, V_hig_range_out,
     V_hig_range_prop_out)
