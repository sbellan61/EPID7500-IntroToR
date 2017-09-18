## EPID 7500 - Binomial Distribution Tutorial
## Fall 2017
## UGA
## Steve Bellan
################################################################################
## Adapted from the below
################################################################################
## Fun with one of my favorite distributions
## Clinic on Dynamical Approaches to Infectious Disease Data
## International Clinics on Infectious Disease Dynamics and Data Program
## University of Florida, Gainesveille, FL, USA
##
## Jim Scott, 2012
## Some Rights Reserved
## CC BY-NC 3.0 (http://creativecommons.org/licenses/by-nc/3.0/)
################################################################################

################################################################################
##
## By the end of this tutorial you should:
##
## * understand the terms: sample space, discrete, random variable, probability
##   distribution
## * know the characterisitics of a binomial process
## * know the binomial formula and how to use it
## * be able to utilize the functions dbinom, pbinom, and rbinom
## * be able to plot a binomial distribution in R
## * visualize how the parameters of the binomial distribution affect it.

# The binomial probability model is a discrete probability model that is
# commonly used in many applications.
# But, what IS it, exactly?

# The "discrete" part means that it produces random variables that have a finite
# number of possible values.  The "probability model" part means
# that it provides us with two important pieces of infomation: the possible
# outcomes that may occur and the probabilities with which each outcome occurs.

# There are a number of common discrete probability models that exist, but the
# binomial model is used to model the number of successes that occur in fixed
# number of independent trials.  It's a good model for a process that: 1) has a
# fixed number of independent trials 2) has outcomes that can be categorized
# into either "success" or "failure" 3) has constant probability for "success"
# (i.e. the probability of a "success" doesn't change.

# Coin flipping is a common example of a binomial process.  Suppose I flip a
# coin 10 times. One flip represents one trial.  The number of trials is fixed
# (n=10).  There are only two outcomes.  The probability of a success (e.g.
# getting "tails") remains constant. The number of tails in 10 trials is a
# binomially distributed random variable.

# What's a random variable?  Well, before we talk about that, lets define one
# other term - sample space.  The sample space of a random phenomenon is the set
# of all possible outcomes that could occur.  Note that an outcome need not be
# numeric.  For example, consider tossing a coin one time.  The sample space is
# {heads, tails}.  If you were to
# toss the coin 2 times the sample space would consist of:
# S = {heads heads, heads tails, tails heads, tails tails}
# and we would say the size of the sample space is 4.

# A random variable maps each outcome in the sample space to a numeric value.
# For example, if I defined the random variable X as the number of tails that
# occurs in two flips of a coin, I would observe the following:
#
# outcome          X
# heads heads      0
# heads tails      1
# tails heads      1
# tails tails      2
#
# I could describe the distribution of X in the following manner:
#
# outcome      probability
# X = 0          0.25
# X = 1          0.50
# X = 2          0.25

# Also, notice that the random variable X is binomial because we have:  1) fixed
# number of independent trials (n=2), 2) either a "success" (tails) or failure
# occurs (not tails), and 3) the probability of a "success" (getting tails)
# remains constant. Here the probability of a success in any one trial is p=0.5

# If we suspect that a random variable is binomial, we can use the binomial
# formula to calculate the probability that X equals some specific value.  For
# example, if we didn't know that the probabiliy of getting 0 tails on 2 flips
# is 0.25, we could have used the following formula to obtain it:
#
# Binomial formula:
# P(X = x) = N!/[(x!)(N-x)!] * p^x * (1-p)^(N-x)
#
# You might be familiar with seeing N!/[(x!)(N-x)!] written as "N choose x"
#
# In the above equation:
# x = number of successes
# N = number of trials
# p = the probability of a success

# In our example, N = 2 and p = 0.5.  To calculate the probability that X = 0
# use:
# P(X = 0) = 2!/[(0!)(2-0)!] * 0.5^0 * (1-0.5)^(2-0)
#          = 1               * 1     * 0.25         = 0.25    (recall that 0! = 1)

# This has all been a preamble toward getting you prepared to use the binomial
# distribution in R.  To obtain the calculation above in R, you need only
# execute the following command:

dbinom(0,2,0.5)

# The syntax is pbinom(x, N, p)

# That one isn't too hard to calculate in your head, but suppose you wanted to
# know the probability of getting exactly 20 tails if you flipped a coin 50
# times.  Instead of calculating it with the formula (or a calculator), just use
# R.  Here, N=50, p is still 0.5. Run:

dbinom(20, 50, 0.5)

# If you'd like to determine the entire distribution when N=50 and p=0.5 you
# could type:

dbinom(0:50, 50, 0.5)

# Nice, but not that visually stimulating.  Let's plot it!
numtails <- 0:50
probdens <- dbinom(numtails, size=50, prob=1/2)
binomdat <- tibble(numtails, probdens)

ggplot(binomdat, aes(numtails, probdens)) + geom_bar(stat='identity', fill='blue') +
    ylab('Probability') + xlab('Number of Tails') +
    ggtitle('Binomial Distribution, N=50, p=1/2')

# The binomial distribution has 2 parameters, N, the number of fixed trials, and
# p, the probability of a success.  The distribution is completely determined by
# these values, just like a normal distribution is completely determined by its
# paramters, the mean and the standard deviation.  To see how the distriution
# changes as p changes, try highlighting and running the following code (here
# we're holding N constant at 50):

