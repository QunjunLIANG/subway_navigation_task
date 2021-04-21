# subway_navigation_task
For opening all scripts we used in virtual subway navigation study. Here, we are grateful for all the supports given by Dr. Buchsbaum in MVPA.

## Introduction of Document Tree

### Task Program

We used [Psychopy](https://www.psychopy.org/) v3.0 to present the whole task.

You can find the python scripts in **Task_Program_Psychopy/**.

Directory named "formal_experiment" contains the program used in formal experiment when fMRI scanning.

Directory named "train_stage" contains the program used in the training stage a day before scanning.

### Linear Mixed Model Analysis

The linear mixed model which modeling the behavioral data of participants was built using R package [lmerTest](https://cran.r-project.org/web/packages/lmerTest/index.html).

You can find the R scritps in **LMM_related/**.

**LMMs_Model_Construction.R** is the script to build the model, and **LMMs_Pre-analysis_gender_accurarcy.R** is the script to analyze gender difference and participants' performance before LMM.

### Reinforcement Learning Agent Training

To test if our participants used hierarchical planning, we trained a reinforcement learning (RF) agent in a flat environment as the base line comparison.

The RF agent was trained using R package [ReinforcementLearning](https://cran.r-project.org/web/packages/ReinforcementLearning/index.html) which could perform a model-free RF.

The directory named **ReinforcementLearning/** contains the script using in agent training (**ReinforcementLearning_pipeline.R**) and the script that presents the result in Rmarkdown (post_ReinforcementLeaning_pipeline.Rmd).

### Universal Analysis of Neural Data

To detect the response of brain areas to computational costs, we built a general linear model 1 which contains four costs for parameteric modulation.

The GLM1 was conducted using [FSL's](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/) feat. All *.fsf files in **GLM1_related/** are design files using in run-level, subject-level and group-level.

The bash script **BashRun_first_level_GLM1.sh** is used for batching process of run-level GLM1.

The time series could be found in the directory named **TimePointExtraction_GLM1**.

### Multi-voxel Patten Analysis

To figure out the decoding and encoding of the computational cost in brain, we conducted two MVPAs, **representational similarity analysis** (RSA) and **shrinkage discriminant analysis classification** (SDA), with neural data.

All MVPAs were conducted using R package [rMVPA](https://github.com/bbuchsbaum/rMVPA).

You can find the corresponding scripts in **RSA_related/** and **SDA_related/**.



