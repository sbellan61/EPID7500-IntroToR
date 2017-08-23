##################################################
## installing & loading packages
##################################################
## install.packages('tidyverse') ## you have to do this once to install the package on each computer
require(tidyverse) ## you have to do this each R session to load the package

##################################################
## vectors
##################################################
3+3
1:100 ## [1] and other [numbers] that R prints out are indices of vector elements
x <- rnorm(100) ## create 100 standard normal random numbers
x
length(x[x>0]) ## select the vector of elements of x that are >0, then return the length of that vector

##################################################
## data.frames
##################################################
## creating fake data in base R
ncat <- 4 ## imagine a variable that has 4 categories (groups A, B, C, D)
numPerCat <- 30 ## and you sample 4 individuals per category
nr <- numPerCat*ncat ## this is how many observations you'll have (i.e. Number of Rows)
myData <- data.frame(x = 1:nr, ## first column of myData will be the sequence of 1:nr
                     y = rnorm(nr), ## create random std normal numbers of the same length
                     cat = rep(LETTERS[1:ncat], numPerCat)) ## group them into groups A, B, C, D
myData
myData[myData$y>0,] ## look at myData for rows where y > 0

##################################################
## tidyR
## Playing with the same data in TidyR
myTibble <- as.tibble(myData) ## in TidyR, we use tibbles intead of data.frames
myTibble
filter(myTibble, y>0) ## select rows where y>0

##################################################
## object classes tell us what an object is. This affects how R handles it
class(myData)
class(myTibble)

##################################################
## subsetting
myTibble
rowsToShow <- c(54, 99, 33, 27, 100,100,100)
slice(myTibble, rowsToShow) ## tidyR version
myData[rowsToShow,] ## base R version

## divide the data into categories, then select rows where y is not an NA, then look at correlation
## of y with itself (Stephanie's question)
group_by(myTibble, cat) %>% filter(!is.na(y)) %>% summarize(cor(y,y))

boxplot(myTibble$y ~ myTibble$cat) ## create a boxplot with base R
boxplot(y ~ cat, data = myTibble)  ## a more succinct version of the last line
?boxplot

ggplot(data=myTibble, mapping=aes(cat, y)) + geom_boxplot() ## boxplot with tidyR

##################################################
## data input 
###############
## absolute path
yts <- read_csv('~/Downloads/Youth_Tobacco_Survey__YTS__Data.csv') 
###############
## relative path
setwd('~/Downloads')
yts <- read_csv('Youth_Tobacco_Survey__YTS__Data.csv')

## look at the data
View(yts)

############### 
## Excercise 1:
## Make a boxplot of the % of men of all reaces who are currently smokers by state in 2015
############### 
names(yts) ## look at names of the data set
nrow(yts) ## how many rows are there?

## look at how many rows we have after filtering
filter(yts, MeasureDesc=="Smoking Status") %>% nrow() 
filter(yts, MeasureDesc=="Smoking Status" & Response=="Current") %>% nrow()
filter(yts, MeasureDesc=="Smoking Status" & Response=="Current" & YEAR == 2015) %>% nrow()
filter(yts, MeasureDesc=="Smoking Status" & Response=="Current" & YEAR == 2015 & Gender =="Male") %>% nrow()

## Save the new filtered data subset
yts2 <- filter(yts, MeasureDesc=="Smoking Status" & Response=="Current" & YEAR == 2015 & Gender =="Male")
View(yts2)

boxplot(Data_Value ~ LocationAbbr, data = yts2) ## boxplot base R
ggplot(data=yts2, mapping = aes(LocationAbbr, Data_Value)) + geom_boxplot() ## boxplot base R
############### 

##################################################
## data output
##################################################
## save new filtered data to a CSV file that you can open in spreadsheet software or elsewhere
write.csv(yts2, 'male current smokers by state.csv') 

## looking in the current directory
dir()
dir(full.names = T)
getwd()

##################################################
## Save one R object
save(yts,  file='yts.Rda')
## Save two R objects
save(yts, yts2,  file='yts.Rda')
## Remove all R objects
rm(list=ls()) 
ls() ## list all objects in R environment/workspace
whatsLoaded <- load(file='yts.Rda') ## load saved data in
whatsLoaded ## get names of saved data

##################################################
## the Example function for learning R
example(mean) ## you can use example in R to see example code for how stuff works

##################################################
## Control Flow
##################################################

## if/else
if(-5 > 0) print("I'm bad at math") else print("I'm pretty good at math")

ifelse(-5>0, "I'm bad at math", "I'm pretty good at math")
args(ifelse)
?ifelse

##################################################
## Logical indices and character strings
currFilenms <- dir()
currFilenms ## load filenames into a character string vector

?grepl ## pattern finding in character strings
fileToLoad <- currFilenms[grepl('csv', currFilenms)] ## which of those file names have CSV in it?
fileToLoad

## now load the file (if there's more than one with CSV in it you might get an error)
if(grepl('csv', filenm))  mydat <- read.csv(filenm)

letters ## alphabet
letters[grep('o', letters)] ## return the element of letters that has o in it
letters[grepl('o', letters)] ## return a logical vector saying whether each alphabet letter has o in it
which(grepl('o', letters)) ## which of the true/false vector is true (numeric element)





## for loops


## plotting by category in ggplot
  


##

# create a data frame that has 6 columns, 5 rows, where 2 of the columns are numeric, and 4 of them are categories (of your choice)


