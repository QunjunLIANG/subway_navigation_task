% Global variable
wkDir = '/media/lqj/research_data/subway_fMRIprep/fMRI_data/derivatives/GLM/DCM_SPM';
subList = [wkDir, '/sub_ID_match.txt'];
outDir = [wkDir, '/Output_concate'];
imgDir = [wkDir, '/rawData_concate'];
condDir = [wkDir, '/conditions_concate'];
confDir = [wkDir, '/confounds_concate'];
hdDir = [wkDir, '/hd_concate'];
[sbjID, sbjName] = textread(subList, '%s %s');

% List of open inputs
for sbjInd = 1:length(sbjName)
    % continue the analysis
    if exist([outDir '/' sbjName{sbjInd}],  'dir')
        continue
    end
    % start working!
    % Specific GLM model
     matlabbatch_1 = pipelinePre(sbjName{sbjInd}, imgDir, condDir, confDir, outDir);
     spm_jobman('run', matlabbatch_1)
    % Session concatnate
    [hd1, hd2, hd3, hd4] = textread([hdDir '/' sbjName{sbjInd} '.txt'], '%d %d %d %d');
    scans = [hd1, hd2, hd3, hd4];
    spm_fmri_concatenate([outDir '/' sbjName{sbjInd} '/SPM.mat'], scans);
    % Estimate GLM model
     matlabbatch_2 = pipelinePos(sbjName{sbjInd}, outDir);
     spm_jobman('run', matlabbatch_2)
end

