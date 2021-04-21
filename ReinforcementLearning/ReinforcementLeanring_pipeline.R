allStations <- c(paste0(letters[1:4], rep(1:7, each = 4)), 'a8', 'c8', paste0('e', 1:5))
allActions <- c('up', 'down', 'right', 'left')
sbjList <- readr::read_csv('name_list _rerun', col_names = F)
sbjFile <- 'behav_data_clean/sub-xxxx/sub-xxxx_scanyyyy.csv'
outFile <- 'sub-xxxx_run-yyyy_RFcompare.csv' 
stationOrderFile <- 'StationIndOrder/xxxx_station.csv'
outDir <- "RF_result"
dir.create(outDir)

# function to demean
Demean <- function(inVec) {
  outVec <- inVec - mean(inVec)
  return(outVec)
}
# function to indicate the whole map
SubwayMap <- function(state, action) {
  next_state <- state
  if (state == state('a1') && action == "right") {next_state <- state('a2')}
  if (state == state('a2') && action == "right") {next_state <- state('a3')}
  if (state == state('a3') && action == "down") {next_state <- state('e1')}
  if (state == state('e1') && action == "left") {next_state <- state('b1')}
  if (state == state('e1') && action == "down") {next_state <- state('a4')}
  if (state == state('a4') && action == "down") {next_state <- state('a5')}
  if (state == state('a5') && action == "down") {next_state <- state('a6')}
  if (state == state('a6') && action == "down") {next_state <- state('e2')}
  if (state == state('e2') && action == "left") {next_state <- state('d4')}
  if (state == state('e2') && action == "right") {next_state <- state('d5')}
  if (state == state('e2') && action == "down") {next_state <- state('a7')}
  if (state == state('a7') && action == "down") {next_state <- state('a8')}
  if (state == state('b1') && action == "left") {next_state <- state('b2')}
  if (state == state('b2') && action == "left") {next_state <- state('b3')}
  if (state == state('b3') && action == "left") {next_state <- state('b4')}
  if (state == state('b4') && action == "down") {next_state <- state('b5')}
  if (state == state('b5') && action == "down") {next_state <- state('e3')}
  if (state == state('e3') && action == "left") {next_state <- state('c3')}
  if (state == state('e3') && action == "right") {next_state <- state('c4')}
  if (state == state('e3') && action == "down") {next_state <- state('b6')}
  if (state == state('b6') && action == "down") {next_state <- state('e4')}
  if (state == state('e4') && action == "left") {next_state <- state('d2')}
  if (state == state('e4') && action == "right") {next_state <- state('d3')}
  if (state == state('e4') && action == "down") {next_state <- state('b7')}
  if (state == state('c1') && action == "right") {next_state <- state('c2')}
  if (state == state('c2') && action == "right") {next_state <- state('c3')}
  if (state == state('c3') && action == "right") {next_state <- state('e3')}
  if (state == state('c4') && action == "right") {next_state <- state('c5')}
  if (state == state('c5') && action == "down") {next_state <- state('c6')}
  if (state == state('c6') && action == "down") {next_state <- state('e5')}
  if (state == state('e5') && action == "left") {next_state <- state('d3')}
  if (state == state('e5') && action == "right") {next_state <- state('d4')}
  if (state == state('e5') && action == "down") {next_state <- state('c7')}
  if (state == state('c7') && action == "down") {next_state <- state('c8')}
  if (state == state('d1') && action == "right") {next_state <- state('d2')}
  if (state == state('d2') && action == "right") {next_state <- state('e4')}
  if (state == state('d3') && action == "right") {next_state <- state('e5')}
  if (state == state('d4') && action == "right") {next_state <- state('e2')}
  if (state == state('d5') && action == "down") {next_state <- state('d6')}
  if (state == state('d6') && action == "down") {next_state <- state('d7')}
  if (state == state('a2') && action == "left") {next_state <- state('a1')}
  if (state == state('a3') && action == "left") {next_state <- state('a2')}
  if (state == state('a4') && action == "up") {next_state <- state('e1')}
  if (state == state('a5') && action == "up") {next_state <- state('a4')}
  if (state == state('a6') && action == "up") {next_state <- state('a5')}
  if (state == state('e2') && action == "up") {next_state <- state('a6')}
  if (state == state('e1') && action == "up") {next_state <- state('a3')}
  if (state == state('a7') && action == "up") {next_state <- state('e2')}
  if (state == state('a8') && action == "up") {next_state <- state('a7')}
  if (state == state('b7') && action == "up") {next_state <- state('e4')}
  if (state == state('e4') && action == "up") {next_state <- state('b6')}
  if (state == state('b6') && action == "up") {next_state <- state('e3')}
  if (state == state('e3') && action == "up") {next_state <- state('b5')}
  if (state == state('b5') && action == "up") {next_state <- state('b4')}
  if (state == state('b4') && action == "right") {next_state <- state('b3')}
  if (state == state('b3') && action == "right") {next_state <- state('b2')}
  if (state == state('b2') && action == "right") {next_state <- state('b1')}
  if (state == state('b1') && action == "right") {next_state <- state('e1')}
  if (state == state('c8') && action == "up") {next_state <- state('c7')}
  if (state == state('c7') && action == "up") {next_state <- state('e5')}
  if (state == state('e5') && action == "up") {next_state <- state('c6')}
  if (state == state('c6') && action == "up") {next_state <- state('c5')}
  if (state == state('c5') && action == "left") {next_state <- state('c4')}
  if (state == state('c4') && action == "left") {next_state <- state('e3')}
  if (state == state('e3') && action == "left") {next_state <- state('c3')}
  if (state == state('c3') && action == "left") {next_state <- state('c2')}
  if (state == state('c2') && action == "left") {next_state <- state('c1')}
  if (state == state('d7') && action == "up") {next_state <- state('d6')}
  if (state == state('d6') && action == "up") {next_state <- state('d5')}
  if (state == state('d5') && action == "left") {next_state <- state('e2')}
  if (state == state('d4') && action == "left") {next_state <- state('e5')}
  if (state == state('d3') && action == "left") {next_state <- state('e4')}
  if (state == state('d2') && action == "left") {next_state <- state('d1')}
  out <- next_state
  return(out)
}
# function to transfer the subject-specific station names to standard framework
StationTransfer <- function(stations, stationInd) {
  outVec <- c()
  stations_clean <- trimws(stations, which = c("both", "left", "right"), whitespace = "[ \t\r\n]")
  for (vInd in seq_along(stations_clean)) {
    outVec <- stationInd %>%
      filter(station == stations_clean[vInd]) %>%
      .$Indication %>%
      c(outVec, .)
  }
  return(outVec)
}
# function to export the journey chosen by RF agent
RFagentTraining <- function(stationsInd, actionsInd, jourEnv, startPos, goalPos) {
  stationOder <- c(paste0('a', 1:3), 'e1', paste0('a', 4:6), 
                   'e2', paste0('a', 7:8), paste0('b', 1:5), 'e3', 'b6', 'e4',
                   'b7', paste0('c', 1:6), 'e5', paste0('c' , 7:8), paste0('d', 1:7))
  if (!startPos%in%stationOder) {
    startPos <- StationTransfer(stations = startPos, stationInd = stationsInd)
  }
  library(ReinforcementLearning)
  takeAct <- actionsInd
  trainData <- sampleExperience(N = 1000, env = jourEnv,
                                states = stationOder, actions = takeAct)
  controlRf <- list(alpha = 0.1, gamma = 0.5, epsilon = 0.1)
  rfModel <- ReinforcementLearning(data = trainData, 
                                    s = 'State', a = 'Action',
                                    r = 'Reward', s_new = 'NextState',
                                    iter = 10, control = controlRf)
  updateData <- sampleExperience(N = 500, env = jourEnv, states = stationOder,
                                 actions = takeAct, actionSelection = 'epsilon-greedy',
                                 model = rfModel, control = controlRf)
  updateModel <- ReinforcementLearning(updateData, s = 'State', a = 'Action',
                                       r = 'Reward', s_new = 'NextState',
                                       control = controlRf, model = rfModel)
  print('Agent training finished')
  outJour <- startPos
  thisStation <- startPos
  OptimalAction <- predict(updateModel, thisStation)
  Qvalue <- updateModel$Q[thisStation, OptimalAction]
  nextStep <- SubwayMap(state = thisStation, action = OptimalAction)
  outJour <- c(outJour, nextStep)
  while (nextStep != goalPos) {
    thisStation <- nextStep
    OptimalAction <- predict(updateModel, thisStation)
    Qvalue <- c(Qvalue, updateModel$Q[thisStation, OptimalAction])
    nextStep <- SubwayMap(state = thisStation, action = OptimalAction)
    outJour <- c(outJour, nextStep)
  }
  #return(outJour[-length(outJour)]) 
  return(list("jour"=outJour[-length(outJour)], 
              "value" =Qvalue[-length(outJour)])) 
}
# function to check the length of journeys in different agent
JourCheck <- function(sbjJour, agentJour) {
  # this function is to check the length of two journeys in case 
  # the error of row binding in data.frame
  if (length(sbjJour)>length(agentJour)) {
    while (length(sbjJour)!=length(agentJour)) {
      agentJour[length(agentJour)+1] <- "Reach"
    }
  }
  if (length(sbjJour)<length(agentJour)) {
    while (length(sbjJour)!=length(agentJour)) {
      sbjJour[length(sbjJour)+1] <- "Reach"
    }
  }
  return(list("sbj"=sbjJour,
              'agent'=agentJour))
}

