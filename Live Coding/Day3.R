## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----message=F-----------------------------------------------------------
require(tidyverse)

## ------------------------------------------------------------------------
setwd("~/Documents/R Repos/EPID7500/Live Coding")
dir()
notif <- read_csv('TB_notifications_2017-08-27.csv')
## head(notif)
notif[1:5,1:5]

