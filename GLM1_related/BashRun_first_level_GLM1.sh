#!/bin/bash
############################
# global environment 
# 
# modifying the path BY YOURSELF!
#############################
FSLDIR=/usr/local/fsl
wkDir=`pwd`
outDir=${wkDir}/first_level_GLM1
timePointPath=${wkDir}/TimePointExtraction_GLM1
sbjNameListFile_opt=${timePointPath}/subject_opt.txt
sbjNameListFile_subopt=${timePointPath}/subject_subopt1.txt
designFile_opt=${wkDir}/1_GLM_design/GLM1_example_design_optimal3.fsf
designFile_subopt=${wkDir}/1_GLM_design/GLM1_example_design_suboptimal3.fsf
useOpt=no # use all-optimal or suboptimal trials
# File requirements
## fmri Data
fmriFile=${wkDir}/func_masked_smooth_denoised_highpass/xxxx_run-yyyy.nii.gz
## confound file
confoundFile=${wkDir}/ICA_confound_filtered/xxxx_run-yyyy_confound-filtered.txt
#############################
# regressors setting
#
# modifying and check the path and
# modifying the number of EVs and
# modifying the EV list BY YOURSELF
#############################
### indicating and ordering the EVs 
### !!!please put the suboptimal journey in the least EV!!! 
EV1_TP=${timePointPath}/cue_screen/xxxx_scanyyyy_cuescreen.txt
EV2_TP=${timePointPath}/feedback_screen/xxxx_scanyyyy_feedbackscreen.txt
EV3_TP=${timePointPath}/line_change/xxxx_scanyyyy_line_change.txt
EV4_TP=${timePointPath}/stay_exchange/xxxx_scanyyyy_stay_exchange.txt
EV5_TP=${timePointPath}/elbow_station/xxxx_scanyyyy_elbow.txt
EV6_TP=${timePointPath}/stay_regular_Ori/xxxx_scanyyyy_stay_regular_ori.txt
EV7_TP=${timePointPath}/stay_regular_Ds/xxxx_scanyyyy_stay_regular_Ds.txt
EV8_TP=${timePointPath}/stay_regular_Dl/xxxx_scanyyyy_stay_regular_Dl.txt
EV9_TP=${timePointPath}/stay_regular_Dx/xxxx_scanyyyy_stay_regular_Dx.txt
EV10_TP=${timePointPath}/stay_regular_Du/xxxx_scanyyyy_stay_regular_Du.txt
EV11_TP=${timePointPath}/subopt_navigation/xxxx_scanyyyy_suboptnavi.txt
## set a list data for easy loopping
if [[ ${useOpt} = "yes" ]]; then
	EVlist=($EV1_TP $EV2_TP $EV3_TP $EV4_TP $EV5_TP $EV6_TP $EV7_TP $EV8_TP $EV9_TP $EV10_TP)
else
	EVlist=($EV1_TP $EV2_TP $EV3_TP $EV4_TP $EV5_TP $EV6_TP $EV7_TP $EV8_TP $EV9_TP $EV10_TP $EV11_TP)
fi
##############################
# Pre-stage
# output directory insurrance
# analysis data use indication
# subjects' name log-in
# DON'T modify anything in this part
##############################
# insurrance the output directory is avilable--------------------
if [[ -e ${outDir} ]]; then
	echo "directory existed"
else
	mkdir -p ${outDir}
fi
# shape the subject name and design file depending on opt/EV11_TP--------------------
if [[ ${useOpt} = "yes" ]]; then
	sbjNameListFile=${sbjNameListFile_opt}
	designFile=${designFile_opt}
	echo "design file is ${designFile}"
else
	sbjNameListFile=${sbjNameListFile_subopt}
	designFile=${designFile_subopt}
	echo "design file is ${designFile}"
