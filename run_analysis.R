setwd("C:/Users/Minhtam/Documents/My Classes/GetData/pj2")

# Load test data
test_y = read.delim("data/UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE)
test_X = read.delim("data/UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
test_subject = read.delim("data/UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

# Load train data
train_y = read.delim("data/UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)
train_X = read.delim("data/UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
train_subject = read.delim("data/UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

# Load features to name variables
features = read.delim("data/UCI HAR Dataset/features.txt", header=FALSE, stringsAsFactor=FALSE)
vars = features[,1]
colnames(test_X) = vars
colnames(train_X) = vars

# Merge the test and training data
m_all = merge(test_X, train_X, all=T)
m_subject = merge(test_subject, train_subject, all=T)
m_y = rbind(test_y, train_y)

# Extracts only the measurements on the mean and standard deviation for each measurement
cols = grep("mean|std", names(m_all))
m_all = m_all[,cols]

# Name the activities in the data set
activity_labels = read.delim("data/UCI HAR Dataset/activity_labels.txt", header=FALSE, sep="")
m_activity = activity_labels[m_y$V1, 2]

# Labels the data set with descriptive variable names
m_all = cbind(m_subject, m_all)
m_all = cbind(m_activity, m_all)

vars = names(m_all)
vars = sub("m_activity", "activity", vars)
vars = sub("V1", "subject", vars)
vars = gsub("mean", "Mean", vars)
vars = gsub("std", "Std", vars)
vars = gsub("[0-9]+ ", "", vars)
vars = gsub("[-(,)]", "", vars)
names(m_all) = vars

# Creates a tidy data set with the average of each variable for each activity and each subject.
m_all = aggregate(m_all[,3:81], by=list(activity=m_all$activity, subject=m_all$subject), FUN=mean, nr.rm=TRUE)
write.table(m_all, "uci_har_dataset.txt", sep="\t", row.names=FALSE)

