This is an implementation of the capstone project for Coursera's 'Getting and Cleaning Data' class. 
This implementation was written by Ryan Fry. 

The script loads the specified Human Activity dataset outlined here: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

It glues togther the columns from the X data set to the column from the Y dataset, and derrives names from the 'features' of the dataset.

It then filters the data down to only mean or standard deviation measurements, and writes the resultant file out to output.csv

It also summarizes the means of each of these columns, and outputs a second dataset called 'outputmeans.csv'. 