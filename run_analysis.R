library(dplyr)

#Downloads file if it does not exist in current directory
if(!file.exists("UCIdata.zip")){
    download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","UCIdata.zip") 
}

#Unzips file if it is not in the current directory
if(!file.exists("UCI HAR Dataset")){
    unzip("UCIdata.zip", files = NULL, exdir=".")
}

#Sets directory to UCI HAR dataset
og_dir <- getwd()
dir <- paste(og_dir,"/UCI HAR Dataset",sep = '')
setwd(dir)

##Gets test data and training data
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt",col.names = c("activity","activity_label"))
y_test <- read.table("test/y_test.txt")
colnames(y_test) = "activity"
x_test <- read.table("test/x_test.txt")
colnames(x_test) = features[,2]
subject_test <- read.table("test/subject_test.txt")
colnames(subject_test) = "subject"
test_data = cbind(y_test,subject_test,x_test)

y_train <- read.table("train/y_train.txt")
colnames(y_train) = "activity"
x_train <- read.table("train/x_train.txt")
colnames(x_train) = features[,2]
subject_train <- read.table("train/subject_train.txt")
colnames(subject_train) = "subject"
train_data = cbind(y_train, subject_train,x_train)

##1 Merges the training and the test sets to create one data set.

total_data <- rbind(train_data,test_data)

##2 Extracts only the measurements on the mean and standard deviation for each measurement.

mean_std_data <- total_data[,grepl("mean()",colnames(total_data),fixed = TRUE) | 
                                grepl("std()",colnames(total_data),fixed = TRUE) | 
                                grepl("activity",colnames(total_data),fixed = TRUE) | 
                                grepl("subject",colnames(total_data),fixed = TRUE)]

##3 Uses descriptive activity names to name the activities in the data set

merged_data <- merge(mean_std_data,activity_labels,by.x = "activity",by.y = "activity",sort = FALSE)
merged_data$activity <- as.factor(merged_data$activity_label)

merged_data <- merged_data[,-69]

##4 Appropriately labels the data set with descriptive variable names.

colnames(merged_data)<- gsub("^t","Time",colnames(merged_data))
colnames(merged_data)<- gsub("^f","Frequency",colnames(merged_data))
colnames(merged_data)<- gsub("Acc","Accelerometer", colnames(merged_data))
colnames(merged_data)<- gsub("Gyro","Gyroscope", colnames(merged_data))
colnames(merged_data)<- gsub("-","", colnames(merged_data))
colnames(merged_data)<- gsub("std","STD", colnames(merged_data))
colnames(merged_data)<- gsub("mean","Mean", colnames(merged_data))
colnames(merged_data)<- gsub("Mag","Magnitude", colnames(merged_data))

##5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

final_data <- merged_data %>% group_by(activity,subject)%>% summarize_all(mean)

write.table(final_data, "TidyData.txt", row.name=FALSE)
setwd(og_dir)
