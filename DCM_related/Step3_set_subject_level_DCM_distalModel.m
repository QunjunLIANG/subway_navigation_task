%% Settings
scriptDir = '/media/lqj/research_data/subway_fMRIprep/fMRI_data/derivatives/GLM/DCM_SPM';
rawGLMdir = [scriptDir '/Output_concate'];
GCMoutDir = [scriptDir '/GCD_output']; % indicate where the GCM.mat will be placed

% MRI scanner settings
TR = 1.2;   % Repetition time (secs)
TE = 0.04;  % Echo time (secs)

% Experiment settings
nsubjects   = 31;
nregions    = 4; 
nconditions = 2;

% Index of each condition in the DCM
DS=1; DL=2;

% Index of each region in the DCM
dmPFC=1; lPMC=2; rPMC=3; SPC=4;

%% Specify DCMs (one per subject)

% A-matrix (on / off)
a = ones(nregions,nregions);
a(dmPFC, rPMC) = 0;
a(dmPFC, lPMC) = 0;
a(rPMC, lPMC) = 0;
% B-matrix
b(:,:,DS) = [0,0,0,1;
             0,0,0,0;
             0,0,0,0;
             0,1,0,0]; % DS specific
b(:,:,DL) = [0,0,0,1;
             0,0,0,0;
             0,0,0,0;
             0,1,1,0]; % DS specific
% C-matrix
c = zeros(nregions,nconditions);

% D-matrix (disabled)
d = zeros(nregions,nregions,0);

start_dir = scriptDir;
for subject = 1:nsubjects
    
    name = sprintf('sub-%02d',subject);
    
    % Load SPM
    glm_dir = fullfile(rawGLMdir,name);
    SPM     = load(fullfile(glm_dir,'SPM.mat'));
    SPM     = SPM.SPM;
    
    % Load ROIs
    f = {fullfile(glm_dir,'VOI_dmPFC_1.mat');
         fullfile(glm_dir,'VOI_lPMC_1.mat');
         fullfile(glm_dir,'VOI_rPMC_1.mat');
         fullfile(glm_dir,'VOI_SPC_1.mat')};    
    for r = 1:length(f)
        XY = load(f{r});
        xY(r) = XY.xY;
    end
    
    % Move to output directory
    cd(glm_dir);
    
    % Select whether to include each condition from the design matrix
    % (DS and DL)
    include = [0 1 1 0 0;
               0 0 0 0 0;
               0 0 0 0 0;
               0 0 0 0 0;
               0 0 0 0 0;
               0 0 0 0 0;
               0 0 0 0 0];    
    
    % Specify. Corresponds to the series of questions in the GUI.
    s = struct();
    s.name       = 'distal_integration_model';
    s.u          = include;                 % Conditions
    s.delays     = repmat(TR,1,nregions);   % Slice timing for each region
    s.TE         = TE;
    s.nonlinear  = false;
    s.two_state  = false;
    s.stochastic = false;
    s.centre     = true;
    s.induced    = 0;
    s.a          = a;
    s.b          = b;
    s.c          = c;
    s.d          = d;
    DCM = spm_dcm_specify(SPM,xY,s);
    
    % Return to script directory
    cd(start_dir);
end

%% Collate into a GCM file and estimate

% Find all DCM files
dcms = spm_select('FPListRec',rawGLMdir,'DCM_distal_integration_model.mat');

% Prepare output directory
out_dir = GCMoutDir;
if ~exist(out_dir,'file')
    mkdir(out_dir);
end

% Check if it exists
if exist(fullfile(out_dir,'GCM_distal_integration_model.mat'),'file')
    opts.Default = 'No';
    opts.Interpreter = 'none';
    f = questdlg('Overwrite existing GCM?','Overwrite?','Yes','No',opts);
    tf = strcmp(f,'Yes');
else
    tf = true;
end

% Collate & estimate
if tf
    % Character array -> cell array
    GCM = cellstr(dcms);
    
    % Filenames -> DCM structures
    GCM = spm_dcm_load(GCM);

    % Estimate DCMs (this won't effect original DCM files)
    GCM = spm_dcm_fit(GCM);
    
    % Save estimated GCM
    save([GCMoutDir '/GCM_core_integration_model.mat'],'GCM');
end
