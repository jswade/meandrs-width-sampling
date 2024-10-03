#!/bin/bash
#*****************************************************************************
#tst_dwnl_Wade_etal_202xb.sh
#*****************************************************************************

#Purpose:
#This script downloads all testing pfaf region 11 files corresponding to:
#DOI: xx.xxxx/xxxxxxxxxxxx
#The files used are available from:
#DOI: 10.5281/zenodo.13381368
#The script returns the following exit codes
# - 0  if all downloads are successful
# - 22 if there was a conversion problem
# - 44 if one download is not successful
#Author:
#Jeffrey Wade, Cedric H. David, 2024.

#*****************************************************************************
#Publication message
#*****************************************************************************
echo "********************"
echo "Downloading files from:   https://doi.org/10.5281/zenodo.13381368"
echo "which correspond to   :   https://doi.org/xx.xxxx/xxxxxxxxxxxx"
echo "These files are under a CC BY-NC-SA 4.0 license."
echo "Please cite these two DOIs if using these files for your publications."
echo "********************"



#*****************************************************************************
#Download MeanDRS Width Sampling Zenodo Repository to /output/
#*****************************************************************************
echo "- Downloading MeanDRS Width Sampling repository"
#-----------------------------------------------------------------------------
#Download parameters
#-----------------------------------------------------------------------------
URL="https://zenodo.org/records/13381368/files"
folder="../output"
list=("riv_coast.zip"                                                          \
      "Qout_rivwidth.zip"                                                      \
      "V_rivwidth_low.zip"                                                     \
      "V_rivwidth_nrm.zip"                                                     \
      "V_rivwidth_hig.zip"                                                     \
      "largest_rivs.zip"                                                       \
      "smallest_rivs.zip"                                                      \
      "global_summary.zip"                                                     \
      "cor_sens.zip"                                                           \
      "rivwidth_sens.zip"                                                      \
      )

#-----------------------------------------------------------------------------
#Download process
#-----------------------------------------------------------------------------
mkdir -p $folder
for file in "${list[@]}"
do
    wget -nv -nc $URL/$file -P $folder
    if [ $? -gt 0 ] ; then echo "Problem downloading $file" >&2 ; exit 44 ; fi
    
#-----------------------------------------------------------------------------
#Extract files
#-----------------------------------------------------------------------------
    unzip -nq "${folder}/${file}" -d "${folder}/"
    if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
    
#-----------------------------------------------------------------------------
#Delete files from untested regions (all except pfaf 11)
#-----------------------------------------------------------------------------
    find "${folder}" -type f ! -name '*11*' ! -path '*/ms_region_overlap/*'   \
        -exec rm {} +
    if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done

echo "Success"
echo "********************"

#*****************************************************************************
#Done
#*****************************************************************************


#*****************************************************************************
#Download MeanDRS river files
#*****************************************************************************
echo "- Downloading MeanDRS files"
#-----------------------------------------------------------------------------
#Download parameters
#-----------------------------------------------------------------------------
URL="https://zenodo.org/records/10013744/files"
folder="../input/MeanDRS"
list=("riv_pfaf_ii_MERIT_Hydro_v07_Basins_v01_GLDAS_COR.zip" \
      "riv_pfaf_ii_MERIT_Hydro_v07_Basins_v01_GLDAS_ENS.zip" \
      "cat_pfaf_ii_MERIT_Hydro_v07_Basins_v01_disso.zip" \
      "V_pfaf_ii_GLDAS_COR_M_1980-01_2009-12_utc_low.zip" \
      "V_pfaf_ii_GLDAS_COR_M_1980-01_2009-12_utc_nrm.zip" \
      "V_pfaf_ii_GLDAS_COR_M_1980-01_2009-12_utc_hig.zip" \
      "V_pfaf_ii_GLDAS_ENS_M_1980-01_2009-12_utc_low.zip" \
      "V_pfaf_ii_GLDAS_ENS_M_1980-01_2009-12_utc_nrm.zip" \
      "V_pfaf_ii_GLDAS_ENS_M_1980-01_2009-12_utc_hig.zip" \
      "Qout_pfaf_ii_GLDAS_COR_M_1980-01_2009-12_utc.zip" \
      "Qout_pfaf_ii_GLDAS_ENS_M_1980-01_2009-12_utc.zip" \
      "Qout_pfaf_ii_GLDAS_CLSM_M_1980-01_2009-12_utc.zip" \
      "Qout_pfaf_ii_GLDAS_NOAH_M_1980-01_2009-12_utc.zip" \
      "Qout_pfaf_ii_GLDAS_VIC_M_1980-01_2009-12_utc.zip" \
      "rapid_connect_pfaf_ii.zip" \
      "cat_MERIT_Hydro_v07_Basins_v01_perim.zip" \
     )