fi
# load subject's name_list ---------------------------------
sbjNameList=(`cat ${sbjNameListFile} | awk '{print $1}'`)
runList=(`cat ${sbjNameListFile} | awk '{print $2}'`)
nameLength=`echo ${#sbjNameList[@]}`
############################
# work phase
# 
# DON'T modify anything in this part
############################
for (( i = 0; i < ${nameLength}; i++ )); do
	sbjName_tmp=sub-${sbjNameList[${i}]}
	runName_tmp=${runList[${i}]}
	outDir_tmp=${outDir}/${sbjName_tmp}
	# shape the output directory
	if [[ -e ${outDir_tmp} ]]; then
		echo "subject ${sbjName_tmp}"
	else
		mkdir -p ${outDir_tmp}
	fi
	# indicating the output of .feat
	outDir_run_tmp=${outDir_tmp}/run-${runName_tmp}
	# indicating the fmri data
	fmriImg_tmp=${fmriFile/xxxx/${sbjName_tmp}}
	fmriImg_tmp=${fmriImg_tmp/yyyy/${runName_tmp}}
	# dealing with the confound file
	## indicating the file
	confound_tmp=${confoundFile/xxxx/${sbjName_tmp}}
	confound_tmp=${confound_tmp/xxxx/${sbjName_tmp}}
	confound_tmp=${confound_tmp/yyyy/${runName_tmp}}
	## copy to the subject directory and change its name
	cp ${confound_tmp} ${outDir_tmp}/${sbjName_tmp}_run${runName_tmp}_confound.tsv 
	confound_tmp=${outDir_tmp}/${sbjName_tmp}_run${runName_tmp}_confound.tsv
	# creat a new EVlist_tmp for specific subject-run
	for EVind in $(seq 0 $((${#EVlist[@]}-1))); do
		EV_tmp=${EVlist[EVind]}
		EV_tmp=${EV_tmp/xxxx/${sbjName_tmp}}
		EV_tmp=${EV_tmp/yyyy/${runName_tmp}}
		EVlist_tmp[EVind]=${EV_tmp}
	done
	# modifying the design File (.fsf)
	# copy the design file (.fsf) named by the oder of runs
	cp ${designFile} ${outDir_tmp}/${sbjName_tmp}_run-${runName_tmp}_design.fsf
	designFile_tmp=${outDir_tmp}/${sbjName_tmp}_run-${runName_tmp}_design.fsf
	## changing output directory
	sed -i "33c set fmri(outputdir) \"${outDir_run_tmp}\"" ${designFile_tmp}
	## changing total volumes
	vol_tmp=`fslnvols ${fmriImg_tmp}`
	sed -i "39c set fmri(npts) ${vol_tmp}" ${designFile_tmp}
	## changing input image
	sed -i "276c set feat_files(1) \"${fmriImg_tmp}\"" ${designFile_tmp}
	## changing input confound
	sed -i "282c set confoundev_files(1) \"${confound_tmp}\"" ${designFile_tmp}
	# indicating those EV left
	for evInd in $(seq 0 $((${#EVlist_tmp[@]}-1))); do
		evOrder=$(($evInd+1))
		text_row=`grep -n "set fmri(custom${evOrder})" ${designFile_tmp}`
		text_row=${text_row%%:*} # find the row number that need to fixed
		sed -i "${text_row}c set fmri(custom${evOrder}) \"${EVlist_tmp[$evInd]}\"" ${designFile_tmp}
	done
	## running first level GLM
	feat ${designFile_tmp}
	# creating a reg directory and copy some necessary files into this directory
	## it's indeed useful for further high order analysis !!!!
	mkdir -p ${outDir_run_tmp}.feat/reg
	cp ${outDir_run_tmp}.feat/mean_func.nii.gz ${outDir_run_tmp}.feat/reg/standard.nii.gz
	cp ${FSLDIR}/etc/flirtsch/ident.mat ${outDir_run_tmp}.feat/reg/example_func2standard.mat
done
