Human Activity Recognition Using Smartphones Data Set- Tidy Data

Repository components:

README.md- Describes the analysis files in this project
CodeBook.md- Lists the variables in the final data set and the r analysis code
run_analysis.R- Creates the Tidy dataset
tidy_data.txt- Contains tidy dataset

Description of R code:
This project downloads the Human Activity Recognition using Smartphones dataset, and cleans up, then summarizes the data. It is recommended that the users set the working directory to the location the user desries to download the files in this project. The first step is to download the data if it doesn’t presently exist in the working directory. Once the data is downloaded, it extracts the train and test data using the read.table() function. Then the program merges the datasets using the rbind() function. After that, the program extracts the mean and standard deviations of each measurement using the grepl() function. We now want appropriate activity names for our dataset, so we use the merge() function to join the activity labels data with the data set we are working on. Using the gsub() function, we label our variables with more descriptive names. Lastly, we find the average of each variable, for each activity and each subject, using the group_by() and summarize_all() functions.

Output:
	The program will output a text file in the “UCI HAR Dataset” folder, titled “TidyData” which will be in the user’s current working directory. 
