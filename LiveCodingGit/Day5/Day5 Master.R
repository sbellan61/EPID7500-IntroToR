## EPID 7500 - Day 5
## Fall 2017
## Steve Bellan

## Start with binomial distribution tutorial (change to dplyr version).

## Simulating data & Visualizing it
require(tidyverse)

## We'll use the dplyr & ggplot libraries to create simulated data and examine it.

## 1. Load in data on baby names with which to create some fake data
bnames <- read_csv('https://raw.githubusercontent.com/hadley/data-baby-names/master/baby-names.csv')
names(bnames)

## read about the sample function
?sample

## 1A Use the sample function to pick 5 random names from the above data set while sampling WITH replacement
sample(bnames$name, 5, replace=T)

## Edit the below code to select 1000 random names WITHOUT replacement, along with sex
sampSize <- 1000
myStudy <- select(bnames, name, sex) %>% 
  slice(sample(1:n(), sampSize, replace=F))

## Fix the levels of sex so that they say 'male' & 'female' instead of 'boy' & girl'
unique(myStudy$sex)
myStudy <- myStudy %>% mutate(sex = factor(sex))
levels(myStudy$sex)
levels(myStudy$sex) <- c('male','female')
levels(myStudy$sex)
myStudy

myStudy <- myStudy %>%
  mutate(smoker = sample(c(T,F), n(), replace=T))

## Read this abstract: https://www.ncbi.nlm.nih.gov/pubmed/7895211
## Let's create a table of lifetime cancer risk. We need every combination of sex/smoker.

crossing(1:2,8:9)
crossing(1:2,head(letters,2), tail(letters,2))
## What does crossing do?

## Use crossing to make a 4 row tibble that has every combination of sex and smoker status
lifetimeLungCancerRisk <- crossing(sex = factor(c('male','female')),
                                   smoker = c(T,F))
## Fill in the lung cancer risk for each of the 4 combinations of sex and smoker
lifetimeLungCancerRisk <- lifetimeLungCancerRisk %>%
  mutate(risk = c(14,116,13,172)/1000) ## risk amongst Canadians from above reference
lifetimeLungCancerRisk

levels(lifetimeLungCancerRisk$sex)
levels(myStudy$sex)

?left_join
myStudy <- left_join(myStudy, lifetimeLungCancerRisk, by=c('sex','smoker'))
## You may have gotten a warning above. Figure out the source of the warning by 
## examining the levels of sex in both data tables. Should you be worried? 
## How can you make sure it hasnt caused a problem?

myStudy

?rbinom
args(rbinom)
rbinom(n=1, size=10, prob=.5)
rbinom(n=10, size=1, prob=.5)

myStudy <- myStudy %>%
  mutate(cancer = rbinom(n=n(), size=1, prob=risk))

myStudy

## Cross tabulation can be done quikly in R with xtabs
?xtabs

xtabs(~cancer, myStudy)
xtabs(~smoker + cancer, myStudy)
xtabs(~ smoker + cancer + sex, myStudy)

## there are Epidemiology packages in R that make contingency tables 
## of the kind epidemiologists are more familiar with.
install.packages('epitools')
require(epitools)
?epitab

epitab(x=myStudy$smoker, y=myStudy$cancer)
## Do your best to interpret this table with the help of ?epitab

## Let's plot some of the results
p1 <- ggplot(myStudy, aes(x=smoker,y=cancer, fill=sex))

p1 + geom_bar(stat = 'identity') + 
  ylab('number of cancer cases')

p1 + geom_jitter(aes(color=sex))

## Bonus Question: Change the proportion of the population who smokes to 10%.

## Add height to the data set
## https://tall.life/height-percentile-calculator-age-country/
myStudy <- myStudy %>%
  mutate(height = ifelse(sex=='male', 
                         rnorm(n(), 69.3, 2.94),
                         rnorm(n(), 63.8, 2.8)))
myStudy


ggplot(myStudy, aes(height, cancer)) + geom_jitter()
ggplot(myStudy, aes(height, cancer, color=smoker)) + geom_jitter()

## Bonus Question: Simulate cancer outcomes where above cancer rates are true for the average height, but where
# risk increases 10% for every 1 inch increase in height above the mean (& decreases 10% for each 1" below the mean)

