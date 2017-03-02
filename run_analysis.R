require(plyr)
#download files
if(!file.exists("./data")){dir.create("./data")}
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL,destfile="./data/Dataset.zip")

unzip(zipfile="./data/Dataset.zip",exdir="./data")

#read feature name
features<-read.table("data/UCI HAR Dataset/features.txt")

#read train data
train_x<-read.table("data/UCI HAR Dataset/train/X_train.txt")

#=========4.Appropriately labels the data set with descriptive variable names.========
#add column name to train_x
colnames(train_x)=features[,2]
#add y axis
train_y<-read.table("data/UCI HAR Dataset/train/Y_train.txt")
#add column name to train_y
colnames(train_y)=c("label_number")
#combine train data
train<-cbind(train_y,train_x)
#create subject colunm of train data set and name it
subject_train<-read.table("data/UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train)=c("subject")
train<-cbind(subject_train,train)

#read test data
test_x<-read.table("data/UCI HAR Dataset/test/X_test.txt")

#=========4.Appropriately labels the data set with descriptive variable names.========
#add column name to test_x
colnames(test_x)=features[,2]
#add y axis
test_y<-read.table("data/UCI HAR Dataset/test/Y_test.txt")
#add column name to test_y
colnames(test_y)=c("label_number")
#combine test data
test<-cbind(test_y,test_x)

#create subject colunm of test data set and name it
subject_test<-read.table("data/UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test)=c("subject")
test<-cbind(subject_test,test)


#===============1.Merges the training and the test sets to create one data set.========
#combine train and test
dt<-rbind(train,test)

#==============2.Extracts only the measurements on the mean and standard deviation for each measurement.======
dt<-dt[,grepl("mean\\(\\)|std\\(\\)|label_number|subject",names(dt))]

#===================3.Uses descriptive activity names to name the activities in the data set=======
labelname<-read.table("data/UCI HAR Dataset/activity_labels.txt")
# add colunm name to labelname
colnames(labelname)=c("number","activity")
#Uses descriptive activity names to name the activities in the data set
dt<-merge(dt,labelname,by.x = "label_number",by.y = "number")

#=========5.creates a second, independent tidy data set with the average of each variable for each activity and each subject.====
dt2 = ddply(dt, c("activity","subject"), numcolwise(mean))
write.table(dt2, file = "averagebySubjectandActivity.txt",row.name=FALSE)