binomBarPlot <- function(N=50, p=.5) {
    numtails <- 0:N
    binomdat <- mutate(binomdat, probdens = dbinom(numtails, size = N, prob = p))
    bp <- ggplot(binomdat, aes(numtails, probdens)) + geom_bar(stat='identity', fill='blue') +
        ylab('Probability') + xlab('Number of Tails') +
        ggtitle(paste0('Binomial Distribution, N=', N, ', p=', p))
    print(bp)
}
binomBarPlot(p=.2)
binomBarPlot(p=.5)
binomBarPlot(p=.8)
binomBarPlot(p=.9)

# If you didn't see all the plots, try clicking the back arrow a few times in
# the plot window to see all the plots that R produced.

# To get an idea of how the binomial distribution can change when N varies try
# running the following code. Here p is set to 1/2, after you've run the code
# once, try changing p to a different value.

binomBarPlot(N=3)
binomBarPlot(N=5)
binomBarPlot(N=20)
binomBarPlot(N=100)


# Again, if you didn't see all the plots, try clicking the back arrow a few
# times in the plot window to see all the plots that R produced.

# The binomial formula provides you with just the height of one bar,
# which equates to the probability of that many tails occurring out of
# your entire sample space.  To determine the probability that we flip
# a certain number of tails OR less, we can sum up all the bar
# heights: for example, the probability that we get 20 or fewer tails
# in 50 flips, you could type:

dbinom(0:20, 50, 0.5)
sum(dbinom(0:20, 50, 0.5))

# or, equivalently

?pbinom
pbinom(q=20, size=50, prob=0.5)


# The difference between these two commands is that dbinom gives the height of
# each bar you specify whereas pbinom sums up the bars that are less than or
# equal to the value of the first number in the parentheses

# To create a visual of this you could execute the following:

numtails <- 0:50
probdens <- dbinom(numtails, size=50, prob=1/2)
binomdat <- tibble(numtails, probdens)

ggplot(binomdat, aes(numtails, probdens)) + geom_bar(stat='identity', fill=ifelse(numtails<=20, 'blue', 'light blue')) +
    ylab('Probability') + xlab('Number of Tails') +
    ggtitle('Binomial Distribution, N=50, p=1/2')

## In case you want to do this in base R plotting, see the below code
barplot(dbinom(numtails, size=50, prob=1/2),names.arg=0:50,ylab="Probability",
        main="Binomial Distribution, N=50, p=1/2",xlab="Number of Tails",
        col=ifelse(numtails<=20,"blue","light blue"))


# The area of the dark blue bars is:
pbinom(20,50,0.5)

# You can also use R to simulate binomially distributed random variables.  For
# example, suppose N = 50 and p=1/2.  You'd expect to get 25 successes, but due
# to random chance you won't always get 25.  Sometimes you'll get a few more,
# sometimes a few less.  To simulate the outcome of 50 coin tosses, just type:

?rbinom
rbinom(n=1, size=50, prob=1/2)

# If you'd like to similate the results of 1000 people flipping a coin 50 times
# type:

numTailsSim <- rbinom(1000,50,1/2)
mySim <- tibble(numTailsSim)
mySim

# the output isn't so useful in that form...try plotting it instead:
p1 <- ggplot(mySim, aes(x=numTailsSim)) + xlab('Number of Tails')

p1 + geom_histogram(binwidth = 1) ## frequency counts (number of observations)
p1 + geom_histogram(binwidth = 1, aes(y=..density..)) ## density (proportion of observations

## in base R
## hist(mysims, freq=FALSE, breaks=0:50-.5, ylim=c(0,0.2),col="grey",
##      ylab="Number of occurences",xlab="Number of tails in 50 flips")

# Your distribution should look similar to the theoretical binomial
                                        # distribution:

numtails <- 0:50
probdens <- dbinom(numtails, size=50, prob=1/2)
binomdat <- tibble(numtails, probdens)

## Plot the two together
p1 + geom_histogram(binwidth = 1, aes(y=..density..)) + ## density (proportion of observations
    geom_line(data=binomdat, aes(numtails, probdens), col='red', lwd=3, alpha = .6)


## What if you have 10 people flipping different coins, 3 of which
## have a 90% chance of tails, and 7 of which have only a 30% chance
## of tails and they each flip it 100 times?

## rbinom() is *vectorized*. This means that it can handle multiple values
## for each of it's arguments and returns the corresponding answer,
## recycling arguments that don't repeat as many times

coinProbs <- rep(c(.9,.3), c(3,7))
coinProbs
rbinom(n=10, size=100, prob = coinProbs)

## what if we had 10 people who only flipped a coin once?
rbinom(n=10, size=1, prob = coinProbs)

## We could similarly imagine that instead of tails, a 1 indicates having some disease (e.g. cancer)
## imagine in a study of 100 people, that 80 people have low risk and 20 have high risk for cancer
groupSizes <- c(lowRisk=80, highRisk=20)
cancerRisk <- c(lowRisk=.05, highRisk=.15)
cancerRiskByIndividual <- rep(cancerRisk, groupSizes)
sampleSize <- length(cancerRiskByIndividual)
rbinom(n=sampleSize, size = 1, prob = cancerRiskByIndividual)

## Note that this is often what we have with binary outcome
## data. There is some underlying idea of risk differences accross
## individuals, but we only see a binary outcome, making it difficult
## to disentangle what's going on.