#-----------------------------------------------------------------------------
#Download process
#-----------------------------------------------------------------------------
mkdir -p $folder
for file in "${list[@]}"
do
    wget -nv -nc $URL/$file -P $folder
    if [ $? -gt 0 ] ; then echo "Problem downloading $file" >&2 ; exit 44 ; fi

#-----------------------------------------------------------------------------
#Extract files
#-----------------------------------------------------------------------------
    unzip -nq "${folder}/${file}" -d "${folder}/${file%.zip}"
    if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

#-----------------------------------------------------------------------------
#Delete files from untested regions (all except pfaf 11)
#-----------------------------------------------------------------------------
    find "${folder}" -type f ! -name '*11*' ! -path \
        '*/cat_MERIT_Hydro_v07_Basins_v01_perim/*' -exec rm {} +
    if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

done

#-----------------------------------------------------------------------------
#Find regions missing from COR dataset
#-----------------------------------------------------------------------------
#Get complete list of regions
regs=$(ls "${folder}/${list[1]%.zip}" | cut -d '_' -f 3 | sort -u)

#Get list of COR regions
regs_cor=$(ls "${folder}/${list[0]%.zip}" | cut -d '_' -f 3 | sort -u)

#Find differences between lists
regs_miss=(`echo ${regs[@]} ${regs_cor[@]} | tr ' ' '\n' | sort | uniq -u`)

#-----------------------------------------------------------------------------
#Copy missing region files from ENS to COR: riv_pfaf_ii
#-----------------------------------------------------------------------------
for reg in ${regs_miss[@]}
do
    cp "${folder}/${list[1]%.zip}/"*${reg}* "${folder}/${list[0]%.zip}"
    if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done

