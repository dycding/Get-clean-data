# Getting and Cleaning Data - Assignment

* This is the final project for the Coursera course: Getting and Cleaning Data
* The `assignment.R` script does the following data processing:

1. Download and unzip the dataset if not exists in the working directory
2. Load activity, feature information, and training/testing (including X, y, and subject) datasets
3. Merge both training and testing datasets and combine with activity, subject information
4. Select the desired (subject, -mean(), -std() and activity) columns
5. Use descriptive activity names for "activity" column and convert it into factors
6. Convert "subject" column into factors
7. Rename the columns with descriptive variable names
8. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
9. The final results are shown in "tidyData2.txt"