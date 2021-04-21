# global enviroments ----
rm(list = ls())
wkDir <- "/media/lqj/research_data/subway_fMRIprep/fMRI_data/derivatives/Behavior_data_analysis"
behaData.name <- 'subway_behaviordata_assumble.csv'

# data reshape  ----
behaData.raw <- readr::read_csv(behaData.name)
summary(behaData.raw)
behaData.raw$RT[which(behaData.raw$RT=='N/A')] <- NA
behaData.raw$RT <- as.numeric(behaData.raw$RT)
behaData.raw["logRT"] <- log(behaData.raw$RT)

# data description ----
## how many journeys does a subject will undertake
library(tidyverse)
journey_desc <- data.frame()
for (sbjInd in unique(behaData.raw$subject)) {
  thisData_subject <- behaData.raw %>%
    filter(subject==sbjInd)
  for (runInd in unique(thisData_subject$run)) {
    thisData_run <- thisData_subject %>%
      filter(run==runInd)
    thisResult <- data.frame(sbjInd, runInd, max(thisData_run$journey, na.rm = T))
    colnames(thisResult) <- c('subject', 'run', 'njourney')
    journey_desc <- rbind(journey_desc, thisResult)
  }
}

mean(journey_desc$njourney) # 17.12903
sd(journey_desc$njourney) # 0.919241
### what about the accurarcy of journeys?
accData <- readr::read_delim('subject_journey.txt', col_names = F, delim = ' ')


## check the data distribution
library(psych)
describeBy(behaData.raw$RT, group = behaData.raw$opt_journey) # get the mean and SD value
## plot the distribution
library(ggplot2)
p.dis_RT <- ggplot(behaData.raw)+ 
  geom_histogram(aes(x = RT, fill = opt_journey), na.rm = T, color='black') +
  ggtitle("Distribution of RT") +
  ylab('Count') +
  xlab('Response Time') +
  theme_bw() +
  theme(text = element_text(face = 'bold', size = 12),
        plot.margin = margin(30,30,30,30)) +
  ggeasy::easy_change_legend(what = 'position', to = 'top') +
  ggeasy::easy_add_legend_title('Type of Journey')
p.dis_logRT <- ggplot(behaData.raw)+ 
  geom_histogram(aes(x = logRT, fill = opt_journey), na.rm = T, color='black') +
  ggtitle("Distribution of logRT") +
  ylab('Count') +
  xlab('Response Time') +
  theme_bw() +
  theme(text = element_text(face = 'bold', size = 12),
        plot.margin = margin(30,30,30,30)) +
  ggeasy::easy_change_legend(what = 'position', to = 'top') +
  ggeasy::easy_add_legend_title('Type of Journey')

## Does optimal/suboptimal choice differenc exist? ----
library(tidyverse)
behaData.raw_journey <- behaData.raw %>%
  select(subject, opt_journey, RT) %>%
  group_by(subject, opt_journey) %>%
  summarise_each(funs(mean(., na.rm = T)))
p.diff_journey <- ggstatsplot::ggbetweenstats(
  data = behaData.raw_journey,
  x = opt_journey,
  y = RT,
  type = 'robust',
  xlab = 'Type of Journey',
  ylab = 'Subjects\' Response Time', 
  title = 'Difference of RT in Type of Journey',
  ggplot.component = theme(plot.margin = margin(30, 10, 30, 10))
)
### divid the stations into regular stations and exchange stations
#### exchange stations 
p.diff_trials_exchange <-  behaData.raw %>%
  filter(station_type==1, response=='switch') %>%
  select(subject, opt_journey, RT) %>%
  group_by(subject, opt_journey) %>%
  summarise_each(funs(mean(., na.rm = T))) %>%
  ggstatsplot::ggbetweenstats(
    data = .,
    x = opt_journey,
    y = RT,
    type = 'robust',
    xlab = 'Type of Journey',
    ylab = 'Subjects\' Response Time', 
    title = 'Difference of RT in Exchange Stations (in switch)',
    ggplot.component = theme(plot.margin = margin(30, 10, 30, 10))
  )
#### regular stations 
p.diff_trials_regular <-  behaData.raw %>%
  filter(station_type==0, response=='stay') %>%
  select(subject, opt_journey, RT) %>%
  group_by(subject, opt_journey) %>%
  summarise_each(funs(mean(., na.rm = T))) %>%
  ggstatsplot::ggbetweenstats(
    data = .,
    x = opt_journey,
    y = RT,
    type = 'robust',
    xlab = 'Type of Journey',
    ylab = 'Subjects\' Response Time', 
    title = 'Difference of RT in Regular Stations (in stay)',
    ggplot.component = theme(plot.margin = margin(30, 10, 30, 10))
  )