#-----------------------------------------------------------------------------
#Rename moved files from ENS to COR: riv_pfaf_ii
#-----------------------------------------------------------------------------
for file in "${folder}/${list[0]%.zip}"/*ENS*
do
    new_fp=$(echo "${file}" | sed 's/ENS/COR/')
    mv "${file}" "${new_fp}"
    if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done

#-----------------------------------------------------------------------------
##Move files to new folders: riv_pfaf_ii
#-----------------------------------------------------------------------------
mkdir "${folder}/riv_COR"
mv "${folder}/${list[0]%.zip}/"*.* "${folder}/riv_COR"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

mkdir "${folder}/riv_UNCOR"
mv "${folder}/${list[1]%.zip}/"*.* "${folder}/riv_UNCOR"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

#-----------------------------------------------------------------------------
#Copy missing region files from ENS to COR: V_pfaf_ii_low
#-----------------------------------------------------------------------------
for reg in ${regs_miss[@]}
do
    cp "${folder}/${list[6]%.zip}/"*${reg}* "${folder}/${list[3]%.zip}"
    if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done

#-----------------------------------------------------------------------------
#Rename moved files from ENS to COR: V_pfaf_ii_low
#-----------------------------------------------------------------------------
for file in "${folder}/${list[3]%.zip}"/*ENS*
do
    new_fp=$(echo "${file}" | sed 's/ENS/COR/')
    mv "${file}" "${new_fp}"
    if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done

#-----------------------------------------------------------------------------
##Move files to new folders: V_pfaf_ii_low
#-----------------------------------------------------------------------------
mkdir "${folder}/V_low_COR"
mv "${folder}/${list[3]%.zip}/"*.* "${folder}/V_low_COR"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

mkdir "${folder}/V_low_UNCOR"
mv "${folder}/${list[6]%.zip}/"*.* "${folder}/V_low_UNCOR"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

#-----------------------------------------------------------------------------
#Copy missing region files from ENS to COR: V_pfaf_ii_nrm
#-----------------------------------------------------------------------------
for reg in ${regs_miss[@]}
do
    cp "${folder}/${list[7]%.zip}/"*${reg}* "${folder}/${list[4]%.zip}"
    if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done

#-----------------------------------------------------------------------------
#Rename moved files from ENS to COR: V_pfaf_ii_nrm
#-----------------------------------------------------------------------------
for file in "${folder}/${list[4]%.zip}"/*ENS*
do
    new_fp=$(echo "${file}" | sed 's/ENS/COR/')
    mv "${file}" "${new_fp}"
    if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done

#-----------------------------------------------------------------------------
##Move files to new folders: V_pfaf_ii_nrm
#-----------------------------------------------------------------------------
mkdir "${folder}/V_nrm_COR"
mv "${folder}/${list[4]%.zip}/"*.* "${folder}/V_nrm_COR"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

mkdir "${folder}/V_nrm_UNCOR"
mv "${folder}/${list[7]%.zip}/"*.* "${folder}/V_nrm_UNCOR"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

#-----------------------------------------------------------------------------
#Copy missing region files from ENS to COR: V_pfaf_ii_hig
#-----------------------------------------------------------------------------
for reg in ${regs_miss[@]}
do
    cp "${folder}/${list[8]%.zip}/"*${reg}* "${folder}/${list[5]%.zip}"
    if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done

#-----------------------------------------------------------------------------
#Rename moved files from ENS to COR: V_pfaf_ii_hig
#-----------------------------------------------------------------------------
for file in "${folder}/${list[5]%.zip}"/*ENS*
do
    new_fp=$(echo "${file}" | sed 's/ENS/COR/')
    mv "${file}" "${new_fp}"
    if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done

#-----------------------------------------------------------------------------
##Move files to new folders: V_pfaf_ii_hig
#-----------------------------------------------------------------------------
mkdir "${folder}/V_hig_COR"
mv "${folder}/${list[5]%.zip}/"*.* "${folder}/V_hig_COR"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

mkdir "${folder}/V_hig_UNCOR"
mv "${folder}/${list[8]%.zip}/"*.* "${folder}/V_hig_UNCOR"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

#-----------------------------------------------------------------------------
#Copy missing region files from ENS to COR: Qout_pfaf_ii
#-----------------------------------------------------------------------------
for reg in ${regs_miss[@]}
do
    cp "${folder}/${list[10]%.zip}/"*${reg}* "${folder}/${list[9]%.zip}"
    if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done

#-----------------------------------------------------------------------------
#Rename moved files from ENS to COR: Qout_pfaf_ii
#-----------------------------------------------------------------------------
for file in "${folder}/${list[9]%.zip}"/*ENS*
do
    new_fp=$(echo "${file}" | sed 's/ENS/COR/')
    mv "${file}" "${new_fp}"
    if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done

#-----------------------------------------------------------------------------
##Move files to new folders: Qout_pfaf_ii
#-----------------------------------------------------------------------------
mkdir "${folder}/Qout_COR"
mv "${folder}/${list[9]%.zip}/"*.* "${folder}/Qout_COR"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

mkdir "${folder}/Qout_UNCOR"
mv "${folder}/${list[10]%.zip}/"*.* "${folder}/Qout_UNCOR"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

mkdir "${folder}/Qout_CLSM"
mv "${folder}/${list[11]%.zip}/"*.* "${folder}/Qout_CLSM"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

mkdir "${folder}/Qout_NOAH"
mv "${folder}/${list[12]%.zip}/"*.* "${folder}/Qout_NOAH"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

mkdir "${folder}/Qout_VIC"
mv "${folder}/${list[13]%.zip}/"*.* "${folder}/Qout_VIC"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

#-----------------------------------------------------------------------------
##Move files to new folders: cat_pfaf_ii
#-----------------------------------------------------------------------------
mkdir "${folder}/cat_disso"
mv "${folder}/${list[2]%.zip}/"*.* "${folder}/cat_disso"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

#-----------------------------------------------------------------------------
##Move files to new folders: rapid_connect_pfaf_ii
#-----------------------------------------------------------------------------
mkdir "${folder}/rapid_connect"
mv "${folder}/${list[14]%.zip}/"*.* "${folder}/rapid_connect"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

#-----------------------------------------------------------------------------
##Move files to new folders: global_perim
#-----------------------------------------------------------------------------
mkdir "${folder}/global_perim"
mv "${folder}/${list[15]%.zip}/"*.* "${folder}/global_perim"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

echo "Success"
echo "********************"

#-----------------------------------------------------------------------------
#Remove original files
#-----------------------------------------------------------------------------
for file in "${list[@]}"
do
    rm -rf "${folder}/${file%.zip}"
    if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done


#*****************************************************************************
#Done
#*****************************************************************************


#*****************************************************************************
#Download MERIT-Basins files
#*****************************************************************************
echo "- Downloading MERIT-Basins files"
#-----------------------------------------------------------------------------
#Download parameters from Google Drive
#-----------------------------------------------------------------------------
# Embedded Folder View shows all 61 files, rather than the 50 limited by G.D.
URL="https://drive.google.com/embeddedfolderview?id=1nXMgbDjLLtB9XPwfVCLcF_0"\
"vlYS2M3wy"
folder="../input/MB"

mkdir -p $folder

#Retrieve HTML from Google Drive file view
wget -q -O "${folder}/temphtml" "$URL"
if [ $? -gt 0 ] ; then echo "Problem downloading MERIT-Basins" >&2 ; exit 44 ; fi

#Scrape download id and name for each file from HTML
idlist=($(grep -o '<div class="flip-entry" id="entry-[0-9a-zA-Z_-]*"'         \
    "${folder}/temphtml" | sed 's/^.*id="entry-\([0-9a-zA-Z_-]*\)".*$/\1/'))
if [ $? -gt 0 ] ; then echo "Problem downloading MERIT-Basins" >&2 ; exit 44 ; fi

filelist=($(grep -o '"flip-entry-title">[^<]*<' "${folder}/temphtml" |        \
    sed 's/"flip-entry-title">//; s/<$//'))
if [ $? -gt 0 ] ; then echo "Problem downloading MERIT-Basins" >&2 ; exit 44 ; fi

#Check if lists have same length
if [ ${#filelist[@]} -ne ${#idlist[@]} ]; then echo "Problem downloading MERIT-Basins"\
    >&2 ; exit 44 ; fi

rm "${folder}/temphtml"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

#-----------------------------------------------------------------------------
#Download process, bypassing Google Drive download warning using cookies
#-----------------------------------------------------------------------------

#Download files for pfaf 11
file="${filelist[0]}"
id="${idlist[0]}"

#Save uuid value from server for authentication
wget "https://docs.google.com/uc?export=download&id=1z-l1ICC7X4iKy0vd7FkT5X4u8Ie2l3sy" -O- | sed -rn 's/.*name="uuid" value=\"([0-9A-Za-z_\-]+).*/\1/p' > "${folder}/google_uuid.txt"
if [ $? -gt 0 ] ; then echo "Problem downloading $file" >&2 ; exit 44 ; fi

