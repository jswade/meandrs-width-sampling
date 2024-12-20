#!/usr/bin/env python3
# ******************************************************************************
# mws_plots.py
# ******************************************************************************

# Purpose:
# Given all output files from previous scripts, generate visualizations.

# Author:
# Jeffrey Wade, Cedric H. David, 2024


# ******************************************************************************
# Import packages
# ******************************************************************************
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import glob
import fiona
from datetime import datetime
import sys
import os


# ******************************************************************************
# Declaration of variables (given as command line arguments)
# ******************************************************************************
# 1 - riv_uncor_shp
# 2 - Qout_prop_csv
# 3 - Qout_range_prop_csv
# 4 - Qout_rivwid_csv
# 5 - V_prop_low_csv
# 6 - V_prop_nrm_csv
# 7 - V_prop_hig_csv
# 8 - V_prop_low_range_csv
# 9 - V_prop_nrm_range_csv
# 10 - V_prop_hig_range_csv
# 11 - V_rivwid_low_csv
# 12 - V_rivwid_nrm_csv
# 13 - V_rivwid_hig_csv
# 14 - Qout_small_csv
# 15 - Qout_large_csv
# 16 - fig1_out
# 17 - fig2a_out
# 18 - fig2b_out
# 19 - fig3_out
# 20 - fig4_out


# ******************************************************************************
# Get command line arguments
# ******************************************************************************
IS_arg = len(sys.argv)
if IS_arg != 21:
    print('ERROR - 20 arguments must be used')
    raise SystemExit(22)

riv_uncor_shp = sys.argv[1]
Qout_prop_csv = sys.argv[2]
Qout_range_prop_csv = sys.argv[3]
Qout_rivwid_csv = sys.argv[4]
V_prop_low_csv = sys.argv[5]
V_prop_nrm_csv = sys.argv[6]
V_prop_hig_csv = sys.argv[7]
V_prop_low_range_csv = sys.argv[8]
V_prop_nrm_range_csv = sys.argv[9]
V_prop_hig_range_csv = sys.argv[10]
V_rivwid_low_csv = sys.argv[11]
V_rivwid_nrm_csv = sys.argv[12]
V_rivwid_hig_csv = sys.argv[13]
Qout_small_csv = sys.argv[14]
Qout_large_csv = sys.argv[15]
fig1_out = sys.argv[16]
fig2a_out = sys.argv[17]
fig2b_out = sys.argv[18]
fig3_out = sys.argv[19]
fig4_out = sys.argv[20]


# ******************************************************************************
# Check if files/folders exist
# ******************************************************************************
try:
    if os.path.isdir(riv_uncor_shp):
        pass
except IOError:
    print('ERROR - '+riv_uncor_shp+' invalid folder path')
    raise SystemExit(22)

try:
    with open(Qout_prop_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_prop_csv)
    raise SystemExit(22)

try:
    with open(Qout_range_prop_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_range_prop_csv)
    raise SystemExit(22)

try:
    if os.path.isdir(Qout_rivwid_csv):
        pass
except IOError:
    print('ERROR - '+Qout_rivwid_csv+' invalid folder path')
    raise SystemExit(22)

try:
    with open(V_prop_low_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_prop_low_csv)
    raise SystemExit(22)

try:
    with open(V_prop_nrm_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_prop_nrm_csv)
    raise SystemExit(22)

try:
    with open(V_prop_hig_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_prop_hig_csv)
    raise SystemExit(22)

try:
    with open(V_prop_low_range_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_prop_low_range_csv)
    raise SystemExit(22)

try:
    with open(V_prop_nrm_range_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_prop_nrm_range_csv)
    raise SystemExit(22)

try:
    with open(V_prop_hig_range_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_prop_hig_range_csv)
    raise SystemExit(22)

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

try:
    with open(Qout_small_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_small_csv)
    raise SystemExit(22)

try:
    with open(Qout_large_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_large_csv)
    raise SystemExit(22)


# ******************************************************************************
# Read files
# ******************************************************************************
print('- Reading files')
# ------------------------------------------------------------------------------
# MeanDRS Uncorrected Rivers
# ------------------------------------------------------------------------------
# Read to shapefile
riv_uncor_files = list(glob.iglob(riv_uncor_shp+'*.shp'))
riv_uncor_files.sort()
riv_uncor = [fiona.open(j, 'r') for j in riv_uncor_files]

# ------------------------------------------------------------------------------
# Qout_rivwidth Files
# ------------------------------------------------------------------------------
# Read files
Qout_prop = pd.read_csv(Qout_prop_csv)
Qout_range_prop = pd.read_csv(Qout_range_prop_csv)

