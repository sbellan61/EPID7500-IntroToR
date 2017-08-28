---
title: "Data Input/Output"
author: "Steve Bellan (slides borrowed from John Muschelli)"
output:
  slidy_presentation: default
  ioslides_presentation:
    css: ../styles.css
    widescreen: yes
---


## Common new user mistakes we have seen

1.  **Working directory problems: trying to read files that R "can't find"**
    - RStudio can help, and so do RStudio Projects
    - discuss in Data Input/Output lecture
2.  Typos (R is **case sensitive**, `x` and `X` are different)
    - RStudio helps with "tab completion"
    - discussed throughout
3.  Data type problems (is that a string or a number?)
4.  Open ended quotes, parentheses, and brackets     
5.  Different versions of software
    
## Working Directories

* R "looks" for files on your computer relative to the "working" directory
* Many people recommend not setting a directory in the scripts 
    - assume you're in the directory the script is in
    - If you open an R file with a new RStudio session, it does this for you.
* If you do set a working directory, do it at the beginning of your script. 
* Example of getting and setting the working directory:


```r
## get the working directory
getwd()
setwd('~/Documents/R Repos/EPID7500/')
```


## Setting a Working Directory

* Setting the directory can sometimes be finicky
    * **Windows**: Default directory structure involves single backslashes ("\"), but R interprets these as "escape" characters. So you must replace the backslash with forward slashes ("/") or two backslashes ("\\")
    * **Mac/Linux**: Default is forward slashes, so you are okay
* Typical directory structure syntax applies
    * ".." - goes up one level
    * "./" - is the current directory
    * "~" - is your "home" directory

## Working Directory 

Note that the `dir()` function interfaces with your operating system and can show you which files are in your current working directory. 

You can try some directory navigation: 


```r
dir() # shows directory contents
```

```
 [1] "Data_IO.html"                     
 [2] "Data_IO.pdf"                      
 [3] "Data_IO.R"                        
 [4] "index.html"                       
 [5] "index.pdf"                        
 [6] "index.R"                          
 [7] "index.Rmd"                        
 [8] "lab"                              
 [9] "makefile"                         
[10] "Youth_Tobacco_Survey_YTS_Data.csv"
[11] "YouthTobacco_newNames.csv"        
[12] "yts_data.rda"                     
[13] "yts_dataset.rds"                  
```

```r
dir("..") # shows up one directory
```

```
 [1] "1.1-RStudio"                             
 [2] "1.2-Basic_R"                             
 [3] "1.3-Data_IO"                             
 [4] "all_the_functions.csv"                   
 [5] "all_the_packages.txt"                    
 [6] "Arrays_Split"                            
 [7] "Basic_R"                                 
 [8] "Best_Model_Coefficients.csv"             
 [9] "Best_Model_Coefficients.xlsx"            
[10] "bibliography.bib"                        
[11] "black_and_white_theme.pdf"               
[12] "bloomberg.logo.small.horizontal.blue.png"
[13] "data"                                    
[14] "Data_Classes"                            
[15] "Data_Cleaning"                           
[16] "Data_IO"                                 
[17] "Data_Summarization"                      
[18] "Data_Visualization"                      
[19] "data.zip"                                
[20] "Day 1"                                   
[21] "dhs"                                     
[22] "Functions"                               
[23] "HW"                                      
[24] "ifelse_stata_way.R"                      
[25] "index.html"                              
[26] "index.Rmd"                               
[27] "install_all_packages.R"                  
[28] "Intro"                                   
[29] "intro_to_r.Rproj"                        
[30] "Knitr"                                   
[31] "LICENSE"                                 
[32] "list_all_packages.R"                     
[33] "live_code"                               
[34] "makefile"                                
[35] "makefile_old"                            
[36] "makefile.copy"                           
[37] "Manipulating_Data_in_R"                  
[38] "my_tab.txt"                              
[39] "ProjectExample"                          
[40] "README.md"                               
[41] "render.R"                                
[42] "renderFile.R"                            
[43] "replace_css.R"                           
[44] "RStudio"                                 
[45] "run_labs.R"                              
[46] "scratch.R"                               
[47] "shiny_knitr"                             
[48] "shiny_knitr.zip"                         
[49] "Simple_Knitr"                            
[50] "Statistics"                              
[51] "styles.css"                              
[52] "Subsetting_Data_in_R"                    
[53] "Syllabus-student.doc"                    
```

```r
dir("../..") # shows up two directories
```

```
 [1] "CarcCapRecap"            "cRCT_vs_iRCT"           
 [3] "datasets"                "EbolaVaccSim"           
 [5] "EPID7500"                "HIVClinicTanzMoH"       
 [7] "ICI3D"                   "lmtacc"                 
 [9] "MathModelsMedPH"         "measlesImmunomodulation"
[11] "MMED2017"                "MMEDparticipants"       
[13] "RakaiLatentHet"          "RTutorials"             
[15] "SDPSimulations"          "sshfsTip.txt"           
[17] "TB_MAC_UGA"              "untitled folder"        
[19] "ZikaTrial"              
```

## Relative vs. absolute paths (From Wiki)

An **absolute or full path** points to the same location in a file system, regardless of the current working directory.

```r
dir('~/Documents', full.names = TRUE)[1:3]
```

```
[1] "/Users/stevenbellan/Documents/Adobe"                    
[2] "/Users/stevenbellan/Documents/Dragon"                   
[3] "/Users/stevenbellan/Documents/DreamPlan Sample Projects"
```

This means if I try your code, and you use absolute paths, it won't work unless we have the exact same folder structure where R is looking (bad).

A **relative path starts from current  working directory**. Need to have the working directory right but good for project portability.

```r
dir('~/Documents', full.names = FALSE)[1:3]
```

```
[1] "Adobe"                     "Dragon"                   
[3] "DreamPlan Sample Projects"
```

## Setting the Working Directory

In RStudio, go to `Session --> Set Working Directory --> To Source File Location`

RStudio should put code in the Console, similar to this:

```r
setwd("~/Lectures/Data_IO/lecture")
```
    
## Setting the Working Directory
    
Again, if you open an R file with a new RStudio session, it does this for you.  You may need to make this a default.

1. Make sure RStudio is the default application to open .R files
    * Mac - right click --> Get Info --> Open With: RStudio --> Change All
    * [Windows 7](https://support.microsoft.com/en-us/help/18539/windows-7-change-default-programs) and [Windows 10](https://www.cnet.com/how-to/how-to-set-default-programs-in-windows-10/)


## Reminder: Use R Help!

For any function, you can write `?FUNCTION_NAME`, or `help("FUNCTION_NAME")` to look at the help file:


```r
?dir
help("dir")
```

## Data Input

* Everything we do in class will be using real publicly available data - there are few 'toy' example datasets and 'simulated' data

* 'Reading in' data is the first step of any real project/analysis
* R can read almost any file format
* Focus on
    * tab delimited (e.g. '.txt')
    * comma separated (e.g. '.csv')
    * Microsoft Excel (e.g. '.xlsx')

## Data Input

[Youth Tobacco Survey (YTS) Dataset](https://catalog.data.gov/dataset/youth-tobacco-survey-yts-data)

* Middle/high school students  tobacco use, exposure to environmental tobacco smoke, smoking cessation, school curriculum,  knowledge and attitudes about tobacco, etc...

* Download the CSV file from the above site by clicking Download 
    * If a file loads in your browser, choose File --> Save As
* Within RStudio: Session --> Set Working Directory --> To Source File Location

## Data Input

R Studio features

* "File --> Import Dataset --> From CSV" command.
* Specify the formatting of your text file. 
* Shows you the corresponding R commands that did the import

## Read in from the internet directly or from a downloaded copy

* Web


```r
mydat = read_csv("https://github.com/sbellan61/EPID7500-IntroToR/raw/gh-pages/1.3-Data_IO/Youth_Tobacco_Survey_YTS_Data.csv")
head(mydat)
```

```
# A tibble: 6 x 31
   YEAR LocationAbbr LocationDesc                 TopicType
  <int>        <chr>        <chr>                     <chr>
1  2015           AZ      Arizona Tobacco Use – Survey Data
2  2015           AZ      Arizona Tobacco Use – Survey Data
3  2015           AZ      Arizona Tobacco Use – Survey Data
4  2015           AZ      Arizona Tobacco Use – Survey Data
5  2015           AZ      Arizona Tobacco Use – Survey Data
6  2015           AZ      Arizona Tobacco Use – Survey Data
# ... with 27 more variables: TopicDesc <chr>, MeasureDesc <chr>,
#   DataSource <chr>, Response <chr>, Data_Value_Unit <chr>,
#   Data_Value_Type <chr>, Data_Value <dbl>,
#   Data_Value_Footnote_Symbol <chr>, Data_Value_Footnote <chr>,
#   Data_Value_Std_Err <dbl>, Low_Confidence_Limit <dbl>,
#   High_Confidence_Limit <dbl>, Sample_Size <int>, Gender <chr>,
#   Race <chr>, Age <chr>, Education <chr>, GeoLocation <chr>,
#   TopicTypeId <chr>, TopicId <chr>, MeasureId <chr>,
#   StratificationID1 <chr>, StratificationID2 <chr>,
#   StratificationID3 <chr>, StratificationID4 <chr>, SubMeasureID <chr>,
#   DisplayOrder <int>
```

* File


```r
dat = read_csv("../data/Youth_Tobacco_Survey_YTS_Data.csv")
```

```
Parsed with column specification:
cols(
  .default = col_character(),
  YEAR = col_integer(),
  Data_Value = col_double(),
  Data_Value_Std_Err = col_double(),
  Low_Confidence_Limit = col_double(),
  High_Confidence_Limit = col_double(),
  Sample_Size = col_integer(),
  DisplayOrder = col_integer()
)
```

```
See spec(...) for full column specifications.
```

The data is now successfully read into your R workspace, just like from using the dropdown menu.

## Base R vs tidyverse

* Base R (loads as a data.frame): read.csv, read.table, read.delim
* TidyVerse (loads as a tibble): read_csv, read_table, read_delim

* [tibbles](http://r4ds.had.co.nz/tibbles.html) print cleaner and have slightly different subsetting syntax

## Data Input


```r
dat
```

```
# A tibble: 9,794 x 31
    YEAR LocationAbbr LocationDesc                 TopicType
   <int>        <chr>        <chr>                     <chr>
 1  2015           AZ      Arizona Tobacco Use – Survey Data
 2  2015           AZ      Arizona Tobacco Use – Survey Data
 3  2015           AZ      Arizona Tobacco Use – Survey Data
 4  2015           AZ      Arizona Tobacco Use – Survey Data
 5  2015           AZ      Arizona Tobacco Use – Survey Data
 6  2015           AZ      Arizona Tobacco Use – Survey Data
 7  2015           AZ      Arizona Tobacco Use – Survey Data
 8  2015           AZ      Arizona Tobacco Use – Survey Data
 9  2015           AZ      Arizona Tobacco Use – Survey Data
10  2015           AZ      Arizona Tobacco Use – Survey Data
# ... with 9,784 more rows, and 27 more variables: TopicDesc <chr>,
#   MeasureDesc <chr>, DataSource <chr>, Response <chr>,
#   Data_Value_Unit <chr>, Data_Value_Type <chr>, Data_Value <dbl>,
#   Data_Value_Footnote_Symbol <chr>, Data_Value_Footnote <chr>,
#   Data_Value_Std_Err <dbl>, Low_Confidence_Limit <dbl>,
#   High_Confidence_Limit <dbl>, Sample_Size <int>, Gender <chr>,
#   Race <chr>, Age <chr>, Education <chr>, GeoLocation <chr>,
#   TopicTypeId <chr>, TopicId <chr>, MeasureId <chr>,
#   StratificationID1 <chr>, StratificationID2 <chr>,
#   StratificationID3 <chr>, StratificationID4 <chr>, SubMeasureID <chr>,
#   DisplayOrder <int>
```

While many online resources use the base R tools, the latest version of RStudio switched to use these new `readr` data import tools, so we will use them in the class for slides. They are also up to two times faster for reading in large datasets, and have a progress bar which is nice. 


## Data Input

Here is how to read in the same dataset using base R functionality, which returns a `data.frame` directly


```r
dat2 = read.csv("../data/Youth_Tobacco_Survey_YTS_Data.csv", as.is = TRUE)
head(dat2)
```

```
  YEAR LocationAbbr LocationDesc                 TopicType
1 2015           AZ      Arizona Tobacco Use – Survey Data
2 2015           AZ      Arizona Tobacco Use – Survey Data
3 2015           AZ      Arizona Tobacco Use – Survey Data
4 2015           AZ      Arizona Tobacco Use – Survey Data
5 2015           AZ      Arizona Tobacco Use – Survey Data
6 2015           AZ      Arizona Tobacco Use – Survey Data
          TopicDesc
1 Cessation (Youth)
2 Cessation (Youth)
3 Cessation (Youth)
4 Cessation (Youth)
5 Cessation (Youth)
6 Cessation (Youth)
                                                MeasureDesc DataSource
1               Percent of Current Smokers Who Want to Quit        YTS
2               Percent of Current Smokers Who Want to Quit        YTS
3               Percent of Current Smokers Who Want to Quit        YTS
4 Quit Attempt in Past Year Among Current Cigarette Smokers        YTS
5 Quit Attempt in Past Year Among Current Cigarette Smokers        YTS
6 Quit Attempt in Past Year Among Current Cigarette Smokers        YTS
  Response Data_Value_Unit Data_Value_Type Data_Value
1                        %      Percentage         NA
2                        %      Percentage         NA
3                        %      Percentage         NA
4                        %      Percentage         NA
5                        %      Percentage         NA
6                        %      Percentage         NA
  Data_Value_Footnote_Symbol
1                          *
2                          *
3                          *
4                          *
5                          *
6                          *
                                                      Data_Value_Footnote
1 Data in these cells have been suppressed because of a small sample size
2 Data in these cells have been suppressed because of a small sample size
3 Data in these cells have been suppressed because of a small sample size
4 Data in these cells have been suppressed because of a small sample size
5 Data in these cells have been suppressed because of a small sample size
6 Data in these cells have been suppressed because of a small sample size
  Data_Value_Std_Err Low_Confidence_Limit High_Confidence_Limit
1                 NA                   NA                    NA
2                 NA                   NA                    NA
3                 NA                   NA                    NA
4                 NA                   NA                    NA
5                 NA                   NA                    NA
6                 NA                   NA                    NA
  Sample_Size  Gender      Race      Age     Education
1          NA Overall All Races All Ages Middle School
2          NA    Male All Races All Ages Middle School
3          NA  Female All Races All Ages Middle School
4          NA Overall All Races All Ages Middle School
5          NA    Male All Races All Ages Middle School
6          NA  Female All Races All Ages Middle School
                                GeoLocation TopicTypeId TopicId MeasureId
1 (34.865970280000454, -111.76381127699972)         BEH  105BEH    170CES
2 (34.865970280000454, -111.76381127699972)         BEH  105BEH    170CES
3 (34.865970280000454, -111.76381127699972)         BEH  105BEH    170CES
4 (34.865970280000454, -111.76381127699972)         BEH  105BEH    169QUA
5 (34.865970280000454, -111.76381127699972)         BEH  105BEH    169QUA
6 (34.865970280000454, -111.76381127699972)         BEH  105BEH    169QUA
  StratificationID1 StratificationID2 StratificationID3 StratificationID4
1              1GEN              8AGE              6RAC              1EDU
2              2GEN              8AGE              6RAC              1EDU
3              3GEN              8AGE              6RAC              1EDU
4              1GEN              8AGE              6RAC              1EDU
5              2GEN              8AGE              6RAC              1EDU
6              3GEN              8AGE              6RAC              1EDU
  SubMeasureID DisplayOrder
1        YTS01            1
2        YTS02            2
3        YTS03            3
4        YTS04            4
5        YTS05            5
6        YTS06            6
```

We will use the TidyVerse `readr` functions because TidyVerse is the wave of the future.

## Data Input

* `nrow()` displays the number of rows of a data frame
* `ncol()` displays the number of columns 
* `dim()` displays a vector of length 2: # rows, # columns
* `colnames()` displays the column names (if any) and `rownames()` displays the row names (if any)


```r
dim(dat2)
```

```
[1] 9794   31
```

```r
nrow(dat2)
```

```
[1] 9794
```

```r
ncol(dat2)
```

```
[1] 31
```

```r
colnames(dat2)
```

```
 [1] "YEAR"                       "LocationAbbr"              
 [3] "LocationDesc"               "TopicType"                 
 [5] "TopicDesc"                  "MeasureDesc"               
 [7] "DataSource"                 "Response"                  
 [9] "Data_Value_Unit"            "Data_Value_Type"           
[11] "Data_Value"                 "Data_Value_Footnote_Symbol"
[13] "Data_Value_Footnote"        "Data_Value_Std_Err"        
[15] "Low_Confidence_Limit"       "High_Confidence_Limit"     
[17] "Sample_Size"                "Gender"                    
[19] "Race"                       "Age"                       
[21] "Education"                  "GeoLocation"               
[23] "TopicTypeId"                "TopicId"                   
[25] "MeasureId"                  "StratificationID1"         
[27] "StratificationID2"          "StratificationID3"         
[29] "StratificationID4"          "SubMeasureID"              
[31] "DisplayOrder"              
```


## Data Input

Changing variable names in `data.frame`s works using the `names()` function, which is analagous to `colnames()` for data frames (they can be used interchangeably)


```r
names(dat)[1] = "year"
names(dat)
```

```
 [1] "year"                       "LocationAbbr"              
 [3] "LocationDesc"               "TopicType"                 
 [5] "TopicDesc"                  "MeasureDesc"               
 [7] "DataSource"                 "Response"                  
 [9] "Data_Value_Unit"            "Data_Value_Type"           
[11] "Data_Value"                 "Data_Value_Footnote_Symbol"
[13] "Data_Value_Footnote"        "Data_Value_Std_Err"        
[15] "Low_Confidence_Limit"       "High_Confidence_Limit"     
[17] "Sample_Size"                "Gender"                    
[19] "Race"                       "Age"                       
[21] "Education"                  "GeoLocation"               
[23] "TopicTypeId"                "TopicId"                   
[25] "MeasureId"                  "StratificationID1"         
[27] "StratificationID2"          "StratificationID3"         
[29] "StratificationID4"          "SubMeasureID"              
[31] "DisplayOrder"              
```


## Data Output

* Writing data from R to a file

```
write_csv(dat, path, na = "NA", append = FALSE) 
?write_csv
```

## Data Output

`x`: the R object (`tibble`) to write

`path`: the file name (with absolute or, ideally, *relative* path)

## Data Output

* Change name of 1st column & write a new file


```r
names(dat)[1] = "Year"
write_csv(dat, path="YouthTobacco_newNames.csv")
```

## Data Input - Excel

Excel to R options

* Saving the Excel sheet as a .csv file, and using `read_csv()`
* Using an add-on package, like `xlsx`, `openxlsx`, `readxl` (can handle multiple worksheets)

## Data Input -  R packages

* **baser** read.csv, write.csv, etc...
* **readr**  -  *read_csv*/*write_csv*  similar to *read.csv*/*write.csv* but  **much faster** for very large data sets & makes tibbles
* [**haven**](https://cran.r-project.org/web/packages/haven/index.html) package reads in SAS, SPSS, Stata formats
* **readxl**  -  `read_excel` 
* **sas7bdat** reads .sas7bdat files

## More ways to save: save

* `save` R object(s) into an "R data file":  `.rda` or `.RData`


```r
x <- 5
yts <- read_csv('../data/Youth_Tobacco_Survey_YTS_Data.csv')
save(yts, x, file = "yts_data.rda")
```

## Loading R data files

`ls()`  lists the items in the workspace/environment and `rm` removes them:


```r
ls() # list things in the workspace
```

```
 [1] "bad"       "bogus"     "cn"        "dat"       "dat2"     
 [6] "days"      "df"        "fe"        "fit5"      "fit6"     
[11] "grouped"   "hw1"       "icol"      "keep"      "mat"      
[16] "mods"      "mydat"     "show_keys" "simbias"   "swiss"    
[21] "x"         "x1hist"    "y"         "yts"       "z"        
```

```r
rm(list = c("x", "yts"))
ls()
```

```
 [1] "bad"       "bogus"     "cn"        "dat"       "dat2"     
 [6] "days"      "df"        "fe"        "fit5"      "fit6"     
[11] "grouped"   "hw1"       "icol"      "keep"      "mat"      
[16] "mods"      "mydat"     "show_keys" "simbias"   "swiss"    
[21] "x1hist"    "y"         "z"        
```

```r
z <- load("yts_data.rda")
ls()
```

```
 [1] "bad"       "bogus"     "cn"        "dat"       "dat2"     
 [6] "days"      "df"        "fe"        "fit5"      "fit6"     
[11] "grouped"   "hw1"       "icol"      "keep"      "mat"      
[16] "mods"      "mydat"     "show_keys" "simbias"   "swiss"    
[21] "x"         "x1hist"    "y"         "yts"       "z"        
```

## More ways to save: load


```r
print(z)
```

```
[1] "yts" "x"  
```

Note, `z` is a **character vector** of the **names** of the objects loaded, **not** the objects themselves.
