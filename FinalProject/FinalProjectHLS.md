Final Project
================
Helle Leth Skjetne
12/4/2020

### Group Members(s): Helle Leth Skjetne

Title: Secondary Crater Size-Range Analysis
-------------------------------------------

Through this project I will explore the size-range relationship of secondary craters. Secondary craters form during a primary impact when an asteroid strikes the surface of a planetary surface, such as Mercury (but are found across surfaces of most solid bodies in our solar system). During the primary impact fragments of the asteroid and the impacted surface are ejected on a radial ballistic trajectory away from the impact site at hypervelocity, and when these fragments strike the surface of a planetary body, they produce what is known as "secondary craters". Secondary craters are clearly differentiable from smaller primary impact craters by their morphology; e.g., v-shaped semi-circles with a dusty "tail", forms in radial crater chains and clusters, and does not form "perfect" circles similarly to smaller primary impacts.

The goal of this project is to produce a reproducible code in RStudio that can analyze raw data (.csv or Microsoft Excel) obtained in ESRI's ArcMap environment to analyze size-range properties and trends in secondary craters on Mercury and other bodies. The benefit of this code is that it can easily be used to calculate the secondary size-range properties of impact fields on a single planetary body, and for other planetary bodies as well. These datasets will be required to consist of information about central latitude and longitude location, diameter, confidence rating on size and whether it is a secondary crater (this code will not evaluate confidence ranting at this point). The code will use this information to calculate trends in secondary crater size with distance (range) away from the primary crater and determine whether there is a trend in the upper percentile sizes across this range in order to study secondary cratering. The deliverable from this project will be designed to analyze data that is currently being collected for several secondary crate ranges across the surfaces and will consist of a code that organizes these data, analyzes trends in these data, and generates meaningful plots to visualize these data. The data to be utilized in this project is part of my doctoral dissertation work in the Department of Earth and Planetary Sciences (UTK).

``` r
# THE PURPOSE OF THIS CHUNK IS TO SET UP THE ENVIRONMENT WITH THE REQUIRED DATA FOR THE ANALYSIS:

# Load packages:
library(ggplot2)
library(tidyverse)
library(dplyr)
library(readr)
library(readxl)
library(ggpubr)
library(ggpmisc)
library(quantreg)
library(drc)
library(nlme)

# Set working directory
setwd("~/Documents/GEOL590/reproducible_data_analysis/homework/FinalProject/") #set working directory
getwd() #check working directory

# Load data file(s)
crater_Warhol <- read_csv("Warhol_Mercury_test.csv", col_names = TRUE) #import data
view(crater_Warhol) #check that import was correct
glimpse(crater_Warhol) #or use glimpse

# Filter data
crater_Warhol_filter <- crater_Warhol[, c(1, 11, 12, 13)] #filter new data frame to show relevant colums for data processing (1=FID, 11=lat_y, 12=lon_x, 13=dia_km)
view(crater_Warhol_filter) #check that data was filtered correctly

# Information about the planetary body
radius_mercury_km <- 2439.7 #insert radius of body in units of km

# Primary center information (A)
center_Warhol_lat <- -2.576 #insert primary center latitude
center_Warhol_lon <- -6.263 #insert primary center longitude

# Secondary center information (B)
mid_y_lat <- crater_Warhol_filter$lat_y #information about midpoint position of secondary craters
mid_x_lon <- crater_Warhol_filter$lon_x #information about midpoint position of secondary craters
```

We want to calculate the distance (C) in units of kilometer (km) of the secondary crater locations (B) away from the primary crater center point (A). In the code chunk we account for the shape of the planetary body. The latitude and longitude information about the location of the secondary craters and the primary crater must be converted into degrees and then into radians; the code below contains a function that performs this operation. The distance (C) (the parameter "length\_c\_ . . ." is maintained to correspond to the original Excel sheet used to calculate distance to avoid confusion with previous work) is calculated using a mathematical formula that uses the radian of points "(B)"/secondary crater locations and points "(A)"/primary crater center point to calculate the distance in radians of the secondary craters away from the primary crater center. The distance in kilometers is found by utilizing information about the length in radians and the radius of the planetary body.

