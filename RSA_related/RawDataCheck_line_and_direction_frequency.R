# global enviroments
rm(list = ls())
wkDir <- getwd()
behaData.name <- 'subway_behaviordata_assumble.csv'
sbjNameList <- 'name_list.txt'

# data preperation ----
## load the behavior data
behaData.raw <- readr::read_csv(behaData.name)
summary(behaData.raw)
behaData.raw$RT[which(behaData.raw$RT=='N/A')] <- NA
behaData.raw$RT <- as.numeric(behaData.raw$RT)
behaData.raw["logRT"] <- as.numeric(behaData.raw$RT)
behaData.raw$subject <- as.character(behaData.raw$subject)

# plot lines in subjects ----
## plot the frequency that in regular station and choice 'stay'
library(tidyverse)
library(ggthemr)
library(ggeasy)
nameList <- readr::read_csv(paste(wkDir, sbjNameList, sep = '/'), col_names = F) %>%
  .$X1 %>%
  as.character()
behaData.line <- behaData.raw %>%
  filter(station_type==0, response=='stay') %>%
  select(subject, run, present_line)
behaData.line$present_line <- factor(behaData.line$present_line,
                                      levels = c('1','2','3','4'),
                                      labels = c('line1','line2','line3','line4'))
behaData.line$run <- factor(behaData.line$run,
                             levels = c('1','2','3','4'),
                             labels = c('Run 1', 'Run 2', "Run 3", 'Run 4'))
behaData.line$subject <- factor(behaData.line$subject, 
                                 levels = nameList)
p1 <- ggplot(data = behaData.line) +
  geom_bar(aes(x = subject, fill = present_line), position = position_dodge()) +
  geom_hline(yintercept = 5, color = 'black') +
  ggtitle("Line-Chosing Frequency in Regular Station") +
  ylab("Count of Choice Frequency") +
  xlab('Subject ID') +
  easy_rotate_x_labels(angle = -45) +
  facet_wrap(~run, nrow = 4) +
  easy_add_legend_title('Line Identification') +
  easy_change_legend(what = 'position', to = 'top') +
  easy_all_text_size(size = 12)

## the partion of diferent lines
library(ggstatsplot)
library(ggeasy)
p2 <- behaData.line %>%
  ggbarstats(main = present_line, condition = subject,
             palette="Set3",
             ggtheme = theme(axis.text.x = element_text(angle = 70, vjust = 0.5),
                             axis.text = element_text(size = 7),
                             axis.title = element_text(family = "bold", size = 13),
                             legend.title = element_blank())) + 
  coord_flip() +
  easy_change_legend(what = 'position', to = 'top')
## combine the plots
library(ggpubr)
comp1 <- ggarrange(p1, p2, nrow = 2, labels = c('A','B'))
ggsave(plot = comp1, filename = 'Line_Choice_Frequency_Check.pdf', height = 20, width = 15)
ggsave(plot = comp1, filename = 'Line_Choice_Frequency_Check.png', height = 20, width = 15)

# plot directions in subjects ----
## Direction distribution in regular stations
library(tidyverse)
behaData.direct <- behaData.raw %>%
  filter(station_type==0, response=='stay') %>%
  select(subject, run, ori_choice)
behaData.direct$ori_choice <- factor(behaData.direct$ori_choice,
                                      levels = c('1','2','3','4'),
                                      labels = c('North','South','West','East'))
behaData.direct$run <- factor(behaData.direct$run,
                               levels = c('1','2','3','4'),
                               labels = c('Run 1', 'Run 2', "Run 3", 'Run 4'))
library(ggthemr)
library(ggeasy)
ggthemr('flat dark')
p3 <- ggplot(data = behaData.direct) +
  geom_bar(aes(x = subject, fill = ori_choice), position = position_dodge()) +
  geom_hline(yintercept = 5, color = 'black') +
  ggtitle("Direction Distribution in Regular Station") +
  ylab("Count of Choice Frequency") +
  xlab('Subject ID') +
  easy_rotate_x_labels(angle = -45) +
  facet_wrap(~run, nrow = 4) +
  easy_add_legend_title('Direction Identification') +
  easy_change_legend(what = 'position', to = 'top') +
  easy_all_text_size(size = 12)

## the partion of diferent lines
library(ggstatsplot)
p4 <- behaData.direct %>%
  ggbarstats(main = ori_choice, condition = subject,
             palette="Set3",
             ggtheme = theme(axis.text.x = element_text(angle = 70, vjust = 0.5),
                             axis.text = element_text(size = 7),
                             axis.title = element_text(family = "bold", size = 13)
                             )) + 
  coord_flip() +
  easy_change_legend(what = 'position', to = 'top')

## combine the plots
library(ggpubr)
comp2 <- ggarrange(p3, p4, nrow = 2, labels = c('A','B'))
ggsave(plot = comp2, filename = 'Direction_Distribution_Check.pdf', height = 20, width = 15)
ggsave(plot = comp2, filename = 'Direction_Distribution_Check.png', height = 20, width = 15)

# run check of lines and directions ----
## the partion of diferent lines
library(ggstatsplot)
library(ggeasy)
p5 <- behaData.line %>%
  grouped_ggbarstats(main = present_line, condition = subject,
                     grouping.var = run,
                     ggplot.component = coord_flip(),
                     ggtheme = theme(axis.text.x = element_text(angle = 70, vjust = 0.5),
                                     axis.text = element_text(size = 7),
                                     axis.title = element_text(family = "bold", size = 13),
                                     legend.position = "top"))
ggsave(plot = p5, filename = 'RawDataCheck_line_choice_run.png', height = 15, width = 25)
## the partion of diferent directions
p6 <- behaData.direct %>%
  grouped_ggbarstats(main = ori_choice, condition = subject,
                     grouping.var = run,
                     ggplot.component = coord_flip(),
                     ggtheme = theme(axis.text.x = element_text(angle = 70, vjust = 0.5),
                                     axis.text = element_text(size = 7),
                                     axis.title = element_text(family = "bold", size = 13),
                                     legend.position = "top"))
ggsave(plot = p6, filename = 'RawDataCheck_direction_distribution_run.png', height = 15, width = 25)
