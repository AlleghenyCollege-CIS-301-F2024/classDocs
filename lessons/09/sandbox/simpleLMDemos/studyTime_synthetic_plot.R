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


# Create some synthetic data
set.seed(123) # set the seed for reproducibility
n_students <- 50
grades <- rnorm(n = n_students, mean = 80, sd = 10)
homework_time <- round(runif(n = n_students, min = 2, max = 6), digits = 2)
myData <- data.frame(grades, homework_time)

pairs.panels(myData)

# Plot the data using ggplot
ggplot(myData, aes(x = grades, y = homework_time)) +
  geom_point() +
  labs(title = "Homework Time vs Grades") + geom_smooth()

# Plot the data using ggplot with lm model

ggplot(myData, aes(x = grades, y = homework_time)) +
  geom_point() +
  labs(title = "Homework Time vs Grades") + geom_smooth(method = lm)


mod <- lm(data = myData, homework_time ~ grades)
summary(mod)
