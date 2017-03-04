# Load the appropriate libraries
library(ggplot2)
library(shiny)
library(dplyr)
library(tidyr)

# Read in the baby names data set
baby.names <- read.csv("data/baby-names.csv")
baby.names.1880 <- baby.names %>%
  select(year = 1880)


# Presidents
# Time Person
# Award winner