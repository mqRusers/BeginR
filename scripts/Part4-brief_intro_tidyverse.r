# Brief introduction to Tidyverse

# https://www.tidyverse.org/

# source: https://mq-software-carpentry.github.io/R-git-for-research/19-dplyr-tidyr/index.html


# loading packages (libraries)
library(tidyverse)
library(datasets)

# information on the datasets available
library(help = "datasets")


# Tidyverse works with tibbles (improved dataframes), 
# which are also more computationally efficient
# to convert a dataframe to a tibble, we use the function 'as_tibble()'

###############

# new functions

# select(): subset columns
# filter(): subset rows on conditions
# mutate(): create new columns by using information from other columns
# group_by() and summarize(): create summary statistics on grouped data
# arrange(): sort results
# count(): count discrete values

# To shape data:

# wide format: more columns, less lines
# long format: less columns, more lines

# gather(): to go from wide to long format
# spread(): to go from long to wide format


###########################################

# SIMPLE EXAMPLE OF PIPING

# COMPARE APPROACH 1 WITH APPROACH2

# APPROACH 1

data <- datasets::iris
data <- as_tibble(data)
data

# APPROACH 2

data = datasets::iris %>% as_tibble() 
data

###########################################

## Functions being piped are applied in that order,
## just like regular functions are applied from inside to outside

# Example: as.factor(as.character(1))
# 1 is converted to a character, then to a factor, not the opposite


# importing dataset from library datasets

data <- read_csv("data/iris_modified.csv",
                col_types = cols(Sepal.Length = col_double(),
                                 Sepal.Width = col_double(),
                                 Petal.Length = col_double(),
                                 Petal.Width = col_double(),
                                 Species = col_factor(),
                                 subtype = col_factor() )
                )
                

summary(data)



# importing dataset from file
# read_csv is an improved version of read.csv

cars_mod <- read_csv("data/mt_cars_modified.csv")

# classes 
sapply(cars_mod, class)

# type as factor
cars_mod$type <-  as_factor (cars_mod$type)

cars_mod

# summarizing columns
summary(cars_mod)

# mutate(): create new columns by using information from other columns

cars_mod <- cars_mod %>% mutate(hp_type = if_else (hp >= mean(hp), "high", "low") )
cars_mod$hp_type = as_factor(cars_mod$hp_type)
cars_mod

# select(): subset columns

cars_mod %>% select (hp, hp_type)

# filter(): subset rows on conditions

cars_mod %>% filter(hp_type == "high")

# group_by() and summarize(): create summary statistics on grouped data

cars_mod %>% group_by(type)

cars_mod %>% summarize(hp_mean = mean(hp)) # summarize and obtain general mean

cars_mod %>% group_by(type) %>% summarize(hp_mean = mean(hp))

# arrange(): sort results

arrange(mtcars, cyl, disp)

cars_mod %>% group_by(type)  %>% arrange(type)

# count(): count discrete values

cars_mod %>% count(hp_type)


# many things together

cars_mod %>% mutate(mpg_type = if_else (mpg >= mean(mpg), "high", "low") )  %>%  
            filter(mpg_type == "low") %>% arrange(cyl) %>% count(type)

cars_mod %>% group_by(hp_type)  %>% arrange(type) %>% count(hp_type)

##########################################################

# gather() - to go from wide to long format.

# ARGUMENTS

# data: The dataset to be modified (in our case, seps)

# key: the name of the new “naming” variable (year)

# value: the name of the new “result” variable (value)

# na.rm: whether missing values are removed (this dataset doesn’t have any, so it isn’t a problem)

# convert: convert anything that seems like it should be in another format 
#         to that other format, e.g. numeric to numeric 
#         (since we used  read_csv we don’t need this one either)



###########################

# spread() - to go from long to wide format.

# ARGUMENTS

# data: The data to be reformatted (inprogress)

# key: The column you want to split apart (Field)

# value: The column you want to use to populate the new columns 
#         (the value column we just created in the spread step)

# fill: what to substitute if there are combinations that don’t exist 
#         (not a problem here)

# convert: whether to fix incorrect data types as it goes 
#         (not a problem here)

##########################################################
# Source

# https://rpubs.com/mm-c/gather-and-spread
# http://www.mm-c.me/mdsi/hospitals93to98.csv

#seps <- read_csv("http://www.mm-c.me/mdsi/hospitals93to98.csv")
seps <- read_csv("data/hospitals93to98.csv")

long_format <- gather(data=seps,key=year,value=value,select=FY1993:FY1998)
long_format

wide_format <- spread(data=long_format,key=Field,value=value)
wide_format

##########################################################

# Resources

# https://www.burns-stat.com/documents/tutorials/impatient-r/
# https://www.bioinform.io/site/wp-content/uploads/2018/09/RDataScience.pdf
# https://www.tidyverse.org/
# https://rpubs.com/mm-c/gather-and-spread
