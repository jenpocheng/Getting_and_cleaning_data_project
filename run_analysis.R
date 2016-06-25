# 1.Merges the training and the test sets to create one data set. 
trainSub   <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainLabel <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSet   <- read.table("UCI HAR Dataset/train/X_train.txt")
testSub    <- read.table("UCI HAR Dataset/test/subject_test.txt")
testLabel  <- read.table("UCI HAR Dataset/test/y_test.txt")
testSet    <- read.table("UCI HAR Dataset/test/X_test.txt")

mergedSet  <- rbind(trainSet, testSet)
features   <- read.table("UCI HAR Dataset/features.txt")
colnames(mergedSet) <- features[, 2]
rm(trainSet, testSet)

mergedSub <- rbind(trainSub, testSub)
colnames(mergedSub) <- "subject"
rm(trainSub, testSub)

mergedLabel <- rbind(trainLabel, testLabel)
colnames(mergedLabel) <- "activity"
rm(trainLabel, testLabel)

mergedAll <- cbind(mergedSub, mergedLabel, mergedSet)
rm(mergedSub, mergedLabel, mergedSet)

# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
selectedAll <- mergedAll[, c(c(TRUE, TRUE), grepl("mean|std", features[,2]))]
rm(mergedAll, features)

# 3.Uses descriptive activity names to name the activities in the data set.
# 4.Appropriatedly lables the data set with descriptive variable names. 
al <- read.table("UCI HAR Dataset/activity_labels.txt")
library(dplyr)
tidy_data1 <- tbl_df(selectedAll) %>%
              mutate(activity = al[match(activity, al[, 1]), 2])
rm(al, selectedAll)

# 5.From the data set in setp 4, creates a second, independent tidy data set with the 
#   average of each variable for each activity and each subject.
tidy_data2 <- tidy_data1 %>% 
              group_by(subject, activity) %>% 
              summarise_each(funs(mean))

write.table(tidy_data2, file = "tidy_data.txt")
