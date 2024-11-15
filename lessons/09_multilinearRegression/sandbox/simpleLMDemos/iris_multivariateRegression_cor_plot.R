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
# Load the iris dataset
data(iris)


# Check correlations among selected variables
correlations <- cor(iris[, c("Sepal.Length", "Sepal.Width", "Petal.Length")])
print(correlations)

# another way to complete an all-against-all correlation analysis
pairs.panels(iris)

# Fit the linear model
model <- lm(Sepal.Length ~ Sepal.Width + Petal.Length, data = iris)

# Display the summary of the model
summary(model)

# Create a ggplot with smooth line
ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length, color = Petal.Length)) +
  geom_point() +
  geom_smooth(se = TRUE, color = "black") +
  labs(title = "Multivariate Linear Regression of Sepal Length",
       x = "Sepal Width",
       y = "Sepal Length") +
  scale_color_gradient(low = "blue", high = "red") +
  theme_minimal()




# Create a ggplot with the linear model as smooth line
ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length, color = Petal.Length)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE, color = "black") +
  labs(title = "Multivariate Linear Regression of Sepal Length",
       x = "Sepal Width",
       y = "Sepal Length") +
  scale_color_gradient(low = "blue", high = "red") +
  theme_minimal()


