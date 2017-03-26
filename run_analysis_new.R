library(dplyr)
library(data.table)
library(tidyr)

run_analysis <- function(dir) {
  wd <- paste0(getwd(),"/",dir)
  # get activity labels and sets column names
  activity_labels <- read.table(paste0(wd,"/activity_labels.txt")) %>%
    setnames(c("activityId","activity"))
  # get features
  features <- read.table(paste0(wd,"/features.txt"))
  #features <- paste0(features[,1],features[,2])
  angle_features_separated <- features %>%
    filter(!(substr(V2, 1, 1) == "t" | substr(V2, 1, 1) == "f")) %>%
    separate(V2, into = c("temp1","variable_type"), sep = "angle", remove = FALSE, fill = "right") %>%
    mutate(inputs = gsub("\\(", "", variable_type)) %>%
    mutate(inputs = gsub("\\)", "", inputs)) %>%
    separate(inputs, into = c("angle_input1","angle_input2"), sep = ",", remove = FALSE, fill = "right") %>%
    mutate(variable_type = "angle") %>%
    select(V1, variable_type, angle_input1, angle_input2)
  
  tf_features_separated <- features %>%
    filter(substr(V2, 1, 1) == "t" | substr(V2, 1, 1) == "f") %>%
    separate(V2, into = c("reader","measure", "axis"), sep = "-", remove = FALSE, fill = "right") %>%
    mutate(variable_type = substr(reader,1,1), readerData = substr(reader,2,length(reader))) %>%
    select(V1, variable_type, readerData, measure, axis)
  
  features_separated <- tf_features_separated %>%
    merge(angle_features_separated, by = c("V1","variable_type"), all.x = TRUE, all.y = TRUE)
  
  ## Get test data
  # get subject_test and set column name
  subject_test <- read.table(paste0(wd,"/test/subject_test.txt")) %>%
    setnames("subject")
  # get y_test and set column name
  y_test <- read.table(paste0(wd,"/test/y_test.txt")) %>%
    setnames("activityId")
  # get X_test
  X_test <- read.table(paste0(wd,"/test/X_test.txt"))
  # set column names and bind the y_test and subject_test data
  #X_test %>%
  #  setnames(as.character(features))
  
  
  ## Get train data
  # get subject_train and set column name
  subject_train <- read.table(paste0(wd,"/train/subject_train.txt")) %>%
    setnames("subject")
  # get y_train and set column name
  y_train <- read.table(paste0(wd,"/train/y_train.txt")) %>%
    setnames("activityId")
  # get X_train
  X_train <- read.table(paste0(wd,"/train/X_train.txt"))
  # set column names and bind the activityid and subjectid data
  #X_train %>%
  #  setnames(as.character(features))
  
  # row bind activities of train and test (train first)
  activity <- rbind(y_train,y_test)
  
  # row bind subjects of train and test (train first)
  subject <- rbind(subject_train,subject_test)
  
  # Merges the training and the test sets to create one data set.
  test_and_train <- rbind(X_train, X_test) %>%
    # adds subject column to data set
    cbind(subject) %>%
    # adds activity column to data set
    cbind(activity) %>%
    # Convert columns of observations to one column
    gather(feature, result, -c(subject, activityId)) %>%
    # Get feature id
    mutate(featureid = as.integer(gsub("[^0-9]","", feature))) %>%
    # Get feature descriptions
    merge(features_separated, by.x = "featureid", by.y = "V1") %>%
    # Uses descriptive activity names to name the activities in the data set
    merge(activity_labels) %>%
    # Extracts only the measurements on the mean and standard deviation for each measurement.
    select(subject, activity, variable_type, readerData, measure, axis, angle_input1, angle_input2, result) #%>%
  # Extracts only the measurements on the mean and standard deviation for each measurement.
  #select(matches("mean|std")) %>%
  
  # aggregate numeric columns by activity and subject, removing NA values
  aggdata <-aggregate(test_and_train[,sapply(test_and_train, is.numeric)], by=list(test_and_train$activity,test_and_train$subject), FUN=mean, na.rm=TRUE)
  
  # return a list of 2 elements: the tidy dataset and it's aggregate
  list(test_and_train, aggdata)
  
}