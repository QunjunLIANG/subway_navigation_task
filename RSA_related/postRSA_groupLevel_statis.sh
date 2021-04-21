#!/bin/bash

# global environment 
wkDir=/media/lqj/research_data/subway_fMRIprep/fMRI_data/derivatives/GLM/GLM3_RSA/searchlight
inputImg=${wkDir}/Fisher_result_wholebrain_lineDs_design1
outDir=${wkDir}/postRSA_result_lineDs_design1
brainMask=${wkDir}/gre_mask_flirt_bin.nii.gz
matchPattern=*searchlight_fz.nii.gz
chanceLevel=0.25
smoothImg=yes
smoothFWHM=6
# generating the output directory
if [[ -e ${outDir} ]]; then
	echo "Directory existed!"
	exit 0
else
	mkdir -p ${outDir}
fi
########################################
# Patr 1
# Smooth the input images
########################################
if [[ ${smoothImg} == "yes" ]]; then
	for imgInd in `ls ${inputImg}/${matchPattern}`; do
		echo `basename -s .nii.gz ${imgInd##*/}`
		# smoothing image
		## calculating the FWHM input by divide guassian kernel (2.33)
		echo "calculating the parameters"
		fwhmUse=`echo "scale=8; ${smoothFWHM}/2.355" |bc`
		## calculating the robust intensity
		rbInten=`fslstats ${imgInd} -p 2 -p 98 | awk '{print "10k " $2 " " $1 " - 10 / p "}' | dc -`
		echo "robust intensity = ${rbInten}"
		## creating a mask and calculating the median intensity within mask
		fslmaths ${imgInd} -thr ${rbInten} -Tmin -bin ${outDir}/tmp_mask_rbInten -odt char
		mask=${outDir}/tmp_mask_rbInten
		medianInt=`fslstats ${imgInd} -k ${mask} -p 50`
		medianInt=`echo "scale=10; ${medianInt}*0.75" | bc`
		echo ${medianInt}
		## masking the fmri data
		echo "creating mask"
		fslmaths ${mask} -dilF ${mask}
		fslmaths ${imgInd} -mas ${mask} ${outDir}/tmp_func_masked
		fmriData=${outDir}/tmp_func_masked # change the indication of fmriData
		## reduce func's time series
		fslmaths ${fmriData} -Tmean ${outDir}/tmp_func_masked_mean
		fmriMean=${outDir}/tmp_func_masked_mean
		## smoothing by susan
		echo "calling susan"
		susan ${fmriData} ${medianInt} ${fwhmUse} 3 1 1 ${fmriMean} ${medianInt} ${outDir}/tmp_func_masked_smooth
		fmriData=${outDir}/tmp_func_masked_smooth
		## masking smooth image
		fslmaths ${fmriData} -mas ${mask} ${fmriData}
		## rename the final image
		fslmaths ${outDir}/tmp_func_masked_smooth ${outDir}/`basename -s .nii.gz ${imgInd##*/}`_smooth
		# smoothing finished, free the space
		rm ${outDir}/tmp*
	done
	echo "Part 1 finished!"
fi
########################################
# Patr 2
# Merge data after RSA
########################################
fileList=""
for fileInd in `ls ${outDir}/*smooth.nii.gz`; do
	fileList="${fileList} ${fileInd}"
done
fslmerge -t ${outDir}/Merge_data.nii.gz ${fileList}
echo "Part 1 finished!"
#######################################
# Part 3
# One sample t test with the merge data
#######################################
randomise -i ${outDir}/Merge_data.nii.gz -o ${outDir}/OneSampleT -1 -x --uncorrp -m ${brainMask} | tee ${outDir}/fwe_log.txt
randomise -i ${outDir}/Merge_data.nii.gz -o ${outDir}/OneSampleT -1 -T --uncorrp -m ${brainMask}| tee ${outDir}/tfce_log.txt
fdr -i ${outDir}/OneSampleT_vox_p_tstat1 --oneminusp -m ${brainMask} -q 0.05 --othresh=${outDir}/OneSampleT_FDR
echo "Part 2 finished!"

