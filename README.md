=============================================================
run_analysis.R
=============================================================
Version 1.0
Meaghan Fitzgerald
meaghan@thetopfloorflat.com
Produced for the Coursera course Getting and Cleaning Data offered in association with Johns Hopkins University


The purpose of this R script
=============================================================
Receive the Human Activity Recognition Using Smartphones Dataset (Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto) data set available at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and convert the associated files into a tidy data set that summarizes the means and standard deviation measurements for all 30 subjects across six different activity types.

This README file outlines the analysis and modifications applied to the original data set to result in the tidy.txt file that is produced.

The following actions were taken to tidy this data set:
=============================================================

1) Downloads and unzips the original Human Activity Recognition Using Smartphones Dataset into a "data" folder in the user's working directory (and creates this folder if it does not already exist). The zip file is renamed dataset and once unzipped, all files sit within that dataset folder.

2) Reads the following tables into R in preperation for additional modification. The summary provided below illustrates how the program interprets the significance of each table.

     activity_labels: the table that identifies which numeric activity ID corresponds with which activity.

     features: the table that identifies all of the different measurements taken for each subject and activity.

     subject_test: the list of subject IDs for the measurements taken in the test group.

     X_test: the full table of measurements collected across all features, subjects and activities in the test group.

     y_test: the list of activity IDs for the measurements taken of subjects in the test group.

     subject_train: the list of subject IDs for the measurements taken in the training group.

     X_train: the full table of measurements collected across all features, subjects and activities in the training group.

     y_train: the list of activity IDs for the measurements taken of subjects in the tra ining group.

3) Assigns useful column names to the newly imported tables. The y_test and y_train tables are simply provided with the column heading ActivityID, the subject_test and subject_train tables with the column heading Subject and the activity_labels table with the two column headings ActivityID and ActivityType. The features table data is imported as column headings for the x_test and x_train tables.

4) Creates a smaller data frame of the test data set by first using the grep() function to create a new data frame that includes only the columns in the x_test with the expression "-mean()" in the column heading. Next, this new data frame is modified using cbind and grep once again to append all columns from the original x_test data set with the expression "-std()" in the column heading. Finally, cbind is used to append the relevant subject ID from the subject_test file and the activity ID from the y_test file to the first two columns of the new data frame. This results in a single data frame with the subject, activity ID and all columns with the mean and std data from the original X_test data set. This data frame is called test_MeansStd.

5) Create a smaller data frame for the trial data by repeating the step 4 above with the X_trial, y_trial and subject_trial files. This data frame is called trial_MeansStd.

6) Merges the test_MeansStd data frame and the activity_labels data frame to add an additional column for the 'plain English' activity name. This process is also carried out for the trial_MeansStd data frame.

7) Combines the test_MeansStd and trial_MeansStd into a single data frame using rbind. This new data frame is called mergedData.

8) Melts the mergedData data frame indicating that the Subject and the ActivityType (that is, the friendly, plain English activity name) are the ids and the rest of the columns are the variables. This provides a very long, skinny data set with just columns for the Subject, the Activity Type, the Variables and the values of those variables.

9) Cast the melted mergedData back into a wide data frame, using the dcast function with the "Subject + ActivityType ~ variable" as the casting formula and taking the mean of the variable values. This cast data frame is stored as a new data frame called tidy.

10) Writes the tidy data frame to a file called tidy.txt. The file is located in the dataset folder, located at ./data/dataset.

This process results in:
=============================================================
A data frame with 180 observations of 69 variables.

The 180 observations represent the 6 different activity types undertaken by 30 different subjects (6 * 30 = 180) and the 69 variables include the 66 different mean and std measurements from the original features list, the subject ID, the activity ID and the friendly 'plain English' activity name. 

The each value represents the mean of the mean or standard diviation across all measurements for a particular subject, activity and measurement type.

Notes:
=========
This run_analysis.R script is writen as a function that includes a default value for the online location of the zip file but can receive the argument 'zip' to replace this location if the zip file online moves.
