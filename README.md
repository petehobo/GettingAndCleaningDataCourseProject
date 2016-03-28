# Getting And Cleaning Data
## Course Project March 2016

#### _Pete Holberton_

The following decsribes the method uses to convert the data at
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

into a second, independent tidy data set with the average of each variable for each activity and each subject.


### Prerequisites

As per the submission instructions, the code can be run as long as the source data is in your working directory.  The code assumes the source data is stored as a zip file, named *getdata-projectfiles-UCI HAR Dataset.zip*.  If the contents of the file have been extracted, they will be ignored.

If the file does not exist it will be downloaded.

A second file, *samsung_data_summary.txt* will be written to the working directory once the source file has been processed.

At least 61Mb of disk space is needed to store these two files.

The dplyr library must be installed to run the code.


### Creating the dataset

To create the output file, set R's working directory to a directory containing the *getdata-projectfiles-UCI HAR Dataset.zip*, eg

```R
setwd("e:/tmp")
```

If the file does not exist in the working directory, it will be downloaded.

Run the [*run_analysis.R*](run_analysis.R) script.  This will create a file called *samsung_data_summary.txt* in the working directory.


### Code Book

A code book describing each variable and its values can be found [here](CodeBook.md).
