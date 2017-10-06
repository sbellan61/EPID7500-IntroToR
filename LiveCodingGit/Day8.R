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
## Confidence Intervals
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
sampSize <- 30
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

