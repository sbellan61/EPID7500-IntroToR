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
## Simulating logistic regression
####################################################################################################

## Last week we looked at how to take a mean of a normal sample. What if we have two variables, one
## of which is normally distributed?There are many different ways this could happen. Our outcome
## variable might be continuous and normally distributed, or our independent variable might be
## normal and continuously distributed, or both might be continuous, but one might be normally
## distributed another might be distributed in a different way according to another probability
## distribution. In general we take our independent variable's probability distribution for granted
## in analysis. I.e. we assume that we are looking at the distribution of outcome variables
## conditional on the observations of the independent variable, but don't think about the fact that
## the independent variables are coming from a probability distribution itself that is reflective of
## the population we are interested in.

## However, when we simulate data, we always need to think about what a probability distribution is
## underlying any data that we simulate because that is how we generate it via simulation. For
## instance, if we were simulating randomized controlled trial in which people are assigned an
## exposure variable (such as vitamin supplementation), we may say that the distribution of this
## variable is that everyone has a 50% chance of getting supplementation. however, we are thinking
## about an independent variable that is not assigned via study design, then we need to think about
## what type of distribution of this variable might exist in the population. Many variables tend to
## look normally distributed, but sometimes they are different patterns such as bimodal patterns.
## For now, we will stick to simple distribution such as the normal distribution or the uniform
## distribution.

##  Imagine we are considering an observational study of how body mass index (BMI) affects risk of
##  active tuberculosis (TB). How might we simulate BMI?  well what does the distribution of BMI actually look like in a real population? Here's an example from a German study:

## https://openi.nlm.nih.gov/detailedresult.php?img=PMC3022146_404_2009_1349_Fig1_HTML&req=4

## Note that it looks normally distributed, but there is a clear lower bounds. Nobody can have a BMI
## lower than 0.  There are useful distributions to know for variables that are strictly
## positive. The lognormal is one of them.

samp <- rlnorm(200, meanlog=0, sdlog=1)
samp

xmin <- 0
xmax <- 5
p1 <- ggplot(data = tibble(x=samp), aes(x)) + geom_histogram(aes(y=..density..), alpha = .3, fill = 'purple', binwidth = .2) + 
    xlim(xmin,xmax) + xlab('log-normal random variable') + ylab('probability density')
p2 <- p1 + stat_function(fun = dlnorm, geom='area', xlim = c(xmin,xmax), alpha =.3) ## plots this function of x
p2

## 1) Change the meanlog & sdlog above so that you simulate data that look like the German
## curve.

## *Hint* (1) look at the mean at the top right of the figure! (2) Using the SD in the
## figure, even on a log scale, won't give you their data because it turns out the mean scales with
## the sd on the log scale. Try a value for sdlog < .5

mulog <- log(23.5)
sdlog <- .3
samp <- rlnorm(200, meanlog=mulog, sdlog=sdlog)
samp
mean(rlnorm(200, meanlog=mulog, sdlog=sdlog))

xmin <- 0
xmax <- 50
p1 <- ggplot(data = tibble(x=samp), aes(x)) + geom_histogram(aes(y=..density..), alpha = .3, fill = 'purple', binwidth = 1 ) + 
    xlim(xmin,xmax) + xlab('log-normal random variable') + ylab('probability density')
p2 <- p1 + stat_function(fun = dlnorm, geom='area', xlim = c(xmin,xmax), alpha =.3,
                         args = list(meanlog=mulog, sdlog=sdlog))
p2

## Now that we have a working model of what some BMI data might look like, we can start to think about our study.

sampSize <- 200
dat <- tibble(id=1:sampSize, BMI=rlnorm(sampSize, mulog, sdlog), tb=NA)

head(dat)

## From Table 5 of this JAMA paper

## https://jamanetwork.com/journals/jamainternalmedicine/fullarticle/412684

## we have the following estimates of the hazard ratio for active TB by BMI class:
## BMI          adjusted hazard ratio
## >= 30        0.38
## 25-30        0.58
## 23-25        0.74
## 18.5-23      1 (reference)
## <18.5        2.11