Qout_rivwid_files = list(glob.iglob(Qout_rivwid_csv+'*'))
Qout_rivwid_files.sort()
Qout_rivwid = [pd.read_csv(j) for j in Qout_rivwid_files]

# ------------------------------------------------------------------------------
# V_rivwidth Files
# ------------------------------------------------------------------------------
# Read files
V_prop_low = pd.read_csv(V_prop_low_csv)
V_prop_nrm = pd.read_csv(V_prop_nrm_csv)
V_prop_hig = pd.read_csv(V_prop_hig_csv)

V_prop_low_range = pd.read_csv(V_prop_low_range_csv)
V_prop_nrm_range = pd.read_csv(V_prop_nrm_range_csv)
V_prop_hig_range = pd.read_csv(V_prop_hig_range_csv)

V_rivwid_low_files = list(glob.iglob(V_rivwid_low_csv+'*'))
V_rivwid_low_files.sort()
V_rivwid_low = [pd.read_csv(j) for j in V_rivwid_low_files]

V_rivwid_nrm_files = list(glob.iglob(V_rivwid_nrm_csv+'*'))
V_rivwid_nrm_files.sort()
V_rivwid_nrm = [pd.read_csv(j) for j in V_rivwid_nrm_files]

V_rivwid_hig_files = list(glob.iglob(V_rivwid_hig_csv+'*'))
V_rivwid_hig_files.sort()
V_rivwid_hig = [pd.read_csv(j) for j in V_rivwid_hig_files]

# ------------------------------------------------------------------------------
# Narrow Coastal Rivers Files
# ------------------------------------------------------------------------------
Qout_small = pd.read_csv(Qout_small_csv)

# ------------------------------------------------------------------------------
# Largest Coastal Rivers Files
# ------------------------------------------------------------------------------
Qout_large = pd.read_csv(Qout_large_csv)


# ******************************************************************************
# Figure 1
# ******************************************************************************
print('- Generating Figure 1')
# ------------------------------------------------------------------------------
# Retrieve discharge values for all rivers in each region
# ------------------------------------------------------------------------------
# Initialize list to store discharge
Q_list = []

# Loop through regions
for j in range(len(riv_uncor)):

    # Retrieve MeanDRS reaches for each pfaf
    riv_lay = riv_uncor[j]

    # Loop through river reaches
    for riv_fea in riv_lay:

        # Store values
        Q_list.append(riv_fea['properties']['meanQ'])

# ------------------------------------------------------------------------------
# Calculate river width from mean discharge
# ------------------------------------------------------------------------------
# Convert list to array
Q_arr = np.array(Q_list)

# Estimate mean river width by Moody & Troutman, 2002
wid_arr = 7.2*(Q_arr**0.5)

# Calculate discharge equivalent of major width thresholds
wid_thr = np.array([10, 25, 50, 100, 250, 500, 1000])
Q_thr = ((wid_thr/7.2)**2).tolist()

# Set cutoffs for histogram
wid_cut = [3.16, 10, 31.6, 100, 316, 1000]

# ------------------------------------------------------------------------------
# Plot river discharge histogram
# ------------------------------------------------------------------------------
bottom = 10
fig = plt.figure(figsize=(4.5, 5))
plt.hist(wid_arr, bins=np.logspace(np.log10(1), np.log10(5000), 50),
         color='gray', bottom=bottom)
[plt.axvline(ln, linewidth=1, color='red') for ln in wid_cut]
plt.yscale("log")
plt.xscale("log")
plt.xlabel('River Width')
plt.ylabel('Number of Rivers')
plt.xlim(1, 5000)
plt.ylim(10, 500000)
plt.savefig(fig1_out, format='svg')


# ******************************************************************************
# Figure 2
# ******************************************************************************
print('- Generating Figure 2')
# ------------------------------------------------------------------------------
# Process river width files for 0m,50m, and 100m scenarios
# ------------------------------------------------------------------------------
# Initialize dataframe for storing Qout and V values for each width scenario
width0_df = pd.DataFrame(0, index=range(Qout_rivwid[0].shape[0]),
                         columns=['Qout', 'V_low', 'V_nrm', 'V_hig'])

width50_df = pd.DataFrame(0, index=range(Qout_rivwid[0].shape[0]),
                          columns=['Qout', 'V_low', 'V_nrm', 'V_hig'])

width100_df = pd.DataFrame(0, index=range(Qout_rivwid[0].shape[0]),
                           columns=['Qout', 'V_low', 'V_nrm', 'V_hig'])

