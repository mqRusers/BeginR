###########################################
# Part 3 - Animation of Penguin Movements #
###########################################
# let's load the libraie we will need to use
library(ggplot2)
library(gganimate)
library(lubridate) # useful functions for working with datetimes

# Again set the working directory
getwd() 
setwd("~/Development/RUsers/workshops/BeginR")

# So now we need to read in all the data for ths=is project. In this
# scenario we have 25 different csv files with each one corresponding 
# to an penguin track. We could write out read.csv() for every single
# track but we try and avoid doing manual work like this when we are
# programming. Mainly because it's very hard to later make small changes
# and can't later be applied to another dataset! 

# Instead we will use a for loop method to read all the csv data files
# in our directory in one go.

# To do this we first need to get the filenames of all the files we wish 
# to read in. We can do this using the function `list.files()`. the
# "pattern" argument speccifies that we only want file names that end
# with ".csv" (the `$` indicates the end of the string).
file_ls <- list.files(path='./data/penguins', pattern=".csv$")

# Now as we read in the data we need somewhere to put it. This is the job
# for a list that can store anything we want. Remeber I said lists can store
# any data type? When we read in out penguin tracks each one will be saved as
# an element of our list as a data frame.
track_ls = list()

# okay now that we have everyting ready we can use a for loop to iterate over
# our file list and read in each instance of the file list. A for is basically
# a method for iterting over a vector. For example. 
for (i in 1:5){
  print(i)
}

# we can iterate over other objects too, not just numbers
for (fruit in c('apple', 'pear', 'orange')){
  print(fruit)
}

# Let's use this method to read in each file
for (i in 1:length(file_ls)){
  file_name <- file_ls[[i]]
  track_ls[[i]] <- read.csv(paste0('./data/penguins/',file_name))
  print(paste('Reading in file',file_name))
}

# now if you look at the track_ls object you will see we have a list of
# dataframes! We can merge all of this into one single data frame by using
# `rbind()`. We will do this in conjuction with another function called
# `do.call()` which allows us to apply the rbind function to the entire 
# list of data frames!
df <- do.call('rbind', track_ls)

# Like in the last example we need to tell R that out dtUTC column is
# a collection of date time objects. 
df$dtUTC <- as.POSIXct(df$dtUTC, tz='UTC')
# I want to display the datetimes as local time at the end so I have 
# made local datetime column. I always like to keep the UTC column too
# to make sure everything is behaving right. 
df$dtAEST <- df$dtUTC
attr(df$dtAEST, "tzone") <- "Australia/Sydney"

# I want to stress that the computer will interpret these times to be exactly
# the same! While they are displayed as different timezones the underlying
# seconds since epoch is exactly the same. Here I'll prove it to you. 
as.integer(df$dtUTC[1])
as.integer(df$dtAEST[1])
as.integer(df$dtUTC[1]) == as.integer(df$dtAEST[1])

# Load map I already have made (how to make this is not in this tutorial)
# For an excellent tutorial on how to make maps you can check out the 
# workshop that was recently run by Matt Kerr on making maps and working 
# with spatial data. You can find it here:
# https://github.com/mqRusers/Spatial_Workshop
mapfile <- readRDS("./data/mapfile.rds")

# Now we are going to make our map. To do this all we have to do is add normal 
# ggplot commands to the mapfile I loaded. The scale_y and scale_x functions are
# just setting the extent of the map to focus in on our data. The we have just
# used geom_point() to add the lat/lomn positions and coloured by the id values. 
peng.map <- mapfile + 
  scale_y_continuous(limits = c(min(df$lat, na.rm=TRUE)-0.01, max(df$lat, na.rm=TRUE)+0.01), expand = c(0, 0)) +
  scale_x_continuous(limits = c(min(df$lon, na.rm=TRUE)-0.07, max(df$lon, na.rm=TRUE)+0.07), expand = c(0, 0)) +
  geom_point(data=df, aes(x=lon,y=lat,color=id), size=1.5)

# let's have look
peng.map

# The legend is not that useful here so let's remove it
peng.map <- peng.map + theme(legend.position = "none")
peng.map # much better!

# If we want a more clear picture ofs we can facet wrap which make a different 
# plot for each value of a given input. We can give it our penguin IDs.
peng.map + facet_wrap(~id) # not saving this one - also might take a while to render as well

# So the penguin tracks look good so let's animate them. We're going to use gganimate
# to do this. We have one more problem to overcome first however. Not all the penguin
# tracks were collected on the same day. But for the sake of our animation we want to 
# plot all of these tracks with just the time (regardless of what day it is). Otherwise
# our animation will be too long and we won't be able to compare the tracks properly. 
# To do this we can build a "relative datetime". Basicaslly we just strip out the hour
# and minute components of the datetime objects and just reformat them all so they all 
# occur on the same arbutary day. We can use some useful functions from the lubridate 
# package to extract the hours and minutes from the datetime columns. 
df$hour <- hour(df$dtAEST)
df$min <- minute(df$dtAEST)
# Add then we just build a new datetime object for Januray 1st, 2000 (can be any date)
# We can use ISOdatetime() to do this. (ISOdatetime(YYYY, MM, DD, hh, mm, ss))
df$datetime_relative <- ISOdatetime(2000, 01, 01, as.integer(df$hour), as.integer(df$min), 0)

# Finally let's do the cool part! We are going to animate these penguin movements
# using gganimate. We are simply going have our frames transition accross the 
# relative dtaetime column we just made. We're also going to add a few cool tails
# to the track movements using `shadow_wake()`.
peng.anim <- peng.map +
  transition_time(df$datetime_relative) +
  shadow_wake(wake_length = 0.2, alpha = TRUE)
# have a look!
peng.anim

# finally we will save the animation as a gif file so we can take it home 
# to show mum and dad. 
anim_save("peng_anim.gif", peng.anim)
