% Global variable
wkDir = '/media/lqj/research_data/subway_fMRIprep/fMRI_data/derivatives/GLM/DCM_SPM';
subList = [wkDir, '/sub_ID_match.txt'];
glmDir = [wkDir, '/Output_concate'];
[sbjID, sbjName] = textread(subList, '%s %s');

% List of open inputs
for sbjInd = 1:length(sbjName)
    % start working!
    % Specific GLM model
    GLMmat = [glmDir '/' sbjName{sbjInd} '/SPM.mat'];
    matlabbatch = pipeline(GLMmat);
    spm_jobman('run', matlabbatch)
end

function matlabbatch = pipeline(designMat)
    maskAdjust = NaN;
    threhold = 1;
    % indicate the center of VOI
    dmPFC_loc = [6.61 6.58 58.3];
    lPMC_loc = [-26.9 -7.81 51.1];
    rPMC_loc = [30.59 -5.42 58.3];
    SPC_loc = [-34.15 -53.36 48.7];
    % START
    matlabbatch{1}.spm.util.voi.spmmat(1) = {designMat};
    matlabbatch{1}.spm.util.voi.adjust = maskAdjust;
    matlabbatch{1}.spm.util.voi.session = 1;
    matlabbatch{1}.spm.util.voi.name = 'dmPFC';
    matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat = {''};
    matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast = 3;
    % matlabbatch{1}.spm.util.voi.roi{1}.spm.conjunction = 1;
    matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh = threhold;
    matlabbatch{1}.spm.util.voi.roi{1}.spm.extent = 0;
    % matlabbatch{1}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{1}.spm.util.voi.roi{2}.sphere.centre = dmPFC_loc;
    matlabbatch{1}.spm.util.voi.roi{2}.sphere.radius = 4;
    matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
    matlabbatch{1}.spm.util.voi.expression = 'i1 & i2';
    matlabbatch{2}.spm.util.voi.spmmat(1) = {designMat};
    matlabbatch{2}.spm.util.voi.adjust = maskAdjust;
    matlabbatch{2}.spm.util.voi.session = 1;
    matlabbatch{2}.spm.util.voi.name = 'lPMC';
    matlabbatch{2}.spm.util.voi.roi{1}.spm.spmmat = {''};
    matlabbatch{2}.spm.util.voi.roi{1}.spm.contrast = 3;
    % matlabbatch{2}.spm.util.voi.roi{1}.spm.conjunction = 1;
    matlabbatch{2}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    matlabbatch{2}.spm.util.voi.roi{1}.spm.thresh = threhold;
    matlabbatch{2}.spm.util.voi.roi{1}.spm.extent = 0;
    % matlabbatch{2}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{2}.spm.util.voi.roi{2}.sphere.centre = lPMC_loc;
    matlabbatch{2}.spm.util.voi.roi{2}.sphere.radius = 4;
    matlabbatch{2}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
    matlabbatch{2}.spm.util.voi.expression = 'i1 & i2';
    matlabbatch{3}.spm.util.voi.spmmat(1) = {designMat};
    matlabbatch{3}.spm.util.voi.adjust = maskAdjust;
    matlabbatch{3}.spm.util.voi.session = 1;
    matlabbatch{3}.spm.util.voi.name = 'rPMC';
    matlabbatch{3}.spm.util.voi.roi{1}.spm.spmmat = {''};
    matlabbatch{3}.spm.util.voi.roi{1}.spm.contrast = 3;
    % matlabbatch{3}.spm.util.voi.roi{1}.spm.conjunction = 1;
    matlabbatch{3}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    matlabbatch{3}.spm.util.voi.roi{1}.spm.thresh = threhold;
    matlabbatch{3}.spm.util.voi.roi{1}.spm.extent = 0;
    % matlabbatch{3}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{3}.spm.util.voi.roi{2}.sphere.centre = rPMC_loc;
    matlabbatch{3}.spm.util.voi.roi{2}.sphere.radius = 4;
    matlabbatch{3}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
    matlabbatch{3}.spm.util.voi.expression = 'i1 & i2';
    matlabbatch{4}.spm.util.voi.spmmat(1) = {designMat};
    matlabbatch{4}.spm.util.voi.adjust = maskAdjust;
    matlabbatch{4}.spm.util.voi.session = 1;
    matlabbatch{4}.spm.util.voi.name = 'SPC';
    matlabbatch{4}.spm.util.voi.roi{1}.spm.spmmat = {''};
    matlabbatch{4}.spm.util.voi.roi{1}.spm.contrast = 3;
    % matlabbatch{4}.spm.util.voi.roi{1}.spm.conjunction = 1;
    matlabbatch{4}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    matlabbatch{4}.spm.util.voi.roi{1}.spm.thresh = threhold;
    matlabbatch{4}.spm.util.voi.roi{1}.spm.extent = 0;
    % matlabbatch{4}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{4}.spm.util.voi.roi{2}.sphere.centre = SPC_loc;
    matlabbatch{4}.spm.util.voi.roi{2}.sphere.radius = 4;
    matlabbatch{4}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
    matlabbatch{4}.spm.util.voi.expression = 'i1 & i2';
end