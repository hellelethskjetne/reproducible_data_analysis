###=======
### Homework 2a: Part I (This is a script used to calculate a mathematical formula)
###=======

# Calculating "2 + 2" in R
x = 2 + 2 # Formula used to obtain answer
x #Display value from addition of variables

# Or it can be done like this:
a <- 2 # define variables
y = a + a # Define formula
 
print(a)
y # Display resulting value from addition

###=======
### Homework 2b: Vectors, types, and coercion
###=======

### 1. Use class() to determine the type of the following vectors:

#### c(TRUE, FALSE, FALSE)
a1 <- c(TRUE, FALSE, FALSE)
class(a1) # "logical" class

#### c(1, 2, 3)
b1 <- c(1, 2, 3)
class(b1) #"numeric" class, e.g., consists of numeric vectors

#### c(1.3, 2.4, 3.5)
c1 <- c(1.3, 2.4, 3.5)
class(c1) #"numeric" class, e.g., consists of numeric vectors

#### c("a", "b", "c")
d1 <- c("a", "b", "c")
class(d1) #"character" class, e.g., consists of character vectors

### 2. What type are the following vectors, and why?

#### c(1, 2, "a")
a2 <- c(1, 2, "a")
class(a2) #"character" class, e.g., consists of a list of numeric and character vectors, so are interpreted as a character vectors (numeric info cannot be inferred by characters)

#### c(TRUE, FALSE, 2)
b2 <- c(TRUE, FALSE, 2)
class(b2) #"numeric" class, e.g., consists of a list of numeric vectors (where true and false could e.g., be interpreted as 0 or 1, and 2 as another condition)

###=======
### Homework 2: Directory setup
###=======

## Set up directory and file management
setwd(dir = "/Users/helle/Documents/GEOL590/reproducible_data_analysis")
getwd() #Confirm working directory: "/Users/helle/Documents/GEOL590/reproducible_data_analysis"
library(tidyverse) #loads 'tidyverse' package to complete hw
library(ggplot2) #load 'ggplot2' for later

###=======
### Homework 2: Basic R Operations
###=======

#load data
med_enz <- read_csv("data/med_enz.csv") #load data and assign it to an object
med_enz #view object for control

## Determine what class med_enz belongs to using the class() function:
class(med_enz) #'med_enz' is a "data.frame" that consists of numeric and character:
                        #"spec_tbl_df" "tbl_df"      "tbl"         "data.frame" 
                      
                        #explore the classes within the dataframe:
                        class(med_enz$site) #"numeric"
                        class(med_enz$core) #"numeric"
                        class(med_enz$substrate) #"character"
                        class(med_enz$activity.nM.hr) #"numeric"

##  Determine the structure of med_enz using the str() function:
str(med_enz)
        ### Structure of 'med_enz":
        #tibble [324 × 4] (S3: spec_tbl_df/tbl_df/tbl/data.frame)             #4 rows, 324 columns
        #$ site          : num [1:324] 8 8 8 10 10 10 14 14 14 19 ...         #site: numeric
        #$ core          : num [1:324] 1 1 1 1 1 1 1 1 1 1 ...                #core: numeric
        #$ substrate     : chr [1:324] "LEU" "LEU" "LEU" "LEU" ...            #substrate: character
        #$ activity.nM.hr: num [1:324] 3.94 3.87 3.73 3.58 3.49 ...           #activity.nM.hr: numeric
        #- attr(*, "spec")=
        #  .. cols(
        #    ..   site = col_double(),
        #    ..   core = col_double(),
        #    ..   substrate = col_character(),
        #    ..   activity.nM.hr = col_double()
        #    .. )

    ## Determine the number of rows of med_enz using the nrow() function:
    nrow(med_enz) #consists of 324 rows
    ncol(med_enz) #consists of 4 columns

## Get a “glimpse” of med_enz using the glimpse() function:
glimpse(med_enz) #get a 'glimpse' of "med_enz"
      #Rows: 324
      #Columns: 4
      #$ site           <dbl> 8, 8, 8, 10, 10, 10, 14, 14, 14, 19, 19, 19, 8, 8, 8, 10, 10, 10, 14, 14, 14, 19, 19,…
      #$ core           <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3…
      #$ substrate      <chr> "LEU", "LEU", "LEU", "LEU", "LEU", "LEU", "LEU", "LEU", "LEU", "LEU", "LEU", "LEU", "…
      #$ activity.nM.hr <dbl> 3.94496432, 3.86943983, 3.73380639, 3.58371375, 3.49188715, 3.47876095, 4.40106712, 4…

## Print and save a histogram of the activity.nmM.hr column using the following code, about which we will talk later:

### Code given to create histogram:
p <- ggplot(data = med_enz, aes(x = activity.nM.hr)) + 
  geom_histogram()
print(p)
ggsave(filename = "plots/hmk_2_plot.png", plot = p, height = 3, width = 4, units = "in", dpi = 300)

