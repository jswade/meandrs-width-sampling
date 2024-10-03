#!/usr/bin/env python3
# ******************************************************************************
# mws_plots_supp1.py
# ******************************************************************************

# Purpose:
# Given all output files from previous scripts, generate visualizations for
# supplemental figures related to sensitivity of using simulations from several
# land surface models to estimate river width.

# Author:
# Jeffrey Wade, Cedric H. David, 2024


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
# 2 - Qout_std_prop_ENS_csv
# 3 - Qout_prop_VIC_csv
# 4 - Qout_prop_VIC_csv
# 5 - Qout_prop_CLSM_csv
# 6 - Qout_prop_CLSM_csv
# 7 - Qout_prop_NOAH_csv
# 8 - Qout_prop_NOAH_csv
# 9 - V_prop_ENS_csv
# 10 - V_std_prop_ENS_csv
# 11 - V_prop_VIC_csv
# 12 - V_std_prop_VIC_csv
# 13 - V_prop_CLSM_csv
# 14 - V_std_prop_CLSM_csv
# 15 - V_prop_NOAH_csv
# 16 - V_std_prop_NOAH_csv
# 16 - fig_s1_out
# 17 - fig_s2_out
# 18 - fig_s3_out
# 19 - fig_s4_out


# ******************************************************************************
# Get command line arguments
# ******************************************************************************
IS_arg = len(sys.argv)
if IS_arg != 21:
    print('ERROR - 20 arguments must be used')
    raise SystemExit(22)

Qout_prop_ENS_csv = sys.argv[1]
Qout_std_prop_ENS_csv = sys.argv[2]
Qout_prop_VIC_csv = sys.argv[3]
Qout_std_prop_VIC_csv = sys.argv[4]
Qout_prop_CLSM_csv = sys.argv[5]
Qout_std_prop_CLSM_csv = sys.argv[6]
Qout_prop_NOAH_csv = sys.argv[7]
Qout_std_prop_NOAH_csv = sys.argv[8]
V_prop_ENS_csv = sys.argv[9]
V_std_prop_ENS_csv = sys.argv[10]
V_prop_VIC_csv = sys.argv[11]
V_std_prop_VIC_csv = sys.argv[12]
V_prop_CLSM_csv = sys.argv[13]
V_std_prop_CLSM_csv = sys.argv[14]
V_prop_NOAH_csv = sys.argv[15]
V_std_prop_NOAH_csv = sys.argv[16]
fig_s1_out = sys.argv[17]
fig_s2_out = sys.argv[18]
fig_s3_out = sys.argv[19]
fig_s4_out = sys.argv[20]


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
    with open(Qout_std_prop_ENS_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_std_prop_ENS_csv)
    raise SystemExit(22)

try:
    with open(Qout_prop_VIC_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_prop_VIC_csv)
    raise SystemExit(22)

try:
    if os.path.isdir(Qout_std_prop_VIC_csv):
        pass
except IOError:
    print('ERROR - '+Qout_std_prop_VIC_csv+' invalid folder path')
    raise SystemExit(22)

try:
    with open(Qout_prop_CLSM_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_prop_CLSM_csv)
    raise SystemExit(22)

try:
    with open(Qout_std_prop_CLSM_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_std_prop_CLSM_csv)
    raise SystemExit(22)

try:
    with open(Qout_prop_NOAH_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_prop_NOAH_csv)
    raise SystemExit(22)

try:
    with open(Qout_std_prop_NOAH_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+Qout_std_prop_NOAH_csv)
    raise SystemExit(22)

try:
    with open(V_prop_ENS_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_prop_ENS_csv)
    raise SystemExit(22)

try:
    with open(V_std_prop_ENS_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_std_prop_ENS_csv)
    raise SystemExit(22)

try:
    if os.path.isdir(V_prop_VIC_csv):
        pass
except IOError:
    print('ERROR - '+V_prop_VIC_csv+' invalid folder path')
    raise SystemExit(22)

try:
    if os.path.isdir(V_std_prop_VIC_csv):
        pass
except IOError:
    print('ERROR - '+V_std_prop_VIC_csv+' invalid folder path')
    raise SystemExit(22)

try:
    if os.path.isdir(V_prop_CLSM_csv):
        pass
except IOError:
    print('ERROR - '+V_prop_CLSM_csv+' invalid folder path')
    raise SystemExit(22)