## R has a way of cutting continuous variables into categorical variables
BMIbreaks <- c(0, 18.5,23,25,30, 100)
sampCat <- cut(samp, breaks = BMIbreaks)
sampCat
levels(sampCat)

tb_risk_by_BMI <- tibble(BMIcat = factor(levels(sampCat)),
                         aHR = c(.38, .58, .74, 1, 2.11), 
                         aHRlower = c(.21, .46, .58, NA, 1.59),
                         aHRupper = c(.7, .74, .94, NA, 2.79))
tb_risk_by_BMI 

ggplot(tb_risk_by_BMI, aes(BMIcat, aHR)) +
    geom_point() +
    geom_errorbar(aes(ymin=aHRlower, ymax=aHRupper))

## The incidence of TB amongst the reference class (18.5-23) is given as 291/100,000 person-years in Table 2 of
## the above paper.

## 2) simulate TB risk in the above data frame so that it reflects this level of risk and the above hazard ratios.
## *Hint* You'll have to
##      1. add hazard (risk per person year) to the tb_risk_by_BMI table above.
##      2. add a categorical BMI column to your study data
##      3. join the two tables

tb_risk_by_BMI <- tb_risk_by_BMI %>% mutate(tbhazard = 291/10^5 * aHR)
tb_risk_by_BMI

dat <- dat %>% mutate(BMIcat = cut(BMI, BMIbreaks))
dat

dat <- left_join(dat, tb_risk_by_BMI, by='BMIcat')
dat

## 3) Now let's imagine this was an observational cohort, for which all individuals did not have
## active TB at baseline and were followed up after 1 year. Simulate tb outcome as a binary random variable.

dat <- dat %>% mutate(tb = rbinom(n(), 1, prob = 1-exp(-tbhazard*1)))
dat
## Note: The probability of an event occurring in a time interval T equals 1-exp(-rate*T), where rate
## is the rate of the event. Thhis is very similar to rate*T for very small rate*T but can be far
## off for larger values.

## 4) Cross-tabulate active cases by BMIcat using xtabs. 

xtabs(~tb + BMIcat, dat)

## 5) Take the above code and turn it into a function where printing the crosstabulation is an option.

BMIbreaks <- c(0, 18.5,23,25,30, 100)
BMIcatlevels <- levels(cut(1:50, breaks = BMIbreaks))

simStudy <- function(sampSize=1000,
                     hazards = tb_risk_by_BMI, refHazard = 291/10^5, 
                     meanlogBMI=log(23.5), sdlogBMI=.3,
                     showXtabs=T, browse=F) {
    if(browse) browser()
    tb_risk_by_BMI <- tb_risk_by_BMI %>% mutate(tbhazard = refHazard * aHR)
    dat <- tibble(id=1:sampSize, BMI=rlnorm(sampSize, meanlogBMI, sdlogBMI)) %>%
        mutate(BMIcat = cut(BMI, BMIbreaks))
    dat <- left_join(dat, tb_risk_by_BMI, by='BMIcat')
    dat <- dat %>% mutate(tb = rbinom(n(), 1, prob = 1-exp(-tbhazard*1)))
    if(showXtabs) print(xtabs(~tb + BMIcat, dat))
    dat
}

simStudy()

## 6) Try your simulation for a sample size of 50,000 (about the size of the Hong Kong study in the
## JAMA paper)
sim1 <- simStudy(50000)
sim1

## 7) Let's look at whether BMI is a significant predictor of tb risk using a logistic regression
## with BMI as a *continuous* variable.
mod1 <- glm(tb ~ BMI, family=binomial('logit'), data = sim1)
summary(mod1)

## A logistic model models the log(odds) of a binary outcome as a function of the explanatory
## variables. The odds is p/(1-p), where p is the probability of an outcome:

## log(p/1-p) = log_odds_intercept + log_odds_ratio_per_unit_BMI * BMI where odds_intercept
## basically means the odds for if BMI was zero (which is important for fitting the model but is not
## really meaningful epidemiologically)

