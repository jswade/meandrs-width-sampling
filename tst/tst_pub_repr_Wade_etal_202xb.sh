#!/bin/bash
#*****************************************************************************
#tst_pub_repr_Wade_etal_202xb.sh
#*****************************************************************************
#Purpose:
#DOI: xx.xxxx/xxxxxxxxxxxx
#The files used are available from:
#DOI: 10.5281/zenodo.13381368
#The following are the possible arguments:
# - No argument: all unit tests are run
# - One unique unit test number: this test is run
# - Two unit test numbers: all tests between those (included) are run
#The script returns the following exit codes
# - 0  if all experiments are successful
# - 22 if some arguments are faulty
# - 99 if a comparison failed
#Author:
#Jeffrey Wade, Cedric H. David, 2024
#
#*****************************************************************************
#Publication message
#*****************************************************************************
echo "********************"
echo "Reproducing files for: https://doi.org/xxx/zenodo.xxx"
echo "********************"


#*****************************************************************************
#Set Pfaf regions and rank
#*****************************************************************************
pfaf='11'
rank='10'


#*****************************************************************************
#Retrieve number of files preset in output directories
#*****************************************************************************
#num_files=$(ls ../input/MeanDRS/Qout_COR/* | wc -l)
num_files=$(ls ../input/MeanDRS/riv_UNCOR/* | wc -l)

#*****************************************************************************
#Select which unit tests to perform based on inputs to this shell script
#*****************************************************************************
#Perform all unit tests if no options are given and all files available
#Perform subset of unit tests if files are missing from GitHub Actions CI
tot=31
if [ "$#" = "0" ]; then
    if [ "$num_files" -ne 61 ] ; then
        fst=1
        lst=15
        echo "Performing all unit tests for available files"
        echo "********************"
    else
        fst=1
        lst=$tot
        echo "Performing all unit tests"
        echo "********************"
    fi
fi

#Perform one single unit test if one option is given
if [ "$#" = "1" ]; then
     fst=$1
     lst=$1
     echo "Performing one unit test: $1"
     echo "********************"
fi

#Perform all unit tests between first and second option given (both included)
if [ "$#" = "2" ]; then
     fst=$1
     lst=$2
     echo "Performing unit tests: $1-$2"
     echo "********************"
fi

#Exit if more than two options are given
if [ "$#" -gt "2" ]; then
     echo "A maximum of two options can be used" 1>&2
     exit 22
fi


#*****************************************************************************
#Initialize count for unit tests
#*****************************************************************************
unt=0

#
##*****************************************************************************
##Identify rivers draining to the global coast: ENS/COR
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/riv_coast/cor"
#mkdir -p "../output_test/riv_coast/uncor"
#
#echo "- Identifying coastal rivers: ENS/COR"
#../src/mws_coastal_rivs.py                                                     \
#    ../input/MeanDRS/cat_disso/cat_pfaf_${pfaf}_MERIT_Hydro_v07_Basins_v01_disso.shp\
#    ../input/MeanDRS/global_perim/cat_MERIT_Hydro_v07_Basins_v01_perim.shp     \
#    ../input/MeanDRS/riv_COR/riv_pfaf_${pfaf}_MERIT_Hydro_v07_Basins_v01_GLDAS_COR.shp\
#    ../input/MeanDRS/riv_UNCOR/riv_pfaf_${pfaf}_MERIT_Hydro_v07_Basins_v01_GLDAS_ENS.shp\
#    ../input/MeanDRS/Qout_UNCOR/Qout_pfaf_11_GLDAS_ENS_M_1980-01_2009-12_utc.nc4\
#    ../output_test/riv_coast/uncor/riv_coast_pfaf_${pfaf}_UNCOR.shp            \
#    ../output_test/riv_coast/cor/riv_coast_pfaf_${pfaf}_COR.shp                \
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing corrected coastal rivers file: COR (.shp)"
#../src/tst_cmp.py                                                              \
#    ../output/riv_coast/cor/riv_coast_pfaf_${pfaf}_COR.shp                     \
#    ../output_test/riv_coast/cor/riv_coast_pfaf_${pfaf}_COR.shp                \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing uncorrected coastal rivers file: ENS (.shp)"
#../src/tst_cmp.py                                                              \
#    ../output/riv_coast/uncor/riv_coast_pfaf_${pfaf}_UNCOR.shp                 \
#    ../output_test/riv_coast/uncor/riv_coast_pfaf_${pfaf}_UNCOR.shp            \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi


#*****************************************************************************
#Identify rivers draining to the global coast: Uncorrected VIC
#*****************************************************************************
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"

run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

mkdir -p "../output_test/rivwidth_sens/riv_coast/uncor_VIC"

echo "- Identifying coastal rivers: VIC"
../src/mws_coastal_rivs.py                                                     \
    ../input/MeanDRS/cat_disso/cat_pfaf_${pfaf}_MERIT_Hydro_v07_Basins_v01_disso.shp\
    ../input/MeanDRS/global_perim/cat_MERIT_Hydro_v07_Basins_v01_perim.shp     \
    ../input/MeanDRS/riv_COR/riv_pfaf_${pfaf}_MERIT_Hydro_v07_Basins_v01_GLDAS_COR.shp\
    ../input/MeanDRS/riv_UNCOR/riv_pfaf_${pfaf}_MERIT_Hydro_v07_Basins_v01_GLDAS_ENS.shp\
    ../input/MeanDRS/Qout_VIC/Qout_pfaf_${pfaf}_GLDAS_VIC_M_1980-01_2009-12_utc.nc4 \
    ../output_test/rivwidth_sens/riv_coast/uncor_VIC/riv_coast_pfaf_${pfaf}_VIC.shp\
    > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing uncorrected coastal rivers file: VIC (.shp)"
../src/tst_cmp.py                                                              \
    ../output/rivwidth_sens/riv_coast/uncor_VIC/riv_coast_pfaf_${pfaf}_VIC.shp \
    ../output_test/rivwidth_sens/riv_coast/uncor_VIC/riv_coast_pfaf_${pfaf}_VIC.shp\
    > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

##*****************************************************************************
##Identify rivers draining to the global coast: Uncorrected CLSM
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/rivwidth_sens/riv_coast/uncor_CLSM"
#
#echo "- Identifying coastal rivers: CLSM"
#../src/mws_coastal_rivs.py                                                     \
#    ../input/MeanDRS/cat_disso/cat_pfaf_${pfaf}_MERIT_Hydro_v07_Basins_v01_disso.shp\
#    ../input/MeanDRS/global_perim/cat_MERIT_Hydro_v07_Basins_v01_perim.shp     \
#    ../input/MeanDRS/riv_COR/riv_pfaf_${pfaf}_MERIT_Hydro_v07_Basins_v01_GLDAS_COR.shp\
#    ../input/MeanDRS/riv_UNCOR/riv_pfaf_${pfaf}_MERIT_Hydro_v07_Basins_v01_GLDAS_ENS.shp\
#    ../input/MeanDRS/Qout_CLSM/Qout_pfaf_${pfaf}_GLDAS_CLSM_M_1980-01_2009-12_utc.nc4\
#    ../output_test/rivwidth_sens/riv_coast/uncor_CLSM/riv_coast_pfaf_${pfaf}_CLSM.shp\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing uncorrected coastal rivers file: CLSM (.shp)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/riv_coast/uncor_CLSM/riv_coast_pfaf_${pfaf}_CLSM.shp\
#    ../output_test/rivwidth_sens/riv_coast/uncor_CLSM/riv_coast_pfaf_${pfaf}_CLSM.shp\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Identify rivers draining to the global coast: Uncorrected NOAH
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/rivwidth_sens/riv_coast/uncor_NOAH"
#
#echo "- Identifying coastal rivers: NOAH"
#../src/mws_coastal_rivs.py                                                     \
#    ../input/MeanDRS/cat_disso/cat_pfaf_${pfaf}_MERIT_Hydro_v07_Basins_v01_disso.shp\
#    ../input/MeanDRS/global_perim/cat_MERIT_Hydro_v07_Basins_v01_perim.shp     \
#    ../input/MeanDRS/riv_COR/riv_pfaf_${pfaf}_MERIT_Hydro_v07_Basins_v01_GLDAS_COR.shp\
#    ../input/MeanDRS/riv_UNCOR/riv_pfaf_${pfaf}_MERIT_Hydro_v07_Basins_v01_GLDAS_ENS.shp\
#    ../input/MeanDRS/Qout_NOAH/Qout_pfaf_${pfaf}_GLDAS_NOAH_M_1980-01_2009-12_utc.nc4\
#    ../output_test/rivwidth_sens/riv_coast/uncor_NOAH/riv_coast_pfaf_${pfaf}_NOAH.shp\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing uncorrected coastal rivers file: NOAH (.shp)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/riv_coast/uncor_NOAH/riv_coast_pfaf_${pfaf}_NOAH.shp\
#    ../output_test/rivwidth_sens/riv_coast/uncor_NOAH/riv_coast_pfaf_${pfaf}_NOAH.shp\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate discharge to ocean based on river width samples: ENS/COR
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/Qout_rivwidth"
#
#echo "- Calculate discharge to ocean for river width samples: ENS/COR"
#python ../src/mws_rivwidth_Qout.py                                             \
#    ../output/riv_coast/uncor/riv_coast_pfaf_${pfaf}_UNCOR.shp                 \
#    ../input/MeanDRS/Qout_COR/Qout_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc.nc4\
#    ../output_test/Qout_rivwidth/Qout_pfaf_${pfaf}_rivwidth.csv                \
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing Qout river width file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/Qout_rivwidth/Qout_pfaf_${pfaf}_rivwidth.csv                     \
#    ../output_test/Qout_rivwidth/Qout_pfaf_${pfaf}_rivwidth.csv                \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate discharge to ocean based on river width samples: VIC
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/rivwidth_sens/Qout_rivwidth_VIC/"
#
#echo "- Calculate discharge to ocean for river width samples: VIC"
#python ../src/mws_rivwidth_Qout.py                                             \
#    ../output/rivwidth_sens/riv_coast/uncor_VIC/riv_coast_pfaf_${pfaf}_VIC.shp \
#    ../input/MeanDRS/Qout_COR/Qout_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc.nc4\
#    ../output_test/rivwidth_sens/Qout_rivwidth_VIC/Qout_pfaf_${pfaf}_rivwidth_VIC_wid.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing Qout river width file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/Qout_rivwidth_VIC/Qout_pfaf_${pfaf}_rivwidth_VIC_wid.csv\
#    ../output_test/rivwidth_sens/Qout_rivwidth_VIC/Qout_pfaf_${pfaf}_rivwidth_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate discharge to ocean based on river width samples: CLSM
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/rivwidth_sens/Qout_rivwidth_CLSM/"
#
#echo "- Calculate discharge to ocean for river width samples: CLSM"
#python ../src/mws_rivwidth_Qout.py                                             \
#    ../output/rivwidth_sens/riv_coast/uncor_CLSM/riv_coast_pfaf_${pfaf}_CLSM.shp\
#    ../input/MeanDRS/Qout_COR/Qout_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc.nc4\
#    ../output_test/rivwidth_sens/Qout_rivwidth_CLSM/Qout_pfaf_${pfaf}_rivwidth_CLSM_wid.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing Qout river width file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/Qout_rivwidth_CLSM/Qout_pfaf_${pfaf}_rivwidth_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/Qout_rivwidth_CLSM/Qout_pfaf_${pfaf}_rivwidth_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate discharge to ocean based on river width samples: NOAH
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/rivwidth_sens/Qout_rivwidth_NOAH/"
#
#echo "- Calculate discharge to ocean for river width samples: NOAH"
#python ../src/mws_rivwidth_Qout.py                                             \
#    ../output/rivwidth_sens/riv_coast/uncor_NOAH/riv_coast_pfaf_${pfaf}_NOAH.shp\
#    ../input/MeanDRS/Qout_COR/Qout_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc.nc4\
#    ../output_test/rivwidth_sens/Qout_rivwidth_NOAH/Qout_pfaf_${pfaf}_rivwidth_NOAH_wid.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing Qout river width file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/Qout_rivwidth_NOAH/Qout_pfaf_${pfaf}_rivwidth_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/Qout_rivwidth_NOAH/Qout_pfaf_${pfaf}_rivwidth_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate discharge to ocean based on river width samples: ENS/ENS
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/cor_sens/Qout_rivwidth_ENS/"
#
#echo "- Calculate discharge to ocean for river width samples: ENS"
#python ../src/mws_rivwidth_Qout.py                                             \
#    ../output/riv_coast/uncor/riv_coast_pfaf_${pfaf}_UNCOR.shp                 \
#    ../input/MeanDRS/Qout_UNCOR/Qout_pfaf_${pfaf}_GLDAS_ENS_M_1980-01_2009-12_utc.nc4\
#    ../output_test/cor_sens/Qout_rivwidth_ENS/Qout_pfaf_${pfaf}_rivwidth_ENS.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing Qout river width file: ENS/ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/Qout_rivwidth_ENS/Qout_pfaf_${pfaf}_rivwidth_ENS.csv    \
#    ../output_test/cor_sens/Qout_rivwidth_ENS/Qout_pfaf_${pfaf}_rivwidth_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate total volume based on river width samples: ENS/COR
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/V_rivwidth_low"
#mkdir -p "../output_test/V_rivwidth_nrm"
#mkdir -p "../output_test/V_rivwidth_hig"
#
#echo "- Calculate total river volume for river width samples"
#../src/mws_rivwidth_V.py                                                       \
#    ../input/MeanDRS/Qout_UNCOR/Qout_pfaf_${pfaf}_GLDAS_ENS_M_1980-01_2009-12_utc.nc4\
#    ../input/MeanDRS/V_low_COR/V_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc_low.nc4\
#    ../input/MeanDRS/V_nrm_COR/V_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc_nrm.nc4\
#    ../input/MeanDRS/V_hig_COR/V_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc_hig.nc4\
#    ../output_test/V_rivwidth_low/V_pfaf_${pfaf}_rivwidth_low.csv              \
#    ../output_test/V_rivwidth_nrm/V_pfaf_${pfaf}_rivwidth_nrm.csv              \
#    ../output_test/V_rivwidth_hig/V_pfaf_${pfaf}_rivwidth_hig.csv              \
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing V_low river width file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/V_rivwidth_low/V_pfaf_${pfaf}_rivwidth_low.csv                   \
#    ../output_test/V_rivwidth_low/V_pfaf_${pfaf}_rivwidth_low.csv              \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing V_nrm river width file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/V_rivwidth_nrm/V_pfaf_${pfaf}_rivwidth_nrm.csv                   \
#    ../output_test/V_rivwidth_nrm/V_pfaf_${pfaf}_rivwidth_nrm.csv              \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing V_hig river width file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/V_rivwidth_hig/V_pfaf_${pfaf}_rivwidth_hig.csv                   \
#    ../output_test/V_rivwidth_hig/V_pfaf_${pfaf}_rivwidth_hig.csv              \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate total volume based on river width samples: VIC
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/rivwidth_sens/V_rivwidth_low_VIC"
#mkdir -p "../output_test/rivwidth_sens/V_rivwidth_nrm_VIC"
#mkdir -p "../output_test/rivwidth_sens/V_rivwidth_hig_VIC"
#
#echo "- Calculate total river volume for river width samples: VIC"
#../src/mws_rivwidth_V.py                                                       \
#    ../input/MeanDRS/Qout_VIC/Qout_pfaf_${pfaf}_GLDAS_VIC_M_1980-01_2009-12_utc.nc4\
#    ../input/MeanDRS/V_low_COR/V_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc_low.nc4\
#    ../input/MeanDRS/V_nrm_COR/V_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc_nrm.nc4\
#    ../input/MeanDRS/V_hig_COR/V_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc_hig.nc4\
#    ../output_test/rivwidth_sens/V_rivwidth_low_VIC/V_pfaf_${pfaf}_rivwidth_low_VIC_wid.csv\
#    ../output_test/rivwidth_sens/V_rivwidth_nrm_VIC/V_pfaf_${pfaf}_rivwidth_nrm_VIC_wid.csv\
#    ../output_test/rivwidth_sens/V_rivwidth_hig_VIC/V_pfaf_${pfaf}_rivwidth_hig_VIC_wid.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing V_low river width file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/V_rivwidth_low_VIC/V_pfaf_${pfaf}_rivwidth_low_VIC_wid.csv\
#    ../output_test/rivwidth_sens/V_rivwidth_low_VIC/V_pfaf_${pfaf}_rivwidth_low_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing V_nrm river width file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/V_rivwidth_nrm_VIC/V_pfaf_${pfaf}_rivwidth_nrm_VIC_wid.csv\
#    ../output_test/rivwidth_sens/V_rivwidth_nrm_VIC/V_pfaf_${pfaf}_rivwidth_nrm_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing V_hig river width file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/V_rivwidth_hig_VIC/V_pfaf_${pfaf}_rivwidth_hig_VIC_wid.csv\
#    ../output_test/rivwidth_sens/V_rivwidth_hig_VIC/V_pfaf_${pfaf}_rivwidth_hig_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate total volume based on river width samples: CLSM
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/rivwidth_sens/V_rivwidth_low_CLSM"
#mkdir -p "../output_test/rivwidth_sens/V_rivwidth_nrm_CLSM"
#mkdir -p "../output_test/rivwidth_sens/V_rivwidth_hig_CLSM"
#
#echo "- Calculate total river volume for river width samples: CLSM"
#../src/mws_rivwidth_V.py                                                       \
#    ../input/MeanDRS/Qout_CLSM/Qout_pfaf_${pfaf}_GLDAS_CLSM_M_1980-01_2009-12_utc.nc4\
#    ../input/MeanDRS/V_low_COR/V_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc_low.nc4\
#    ../input/MeanDRS/V_nrm_COR/V_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc_nrm.nc4\
#    ../input/MeanDRS/V_hig_COR/V_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc_hig.nc4\
#    ../output_test/rivwidth_sens/V_rivwidth_low_CLSM/V_pfaf_${pfaf}_rivwidth_low_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/V_rivwidth_nrm_CLSM/V_pfaf_${pfaf}_rivwidth_nrm_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/V_rivwidth_hig_CLSM/V_pfaf_${pfaf}_rivwidth_hig_CLSM_wid.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing V_low river width file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/V_rivwidth_low_CLSM/V_pfaf_${pfaf}_rivwidth_low_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/V_rivwidth_low_CLSM/V_pfaf_${pfaf}_rivwidth_low_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing V_nrm river width file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/V_rivwidth_nrm_CLSM/V_pfaf_${pfaf}_rivwidth_nrm_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/V_rivwidth_nrm_CLSM/V_pfaf_${pfaf}_rivwidth_nrm_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing V_hig river width file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/V_rivwidth_hig_CLSM/V_pfaf_${pfaf}_rivwidth_hig_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/V_rivwidth_hig_CLSM/V_pfaf_${pfaf}_rivwidth_hig_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate total volume based on river width samples: NOAH
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/rivwidth_sens/V_rivwidth_low_NOAH"
#mkdir -p "../output_test/rivwidth_sens/V_rivwidth_nrm_NOAH"
#mkdir -p "../output_test/rivwidth_sens/V_rivwidth_hig_NOAH"
#
#echo "- Calculate total river volume for river width samples: NOAH"
#../src/mws_rivwidth_V.py                                                       \
#    ../input/MeanDRS/Qout_NOAH/Qout_pfaf_${pfaf}_GLDAS_NOAH_M_1980-01_2009-12_utc.nc4\
#    ../input/MeanDRS/V_low_COR/V_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc_low.nc4\
#    ../input/MeanDRS/V_nrm_COR/V_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc_nrm.nc4\
#    ../input/MeanDRS/V_hig_COR/V_pfaf_${pfaf}_GLDAS_COR_M_1980-01_2009-12_utc_hig.nc4\
#    ../output_test/rivwidth_sens/V_rivwidth_low_NOAH/V_pfaf_${pfaf}_rivwidth_low_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/V_rivwidth_nrm_NOAH/V_pfaf_${pfaf}_rivwidth_nrm_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/V_rivwidth_hig_NOAH/V_pfaf_${pfaf}_rivwidth_hig_NOAH_wid.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing V_low river width file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/V_rivwidth_low_NOAH/V_pfaf_${pfaf}_rivwidth_low_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/V_rivwidth_low_NOAH/V_pfaf_${pfaf}_rivwidth_low_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing V_nrm river width file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/V_rivwidth_nrm_NOAH/V_pfaf_${pfaf}_rivwidth_nrm_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/V_rivwidth_nrm_NOAH/V_pfaf_${pfaf}_rivwidth_nrm_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing V_hig river width file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/V_rivwidth_hig_NOAH/V_pfaf_${pfaf}_rivwidth_hig_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/V_rivwidth_hig_NOAH/V_pfaf_${pfaf}_rivwidth_hig_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate total volume based on river width samples: ENS/ENS
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/cor_sens/V_rivwidth_low_ENS"
#mkdir -p "../output_test/cor_sens/V_rivwidth_nrm_ENS"
#mkdir -p "../output_test/cor_sens/V_rivwidth_hig_ENS"
#
#echo "- Calculate total river volume for river width samples: ENS"
#../src/mws_rivwidth_V.py                                                       \
#    ../input/MeanDRS/Qout_UNCOR/Qout_pfaf_${pfaf}_GLDAS_ENS_M_1980-01_2009-12_utc.nc4\
#    ../input/MeanDRS/V_low_UNCOR/V_pfaf_${pfaf}_GLDAS_ENS_M_1980-01_2009-12_utc_low.nc4\
#    ../input/MeanDRS/V_nrm_UNCOR/V_pfaf_${pfaf}_GLDAS_ENS_M_1980-01_2009-12_utc_nrm.nc4\
#    ../input/MeanDRS/V_hig_UNCOR/V_pfaf_${pfaf}_GLDAS_ENS_M_1980-01_2009-12_utc_hig.nc4\
#    ../output_test/cor_sens/V_rivwidth_low_ENS/V_pfaf_${pfaf}_rivwidth_low_ENS.csv\
#    ../output_test/cor_sens/V_rivwidth_nrm_ENS/V_pfaf_${pfaf}_rivwidth_nrm_ENS.csv\
#    ../output_test/cor_sens/V_rivwidth_hig_ENS/V_pfaf_${pfaf}_rivwidth_hig_ENS.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing V_low river width file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/V_rivwidth_low_ENS/V_pfaf_${pfaf}_rivwidth_low_ENS.csv\
#    ../output_test/cor_sens/V_rivwidth_low_ENS/V_pfaf_${pfaf}_rivwidth_low_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing V_nrm river width file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/V_rivwidth_nrm_ENS/V_pfaf_${pfaf}_rivwidth_nrm_ENS.csv\
#    ../output_test/cor_sens/V_rivwidth_nrm_ENS/V_pfaf_${pfaf}_rivwidth_nrm_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing V_hig river width file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/V_rivwidth_hig_ENS/V_pfaf_${pfaf}_rivwidth_hig_ENS.csv\
#    ../output_test/cor_sens/V_rivwidth_hig_ENS/V_pfaf_${pfaf}_rivwidth_hig_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Identify and trace rivers narrower than 100m draining to the ocean
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/smallest_rivs/cat"
#mkdir -p "../output_test/smallest_rivs/riv"
#
#echo "- Identifying and tracing narrow rivers draining to the ocean"
#../src/mws_smallest_rivs.py                                                    \
#    ../input/MeanDRS/rapid_connect/rapid_connect_pfaf_${pfaf}.csv              \
#    ../output/riv_coast/cor/riv_coast_pfaf_${pfaf}_COR.shp                     \
#    ../output/riv_coast/uncor/riv_coast_pfaf_${pfaf}_UNCOR.shp                 \
#    ../input/MeanDRS/riv_COR/riv_pfaf_${pfaf}_MERIT_Hydro_v07_Basins_v01_GLDAS_COR.shp\
#    ../input/MeanDRS/riv_UNCOR/riv_pfaf_${pfaf}_MERIT_Hydro_v07_Basins_v01_GLDAS_ENS.shp\
#    ../input/MB/cat/cat_pfaf_${pfaf}_MERIT_Hydro_v07_Basins_v01.shp            \
#    ../output_test/smallest_rivs/riv/riv_pfaf_${pfaf}_small_100m.shp           \
#    ../output_test/smallest_rivs/cat/cat_pfaf_${pfaf}_small_100m.shp           \
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing narrow coastal rivers traced reaches file (.shp)"
#../src/tst_cmp.py                                                              \
#    ../output/smallest_rivs/riv/riv_pfaf_${pfaf}_small_100m.shp                \
#    ../output_test/smallest_rivs/riv/riv_pfaf_${pfaf}_small_100m.shp           \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing narrow coastal rivers traced catchment file (.shp)"
#../src/tst_cmp.py                                                              \
#    ../output/smallest_rivs/cat/cat_pfaf_${pfaf}_small_100m.shp                \
#    ../output_test/smallest_rivs/cat/cat_pfaf_${pfaf}_small_100m.shp           \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate global summary terms for rivers narrower than 100m at coast
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/smallest_rivs/csv"
#
#echo "- Computing global summary for narrow coastal rivers"
#../src/mws_smallest_rivs_global.py                                             \
#    ../output/riv_coast/cor/                                                   \
#    ../output/riv_coast/uncor/                                                 \
#    ../output/smallest_rivs/cat/                                               \
#    ../output_test/smallest_rivs/csv/Q_wid_100m.csv                            \
#    ../output_test/global_summary/cat_small_gl/cat_dis_global_small_100m.shp   \
#    no_gl_dis                                                                  \
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global narrow coastal rivers reaches file (.shp)"
#../src/tst_cmp.py                                                              \
#    ../output/smallest_rivs/csv/Q_wid_100m.csv                                 \
#    ../output_test/smallest_rivs/csv/Q_wid_100m.csv                            \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Identify 10 largest river basins based on discharge to coastal outlet
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/largest_rivs/csv"
#
#echo "- Identifying 10 largest river basins"
#../src/mws_largest_rivs_rank.py                                                \
#    ../output/riv_coast/cor/                                                   \
#    ../output/riv_coast/uncor/                                                 \
#    ../input/MeanDRS/riv_COR/                                                  \
#    ../input/MeanDRS/riv_UNCOR/                                                \
#    ../input/MB/cat/                                                           \
#    ../output_test/largest_rivs/csv/Q_df_top10.csv                             \
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing largest river basin ranking file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/largest_rivs/csv/Q_df_top10.csv                                  \
#    ../output_test/largest_rivs/csv/Q_df_top10.csv                             \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Trace contributing reaches and catchments of largest river basins
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/largest_rivs/cat"
#mkdir -p "../output_test/largest_rivs/riv"
#
#echo "- Tracing contributing reaches and catchments of largest river basins"
#../src/mws_largest_rivs_trace.py                                               \
#    ../output/largest_rivs/csv/Q_df_top10.csv                                  \
#    ../input/MeanDRS/rapid_connect/                                            \
#    ../input/MeanDRS/riv_COR/                                                  \
#    ../input/MeanDRS/riv_UNCOR/                                                \
#    ../input/MB/cat/                                                           \
#    ${rank}                                                                    \
#    ../output_test/largest_rivs/riv/riv_top10_n${rank}.shp                     \
#    ../output_test/largest_rivs/cat/cat_top10_n${rank}.shp                     \
#    ../output_test/largest_rivs/cat/cat_dis_top10_n${rank}.shp                 \
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing largest river basin traced reaches file (.shp)"
#../src/tst_cmp.py                                                              \
#    ../output/largest_rivs/riv/riv_top10_n${rank}.shp                          \
#    ../output_test/largest_rivs/riv/riv_top10_n${rank}.shp                     \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing largest river basin traced catchment file (.shp)"
#../src/tst_cmp.py                                                              \
#    ../output/largest_rivs/cat/cat_top10_n${rank}.shp                          \
#    ../output_test/largest_rivs/cat/cat_top10_n${rank}.shp                     \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing largest river basin dissolved catchment file (.shp)"
#../src/tst_cmp.py                                                              \
#    ../output/largest_rivs/cat/cat_dis_top10_n${rank}.shp                      \
#    ../output_test/largest_rivs/cat/cat_dis_top10_n${rank}.shp                 \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate global summary terms for discharge to the ocean: ENS/COR
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/global_summary/Qout_rivwidth"
#
#echo "- Calculate global summary terms for discharge to the ocean"
#../src/mws_Q_summary.py                                                        \
#    ../output/Qout_rivwidth/                                                   \
#    ../output_test/global_summary/Qout_rivwidth/Qout_rivwidth_global.csv       \
#    ../output_test/global_summary/Qout_rivwidth/Qout_rivwidth_prop.csv         \
#    ../output_test/global_summary/Qout_rivwidth/Qout_std.csv                   \
#    ../output_test/global_summary/Qout_rivwidth/Qout_std_prop.csv              \
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout rivwidth file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/Qout_rivwidth/Qout_rivwidth_global.csv            \
#    ../output_test/global_summary/Qout_rivwidth/Qout_rivwidth_global.csv       \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout rivwidth proportion file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/Qout_rivwidth/Qout_rivwidth_prop.csv             \
#    ../output_test/global_summary/Qout_rivwidth/Qout_rivwidth_prop.csv         \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout standard dev. file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/Qout_rivwidth/Qout_std.csv                        \
#    ../output_test/global_summary/Qout_rivwidth/Qout_std.csv                   \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout standard dev. proportion file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/Qout_rivwidth/Qout_std_prop.csv                   \
#    ../output_test/global_summary/Qout_rivwidth/Qout_std_prop.csv              \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate global summary terms for discharge to the ocean: VIC
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/rivwidth_sens/global_summary_VIC/Qout_rivwidth"
#
#echo "- Calculate global summary terms for discharge to the ocean: VIC"
#../src/mws_Q_summary.py                                                        \
#    ../output/rivwidth_sens/Qout_rivwidth_VIC/                                 \
#    ../output_test/rivwidth_sens/global_summary_VIC/Qout_rivwidth/Qout_rivwidth_global_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/Qout_rivwidth/Qout_rivwidth_prop_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/Qout_rivwidth/Qout_std_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/Qout_rivwidth/Qout_std_prop_VIC_wid.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout rivwidth file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/Qout_rivwidth/Qout_rivwidth_global_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/Qout_rivwidth/Qout_rivwidth_global_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout rivwidth proportion file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/Qout_rivwidth/Qout_rivwidth_prop_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/Qout_rivwidth/Qout_rivwidth_prop_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout standard dev. file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/Qout_rivwidth/Qout_std_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/Qout_rivwidth/Qout_std_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout standard dev. proportion file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/Qout_rivwidth/Qout_std_prop_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/Qout_rivwidth/Qout_std_prop_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate global summary terms for discharge to the ocean: CLSM
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/rivwidth_sens/global_summary_CLSM/Qout_rivwidth"
#
#echo "- Calculate global summary terms for discharge to the ocean: CLSM"
#../src/mws_Q_summary.py                                                        \
#    ../output/rivwidth_sens/Qout_rivwidth_CLSM/                                \
#    ../output_test/rivwidth_sens/global_summary_CLSM/Qout_rivwidth/Qout_rivwidth_global_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/Qout_rivwidth/Qout_rivwidth_prop_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/Qout_rivwidth/Qout_std_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/Qout_rivwidth/Qout_std_prop_CLSM_wid.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout rivwidth file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/Qout_rivwidth/Qout_rivwidth_global_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/Qout_rivwidth/Qout_rivwidth_global_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout rivwidth proportion file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/Qout_rivwidth/Qout_rivwidth_prop_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/Qout_rivwidth/Qout_rivwidth_prop_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout standard dev. file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/Qout_rivwidth/Qout_std_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/Qout_rivwidth/Qout_std_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout standard dev. proportion file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/Qout_rivwidth/Qout_std_prop_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/Qout_rivwidth/Qout_std_prop_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate global summary terms for discharge to the ocean: NOAH
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/rivwidth_sens/global_summary_NOAH/Qout_rivwidth"
#
#echo "- Calculate global summary terms for discharge to the ocean: NOAH"
#../src/mws_Q_summary.py                                                        \
#    ../output/rivwidth_sens/Qout_rivwidth_NOAH/                                \
#    ../output_test/rivwidth_sens/global_summary_NOAH/Qout_rivwidth/Qout_rivwidth_global_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/Qout_rivwidth/Qout_rivwidth_prop_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/Qout_rivwidth/Qout_std_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/Qout_rivwidth/Qout_std_prop_NOAH_wid.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout rivwidth file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/Qout_rivwidth/Qout_rivwidth_global_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/Qout_rivwidth/Qout_rivwidth_global_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout rivwidth proportion file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/Qout_rivwidth/Qout_rivwidth_prop_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/Qout_rivwidth/Qout_rivwidth_prop_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout standard dev. file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/Qout_rivwidth/Qout_std_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/Qout_rivwidth/Qout_std_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout standard dev. proportion file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/Qout_rivwidth/Qout_std_prop_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/Qout_rivwidth/Qout_std_prop_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate global summary terms for discharge to the ocean: ENS/ENS
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/cor_sens/global_summary_ENS/Qout_rivwidth"
#
#echo "- Calculate global summary terms for discharge to the ocean: ENS"
#../src/mws_Q_summary.py                                                        \
#    ../output/cor_sens/Qout_rivwidth_ENS/                                      \
#    ../output_test/cor_sens/global_summary_ENS/Qout_rivwidth/Qout_rivwidth_global_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/Qout_rivwidth/Qout_rivwidth_prop_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/Qout_rivwidth/Qout_std_ENS.csv  \
#    ../output_test/cor_sens/global_summary_ENS/Qout_rivwidth/Qout_std_prop_ENS.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout rivwidth file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/Qout_rivwidth/Qout_rivwidth_global_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/Qout_rivwidth/Qout_rivwidth_global_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout rivwidth proportion file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/Qout_rivwidth/Qout_rivwidth_prop_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/Qout_rivwidth/Qout_rivwidth_prop_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout standard dev. file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/Qout_rivwidth/Qout_std_ENS.csv       \
#    ../output_test/cor_sens/global_summary_ENS/Qout_rivwidth/Qout_std_ENS.csv  \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global Qout standard dev. proportion file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/Qout_rivwidth/Qout_std_prop_ENS.csv  \
#    ../output_test/cor_sens/global_summary_ENS/Qout_rivwidth/Qout_std_prop_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate global summary terms for total river volume: ENS/COR
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/global_summary/V_rivwidth_low"
#mkdir -p "../output_test/global_summary/V_rivwidth_nrm"
#mkdir -p "../output_test/global_summary/V_rivwidth_hig"
#
#echo "- Calculate global summary terms for river volume"
#../src/mws_V_summary.py                                                        \
#    ../output/V_rivwidth_low/                                                  \
#    ../output/V_rivwidth_nrm/                                                  \
#    ../output/V_rivwidth_hig/                                                  \
#    ../output_test/global_summary/V_rivwidth_low/V_rivwidth_low_global.csv     \
#    ../output_test/global_summary/V_rivwidth_nrm/V_rivwidth_nrm_global.csv     \
#    ../output_test/global_summary/V_rivwidth_hig/V_rivwidth_hig_global.csv     \
#    ../output_test/global_summary/V_rivwidth_low/V_rivwidth_low_prop.csv       \
#    ../output_test/global_summary/V_rivwidth_nrm/V_rivwidth_nrm_prop.csv       \
#    ../output_test/global_summary/V_rivwidth_hig/V_rivwidth_hig_prop.csv       \
#    ../output_test/global_summary/V_rivwidth_low/V_low_std.csv                 \
#    ../output_test/global_summary/V_rivwidth_nrm/V_nrm_std.csv                 \
#    ../output_test/global_summary/V_rivwidth_hig/V_hig_std.csv                 \
#    ../output_test/global_summary/V_rivwidth_low/V_low_std_prop.csv            \
#    ../output_test/global_summary/V_rivwidth_nrm/V_nrm_std_prop.csv            \
#    ../output_test/global_summary/V_rivwidth_hig/V_hig_std_prop.csv            \
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low rivwidth file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/V_rivwidth_low/V_rivwidth_low_global.csv          \
#    ../output_test/global_summary/V_rivwidth_low/V_rivwidth_low_global.csv     \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm rivwidth file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/V_rivwidth_nrm/V_rivwidth_nrm_global.csv          \
#    ../output_test/global_summary/V_rivwidth_nrm/V_rivwidth_nrm_global.csv     \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig rivwidth file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/V_rivwidth_hig/V_rivwidth_hig_global.csv          \
#    ../output_test/global_summary/V_rivwidth_hig/V_rivwidth_hig_global.csv     \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low rivwidth proportion file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/V_rivwidth_low/V_rivwidth_low_prop.csv            \
#    ../output_test/global_summary/V_rivwidth_low/V_rivwidth_low_prop.csv       \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm rivwidth proportion file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/V_rivwidth_nrm/V_rivwidth_nrm_prop.csv            \
#    ../output_test/global_summary/V_rivwidth_nrm/V_rivwidth_nrm_prop.csv       \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig rivwidth proportion file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/V_rivwidth_hig/V_rivwidth_hig_prop.csv            \
#    ../output_test/global_summary/V_rivwidth_hig/V_rivwidth_hig_prop.csv       \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low standard dev. file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/V_rivwidth_low/V_low_std.csv                      \
#    ../output_test/global_summary/V_rivwidth_low/V_low_std.csv                 \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm standard dev. file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/V_rivwidth_nrm/V_nrm_std.csv                      \
#    ../output_test/global_summary/V_rivwidth_nrm/V_nrm_std.csv                 \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm standard dev. file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/V_rivwidth_hig/V_hig_std.csv                      \
#    ../output_test/global_summary/V_rivwidth_hig/V_hig_std.csv                 \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low standard dev. proportion file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/V_rivwidth_low/V_low_std_prop.csv                 \
#    ../output_test/global_summary/V_rivwidth_low/V_low_std_prop.csv            \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm standard dev. proportion file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/V_rivwidth_nrm/V_nrm_std_prop.csv                 \
#    ../output_test/global_summary/V_rivwidth_nrm/V_nrm_std_prop.csv            \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig standard dev. proportion file (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/global_summary/V_rivwidth_hig/V_hig_std_prop.csv                 \
#    ../output_test/global_summary/V_rivwidth_hig/V_hig_std_prop.csv            \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate global summary terms for total river volume: VIC
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_low"
#mkdir -p "../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_nrm"
#mkdir -p "../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_hig"
#
#echo "- Calculate global summary terms for river volume: VIC"
#../src/mws_V_summary.py                                                        \
#    ../output/rivwidth_sens/V_rivwidth_low_VIC/                                \
#    ../output/rivwidth_sens/V_rivwidth_nrm_VIC/                                \
#    ../output/rivwidth_sens/V_rivwidth_hig_VIC/                                \
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_low/V_rivwidth_low_global_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_nrm/V_rivwidth_nrm_global_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_hig/V_rivwidth_hig_global_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_low/V_rivwidth_low_prop_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_nrm/V_rivwidth_nrm_prop_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_hig/V_rivwidth_hig_prop_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_low/V_low_std_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_nrm/V_nrm_std_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_hig/V_hig_std_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_low/V_low_std_prop_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_nrm/V_nrm_std_prop_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_hig/V_hig_std_prop_VIC_wid.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low rivwidth file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/V_rivwidth_low/V_rivwidth_low_global_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_low/V_rivwidth_low_global_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm rivwidth file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/V_rivwidth_nrm/V_rivwidth_nrm_global_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_nrm/V_rivwidth_nrm_global_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig rivwidth file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/V_rivwidth_hig/V_rivwidth_hig_global_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_hig/V_rivwidth_hig_global_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low rivwidth proportion file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/V_rivwidth_low/V_rivwidth_low_prop_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_low/V_rivwidth_low_prop_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm rivwidth proportion file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/V_rivwidth_nrm/V_rivwidth_nrm_prop_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_nrm/V_rivwidth_nrm_prop_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig rivwidth proportion file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/V_rivwidth_hig/V_rivwidth_hig_prop_VIC_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_hig/V_rivwidth_hig_prop_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low standard dev. file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/V_rivwidth_low/V_low_std_VIC_wid.csv          \
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_low/V_low_std_VIC_wid.csv     \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm standard dev. file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/V_rivwidth_nrm/V_nrm_std_VIC_wid.csv          \
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_nrm/V_nrm_std_VIC_wid.csv     \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig standard dev. file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/V_rivwidth_hig/V_hig_std_VIC_wid.csv          \
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_hig/V_hig_std_VIC_wid.csv     \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low standard dev. proportion file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/V_rivwidth_low/V_low_std_prop_VIC_wid.csv     \
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_low/V_low_std_prop_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm standard dev. proportion file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/V_rivwidth_nrm/V_nrm_std_prop_VIC_wid.csv     \
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_nrm/V_nrm_std_prop_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig standard dev. proportion file: VIC (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_VIC/V_rivwidth_hig/V_hig_std_prop_VIC_wid.csv     \
#    ../output_test/rivwidth_sens/global_summary_VIC/V_rivwidth_hig/V_hig_std_prop_VIC_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate global summary terms for total river volume: CLSM
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_low"
#mkdir -p "../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_nrm"
#mkdir -p "../output_test/rivwidth_sens/global_summary_CLSM//V_rivwidth_hig"
#
#echo "- Calculate global summary terms for river volume: CLSM"
#../src/mws_V_summary.py                                                        \
#    ../output/rivwidth_sens/V_rivwidth_low_CLSM/                               \
#    ../output/rivwidth_sens/V_rivwidth_nrm_CLSM/                               \
#    ../output/rivwidth_sens/V_rivwidth_hig_CLSM/                               \
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_low/V_rivwidth_low_global_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_nrm/V_rivwidth_nrm_global_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_hig/V_rivwidth_hig_global_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_low/V_rivwidth_low_prop_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_nrm/V_rivwidth_nrm_prop_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_hig/V_rivwidth_hig_prop_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_low/V_low_std_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_nrm/V_nrm_std_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_hig/V_hig_std_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_low/V_low_std_prop_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_nrm/V_nrm_std_prop_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_hig/V_hig_std_prop_CLSM_wid.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low rivwidth file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/V_rivwidth_low/V_rivwidth_low_global_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_low/V_rivwidth_low_global_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm rivwidth file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/V_rivwidth_nrm/V_rivwidth_nrm_global_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_nrm/V_rivwidth_nrm_global_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig rivwidth file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/V_rivwidth_hig/V_rivwidth_hig_global_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_hig/V_rivwidth_hig_global_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low rivwidth proportion file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/V_rivwidth_low/V_rivwidth_low_prop_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_low/V_rivwidth_low_prop_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm rivwidth proportion file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/V_rivwidth_nrm/V_rivwidth_nrm_prop_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_nrm/V_rivwidth_nrm_prop_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig rivwidth proportion file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/V_rivwidth_hig/V_rivwidth_hig_prop_CLSM_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_hig/V_rivwidth_hig_prop_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low standard dev. file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/V_rivwidth_low/V_low_std_CLSM_wid.csv          \
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_low/V_low_std_CLSM_wid.csv     \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm standard dev. file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/V_rivwidth_nrm/V_nrm_std_CLSM_wid.csv          \
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_nrm/V_nrm_std_CLSM_wid.csv     \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig standard dev. file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/V_rivwidth_hig/V_hig_std_CLSM_wid.csv          \
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_hig/V_hig_std_CLSM_wid.csv     \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low standard dev. proportion file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/V_rivwidth_low/V_low_std_prop_CLSM_wid.csv     \
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_low/V_low_std_prop_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm standard dev. proportion file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/V_rivwidth_nrm/V_nrm_std_prop_CLSM_wid.csv     \
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_nrm/V_nrm_std_prop_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig standard dev. proportion file: CLSM (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_CLSM/V_rivwidth_hig/V_hig_std_prop_CLSM_wid.csv     \
#    ../output_test/rivwidth_sens/global_summary_CLSM/V_rivwidth_hig/V_hig_std_prop_CLSM_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate global summary terms for total river volume: NOAH
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_low"
#mkdir -p "../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_nrm"
#mkdir -p "../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_hig"
#
#echo "- Calculate global summary terms for river volume: NOAH"
#../src/mws_V_summary.py                                                        \
#    ../output/rivwidth_sens/V_rivwidth_low_NOAH/                               \
#    ../output/rivwidth_sens/V_rivwidth_nrm_NOAH/                               \
#    ../output/rivwidth_sens/V_rivwidth_hig_NOAH/                               \
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_low/V_rivwidth_low_global_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_nrm/V_rivwidth_nrm_global_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_hig/V_rivwidth_hig_global_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_low/V_rivwidth_low_prop_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_nrm/V_rivwidth_nrm_prop_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_hig/V_rivwidth_hig_prop_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_low/V_low_std_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_nrm/V_nrm_std_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_hig/V_hig_std_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_low/V_low_std_prop_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_nrm/V_nrm_std_prop_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_hig/V_hig_std_prop_NOAH_wid.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
##
#echo "- Comparing global V_low rivwidth file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/V_rivwidth_low/V_rivwidth_low_global_NOAH_wid.csv\
#    ../output_test/global_summary_NOAH/V_rivwidth_low/V_rivwidth_low_global_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm rivwidth file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/V_rivwidth_nrm/V_rivwidth_nrm_global_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_nrm/V_rivwidth_nrm_global_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig rivwidth file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/V_rivwidth_hig/V_rivwidth_hig_global_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_hig/V_rivwidth_hig_global_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low rivwidth proportion file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/V_rivwidth_low/V_rivwidth_low_prop_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_low/V_rivwidth_low_prop_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm rivwidth proportion file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/V_rivwidth_nrm/V_rivwidth_nrm_prop_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_nrm/V_rivwidth_nrm_prop_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig rivwidth proportion file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/V_rivwidth_hig/V_rivwidth_hig_prop_NOAH_wid.csv\
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_hig/V_rivwidth_hig_prop_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low standard dev. file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/V_rivwidth_low/V_low_std_NOAH_wid.csv          \
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_low/V_low_std_NOAH_wid.csv     \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm standard dev. file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/V_rivwidth_nrm/V_nrm_std_NOAH_wid.csv          \
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_nrm/V_nrm_std_NOAH_wid.csv     \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig standard dev. file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/V_rivwidth_hig/V_hig_std_NOAH_wid.csv          \
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_hig/V_hig_std_NOAH_wid.csv     \
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low standard dev. proportion file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/V_rivwidth_low/V_low_std_prop_NOAH_wid.csv     \
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_low/V_low_std_prop_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm standard dev. proportion file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/V_rivwidth_nrm/V_nrm_std_prop_NOAH_wid.csv     \
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_nrm/V_nrm_std_prop_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig standard dev. proportion file: NOAH (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/rivwidth_sens/global_summary_NOAH/V_rivwidth_hig/V_hig_std_prop_NOAH_wid.csv     \
#    ../output_test/rivwidth_sens/global_summary_NOAH/V_rivwidth_hig/V_hig_std_prop_NOAH_wid.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Calculate global summary terms for total river volume: ENS/ENS
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/cor_sens/global_summary_ENS/V_rivwidth_low"
#mkdir -p "../output_test/cor_sens/global_summary_ENS/V_rivwidth_nrm"
#mkdir -p "../output_test/cor_sens/global_summary_ENS/V_rivwidth_hig"
#
#echo "- Calculate global summary terms for river volume: ENS"
#../src/mws_V_summary.py                                                        \
#    ../output/cor_sens/V_rivwidth_low_ENS/                                     \
#    ../output/cor_sens/V_rivwidth_nrm_ENS/                                     \
#    ../output/cor_sens/V_rivwidth_hig_ENS/                                     \
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_low/V_rivwidth_low_global_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_nrm/V_rivwidth_nrm_global_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_hig/V_rivwidth_hig_global_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_low/V_rivwidth_low_prop_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_nrm/V_rivwidth_nrm_prop_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_hig/V_rivwidth_hig_prop_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_low/V_low_std_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_nrm/V_nrm_std_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_hig/V_hig_std_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_low/V_low_std_prop_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_nrm/V_nrm_std_prop_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_hig/V_hig_std_prop_ENS.csv\
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low rivwidth file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/V_rivwidth_low/V_rivwidth_low_global_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_low/V_rivwidth_low_global_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm rivwidth file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/V_rivwidth_nrm/V_rivwidth_nrm_global_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_nrm/V_rivwidth_nrm_global_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig rivwidth file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/V_rivwidth_hig/V_rivwidth_hig_global_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_hig/V_rivwidth_hig_global_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low rivwidth proportion file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/V_rivwidth_low/V_rivwidth_low_prop_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_low/V_rivwidth_low_prop_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm rivwidth proportion file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/V_rivwidth_nrm/V_rivwidth_nrm_prop_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_nrm/V_rivwidth_nrm_prop_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig rivwidth proportion file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/V_rivwidth_hig/V_rivwidth_hig_prop_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_hig/V_rivwidth_hig_prop_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low standard dev. file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/V_rivwidth_low/V_low_std_prop_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_low/V_low_std_prop_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm standard dev. file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/V_rivwidth_nrm/V_nrm_std_prop_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_nrm/V_nrm_std_prop_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm standard dev. file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/V_rivwidth_hig/V_hig_std_ENS.csv     \
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_hig/V_hig_std_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_low standard dev. proportion file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/V_rivwidth_low/V_low_std_prop_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_low/V_low_std_prop_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_nrm standard dev. proportion file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/V_rivwidth_nrm/V_nrm_std_prop_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_nrm/V_nrm_std_prop_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing global V_hig standard dev. proportion file: ENS (.csv)"
#../src/tst_cmp.py                                                              \
#    ../output/cor_sens/global_summary_ENS/V_rivwidth_hig/V_hig_std_prop_ENS.csv\
#    ../output_test/cor_sens/global_summary_ENS/V_rivwidth_hig/V_hig_std_prop_ENS.csv\
#    > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Produce visualizations: Main Figures
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/figures"
#
#echo "- Producing visualizations: Main Figures"
#../src/mws_plots.py                                                            \
#    ../input/MeanDRS/riv_UNCOR/                                                \
#    ../output/global_summary/Qout_rivwidth/Qout_rivwidth_prop.csv              \
#    ../output/global_summary/Qout_rivwidth/Qout_std_prop.csv                   \
#    ../output/Qout_rivwidth/                                                   \
#    ../output/global_summary/V_rivwidth_low/V_rivwidth_low_prop.csv            \
#    ../output/global_summary/V_rivwidth_nrm/V_rivwidth_nrm_prop.csv            \
#    ../output/global_summary/V_rivwidth_hig/V_rivwidth_hig_prop.csv            \
#    ../output/global_summary/V_rivwidth_low/V_low_std_prop.csv                 \
#    ../output/global_summary/V_rivwidth_nrm/V_nrm_std_prop.csv                 \
#    ../output/global_summary/V_rivwidth_hig/V_hig_std_prop.csv                 \
#    ../output/V_rivwidth_low/                                                  \
#    ../output/V_rivwidth_nrm/                                                  \
#    ../output/V_rivwidth_hig/                                                  \
#    ../output/smallest_rivs/csv/Q_wid_100m.csv                                 \
#    ../output/largest_rivs/csv/Q_df_top10.csv                                  \
#    ../output_test/figures/figure1_out.svg                                     \
#    ../output_test/figures/figure2a_out.svg                                    \
#    ../output_test/figures/figure2b_out.svg                                    \
#    ../output_test/figures/figure3_out.svg                                     \
#    ../output_test/figures/figure4_out.svg                                     \
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Produce visualizations: Supplemental 1
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/figures"
#
#echo "- Producing visualizations: Supplemental Figures Part 1"
#../src/mws_plots_supp1.py                                                      \
#    ../output/global_summary/Qout_rivwidth/Qout_rivwidth_prop.csv              \
#    ../output/global_summary/Qout_rivwidth/Qout_std_prop.csv                   \
#    ../output/rivwidth_sens/global_summary_VIC/Qout_rivwidth/Qout_rivwidth_prop_VIC_wid.csv\
#    ../output/rivwidth_sens/global_summary_VIC/Qout_rivwidth/Qout_std_prop_VIC_wid.csv\
#    ../output/rivwidth_sens/global_summary_CLSM/Qout_rivwidth/Qout_rivwidth_prop_CLSM_wid.csv\
#    ../output/rivwidth_sens/global_summary_CLSM/Qout_rivwidth/Qout_std_prop_CLSM_wid.csv\
#    ../output/rivwidth_sens/global_summary_NOAH/Qout_rivwidth/Qout_rivwidth_prop_NOAH_wid.csv\
#    ../output/rivwidth_sens/global_summary_NOAH/Qout_rivwidth/Qout_std_prop_NOAH_wid.csv\
#    ../output/global_summary/V_rivwidth_nrm/V_rivwidth_nrm_prop.csv            \
#    ../output/global_summary/V_rivwidth_nrm/V_nrm_std_prop.csv                 \
#    ../output/rivwidth_sens/global_summary_VIC/V_rivwidth_nrm/V_rivwidth_nrm_prop_VIC_wid.csv\
#    ../output/rivwidth_sens/global_summary_VIC/V_rivwidth_nrm/V_nrm_std_prop_VIC_wid.csv\
#    ../output/rivwidth_sens/global_summary_CLSM/V_rivwidth_nrm/V_rivwidth_nrm_prop_CLSM_wid.csv\
#    ../output/rivwidth_sens/global_summary_CLSM/V_rivwidth_nrm/V_nrm_std_prop_CLSM_wid.csv\
#    ../output/rivwidth_sens/global_summary_NOAH/V_rivwidth_nrm/V_rivwidth_nrm_prop_NOAH_wid.csv\
#    ../output/rivwidth_sens/global_summary_NOAH/V_rivwidth_nrm/V_nrm_std_prop_NOAH_wid.csv\
#    ../output_test/figures/figure_s1_out.svg                                   \
#    ../output_test/figures/figure_s2_out.svg                                   \
#    ../output_test/figures/figure_s3_out.svg                                   \
#    ../output_test/figures/figure_s4_out.svg                                   \
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*****************************************************************************
##Produce visualizations: Supplemental 2
##*****************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/$tot"
#
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#mkdir -p "../output_test/figures"
#
#echo "- Producing visualizations: Supplemental Figures Part 2"
#../src/mws_plots_supp2.py                                                      \
#    ../output/cor_sens/global_summary_ENS/Qout_rivwidth/Qout_rivwidth_prop_ENS.csv\
#    ../output/cor_sens/global_summary_ENS/Qout_rivwidth/Qout_std_prop_ENS.csv  \
#    ../output/cor_sens/global_summary_ENS/V_rivwidth_nrm/V_rivwidth_nrm_prop_ENS.csv\
#    ../output/cor_sens/global_summary_ENS/V_rivwidth_nrm/V_nrm_std_prop_ENS.csv\
#    ../output/global_summary/Qout_rivwidth/Qout_rivwidth_prop.csv              \
#    ../output/global_summary/Qout_rivwidth/Qout_std_prop.csv                   \
#    ../output/global_summary/V_rivwidth_nrm/V_rivwidth_nrm_prop.csv            \
#    ../output/global_summary/V_rivwidth_nrm/V_nrm_std_prop.csv                 \
#    ../output_test/figures/figure_s5_out.svg                                   \
#    ../output_test/figures/figure_s6_out.svg                                   \
#    ../output_test/figures/figure_s7_out.svg                                   \
#    ../output_test/figures/figure_s8_out.svg                                   \
#    > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