try:
    with open(V_std_prop_CLSM_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_std_prop_CLSM_csv)
    raise SystemExit(22)

try:
    with open(V_prop_NOAH_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_prop_NOAH_csv)
    raise SystemExit(22)

try:
    with open(V_std_prop_NOAH_csv) as file:
        pass
except IOError:
    print('ERROR - Unable to open '+V_std_prop_NOAH_csv)
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
Qout_std_prop_ENS = pd.read_csv(Qout_std_prop_ENS_csv)

# Read files: VIC
Qout_prop_VIC = pd.read_csv(Qout_prop_VIC_csv)
Qout_std_prop_VIC = pd.read_csv(Qout_std_prop_VIC_csv)

# Read files: CLSM
Qout_prop_CLSM = pd.read_csv(Qout_prop_CLSM_csv)
Qout_std_prop_CLSM = pd.read_csv(Qout_std_prop_CLSM_csv)

# Read files: NOAH
Qout_prop_NOAH = pd.read_csv(Qout_prop_NOAH_csv)
Qout_std_prop_NOAH = pd.read_csv(Qout_std_prop_NOAH_csv)


# ------------------------------------------------------------------------------
# V_rivwidth Files
# ------------------------------------------------------------------------------
# Read files: ENS
V_prop_ENS = pd.read_csv(V_prop_ENS_csv)
V_std_prop_ENS = pd.read_csv(V_std_prop_ENS_csv)

# Read files: VIC
V_prop_VIC = pd.read_csv(V_prop_VIC_csv)
V_std_prop_VIC = pd.read_csv(V_std_prop_VIC_csv)

# Read files: CLSM
V_prop_CLSM = pd.read_csv(V_prop_CLSM_csv)
V_std_prop_CLSM = pd.read_csv(V_std_prop_CLSM_csv)

# Read files: NOAH
V_prop_NOAH = pd.read_csv(V_prop_NOAH_csv)
V_std_prop_NOAH = pd.read_csv(V_std_prop_NOAH_csv)


# *******************************************************************************
# Supplemental Figure 1
# *******************************************************************************
print('- Generating Supplemental Figure 1')
# ------------------------------------------------------------------------------
# Plot River Width Scenarios for Datasets: Qout Mean;
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
Qout_pt_VIC = Qout_prop_VIC.iloc[range(0, len(wid_scen)+1, 5)]
Qout_pt_CLSM = Qout_prop_CLSM.iloc[range(0, len(wid_scen)+1, 5)]
Qout_pt_NOAH = Qout_prop_NOAH.iloc[range(0, len(wid_scen)+1, 5)]

# Create plot
fig, ax = plt.subplots()

col1 = 'black'
col2 = '#124375'
col3 = '#a559aa'
col4 = '#e02b35'

ax.plot(rivwid_scen_pt, Qout_pt_VIC.iloc[:, 1], color=col2,
        alpha=0.8, label='VIC', zorder=1)
ax.scatter(rivwid_scen_pt, Qout_pt_VIC.iloc[:, 1],
           color=col2, label='VIC', zorder=1)

ax.plot(rivwid_scen_pt, Qout_pt_CLSM.iloc[:, 1], color=col3,
        alpha=0.8, label='CLSM', zorder=2)
ax.scatter(rivwid_scen_pt, Qout_pt_CLSM.iloc[:, 1],
           color=col3, label='CLSM', zorder=3)

ax.plot(rivwid_scen_pt, Qout_pt_NOAH.iloc[:, 1], color=col4,
        alpha=0.8, label='NOAH', zorder=3)
ax.scatter(rivwid_scen_pt, Qout_pt_NOAH.iloc[:, 1],
           color=col4, label='NOAH', zorder=3)

ax.plot(rivwid_scen_pt, Qout_pt_ENS.iloc[:, 1], color=col1,
        linewidth=2, label='ENS', zorder=4)
ax.scatter(rivwid_scen_pt, Qout_pt_ENS.iloc[:, 1],
           color=col1, s=60, label='ENS', zorder=4)


ax.set_xlabel('Aggregation for All Rivers Wider Than Given Width (m)')
ax.set_ylabel('Proportion of Mean Global Discharge to the Ocean Observed (%)')

