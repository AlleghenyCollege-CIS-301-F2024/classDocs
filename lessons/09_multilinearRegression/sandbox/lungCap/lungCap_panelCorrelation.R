rm(list = ls()) # clear out the variables from memory to make a clean execution of the code.

# If you want to remove all previous plots and clear the console, run the following two lines.
graphics.off() # clear out all plots from previous work.

cat("\014") # clear the console

#library(tidyverse)
# A better way to code...
# Find out if the library is not already installed and\
# if not, install the library and then load it.

if(!require('tidyverse')) {
  install.packages('tidyverse')
  library('tidyverse')
}
if(!require('psych')) {
  install.packages('psych')
  library('psych')
}

#open lung capacity data
lc <-file.choose()

dataLungCap <- read.csv(lc, sep = ",", header = T)


# all against all correlation
pairs.panels(dataLungCap)

# Use the model to study correlations. Note the changes in the red lines
pairs.panels(dataLungCap, lm = TRUE)

# Work with a specific subset of the entire dataset
cor(dataLungCap$Age, dataLungCap$Height)

corPlot(dataLungCap[1:3])

pairs.panels(dataLungCap[1:3])

cor(dataLungCap$Age,dataLungCap$Height)
