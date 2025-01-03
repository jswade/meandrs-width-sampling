#!/usr/bin/env python3
# ******************************************************************************
# mws_plots_supp2.py
# ******************************************************************************

# Purpose:
# Given all output files from previous scripts, generate visualizations for
# supplemental figures relating to sensitivity of using uncorrected versus
# corrected discharge and volume simulations.

# Author:
# Jeffrey Wade, Cedric H. David, 2025


# ******************************************************************************
# Import packages
# ******************************************************************************
import pandas as pd
import matplotlib.pyplot as plt
import sys
import os


# ******************************************************************************
# Declaration of variables (given as command line arguments)
# ******************************************************************************
# 1 - Qout_prop_ENS_csv
# 2 - Qout_range_prop_ENS_csv
# 3 - V_prop_ENS_csv
# 4 - V_range_prop_ENS_csv
# 5 - Qout_prop_COR_csv
# 6 - Qout_range_prop_COR_csv
# 7 - V_prop_COR_csv
# 8 - V_range_prop_COR_csv
# 9 - fig_s5_out
# 10 - fig_s6_out
# 11 - fig_s7_out
# 12 - fig_s8_out


# ******************************************************************************
# Get command line arguments
# ******************************************************************************
IS_arg = len(sys.argv)
if IS_arg != 13:
    print('ERROR - 12 arguments must be used')
    raise SystemExit(22)

Qout_prop_ENS_csv = sys.argv[1]
Qout_range_prop_ENS_csv = sys.argv[2]
V_prop_ENS_csv = sys.argv[3]
V_range_prop_ENS_csv = sys.argv[4]
Qout_prop_COR_csv = sys.argv[5]
Qout_range_prop_COR_csv = sys.argv[6]
V_prop_COR_csv = sys.argv[7]
V_range_prop_COR_csv = sys.argv[8]
fig_s5_out = sys.argv[9]
fig_s6_out = sys.argv[10]
fig_s7_out = sys.argv[11]
fig_s8_out = sys.argv[12]


# ******************************************************************************
# Check if files/folders exist
# ******************************************************************************
try:
    if os.path.isdir(Qout_prop_ENS_csv):
        pass
except IOError:
    print('ERROR - '+Qout_prop_ENS_csv+' invalid folder path')
    raise SystemExit(22)

try:
    with open(Qout_range_prop_ENS_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_range_prop_ENS_csv)
    raise SystemExit(22)

try:
    with open(V_prop_ENS_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_prop_ENS_csv)
    raise SystemExit(22)

try:
    if os.path.isdir(V_range_prop_ENS_csv):
        pass
except IOError:
    print('ERROR - '+V_range_prop_ENS_csv+' invalid folder path')
    raise SystemExit(22)

try:
    with open(Qout_prop_COR_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_prop_COR_csv)
    raise SystemExit(22)

try:
    with open(Qout_range_prop_COR_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_range_prop_COR_csv)
    raise SystemExit(22)

try:
    with open(V_range_prop_COR_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_range_prop_COR_csv)
    raise SystemExit(22)

try:
    with open(V_prop_COR_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_prop_COR_csv)
    raise SystemExit(22)


# ******************************************************************************
# Read files
# ******************************************************************************
print('- Reading files')
# ------------------------------------------------------------------------------
# Qout_rivwidth Files
# ------------------------------------------------------------------------------
# Read files: ENS
Qout_prop_ENS = pd.read_csv(Qout_prop_ENS_csv)
Qout_range_prop_ENS = pd.read_csv(Qout_range_prop_ENS_csv)

# Read files: COR
Qout_prop_COR = pd.read_csv(Qout_prop_COR_csv)
Qout_range_prop_COR = pd.read_csv(Qout_range_prop_COR_csv)

