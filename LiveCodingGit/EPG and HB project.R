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

createMyStudy <- function(sampSize=50, epg_mu=40, epg_sigma=10, 
                          hb_slope=-1/20, hb_int=14, hb_sd=1.2,
                          hb_male = 2, doPlot=T, browse=F) {
  if(browse) browser()
  dat <- tibble(epg = rlnorm(sampSize, mean = log(epg_mu), sd = log(epg_mu) - log(epg_mu-epg_sigma)),
                sex = sample(c('m','f'), size = sampSize, replace = T))
  dat <- dat %>% mutate(hb_expected = hb_int + hb_slope*epg + hb_male*as.numeric(sex=='m'))
  dat <- dat %>% mutate(hb_noise = rnorm(n(), 0, sd=hb_sd),
                        hb = hb_expected + hb_noise)
    if(doPlot)  {
      p1 <- ggplot(dat, aes(epg, hb, col=sex)) + 
        geom_point() + 
        xlim(min(0, min(dat$epg)), max(dat$epg, 100)) + 
        ylim(0,max(20, max(dat$epg)))
      print(p1)
    }
    return(dat)
}

createMyStudy(browse = F, epg_sigma = 20)
createMyStudy(browse=F, epg_sigma = 4)

createMyMod <- function(dat) {
    mod <- lm(hb ~ epg, data = dat)
    modfit <- tibble(int = coef(mod)['(Intercept)'],
                     intlower = confint(mod)['(Intercept)', '2.5 %'],
                     intupper = confint(mod)['(Intercept)', '97.5 %'],
                     epg = coef(mod)['epg'],
                     epglower = confint(mod)['epg', '2.5 %'],
                     epgupper = confint(mod)['epg', '97.5 %'])
    return(modfit)
}

tempdat <- createMyStudy(browse=F, epg_sigma = 4)
createMyMod(tempdat)

####################################################################################################
## Nov 9

## Create a function, simulateLM() that simulates a data set, then fits a linear model to it, and
## does this multiple times within a for loop. Use do.call() to be able to flexibly feed a list of
## arguments to simulateLM() that get fed to createMyStudy, and a separate list of arguments to
## createMyMod. Have the option to plot the main effects and confidence intervals from all the
## runs. The function return a list containing 1) a tibble of the linear model estimates for each
## run, and 2) the estimate of statistical power across runs.
simulateLM <- function() {

    }

