This repoistory contains the code to analyze data from the HCI HAR Dataset that can be found in http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The reposity contains:
1. README.md file
  Read me file that explains the repository and contents

2. run_analysis.R
  Contains the function run_analysis(dir), where dir is the name of the directory in the current working directory that contains the files for the analysis. For example, if the files were in the directory, "UCI HAR Dataset", then the function call run_analysis("UCI HAR Dataset") would return a list of 2 elements:
  The first is the tidy data set based on the following instructions:
    a. Merges the training and the test sets to create one data set.
    b. Extracts only the measurements on the mean and standard deviation for each measurement.
    c. Uses descriptive activity names to name the activities in the data set
    d. Appropriately labels the data set with descriptive variable names.
  The second element contains the aggregated dataset based on the following instruction:
    e. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

3. run_analysis.html
  This is the resulting html document from an r markdown that explains each step and the variables used in the analysis
  
4. codebook.md
  This codebook references the run_analysis.html document above.