# ------------------------------------------------------------------------------
# V_rivwidth Files
# ------------------------------------------------------------------------------
# Read files: ENS
V_prop_ENS = pd.read_csv(V_prop_ENS_csv)
V_range_prop_ENS = pd.read_csv(V_range_prop_ENS_csv)

# Read files: COR
V_prop_COR = pd.read_csv(V_prop_COR_csv)
V_range_prop_COR = pd.read_csv(V_range_prop_COR_csv)


# *******************************************************************************
# Supplemental Figure 5
# *******************************************************************************
print('- Generating Supplemental Figure 5')
# ------------------------------------------------------------------------------
# Plot River Width Scenarios for Datasets: Qout Mean, ENS vs COR
# ------------------------------------------------------------------------------
# Set max river width scenario
n_s = 500

# Set river width step size
step = 5

# Set river width scenario values
wid_scen = pd.DataFrame(list(range(n_s, -1, -step)))

# Retrieve select points for scatter plot
rivwid_scen_pt = wid_scen.iloc[range(0, len(wid_scen)+1, 5)]
Qout_pt_ENS = Qout_prop_ENS.iloc[range(0, len(wid_scen)+1, 5)]
Qout_pt_COR = Qout_prop_COR.iloc[range(0, len(wid_scen)+1, 5)]

# Create plot
fig, ax = plt.subplots()

col1 = 'black'
col2 = '#c1272d'

ax.plot(rivwid_scen_pt, Qout_pt_COR.iloc[:, 1], color=col1,
        label='COR', zorder=2)
ax.scatter(rivwid_scen_pt, Qout_pt_COR.iloc[:, 1],
           color=col1, s=60, label='COR', zorder=2)

ax.plot(rivwid_scen_pt, Qout_pt_ENS.iloc[:, 1], color=col2,
        linewidth=2, alpha=0.8, label='ENS', zorder=1)
ax.scatter(rivwid_scen_pt, Qout_pt_ENS.iloc[:, 1],
           color=col2, label='ENS', zorder=1)


ax.set_xlabel('Aggregation for All Rivers Wider Than Given Width (m)')
ax.set_ylabel('Proportion of Mean Global Discharge to the Ocean Observed (%)')

ax.set_ylim([50, 101])
plt.xticks(rotation=0, ha='center')
plt.legend()

fig.tight_layout()
plt.gca().invert_xaxis()

plt.savefig(fig_s5_out, format='svg')


# *******************************************************************************
# Supplemental Figure 6
# *******************************************************************************
print('- Generating Supplemental Figure 6')
# ------------------------------------------------------------------------------
# Plot River Width Scenarios for Datasets: Qout range, ENS vs COR
# ------------------------------------------------------------------------------
# Retrieve select points for scatter plot
rivwid_scen_pt = wid_scen.iloc[range(0, len(wid_scen)+1, 5)]
Qout_range_pt_ENS = Qout_range_prop_ENS.iloc[range(0, len(wid_scen)+1, 5)]
Qout_range_pt_COR = Qout_range_prop_COR.iloc[range(0, len(wid_scen)+1, 5)]

# Create plot
fig, ax = plt.subplots()

col1 = 'black'
col2 = '#c1272d'

ax.plot(rivwid_scen_pt, Qout_range_pt_COR.iloc[:, 1], color=col1,
        linestyle='dashed', label='COR', zorder=2)
ax.scatter(rivwid_scen_pt, Qout_range_pt_COR.iloc[:, 1],
           color=col1, s=60, label='COR', zorder=2)

ax.plot(rivwid_scen_pt, Qout_range_pt_ENS.iloc[:, 1], color=col2,
        linestyle='dashed', alpha=0.8, linewidth=2, label='ENS', zorder=1)
ax.scatter(rivwid_scen_pt, Qout_range_pt_ENS.iloc[:, 1],
           color=col2, label='ENS', zorder=1)


ax.set_xlabel('Aggregation for All Rivers Wider Than Given Width (m)')
ax.set_ylabel('Proportion of Mean Annual Range of Global Discharge to the Ocean'
              'Observed (%)')

