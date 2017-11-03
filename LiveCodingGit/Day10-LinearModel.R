####################################################################################################
## EPID 7500
## Steve Bellan
## Fall 2017
## UGA
## Licensed for reuse with attribution as CC-BY NC
## (https://creativecommons.org/licenses/by-nc/4.0/legalcode)
####################################################################################################
require(tidyverse)

## Let's say we have two continuous variables number of eggs per gram of a parasitic worm blood
## hemoglobin level (g/dl)

## How might we simulate these?

N <- 50
dat <- tibble(epg = rnorm(N, mean = 40, sd = 10))
dat

ggplot(dat, aes(epg)) + geom_histogram()

## What if we thought that hemoglobin level was negatively correlated with eggs per gram? The
## average hemoglobin count is about 14g/dl in uninfected persons. Let's assume that the count
## dropped 1g/dl for every 20 epg a person was infected with:

dat <- dat %>% mutate(hb_expected = 14 - epg/20)

ggplot(dat, aes(epg, hb_expected)) + geom_point() + xlim(0, 100) + ylim(0,20)

## But in actuality, even if this was the effect of epg on HB, there are many other things that
## additionally affect HB, and HB measures themselves might vary due to measurement noise or just
## temporal variation in HB levels. We can think about this as extra variation around this
## relationship betewen epg and HB. We can simulate it by using normally distributed random
## noise. Let's assume that the standard deviation of this extra noise is 1.2

dat <- dat %>% mutate(hb_noise = rnorm(n(), 0, sd=1.2),
                      hb = hb_expected + hb_noise)

ggplot(dat, aes(epg, hb)) + geom_point() + xlim(0, 100) + ylim(0,20)

## This now looks like real data we might have actually collected. It seems suggestive of a
## relationship, but there is noise making it difficult to discern visually whether the relationship
## is real, or whether there could just be no relationship but look like there is due to the
## noisiness of the data.

## 1) Turn the above code into a function that has arguments for the sample size, the mean and sd of
## epg, the relationship between epg and HB, the sd of HB, and a logical option of whether to plot a
## scatter plot of the HB data vs the epg data or not.

createMyStudy <- function() {

}

## When we want to explore a relationship between two continuous variables, a natural first attempt
## to characterize the relationship is to fit a line between them. This is the "linear model". The model is of the form:

## y_i = a + b*x_i + e_i

## y_i is the i-th observation of the outcome variable (HB)
## x_i is the i-th observation of the explanatory variable (epg)
## a is the intercept, i.e. the expected value of y_i when x_i = 0
## b is the slope, i.e. the change in y_i for a unit change in x_i
## e_i is the residual error, i.e. the extra noise in y_i around it's expected value given x_i

## Above we have simulated the linear model by assuming a, b, and a normally distributed e_i with
## some known standard deviation. We can now fit a linear model to the simulated data that come from
## this underlying "true" linear model that we've assumed.

mod <- lm(hb ~ epg, data = dat)
mod ## not so useful
summary(mod) ## usually the most useful output comes from summary() of a model
coef(mod)
confint(mod)

## ggplot will also fit a linear model to our data for us if we ask it to

ggplot(dat, aes(epg, hb)) + geom_point() + xlim(0, 100) + ylim(0,20) +
    geom_smooth(method='lm')

## 2) edit your function so that it
##      A. when plotting, it plots the linear model as well. 
##      B. returns a tibble that contains as columns: slope estimate & confidence intervals,
##      intercept estimate and confidence intervals.

## 3) Create another function, simulateLM() that runs your createMyStudy function a specified number of times, and
## collects the output into a single tibble, plotting the confidence intervals of the slope.

simulateLM <- function() {

    }

## 4) Now have simulateLM also plot the intercept (hint use gather to convert the slope &
## intercept data to long format)

## 5) Have simulateLM return the proportion of simulations whose confidence intervals for the slope
## do not include 0 (i.e. this can be done using confidence intervals or P values for the slope
## estimate being significantly different from zero). Recall, this is known as statistical power:
## the probability that a study rejects the null hypothesis of no effect.

## 6) Calculate study power for simulations in which there is no relationship between epg and HB
## (i.e. the slope equals zero). What should this number actually be?

## 7) Change the slope back to 1/20 as originally. Change the distribution of epg to have a standard
## deviation of 2 instead of 10 in the rnorm() statement. How does study power compare in this
## simulation to when there is more variance in epg?

## There are two problems with using normally distributed epg:

## A) Firstly, epg cannot be negative. Yet there is a non-zero probability that epg is if we use a
## normal distribution. We can show this with the cumulative normal probability density function:

pnorm(0, mean = 40, sd = 10, lower.tail=T)
## This probability is very small, but if we changed the sd to be larger, we could accidentally
## start simulating negative epg.
pnorm(0, mean = 40, sd = 30, lower.tail=T)

## B) Secondly, parasite burden (as measured by epg here) is often highly skewed such that a few humans have
## very high epg's, but most humans have very few epgs. The normal distribution is unable to
## accurately reflect this.

## There are several other probability distributions that can create randomly distributed numbers
## that are highly skewed and strictly positive. Two common choices are the lognormal distribution,
## which is the distribution of a variable whose logarithm is normally distributed. I.e.

## exp(x) ~ normal(mean, sd)
## x ~ lognormal(meanlog, sdlog)

x <- rlnorm(100, meanlog=0, sdlog=1)
x
mean(log(x))
sd(log(x))

ggplot(data = tibble(x=x), aes(x)) + geom_histogram()

## note that if we specify meanlog on a log scale, it gives us close to the mean. However, the mean
## of a lognormally distributed variable increases with its variance (sd) too.
mu <- 4
sigma <- .5
x <- rlnorm(1000, meanlog=log(mu), sdlog=sigma)
mean(x) 
exp(log(mu) + sigma^2/2) ## analytic expression for mean of lognormal: exp(meanlog + sd^2/2)

## 8) change mu and sigma above to 80 and 3

## 9) Add to createMyStudy an option to use a lognormal distribution instead of a normal
## distribution and rerun simulateLM, playing around with the size of meanlog and sdlog.

