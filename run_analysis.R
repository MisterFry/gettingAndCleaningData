################ Getting and cleaning data Capstone project #################

#using the UCI HAR Dataset:
# 1. merge test and train. 
# 2. extract only mean and standard deviation measures
# 3. create descriptive activity names
# 4. Lable the dataset with the descriptive activity names
# 5. Create a second dataset with the average of each activity


# I'm going to need tehse libraries to manipulate the files and data
library(dplyr)

# The test set and the train set are located in the respective directories: test and train. 
# It excludes the Internal Signals sub directory of the dataset. 

# ordinarily, I would download the file manually, and extract it. 
# given the content of the course, I presume they want me to do this via r. 


dataurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# when the files are extracted from the archive, it creates a directory called 
# "UCI HAR Dataset" check if this exists, if it doesn't download the zip file
# from source and extract it. 
if (!file.exists("UCI HAR Dataset")) {
     download.file(dataurl, destfile="hardataset.zip", method="curl")
     #unzip the file
     unzip("hardataset.zip")
}

############## PART 1 - Combine Test and Train ######################

# read the test data 
# the files are in fixed width format, so use dplyr's read.table to extract them

xtest <- read.table('UCI HAR Dataset/test/X_test.txt')
ytest <- read.table('UCI HAR Dataset/test/Y_test.txt')
subtest <- read.table('UCI HAR Dataset/test/subject_test.txt')

#bind them into one table
testdata <- cbind(xtest, ytest, subtest)
rm(xtest)
rm(ytest)
rm(subtest)

#read the train data 

xtrain <- read.table('UCI HAR Dataset/train/X_train.txt')
ytrain <- read.table('UCI HAR Dataset/train/Y_train.txt')
subtrain <- read.table('UCI HAR Dataset/train/subject_train.txt')

#bind them into one table 
traindata <- cbind(xtrain, ytrain, subtrain)
rm(xtrain)
rm(ytrain)
rm(subtrain)

#now Rbind test with train
combinedData <- rbind(testdata, traindata)
rm(traindata)
rm(testdata)

############ 2. extract only mean and standard deviation measures ##############

#extract the column or 'feature' names 
features <- read.table('UCI HAR Dataset/features.txt', stringsAsFactors = FALSE)

#features contains the names of the x test and x train variables
names(combinedData) <- c(features[,2], 'y', 'subject')

## find only mean and std measures 
#define a regx to find mean or std values
regxMeanorStd <- '(-(M|m)ean\\(\\)|-(S|s)td\\(\\))'
#look through the feature names for any measure containing  mean or std. presume I also want 'y' and 'subject
selectedData <- combinedData[grepl(regxMeanorStd, names(combinedData))]
#likely an easier way to do this, but it's only 2 columns
selectedData$y <- combinedData$y
selectedData$subject <- combinedData$subject
#clean up
rm(combinedData)
rm(features)


############ 3. Create meaningful names ####################

# the trouble I have with #3 is that theare already ARE perfectly reasonable names for these variables
# and I've already assigned them. 

#lets remove the () from the names. 
names(selectedData) <- sub('\\(\\)', '', names(selectedData))


########### 4. assign the names to the dataset #############

#uhh... ok. I already did that. 

#write the dataset
write.csv(selectedData, 'output.csv')


########### 5. new dataset with the averages of the previous dataset #############

#exclude 'subject' because it's a factor, and doesn't make sense to mean
meansSelectedData <- rowMeans(selectedData[,1:68])
#give thedataset names
meansSelectedData$names <- names(selectedData)[1:68]
write.csv(meansSelectedData, 'outputmeans.csv')