``` r
# THE PURPOSE OF THIS FIRST PART OF THIS CHUNK IS TO CALCULATE THE DISTCANE (C) (in KM UNITS) OF THE SECONDARY CRATER AWAY FROM THE PRIMARY CRATER: 

# Write function to calculate radians from degrees:
  deg2rad <- function(deg) {
    (deg * pi) / (180)
    }

# Find Co-Lat. A (b)
  # Degrees:
  Co_Lat_A_deg <- 90 - center_Warhol_lat
  #Radians:
  Co_Lat_A_rad <- deg2rad(Co_Lat_A_deg)

# Find Co-Lat. B (a)
  # Degrees:
  Co_Lat_B_deg <- 90 - mid_y_lat
  #Radians:
  Co_Lat_B_rad <- deg2rad(Co_Lat_B_deg)

# Find Delta lon. C:
  # Degrees:
  delta_lon_C_deg <- mid_x_lon - center_Warhol_lon
  #Radians:
  delta_lon_C_rad <- deg2rad(delta_lon_C_deg)

# Find Distance (c)
  # Radians:
  length_c_rad <- acos((cos(Co_Lat_B_rad) * cos(Co_Lat_A_rad)) + 
                         (sin(Co_Lat_B_rad) * sin(Co_Lat_A_rad) * cos(delta_lon_C_rad)))
  # Distance (km):
  length_c_km <- length_c_rad * radius_mercury_km

# THE PURPOSE OF THIS SECOND PART OF THIS CHUNK IS TO UPDATE THE DATA FILE WITH THE CALCULATED DISTANCE (KM) DATA:

# Convert length (km) into a numeric vector:
#length_km_factor <- factor(length_c_km) #convert into factor if needed
distance_km <- as.numeric(length_c_km)

# Combine length (km) with filtered data (crater_Warhol_filter)
crater_Warhol_filter$distance_km <- distance_km
view(crater_Warhol_filter)
```

This research is focused on characterization of the upper envelope of the size-range distribution, as seen in the curves in Figure 1. This information provides a constraint on the maximum secondary crater size at a given distance from a primary. Quantile regression fits to a power law function of the 99th and 99.9th quantiles. The 99th quantile represents a typical large secondary size, while the 99.9th is closer to an absolute maximum. For additional reference the 50th and 95th quantiles are also included.

``` r
# THE PURPOSE OF THIS CHUNK IS TO PERFORM STATISTICAL ANALYSIS TO EVALUATE DATA TRENDS:

# Perform quantile regression using th rq function:

  # 50th Quantile:
  rq_fit_warhol_50th <- rq(dia_km ~ distance_km, data = crater_Warhol_filter, tau = .5)
  rq_fit_warhol_50th
```

    ## Call:
    ## rq(formula = dia_km ~ distance_km, tau = 0.5, data = crater_Warhol_filter)
    ## 
    ## Coefficients:
    ##  (Intercept)  distance_km 
    ##  2.791916350 -0.003297471 
    ## 
    ## Degrees of freedom: 2550 total; 2548 residual

``` r
  summary(rq_fit_warhol_50th)
```

    ## 
    ## Call: rq(formula = dia_km ~ distance_km, tau = 0.5, data = crater_Warhol_filter)
    ## 
    ## tau: [1] 0.5
    ## 
    ## Coefficients:
    ##             Value     Std. Error t value   Pr(>|t|) 
    ## (Intercept)   2.79192   0.05348   52.20192   0.00000
    ## distance_km  -0.00330   0.00024  -13.72713   0.00000

