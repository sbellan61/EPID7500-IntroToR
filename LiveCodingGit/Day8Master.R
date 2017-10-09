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
## Normal Confidence Intervals
####################################################################################################


####################################################################################################
## Binomial Probability Distribution Refresher

## 1A. Simulate 30 standard normal random variables ("RVs"; often called "random deviates" as well):
x <- rnorm(30)
mean(x)
sd(x)
## Repeat the above but change 30 to 100, and then 1000

## Refresher: the binomial distribution function tells us the probability of each possible
## outcome for an experiment of binary outcomes.
sz <- 20
p <- .7

## random number generator
rbinom(n=10, size = sz, prob = p)

## binomial probability distribution function: probability of getting exactly 15 "successes"
dbinom(x=17, size = sz, prob = p)

## binomial cumulative probability function: probability of getting <=15 "successes"
pbinom(q=17, size = sz, prob = p, lower.tail=TRUE) 

## 1A) What does the below line do?
pbinom(q=15, size = sz, prob = p, lower.tail=FALSE) 

##################################################
## Plotting the binomial distribution

## Calculate all discrete values of dbinom in the aesthetic part of ggplot
p1 <- ggplot(data = data.frame(x = 0:sz),
             aes(x, y = dbinom(x, sz, p))) + 
    xlim(0,sz) + xlab('random variable') + ylab('probability') + 
    scale_fill_manual(values=c('black', 'blue'))

## Plot the binomial distribution function
p1+ geom_bar(stat='identity') ## add the argument width=1 to geom_bar()

p1 + geom_bar(stat='identity', width = 1, aes(fill= x==15))
## 1B) Write code to calculate the height of the blue bar from the above plot using dbinom

p1 + geom_bar(stat='identity', width = 1, aes(fill= x<=15)) 
## 1C) Write code to calculate the blue area from the above plot using pbinom

p1 + geom_bar(stat='identity', width = 1, aes(fill= x>12)) 
## 1D) Write code to calculate the blue area from the above plot using pbinom



####################################################################################################
####################################################################################################
## The Normal Distribution

## Just like the probability of a binomial random variable (rbinom) comes from the binomial
## probability distribution function (dbinom), normal random variables are characterized by the
## normal *density* function. We'll define probability density in the below section


## random number generator
sampSize <- 20
x <- rnorm(n=sampSize, mean=0, sd=1)
x
mean(x)
sd(x)

## 2A) Run the above lines again for sampSize=100, what happens to mean(x) & sd(x)?

## probability *density* function (NOT distribution): probability density of x=17. We'll discuss what a probability density
dnorm(x=.8, mean=0, sd = 1)
dnorm(x=.8)
## 2B) Why do the above two lines give the same number?

## cumulative probability function: probability of getting a random variable q <=.8
pnorm(q=.8)

## 2C) What does the below line do?
pnorm(q=.8, lower.tail = F)

## Since dnorm is continuous (unlike dbinom which is discrete), we'll use stat_fun in ggplot to plot
## the function rather than just plot it at discrete values: To do this, we'll initialize a dummy
## empty data set since ggplot needs one, then we'll just use stat_fun to plot a function on this
## empty layer
xmin <- -4
xmax <- 4
p1 <- ggplot(data = data.frame(NULL), aes(x)) + 
    xlim(xmin,xmax) + xlab('random variable') + ylab('probability density')
p1 ## empty plot

## Add dnorm() to the plot
p2 <- p1 + stat_function(fun = dnorm, geom='area', xlim = c(xmin,xmax)) ## plots this function of x
p2

## Show the probability of getting <.8 as an area
p2 + stat_function(fun = dnorm, geom='area', xlim = c(xmin, .8), fill = 'blue')

## Show the probability of getting >.8 as an area
p2 + stat_function(fun = dnorm, geom='area', xlim = c(.8, xmax), fill = 'blue')

## 2D) Show the probability of getting between .8 and .9
p2 + stat_function(fun = dnorm, geom='area', xlim = c(.8, .9), fill = 'blue')

## To calculate the probability of getting between .8 and .9 in R, interpret the following plot
p1 + stat_function(fun = dnorm, geom='area', xlim = c(xmin, xmax), fill = 'gray', alpha = .8) +
     stat_function(fun = dnorm, geom='area', xlim = c(xmin, .9), fill = 'blue', alpha = .2) +
    stat_function(fun = dnorm, geom='area', xlim = c(xmin, .8), fill = 'red', alpha = .2)

## thus, the desired probability can be obtained in the following way
pnorm(.9) - pnorm(.8) 

## Coming back to calculus (if you still remember it!): This means thhat the probability density function is the
## derivative of the cumulative probability function, such that integration of the density function
## gives the cumulative probability function.

