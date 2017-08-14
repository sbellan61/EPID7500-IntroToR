rm(list=ls(all=T))
require(pacman)
p_load(tidyverse, mosaic)
getwd()
setwd('~/Documents/R Repos/EPID7500-IntroToR/Day 1/')
ls()
load(url('https://github.com/sbellan61/Bellan-2013-Lancet-DHS-analysis-/raw/master/alldhs.Rdata'))
ls()


dhs <- as.tibble(dat)
summary(dhs)
names(dhs)

dhs <- mutate(dhs, mpos = ser %in% c(1,2), fpos = ser %in% c(1,3))
xtabs(~mpos + fpos, dhs)
xtabs(~ser, dhs)
dhs <- mutate(dhs, ser = factor(ser))

ggplot(data=filter(dhs, flsp<95 & mlsp<95) , aes(x=flsp, y=mlsp)) + 
  geom_point(aes(colour=ser), size = 1, alpha = .5) + 
    facet_wrap(~group, nrow = 4) + geom_smooth(method='lm') +
  xlab('female lifetime sexual partners') +
  ylab('male lifetime sexual partners') 

dhs %>%
  mutate(tmar = tmar/12+1900) %>%
  filter(group=='Rwanda') %>%
  select(group, tmar, mlsp, flsp) %>%
  slice(1:10)



## DHS Questionnaire
## http://dhsprogram.com/publications/publication-dhsq6-dhs-questionnaires-and-manuals.cfm
# uid user id
# ds data set
# ser serostatus (1 --, 2 m+f-, 3m-f+, 4++)
# tms/tfs male/female month of first sex (months since 1990)
# tmar month of marriage (months since 1990)
# tint month of interview (months since 1990)
# mardur.mon marital duration in months
# circ male circumscision status
# mage/fage male/female age at interview date
# m/flsp lifetime sexual partners
# m/fevtest ever tested for hiv




# dhs <- as.tibble(allraw)
# ggplot(data=dhs, mapping=aes(x=FLiteracy, y = FAge.at.first.intercourse)) + geom_point()
# ggplot(data=dhs, mapping=aes(x=FLiteracy, y = FAge.at.first.intercourse)) + geom_boxplot()
# ggplot(data=dhs, mapping=aes(x=FLiteracy, y = FHIVresult)) + geom_point()
# 