``` r
                #Coefficients:
                #            Value     Std. Error t value   Pr(>|t|) 
                #(Intercept)   2.79192   0.05348   52.20192   0.00000
                #distance_km  -0.00330   0.00024  -13.72713   0.00000
  
  # 95th Quantile:
  rq_fit_warhol_95th <- rq(dia_km ~ distance_km, data = crater_Warhol_filter, tau = .95)
  rq_fit_warhol_95th
```

    ## Call:
    ## rq(formula = dia_km ~ distance_km, tau = 0.95, data = crater_Warhol_filter)
    ## 
    ## Coefficients:
    ##  (Intercept)  distance_km 
    ##  5.060015478 -0.005399429 
    ## 
    ## Degrees of freedom: 2550 total; 2548 residual

``` r
  summary(rq_fit_warhol_95th)
```

    ## 
    ## Call: rq(formula = dia_km ~ distance_km, tau = 0.95, data = crater_Warhol_filter)
    ## 
    ## tau: [1] 0.95
    ## 
    ## Coefficients:
    ##             Value    Std. Error t value  Pr(>|t|)
    ## (Intercept)  5.06002  0.15745   32.13773  0.00000
    ## distance_km -0.00540  0.00081   -6.64564  0.00000

``` r
                #Coefficients:
                #            Value    Std. Error t value  Pr(>|t|)
                #(Intercept)  5.06002  0.15745   32.13773  0.00000
                #distance_km -0.00540  0.00081   -6.64564  0.00000
  
  # 99th Quantile:
  rq_fit_warhol_99th <- rq(dia_km ~ distance_km, data = crater_Warhol_filter, tau = .99)
  rq_fit_warhol_99th
```

    ## Call:
    ## rq(formula = dia_km ~ distance_km, tau = 0.99, data = crater_Warhol_filter)
    ## 
    ## Coefficients:
    ##  (Intercept)  distance_km 
    ##  6.045839136 -0.006174659 
    ## 
    ## Degrees of freedom: 2550 total; 2548 residual

``` r
  summary(rq_fit_warhol_99th)
```

    ## 
    ## Call: rq(formula = dia_km ~ distance_km, tau = 0.99, data = crater_Warhol_filter)
    ## 
    ## tau: [1] 0.99
    ## 
    ## Coefficients:
    ##             Value    Std. Error t value  Pr(>|t|)
    ## (Intercept)  6.04584  0.29331   20.61280  0.00000
    ## distance_km -0.00617  0.00193   -3.20255  0.00138

``` r
                #Coefficients:
                #            Value    Std. Error t value  Pr(>|t|)
                #(Intercept)  6.04584  0.29331   20.61280  0.00000
                #distance_km -0.00617  0.00193   -3.20255  0.00138
  
  # 99.9th Quantile:
  rq_fit_warhol_99_9th <- rq(dia_km ~ distance_km, data = crater_Warhol_filter, tau = .999)
  rq_fit_warhol_99_9th
```

    ## Call:
    ## rq(formula = dia_km ~ distance_km, tau = 0.999, data = crater_Warhol_filter)
    ## 
    ## Coefficients:
    ##  (Intercept)  distance_km 
    ##  8.299650982 -0.009483368 
    ## 
    ## Degrees of freedom: 2550 total; 2548 residual

``` r
  summary(rq_fit_warhol_99_9th)   #WARNING: 29 non-positive fis
```

    ## 
    ## Call: rq(formula = dia_km ~ distance_km, tau = 0.999, data = crater_Warhol_filter)
    ## 
    ## tau: [1] 0.999
    ## 
    ## Coefficients:
    ##             Value      Std. Error t value    Pr(>|t|)  
    ## (Intercept)    8.29965    0.01433  579.20136    0.00000
    ## distance_km   -0.00948    0.00005 -199.63741    0.00000

