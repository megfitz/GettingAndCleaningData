## A function for the programming assignment of the Coursera 
## Getting and Cleaning Data Course. This function should receive a
## URL for a zip file with Samsung Galaxy accelerometer data and 
## convert the information included into a tidy data set.

run_analysis <- function(zip = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip") {
	
	## Download and unzip the files into a dataset folder
	if(!file.exists("data")){dir.create("./data")}
	download.file(zip,destfile="./data/dataset.zip")
	unzip("./data/dataset.zip", exdir = "./data/dataset")

	## Read as tables and assign variables to all of the relevant data sets within the folder
	activity_labels <- read.table("./data/dataset/UCI HAR Dataset/activity_labels.txt")
	features <- read.table("./data/dataset/UCI HAR Dataset/features.txt")
	subject_test <- read.table("./data/dataset/UCI HAR Dataset/test/subject_test.txt")
	X_test <- read.table("./data/dataset/UCI HAR Dataset/test/X_test.txt")
	y_test <- read.table("./data/dataset/UCI HAR Dataset/test/y_test.txt")
	subject_train <- read.table("./data/dataset/UCI HAR Dataset/train/subject_train.txt")
	X_train <- read.table("./data/dataset/UCI HAR Dataset/train/X_train.txt")
	y_train <- read.table("./data/dataset/UCI HAR Dataset/train/y_train.txt")

	## Assign the correct and tidy column names to each data set
	colnames(X_test) <- as.character(features[,2])
	colnames(X_train) <- as.character(features[,2])
	colnames(y_test) <- "ActivityID"
	colnames(y_train) <- "ActivityID"
	colnames(subject_test) <- "Subject"
	colnames(subject_train) <- "Subject"
	colnames(activity_labels) <- c("ActivityID", "ActivityType")

	## Create a smaller dataframe of TEST data with the relevant columns for
	## mean and std plus append the subject and activity labels.

	test_MeansStd <- X_test[,grep("-mean\\(\\)", colnames(X_test))]
	test_MeansStd <- cbind(test_MeansStd, X_test[,grep("-std\\(\\)", colnames(X_test))]) ## Makes a data frame with the means and Std data by appending the Std columns from the original data frame to the means data frame
	test_MeansStd <- cbind("ActivityID" = y_test, test_MeansStd) ## Adds the activity ID to the first column
	test_MeansStd <- cbind(subject_test, test_MeansStd) ## Adds the subject ID to the first column

	## Create a smaller dataframe of TRAIN data with the relevant columns for
	## mean and std plus append the subject and activity labels.

	train_MeansStd <- X_train[,grep("-mean\\(\\)", colnames(X_train))]
	train_MeansStd <- cbind(train_MeansStd, X_train[,grep("-std\\(\\)", colnames(X_train))]) ## Makes a data frame with the means and Std data by appending the Std columns from the original data frame to the means data frame
	train_MeansStd <- cbind("ActivityID" = y_train, train_MeansStd) ## Adds the activity ID to the first column
	train_MeansStd <- cbind(subject_train, train_MeansStd) ## Adds the subject ID to the first column

	## Merge the activityID/y data sets with the activity labels and rename them properly

	test_MeansStd <- merge(test_MeansStd,activity_labels,by.x="ActivityID", by.y="ActivityID", all=TRUE)
	train_MeansStd <- merge(train_MeansStd,activity_labels,by.x="ActivityID", by.y="ActivityID", all=TRUE)


	## Binds the two new, smaller data frames together.

	mergedData <- rbind(train_MeansStd, test_MeansStd)

	## Melts the mergedData into a new data frame with Subject and ActivityKind as the IDs
	## then recasts that data by the subject and activity type.

	molton <- melt(mergedData,id=c("Subject", "ActivityType"))
	tidy <- dcast(molton, Subject + ActivityType ~ variable, mean)

	write.table(tidy, file = "./data/dataset/tidy.txt")
}