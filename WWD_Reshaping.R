###### PARING DOWN, REORDING, AND RENAMING COLUMNS

library(tidyverse)

#We're going to dig deeper in the Tidyverse in this part and really get into reshaping our data in ways that'll make it useful
#to be visualized, in map or other forms. 

#First, let's only keep the columns we want from this sheet. The select() function is really amazing and flexible at letting
#us do this efficiently. 

#Also, for this section, we're going to be using the pipe operator, %>% . You can make one with command-shift-m. What is it? 
#It's a useful little tool that allows you to build and run code line by line. It basically says, take the thing on my left 
#and feed it into the next function. In words, you can think of it as "then". So:

census_data %>% select(`Row Source Year`, `NHGIS Integrated State Name`)

#You can read this code as "Take census data then select Row Source Year and NGIS Integrated State Name. Equivalently, you could
#write the code like this instead:
select(census_data, `Row Source Year`, `NHGIS Integrated State Name`)

#We haven't assigned this selection anywhere, but we in a moment. First, let's see what cool things we can do with select().

?select

#You can do SO MUCH in select()! You can even rename columns while selecting them, or unselect columns by saying -colname. 
#data %>% select(col_new_name=col_old_name, colb:colz, -colq) ... the possibilities are endless! 

#Which columns do we want to keep? We're not going to use FIPS in this part of the workshop. We'll just keep the state and 
#county names. 

#Taking only the columns we need; using 'Year-Specific Area Name' rather than the County Name field because in the latter
#county is repeated over and over again. Renaming some fields while selecting. 

census_data_cleaned <- census_data_raw %>% select(state=`NHGIS Integrated State Name`, county=`Year-Specific Area Name`, 
                                              year=`Row Source Year`, Urban:`85 years and over`)



######### CREATING NEW COLUMNS WITH YOUR DATA

#Now we're down to 25 columns, which is a start. Let's combine some ages. I'd like the age ranges to be, for the most part,
#10 years. We're going to create new columns to do that. For some reason, the function for creating new columns is called
#mutate(). Again, it's always a good idea to check documentation for examples before using a new function. 

?mutate

#Let's start with one new column to see how this all works. Let's combine 5-14 years and create a new object to do so. 
census_data_cleaned <- census_data_cleaned %>% mutate(`5 to 14 years`= `5 to 9 years` + `10 to 14 years`, 
                                                      #Optionally one can remove the columns used to make our new column at this
                                                      #point using the following:
                                                      #`5 to 9 years` = NULL, 
                                                      #`10 to 14 years`=NULL
                                                      )

#We now have a new column at the end. We'll get rid of the columns we used to create the new column later with select(). 
#Let's create the rest of our combined columns all at once, since mutate() allows you to create multiple columns at once. 

#Combining more age columns together
census_data_cleaned <- census_data_cleaned %>% mutate(`15 to 24 years`= `15 to 17 years` + `20 years`+ `21 years`+`22 to 24 years`, 
                                      `25 to 34 years` = `25 to 29 years` + `30 to 34 years`, 
                                      `55 to 64 years` = `55 to 59 years` + `60 and 61 years` + `62 to 64 years`)



######## REMOVING UNWANTED COLUMNS

#Let's get rid of the columns we used to make our new columns with select().
census_data_cleaned <- census_data_cleaned %>% select(-(`5 to 9 years`:`30 to 34 years`), 
                                                      -(`55 to 59 years`:`62 to 64 years`))

#Optional: reorder columns
#If you don't like the looks of out-of-order columns, never fear: let's relocate() them.
census_data_cleaned <- census_data_cleaned %>% relocate(`5 to 14 years`:`25 to 34 years`, .after=`Under 5 years`) %>% 
  relocate(`55 to 64 years`, .after = `45 to 54 years`)

#Note: once you learn about group_by, you'll see there's another, more elegant way of doing this last step after we
#change our data into the long format. 


####### CHANGING DATA FROM WIDE TO LONG

#Combining columns is not all I want to do with my data. I'm going to be putting it in a program where the preferred format 
#is the long format, as in, I want a column called "Age". There's an easy function to do this and the reverse operation called
#pivot_longer() and pivot_wider(). Let's take a look at what the function takes. 

?pivot_longer

#Pivoting data to create an "Age" column
census_data_cleaned <- census_data_cleaned %>% pivot_longer(cols = `Under 5 years`:`85 years and over`, 
                                                            names_to = "Age", values_to = "No. of people")

#Well done! In the next script, I'll teach you how to filter, summarize, and join data. But before you go, let's write the data
#to a file, since it's already in so much better shape. write_csv() is the way to go here.



######### WRITING YOUR DATA TO A FILE
#write_csv() works very similarly to read_csv()
write_csv(census_data_cleaned, "exports/census_data_cleaned.csv")