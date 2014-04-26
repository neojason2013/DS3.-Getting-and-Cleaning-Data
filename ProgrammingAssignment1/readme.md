run_analysis.R does the following steps:

1. download files if not existd.
2. unzip data into temp folder.
2. load tables, including features and activites.
3. only reserve variables with mean or std.
4. adds subject and activity variables.
5. adds names of variables.
6. combine all data into one big table.
6. aggregate data using average of each variable for each activity and each subject.
7. saves data to output files.