# Loop through region-specific files
for i in range(len(Qout_rivwid)):

    # Add Qout values from pfaf to summary df
    width0_df.Qout = width0_df.Qout + Qout_rivwid[i].wid_0
    width50_df.Qout = width50_df.Qout + Qout_rivwid[i].wid_50
    width100_df.Qout = width100_df.Qout + Qout_rivwid[i].wid_100

    # Add V values from pfaf to summary df
    width0_df.V_low = width0_df.V_low + V_rivwid_low[i].wid_0
    width0_df.V_nrm = width0_df.V_nrm + V_rivwid_nrm[i].wid_0
    width0_df.V_hig = width0_df.V_hig + V_rivwid_hig[i].wid_0

    width50_df.V_low = width50_df.V_low + V_rivwid_low[i].wid_50
    width50_df.V_nrm = width50_df.V_nrm + V_rivwid_nrm[i].wid_50
    width50_df.V_hig = width50_df.V_hig + V_rivwid_hig[i].wid_50

    width100_df.V_low = width100_df.V_low + V_rivwid_low[i].wid_100
    width100_df.V_nrm = width100_df.V_nrm + V_rivwid_nrm[i].wid_100
    width100_df.V_hig = width100_df.V_hig + V_rivwid_hig[i].wid_100

# Convert index to datetime format
time_ind = [datetime.strptime(j, '%Y-%m-%d %H:%M:%S') for j in
            Qout_rivwid[0].time]

# Set index to timesteps
width0_df.index = time_ind
width50_df.index = time_ind
width100_df.index = time_ind

# ------------------------------------------------------------------------------
# Plot global monthly discharge to ocean (Figure 2a)
# ------------------------------------------------------------------------------
fig = plt.figure(figsize=(9.4, 6))
ax = plt.gca()
plt.axhline(y=np.mean(width0_df.Qout), c='#00221e', linestyle='dotted',
            alpha=0.5, lw=2)
plt.axhline(y=np.mean(width50_df.Qout), c='#4c8376', linestyle='dotted',
            alpha=0.5, lw=2)
plt.axhline(y=np.mean(width100_df.Qout), c='#96e0cc', linestyle='dotted',
            alpha=0.5, lw=2)
plt.plot(width0_df.Qout, lw=1.5, c='#00221e', alpha=0.9, label="All Reaches")
plt.plot(width50_df.Qout, lw=1.5, c='#4c8376', alpha=0.9, label="Width>50m")
plt.plot(width100_df.Qout, lw=1.5, c='#96e0cc', alpha=0.9, label="Width>100m")
ax.xaxis.set_major_locator(mdates.YearLocator(5))
ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y'))
plt.gcf().autofmt_xdate()
plt.gcf().autofmt_xdate(rotation=00)
plt.ylim(15000, 60000)
plt.xticks(rotation=0, ha='center')
plt.xlabel('Time')
plt.ylabel('Discharge to Ocean (km3/year)')
plt.savefig(fig2a_out, format='svg')

# ------------------------------------------------------------------------------
# Plot global monthly river storage (Figure 2b)
# ------------------------------------------------------------------------------
fig = plt.figure(figsize=(9.4, 6))
ax = plt.gca()
plt.axhline(y=np.mean(width0_df.V_low), c='#a7324b',
            linestyle='dotted', alpha=0.5, lw=2)
plt.axhline(y=np.mean(width50_df.V_low), c='#d68590',
            linestyle='dotted', alpha=0.5, lw=2)
plt.axhline(y=np.mean(width100_df.V_low), c='#ffd5da',
            linestyle='dotted', alpha=0.5, lw=2)
plt.axhline(y=np.mean(width0_df.V_nrm), c='#468608',
            linestyle='dotted', alpha=0.5, lw=2)
plt.axhline(y=np.mean(width50_df.V_nrm), c='#91b66c',
            linestyle='dotted', alpha=0.5, lw=2)
plt.axhline(y=np.mean(width100_df.V_nrm), c='#d7e8c4',
            linestyle='dotted', alpha=0.5, lw=2)
plt.axhline(y=np.mean(width0_df.V_hig), c='#004c6d',
            linestyle='dotted', alpha=0.5, lw=2)
plt.axhline(y=np.mean(width50_df.V_hig), c='#528eb3',
            linestyle='dotted', alpha=0.5, lw=2)
plt.axhline(y=np.mean(width100_df.V_hig), c='#bde0f6',
            linestyle='dotted', alpha=0.5, lw=2)
plt.plot(width0_df.V_low, lw=1.5, c='#a7324b', alpha=0.9)
plt.plot(width50_df.V_low, lw=1.5, c='#d68590', alpha=0.9)
plt.plot(width100_df.V_low, lw=1.5, c='#ffd5da', alpha=0.9,
         label="Short Residence Time")
plt.plot(width0_df.V_nrm, lw=1.5, c='#468608', alpha=0.9)
plt.plot(width50_df.V_nrm, lw=1.5, c='#91b66c', alpha=0.9)
plt.plot(width100_df.V_nrm, lw=1.5, c='#d7e8c4', alpha=0.9,
         label="Medium Residence Time")
