###=======
### Homework 3: Input / Output & Wide vs long (tidy) data & Plotting with ggplot2
###=======

#Part 1: Input / Output
##Use one of the readr functions (read_csv(), read_delim(), etc), read in either:
##Some of your own data, or The .csv file here (you’ll want to right-click and ‘download file’). This is a subset of the babynames dataset, which lists the number of babies registered with the US Social Security Administration by year, sex, and name. I have filtered it to only include babies named “Chris” and reformatted it. The male and female columns indicate numbers of male and female children, respectively.

####Import data baby names across several years
bb_names <- read_csv("data/chris_names_wide.csv") #load data of airports in north dakota with 'read_csv' tool
bb_names #view file

#Part 2: Wide vs long (tidy) data
bb_names_long <- pivot_longer(bb_names, 
                                 cols = -year, 
                                 names_to = "sex", 
                                 values_to = "n")
bb_names_long #view output from long format after pivot

#Part 3: Plotting with ggplot2
## Plot 1: A line plot with year on the x axis, the number of babies on the y axis, and a different color for each sex
bb_line <- ggplot(bb_names_long, aes(x = year, y = n, color = sex)) + 
  geom_line() + 
  xlab("Year") +
  ylab("Number (n)") +
  ggtitle("Number of Babies Named 'Chris' (1880 to 2000)")
bb_line

print(bb_line) #print final plot

## Plot 2: A plot with the same axes, but with a “loess”-smoothed line representing the data
bb_loess <- ggplot(bb_names_long, aes(x = year, y = n, color = sex)) + 
  #geom_line() + 
  geom_smooth(method = "loess") +
  xlab("Year") +
  ylab("Number (n)") +
  ggtitle("Number of Babies Named 'Chris' (Using Loess Smooths)")
bb_loess

print(bb_loess) #print final plot

## Plot 3: A boxplot with sex on the x axis and the number of people with that name on the y-axis.

bb_box <- ggplot(bb_names_long, aes(x = sex, y = n, color = sex)) + 
  geom_boxplot() +
  xlab("Sex") +
  ylab("Number (n)") +
  ggtitle("Number of Babies Named 'Chris' (1880 to 2000)")
bb_box

print(bb_box) # print final plot