#!/usr/bin/env python3
# ******************************************************************************
# mws_plots_supp3.py
# ******************************************************************************

# Purpose:
# Given all output files from previous scripts, generate visualizations for
# supplemental figures relating to the validation of width estimates.

# Author:
# Jeffrey Wade, Cedric H. David, 2024


# ******************************************************************************
# Import packages
# ******************************************************************************
import sys
import os
import pandas as pd
import numpy as np
import fiona
import glob
from scipy.stats import linregress, pareto
import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm
from scipy.stats import spearmanr


# ******************************************************************************
# Declaration of variables (given as command line arguments)
# ******************************************************************************
# 1 - width_val_in
# 2 - riv_uncor_in
# 3 - fig_s9_out
# 4 - fig_s10_out


# ******************************************************************************
# Get command line arguments
# ******************************************************************************
IS_arg = len(sys.argv)
if IS_arg != 5:
    print('ERROR - 4 arguments must be used')
    raise SystemExit(22)

width_val_in = sys.argv[1]
riv_uncor_in = sys.argv[2]
fig_s9_out = sys.argv[3]
fig_s10_out = sys.argv[4]


# ******************************************************************************
# Check if files/folders exist
# ******************************************************************************
try:
    if os.path.isdir(width_val_in):
        pass
except IOError:
    print('ERROR - '+width_val_in+' invalid folder path')
    raise SystemExit(22)

try:
    if os.path.isdir(riv_uncor_in):
        pass
except IOError:
    print('ERROR - '+riv_uncor_in+' invalid folder path')
    raise SystemExit(22)

# ******************************************************************************
# Read files
# ******************************************************************************
print('- Reading files')
# ------------------------------------------------------------------------------
# Width Validation Files
# ------------------------------------------------------------------------------
# Read files
width_val_files = list(glob.iglob(width_val_in + '*.csv'))
width_val_all = [pd.read_csv(x) for x in width_val_files]

# Combine dataframes
width_val_all = [df for df in width_val_all if not df.empty]
wid_df = pd.concat(width_val_all, axis=0, ignore_index=True)

# ------------------------------------------------------------------------------
# MeanDRS Uncorrected Rivers
# ------------------------------------------------------------------------------
# Read to shapefile
riv_uncor_files = list(glob.iglob(riv_uncor_in+'*.shp'))
riv_uncor_files.sort()
riv_uncor = [fiona.open(j, 'r') for j in riv_uncor_files]


# ******************************************************************************
# Supplemental Figure 9
# ******************************************************************************
print('- Generating Supplemental Figure 9')
# ------------------------------------------------------------------------------
# Plot width validation between MeanDRS and GRWL SWORD
# ------------------------------------------------------------------------------
# Regress MeanDRS and GRWL widths
slope, intercept, r_value, p_value, std_err = linregress(wid_df["m_wid"],
                                                         wid_df["sw_wid"]
                                                         )

# Regress MeanDRS and GRWL widths through origin
slope_0 = np.sum(wid_df["m_wid"] * wid_df["sw_wid"]) /                         \
    np.sum(wid_df["m_wid"]**2)

sw_pred = slope_0 * wid_df["m_wid"]
ss_total = np.sum((wid_df["sw_wid"] - np.mean(wid_df["sw_wid"]))**2)
ss_residual = np.sum((wid_df["sw_wid"] - sw_pred)**2)
r_squared_0 = 1 - (ss_residual / ss_total)

# Calculate Mean Absolute Bias
mab = np.mean(np.abs(wid_df["sw_wid"] - wid_df["m_wid"]))

# Calculate Mean Bias
mb = np.mean(wid_df["sw_wid"] - wid_df["m_wid"])

# Calculate Spearman correlation
corr, p_value = spearmanr(wid_df['m_wid'], wid_df['sw_wid'])

# Width Heatmap for Type 1 reaches (log)
wid_df_0 = wid_df[(wid_df.m_wid > 0) & (wid_df.sw_wid > 0)]
x_bins = np.logspace(np.log10(3), np.log10(np.max(wid_df.m_wid)), 86)
y_bins = np.logspace(np.log10(3), np.log10(np.max(wid_df.sw_wid)), 86)

fig, ax = plt.subplots()
hist = ax.hist2d(wid_df_0.m_wid, wid_df_0.sw_wid, bins=[x_bins, y_bins],
                 cmap='cividis', norm=LogNorm(vmin=1, vmax=1000),
                 rasterized=True)
ax.plot([2, 20000], [2, 20000], c='black', linestyle='--', alpha=0.75)
ax.set_xlabel('MeanDRS Width, m')
ax.set_ylabel('GRWL Width, m')
ax.set_xlim([2.5, 20000])
ax.set_ylim([2.5, 20000])
ax.set_xscale('log')
ax.set_yscale('log')
cb = fig.colorbar(hist[3], ax=ax)
cb.set_label('log10(Frequency)')
plt.tight_layout()
plt.savefig(fig_s9_out, format='svg')


# ******************************************************************************
# Supplemental Figure 10
# ******************************************************************************
print('- Generating Supplemental Figure 10')
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

wid_arr_10 = wid_arr[wid_arr > 11]
wid_arr_0 = wid_arr[wid_arr > 0]

# ------------------------------------------------------------------------------
# Plot width validation Pareto Fit
# ------------------------------------------------------------------------------
# Define the fixed shape and scale parameters by Allen & Pavelsky (2018)
fixed_shape = 0.9
fixed_scale = 2.8

# Create bins for the histogram and pareto distribution
bins = np.logspace(np.log10(wid_arr_0.min()), np.log10(wid_arr_0.max()), 500)

fig, ax = plt.subplots(figsize=(8, 6))
counts, bins = np.histogram(wid_arr_0, bins=bins, density=False)
bin_widths = np.diff(bins)
ax.bar(bins[:-1], counts, width=bin_widths, align='edge', alpha=0.6,
       color='gray', edgecolor='none', bottom=1)

# Fit pareto model
pdf_fitted = pareto.pdf(bins, fixed_shape, scale=fixed_scale)
counts_fitted = pdf_fitted[:-1] * bin_widths * len(wid_arr_0)
ax.plot(bins[:-1], counts_fitted, c='black', lw=1)

# Extend the pareto fit linearly until x = 0.32
y0 = np.log10(counts_fitted[210])
y1 = np.log10(counts_fitted[300])
x0 = np.log10(bins[210])
x1 = np.log10(bins[300])
pareto_m = (y1 - y0) / (x1 - x0)
logx32 = np.log10(0.32)
logy32 = pareto_m * (logx32 - x0) + y0
y32 = 10 ** logy32
ax.plot([bins[300], 0.32], [counts_fitted[300], y32], c='black', lw=1)

ax.set_xscale('log')
ax.set_yscale('log')
ax.set_xlim([0.32, 3500])
ax.set_ylim([1, 10e5])
ax.set_xlabel('Width, m')
ax.set_ylabel('Number of Occurrences')
fig.tight_layout()
plt.savefig(fig_s10_out, format='svg')
