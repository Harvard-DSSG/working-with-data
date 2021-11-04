#Let's switch gears and learn how to join data. I have another dataset and I want to join population data to it. This dataset was
#produced with MUCH effort from a truly awful data source (still census, but language spoken at home.) Let's read it in and
#take a look. This is data from 2010. 

#My goal: https://markets.businessinsider.com/news/stocks/what-is-the-most-common-language-in-every-state-map-2019-6 , but on
#a county level.



######## SUMMARIZING OR ANALYZING SUBSETS OF YOUR DATA WITH GROUP_BY()
#group_by() was once described to me as dplyr's black magic. But basically, you're making transient pivot tables and doing 
#operations within these transient pivot tables. 

#In this case, recall that I want the most-spoken language after English and Spanish in each county. To figure this out, I'd like
#to rank the languages by number of speakers per county. So I want to break down my data into state, county, then sort the 
#languages by number of speakers, and rank them based on that. 

#First, let's take a look at the data I have to work with. 

#### ACTIVITY
#Read in language data
languages_spoken_raw <- read_csv("raw data/cleaned_language_data.csv")

#Given my goal of looking at this dataset on the county level, it's a problem that right now the data is on a census tract level.
#Many counties have several census tracts within them, and for each, all the languages are listed. So in County A, Spanish
#could be listed multiple times, and to get the true count of Spanish speakers in County A I'd need to add up all rows in 
#county A marked "Spanish". 

#To fix this, we're going to use group_by() and summarize(). 

languages_spoken_county <- languages_spoken_raw %>% group_by(state_abbv, `FIPS State Code`, `Area Name (State or County)`, 
                                                             `FIPS County Code`, Language) %>% 
  #At this point let's pause and look at a visual of what we've just done under the hood
  summarize(num_speakers=sum(`Number of speakers`)) %>% 
  ungroup()

#We went from nearly 300k rows to ~46k rows! Now our data is rolled up to the county level. Next up, how to I rank these
#languages from the most to least number of speakers? 

languages_spoken_county_rank <- languages_spoken_county %>% group_by(state_abbv, `Area Name (State or County)`) %>% 
  #Create a new column with ranks. rank() works but min_rank handles ties in the same method as sports. 
  mutate(rank=min_rank(desc(num_speakers))) %>% 
  #This is just a bonus -- if we want to reorder our data based on rank within each grouping of state, county
  arrange(rank, .by_group=TRUE)



######## FILTERING AND PARING DOWN DATA
#I want to add rural/urban population data from 2010 to this dataset, and rank the languages by most to least speakers in 
#the state. The datasets are similar but have a few frustrating differences. This is completely typical. But recall what
#our raw data looked like -- some of the columns are the same. We can merge the data by using the FIPS columns that appear
#in both datasets. 

#First I want to filter to just data from the right year in my raw population dataset. What years are represented? 
#Just like in Google Sheets/Excel, you can look at the unique values of a column. Remember how we call up columns? With a $. 

unique(census_data_raw$`Row Source Year`)

#So 1970-2010 is reflected here. How to keep just 2010 data? There's a handy filter() function. Let's take a look at it.

?filter

#### ACTIVITY
#Scroll down to the examples in the filter documentation, and see if you can come up with a line that would filter to just rows 
#with the year 1970. Create an object called census_data_1970 with just rows marked "1970". 

census_data_2010 <- filter(census_data_raw, `Row Source Year`=="2010")

#### ACTIVITY
#Great, now we have just 2010 data! Let's now select only the columns we're going to join to the language dataset: the two FIPS,
#urban population, and rural population. You know how -- our friend select(). Can you make census_data_raw have just those columns?

census_tojoin <- census_data_2010 %>% select(`FIPS State Code`, `FIPS County Code`, Urban, Rural)



######## JOINING/MERGING DATA

#Ready to join? We're going to do a left join, which means I want to keep all the rows from the languages dataset, even though
#some of them won't have matches in the rural/urban dataset (e.g., we don't have rural/urban data US-wide in the latter
#dataset). An inner join would keep only rows that had matches in both datasets. 

languages_spoken_pop <- left_join(languages_spoken_county_rank, census_tojoin, by = c("FIPS State Code", "FIPS County Code"))

#Take a look. Remember, this was a left join, so for entries like "United States" we expected a NA result. Scroll down and you'll
#see it was a successful join!



######## CREATE A BASIC FUNCTION

#Preparatory to Cole's section on web scraping in R, you need to learn about creating a custom function in R. It's super easy;
#take a look at the example below: 

fahrenheit_to_celsius <- function(temp_F) {
  temp_C <- (temp_F - 32) * 5 / 9
  return(temp_C)
}
