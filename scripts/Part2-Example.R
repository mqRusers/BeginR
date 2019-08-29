###################
# BeginR - Part 2 #
###################
# In this example we will be using a dataset of insect spray effectiveness and
# a dataset of global temperature anomalies. We have two data sources for this 
# dataset being "GCAG" and "GISTEMP" so effectively we have two datasets in the 
# one dataset.

# In this tutorial we will be using some R packages. Packages are basically just
# collections of useful function to perform specific tasks that extend the
# functionality of the base R packages. You can load a package (once you have it
# installed) using the `library()` function. It's good practice to load all packages
# you will use at the top of your script. 

library(datasets) # some built in datasets to play with
library(ggplot2) # useful for making nice looking plots and figures
library(gganimate) # useful for making animations
library(cmocean) # some nice looking colormaps (you'll see)

# First up let's set out working directopry again. You can copy this accross from
# the first script. This will be set from the last script but it's good practice 
# to set this early on. We can get the current working directory useing `getwd()`.
getwd()
setwd("~/Development/RUsers/workshops/BeginR")

####################################
# Part 2.1 - Insect Spray Analysis #
####################################
# In this part we're going to analyse the effectiveness of 6 insecticide 
# sprays. In doing so we will learn about more complex data structures such
# as dataframes and how to manipulate them.

# Data frames
# Now let's load our first dataset that's been loaded with the `datasets` package
# We're saving the data as a variable "df" which is shorthand for "data frame"
# Data frames are essentially "tables". You can think of each column as a
# vector that's been binded together to make a "data frame"
df <- InsectSprays

# Let's have a quick look at the data
# We can use `head()` to see the first few rows to get an idea of how it is
# structured
head(df)

# We can use `summary()` to have a look at some basic metrics such as the 
# minimum, maximum, median and the mean.
summary(df)

# Now we can learn about the `$` operator. Within a some data structures
# we can select different components using the `$` symbol. For example,
# we can select the two columns using this operator.
df$count
df$spray

# when you select a column you can index it like you would a vector
df$count[2]
df$spray[2]

# We can also index data frames by sepcifying both the rows and columns
df[2, 1] # this will select row 2 in column 1 (count)
df[10:20, 2] # this will select rows 10 to 20 for column 2 (spray)

# also like before we can also use conditional statements to index our
# data frames which can be incredibly useful. Just say we wanted only to
# select the data from spray 'D'. We could make a conditional statement like this.
df$spray == 'D'
# this can then be passed to slect only the rows of the data frame where
# the spray is 'D'
df[df$spray == 'D', ]
# notice the comma followed by nothing? That simply means we are slecting ALL
# the columns. If we wanted just the count data where spray = 'D' then we could
# pass either the column name as a string or the column index.
df[df$spray == 'D', 'count']
df[df$spray == 'D', 1]

# notice that none of this changes the data and df is still the same. R does
# not save data to a variable unless we explicity tell it to. For example we
# can save the data frame with only spray 'D' like this.
df_spray_D <- df[df$spray == 'D', ]
df_spray_D

# There's also one more useful trick we can use. You can invert a logic array
# using the `!` symbol.  
!df$spray == 'D'
# So we can also select all the rows that are the inverse of our conditon.
# In this case all rows that are not 'D'
df[!df$spray == 'D', ]
# we could also use the `!=` (not equal) operator to do this but this just
# shows there's more than one way to achieve the same results in R.
df[df$spray != 'D', ]

# Well enough messing about let's actually analyse this data.
# Let's make a visual plot of our data.
# Are has a lot of "base" plotting functions that are quite good.
# It's also usually smart enough to know what you want to plot based
# on the layout of the data. Becuase our x axis is factors and y axis 
# is numerical in this case R knows that a box plot is the best way to
# represent this data.
plot(df$spray, df$count)

# Well it's pretty clear that C, D and E are lowering the insects count
# but let's confirm this statistically. 
# we can do an Analysis of Variance (ANOVA) very easily in R
aov.spray <- aov(count ~ spray, data = df)
summary(aov.spray)

#################################
# Part 2.2 - Global Temperature #
#################################
# In this secrtin we're going to learn some more advanced plotting features 
# avliable in the package `ggplot2` which we loaded earlier. We'll also learn
# how to load our own datasets.

