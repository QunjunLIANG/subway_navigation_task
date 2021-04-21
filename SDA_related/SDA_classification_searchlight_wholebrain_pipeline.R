#!/usr/bin/Rscript

# search light RSA
# use rMVPA
library(rMVPA)
library(neuroim2)
library(fslr)
library(stringr)
library(caret)
library(kernlab)
# global variables ----
wkDir <- "/media/lqj/research_data/subway_fMRIprep/fMRI_data/derivatives/GLM/GLM3_RSA"
fmriExample <- "searchlight/rawdata_lineDs_design2/sub-xxxx_merge.nii.gz"
outDir <- "searchlight/MVPA_wholebrain_lineDs_design1"
outDirPlot <- "Plots"
outDirRData <- 'RData'
mask <- "searchlight/masks/sub-xxxx_brainmask.nii.gz"
sbjFile <- "name_list_clean"
radius <- 15 # indicate the size of ROI
classifier <- "sda_notune"
method <- 'standard'
# reshape the right path
fmriExample_use <- paste(wkDir, fmriExample, sep = '/')
mask_use <- paste(wkDir, mask, sep = '/')
sbjFile_use <- paste(wkDir, sbjFile, sep = '/')
outDir_use <- paste(wkDir, outDir, sep = '/')
outDirPlot_use <- paste(outDir_use, outDirPlot, sep = '/')
outDirRData_use <- paste(outDir_use, outDirRData, sep = '/')
# outACC <- "sub-xxxx_accuracy"
# outAUC <- "sub-xxxx_AUC"
# outAUC_line1 <- "sub-xxxx_AUC_line1"
# outAUC_line2 <- "sub-xxxx_AUC_line2"
# outAUC_line3 <- "sub-xxxx_AUC_line3"
# outAUC_line4 <- "sub-xxxx_AUC_line4"
# outPob <- "sub-xxxx_pobserved.nii.gz"
# outACC_use <- paste(outDir_use, outAcc_use, sep = '/')
# outAUC_use <- paste(outDir_use, outAUC, sep = '/')
# outAUC_line1_use <- paste(outDir_use, outAUC_line1, sep = '/')
# outAUC_line2_use <- paste(outDir_use, outAUC_line2, sep = '/')
# outAUC_line3_use <- paste(outDir_use, outAUC_line3, sep = '/')
# outAUC_line4_use <- paste(outDir_use, outAUC_line4, sep = '/')
# outPob_use <- paste(outDir, outPob, sep = '/')