oddsfxn <- function(x) x/(1-x)
logisticfxn <- function(x) log(oddsfxn(x))
logisticfxn(.5)

## Let's plot the odds vs probability in base R
curve(oddsfxn, from=0, to = .03, xlab='probability of outcome', ylab='odds of outcome', lwd=3)
## 8) Note that probability and odds are very close when probability is small by zooming in (set to=.03 and add asp=1)

## Plot the log odds
curve(logisticfxn, from=0, to = 1, xlab='probability of outcome', ylab='log odds of outcome', lwd=3)


## By transforming from a probability to a log(odds), we now have an outcome variable that ranges
## from -Inf to Inf, instead of 0 to 1, which means we can model this outcome variable as a linear
## function of explanatory variables without worrying about it going in unreasonable areas (we can't
## fit a line to probabilities because the line may go negative or over 1).

## What R is returning in summary(mod1) is the log_odds_ratio_per_unit_BMI
summary(mod1)
coef(summary(mod1))
logOR_intercept <- coef(summary(mod1))['(Intercept)','Estimate']
logOR_BMI <- coef(summary(mod1))['BMI','Estimate']
logOR_BMI_CI <- confint(mod1)['BMI',]

## To get the odds_ratio_per_unit_BMI, we have to exponentiate it
OR_BMI <- exp(logOR_BMI)
OR_BMI_CI <- exp(logOR_BMI_CI)
c(OR_BMI, OR_BMI_CI)

## With the above parameters we can figure out the model's predicted probability of someone with a
## given BMI having acquired active TB over the year in our study
BMIseq <- 0:60
logOddsBMI <- 
modelFit <- tibble(BMI = BMIseq) %>%
    mutate(logOddsBMI = logOR_intercept + logOR_BMI * BMIseq,
           oddsBMI = exp(logOddsBMI),
           probBMI = oddsBMI/(1+oddsBMI)) ## o = p/(1-p); o - op = p; o = p + op; o =(1+o)p; p = o/(1+o) 
modelFit

s1 <- ggplot(modelFit, aes(x=BMI, y=probBMI)) +
  geom_line(col='red')

s1 + geom_point(aes(x=BMI, y = as.numeric(tb)), data = sim1, shape = 21, size = 2, position=position_jitter(width=0, height = .05), alpha = .3)

## 9) Within your simulated data, find the mean values of the probability of acquiring TB over the year for the center point of
## each BMI category and then calculate the hazard ratios with respect to the reference level

## 10) Change your study simulation function so it returns a tibble with columns for the OR_BMI
## estimate, confidence intervals, and p value

simStudy <- function(sampSize=1000,
                     hazards = tb_risk_by_BMI, refHazard = 291/10^5, 
                     meanlogBMI=log(23.5), sdlogBMI=.3,
                     showXtabs=T, doMod=F, browse=F) {
    if(browse) browser()
    tb_risk_by_BMI <- tb_risk_by_BMI %>% mutate(tbhazard = refHazard * aHR)
    dat <- tibble(id=1:sampSize, BMI=rlnorm(sampSize, meanlogBMI, sdlogBMI)) %>%
        mutate(BMIcat = cut(BMI, BMIbreaks))
    dat <- left_join(dat, tb_risk_by_BMI, by='BMIcat')
    dat <- dat %>% mutate(tb = rbinom(n(), 1, prob = 1-exp(-tbhazard*1)))
    if(showXtabs) print(xtabs(~tb + BMIcat, dat))
    if(doMod)
    {
        tempmod <- glm(tb ~ BMI, family=binomial('logit'), data = dat)
        OR_BMI <- exp(coef(summary(tempmod))['BMI','Estimate'])
        OR_BMI_CI <- exp(confint(tempmod)['BMI',])
        return(list(dat=dat, OR_BMI=tibble(est = OR_BMI,
                                           lower = OR_BMI_CI[1],
                                           upper = OR_BMI_CI[2],
                                           p = coef(summary(tempmod))['BMI','Pr(>|z|)'])))
    }else{
        return(dat)
    }
}

simStudy(50000, doMod=T)