## What does the cumulative normal probability function look like?
p3 <- p1 + stat_function(fun=pnorm, geom='line', xlim =c(xmin, xmax))
p3

## What does looking at the probability of getting between .8 and .9 look like here?
p3 + geom_hline(data = data.frame(x=c(.8,.9)), aes(yintercept=pnorm(x)), col = c('red', 'blue'))
## The height differences between these lines is equal to the area of the blue bar below
p2 + stat_function(fun = dnorm, geom='area', xlim = c(.8, .9), fill = 'blue')

## 2E) Change the mean to 1.7 and the sd to 3 above and remake all the above plots
## Hint: you will need to
        ## i) change xmin & xmax too and
        ## ii) make sure you give stat_function the new arguments for dnorm using args=list(mean=,sd=)


####################################################################################################
## Confidence intervals of a normal sample
sampSize <- 30
mu <- 3
sigma <- 2
x <- rnorm(sampSize, mu, sigma)
x
mean(x)
sd(x)
## How do we get a confidence interval on the *mean* of x? It is 3, but let's pretend we didn't know that.

## Quantile functions in R: What if we want to know the value of X such that there's a 5%
## probability of chooseing a random variables less than X? We can do this with the qnorm (or qbinom, etc)
## function:
qnorm(p=.05, mean = 0, sd = 1, lower.tail = T)
qnorm(.05) ## note above default arguments

## What if we want to know the value of X such that there's a 5% chance of choosing a random
## variable *greater* than X?
qnorm(.05, lower.tail=F)
qnorm(.95) ## why are these the same?

## So how do we find the symmetrical values on the X-axis such that there's a 95% chance of picking
## a random variable between?
qnorm(p=c(.025, .975)) ## note that just like rnorm, dnorm, pnorm, qnorm can take in vectors

## These are called the 2.5% and 97.5% quantiles of the probability density function (PDF)

## This fact, that standard normal distributions have 95% of their probability mass centered between
## -1.96 and 1.96 is how many confidence intervals are derived in practice. For instance, say we
## want to calculate the 2.5% and 975.% quantiles for a normal distribution with a different mean
## and standard deviation.
qnorm(c(.025, .975), mean = 3, sd = 4)
## We could also do it by playing with the standard normal distribution
3 + qnorm(c(.025,.975))*4 ## mu +/- 1.96 * sigma
## In other words if we know the standard deviation and mean of a distribution, and we assume it's
## normal we can estimate its 2.5% and 97.5% quantile bounds.

## It turns out that our confidence interval on the mean of x is given by using the sample mean &
## standard deviation
mu ## actual mean
sigma ## actual standard deviation
## confidence interval on mean of x = sample mean + standard error = sample mean + sigma/sqrt(n)
ci_boundsN <- mean(x) + qnorm(c(.025,.975)) * sd(x) / sqrt(sampSize) 
ci_boundsN

## The confidence interval rsepresents what values of the mean for X we would not reject as being
## unlikely (using a P-value of .05). I.e., a (1-alpha) confidence interval is the COLLECTION OF
## NON-REJECTABLE HYPOTHESES with criteria P < alpha.

## Let's visualize this.
xmin <- -5
xmax <- 15
s1 <- ggplot(data = tibble(x=x), aes(x)) + geom_histogram(aes(y=..density..), bins = 100) + xlim(xmin, xmax)
s1

## PDF and the data it generated
s2 <- s1 + stat_function(fun = dnorm, geom='area', alpha = .3, args=list(mean=mu, sd=sigma))
s2

## Show confidence interval on mean & true mean
s3 <-  s2 + geom_vline(xintercept = ci_boundsN, col = 'red', lwd = 2, lty = 2, alpha = .6) +
    geom_vline(xintercept = mu, col = 'blue', lwd = 2, alpha = .6)
s3

## But actually, as you may have already noted, this confidence interval on the mean is wrong!
## Because we're estimating the sample standard deviation,
sd(x)
## which is not the true standard deviation,
sigma
## there's extra variation (i.e. error) in our estimate of the mean. To account for this, we use the
## T-distribution with degrees of freedom (df) corresponding to our sample size. As df gets large,
## the t-distribution approaches the normal.
qt(c(.025, .975), df = sampSize)
qt(c(.025, .975), df = 10^5)

ci_boundsT <- mean(x) + qt(c(.025,.975), df=sampSize) * sd(x) / sqrt(sampSize) 
ci_boundsT
ci_boundsN

## Note that there's not a huge difference here
s4 <- s3 + geom_vline(xintercept = ci_boundsT, col = 'purple', lwd = 2, lty = 2, alpha=.6)
s4

####################################################################################################
## Another common definition of confidence intervals are that they are intervals that capture the
## true value of a statistic 95% of the time. Let's show that via simulation.

