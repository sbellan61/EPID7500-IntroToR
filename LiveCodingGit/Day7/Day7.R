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
## Load names from the internet
bnames <- read_csv('https://raw.githubusercontent.com/hadley/data-baby-names/master/baby-names.csv')
bnames <- bnames %>% mutate(sex=factor(sex))
levels(bnames$sex) <- c('male','female') ## change the levels from boy/girl
bnames
## Create table of cancer risk by sex & smoking from Canadian study
lifetimeLungCancerRisk <- crossing(sex = factor(c('male','female'), levels = c('male','female')),
                                   smoker = c(T,F))
lifetimeLungCancerRisk <- lifetimeLungCancerRisk %>% ## from https://www.ncbi.nlm.nih.gov/pubmed/7895211
    mutate(risk = c(14,116,13,172)/1000) 

createMyStudy <- function(sampSize=1000, printXtabs=F, groupRisks = lifetimeLungCancerRisk, browse=F) {
    if(browse) browser()
    myStudy <- select(bnames, name, sex) %>% 
        slice(sample(1:n(), sampSize, replace=F)) ## randomly select sampSize rows
    myStudy <- mutate(myStudy, smoker = sample(c(T,F), n(), replace=T)) ## add smoker data
    ## Join tables to add risk to myStudy
    myStudy <- left_join(myStudy, groupRisks, by=c('sex','smoker'))
    myStudy <- myStudy %>% ## simulate cancer
        mutate(cancer = rbinom(n=n(), size=1, prob=risk))
    if(printXtabs) print(xtabs(~smoker + cancer, myStudy))
    return(myStudy)
}
createMyStudy(sampSize=100, printXtabs = T, browse=F)

## Calculate a risk ratio
CalcPrevRatio <- function(data, browse=F) {
    if(browse) browser()
    prevRatioSmoking <- group_by(data, smoker) %>%
        summarize(prevalence = mean(cancer)) %>%
        summarize(prevRatioSmoking = prevalence[smoker==T] / prevalence[smoker==F]) %>%
        .$prevRatioSmoking
    return(prevRatioSmoking)
}

myStudy <- createMyStudy(sampSize=100) ## simulate
CalcPrevRatio(data=myStudy, browse=F) ## analyze

####################################################################################################
## Statistical inference with non-parametric resampling tests
####################################################################################################

## We're testing whether smoking is correlated with lung cancer. Statistical inference is based on
## the idea of generating a null hypothesis of no relationship and then seeing whether the available
## data can be used to reject the null hypothesis. Here the null hypothesis would be that smoking
## and cancer are NOT associated. If this was true then the fact that some individuals smoke and
## some do not is totally unrelated to their cancer outcome column, and any correlation we see
## between smoking and cancer in our data is just a product of random noise.

## We can resample our data in a way such that the null hypothesis IS TRUE in the resampled
## data. All we neeed to do, is to jumble up the smoker variable, while keeping the cancer column
## the same:

permuteStat <- function(data, statFun=CalcPrevRatio, permutations = 999, 
                        showHist=T, updateFreq = 200, browse=F) {
    if(browse) browser()
    actualPrevRatio <- CalcPrevRatio(myStudy)
    message('study statistic is ', signif(actualPrevRatio,3))
    output <- vector('double', permutations)
    for(i in seq_along(output)) {
        if(i %% updateFreq ==0)  print(i)
        jumbledSim <- data %>%
            mutate(smoker = sample(smoker, size = n(), replace=FALSE))
        output[i] <- statFun(jumbledSim)
    }
    prevRatiosAll <- tibble(prevRatio = c(actualPrevRatio, output),
                            randomized = c(F, rep(T, length(output)))
                            )
    if(showHist) {
        g <- ggplot(prevRatiosAll, aes(x=prevRatio, fill=randomized)) +
            scale_x_log10() + 
            geom_histogram(bins = 30) +
            geom_vline(xintercept = actualPrevRatio, col = 'red')
        print(g)
    }
    prevRatiosAll
}

myStudy <- createMyStudy(sampSize=300, printXtabs=T)
permutationTestResults <- permuteStat(myStudy) ##, permutations=1, browse=F)

calcPvalue <- function(allVals) {
    upperTail <- allVals %>% summarize(mean(prevRatio >= prevRatio[!randomized]))
    lowerTail <- allVals %>% summarize(mean(prevRatio <= prevRatio[!randomized]))
    min(upperTail, lowerTail)
}
calcPvalue(permutationTestResults)


####################################################################################################
## 1. What is the true prevalence ratio amongst men and women?

####################################################################################################
## 2. Create a new table where the risk ratio is only 1.5

## 3. Run the study simulator with this risk

####################################################################################################
## 4. Power calculation: If your sample size is 200, what is the probability that your study would be
## able to detect that smoking had a statistically significant effect on cancer (P > .05)?

## 5. In your own words define a p Value

## Read more about permutation tests: https://en.wikipedia.org/wiki/Resampling_(statistics)#Permutation_tests

## 6. Logistic regression is another common way to evaluate binary outcomes
myModel <- glm(cancer ~ smoker, family=binomial(link='logit'), data=myStudy)
summary(myModel) ## summary of results

coef(myModel) ## just coefficients
confint(myModel) ## confidence intervals around them

exp(coef(myModel))['smokerTRUE'] ## the odds ratio between smokers and non-smokers
exp(confint(myModel))['smokerTRUE',] ## the confidence interval around that odds ratio

coef(summary(myModel)) ## model coefficients and statistics
coef(summary(myModel))['smokerTRUE',4] ## p value on smoking

####################################################################################################
####################################################################################################
## Probability distributions

## Above, we considered a binary outcome (cancer). To simulate a binary outcome as a function of
## explanatory variables, we use the binomial distribution. What other kinds of random variables are
## there?

####################################################################################################
## 1. Continuous random variables are very common (weight, height, hemoglobin level, etc). We often
## use the normal (AKA gaussian) distribution to model these because many continuous variables have
## this distribution
stdNormalDensityFxn <- function(x) dnorm(x, mean = 0, sd = 1)
curve(stdNormalDensityFxn, from = -3, to = 3)

samp <- rnorm(1000, mean=0, sd=1)
hist(samp)
hist(samp, breaks = 100)

####################################################################################################
## Confidence Intervals
####################################################################################################

## 1. In the above example we considered three binary random variables (smoking, sex, cancer). Let's
## now consider a continuous variable, simulating the effect of vitamin A supplementation on changes
## in a child's height over time

## https://www.ncbi.nlm.nih.gov/pubmed/10648265
createWeightStudy <- function(sampSize=1000, printXtabs=F, meanHeights, browse=F) {
    if(browse) browser()
    myStudy <- select(bnames, name, sex) %>% 
        slice(sample(1:n(), sampSize, replace=F)) ## randomly select sampSize rows
    myStudy <- myStudy %>% mutate(vitaminA = sample(c(T,F), n(), replace=T)) %>%
        mutate(height = NA) %>%
        mutate(height = replace(height, vitaminA==T, rnorm(sum(vitaminA), 100, 5))) %>%
        mutate(height = replace(height, vitaminA==F, rnorm(sum(!vitaminA), 95, 5)))
    return(myStudy)
}

wtDat <- createWeightStudy()
ggplot(wtDat, aes(height, fill=vitaminA)) + geom_histogram(position='dodge')



