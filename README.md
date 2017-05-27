# Course Assignment on Getting and Cleaning Data

This repository includes the R script file **run_analysis.R** to achieve the objectives set out in the assignment, and to produce the **tidy_data.txt** file (also uploaded to the repository). The **tidy_data.txt** file stores the final tidy dataset prepared during the assignment.

## Assumption
The included R script assumes that the zip file for the data for the assignment has already been downloaded and the contents under the **"UCI HAR Dataset"** folder extracted and saved into a separate folder called **data** in the current working directory.

## Steps
The following broadly outlines the steps in the R script:

1. As a first step, we look at the features list to narrow down the list of variables which represent means and standard deviations. The indices as well as names of such variables are stored.
1. We read the training and test datasets into separate data tables. Only columns selected in the step above are included. Activity labels and Subjects are read in separately and attached to the two datasets which are finally binded to each other using **rbind**.
1. The merged data set is updated to include descriptive column names. Activity names are also included.
1. Through melting and casting, we create a new dataset called **tidy_data** which includes the means of all relevant variables for each combination of **activity** and **subject**.
1. This **tidy_data** is then written into the text file **tidy_data.txt**.