##############################
## 1) Write a function that repeates the following  

## i. generate a normal sample, 

## ii. calculate sample mean & the 95% confidence interval on the sample mean

## iii. saves the mean & confidence interval into a row of a tibble

## iv. plot all the confidence intervals along with the true mean

## v. create a logical column indicating whether the confidence interval captures the true mean

## vi. add a plot title saying proportion of confidence intervals that encompass the mean (the CI coverage)

## vii. add a horizontal line for the true mean

## viii. color the points and error bars by whether or not they encompass the true mean (dark green=yes, red=no)

## ix. run your function for 100 runs, then 1000 runs, then 10000 runs

## x. outputs a list containing the tibble and the CI coverage

ciMaker <- function(sampSize, sampMean, sampSD, runs) {
    
    }


##############################
## 2) Change your function to allow for the option of plotting the CIs that do and do not encompass
## the true mean on different facets using facet_wrap.

##############################
## 3) Add to the above function a calculation that calculates the P value for the test of the
## hypothesis of whether the true mean is the mean for each sample. Recall that the t distribution can also be used to calculate t statistics

## t = (sample mean - hypothesized mean) / (std error)
##   = (sample mean - hypothesized mean) / (sample standard deviation / sqrt(sample size))

## and that the quantile of that t-statistic tells you whether you can reject thatnull hypothesis
## (i.e. does it fall in the 2.5% tails of the t-distribution)

## Examine the p values for CIs that don't capture the mean, what pattern do you see?

##############################
## 4) Add to the above function an option to look at other confidence intervals (90%, 99%) using an
## argument "alpha". Compare a few different confidence interval types

##############################
## 5) Add to the above function an option to calculate the CIs based on the normal distribution
## instead of the T distribution. Compare the CI coverage for sample sizes of 5 and 1000.


##############################
## 6) Plot the CI coverage for the normal & T distribution CI calculations as a function of sample
## size by populating the below tibble by calling your function inside of a for() loop
coverageDat <- tibble(sampSizes = c(2,5,10,50,100), coverageT = 0, coverageNorm = 0)
coverageDat


ciMaker <- function(sampSize, sampMean, sampSD, runs, type='t', facet=F, plot=T, alpha = .05, browse=F) {
    output <- tibble(lower = numeric(runs), mean = numeric(runs), upper = numeric(runs))
    for(i in 1:runs) {
        samp <- rnorm(sampSize, sampMean, sampSD)
        qs <- c(alpha/2, .5, 1-alpha/2)
        if(type=='t') quants <- qt(qs, df = sampSize)
        if(type=='normal') quants <- qnorm(qs)
        output[i,c('lower', 'mean', 'upper')] <- mean(samp) + quants*sd(samp)/sqrt(sampSize)
        output[i,'t'] <- (mean(samp) - sampMean) / (sd(samp)/sqrt(sampSize))
    }
    output$meanCaptured <- sampMean >= output$lower & sampMean <= output$upper
    if(browse) browser()
    output$p <- pt(-abs(output$t), df = sampSize)
    ci_coverage <- mean(output$meanCaptured)*100
    output$run <- 1:runs
    if(plot) {
        p1 <- ggplot(output, aes(run, mean, lower, upper, col = meanCaptured), alpha = .5) +
            geom_point(aes(run, mean), shape = 1, size = 4) +
            geom_errorbar(aes(ymin = lower, ymax = upper)) +
            scale_color_manual(values=c('TRUE'='dark green','FALSE'='red')) +
            geom_hline(yintercept = sampMean, col = 'blue', lwd = 2) +
            ggtitle(paste0(ci_coverage, '% of ', alpha, '% CIs encompass true mean'))
        if(facet) print(p1 + facet_wrap(~meanCaptured)) else
                                                            print(p1)
    }
    return(list(output=output, ci_coverage=ci_coverage))
}

ciMaker(20, 3, 2, runs=1000, facet=T, alph = .7)

mu <- 3
sigma <- 2
runs <- 1000
for(i in 1:nrow(coverageDat)) {
    coverageDat[i, 'coverageT'] <- ciMaker(sampSize = coverageDat$sampSizes[i], sampMean=mu,
                                           sampSD = 2, runs = runs, type='t', plot=F)$ci_coverage
    coverageDat[i, 'coverageNorm'] <- ciMaker(sampSize = coverageDat$sampSizes[i], sampMean=mu,
                                              sampSD = 2, runs = runs, type='normal', plot=F)$ci_coverage
}
coverageDat

coverageDat_long <- gather(coverageDat, key =distribution, value = coverage, -sampSizes)

ggplot(coverageDat_long, aes(sampSizes, coverage, col=distribution)) +
    geom_line() +
    geom_hline(yintercept = 95, lty=2)
