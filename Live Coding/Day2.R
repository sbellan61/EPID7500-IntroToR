require(tidyverse)
## vectors
3+3
1:100
x <- rnorm(100)
x
length(x[x>0])

## data.frames

## base R
ncat <- 4
numPerCat <- 30
nr <- numPerCat*ncat
myData <- data.frame(x = 1:nr, y = rnorm(nr), cat = rep(LETTERS[1:ncat], numPerCat))
myData[myData$y>0,]
myData

## tidyR
myTibble <- as.tibble(myData)
myTibble
filter(myTibble, y>0)

## object classes
class(myData)
class(myTibble)

## subsetting
myTibble
slice(myTibble, c(54, 99, 33, 27, 100,100,100))
group_by(myTibble, cat) %>% filter(!is.na(y)) %>% summarize(cor(y,y))

boxplot(myTibble$y ~ myTibble$cat)
?boxplot

## summarizing

## data input 
yts <- read_csv('~/Downloads/Youth_Tobacco_Survey__YTS__Data.csv')
View(yts)

## Make a boxplot of the % of men of all reaces who are currently smokers by state in 2015
names(yts)
nrow(yts)
yts2 <- filter(yts, MeasureDesc=="Smoking Status" & Response=="Current" & YEAR == 2015 & Gender =="Male")

boxplot(yts2$Data_Value ~ yts2$LocationAbbr)
View(yts2)

nrow(yts2)
str(yts)

## installing & loading packages

install.packages('tidyverse')
require(tidyverse)

## example

## data output

write.csv(yts2, 'male current smokers by state.csv')

save(yts, yts2,  file='yts.Rda')
rm(list=ls())
ls()
whatsLoaded <- load(file='yts.Rda') ##
whatsLoaded

class(yts2$Data_Value) <- 'Character'
class(yts2$Data_Value)

example(filter)

dir()
getwd()

## if/else
if(-5 > 0) print("I'm bad at math") else print("I'm pretty good at math")

ifelse(-5>0, "I'm bad at math", "I'm pretty good at math")
args(ifelse)
?ifelse

filenm <- 'blah.xls'
currFilenms <- dir()
currFilenms

fileToLoad <- currFilenms[grepl('csv', currFilenms)] ## faster version
dir()[grepl('csv', dir())] ## slower version

read.csv(fileToLoad)

if(grepl('csv', filenm))  mydat <- read.csv(filenm)

letters[grep('o', letters)]
letters[grepl('o', letters)]
which(grepl('o', letters))





## for loops


## plotting by category in ggplot
  


##

# create a data frame that has 6 columns, 5 rows, where 2 of the columns are numeric, and 4 of them are categories (of your choice)


