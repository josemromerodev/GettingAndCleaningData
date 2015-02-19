# Packages
library(plyr)

# String Constants
dataPath <- "data/UCI\ HAR\ Dataset/"
activityLabelsFileName <- paste0(dataPath, "activity_labels.txt")
featuresFileName <- paste0(dataPath, "features.txt")
XTrainFileName <- paste0(dataPath, "train/X_train.txt")
YTrainFileName <- paste0(dataPath, "train/y_train.txt")
SubjectTrainFileName <- paste0(dataPath, "train/subject_train.txt")
XTestFileName <- paste0(dataPath, "test/X_test.txt")
YTestFileName <- paste0(dataPath, "test/y_test.txt")
SubjectTestFileName <- paste0(dataPath, "test/subject_test.txt")

# Reads the Features Table and removes dashes and parenthesis
readAndCleanFeatures <- function() {
        df <- read.table(featuresFileName, 
                   col.names = c("index", "featureName"))
        f <- gsub("-", ".", gsub("\\(\\)", "", df$featureName))
        f <- gsub("\\.mean", "Mean", f)
        f <- gsub("\\.std", "Std", f)
        f <- gsub("\\.X", "X", f)
        f <- gsub("\\.Y", "Y", f)
        f <- gsub("\\.Z", "Z", f)
        f
}

# Read X data
getXData <- function(f) {
        x_train <- read.table(XTrainFileName, col.names = f)
        x_test <- read.table(XTestFileName, col.names = f)
        rbind(x_train, x_test)
}

# Read Y data
getYData <- function() {
        y_train <- read.table(YTrainFileName)
        y_test <- read.table(YTestFileName)
        rbind(y_train, y_test)
}

# Read Subject data
getSubjectData <- function() {
        subject_train <- read.table(SubjectTrainFileName)
        subject_test <- read.table(SubjectTestFileName)
        rbind(subject_train, subject_test)
}

# Extracts the Mean and Std columns from the data frame
extractMeanAndStd <- function(f, x) {
        colToKeep <- append(grep("Mean", f, value = TRUE),
                            grep("Std", f, value = TRUE))
        colToKeep <- colToKeep[!grepl("MeanFreq", colToKeep)]
        x[ , colToKeep[!grepl("angle", colToKeep)]]
}

# Creates a tidy data frame getting the mean of every column for each subject
# and activity
createTidySet <- function(x) {
        subjectFactors <- unique(x$subject)
        for(factor in subjectFactors) {
                x.subset <- subset(x, x$subject == factor)
                temp <- ddply(x.subset, .(subject, activityName), 
                              numcolwise(mean))
                if(exists("tidy")) {
                        tidy <- rbind(tidy, temp)
                } else {
                        tidy <- temp
                }
        }
        tidy <- tidy[order(tidy$subject, tidy$activityName), ]
        tidy
}

# Read Activity Labels
activity_labels <- read.table(activityLabelsFileName, 
                              col.names = c("classLabel", "activityName"))

# Read and Clean the Features Table
features <- readAndCleanFeatures()

# 1. Merges the training and the test sets to create one data set.
x_all_columns <- getXData(features)
y_all_columns <- getYData()
subject_row <- getSubjectData()

# 2. Extracts only the measurements on the mean and standard deviation for 
#    each measurement. 
x <- extractMeanAndStd(features, x_all_columns)
colnames(y_all_columns)[1] <- "activityName"
y <- as.vector(sapply(y_all_columns$activityName, 
                      function(rowItem){rowItem=activity_labels[rowItem,2]}))

# 3. Uses descriptive activity names to name the activities in the data set
y <- as.factor(y)
x <- cbind(y, x)
x <- cbind(subject_row, x)

# 4. Appropriately labels the data set with descriptive variable names. 
colnames(x)[1] <- "subject"
colnames(x)[2] <- "activityName"

# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.
tidy <- createTidySet(x)
write.table(tidy, file="tidy.txt", row.name=FALSE)
