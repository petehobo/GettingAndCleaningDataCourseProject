
## DEBUG
rm(list=ls())
## END DEBUG



## Required libraries
library(dplyr)

## Constants

sourceUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
sourceFileName <- "getdata-projectfiles-UCI HAR Dataset.zip"

## Utility functions

downloadData <- function() {
  if (!file.exists(sourceFileName)) {
    download.file(sourceUrl, destfile=sourceFileName, method="curl")
    dateDownloaded <- date()
  } else {
    dateDownloaded <- file.info(sourceFileName)$ctime
  }
  return(dateDownloaded)
}

combineData <- function(x, y, subject) {
  return( cbind(x, y, subject) )
}

loadDataset <- function(dataset) {
  print(paste("Loading", dataset, "data"))
  datasetDirectory <- paste0("UCI HAR Dataset/", dataset, "/")

  xFile <- unz(sourceFileName, paste0(datasetDirectory, "X_", dataset, ".txt"))
  yFile <- unz(sourceFileName, paste0(datasetDirectory, "y_", dataset, ".txt"))
  subjectFile <- unz(sourceFileName, paste0(datasetDirectory, "subject_", dataset, ".txt"))

  return( combineData(read.table(xFile), read.table(yFile), read.table(subjectFile)) )
}

loadXFeatureNames <- function() {
  featuresFile <- unz(sourceFileName, "UCI HAR Dataset/features.txt")
  features <- read.table(featuresFile, stringsAsFactors = FALSE)
  result <- features[,2]
  return(result)
}

getFeatureNames <- function() {
  xNames <- loadXFeatureNames()
  xNames <- tolower(xNames)
  xNames <- gsub("[^a-zA-Z0-9]", "", xNames)
  
  return( combineData(t(xNames), c("y"), c("subject")) )
}

## Main functionality

dateDownloaded <- downloadData()
print(paste("Using file downloaded", dateDownloaded))

allData <- data.frame() # Create empty variable to hold the data (for re-runnability)

## Load and combine data from the two sets of data
for (dataset in c("train", "test")) {
  allData <- rbind(allData, loadDataset(dataset))
}

## Load the column names
names(allData) <- getFeatureNames()

head(allData)
tail(allData)