``` r
                #Coefficients:
                #            Value      Std. Error t value    Pr(>|t|)  
                #(Intercept)    8.29965    0.01433  579.20136    0.00000
                #distance_km   -0.00948    0.00005 -199.63741    0.00000

# Determine a linear regression model based on a logarithmic scaling of both the x and y axes to find the solution for "a" and "b" in "y = ax^b":
  #plot(crater_Warhol_filter$distance_km, crater_Warhol_filter$dia_km, log = "xy", cex = 0.8) #Plot for control reference if needed
model <- lm(log(crater_Warhol_filter$dia_km) ~ log(crater_Warhol_filter$distance_km))
  #points(crater_Warhol_filter$distance_km,
         #round(exp(coef(model)[1] + coef(model)[2] * log(crater_Warhol_filter$distance_km))),
         #col = "red")
a <- exp(coef(model)[1]) 
a #7.593766 (Intecept) is the "a" value in the power law function "y = ax^b"
```

    ## (Intercept) 
    ##    7.593766

``` r
b <- coef(model)[2] 
b #-0.2408627 is the "b" value in the power law function "y = ax^b"
```

    ## log(crater_Warhol_filter$distance_km) 
    ##                            -0.2408627

``` r
# THE PURPOSE OF THIS CHUNK IS TO GENERATE A PLOT WITH THE APPROPRIATE REGRESSION LINES TO VISUALISE TRENDS IN THE DATA:

# Create function to plot data with a generic layout
my.Craterplot <- function() {
  result <- ggplot(data = crater_Warhol_filter, #insert data
                   aes(x = distance_km, #define x axis 
                       y = dia_km)) + #define y axis
    labs(x = "Distance from Center (km)", #define x label text
         y = "Secondary Crater Diameter (km)") + #define y label text
    ggtitle("Warhol Crater (Mercury)") + # define title
    geom_point(size = 2, color = "blue") + #define plot type
    theme( #general theme
      axis.title.x = element_text(size = 18, face = "bold"),
      axis.title.y = element_text(size = 18, face = "bold"),
      legend.title = element_text(size = 15, face = "bold"),
      legend.text = element_text(size = 15),
      legend.key.size = unit(2.5, "lines"),
      axis.text.x = element_text(size = 15, color = "black"),
      axis.text.y = element_text(size = 15, color = "black"),
      panel.grid.major = element_line(color = "grey70", size = 0.5),
      panel.background = element_rect(fill = "white"),
      panel.border = element_rect(colour = "black", fill = NA, size = 1),
      axis.line.y = element_line(color = "black", size = 1),
      axis.line.x = element_line(color = "black", size = 1),
      axis.line.x.top = element_line(color = "black", size = 1),
      axis.ticks = element_line(color = "black", size = 1),
      axis.ticks.length = unit(0.3, "cm"), 
      plot.title = element_text(family = "Helvetica", 
                                  face = "bold",
                                  hjust = 0.5,
                                  size = (18)))
}

# Create plot that shows the regression of 0.5th, 0.95th, 0.99th, and 0.999th quantiles:

# Using an approximate power function (this plot resembles the output from using the "power trendline option in Excel"):
distdia_qr_log_power <- my.Craterplot() + 
  geom_quantile(formula = y~log(x), quantiles = c(0.5, 0.95, 0.99, 0.999), colour = "black", show.legend = TRUE) + #Could also use "formula = y~I(x^-2)"
  labs(subtitle = "Figure 1",
       caption = "Trends in secondary crater size with diatance from the primary crater center are \nshown in the black lines, indicating the 0.5th (bottom line), 0.95th, 0.99th, and 0.999th \n(top line) quantiles. The quantile regression fits to an approximate power law function \n(simplified as the scaling laws for secondary crater sizes across a planetary body \nhas not yet been determined, and is the topic of ongoing work).") +
  theme(plot.caption = element_text(hjust = 0, size = 12))
distdia_qr_log_power #note: 0.5 is the bottom line, 0.95 is the 2nd lowest, 0.99 is the 2nd top line, and 0.999 is the top line
```

![](FinalProjectHLS_files/figure-markdown_github/plots-1.png)
