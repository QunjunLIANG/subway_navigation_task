# search light RSA
# use rMVPA
library(rMVPA)
library(neuroim2)
library(fslr)
library(stringr)
# global variables ----
wkDir <- getwd()
sbjFile <- "name_list_clean"
fmriDir <- "searchlight/rawdata_line_design2"
fmriExample <- "sub-xxxx_merge.nii.gz"
outDir.mask <- "searchlight/masks"
outDir.rsa <- "searchlight/result_wholebrain_line_design2"
mask.ori <- "/media/lqj/research_data/subway_fMRIprep/fMRI_data/derivatives/fmriprep/xxxx/anat/xxxx_space-MNI152NLin2009cAsym_desc-brain_mask.nii.gz"
radius <- 15 # indicate the size of ROI
rsa.method <- 'pearson' # the correlation using in rsa
## reshape the directories
sbjList <- read.table(paste0(wkDir,'/',sbjFile))
fmriDir_use <- paste0(wkDir, '/', fmriDir)
fmriExample_use <- paste0(fmriDir_use,'/',fmriExample)
outDir.mask_use <- paste0(wkDir, '/', outDir.mask)
outDir.rsa_use <- paste0(wkDir, '/', outDir.rsa)
if (!dir.exists(outDir.rsa_use)) {
  dir.create(outDir.rsa_use, recursive = T)
}
if (!dir.exists(outDir.mask_use)) {
  dir.create(outDir.mask_use, recursive = T)
}

# functions initial ----
## function to make masks
MakeMask <- function(mask=mask.ori, img, outDir) {
  library(stringr)
  sbjInd <- str_extract(img, pattern = 'sub-[0-9]+')
  outFile <- paste0(sbjInd,"_brainmask",".nii.gz")
  maskFile <- str_replace_all(string = mask, pattern = 'xxxx', replacement = sbjInd)
  flirt(infile = maskFile, reffile = img,
        dof = 12, outfile = paste0(outDir,'/',outFile), opts = "-applyxfm -usesqform", verbose = F)
  fslmaths(file = paste0(outDir,'/',outFile), outfile = paste0(outDir,'/',outFile), opts = "-thr 0.5 -bin", verbose = F)
}
## function to run rsa searchlight
SearchLightWholeBrain <- function(img, mask, rad, corMethod, outDir) {
  library(rMVPA)
  library(neuroim2)
  trainData <- read_vec(img)
  maskImg <- read_vol(mask)
  dataset <- mvpa_dataset(train_data = trainData, mask = maskImg)
  # make the DSM based on orignal research
  DSM <- dist(rep(1:4, times = 4))
  DSM[DSM==0] <- -1
  DSM[DSM > 0] <- 0
  DSM[DSM==-1] <- 1
  # start searchlight
  rsaDesign <- rsa_design(~DSM, list(DSM=DSM), block_var = factor(rep(1:4, each=4)))
  rsaModel <- rsa_model(dataset = dataset, design = rsaDesign)
  rsa_test <- run_searchlight(rsaModel, radius=rad, method = "standard", regtype = corMethod)
  outFile <- paste0(str_extract(img, pattern = 'sub-[0-9]+'),"_searchlight.nii.gz")
  write_vol(rsa_test$DSM, paste0(outDir, '/', outFile))
}
# # step 1: making masks ----
fmriList <- sapply(as.character(sbjList$V1), simplify = T, FUN = str_replace, string=fmriExample_use,pattern='xxxx')
for (sbj in fmriList) {
  MakeMask(img = sbj, outDir = outDir.mask_use)
}

# step 2: whole brain searchlight analysis in subject-level ----
fmriList <- sapply(as.character(sbjList$V1), simplify = T, FUN = str_replace, string=fmriExample_use,pattern='xxxx')
maskList <- list.files(outDir.mask_use, full.names = T)
for (ind in 1:length(fmriList)) {
  SearchLightWholeBrain(img = fmriList[ind], mask = maskList[ind],
                        rad = radius, corMethod = rsa.method, outDir = outDir.rsa_use) 
  print(paste0("subject ",ind," finished!"))
}
