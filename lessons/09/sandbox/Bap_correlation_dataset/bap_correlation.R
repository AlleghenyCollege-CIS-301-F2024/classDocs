# correlation using all against all

rm(list = ls()) # clear out the variables from memory to make a clean execution of the code.

# If you want to remove all previous plots and clear the console, run the following two lines.
graphics.off() # clear out all plots from previous work.

cat("\014") # clear the console

# dataset: characters-aggregated.zip at https://openpsychometrics.org/_rawdata/
# dataset link: http://openpsychometrics.org/_rawdata/characters-aggregated.zip

if(!require('tidyverse')) {
  install.packages('tidyverse')
  library('tidyverse')
}

if(!require('psych')) {
  install.packages('psych')
  library('psych')
}
# open the crime dataset from the data.
c <- file.choose() # set the filename
aggData <- read.csv(c, sep = ",") # load and read the data.

#View(aggData)
#data(aggData)
pairs.panels(aggData[1:5,2:10])
cor.plot(aggData[1:5,2:10])



