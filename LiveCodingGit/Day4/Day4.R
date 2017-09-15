## EPID 7500 - Day 4 
## Steve Bellan
require(readxl); require(tidyverse); require(lubridate); require(stringr)
setwd("~/Dropbox/Admin & Misc/UGA admin/Courses/Bellan EPID 7500/TempCode/Day4")


## Excercise 1 (bonus from Day 3 that we didn't get to)
# 
# * [WHO Measles & Rubella Page](http://www.who.int/immunization/monitoring_surveillance/burden/vpd/surveillance_type/active/measles_monthlydata/en/)
# * Download the [Distribution of measles cases by country and by month, 2011-2017](http://www.who.int/entity/immunization/monitoring_surveillance/burden/vpd/Table_407_Web_Number_Measles_Cases_Month_2017-08-09.xlsx?ua=1)
# * Read it into R with the  `xlsx` library (note you have to read 2nd sheet!)
# * Reformat the data so it is in long with date in YYYY-MM format

meas <- read_xlsx('Table_407_Web_Number_Measles_Cases_Month_2017-08-09.xlsx', sheet = 2)
View(meas)
names(meas)
?gather
month.name
meas2 <- meas %>% 
  gather(key = month, value = cases, January:December) %>% ##-ISO3, -Country, -Year) 
  mutate(monthNum = factor(month, ordered=T, levels = month.name)) %>%
  mutate(monthNum = as.numeric(monthNum)) %>%
  mutate(monthNum = str_pad(monthNum, width = 2, side = 'left', pad=0))
meas2
filter(meas2, month == "September") %>% distinct(monthNum)
meas2 <- meas2 %>%
  unite(dateYM, Year, monthNum, sep='-') %>%
  mutate(dateYMD = paste0(dateYM, '-01')) %>%
  select(-dateYM,-month) %>%
  mutate(dateYMD = ymd(dateYMD))
meas2

## Excercise 2 -  Plot measles incidence time series by country for the
## 5 highest cumulative incidence countries 
meas2
meas2 <- meas2 %>% mutate(cases = as.numeric(cases))
meas2
top5 <- meas2 %>% 
  group_by(Country) %>%
  summarize(totalNAs = sum(is.na(cases)),
            notMissing  = sum(!is.na(cases)),
            cumulativeCases = sum(cases, na.rm=T)) %>%
  arrange(desc(cumulativeCases)) %>% ##  arrange(cumulativeCases) %>%  tail(5)
head(5) %>% .$Country

top5

filter(meas2, Country %in% top5) %>% 
  ggplot(aes(x=dateYMD, y=cases, color=Country)) + geom_line() + 
  ylab('monthly measles cases') + xlab('')

##  ggplot(meas2, aes(totalNAs)) + geom_histogram()
## filter(meas2, str_detect(Country, 'Barbuda'))

## Excercise 3 - Plot measles incidence time series for *all* countries on a regular scale and on a log scale
## hint use legend.position='none' if your legend takes up too much space
countries <- meas2 %>% distinct(Country)  %>% .$Country
countries
testCountries <- sample(countries, 10)

filter(meas2, Country %in% testCountries) %>%  ggplot(aes(x=dateYMD, y=log(cases), color=Country)) + geom_line() + 
  ylab('monthly measles cases') + xlab('') + theme(legend.position = 'none')

# Excercise 4 - Merging
# It's not really fair to measure the highest measles incidence
# on an absolute value. What we really want is the per capita incidence
# Let's merge in population data from the world bank:
## https://data.worldbank.org/indicator/SP.POP.TOTL
## Download the CSV file there (you'll have to unzip and choose the right file)
popdat <- read_csv('API_SP.POP.TOTL_DS2_en_csv_v2.csv', skip = 4) ## skip the first couple lines because they're extra metadata
View(popdat)
head(popdat)
?read_csv
head(names(popdat))

popdat2 <- select(popdat, -X62, -`Indicator Name`, -`Indicator Code`)  %>% 
    rename(Country = `Country Name`, ISO3=`Country Code`)

popdat2 <- popdat2 %>%
  gather(key = year, value = population, `1960`:`2016`) %>%
  mutate(year = as.numeric(year))
popdat2

meas2 <- arrange(meas2, Country, dateYMD)
meas2 <- meas2 %>% mutate(year = year(dateYMD))
meas2
popdat2

measpop <- inner_join(meas2, select(popdat2, -Country), by=c('ISO3', 'year'))
measpop

filter(popdat2, Country=='Afghanistan', year==2011)

finalCountries <- measpop %>% distinct(Country) %>% .$Country
InitialCountries <- meas2 %>% distinct(Country) %>% .$Country
InitialCountries[!InitialCountries %in% finalCountries]

finalISO3 <- measpop %>% distinct(Country) %>% .$Country
InitialISO3 <- meas2 %>% distinct(Country) %>% .$Country
InitialISO3[!InitialISO3 %in% finalISO3]

measpop %>% mutate(casesPer100k = cases/population * 10^5) %>%
  ggplot(aes(dateYMD, casesPer100k, color = Country)) + 
  geom_line() + theme(legend.position = 'none')

?year

## Now let's look at the top countries

## Excercise 5 - 
## Assume Vitamin X supplementation is thought to affect the height of children,
## with a 3cm increase in height of children that get supplementation vs those who do not by the age of 3.
## Unsupplemented 3 year olds heights are normally distributed around a mean of 90cm, with a sd of 4.

rnorm(10, mean = 90, sd =4)

## 1. Simulate a single data set of 100 children, half of which are supplemented

tibble(id = 1:100)


## 2. Plot a histogram of heights by supplementation status for your simulated data set
  
## 3. Plot overlayed smooth density plots (geom_density) corresponding to these histograms.
  
## 4. Conduct a t-test of a difference in means for your simulated data set
  
## 5. Write a for loop to repeat this 5 times
  

## Excercise 6
## Assume <85cm height is considered stunted and >85cm is not (these are fake thresholds!).
## Add a dichotomous variable for stunting to the above data set and make a 2x2 table of supplementation vs stunting.
## Install the R library epiR and use the epi.2by2() function therein to analyze the data for each of your 5 loops.

  
