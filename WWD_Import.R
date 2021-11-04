######## INTRODUCTION
#First, create a folder structure somewhere logical on your computer. Name it something like DSSG Working With Data. Inside
#this folder, have a folder called "Raw data", and a folder called "Exports". Download the data files from Canvas into "Raw data"
#and there they shall stay, no touching them! Any altered form of your raw data will go into "Exports". 

#This is a comment. Documentation is key. You should comment about EVERYTHING you do. Comments start with a # (hashtag? pound sign?)
#The standard in R is to assign variables with this: <- 

#It's essentially the same as an equals sign. Let's try it. 

#Write in the console 
x <- 6 # and press enter. Look what appeared in our environment! and yes, you can start a comment mid-line. Now write in
y <- 4. 
#Now try 
x+y
#Hurray! You're coding. Let's get fancier and make a vector with c(), the "combine" function. It's very commonly used in R. 

#You can combine numbers together using c() like this:
c(1,2,3)
#Or a sequence of numbers
c(1:5)
#You can combine different data types and even do simple operations in c()
c("cat", 1:10, x+y)

#If you want to keep your vector and not just see it print in console, assign it a name
funnylist <- c("cat", 1:10, x+y)
funnylist #displays in console

#You can combine vectors with each other like so:
c(funnylist, "another cat")

#What if you forget what I'm telling you now about how c() works? Never fear, you can either click on the help tab to the right
#and type in c(), or you can type ?c() in the console. This documentation is terse and rather hard to understand, but also 
#provides some examples, which can be helpful. Otherwise, google away! So many people have made tutorials or asked questions about
#R in StackOverflow and other places. 

#These objects we've made are rather silly and we don't need them anymore. Let's clear them away. Click on the little broom 
#icon in the Environment tab on the upper right.

#Now let's install the packages we need for our census project today. R has a base set of functions you can call on and use -- 
#and devoted users or groups of users have an idea of some other functionality they'd like and build a package with a library
#of functions, usually around a certain theme or use case. These libraries are called packages. Let's install the very best one:
#TIDYVERSE! https://www.tidyverse.org/ 

#In the lower right box where c() documentation currently is, click on the packages tab. Search for "tidyverse". Install it,
#and all its dependencies. The code for it is:
install.packages("tidyverse")

#Once it's installed, you have to load it. You can check it off in the list of packages, or use the following code:
library(tidyverse)

#a few library() calls are always at the top of any scripts I write. For our task, we just need one library. 

#Change working directory -- click on the "files" tab in the bottom right box. Navigate to the folder where you put this script. 
#Code for this is: setwd("~/Documents/R/DSSG Working With Data")



###################

####### LOADING DATA
#Let's read in our data with read_csv! And learn about tabs. 
read_csv(file = "raw data/nhgis0003_ts_nominal_county.csv")

#Looks like we should assign it to something! 
census_data_raw <- read_csv(file = "Raw data/nhgis0003_ts_nominal_county.csv")

#R is telling us how it's interpreting each of the columns, and if it's wrong we can do read_csv() again and tell it specifically
#how we want it to interpret any of these columns. One other cool thing RStudio lets you do is click on a file and check it out. 
#I do this all the time. Equivalently, View(census_data)

#We now have a dataframe called census_data, but as you can tell, there are *a lot* of columns and a lot of really pointless names.
#Codebook to the rescue! Let's import our codebook and take a look. 

### ACTIVITY
#You write the code! Our codebook is in Raw data and called codebook.csv . Import codebook, assign it the name codebook in R, 
#and then view it. Don't forget to comment out what you're doing. 

#Importing codebook
codebook <- read_csv("raw data/codebook.csv")
#Take a look at it
View(codebook)

######## CHANGING COLUMN NAMES EN MASSE
#Great! Now let's do something clever. Note the dimensions of our two dataframes in our Global Environment. 31 is repeated twice.
#Basically, we want the column names of census_data to be what we see in the "Field" column of codebook. And we can do that.
#To see the names of a dataframe, you can use the names() function.

#Checking the names of census_data
names(census_data_raw) #note tab-complete can save time and typos here!

#Now I'll teach you how to grab a column of a dataframe in R. You use $, and again, tab-complete can be helpful
codebook$Field

#We want to replace the current census data names with the values in codebook$field. We can do that by just assigning the one
#to the other, like so:

names(census_data_raw) <- codebook$Field

#Now look at the census_data again! And look at those absurd age breakdowns. Don't worry, we'll be fixing all of this in the
#next script, when we start talking about cleaning. But first, even R, let's keep our raw data raw and make a new dataframe
#to manipulate in our next steps. 