#Download file from server using uuid value
wget -O "${folder}/$file" "https://drive.usercontent.google.com/download?export=download&id=${id}&confirm=t&uuid=$(<"${folder}/google_uuid.txt")"

rm "${folder}/google_uuid.txt"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

#-----------------------------------------------------------------------------
#Extract files
#-----------------------------------------------------------------------------
unzip -nq "${folder}/$file" -d "${folder}/${filename%.zip}"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

#-----------------------------------------------------------------------------
#Delete zip files
#-----------------------------------------------------------------------------
rm "${folder}/$file"
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

#-----------------------------------------------------------------------------
#Organize files by type (riv and cat)
#-----------------------------------------------------------------------------
mkdir -p "$folder/cat"
mkdir -p "$folder/riv"

#Move all files beginning with cat
for file in "${folder}/cat"*
do
    #Confirm file exists and is regular
    if [ -f "$file" ]; then
        mv "$file" "$folder/cat/"
        if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
    fi
done

#Move all files beginning with riv
for file in "${folder}/riv"*
do
    #Confirm file exists and is regular
    if [ -f "$file" ]; then
        mv "$file" "$folder/riv/"
        if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
    fi
done

# Remove riv files
rm -rf "$folder/riv"

echo "Success"
echo "********************"

#*****************************************************************************
#Done
#*****************************************************************************
