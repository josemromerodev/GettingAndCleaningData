### INTRODUCTION

This script reads the Samsung Galaxy S smartphone accelerometer data and attempts
to tidy the data for later analysis.

### INSTRUCTION LIST
1. STEP 1 - Define text constants for all the file names to use in the script
2. STEP 2 - Read the activity_labels.txt file and assign names to the columns
3. STEP 3 - Read features.txt and clean up the names by removing dashes and
            parenthesis.
4. STEP 4 - Read the X_train.txt and X_test.txt tables and bind them into one
            table called x_all_columns.
5. STEP 5 - Read the Y_train.txt and Y_test.txt tables and bind them into one
            table called y_all_columns.
6. STEP 6 - Read the subject_train.txt and subject_test.txt tables and bind them
            into one table called subject_row.
7. STEP 7 - Extract the mean and standard deviation measurements from
            x_all_columns and store them into x.
8. STEP 8 - Create a vector (y) with all the activity names.
9. STEP 9 - Bind the activity names (y) and subjects (subject_row) with the
            measurements to have descriptive names to the activities.
10. STEP 10 - Label the subject and activity columns
11. STEP 11 - Extract the tidy data set by getting the mean of evey measurement.
12. STEP 12 - Write the tidy data set to a text file using write.table().

### RESULTS
The program was successfully run multiple times on a Mac OS X with R 3.1.2

