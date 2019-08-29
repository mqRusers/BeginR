###################
# BeginR - Part 1 #
###################
# Set the working directory (you will need to change this line to where your 
# "BeginnerR" directory is located)

# only works in Mac (not in windows)
setwd("~/Development/RUsers/workshops/BeginR")

# use this for windows
setwd(choose.dir())

###########################
# Part 1.1 - Basic Syntax #
###########################
# Throughout this tutorial I have written some helpful notes in
# the form of "comments". Comments are ignored by R and will not
# be executed. Any line starting with "#" is a comment. 

# Assinging variables (using "<-")
myNum <- 7
# Once we've assigned a value it will appear in the environment 
# window. We can print our variables to the console at anytime by
# either writing there names or using the `print()` function.
myNum
print(myNum)

# There are several types of basic variables in R.
# Numeric - these are decimal values
myNum1 <- 4
myNum2 <- 2.3
# Calculations can easily be performed on numeric values
# (+, -, *, /, etc.)
myNum1 + myNum2
myNum1 - myNum2
myNum1 * myNum2
myNum1 / myNum2

# Integers - Integers are whole numbers only
# They can be created using the `as.integer()` function
typeof(myNum1)
myInt <- as.integer(myNum1)
typeof(myInt)
# If you pass a fractional number to `as.integer()` it will round down
as.integer(5.2)
as.integer(5.8)

# Characters and strings
# Basically letters and words (but also other characters)
# These are set using single or double qutes
myChar <- 'a'
myChar <- "a"
myString <- 'Hello!'
# Strings can be joined together using `paste()` or `paste0()` commands
paste('I', 'love', 'R')
paste('I', 'love', 'R', sep='_')
paste('I', 'love', 'R', sep='hfsjkafhkja')
paste0('I', 'love', 'R') # no separator 

# Logical (Boolean) values
# Logical values are either TRUE or FALSE.
myBool <- TRUE
# They can also be created by making logical statements
# logical statements are made using logical operators such as
# >, <, ==, !=, etc. 
# For example... What is this testing?
test <- myNum1 > myNum2
test

# some basic operators include..
myNum1 > myNum2 # Greater than
myNum1 < myNum2 # Less than
myNum1 == myNum2 # Equal to
myNum1 != myNum2 # Not equal to
myNum1 >= myNum2 # Greater than or equal to
myNum1 <= myNum2 # Less than or equal to

# These can be combined with other logical operates such as "AND" (&&) or "OR" ( | ) 
(myNum1 > myNum2) && (myNum1 > 5)
(myNum1 > myNum2) | (myNum1 > 5)

# converting between variable types
# we can convert some between variable types but not always
myString <- as.character(1543)
myString
myNum <- as.numeric(myString)
myNum
myString <- 'xyz_1543'
as.numeric(myString) # Why does this not work?

# If you're ever unsure what class the variable you are working with you can check
# the environment panel or use the function `class()`.
class(myNum)
class(myString)

########################
# Part 1.2 - Functions #
########################
# Functions are probably the single most important thing to understand in R.
# Functions are very simple, they basically take an input and give you an output.
# We've already used several! (print(), as.integer(), paste(), etc..)

# Let's use the `round()` function to round pi to N decimal places
# "pi" is a built in variable in R
pi 

# Functions take "arguments"
# In this case the arguments are the input (pi) and the number of decimal 
# places we wish to round to.
round(pi, 2)
round(pi, 6)

# Let's look at another function `mean()`
# This function takes the mean of a series of values so takes 
# a vector or list as an argument (we will introduce lists
# and vectors shortly)
myVector <- c(100, 200, 150, 150, 400)
mean(myVector)

# in R we can also define our own functions!
# Functions can use other function inside them
# Let's make a simple funciton to add two numbers and then
# devide them by pi and then round to two decimal places. 
# Our arguments will be "x" and "y".
myFunction <- function(x, y){
  result <- (x + y)/pi
  result <- round(result, 2)
  return(result)
}

# let's test our function
myFunction(34, 23)

################################
# Part 1.3 - Lists and Vectors #
################################
# We can store much more than single values as variables in R
# We can also store data as data structures such as vectors or lists.
# Vectors and lists are collections of objects

# vectors are set using the `c()` function.
myVector <- c(1, 2, 3, 4, 5)
myVector

# Lists are set using the `list()` function.
myList <- list(1, 2, 3, 4, 5)
myList

# You probably notice that the output of the list is different
# to that of the vector. **Don't worry about this right now.**
# The main difference between lists and vectors are that vectors can
# only store values of one type while lists can store any types! (including
# other vectors and lists!
myList <- list(1, 2, 'string', 4, 5)
myList
myVector <- c(1, 2, 'string', 4, 5)
myVector # Mixed types are not allowed so everything has been turned to strings!

# Indexing - This is so important!
# We can select items in a vector or list (indexing) by using square brackets [].
# For example:
myVector <- c(1, 4, 7, 9, 342)
myVector[1] # this selects position 1
myVector[3] # this selects position 3
myVector[5] # this selects position 5
# or using a range (which is actually another vector) or other vectors
1:3
myVector[1:3] # this selects positions 1 to 3
myVector[c(1,2,4)] # this selects positions 1, 2 and 4
myVector[c(5,2,4)] # this selects positions 5, 2 and 4

# if you want to know how long a vector is you can use the `length` fucntion
length(myVector)
# This is also a clever way to select the last element of a vector if 
# you don't know how long it's going to be before hand.
myVector[length(myVector)] 

# Indexing using logic
# Sometimes we might want to select elements based on conditions
# To do this we can use logical statements for indexing
# Data structures like list or vectors can take logical values of the same 
# length to index like so
myVector[c(TRUE, FALSE, TRUE, FALSE, TRUE)] # Here we get the 1st, 3rd and 5th elements

# The trick is we can procude a logical vector like this by making
# conditional statements. For example:
myVector > 5

# now we can insert these logical values back into out vector as the index to
# return all values that are greater than 5!
myVector[myVector > 5]

# These statements are very poweful and allow us to do some advanced 
# data wrangling

# That's enough of the basic syntax! Let's move on to a working example
# where we apply what we've learned and introduce some more advanced concepts!

