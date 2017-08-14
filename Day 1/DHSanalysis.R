rm(list=ls(all=T))
require(tidyverse)
getwd()
setwd('~/Documents/R Repos/EPID7500-IntroToR/Day 1/')
getwd()
ls()
load(url('https://github.com/sbellan61/Bellan-2013-Lancet-DHS-analysis-/raw/master/alldhs.Rdata'))
ls()

dhs <- as.tibble(dat)
dhs
summary(dhs)
names(dhs)

dhs <- mutate(dhs, mpos = ser %in% 1:2, fpos = ser %in% c(1,3))
save(dhs, file='alldhs.Rda')

xtabs(~mpos + fpos, dhs)
xtabs(~ser, dhs)
dhs <- mutate(dhs, ser = factor(ser))

ggplot(data=filter(dhs, flsp<95 & mlsp<95) , aes(x=flsp, y=mlsp)) + 
  geom_point(aes(colour=mpos), alpha = .5) + 
  facet_wrap(~group, nrow = 4) + geom_smooth(method='lm') +
  xlab('female lifetime sexual partners') +
  ylab('male lifetime sexual partners') 

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


##################################################
## DHS Questionnaire
## http://dhsprogram.com/publications/publication-dhsq6-dhs-questionnaires-and-manuals.cfm
## Variable Names ####################
## uid user id
## ds data set
## ser serostatus (1 --, 2 m+f-, 3m-f+, 4++)
## tms/tfs male/female month of first sex (months since 1990)
## tmar month of marriage (months since 1990)
## tint month of interview (months since 1990)
## mardur.mon marital duration in months
## circ male circumscision status
## mage/fage male/female age at interview date
## m/flsp lifetime sexual partners
## m/fevtest ever tested for hiv
##################################################