# function for MVPA
MVPAclassification <- function(sbjImg, maskImg, classifier, method, radius) {
  library(neuroim2)
  library(caret)
  library(kernlab)
  library(rMVPA)
  # start MVPA
  fmriDat <- read_vec(file_name = sbjImg)
  mask <- read_vol(file_name = maskImg)
  dat <- mvpa_dataset(train_data = fmriDat, mask = mask)
  designDF <- data.frame('label'=factor(x = rep(1:4, times=4),levels = c(1:4),labels = c('line1', 'line2', 'line3', 'line4')),
                         'block'=rep(1:4, each=4))
  design <- mvpa_design(train_design = designDF, y_train = ~ label, block_var = "block")
  crossval <- blocked_cross_validation(block_var = design$block_var)
  sda_model <- load_model(classifier)
  model <- mvpa_model(model = sda_model, dataset = dat, design = design, model_type = 'classification', crossval = crossval)
  result <- run_searchlight(model_spec = model, radius = radius, method = method)
  return(result)
}
GetMVPAresultImages <- function(sbjName, result, outDir) {
  library(stringr)
  library(tidyverse)
  library(neuroim2)
  library(rMVPA)
  # correct the output directory
  sbjName <- as.character(sbjName)
  outACC <- str_replace("sub-xxxx_accuracy", pattern = 'xxxx', replacement = sbjName) %>%
    paste0(outDir, '/', ., '.nii.gz')
  outAUC <- str_replace("sub-xxxx_AUC", pattern = 'xxxx', replacement = sbjName)   %>%
    paste0(outDir, '/', ., '.nii.gz')
  outAUC_line1 <- str_replace("sub-xxxx_AUC_line1", pattern = 'xxxx', replacement = sbjName)  %>%
    paste0(outDir, '/', ., '.nii.gz')
  outAUC_line2 <- str_replace("sub-xxxx_AUC_line2", pattern = 'xxxx', replacement = sbjName)  %>%
    paste0(outDir, '/', ., '.nii.gz')
  outAUC_line3 <- str_replace("sub-xxxx_AUC_line3", pattern = 'xxxx', replacement = sbjName)  %>%
    paste0(outDir, '/', ., '.nii.gz')
  outAUC_line4 <- str_replace("sub-xxxx_AUC_line4", pattern = 'xxxx', replacement = sbjName)  %>%
    paste0(outDir, '/', ., '.nii.gz')
  outPob <- str_replace("sub-xxxx_pobserved.nii.gz", pattern = 'xxxx', replacement = sbjName)  %>%
    paste0(outDir, '/', .)
  # get the image
  write_vol(result$Accuracy, file_name = outACC)
  write_vol(result$AUC, file_name = outAUC)
  write_vol(result$AUC_line1, file_name = outAUC_line1)
  write_vol(result$AUC_line2, file_name = outAUC_line2)
  write_vol(result$AUC_line3, file_name = outAUC_line3)
  write_vol(result$AUC_line4, file_name = outAUC_line4)
  write_vec(result$pobserved, file_name = outPob)
}
GetMVPAresultPLot <- function(sbjName, result, outDir) {
  library(stringr)
  library(tidyverse)
  library(Cairo)
  # indicating the plot path
  # correct the output directory
  sbjName <- as.character(sbjName)
  outACC <- str_replace("sub-xxxx_accuracy", pattern = 'xxxx', replacement = sbjName) %>%
    paste0(outDir, '/', ., '.png')
  outAUC <- str_replace("sub-xxxx_AUC", pattern = 'xxxx', replacement = sbjName)   %>%
    paste0(outDir, '/', ., '.png')
  outAUC_line1 <- str_replace("sub-xxxx_AUC_line1", pattern = 'xxxx', replacement = sbjName)  %>%
    paste0(outDir, '/', ., '.png')
  outAUC_line2 <- str_replace("sub-xxxx_AUC_line2", pattern = 'xxxx', replacement = sbjName)  %>%
    paste0(outDir, '/', ., '.png')
  outAUC_line3 <- str_replace("sub-xxxx_AUC_line3", pattern = 'xxxx', replacement = sbjName)  %>%
    paste0(outDir, '/', ., '.png')
  outAUC_line4 <- str_replace("sub-xxxx_AUC_line4", pattern = 'xxxx', replacement = sbjName)  %>%
    paste0(outDir, '/', ., '.png')
  # plotting and saving
  CairoPNG(outACC)
  p <- hist(result$Accuracy, main = paste0('Histogram of ACC in sub-', sbjName), xlab = 'Accuracy', col = 'steelblue')
  dev.off()
  CairoPNG(outAUC)
  p <- hist(result$AUC, main = paste0('Histogram of AUC in sub-', sbjName), xlab = 'AUC', col = 'steelblue')
  dev.off()
  CairoPNG(outAUC_line1)
  p <- hist(result$AUC_line1, main = paste0('Histogram of AUC_line1 in sub-', sbjName), xlab = 'AUC', col = 'steelblue')
  dev.off()
  CairoPNG(outAUC_line2)
  p <- hist(result$AUC_line2, main = paste0('Histogram of AUC_line2 in sub-', sbjName), xlab = 'AUC', col = 'steelblue')
  dev.off()
  CairoPNG(outAUC_line3)
  p <- hist(result$AUC_line3, main = paste0('Histogram of AUC_line3 in sub-', sbjName), xlab = 'AUC', col = 'steelblue')
  dev.off()
  CairoPNG(outAUC_line4)
  p <- hist(result$AUC_line4, main = paste0('Histogram of AUC_line4 in sub-', sbjName), xlab = 'AUC', col = 'steelblue')
  dev.off()
}

# start working
if (!dir.exists(outDir_use)) {
  dir.create(outDir_use, recursive = T)
}
if (!dir.exists(outDirPlot_use)) {
  dir.create(outDirPlot_use, recursive = T)
}
if (!dir.exists(outDirRData_use)) {
  dir.create(outDirRData_use, recursive = T)
}
sbjList <- read.table(sbjFile_use)$V1
fmriList <- sapply(as.character(sbjList), simplify = T, FUN = str_replace, string=fmriExample_use, pattern='xxxx')
maskList <- sapply(as.character(sbjList), simplify = T, FUN = str_replace, string=mask_use, pattern='xxxx')
for (ind in 1:length(fmriList)) {
  rdsName_tmp <- paste0(outDirRData_use,'/',sbjList[ind],'_MVPAresult.rds')
  if (file.exists(rdsName_tmp)) {
    print(paste0(rdsName_tmp, 'exists, continue to next loop'))
    next
  }
  resultMVPA <- MVPAclassification(sbjImg = fmriList[ind], maskImg = maskList[ind],
                                   classifier = classifier, method = method, radius = radius)
  GetMVPAresultImages(sbjName = sbjList[ind], result = resultMVPA, outDir = outDir_use)
  GetMVPAresultPLot(sbjName = sbjList[ind], result = resultMVPA, outDir = outDirPlot_use)
  # save the variable as a external file
  saveRDS(resultMVPA, file = rdsName_tmp)
  print(sbjList[ind])
  print(paste0("subject ",ind," finished!"))
}