plt.plot(width0_df.V_hig, lw=1.5, c='#004c6d', alpha=0.9)
plt.plot(width50_df.V_hig, lw=1.5, c='#528eb3', alpha=0.9)
plt.plot(width100_df.V_hig, lw=1.5, c='#bde0f6', alpha=0.9,
         label="Long Residence Time")
ax.xaxis.set_major_locator(mdates.YearLocator(5))
ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y'))
plt.gcf().autofmt_xdate()
plt.gcf().autofmt_xdate(rotation=00)
plt.xlabel('Time')
plt.ylabel('River Storage (km3)')
plt.ylim(0, 6000)
plt.xticks(rotation=0, ha='center')
plt.savefig(fig2b_out, format='svg')


# *******************************************************************************
# Figure 3
# *******************************************************************************
print('- Generating Figure 3')
# ------------------------------------------------------------------------------
# Plot River Width Scenarios: Mean and Range; (Figure 3)
# ------------------------------------------------------------------------------
# Set max river width scenario
n_s = 500

# Set river width step size
step = 5

# Set river width scenario values
wid_scen = pd.DataFrame(list(range(n_s, -1, -step)))

# Retrieve select points for scatter plot
rivwid_scen_pt = wid_scen.iloc[range(0, len(wid_scen)+1, 5)]
V_nrm_pt = V_prop_nrm.iloc[range(0, len(wid_scen)+1, 5)]
Qout_pt = Qout_prop.iloc[range(0, len(wid_scen)+1, 5)]
V_nrm_range_pt = V_prop_nrm_range.iloc[range(0, len(wid_scen)+1, 5)]
Qout_range_pt = Qout_range_prop.iloc[range(0, len(wid_scen)+1, 5)]

fig, ax = plt.subplots()

col1 = 'black'
ax.plot(rivwid_scen_pt, V_nrm_range_pt.iloc[:, 1], color=col1,
        linestyle='dashed')
ax.scatter(rivwid_scen_pt, V_nrm_range_pt.iloc[:, 1],
           color=col1, marker='D')
ax.tick_params(axis='y', labelcolor=col1)

col2 = '#3b5ba1'
ax.plot(rivwid_scen_pt, Qout_range_pt.iloc[:, 1], color=col2,
        linestyle='dashed')
ax.scatter(rivwid_scen_pt, Qout_range_pt.iloc[:, 1],
           color=col2, marker='D')

ax.set_xlabel('Aggregation for All Rivers Wider Than Given Width (m)')
ax.set_ylabel('Proportion of Total Quantity Observed (%)')
ax.plot(rivwid_scen_pt, V_nrm_pt.iloc[:, 1], color=col1)
ax.scatter(rivwid_scen_pt, V_nrm_pt.iloc[:, 1], color=col1)

ax.plot(rivwid_scen_pt, Qout_pt.iloc[:, 1], color=col2)
ax.scatter(rivwid_scen_pt, Qout_pt.iloc[:, 1], color=col2)
ax.set_ylim([50, 101])
plt.xticks(rotation=0, ha='center')

fig.tight_layout()
plt.gca().invert_xaxis()
plt.savefig(fig3_out, format='svg')


# ******************************************************************************
# Figure 4
# ******************************************************************************
print('- Generating Figure 4')
# ------------------------------------------------------------------------------
# Prepare data for plotting
# ------------------------------------------------------------------------------
# Set total Q to ocean from all rivers (km3/yr)
Q_oc = np.mean(width0_df.Qout)

# Calculate proportion of discharge to the ocean from rivers smaller than 100m
Q_sm_prp = 100*(np.sum(Qout_small.Qout_cor)/Q_oc)

# Arrange Q_lg values for bar plot
Q_lg_prp = 100*(Qout_large.Qout_cor/Q_oc)

# ------------------------------------------------------------------------------
# Create bar plot
# ------------------------------------------------------------------------------
blues = ['#112f47', '#143753', '#173e5e', '#1a466a', '#1d4e76', '#346084',
         '#4a7191', '#61839f', '#7795ad', '#8ea7bb']

fig, ax = plt.subplots(figsize=(6, 4))

# Stacked bar chart with loop
for i in range(Qout_large.shape[0]):
    ax.barh('lg', Q_lg_prp[i], height=0.7, left=np.sum(Q_lg_prp[:i]),
            color=blues[i], edgecolor='white', alpha=0.9, linewidth=2)

ax.barh('sm', Q_sm_prp, height=0.7, color='#800e10', edgecolor='white',
        alpha=0.9, linewidth=2)

plt.xlabel('Proportion of Total Discharge to Ocean (%)')
plt.xlim([0, 40])
plt.savefig(fig4_out, format='svg')