# start Reinforcement Learning
for (sbjInd in sbjList$X1) {
  for (runInd in 1:4) {
    library(tidyverse)
    # indicate the path and file (input and output)
    sbjFile_tmp <- sbjFile %>%
      stringr::str_replace_all(pattern = 'xxxx', replacement = as.character(sbjInd)) %>%
      stringr::str_replace(pattern = 'yyyy', replacement = as.character(runInd))
    outFile_tmp <- outFile %>%
      stringr::str_replace_all(pattern = 'xxxx', replacement = as.character(sbjInd)) %>%
      stringr::str_replace(pattern = 'yyyy', replacement = as.character(runInd)) %>%
      paste(outDir, ., sep = '/')
    # start working
    ## read the data ----
    sbjData <- read.csv(sbjFile_tmp, 
                        skip = 1, fileEncoding = "GB18030", stringsAsFactors = F,
                        sep = ',', header = T, row.names = NULL)
    colnames(sbjData) <- colnames(sbjData)[-1]
    sbjData <- sbjData[, -28]
    sbjName_tmp <- stringr::str_extract(string = sbjFile, pattern = 'sub-[0-9]*')
    run_tmp <- stringr::str_extract(string = sbjFile, pattern = 'scan[0-9]')
    routeData <- sbjData %>%
      filter(界面==" navigation")
    if (sbjInd < 201805002) {
      stationList <- readr::read_csv('StationIndOrder/subway_coordinate.csv', quote = "")
    }else{
      stationList <- stationOrderFile %>%
        stringr::str_replace(pattern = 'xxxx', replacement = as.character(sbjInd)) %>%
        read.csv(quote = "")
    }
    resultFrame <- data.frame("subject"='', "run"='', "journey"='',
                              "sbjRoute"='', "sbjStep"='',
                              "agentRoute"='', "agentStep"='',
                              "matchIndex"='', "Qvalue"='',
                              "Qdemean"="", "optJour"="")
    ## start RF ----
    for (jourInd in unique(routeData$导航编号)) {
      routeTmp <- routeData %>%
        filter(导航编号==jourInd & 反应类型!=' none')
      goal_tmp <- trimws(unique(routeTmp$终点),
                         which = c("both", "left", "right"), whitespace = "[ \t\r\n]") %>%
        StationTransfer(., stationList)
      # optimal journey judgement ----
      if (length(routeTmp$当前站台)==routeTmp$最佳步数[1]) {
        optmalJourney <- 1
      }else{
        optmalJourney <- 0
      }
      # RF module ----
      env_tmp <- function(state, action, goal=goal_tmp) {
        next_state <- state
        if (state == state('a1') && action == "right") {next_state <- state('a2')}
        if (state == state('a2') && action == "right") {next_state <- state('a3')}
        if (state == state('a3') && action == "down") {next_state <- state('e1')}
        if (state == state('e1') && action == "left") {next_state <- state('b1')}
        if (state == state('e1') && action == "down") {next_state <- state('a4')}
        if (state == state('a4') && action == "down") {next_state <- state('a5')}
        if (state == state('a5') && action == "down") {next_state <- state('a6')}
        if (state == state('a6') && action == "down") {next_state <- state('e2')}
        if (state == state('e2') && action == "left") {next_state <- state('d4')}
        if (state == state('e2') && action == "right") {next_state <- state('d5')}
        if (state == state('e2') && action == "down") {next_state <- state('a7')}
        if (state == state('a7') && action == "down") {next_state <- state('a8')}
        if (state == state('b1') && action == "left") {next_state <- state('b2')}
        if (state == state('b2') && action == "left") {next_state <- state('b3')}
        if (state == state('b3') && action == "left") {next_state <- state('b4')}
        if (state == state('b4') && action == "down") {next_state <- state('b5')}
        if (state == state('b5') && action == "down") {next_state <- state('e3')}
        if (state == state('e3') && action == "left") {next_state <- state('c3')}
        if (state == state('e3') && action == "right") {next_state <- state('c4')}
        if (state == state('e3') && action == "down") {next_state <- state('b6')}
        if (state == state('b6') && action == "down") {next_state <- state('e4')}
        if (state == state('e4') && action == "left") {next_state <- state('d2')}
        if (state == state('e4') && action == "right") {next_state <- state('d3')}
        if (state == state('e4') && action == "down") {next_state <- state('b7')}
        if (state == state('c1') && action == "right") {next_state <- state('c2')}
        if (state == state('c2') && action == "right") {next_state <- state('c3')}
        if (state == state('c3') && action == "right") {next_state <- state('e3')}
        if (state == state('c4') && action == "right") {next_state <- state('c5')}
        if (state == state('c5') && action == "down") {next_state <- state('c6')}
        if (state == state('c6') && action == "down") {next_state <- state('e5')}
        if (state == state('e5') && action == "left") {next_state <- state('d3')}
        if (state == state('e5') && action == "right") {next_state <- state('d4')}
        if (state == state('e5') && action == "down") {next_state <- state('c7')}
        if (state == state('c7') && action == "down") {next_state <- state('c8')}
        if (state == state('d1') && action == "right") {next_state <- state('d2')}
        if (state == state('d2') && action == "right") {next_state <- state('e4')}
        if (state == state('d3') && action == "right") {next_state <- state('e5')}
        if (state == state('d4') && action == "right") {next_state <- state('e2')}
        if (state == state('d5') && action == "down") {next_state <- state('d6')}
        if (state == state('d6') && action == "down") {next_state <- state('d7')}
        if (state == state('a2') && action == "left") {next_state <- state('a1')}
        if (state == state('a3') && action == "left") {next_state <- state('a2')}
        if (state == state('a4') && action == "up") {next_state <- state('e1')}
        if (state == state('a5') && action == "up") {next_state <- state('a4')}
        if (state == state('a6') && action == "up") {next_state <- state('a5')}
        if (state == state('e2') && action == "up") {next_state <- state('a6')}
        if (state == state('e1') && action == "up") {next_state <- state('a3')}
        if (state == state('a7') && action == "up") {next_state <- state('e2')}
        if (state == state('a8') && action == "up") {next_state <- state('a7')}
        if (state == state('b7') && action == "up") {next_state <- state('e4')}
        if (state == state('e4') && action == "up") {next_state <- state('b6')}
        if (state == state('b6') && action == "up") {next_state <- state('e3')}
        if (state == state('e3') && action == "up") {next_state <- state('b5')}
        if (state == state('b5') && action == "up") {next_state <- state('b4')}
        if (state == state('b4') && action == "right") {next_state <- state('b3')}
        if (state == state('b3') && action == "right") {next_state <- state('b2')}
        if (state == state('b2') && action == "right") {next_state <- state('b1')}
        if (state == state('b1') && action == "right") {next_state <- state('e1')}
        if (state == state('c8') && action == "up") {next_state <- state('c7')}
        if (state == state('c7') && action == "up") {next_state <- state('e5')}
        if (state == state('e5') && action == "up") {next_state <- state('c6')}
        if (state == state('c6') && action == "up") {next_state <- state('c5')}
        if (state == state('c5') && action == "left") {next_state <- state('c4')}
        if (state == state('c4') && action == "left") {next_state <- state('e3')}
        if (state == state('e3') && action == "left") {next_state <- state('c3')}
        if (state == state('c3') && action == "left") {next_state <- state('c2')}
        if (state == state('c2') && action == "left") {next_state <- state('c1')}
        if (state == state('d7') && action == "up") {next_state <- state('d6')}
        if (state == state('d6') && action == "up") {next_state <- state('d5')}
        if (state == state('d5') && action == "left") {next_state <- state('e2')}
        if (state == state('d4') && action == "left") {next_state <- state('e5')}
        if (state == state('d3') && action == "left") {next_state <- state('e4')}
        if (state == state('d2') && action == "left") {next_state <- state('d1')}
        if (next_state == state(goal) && state != state(goal)) {
          reward <- 100
        }else{
          reward <- -1
        }
        out <- list(NextState = next_state, Reward = reward)
        return(out)
      }
      agentResult <- RFagentTraining(stationsInd = stationList, actionsInd = allActions,
                                     jourEnv = env_tmp, startPos = routeTmp$起点[1], goalPos = goal_tmp)
      # assemble the results ----
      qvalue <- agentResult[['value']]
      qdemean <- Demean(agentResult[['value']])
      sbjJour <- StationTransfer(routeTmp$当前站台, stationList)
      agentJour <- agentResult[['jour']]
      # check the length of journey ----
      if (length(sbjJour)!=length(agentJour)) {
        agentJour <- NA
        qvalue <- NA
        qdemean <- NA
      }
      jourConver <- mean(agentJour%in%sbjJour)
      resultFrame <- rbind(resultFrame, data.frame("subject"=sbjInd,
                                                   "run"=runInd,
                                                   "journey"=jourInd,
                                                   "sbjRoute"=sbjJour,
                                                   "sbjStep"=length(routeTmp$当前站台),
                                                   "agentRoute"=agentJour,
                                                   "agentStep"=length(agentJour),
                                                   "matchIndex"=jourConver,
                                                   "Qvalue"=qvalue,
                                                   "Qdemean"=qdemean,
                                                   "optJour"=optmalJourney))
    }
    ## clean and output the result ----
    resultFrame <- resultFrame[-1,] %>%
      readr::write_csv(., file = outFile_tmp)
    ## give feedback 
    paste0('subject ', sbjInd, ' run ', runInd, ' work finished!') %>%
      print()
  }
}