## Does gender differenc exist? ----
### filter out the suboptimal trials
behaData.opt <- behaData.raw[behaData.raw$opt_journey=="optimal",]
behaData.opt$subject <- as.character(behaData.opt$subject)
library(tidyverse)
genderInd <- readr::read_csv(paste(wkDir, 'sbj_ID_index.csv', sep = '/'), 
                             col_types = list(col_character(), col_character(), col_character()),
                             col_names = c('subject', 'ID', 'gender'))
behaData.opt.gender <- behaData.opt %>% # combine and average the RT in subjects
  group_by(subject) %>%
  summarise_each(funs(mean)) %>%
  left_join(genderInd, by = "subject")
psych::describeBy(behaData.opt.gender$RT, group = behaData.opt.gender$gender)
t.test(behaData.opt.gender$RT ~ behaData.opt.gender$gender, alternative = "two.sided", na.action = na.omit)
wilcox.test(behaData.opt.gender$RT  ~ behaData.opt.gender$gender, alternative = "two.sided", na.action = na.omit)
p.diff_gender <- ggstatsplot::ggbetweenstats(
  data = behaData.opt.gender,
  x = gender,
  y = RT,
  type = 'robust',
  xlab = 'Type of Journey',
  ylab = 'Subjects\' Response Time', 
  title = 'Difference of RT in Genders'
)

## Does the trials in the beginning of a journey take longer to response than the last trial in the identical journey? ----
library(tidyverse)
behaData.opt.trial <- data_frame()
for (sbjInd in unique(behaData.opt$subject)) {
  for (runInd in unique(behaData.opt$run)) {
    this.data_run <- behaData.opt %>%
      filter(subject==sbjInd, run==runInd)
    for (jourInd in unique(this.data_run$journey)) {
      this.data <- this.data_run %>%
        filter(journey==jourInd)
      this.result_begin <- data.frame(sbjInd, runInd, jourInd, 'begin', this.data$RT[1])
      this.result_end <- data.frame(sbjInd, runInd, jourInd, 'end', this.data$RT[nrow(this.data)])
      colnames(this.result_begin) <- c('subject', 'run', 'journey', 'stage', 'RT')
      colnames(this.result_end) <- c('subject', 'run', 'journey', 'stage', 'RT')
      this.result <- rbind(this.result_begin, this.result_end)
      coeff_trials <- lm(data = this.data, RT ~ trial)$coefficients[2]
      this.result["coeff"] <- coeff_trials
      behaData.opt.trial <- rbind(behaData.opt.trial, this.result)
    }
  }
}
### group mean by subject and stage
behaData.opt.trial_mean <- behaData.opt.trial %>% # ectraction the RT of begin and end
  group_by(subject, stage) %>%
  summarise_each(funs(mean))
behaData.opt.trial_coeff <- behaData.opt.trial %>% # extrating the coefficicent of linear trend of trials
  group_by(subject) %>%
  summarise_each(funs(mean))
### Does the RT in first tirals and last trials in each journey are different?
p.diff_trials <- ggstatsplot::ggwithinstats(
  data = behaData.opt.trial_mean,
  x = stage,
  y = RT,
  pairwise.comparisons = T,
  title = 'Difference of the First and Last Trial',
  xlab = 'Choice Stage',
  ylab = 'Response Time'
)
library(ggthemr)
ggthemr('flat dark')
p.trial_coeff <- ggstatsplot::gghistostats(
  data = behaData.opt.trial_coeff,
  x = coeff, # numeric variable whose distribution is of interest
  title = "Amount of Coefficicent", # title for the plot
  test.value = 0,
  test.value.line = TRUE, 
  bar.fill = 'brown2',
  ggplot.component = theme(text = element_text(size=13))
)

# combine the result plot ---------------------
p.combine_10 <- ggstatsplot::combine_plots(p.dis_RT, p.dis_logRT, labels = c('A', 'B'), nrow =2) %>%
  ggstatsplot::combine_plots(., p.diff_journey, ncol = 2, labels = c('', 'C'))
p.combine_11 <- ggstatsplot::combine_plots(p.diff_trials_exchange, p.diff_trials_regular,
                                           labels = c('D', 'E'), nrow = 2)
p.combine_1 <- ggstatsplot::combine_plots(p.combine_10, p.combine_11,
                                          rel_widths = c(2,1))
ggsave(plot = p.combine_1, filename = 'Plot_RTdis_logRTdis_JourDiff.png')

p.combine_2 <- ggstatsplot::combine_plots(p.diff_trials, p.trial_coeff, nrow = 2, labels = c('A', 'B')) %>%
  ggstatsplot::combine_plots(., p.diff_gender, labels = c('','C'), ncol = 2)
ggsave(plot = p.combine_2, filename = 'Plot_GenderDiff_TrialCoeff_TrialDiff.png')
