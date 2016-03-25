# Getting And Cleaning Data - Course Project March 2016

#### _Pete Holberton_

The following decsribes the method uses to convert the data at
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

into a second, independent tidy data set with the average of each variable for each activity and each subject.


### Prerequisites

As per the submission instructions, the code can be run as long as the source data is in your working directory.  The code assumes the source data is stored as a zip file, named *getdata-projectfiles-UCI HAR Dataset.zip*.  If the contents of the file have been extracted, they will be ignored.

If the file does not exist it will be downloaded.

A second file, *samsung_data_summary.txt* will be written to the working directory once the source file has been processed.

At least XXX Mb of disk space is needed to store these two files.

The dplyr library must be installed.


### Creating the dataset



con <- unz("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode <- readLines(con)
close(con)
htmlCode
