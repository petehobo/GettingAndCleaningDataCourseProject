## Required libraries
library(dplyr)


## ----------------------------------- Config ---------------------------------- ##
sourceUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
sourceFileName <- "getdata-projectfiles-UCI HAR Dataset.zip"


## ---------------------------- Utility functions ------------------------------ ##

# Download the source data, if it isn't present in the working directory
downloadData <- function() {
  if (!file.exists(sourceFileName)) {
    download.file(sourceUrl, destfile=sourceFileName, method="curl")
    dateDownloaded <- date()
  } else {
    dateDownloaded <- file.info(sourceFileName)$ctime
  }
  return(dateDownloaded)
}

# Merge data, activity and subject data in a consistent order
# (used for both data and the corresponding labels)
combineData <- function(data, activity, subject) {
  return( cbind(subject, activity, data) )
}

# Load the and combine the three files associated with a dataset (train or test data)
loadDataset <- function(dataset) {
  print(paste("Loading", dataset, "data"))
  datasetDirectory <- paste0("UCI HAR Dataset/", dataset, "/")

  xFile <- unz(sourceFileName, paste0(datasetDirectory, "X_", dataset, ".txt"))
  activityFile <- unz(sourceFileName, paste0(datasetDirectory, "y_", dataset, ".txt"))
  subjectFile <- unz(sourceFileName, paste0(datasetDirectory, "subject_", dataset, ".txt"))

  result = combineData(read.table(xFile), read.table(activityFile), read.table(subjectFile))
  return(result)
}

# Load the feature names from the features.txt file
loadXFeatureNames <- function() {
  featuresFile <- unz(sourceFileName, "UCI HAR Dataset/features.txt")
  features <- read.table(featuresFile, stringsAsFactors = FALSE)
  result <- features[,2]
  return(result)
}

# Format the feature names as recommended in the lectures (lower case, alphanumeric) 
getFeatureNames <- function() {
  xNames <- loadXFeatureNames()
  xNames <- tolower(xNames)
  xNames <- gsub("[^a-z0-9]", "", xNames)
  
  return( combineData(t(xNames), c("activityid"), c("subject")) )
}

# Load the lookup table to map the activity IDs to descriptions
getActivityLabels <- function() {
  activityLabelFile <- unz(sourceFileName, "UCI HAR Dataset/activity_labels.txt")
  labels <- read.table(activityLabelFile, stringsAsFactors = TRUE)
  names(labels) = c("activityid", "activityname")
  return(labels)
}


## --------------------------- Main functionality ------------------------------ ##

# Download the file (if necessary)
dateDownloaded <- downloadData()
print(paste("Using file downloaded", dateDownloaded))

# Merge the training and the test sets to create one data set
rawData <- data.frame() # Create empty variable to hold the data (for re-runnability, since we're appending)
for (dataset in c("train", "test")) {
  rawData <- rbind(rawData, loadDataset(dataset))
}

# Appropriately label the data set with descriptive variable names
featureNames <- getFeatureNames()
names(rawData) <- featureNames

# Load the lookup table to map the activity IDs to descriptions
activityLabels <- getActivityLabels()

# Use descriptive activity names to name the activities in the data set
dataWithActivityNames <- inner_join(activityLabels, rawData, by = "activityid")

# Extract only the measurements on the mean and standard deviation for each measurement
# and the activity name and subject, for grouping.  Note that this leaves the meanFreq()
# columns - it's unclear from the instructions whether these are required
featuresOfInterest <- grep("activityname|subject|mean|std", names(dataWithActivityNames), ignore.case = TRUE, value = TRUE)
featuresOfInterest <- grep("^angle", featuresOfInterest, ignore.case = TRUE, value = TRUE, invert = TRUE)

# Grab only the columns of interest from the data
rawDataExtract <- dataWithActivityNames[, featuresOfInterest]

# Create a second, independent tidy data set with the average of each variable for each activity and each subject
summary <- rawDataExtract %>%
  group_by(activityname, subject) %>%
  summarize_each(funs(mean))

# Write the results to file
write.table(summary, "uci-har-summary.txt", row.name=FALSE)

## ----------------------------------------------------------------------------- ##
