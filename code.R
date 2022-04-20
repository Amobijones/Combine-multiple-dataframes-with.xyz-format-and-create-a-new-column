
# Load needed packages
library(dplyr)
library(tibble)
library(plyr) 
library(readr)

#######################################################################################################
#import data

xyzs <- list.files('./data/', full.names = T, pattern = '*.xyz')


# create a function to read .xyz file as a table (reading as csv, sees the first row as a column name), 
# convert to dataframe and export all as csv
con_func <- function(listx){
  list_holder <- vector(mode = 'list', length = length(xyzs)) # create and empty list
  list_holder  <- listx %>% # assign the list to the empty holder
    lapply(read.table) %>%   # read each table into a txt file
    lapply(data.frame)  # turn each to a dataframe
  #export each as csv file
  lapply(seq_along(list_holder), 
         function(i) { write.csv(list_holder[[i]],
                                 sprintf("%02d.csv", i), row.names = F) }) 
}


#run the function
con_func(xyzs)

# Get paths to all exported  .csv files in working dir
csvs <- list.files(pattern = ".csv")

# Empty list to hold the result of each iteration
all_files <- list()
for(i in 1:length(csvs)){
  temp <- read_csv(csvs[i])
  #sub() extracts the digits from the name of the 'ith' xyz file 
  #(like strsplit function) using a regex pattern .*_(\\d{+}).xyz
  mile_num <- sub(pattern = ".*_(\\d{+}).xyz", replacement = "\\1", x = xyzs[i])
  temp$mile <- mile_num
  all_files[[i]] <- temp
}


# export all individual files. make sure you send this to a directory you are familiar with. 
#perhaps setwd (a new working directory) before exporting the data

setwd('./resultz')

lapply(seq_along(all_files), function(i) { write.csv(all_files[[i]], sprintf("%03d.csv", i), row.names = F) }) 

# read all exported files that were exported in the immediate code and comine them into one csv
combined <- list.files('.', full.names = T, pattern = '.csv') %>% #import files
  #read all the csv using the lapply function
  lapply(read_csv) %>%   # Store all files in list
  #bind all the data using the bind_rows from dplyr
  bind_rows   # Combine data sets into one data set 

########################################################################################################################
# you can EXPORT the CSV

write.csv(combined, 'combined.csv')
#The End

