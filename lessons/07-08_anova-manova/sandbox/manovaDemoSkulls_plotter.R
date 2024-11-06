# Manova demo using Skulls dataset.

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

# ref: https://www.youtube.com/watch?v=48cZ2cMBpio&t=18s

if(!require('HSAUR2')) {
  install.packages('HSAUR2')
  library('HSAUR2')
}

# The skulls data concerns measurements made on Egyptian skulls from five epochs.
# ?skulls

data("skulls") # use this data set for proceeding code
names(skulls) # get the variables

summary(skulls) # summary of the data


# Plotting to visualize the means.
###

# steps:
# Install and load the necessary packages.
# Load the skulls dataset.
# Calculate the means of each column grouped by epoch.
# Create a plot to visualize the means.


# Calculate the means of each column by epoch
means_by_epoch <- skulls %>%
  group_by(epoch) %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE))
# across(): we apply the function to multiple cols

# Reshape the data for plotting
means_long <- means_by_epoch %>%
  pivot_longer(cols = -epoch, names_to = "measurement", values_to = "mean_value")

# Create the plot
ggplot(means_long, aes(x = epoch, y = mean_value, fill = measurement)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Mean Values of Skull Measurements by Epoch",
       x = "Epoch",
       y = "Mean Value") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

##################################
# Add manova code below
##################################

## Create vector for manova test
# Note: cbind Take a sequence of vector, matrix or data-frame
# arguments and combine by columns or rows, respectively. 

# We want to order mb, bh, bl and nh as factors according epoch variable.
# Use cbind() to determine different columns form the response then we use 'as.factor' 
# to convert the "epoch" variable to a factor label  

skull.manova1 <- manova(cbind(mb, bh, bl, nh) ~ as.factor(epoch), data = skulls) 


# Prepare different types of manova tests

summary(skull.manova1, test = "Hotelling-Lawley")
summary(skull.manova1, test = "Roy")
summary(skull.manova1, test = "Pillai")
summary(skull.manova1, test = "Wilks")

#Note: all p-values from all tests seem to agree in significance

# Check which differences there are.
summary.aov(skull.manova1)

# Notes:
# mb: is significant
# bh: is significant, but marginally
# bl: is highly significant
# nh: not significant

# Perform pairwise comparisons to improve rigor.
# Question: Where is there a "noticiable difference" in the skulls dataset?
# We compare 4000BC to 200BC

skull.manova2 <- manova(cbind(mb, bh, bl, nh) ~ as.factor(epoch), 
                        data = skulls, 
                        subset = as.factor(epoch) %in% c("c4000BC", "c200BC")
) 
summary(skull.manova2)

# Note: the p-value is highly significant (p-value is 0.0004564)
# We conclude that skull dimensions between 4000BC and 200BC are significant


# end