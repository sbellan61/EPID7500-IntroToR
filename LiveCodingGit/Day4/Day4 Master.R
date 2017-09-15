## EPID 7500 - Day 4 
## Steve Bellan
require(readxl); require(tidyverse); require(lubridate);
setwd("~/Dropbox/Admin & Misc/UGA admin/Courses/Bellan EPID 7500/TempCode/Day4")


## Excercise 1 (bonus from Day 3 that we didn't get to)
# 
# * [WHO Measles & Rubella Page]
#   (http://www.who.int/immunization/monitoring_surveillance/burden/vpd/surveillance_type/active/measles_monthlydata/en/)
# * Download the [Distribution of measles cases by country and by month, 2011-2017]
#  (http://www.who.int/entity/immunization/monitoring_surveillance/burden/vpd/Table_407_Web_Number_Measles_Cases_Month_2017-08-09.xlsx?ua=1)
# * Read it into R with the  `xlsx` library (note you have to read 2nd sheet!)
# * Reformat the data so it is in long with date in YYYY-MM format

meas <- read_xlsx('Table_407_Web_Number_Measles_Cases_Month_2017-08-09.xlsx', sheet = 2)

head(meas)
?gather
## gather everything but iso3, countyr, year and make value of column name
meas2 <- gather(meas, month, cases, -c(ISO3, Country, Year) )
str(meas2)
## change class of month to a factor, and use month.name as ordered.level
month.name
meas2 <- meas2 %>% mutate(month =  factor(month, ordered = T, levels = month.name))
str(meas2)
meas2
meas2 <- meas2 %>% mutate(monthNum = as.numeric(meas2$month))
meas2
meas2 <- meas2 %>% mutate(monthNum = str_pad(meas2$monthNum, width = 2, side = 'left', pad=0))
meas2

distinct(meas2, month, monthNum) ## look at every distinct entry by monthXmonthNum
filter(meas2, month=='March') ## look at a month as a test case

meas3 <- ## unite year & month columns
  unite(meas2, ym, Year, monthNum, sep='-') %>%
  mutate(date = paste0(ym, '-01')) %>% ## add day
  mutate(date = ymd(date)) %>%
  select(-month, -ym)
meas3

## Excercise 2 -  Plot measles incidence time series by country for the 5 highest incidence countries in 2015
str(meas3)
meas3 <- meas3 %>% mutate(cases = as.numeric(cases))
group_by(meas3, Country) %>% summarize(nonmissing = sum(!is.na(cases)), missing = sum(is.na(cases)))
meas3 <- meas3 %>% filter(!is.na(cases))
meas3
group_by(meas3, Country) %>% summarize(maxcases = max(cases), rank=rank(maxcases)) %>% arrange(desc(maxcases))
group_by(meas3, Country) %>% summarize(maxcases = max(cases)) %>% arrange(desc(maxcases)) %>%
  ungroup() %>%
  mutate(rank=rank(maxcases)) %>%
  head(5) %>% .$Country -> top5

filter(meas3, Country %in% top5) %>%
  ggplot(aes(date, cases, col=Country)) + geom_line() + geom_point() +
  theme(legend.position = 'left')


## Excercise 3 - Plot measles incidence time series for *all* countries on a regular scale and on a log scale
## hint use legend.position='none' if your legend takes up too much space
meas3 %>%
  ggplot(aes(date, cases, col=Country)) + geom_line() + geom_point() +
  theme(legend.position = 'none')

meas3 %>%
  ggplot(aes(date, log(cases), col=Country)) + geom_line() + geom_point() +
  theme(legend.position = 'none')
meas3

# Excercise 4 - Merging
# It's not really fair to measure the highest measles incidence
# on an absolute value. What we really want is the per capita incidence
# Let's merge in population data from the world bank:
## https://data.worldbank.org/indicator/SP.POP.TOTL
## Download the CSV file there
popdat <- read_csv('API_SP.POP.TOTL_DS2_en_csv_v2.csv', skip = 3) ## skip the first couple lines because they're extra metadata
popdat <- popdat %>% rename(Country = 'Country Name', ISO3 = 'Country Code') %>%
  select(-`Indicator Name`, -`Indicator Code`)
popdat
popdat <- popdat %>%
  gather(key = year, value = population, -Country, -ISO3) %>%
  arrange(Country, year)
popdat <- popdat %>% mutate(year = as.numeric(year),
                 population = as.numeric(population))

popdat

meas3 <- mutate(meas3, year = year(date))
meas3

measpop <- inner_join(meas3, popdat, by = c('Country','year'))
measpop

measpop <- measpop %>% mutate(per100k = cases/population * 10^5)
measpop

## Now let's look at the top countries
group_by(measpop, Country) %>% summarize(maxcases = max(per100k)) %>% arrange(desc(maxcases)) %>%
  ungroup() %>%
  head(5) %>% .$Country -> top5
top5

group_by(measpop, Country) %>% summarize(maxc = max(per100k)) %>% ggplot(aes(maxc)) + geom_histogram()

filter(measpop, Country %in% top5) %>%
  ggplot(aes(date, per100k, col=Country)) + geom_line() + geom_point() +
  theme(legend.position = 'left')


  ggplot(measpop, aes(date, per100k, col=Country)) + geom_line() + geom_point() +
  theme(legend.position = 'none')

## Excercise 5 - 
## Assume Vitamin X supplementation is thought to affect the height of children,
## with a 3cm increase in height of children that get supplementation vs those who do not by the age of 3.
## Unsupplemented 3 year olds heights are normally distributed around a mean of 90cm, with a sd of 4.

## 1. Simulate a single data set of 100 children, half of which are supplemented

## 2. Plot a histogram of heights by supplementation status for your simulated data set
  
## 3. Plot overlayed smooth density plots (geom_density) corresponding to these histograms.
  
## 4. Conduct a t-test of a difference in means for your simulated data set
  
## 5. Write a for loop to repeat this 5 times
  

## Excercise 6
## Assume 1000 people are enrolled in a prospective cohort study of smoking and lung cancer.
  
