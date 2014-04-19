#Step 0: Checking Step
list.files("./")

#Step 1: Merges the training and the test sets to create one data set
features <- read.table("./features.txt")

##1.1 Read test set
X <- read.table("./test/X_test.txt", col.names = features[,2])
Xsubjects <- read.table("./test/subject_test.txt", col.names = c("subject_id"))
Xtest <- cbind(Xsubjects,X)

##1.2 Read train set
X <- read.table("./train/X_train.txt", col.names = features[,2])
Xsubjects <- read.table("./train/subject_train.txt", col.names = c("subject_id"))
Xtrain <- cbind(Xsubjects,X)

##1.3 Merge train & test sets
data_set <- rbind(Xtrain,Xtest)

##Step 2: Extracts only the measurements on the mean and standard deviation for each measurement
mean_indexes <- grep("mean", features[,2], fixed=TRUE)
std_indexes <- grep("std", features[,2], fixed=TRUE)

data_set2 <- data_set[, c(mean_indexes,std_indexes)]

##Step 3: Uses descriptive activity names to name the activities in the data set
ytrain <- read.table("./train/y_train.txt", col.names = c("activity"))
ytest <- read.table("./test/y_test.txt", col.names = c("activity"))
activity <- rbind(ytrain,ytest)

data_set3 <- cbind(activity,data_set2)

##Step 4: Appropriately labels the data set with descriptive activity names
labels <- read.table("./activity_labels.txt", col.names = c("activity","activity_label"))

data_set4 <- merge(data_set3,labels)

##Step 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject
#tidy <- tapply(data_set4$activity, data_set4$activity_label, FUN=mean)
tidy <- aggregate(.~activity_label+subject_id, data=data_set4,FUN=mean)
tidy

##Final Step: write a file
write.table(tidy,row.names = F, file = "tidy.txt", quote=F, sep="\t")
