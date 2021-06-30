%
clear all;

subList = 'sub_ID_match.txt';
outDir = './GCD_output_new/';
dcmDir = './Output_concate/';
model_core = '/DCM_two_models_m0001.mat';
model_distal = '/DCM_two_models_m0002.mat';
[sbjID, sbjBIDS] = textread(subList, '%s %s');

matlabbatch{1}.spm.dcm.bms.inference.dir = {outDir};

for s=1:length(sbjBIDS)
    matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{s}.dcmmat{1,1} = [dcmDir sbjBIDS{s} model_core];
    matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{s}.dcmmat{2,1} = [dcmDir sbjBIDS{s} model_distal];
end
matlabbatch{1}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{1}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{1}.spm.dcm.bms.inference.method = 'FFX';
matlabbatch{1}.spm.dcm.bms.inference.family_level.family_file = {''};
% matlabbatch{1}.spm.dcm.bms.inference.bma.bma_no = 0;
matlabbatch{1}.spm.dcm.bms.inference.bma.bma_yes.bma_famwin = 'famwin';
matlabbatch{1}.spm.dcm.bms.inference.verify_id=1;
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);

