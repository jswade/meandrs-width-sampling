#!/usr/bin/env python3
# ******************************************************************************
# mws_Q_summary.py
# ******************************************************************************

# Purpose:
# Given coastal river discharge output files from previous scripts, calculate
# global discharge to the ocean summary terms for each sampling scenario.

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
# 1 - Qout_rivwid_csv
# 2 - Qout_out
# 3 - Qout_prop_out
# 4 - Qout_std_out
# 5 - Qout_std_prop_out


# ******************************************************************************
# Get command line arguments
# ******************************************************************************
IS_arg = len(sys.argv)
if IS_arg != 6:
    print('ERROR - 5 arguments must be used')
    raise SystemExit(22)

Qout_rivwid_csv = sys.argv[1]
Qout_out = sys.argv[2]
Qout_prop_out = sys.argv[3]
Qout_std_out = sys.argv[4]
Qout_std_prop_out = sys.argv[5]


# ******************************************************************************
# Check if files/folders exist
# ******************************************************************************
try:
    if os.path.isdir(Qout_rivwid_csv):
        pass
except IOError:
    print('ERROR - '+Qout_rivwid_csv+' invalid folder path')
    raise SystemExit(22)


# ******************************************************************************
# Read files
# ******************************************************************************
print('- Reading files')
# ------------------------------------------------------------------------------
# Qout to ocean: Rivwidth
# ------------------------------------------------------------------------------
Qout_rivwid_files = list(glob.iglob(Qout_rivwid_csv+'*'))
Qout_rivwid_files.sort()
Qout_rivwid = [pd.read_csv(j) for j in Qout_rivwid_files]

# Retrieve numbers of pfafs
pfaf_list = pd.Series([x.partition("pfaf_")[-1][0:2] for x in
                       Qout_rivwid_files]).sort_values(ignore_index=True)


# ******************************************************************************
# Generate Qout summary files
# ******************************************************************************
print('- Computing global Q summary')
# ------------------------------------------------------------------------------
# Qout Global Summary
# ------------------------------------------------------------------------------
# Set max river width scenario
n_s = 500

# Set river width step size
step = 5

# Set river width scenario values
wid_scen = list(range(n_s, -1, -step))

# Create dataframe to store meanQ values for each region
Q_df = pd.DataFrame(index=["wid_" + str(x) for x in
                           (wid_scen)], columns=range(len(pfaf_list)))

# Give column names
pfaf_str = ('pfaf_' + pfaf_list).tolist()
Q_df.columns = pfaf_str

# Calculate mean of each scenario across times steps and store in Q_df
for i in range(len(pfaf_list)):
    temp_df = Qout_rivwid[i].select_dtypes(include=['float64'])
    Q_df.iloc[:, i] = np.mean(temp_df, axis=0)

# Write file to csv
Q_df.to_csv(Qout_out)

# ------------------------------------------------------------------------------
# Calculate proportion of Q to ocean captured by each scenario
# ------------------------------------------------------------------------------
Q_sum_global = np.sum(Q_df, axis=1)
Q_prop = 100 * Q_sum_global / Q_sum_global.iloc[len(wid_scen) - 1]

# Write file to csv
Q_prop.to_csv(Qout_prop_out)

# ------------------------------------------------------------------------------
# Calculate total global Q to ocean at each time step for each scenario
# ------------------------------------------------------------------------------

# Initialize dataframe to store global Q values
Q_global = pd.DataFrame(np.zeros(Qout_rivwid[0].shape))

# Set column names
Q_global.columns = Qout_rivwid[0].columns

# Set time column
Q_global.time = Qout_rivwid[0].time

# Loop through pfaf regions
for j in range(len(Qout_rivwid)):

    # Sum Q to ocean at each time step for each river width scenario
    Q_global.iloc[:, 1:] = Q_global.iloc[:, 1:] + Qout_rivwid[j].iloc[:, 1:]

# Summarize Q STD for river width scenarios
Q_std = np.std(Q_global.iloc[:, 1:], axis=0)

# Calculate proportion of Q std deviation captured by each scenario
Q_std_prop = 100 * Q_std/Q_std.iloc[len(Q_std)-1]

# Write files to csv
Q_std.to_csv(Qout_std_out)
Q_std_prop.to_csv(Qout_std_prop_out)
