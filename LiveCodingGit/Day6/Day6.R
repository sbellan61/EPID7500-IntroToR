####################################################################################################
## EPID 7500
## Steve Bellan
## Fall 2017
## UGA
## Licensed for reuse with attribution as CC-BY NC
## (https://creativecommons.org/licenses/by-nc/4.0/legalcode)
####################################################################################################
require(tidyverse)

####################################################################################################
## Simulating a study using a function
####################################################################################################
## Let's pick up where we left off last week. Here's the same code in
## a more compact form (and removing the extraneous pedagogical parts)

## **** ##
sampSize <- 1000
bnames <- read_csv('https://raw.githubusercontent.com/hadley/data-baby-names/master/baby-names.csv')
myStudy <- select(bnames, name, sex) %>% 
  slice(sample(1:n(), sampSize, replace=F)) ## randomly select sampSize rows
myStudy <- myStudy %>% mutate(sex = factor(sex)) ## make sex a factor
levels(myStudy$sex) <- c('male','female') ## change the levels from boy/girl
myStudy <- mutate(myStudy, smoker = sample(c(T,F), n(), replace=T)) ## add smoker data
## set up lung cancer risk table for sex/smoker status
lifetimeLungCancerRisk <- crossing(sex = factor(c('male','female'), levels = c('male','female')),
 ## specified levels for sex in the same order as above in myStudy to avoid warnings during join
                                   smoker = c(T,F))
lifetimeLungCancerRisk <- lifetimeLungCancerRisk %>% 
  mutate(risk = c(14,116,13,172)/1000) ## from https://www.ncbi.nlm.nih.gov/pubmed/7895211

## Join tables to add risk to myStudy
myStudy <- left_join(myStudy, lifetimeLungCancerRisk, by=c('sex','smoker'))
myStudy <- myStudy %>% ## simulate cancer
  mutate(cancer = rbinom(n=n(), size=1, prob=risk))
## **** ##

myStudy

####################################################################################################
## 1A look at some cross tabulations of your simulation
xtabs(~cancer, myStudy)
xtabs(~smoker + cancer, myStudy)
xtabs(~smoker + cancer + sex, myStudy)

## 1B Guess: How big of a sample size do you think you would have
## needed for this study to be reasonably sure smoking really is
## correlated with cancer risk? Write your guess down:


####################################################################################################
## 2A Convert the code between the two (## **** ##) above into a
##    function with an argument for sampSize.  Try it out on a few
##    sampSizes.

## 2B Add a logical argument called printXtab to your function that,
##    if TRUE, prints the crosstabulation of smoker X cancer.

## 2C Run the function for sampSize of 10, 20, 30, 100, and 1000 using
## sapply(), printing the cross tbulation

####################################################################################################
## Debugging
####################################################################################################
## R's built in debugging mode allows you to walk around inside a function.
?browser
?debug

## 3A Call debug() on the name of your function and then run your
## function again, using R's debugger to step through it and explore
## objects as you go.

## 3B Add the following line to the top of your function
if(browse) browser()
## And add the argument browse with a default of FALSE to your
## function's arguments. Then run your function once with the default
## for browse, and once with browse=T.


####################################################################################################
## Risk Ratios
####################################################################################################
## As you have learned or will be learning in your introductor epi
## class, a common way to measure an effect of a risk ractor is with a
## risk ratio. In our simulated study, we don't have any real notion
## of time (just lifetimes). So our measure of cancer is prevalence.

mean(myStudy$cancer) ## prevalence of cancer

## We can measure prevalence in both the smoking & non-smoking groups
prevXsmoker <- group_by(myStudy, smoker) %>%
    summarize(prevalence = mean(cancer))
prevXsmoker

## And we can calculate a prevalence ratio of smoker vs non-smoker

prevRatioSmoking <- summarize(prevXsmoker, prevRatioSmoking = prevalence[smoker==T] / prevalence[smoker==F]) %>%
    .$prevRatioSmoking
prevRatioSmoking

## 4A Create a function that takes the output of your study simulator
## and calculates this prevalence ratio



####################################################################################################
## Statistical inference with non-parametric resampling tests
####################################################################################################

## We're testing whether smoking is correlated with lung
## cancer. Statistical inference is based on the idea of generating a
## null hypothesis of no relationship and then seeing whether the
## available data can be used to reject the null hypothesis. Here the
## null hypothesis would be that smoking and cancer are NOT
## associated. If this was true then the fact that some individuals
## smoke and some do not is totally unrelated to their cancer outcome
## column, and any correlation we see between smoking and cancer in
## our data is just a product of random noise.

## We can resample our data in a way such that the null hypothesis IS
## TRUE in the resampled data. All we neeed to do, is to jumble up the
## smoker variable, while keeping the cancer column the same:

myStudyJumbled <- myStudy %>%
    mutate(smoker = sample(smoker, size = n(), replace=FALSE))
myStudyJumbled

## 5A Use your function from 4 above to calculate the prevalence ratio
## for data with smoker jumbled.

## 5B Write a for() loop that repeats this 10 times (jumble, calculate
## prevalence ratio, store prevalence ratio in a vector).

## *Hint*: Here's some example code that shows how you can use a for()
## loop to fill a vector

runs <- 10
vectorToFill <- as.numeric() ## initiate an empty vector that's of class numeric
for(i in 1:runs) {
## append something to the vector (starts out empty then gets filled up one at a time)
    vectorToFill <- c(vectorToFill, i*2 + 10) 
}
vectorToFill

## 5C Now do it 1000 times. Plot a histogram of these prevalence
## ratios from the jumbled data using ggplot() + geom_histogram()

## 5D add a vertical red line for where the prevalence ratio from the
## true data lies.

## 5E Interpret this plot, what does it tell you?

## 5F Repeat 5C-D above for a simulated study sample size of 100. What is the difference?
