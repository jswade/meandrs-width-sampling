#!/usr/bin/env python3
# ******************************************************************************
# test_cmp.py
# ******************************************************************************

# Purpose:
# Given an original file and a file generating during testing,
# ensure that files are identical.

# Author:
# Jeffrey Wade, Cedric H. David, 2024


# ******************************************************************************
# Import Python modules
# ******************************************************************************
import sys
import filecmp
import pandas as pd

# ******************************************************************************
# Declaration of variables (given as command line arguments)
# ******************************************************************************
# 1 - file_org
# 2 - file_tst


# ******************************************************************************
# Get command line arguments
# ******************************************************************************
IS_arg = len(sys.argv)
if IS_arg != 3:
    print('ERROR - 2 arguments must be used')
    raise SystemExit(22)

file_org = sys.argv[1]
file_tst = sys.argv[2]


# ******************************************************************************
# Check if files exist
# ******************************************************************************
try:
    with open(file_org) as file:
        pass
except IOError:
    print('ERROR - Unable to open ' + file_org)
    raise SystemExit(22)

try:
    with open(file_tst) as file:
        pass
except IOError:
    print('ERROR - Unable to open ' + file_tst)
    raise SystemExit(22)


# ******************************************************************************
# Compare original and test files
# ******************************************************************************

# # Clear cache
# filecmp.clear_cache()

# # If files are not identical, raise error
# if not (filecmp.cmp(file_org, file_tst, shallow=False)):
#     print('ERROR - Comparison failed.')
#     raise SystemExit(99)
# else:
#     print('Comparison successful!')


df_org = pd.read_csv(file_org)
df_tst = pd.read_csv(file_tst)

# Ensure both DataFrames have the same shape
if df_org.shape != df_tst.shape:
    print(f"ERROR - DataFrames have different shapes: {df_org.shape} vs {df_tst.shape}")
    raise SystemExit(99)

# Find differences by comparing values
comparison_result = df_org.compare(df_tst, keep_shape=True, keep_equal=False)
comparison_result = comparison_result.dropna(axis=1,how='all')

if comparison_result.empty:
    print('Comparison successful! Files contain identical data.')
else:
    print('ERROR - Data comparison failed. Differences found:')
    print(comparison_result)
    raise SystemExit(99)

# if not(df_org.equals(df_tst)):
#     print('ERROR - Comparison failed.')
#     raise SystemExit(99)
# else:
#     print('Comparison successful!')