ax.set_ylim([40, 101])
plt.xticks(rotation=0, ha='center')
plt.legend()

fig.tight_layout()
plt.gca().invert_xaxis()

plt.savefig(fig_s1_out, format='svg')


# *******************************************************************************
# Supplemental Figure 2
# *******************************************************************************
print('- Generating Supplemental Figure 2')
# ------------------------------------------------------------------------------
# Plot River Width Scenarios for Datasets: Qout STD;
# ------------------------------------------------------------------------------
# Retrieve select points for scatter plot
rivwid_scen_pt = wid_scen.iloc[range(0, len(wid_scen)+1, 5)]
Qout_std_pt_ENS = Qout_std_prop_ENS.iloc[range(0, len(wid_scen)+1, 5)]
Qout_std_pt_VIC = Qout_std_prop_VIC.iloc[range(0, len(wid_scen)+1, 5)]
Qout_std_pt_CLSM = Qout_std_prop_CLSM.iloc[range(0, len(wid_scen)+1, 5)]
Qout_std_pt_NOAH = Qout_std_prop_NOAH.iloc[range(0, len(wid_scen)+1, 5)]

# Create plot
fig, ax = plt.subplots()

col1 = 'black'
col2 = '#124375'
col3 = '#a559aa'
col4 = '#e02b35'

ax.plot(rivwid_scen_pt, Qout_std_pt_VIC.iloc[:, 1], color=col2,
        linestyle='dashed', alpha=0.8, label='VIC', zorder=1)
ax.scatter(rivwid_scen_pt, Qout_std_pt_VIC.iloc[:, 1],
           color=col2, label='VIC', zorder=1)

ax.plot(rivwid_scen_pt, Qout_std_pt_CLSM.iloc[:, 1], color=col3,
        linestyle='dashed', alpha=0.8, label='CLSM', zorder=2)
ax.scatter(rivwid_scen_pt, Qout_std_pt_CLSM.iloc[:, 1],
           color=col3, label='CLSM', zorder=2)

ax.plot(rivwid_scen_pt, Qout_std_pt_NOAH.iloc[:, 1], color=col4,
        linestyle='dashed', alpha=0.8, label='NOAH', zorder=3)
ax.scatter(rivwid_scen_pt, Qout_std_pt_NOAH.iloc[:, 1],
           color=col4, label='NOAH', zorder=3)

ax.plot(rivwid_scen_pt, Qout_std_pt_ENS.iloc[:, 1], color=col1,
        linestyle='dashed', linewidth=2, label='ENS', zorder=4)
ax.scatter(rivwid_scen_pt, Qout_std_pt_ENS.iloc[:, 1],
           color=col1, s=60, label='ENS', zorder=4)


ax.set_xlabel('Aggregation for All Rivers Wider Than Given Width (m)')
ax.set_ylabel('Proportion of Std. Dev. of Global Discharge to the Ocean'
              'Observed (%)')

ax.set_ylim([40, 101])
plt.xticks(rotation=0, ha='center')
plt.legend()

fig.tight_layout()
plt.gca().invert_xaxis()

plt.savefig(fig_s2_out, format='svg')


# *******************************************************************************
# Supplemental Figure 3
# *******************************************************************************
print('- Generating Supplemental Figure 3')
# ------------------------------------------------------------------------------
# Plot River Width Scenarios for Datasets: Volume Mean;
# ------------------------------------------------------------------------------
# Retrieve select points for scatter plot
rivwid_scen_pt = wid_scen.iloc[range(0, len(wid_scen)+1, 5)]
V_pt_ENS = V_prop_ENS.iloc[range(0, len(wid_scen)+1, 5)]
V_pt_VIC = V_prop_VIC.iloc[range(0, len(wid_scen)+1, 5)]
V_pt_CLSM = V_prop_CLSM.iloc[range(0, len(wid_scen)+1, 5)]
V_pt_NOAH = V_prop_NOAH.iloc[range(0, len(wid_scen)+1, 5)]

# Create plot
fig, ax = plt.subplots()

col1 = 'black'
col2 = '#124375'
col3 = '#a559aa'
col4 = '#e02b35'

ax.plot(rivwid_scen_pt, V_pt_VIC.iloc[:, 1], color=col2,
        alpha=0.8, label='VIC', zorder=1)
