# Load the appropriate libraries
library(ggplot2)
library(shiny)
library(dplyr)
library(tidyr)
library(shinythemes)

# Load in the datasets
baby_names <- read.csv("data/baby-names.csv", stringsAsFactors = FALSE)
presidents <- read.csv("data/presidents.csv", stringsAsFactors = FALSE)
grammys <- read.csv("data/grammy.csv", stringsAsFactors = FALSE)
authors <- read.csv("data/authors.csv", fileEncoding="UTF-8-BOM", stringsAsFactors = FALSE)
colnames(authors) <- c("year", "first","full", "gender", "name")

# Defines "GetInfluence" function, which takes in a row, and returns a vector with a name, year, and percent change influence.
GetInfluence <- function(row) {
  
  # Initializes variables from inputted row
  name <- getElement(row, "first")
  selected_gender <- getElement(row, "gender")
  year <- as.numeric(getElement(row, "year"))
  full_name <- getElement(row, "full")
  
  # Defaulted change to "Not Enough Data", which displays if name does not have enough year data to calculate change
  overall_change <- "Not Enough Data"
  
  # Sets "years_before" and "years_after" to create a range of 10 years (5 before, 5 after) to look for influence
  years_before <- c((year - 5):(year - 1))
  years_after <- c((year + 1):(year + 5))
  
  # Filters "baby_names" into "specific_names" looking only for rows with the relevant name and gender
  specific_names <- baby_names %>% filter(first == name) %>% 
    filter(gender == selected_gender)
  
  # Enters if statement if "specific_names" has year data for the years in the range specified in "years_before" and "years_after"
  if (all(years_before %in% specific_names$year) && all(years_after %in% specific_names$year)) {
    
    # Creates a data frames "before_data" and "after_data" filtering from "specific_names" the data for years in range, and percent of names
    before_data <- data.frame(years_before, specific_names %>% filter(year %in% years_before) %>% select(percent))
    after_data <- data.frame(years_after, specific_names %>% filter(year %in% years_after) %>% select(percent))
    
    # Saves the linear regression slope for both before data and after data in "before_slope" and "after_slope"
    before_linear_regression <- lm(before_data$percent ~ before_data$years_before)
    before_slope <- (summary(before_linear_regression)$coefficients[2,1])
    after_linear_regression <- lm(after_data$percent ~ after_data$years_after)
    after_slope <- (summary(after_linear_regression)$coefficients[2,1])
    
    # Calculates "overall_change", which is the slope after - slope before, which measures potential difference caused by person
    overall_change <- (after_slope - before_slope)
  }
  
  # Returns vector of name, year, and calculated change
  return(c(full_name, year, overall_change))
}

# Defines "GetInfluenceForDataSet" which takes in a data set of people and returns a data set with a name, year, and influence percentage
GetInfluenceForDataSet <- function(data) {
  
  data <- presidents
  # Defines "years" as the range the given data set's years.
  years <- range(data$year)
  
  # Filters data so that only data collected 5 years from the limits are used, so that years before and after used data can be analyzed
  specified_data <- data %>% filter(year < (years[2] - 5)) %>% filter(year > (years[1] + 5))
  
  # Applies "GetInfluence" function to all rows, stores this in "influence_results"
  influence_results <- apply(specified_data, 1, function(x) GetInfluence(x))
  
  # Switches columns and rows of "influence_results", stores this in "viewable_results"
  viewable_results <- t(influence_results)
  
  # Cleans up column names for "viewable_results", and returns this
  colnames(viewable_results) <- c("Name", "Year", "Influence")
  viewable_results <- viewable_results %>% filter("Influence" == "Not Enough Data")
  return(viewable_results)
}

presidents_table <- GetInfluenceForDataSet(presidents)
GetInfluenceForDataSet(grammys)
GetInfluenceForDataSet(authors)
