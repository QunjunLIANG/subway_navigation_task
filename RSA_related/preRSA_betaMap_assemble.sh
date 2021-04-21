#!/bin/bash
########################
# 
# This script is used to merge the fmri data across subjects as a whole
# which fit in RSA analysis
#
# qunjun 2020/09/18
########################

# global environments
wkDir=`pwd`
fmriDir=/media/lqj/research_data/subway_fMRIprep/fMRI_data/derivatives/GLM/first_level_GLM3_remake/sub-xxxx/run-yyyy.feat/stats
sbjFile=${wkDir}/name_list
outDir_line=${wkDir}/searchlight/rawdata_line
outDir_lineDs=${wkDir}/searchlight/rawdata_lineDs

if [[ -e ${outDir_line} ]]; then
	echo "output directory existed, please check"
	exit 0
else
	mkdir -p ${outDir_line}
fi
if [[ -e ${outDir_lineDs}  ]]; then
	echo "output directory existed, please check"
	exit 0
else
	mkdir -p ${outDir_lineDs}
fi

# start working!
sbjList=`cat ${sbjFile}`
for sbj in ${sbjList}; do
	imgList_line=""
	imgList_lineDs=""
	for (( run = 1; run < 5; run++ )); do
		fmriDir_tmp=${fmriDir/xxxx/${sbj}}
		fmriDir_tmp=${fmriDir_tmp/yyyy/${run}}
		imgList_line="${imgList_line} ${fmriDir_tmp}/cope1 ${fmriDir_tmp}/cope2 ${fmriDir_tmp}/cope3 ${fmriDir_tmp}/cope4"
		imgList_lineDs="${imgList_lineDs} ${fmriDir_tmp}/cope5 ${fmriDir_tmp}/cope6 ${fmriDir_tmp}/cope7 ${fmriDir_tmp}/cope8"
	done
	fslmerge -t ${outDir_line}/sub-${sbj}_merge.nii.gz ${imgList_line}
	fslmerge -t ${outDir_lineDs}/sub-${sbj}_merge.nii.gz ${imgList_lineDs}
	echo "subject ${sbj} work finished!"
done
