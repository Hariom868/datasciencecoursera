library(data.table)
library(dplyr)
ytest <- read.table("y_test.txt", header = F)
ytrain <- read.table("y_train.txt", header = F)
xtest <- read.table("X_test.txt", header = F)
xtrain <- read.table("X_train.txt", header = F)
SubjectTest <- read.table("subject_test.txt", header = F)
SubjectTrain <- read.table("subject_train.txt", header = F)
ActivityLabels <- read.table("activity_labels.txt", header = F)
FeaturesNames <- read.table("features.txt", header = F)
FeaturesData <- rbind(xtest, xtrain)
SubjectData <- rbind(SubjectTest, SubjectTrain)
ActivityData <- rbind(ytest, ytrain)
names(ActivityData) <- "Activityid"
names(ActivityLabels) <- c("Activityid", "Activity")
Activity <- left_join(ActivityData, ActivityLabels, "Activityid")[, 2]
names(SubjectData) <- "Subject"
names(FeaturesData) <- FeaturesNames$V2
DataSet <- cbind(SubjectData, Activity)
DataSet <- cbind(DataSet, FeaturesData)
subFeaturesNames <- FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
DataNames <- c("Subject", "Activity", as.character(subFeaturesNames))
DataSet <- subset(DataSet, select=DataNames)
names(DataSet)<-gsub("^t", "time", names(DataSet))
names(DataSet)<-gsub("^f", "frequency", names(DataSet))
names(DataSet)<-gsub("Acc", "Accelerometer", names(DataSet))
names(DataSet)<-gsub("Gyro", "Gyroscope", names(DataSet))
names(DataSet)<-gsub("Mag", "Magnitude", names(DataSet))
names(DataSet)<-gsub("BodyBody", "Body", names(DataSet))
SecondDataSet<-aggregate(. ~Subject + Activity, DataSet, mean)
SecondDataSet<-SecondDataSet[order(SecondDataSet$Subject,SecondDataSet$Activity),]
write.table(SecondDataSet, file = "tidydata.txt",row.name=FALSE)
