## This file extract mean/std data from data collected from 
## the accelerometers from the Samsung Galaxy S smartphone
## and output file contains average of each variable 
## for each activity and each subject

basedir <- getwd()

# if no original data, download from internet
if (!file.exists("Dataset.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "Dataset.zip")
}

# unzip files into temp directory
tempdir <- paste(basedir, "/temp", sep="")
unzip("Dataset.zip", exdir = tempdir)

# set several directory for later use
datadir <- paste(tempdir, "/", list.files(tempdir)[1], sep="")
testdir <- paste(datadir,"/","test",sep="")
traindir <- paste(datadir,"/","train",sep="")

# read tables
train_subject <- read.table(paste(traindir,"/","subject_train.txt",sep=""))
train_y <- read.table(paste(traindir,"/","y_train.txt",sep=""))
train_x <- read.table(paste(traindir,"/","X_train.txt",sep=""))

test_subject <- read.table(paste(testdir,"/","subject_test.txt",sep=""))
test_y <- read.table(paste(testdir,"/","y_test.txt",sep=""))
test_x <- read.table(paste(testdir,"/","X_test.txt",sep=""))

all_subject <- rbind(train_subject, test_subject)
all_x <- rbind(train_x, test_x)
all_y <- rbind(train_y, test_y)

activity_label <- scan(paste(datadir,"/","activity_labels.txt",sep=""),what="character")
activity_label <- activity_label[seq(2,length(activity_label),2)]

features <- scan(paste(datadir,"/","features.txt",sep=""),what="character")
features <- features[seq(2,length(features),2)]

# only reserve features contains "mean" or "std"
reserve_ids <- grep("mean|std",features,ignore.case=TRUE)
features <- features[reserve_ids]

# set column names
colnames(all_subject) <- c("subject")

all_x<-all_x[reserve_ids]
colnames(all_x) <- features

colnames(all_y) <- c("activity")
for(i in 1:6){
  all_y[all_y$activity==i,] <- activity_label[i]
}

# combine all data into one table
all_data <- cbind(all_subject, all_y, all_x)

# do average job
tidydata <- aggregate(all_data[,c(3:ncol(all_data))],
                     by=list(subject=all_data$subject,activity=all_data$activity),
                     FUN=mean, na.rm=TRUE)

# write into output file
write.table(tidydata, file = "tidydata.txt", row.names=FALSE)