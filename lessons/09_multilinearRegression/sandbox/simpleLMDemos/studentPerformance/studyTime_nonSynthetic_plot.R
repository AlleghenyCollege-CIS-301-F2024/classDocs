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
  install.packages('pyche')
  library('pyche')
}

# load the csv file
f <- file.choose()
#f <- "score_updated.csv"
myData <- read_csv(file = f,col_names = TRUE)


# check for correlations between variables
pairs.panels(myData)

# Plot the data using ggplot
ggplot(myData, aes(x = Hours, y = Scores)) +
  geom_point() +
  labs(title = "Homework Time vs Grades") + geom_smooth()

# Plot the data using ggplot with lm model
ggplot(myData, aes(x = Hours, y = Scores)) +
  geom_point() +
  labs(title = "Homework Time vs Grades") + geom_smooth(method = lm)



mod <- lm(data = myData, Hours ~ Scores)
summary(mod)

