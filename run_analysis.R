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
  # filter features for only mean() and std()
  mean_std.features <- features %>%
    filter(grepl("mean\\(\\)|std\\(\\)",V2))

  ## Get test data
  # get subject_test and set column name
  subject_test <- read.table(paste0(wd,"/test/subject_test.txt")) %>%
    setnames("subject")
  # get y_test and set column name
  y_test <- read.table(paste0(wd,"/test/y_test.txt")) %>%
    setnames("activityId")
  # get X_test
  X_test <- read.table(paste0(wd,"/test/X_test.txt"))
  
  ## Get train data
  # get subject_train and set column name
  subject_train <- read.table(paste0(wd,"/train/subject_train.txt")) %>%
    setnames("subject")
  # get y_train and set column name
  y_train <- read.table(paste0(wd,"/train/y_train.txt")) %>%
    setnames("activityId")
  # get X_train
  X_train <- read.table(paste0(wd,"/train/X_train.txt"))

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
    # Get mean and std feature descriptions
    merge(mean_std.features, by.x = "featureid", by.y = "V1") %>%
    # Uses descriptive activity names to name the activities in the data set
    merge(activity_labels) %>%
    # separate the feature description into measurement, type and axis
    separate('V2', c("measurement", "measurementType", "axis"), sep="-", extra="drop") %>%
    # Extracts only the measurements on the mean and standard deviation for each measurement.
    select(subject, activity, measurement, measurementType, axis, result) %>%
    # Order
    arrange(subject, activity, measurement, measurementType, axis)
  
  # aggregate numeric columns by activity and subject, removing NA values
  aggdata <-test_and_train %>%
    # group by subject, activity measurement, measurementType and axis
    group_by(subject, activity, measurement, measurementType, axis) %>%
    # summarize by the mean of the result
    summarize(mean = mean(result))
  
  # return a list of 2 elements: the tidy dataset and it's aggregate
  list(test_and_train, aggdata)
  
}