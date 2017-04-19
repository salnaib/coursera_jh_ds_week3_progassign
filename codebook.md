This codebook explains the variables created and used to return a tidy dataset.

The run_analysis.R file has a function called run_analysis with one input dir

The dir input is the directory name of the dataset to be tidied. For example run_analysis("UCI HAR Dataset").

Libraries used:
dplyr
data.table
tidyr

Variables:

wd: The working directory concatenated with the dir variable passed in to create the path for the dataset to be cleaned
activity_labels: The df read from activity_labels.txt

features: The df read from features.txt

mean_std.features: The features df filtered for mean() and std()

subject_test: The df read from test/subject_test.txt and the column name is changed to "subject"

y_test: The df read from test/y_test.txt and the column name is changed to "activity"

X_test: The df read from test/X_test.txt

subject_train: The df read from train/subject_train.txt and the column name is changed to "subject"

y_train: The df read from train/y_train.txt and the column name is changed to "activity"

X_train: The df read from train/X_train.txt

activity: The df of combined y_train and y_test, with y_train rows first

subject: The df of combined subject_train and subject_test, with subject_train rows first

test_and_train: The tidy dataset from doing the following steps:
1. row bind the X_train and X_test
2. column bind the subject to the result of 1
3. column bind the activity to the result of 2
4. convert the columns of feature types to one column (gather on feature)
5. create featureid column from the feature column (remove the "V")
6. merge with the mean_std.features to get filter for mean() and std() features and get the feature names
6. merge the activity_labels to get the labels
7. Separates the features by "-" into 3 columns: measurement, measurementType and axis
8. select and name the relevant columns: subject, activity, measurement, measurementType and axis

aggdata: Aggregate the test_and_train to get the mean of the results by grouping on subject, activity and variable

