# global environment ----
wkDir <- getwd()
dataDir <- 'searchlight/result_wholebrain_lineDs_design1'
inputName <- 'sub-xxxx_searchlight.nii.gz'
outDir <- 'searchlight/Fisher_result_wholebrain_lineDs_design1'
outputName <- 'sub-xxxx_searchlight_fz.nii.gz'
sbjListFile <- 'name_list_clean'
## recode the path
dataDir_use <- paste(wkDir, dataDir,  sep = '/')
outDir_use <- paste(wkDir, outDir, sep = '/')
sbjListFile_use <- paste(wkDir, sbjListFile,  sep = '/')
inputName_use <- paste(dataDir_use, inputName,  sep = '/')
outputName_use <- paste(outDir_use, outputName,  sep = '/')
## ensure the output path
if (dir.exists(outDir_use)) {
  print('Result exsisted, please check!')
  quit(save = "no")
}else{
  dir.create(path = outDir_use, recursive = T)
}

# initial the functions ----
FisherTrans <- function(nVol) {
  library(DescTools)
  library(neuroim2)
  vals <- as.vector(nVol)
  fzvals <- FisherZ(vals)
  fzvol <- NeuroVol(fzvals, 
                    space = NeuroSpace(dim = c(82,97,81), spacing = c(2.4, 2.4, 2.4)))
  return(fzvol)
}

# load the necesse ----
library(neuroim2)
library(stringr)
sbjList <- read.table(sbjListFile_use)$V1
fmriList <- sapply(as.character(sbjList),
                   simplify = T, FUN = str_replace, 
                   string=inputName_use, pattern='xxxx')
outList <-  sapply(as.character(sbjList),
                   simplify = T, FUN = str_replace, 
                   string=outputName_use, pattern='xxxx')
for (ind in 1:length(fmriList)) {
  corMap_tmp <- read_vol(fmriList[ind])
  fz_corMap_tmp <- FisherTrans(corMap_tmp)
  write_vol(fz_corMap_tmp, outList[ind])
  print(paste0("subject ",ind," finished!"))
}
