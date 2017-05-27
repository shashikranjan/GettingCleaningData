# This assumes that the relvant data files have been downloaded and 
# saved into a "data" folder in the current working directory

library(data.table)
library(reshape2)

########## EXTRACT ONLY THE MEAN AND STD MEASUREMENTS ##############
features_list <- fread( "./data/features.txt")
featuresWanted <- grep(".*mean.*|.*std.*", features_list$V2)
featuresWanted.headers <- features_list[ featuresWanted, 2]


########### CREATE THE MERGED DATASET ##############

# Read the training and test datasets and corresponding subjects and activity labels
# We only read the columns as determined by featuresWanted
training_set <- fread( "./data/train/X_train.txt", select = featuresWanted)
training_act_labels <- fread( "./data/train/y_train.txt")
training_subjects <- fread( "./data/train/subject_train.txt")

test_set <- fread( "./data/test/X_test.txt", select = featuresWanted)
test_act_labels <- fread( "./data/test/y_test.txt")
test_subjects <- fread( "./data/test/subject_test.txt")

# Create the merged dataset all_data
training_set <- cbind( training_subjects, training_act_labels, training_set)
test_set <- cbind( test_subjects, test_act_labels, test_set)
all_data <- rbind( training_set, test_set)
# Free up some memory
rm(training_set)
rm(test_set)


############ USE DESCRIPTIVE ACTIVITY NAMES, AND USE DESCRIPTIVE COLUMN NAMES ####################

# Add column names
colnames(all_data) <- c("subject", "activity_class", unlist(featuresWanted.headers))

# Add avtivity names under a column called activity
activity_labels <- fread( "./data/activity_labels.txt")
colnames( activity_labels) <- c("activity_class", "activity")
all_data <- merge( all_data, activity_labels, by = "activity_class")


############### CREATE THE INDEPENDENT SUMMARY DATASET #########################
# Convert activity and subject to factors
all_data$subject <- as.factor( all_data$subject)
all_data$activity <- as.factor( all_data$activity)

melt_data <- melt( all_data, id = c( "activity", "subject"), measure.vars = unlist(featuresWanted.headers))

tidy_data <- dcast( melt_data, activity + subject ~ variable, mean)
# Clean up column names
col_names <- colnames( tidy_data)
col_names <- gsub('[-()]', '', col_names)
colnames( tidy_data) <- col_names


# Write this tidy data into a file
write.table( tidy_data, file = "tidy_data.txt", row.names = F, col.names = T)