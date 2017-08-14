rm(list=ls(all=T)) ## clean the workspace
require(tidyverse) ## load the tidyverse R package (i.e. extension)
getwd() ## what working directory am I currently in?
setwd('~/Documents/R Repos/EPID7500/Day 1/') ## set the current working directory
getwd()
ls() ## what objects exist in the workspace? (none right now)
## load Demograhpic and Health Survey data from Steve's site (already somewhat cleaned for a prior analysis)
load(url('https://github.com/sbellan61/EPID7500-IntroToR/raw/gh-pages/Day%201/alldhs.Rda'))
ls() ## now an object does exist, it's called dhs

dhs ## we can see some of that object
str(dhs) ## let's look at the object summary
##################################################
## Have a look at the DHS Questionnaire
## http://dhsprogram.com/publications/publication-dhsq6-dhs-questionnaires-and-manuals.cfm
##################################################

## What do you want to look at in this data to start exploring it?

## Cross-tabulation
dhs %>% ## the package dplyr says take a data set and do something to it (%>% says do the next thing)
  summarize(sum(fpos)/n()*100) ## dplyr function summarize to calculate the prevalence of HIV amongst women

dhs %>% ## the package dplyr says take a data set and do something to it (%>% says do the next thing)
  summarize(sum(mpos)/n()*100) ## dplyr function summarize to calculate the prevalence of HIV amongst men

dhs %>%
  group_by(country) %>%  ## take dhs and group it by country
  summarize(malePrevalence = sum(mpos)/n()*100, 
            femalePrevalence = sum(fpos)/n()*100)

## practice with 
dhs %>% slice(1:5) %>%  ## a slice of the first 5 rows
  select( monthMarriage, monthInterview, maleAge) %>% ## select some columns
  ## calc months since married
  mutate(monthsSinceMarried = monthInterview - monthMarriage) %>%
  ## use that to calculate age at marriage
  mutate(maleAgeAtMarriage = maleAge - monthsSinceMarried)



## do it for real
dhs <- dhs %>%  ## on the whole data set
  mutate(monthsSinceMarried = monthInterview - monthMarriage) %>%
  ## use that to calculate age at marriage
  mutate(maleAgeAtMarriageYrs = (maleAge - monthsSinceMarried)/12,
         femaleAgeAtMarriageYrs = (femaleAge - monthsSinceMarried)/12)


str(dhs)
graphics.off() ## reset graphics (in case old stuff was screwing things up)
## plot age at marriage female vs male
ageAtMarriagePlot <- ggplot(data=dhs, aes(x=maleAgeAtMarriageYrs, y=femaleAgeAtMarriageYrs)) + 
  xlab('male age (years)') +   ylab('female age (years)')

ageAtMarriagePlot + geom_point(alpha = .03, col = 'blue')
ageAtMarriagePlot + geom_point(alpha = .1, col = 'purple')
ageAtMarriagePlot + geom_point(alpha = .1, col = 'brown') + facet_wrap(~country) ## by country

## calculate centroids by country to plot on top of scatter plot
centroids <- aggregate(cbind(maleAgeAtMarriageYrs,femaleAgeAtMarriageYrs)~country,dhs,mean)
centroids

## by country with centroids
ageAtMarriagePlot + geom_point(alpha = .1, col = 'brown') + facet_wrap(~country) + 
  geom_point(data=centroids,size=2)

## figure out axis limits in a regimented way to use later
axismin <- min(centroids$maleAgeAtMarriageYrs, centroids$femaleAgeAtMarriageYrs) 
axismax <- max(centroids$maleAgeAtMarriageYrs, centroids$femaleAgeAtMarriageYrs)

## plot just the centroids
ggplot(centroids, aes(x=maleAgeAtMarriageYrs, y=femaleAgeAtMarriageYrs)) + geom_point(aes(col=country)) +
  xlim(axismin, axismax) + ylim(axismin, axismax) 