# Now the next thing we need to do is read in our dataset. Out data set is
# in a format called "comma separated values" or "csv". In R with 
# have a function called `read.csv()` for reading csv files. Let's
# read in the data. We're saving the data as a variable "df" which is
# shorthand for "data frame"
df <- read.csv('data/monthlyTemp.csv')

# To have a quick loomk at the data we can use the `head()` function
# to print the first few rows.
head(df)
# And we can use the `summary()` function to get and overview of the
# data set.
summary(df)

# Okay let's have a quick look at this data!
plot(df$Date, df$Mean, col=df$Source)
# Oh dear! Something is not quite right here.

# R is pretty smart, but sometimes we still need to tell it how to interpret
# things. Because it has no way of knowing what we wanted it has read in
# the "Date" column to be character variables. Consequently it has interpreted
# this column to be a factor with 1644 levls! By default, in base R when you
# set your x axis to be a factor and y as numeric R will try and make a boxplot
# of the resuts. That's why our plot looks so odd!

# Consequently we need to tell R to interpret the Date column as a continuous 
# date variable instead of a character. To do this we need to convert the dates
# into a new variable type called a datetime object (or POSIXct). We can easily
# convert properly formatted strings (YYYY-MM-DD hh:mm:ss) into this datatype 
# uibg the `as.POXISct()` function.
df$Date <- as.POSIXct(df$Date, tz='UTC')
# Now let's plot again
plot(df$Date, df$Mean, col=df$Source)

# The POSIXct data type is how comnputers understand time. It is a unit measured
# as seconds since January 1, 1970. Let's have a look at what is going on here

myDatetime <- as.POSIXct('1970-01-01 00:00:01', tz='UTC')
myDatetime
as.integer(myDatetime) # 1 second past 1970

myDatetime <- as.POSIXct('2019-08-29 16:30:00', tz='UTC')
myDatetime
as.integer(myDatetime) # 1567096200 seconds past 1970

# Be very careful when working with datetimes! Here's a common trap for young players!
# If you use as.POSIXct() without specifying the timezone, it assumes the times you have 
# entered are your local timezone! So this can catch you out!
# THIS.....
myDatetime <- as.POSIXct('2019-08-29 16:30:00', tz='UTC')
myDatetime
as.integer(myDatetime)
# IS NOT THE SAME AS THIS!!...
myDatetime <- as.POSIXct('2019-08-29 16:30:00')
myDatetime
as.integer(myDatetime)

# Datetimes can be a real head scratcher sometimes. My advice is unless you have a reason
# not to. Make all of your Datetimes UTC untill it comes time to display them and convert them
# to local timezones at the very end. This way you will never have to worry about difficulties 
# with timezones and issues with daylight savings. You will see an example of this later.

# Okay now that we have the data set up better let's make a nicer plot bnecause out base R
# plot is pretty ugly. To do this we will use thew package ggplot2 which we loaded in earlier
# using library(ggplot2)

# ggplot is nice to work with. You simply set up how you want the data displayed and then add
# what kind of plot you want. 
plot.temp <- ggplot(data = df, aes(x=Date, y=Mean, color=Source)) +
  geom_point(alpha=0.3) + # add points 
  geom_smooth(method='loess') # add a loess regression line
# call our plot
plot.temp

# we can even add other components to it later once we have saved a plot
plot.temp <- plot.temp + ggtitle('Global Mean Temperature Anomaly') # add a title
# call our plot
plot.temp

# We can see the two datasets we're looking at agree quite nicely so let's look at just
# one of the datasets. Let's subset our data set by only looking at the source where the 
# source is equal to "GCAG". We'll also make the plot look nicer by using a colormap from the 
# cmocean library
plot.temp.thermal <- ggplot(data = df[df$Source == 'GCAG', ], aes(Date, Mean, color=Mean)) +
  geom_line(size=0.7) +
  scale_colour_gradientn(colours = cmocean('thermal')(10))
# have a look
plot.temp.thermal

# And a bit of a bonus let's use the gganimate package to do a bit of a slow reveal 
# showing that the hottest months have all occured in the last few decades. 
animate(plot.temp.thermal + transition_reveal(Date))