ax.scatter(rivwid_scen_pt, V_pt_VIC.iloc[:, 1],
           color=col2, marker='D', label='VIC', zorder=1)

ax.plot(rivwid_scen_pt, V_pt_CLSM.iloc[:, 1], color=col3,
        alpha=0.8, label='CLSM', zorder=2)
ax.scatter(rivwid_scen_pt, V_pt_CLSM.iloc[:, 1],
           color=col3, marker='D', label='CLSM', zorder=3)

ax.plot(rivwid_scen_pt, V_pt_NOAH.iloc[:, 1], color=col4,
        alpha=0.8, label='NOAH', zorder=3)
ax.scatter(rivwid_scen_pt, V_pt_NOAH.iloc[:, 1],
           color=col4, marker='D', label='NOAH', zorder=3)

ax.plot(rivwid_scen_pt, V_pt_ENS.iloc[:, 1], color=col1,
        linewidth=2, label='ENS', zorder=4)
ax.scatter(rivwid_scen_pt, V_pt_ENS.iloc[:, 1],
           color=col1, marker='D', s=60, label='ENS', zorder=4)


ax.set_xlabel('Aggregation for All Rivers Wider Than Given Width (m)')
ax.set_ylabel('Proportion of Mean Global River Storage Observed (%)')

ax.set_ylim([40, 101])
plt.xticks(rotation=0, ha='center')
plt.legend()

fig.tight_layout()
plt.gca().invert_xaxis()

plt.savefig(fig_s3_out, format='svg')


# *******************************************************************************
# Supplemental Figure 4
# *******************************************************************************
print('- Generating Supplemental Figure 4')
# ------------------------------------------------------------------------------
# Plot River Width Scenarios for Datasets: Volume St Dev.;
# ------------------------------------------------------------------------------
# Retrieve select points for scatter plot
rivwid_scen_pt = wid_scen.iloc[range(0, len(wid_scen)+1, 5)]
V_std_pt_ENS = V_std_prop_ENS.iloc[range(0, len(wid_scen)+1, 5)]
V_std_pt_VIC = V_std_prop_VIC.iloc[range(0, len(wid_scen)+1, 5)]
V_std_pt_CLSM = V_std_prop_CLSM.iloc[range(0, len(wid_scen)+1, 5)]
V_std_pt_NOAH = V_std_prop_NOAH.iloc[range(0, len(wid_scen)+1, 5)]

# Create plot
fig, ax = plt.subplots()

col1 = 'black'
col2 = '#124375'
col3 = '#a559aa'
col4 = '#e02b35'

ax.plot(rivwid_scen_pt, V_std_pt_VIC.iloc[:, 1], color=col2,
        linestyle='dashed', alpha=0.8, label='VIC', zorder=1)
ax.scatter(rivwid_scen_pt, V_std_pt_VIC.iloc[:, 1],
           color=col2, marker='D', label='VIC', zorder=1)

ax.plot(rivwid_scen_pt, V_std_pt_CLSM.iloc[:, 1], color=col3,
        linestyle='dashed', alpha=0.8, label='CLSM', zorder=2)
ax.scatter(rivwid_scen_pt, V_std_pt_CLSM.iloc[:, 1],
           color=col3, marker='D', label='CLSM', zorder=3)

ax.plot(rivwid_scen_pt, V_std_pt_NOAH.iloc[:, 1], color=col4,
        linestyle='dashed', alpha=0.8, label='NOAH', zorder=3)
ax.scatter(rivwid_scen_pt, V_std_pt_NOAH.iloc[:, 1],
           color=col4, marker='D', label='NOAH', zorder=3)

ax.plot(rivwid_scen_pt, V_std_pt_ENS.iloc[:, 1], color=col1,
        linestyle='dashed', linewidth=2, label='ENS', zorder=4)
ax.scatter(rivwid_scen_pt, V_std_pt_ENS.iloc[:, 1],
           color=col1, marker='D', s=60, label='ENS', zorder=4)


ax.set_xlabel('Aggregation for All Rivers Wider Than Given Width (m)')
ax.set_ylabel('Proportion of Std. Dev. of Global River Storage Observed (%)')

ax.set_ylim([40, 101])
plt.xticks(rotation=0, ha='center')
plt.legend()

fig.tight_layout()
plt.gca().invert_xaxis()

plt.savefig(fig_s4_out, format='svg')
