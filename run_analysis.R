library(dplyr)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "rawData.zip"

# Check whether the file exists or not
if (!file.exists(fileName)) {
    download.file(fileUrl, fileName, method = 'curl')
}

# Check whether the file is unzipped or not
if (!file.exists("UCI HAR Dataset")) {
    unzip(fileName)
}

# Read the data
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activityLabel", "activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("featureLabel", "feature"))
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$feature)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activityLabel")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$feature)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activityLabel")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

# Merge training set and test set
X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)

# Merge X, y, and subject to one table
merged <- cbind(subject, X, y)

# Extracts only the mean and standard deviation
# The -mean() and -std() in the raw data correspond to .mean.. and .std..
tidyData <- select(merged, subject, contains(c(".mean..", ".std..")), "activityLabel")

# Use descriptive activity names and convert into factors
tidyData$activityLabel <- as.factor(activities[tidyData$activityLabel, 2])

# Convert subject column into factors
tidyData$subject <- as.factor(tidyData$subject)

# Use descriptive variable names
name_array <- names(tidyData)
name_array[length(name_array)] <- "activity"
name_array <- gsub("[.]", "", name_array)
name_array <- gsub("mean", "Mean", name_array)
name_array <- gsub("std", "Std", name_array)
name_array <- gsub("Acc", "Accelerometer", name_array)
name_array <- gsub("Gyro", "Gyroscope", name_array)
name_array <- gsub("Mag", "Magnitude", name_array)
name_array <- gsub("BodyBody", "Body", name_array)
name_array <- gsub("^t", "time", name_array)
name_array <- gsub("^f", "frequency", name_array)
names(tidyData) <- name_array

# Creates a second, independent tidy data set with the average
# of each variable for each activity and each subject
tidyData2 <- group_by(tidyData, subject, activity)
tidyData2 <- summarise_all(tidyData2, list(mean = mean))
names(tidyData2) <- gsub("_mean", "", names(tidyData2))
write.table(tidyData2, "tidyData2.txt", row.name=FALSE)