function matlabbatch = pipelinePre(subID, imgDir, condDir, confDir, outDir)
    %-----------------------------------------------------------------------
    % Variable inital
    %-----------------------------------------------------------------------    
    % subject-run image
    img = [imgDir '/' subID '.nii'];
    % subject-run confounds
    cond = [condDir '/' subID '.mat'];
    % subject-run confounds
    conf = [confDir '/' subID '.txt'];
    %-----------------------------------------------------------------------
    % Job saved on 04-Jun-2021 20:16:41 by cfg_util (rev $Rev: 7345 $)
    % spm SPM - SPM12 (7771)
    % cfg_basicio BasicIO - Unknown
    %-----------------------------------------------------------------------
    matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {outDir};
    matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = subID;
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'img_condition_confound';
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {
                                                                         {img}
                                                                         {cond}
                                                                         {conf}
                                                                         }';
    matlabbatch{3}.spm.stats.fmri_spec.dir(1) = cfg_dep('Make Directory: Make Directory ''Output_concate''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
    matlabbatch{3}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{3}.spm.stats.fmri_spec.timing.RT = 1.2;
    matlabbatch{3}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{3}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    matlabbatch{3}.spm.stats.fmri_spec.sess.scans(1) = cfg_dep('Named File Selector: img_condition_confound(1) - Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{3}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{3}.spm.stats.fmri_spec.sess.multi(1) = cfg_dep('Named File Selector: img_condition_confound(2) - Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{2}));
    matlabbatch{3}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{3}.spm.stats.fmri_spec.sess.multi_reg(1) = cfg_dep('Named File Selector: img_condition_confound(3) - Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{3}));
    matlabbatch{3}.spm.stats.fmri_spec.sess.hpf = 128;
    matlabbatch{3}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{3}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{3}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{3}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{3}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{3}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{3}.spm.stats.fmri_spec.cvi = 'AR(1)';
end

function matlabbatch = pipelinePos(subID, outDir)
    % settings
    maskAdjust = 3;
    % indicate the center of VOI
    dmPFC_loc = [6.61 6.58 58.3];
    lPMC_loc = [-26.9 -7.81 51.1];
    rPMC_loc = [30.59 -5.42 58.3];
    SPC_loc = [-34.15 -53.36 48.7];
    %-----------------------------------------------------------------------
    % Job saved on 04-Jun-2021 20:52:58 by cfg_util (rev $Rev: 7345 $)
    % spm SPM - SPM12 (7771)
    % cfg_basicio BasicIO - Unknown
    %-----------------------------------------------------------------------
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'DesignFile';
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {{[outDir '/' subID '/SPM.mat']}};
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Named File Selector: DesignFile(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = 'Effects of Interest';
    %%
    matlabbatch{3}.spm.stats.con.consess{1}.fcon.weights = [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    %%
    matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep = 'replsc';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Ds';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 1];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'replsc';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Dl';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 0 1];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'replsc';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Dx';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 1];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'replsc';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Du';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 1];
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'replsc';
    matlabbatch{3}.spm.stats.con.delete = 0;
    matlabbatch{4}.spm.util.voi.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{4}.spm.util.voi.adjust = maskAdjust;
    matlabbatch{4}.spm.util.voi.session = 1;
    matlabbatch{4}.spm.util.voi.name = 'dmPFC';
    matlabbatch{4}.spm.util.voi.roi{1}.spm.spmmat = {''};
    matlabbatch{4}.spm.util.voi.roi{1}.spm.contrast = 3;
    % matlabbatch{4}.spm.util.voi.roi{1}.spm.conjunction = 1;
    matlabbatch{4}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    matlabbatch{4}.spm.util.voi.roi{1}.spm.thresh = 0.05;
    matlabbatch{4}.spm.util.voi.roi{1}.spm.extent = 0;
    % matlabbatch{4}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{4}.spm.util.voi.roi{2}.sphere.centre = dmPFC_loc;
    matlabbatch{4}.spm.util.voi.roi{2}.sphere.radius = 4;
    matlabbatch{4}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
    matlabbatch{4}.spm.util.voi.expression = 'i1 & i2';
    matlabbatch{5}.spm.util.voi.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{5}.spm.util.voi.adjust = maskAdjust;
    matlabbatch{5}.spm.util.voi.session = 1;
    matlabbatch{5}.spm.util.voi.name = 'lPMC';
    matlabbatch{5}.spm.util.voi.roi{1}.spm.spmmat = {''};
    matlabbatch{5}.spm.util.voi.roi{1}.spm.contrast = 3;
    % matlabbatch{5}.spm.util.voi.roi{1}.spm.conjunction = 1;
    matlabbatch{5}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    matlabbatch{5}.spm.util.voi.roi{1}.spm.thresh = 0.05;
    matlabbatch{5}.spm.util.voi.roi{1}.spm.extent = 0;
    % matlabbatch{5}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{5}.spm.util.voi.roi{2}.sphere.centre = [-26.9 -7.81 51.1];
    matlabbatch{5}.spm.util.voi.roi{2}.sphere.radius = 4;
    matlabbatch{5}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
    matlabbatch{5}.spm.util.voi.expression = 'i1 & i2';
    matlabbatch{6}.spm.util.voi.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{6}.spm.util.voi.adjust = maskAdjust;
    matlabbatch{6}.spm.util.voi.session = 1;
    matlabbatch{6}.spm.util.voi.name = 'rPMC';
    matlabbatch{6}.spm.util.voi.roi{1}.spm.spmmat = {''};
    matlabbatch{6}.spm.util.voi.roi{1}.spm.contrast = 3;
    % matlabbatch{6}.spm.util.voi.roi{1}.spm.conjunction = 1;
    matlabbatch{6}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    matlabbatch{6}.spm.util.voi.roi{1}.spm.thresh = 0.05;
    matlabbatch{6}.spm.util.voi.roi{1}.spm.extent = 0;
    % matlabbatch{6}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{6}.spm.util.voi.roi{2}.sphere.centre = [30.59 -5.42 58.3];
    matlabbatch{6}.spm.util.voi.roi{2}.sphere.radius = 4;
    matlabbatch{6}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
    matlabbatch{6}.spm.util.voi.expression = 'i1 & i2';
    matlabbatch{7}.spm.util.voi.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{7}.spm.util.voi.adjust = maskAdjust;
    matlabbatch{7}.spm.util.voi.session = 1;
    matlabbatch{7}.spm.util.voi.name = 'SPC';
    matlabbatch{7}.spm.util.voi.roi{1}.spm.spmmat = {''};
    matlabbatch{7}.spm.util.voi.roi{1}.spm.contrast = 3;
    % matlabbatch{7}.spm.util.voi.roi{1}.spm.conjunction = 1;
    matlabbatch{7}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    matlabbatch{7}.spm.util.voi.roi{1}.spm.thresh = 0.05;
    matlabbatch{7}.spm.util.voi.roi{1}.spm.extent = 0;
    % matlabbatch{7}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{7}.spm.util.voi.roi{2}.sphere.centre = [-34.15 -53.36 48.7];
    matlabbatch{7}.spm.util.voi.roi{2}.sphere.radius = 4;
    matlabbatch{7}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
    matlabbatch{7}.spm.util.voi.expression = 'i1 & i2';
end