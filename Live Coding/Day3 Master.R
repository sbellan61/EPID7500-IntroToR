## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----message=F-----------------------------------------------------------
require(tidyverse)

## ----message=F, results='hide'-------------------------------------------
notif <- read_csv('~/Downloads/TB_notifications_2017-08-27.csv')

## ----message=F-----------------------------------------------------------
head(colnames(notif),20)
notif[1:4,1:5]

## ----selectCols----------------------------------------------------------
notif2 <- select(notif, iso3, country, g_whoregion, year, c_newinc) %>% 
  rename(whoreg = g_whoregion, inc = c_newinc)
notif2
head(distinct(notif2, country) %>% .$country)

## ----incNA---------------------------------------------------------------
indNA <- which(is.na(notif2$inc))
head(indNA)
slice(notif2, indNA)

## ----incZ, echo=F--------------------------------------------------------
ind0 <- which(notif2$inc==0)
head(ind0)
slice(notif2, ind0)

## ------------------------------------------------------------------------
sum(is.na(c(0,NA,3,NA,5)))

## ----fullcountry---------------------------------------------------------
fullcountry <- 
  group_by(notif2, country) %>%
  summarize(noNAs = sum(is.na(inc))==0) %>%
  filter(noNAs==T) %>%
  .$country
head(fullcountry)

## ----fullcountryDat------------------------------------------------------
notif3 <- filter(notif2, country %in% fullcountry)
range(notif3$inc)
sum(is.na(notif3$inc))
glimpse(notif3)
summary(notif3)

## ----spread, echo=FALSE--------------------------------------------------
args(spread)
head(notif3)
notifWide <- select(notif3, country, year, inc) %>%
  spread(country, inc)
notifWide[1:5,1:5]
filter(notif3, country=='Argentina')

## ----bigC----------------------------------------------------------------
big_countries <- 
  group_by(notif3, country) %>%
  summarize(cum_inc= sum(inc)) %>%
  arrange(desc(cum_inc)) %>% 
  slice(1:10) %>%
  .$country
big_countries

## ----boxplot, echo=FALSE-------------------------------------------------
big_countries
boxplot(inc ~ iso3, filter(notif3, country %in% big_countries) , las = 2)

## ----boxplotGG, echo=FALSE-----------------------------------------------
big_countries
filter(notif3, country %in% big_countries) %>% 
  ggplot(., aes(iso3, inc)) + geom_boxplot() + 
  ## the next line rotates the country labels 90 degrees
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 

## ----measlesDat1---------------------------------------------------------
## load the necessary libraries
require(readxl); require(tidyverse); require(lubridate); require(stringr)
getwd()
meas <- read_xlsx('Table_407_Web_Number_Measles_Cases_Month_2017-08-09.xlsx', sheet = 2)
head(meas)
?gather
## gather everything but iso3, countyr, year and make value of column name
meas2 <- gather(meas, month, cases, -c(ISO3, Country, Year) )
## change class of month to a factor, and use month.name as ordered.level
month.name
meas2$month <- factor(meas2$month, ordered = T, levels = month.name)
meas2$monthNum <- as.numeric(meas2$month)
meas2$monthNum <- str_pad(meas2$monthNum, width = 2, side = 'left', pad=0)
meas2

## ----measlesDat2---------------------------------------------------------
## double check that the number months match the name months
distinct(meas2, month, monthNum) ## look at every distinct entry by monthXmonthNum
filter(meas2, monthNum==5) ## look at a random month num
meas3 <- ## unite year & month columns
  unite(meas2, ym, Year, monthNum, sep='-') %>%
  select(-month) %>% ## remove the month column which is no longer necessary
  rename(date=ym) ## rename the ym column
meas3