ax.set_ylim([50, 101])
plt.xticks(rotation=0, ha='center')
plt.legend()

fig.tight_layout()
plt.gca().invert_xaxis()

plt.savefig(fig_s6_out, format='svg')


# *******************************************************************************
# Supplemental Figure 7
# *******************************************************************************
print('- Generating Supplemental Figure 7')
# ------------------------------------------------------------------------------
# Plot River Width Scenarios for Datasets: Volume Mean; ENS vs COR
# ------------------------------------------------------------------------------
# Retrieve select points for scatter plot
rivwid_scen_pt = wid_scen.iloc[range(0, len(wid_scen)+1, 5)]
V_pt_ENS = V_prop_ENS.iloc[range(0, len(wid_scen)+1, 5)]
V_pt_COR = V_prop_COR.iloc[range(0, len(wid_scen)+1, 5)]

# Create plot
fig, ax = plt.subplots()

col1 = 'black'
col2 = '#c1272d'

ax.plot(rivwid_scen_pt, V_pt_COR.iloc[:, 1], color=col1,
        label='COR', zorder=2)
ax.scatter(rivwid_scen_pt, V_pt_COR.iloc[:, 1],
           color=col1, marker='D', s=60, label='COR', zorder=2)

ax.plot(rivwid_scen_pt, V_pt_ENS.iloc[:, 1], color=col2,
        alpha=0.8, linewidth=2, label='ENS', zorder=1)
ax.scatter(rivwid_scen_pt, V_pt_ENS.iloc[:, 1],
           color=col2, marker='D', label='ENS', zorder=1)


ax.set_xlabel('Aggregation for All Rivers Wider Than Given Width (m)')
ax.set_ylabel('Proportion of Mean Global River Storage Observed (%)')

ax.set_ylim([50, 101])
plt.xticks(rotation=0, ha='center')
plt.legend()

fig.tight_layout()
plt.gca().invert_xaxis()

plt.savefig(fig_s7_out, format='svg')


# *******************************************************************************
# Supplemental Figure 8
# *******************************************************************************
print('- Generating Supplemental Figure 8')
# ------------------------------------------------------------------------------
# Plot River Width Scenarios for Datasets: Volume Range; ENS vs COR
# ------------------------------------------------------------------------------
# Retrieve select points for scatter plot
rivwid_scen_pt = wid_scen.iloc[range(0, len(wid_scen)+1, 5)]
V_range_pt_ENS = V_range_prop_ENS.iloc[range(0, len(wid_scen)+1, 5)]
V_range_pt_COR = V_range_prop_COR.iloc[range(0, len(wid_scen)+1, 5)]

# Create plot
fig, ax = plt.subplots()

col1 = 'black'
col2 = '#c1272d'

ax.plot(rivwid_scen_pt, V_range_pt_COR.iloc[:, 1], color=col1,
        linestyle='dashed', label='COR', zorder=2)
ax.scatter(rivwid_scen_pt, V_range_pt_COR.iloc[:, 1],
           color=col1, marker='D', s=60, label='COR', zorder=2)

ax.plot(rivwid_scen_pt, V_range_pt_ENS.iloc[:, 1], color=col2,
        alpha=0.8, linestyle='dashed', linewidth=2, label='ENS', zorder=1)
ax.scatter(rivwid_scen_pt, V_range_pt_ENS.iloc[:, 1],
           color=col2, marker='D', label='ENS', zorder=1)


ax.set_xlabel('Aggregation for All Rivers Wider Than Given Width (m)')
ax.set_ylabel('Proportion of Mean Annual Range of Global River Storage'
              ' Observed (%)')

ax.set_ylim([50, 101])
plt.xticks(rotation=0, ha='center')
plt.legend()

fig.tight_layout()
plt.gca().invert_xaxis()

plt.savefig(fig_s8_out, format='svg')
