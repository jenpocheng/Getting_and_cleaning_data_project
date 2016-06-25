# Code Book
This code book explains how run_analysis.R works.

## Getting Data
1. download the zip file from [the given url](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
2. unzip the zip file to the directory, 'UCI HAR Dataset'.

## Variables
### Used to store data directly read from 'UCI HAR Dataset'
- trainSub   <- read.table("UCI HAR Dataset/train/subject_train.txt")
- trainLabel <- read.table("UCI HAR Dataset/train/y_train.txt")
- trainSet   <- read.table("UCI HAR Dataset/train/X_train.txt")
- testSub    <- read.table("UCI HAR Dataset/test/subject_test.txt")
- testLabel  <- read.table("UCI HAR Dataset/test/y_test.txt")
- testSet    <- read.table("UCI HAR Dataset/test/X_test.txt")
- features   <- read.table("UCI HAR Dataset/features.txt")
- al <- read.table("UCI HAR Dataset/activity_labels.txt")

### Transformed variables
- mergedSet:   row-merges the X_train and X_test data.frames.
- mergedSub:   row-merges the subject_train and subject_test data.frames.
- mergedLabel: row-merges the y_train and y_test data.frames.
- mergedAll:   column-merges the mergedSet, mergedSub, and mergedLabel data.frames.
- selectedAll: extracts the mean and standard deviation columns from mergedAll.
- tidy_data1:  labels the selectedAll with descriptive varaibale names according to al data.frame.
- tidy_data2:  stores the final tidy_data which averages each variables for each activity and each subjects.

## Manipulating data

### 1. Merges the training and the test sets to create one data set. 
```
mergedSet   <- rbind(trainSet, testSet); colnames(mergedSet) <- features[, 2] 
mergedSub   <- rbind(trainSub, testSub); colnames(mergedSub) <- "subject" 
mergedLabel <- rbind(trainLabel, testLabel); colnames(mergedLabel) <- "activity" 
mergedAll   <- cbind(mergedSub, mergedLabel, mergedSet) 
```
### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
```
selectedAll <- mergedAll[, c(c(TRUE, TRUE), grepl("mean|std", features[,2]))]
```
### 3. Uses descriptive activity names to name the activities in the data set and 4. Appropriatedly lables the data set with descriptive variable names. 
```
library(dplyr)
tidy_data1 <- tbl_df(selectedAll) %>%
              mutate(activity = al[match(activity, al[, 1]), 2])
```
### 5. From the data set in setp 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```
tidy_data2 <- tidy_data1 %>% 
              group_by(subject, activity) %>% 
              summarise_each(funs(mean))
```
### 6. Write the tidy_data to file, "tidy_data.txt"
```
write.table(tidy_data2, file = "tidy_data.txt")
```
