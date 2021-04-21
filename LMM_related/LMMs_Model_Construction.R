#####################
#
# LMMs analysis
#
########################
rm(list = ls())
# global environment ---------
wkDir <- '/media/lqj/research_data/subway_fMRIprep/fMRI_data/derivatives/Behavior_data_analysis'
dataFileName <- 'Behavior_Data_Clean_1201.csv'
LMMresult_file_name <- 'LMMs_result_table.doc'

# load and check the data ----
data.ori <- readr::read_csv(paste(wkDir, dataFileName, sep = '/'))
head(data.ori)
## the colnames of the data was renamed for easily modelling
### RT_log -- Y
### DS -- A
### DL -- B
### DX -- C
### DU -- D
### station_type -- F1
### response_type -- F2
### Note. trials of suboptimal journey were filtered out
## re-code the data type of variables
data.recode <- data.ori
data.recode$journey <- as.factor(data.recode$journey)
data.recode$subject <- as.character(data.recode$subject)
data.recode$run <- as.factor(data.recode$run)
head(data.recode)
table(data.recode$subject) # check the data loading of each subject
VIM::matrixplot(data.recode) # missing value check
data.lmm <- data.recode

# Model construction ----
library(lmerTest)
## test the random effect ----
RE.formula.1     <- "Y ~ F1*F2 + A + B + C + D + (1 | subject)"
RE.formula.2     <- "Y ~ F1*F2 + A + B + C + D + (1 | subject) + (1 | run)"
RE.formula.3     <- "Y ~ F1*F2 + A + B + C + D + (1 | subject) + (1 | run) + (1|journey)"
model.re.1 <- lmer(formula = RE.formula.1, data = data.lmm, REML = T)
model.re.2 <- lmer(formula = RE.formula.2, data = data.lmm, REML = T)
model.re.3 <- lmer(formula = RE.formula.3, data = data.lmm, REML = T)
anova(model.re.1, model.re.2, model.re.3, refit=F) # ANOVA shows the optimal random effects are subject and run
## test the fixed effect ----
FE.formula.1     <- "Y ~ F1*F2 + (1 | subject) + (1 | run)"
FE.formula.2     <- "Y ~ F1*F2 + A + (1 | subject) + (1 | run)"
FE.formula.3     <- "Y ~ F1*F2 + A + B + (1 | subject) + (1 | run)"
FE.formula.4     <- "Y ~ F1*F2 + A + B + C + (1 | subject) + (1 | run)"
FE.formula.5     <- "Y ~ F1*F2 + A + B + C + D + (1 | subject) + (1 | run)"
model.fe.1 <- lmer(formula = FE.formula.1, data = data.lmm, REML = F)
model.fe.2 <- lmer(formula = FE.formula.2, data = data.lmm, REML = F)
model.fe.3 <- lmer(formula = FE.formula.3, data = data.lmm, REML = F)
model.fe.4 <- lmer(formula = FE.formula.4, data = data.lmm, REML = F)
model.fe.5 <- lmer(formula = FE.formula.5, data = data.lmm, REML = F)
anova(model.fe.1, model.fe.2, model.fe.3, model.fe.4, model.fe.5) # model compasion shows the optimal model is 3 parameters model
anova(model.fe.1, model.fe.5)
anova(model.fe.2, model.fe.5)
anova(model.fe.3, model.fe.5)
anova(model.fe.4, model.fe.5)
anova(model.fe.5, model.fe.4)
## test the geographic parameter model ----
geom.formula.1 <- "Y ~ F1*F2 + A + B + C + D  + vector + angle + (1 | subject) + (1 | run)"
geom.formula.2 <- "Y ~ F1*F2 + A + B + C + D + vectorH + vectorV + angle + (1 | subject) + (1 | run)"
model.geom.1 <- lmer(formula = geom.formula.1, data = data.lmm, REML = F)
model.geom.2 <- lmer(formula = geom.formula.2, data = data.lmm, REML = F)
anova(model.fe.5, model.geom.1, model.geom.2) # anova shows the vecter and angle model is the optimal model
anova(model.fe.4, model.geom.1, model.geom.2)
# export the table ----
library(sjPlot)
tab_model(model.fe.5, model.fe.3, model.fe.2, 
          pred.labels = c("(intercept)",'StationType','ResponseType','DS','DL','DX','DU','Station*Response'),
          dv.labels = c('Full Model','Task-space Model',"Distance Model"),
          p.style = 'stars',
          collapse.ci = T,
          file = LMMresult_file_name)
