rm(list=ls(all=T))
require(tidyverse)
getwd()
setwd('~/Documents/R Repos/EPID7500-IntroToR/Day 1/')
getwd()
ls()
## Hiding this from them
load(url('https://github.com/sbellan61/Bellan-2013-Lancet-DHS-analysis-/raw/master/alldhs.Rdata'))
dhs <- as.tibble(dat)
dhs <- mutate(dhs, mpos = as.numeric(ser %in% 1:2), fpos = as.numeric(ser %in% c(1,3))) %>%
    select(uid, ds, group, mpos, fpos, ser, tms, tfs, tmar, tint, mage, fage, mlsp, flsp,
           mevtest, fevtest) %>%
    rename(userID=uid, dataset=ds, country=group, coupleSerostatus=ser,
           maleMonthSexDebut = tms, femaleMonthSexDebut = tfs,
           monthMarriage = tmar, monthInterview = tint,
           maleAge = mage, femaleAge = fage,
           malePartners = mlsp, femalePartners = flsp,
           maleEvTest = mevtest, femaleEvTest = fevtest)
dhs
save(dhs, file='alldhs.Rda')
rm(list=ls(all=T))
ls()
## End hiding
rm(list=ls(all=T))
load(url('https://github.com/sbellan61/EPID7500-IntroToR/raw/gh-pages/Day%201/alldhs.Rda'))
dhs
str(dhs)
##################################################
## DHS Questionnaire
## http://dhsprogram.com/publications/publication-dhsq6-dhs-questionnaires-and-manuals.cfm
##################################################

## What do you want to look at in this data to start exploring it?

## Cross-tabulation
xtabs(~mpos + fpos, dhs)
xtabs(~mpos + country, dhs)
xtabs(~ser, dhs)

ggplot(data=filter(dhs, flsp<95 & mlsp<95) , aes(x=flsp, y=mlsp)) + 
  geom_point(aes(colour=mpos), alpha = .5) + 
  facet_wrap(~group, nrow = 4) + geom_smooth(method='lm') +
  xlab('female lifetime sexual partners') +
  ylab('male lifetime sexual partners') 

dhs %>% distinct(country)
dhs %>% distinct(dataset)
dhs %>% distinct(dataset) %>% print(n=40)

dhs %>%
  mutate(tmar = tmar/12+1900) %>%
  filter(group=='Rwanda') %>%
  select(group, tmar, mlsp, flsp) %>%
  slice(1:10)


##################################################
## 1. Pick another two variables and try to visualize them with ggplot.

##################################################
## 2. Modify the following code to find out

##       a) What is the HIV prevalence amongst all women?
dhs %>%
    summarise(fHIVprevalence = sum(fpos)/n())

##       b) What is the HIV prevalence amongst all women by country?
dhs %>%
    group_by(group) %>%
    summarise(fHIVprevalence = sum(fpos)/n())

##       c) repeat a and b but for men

##       d) repeat all of the above but for each data set (variable ds)

##################################################
## 3.

## a) With your partner, think about an epidemiological question of
## interest you think could be answered with this data set.

## b) What plot would you want to make to begin to explore this question? 
