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
authors <- read.csv("data/authors.csv",
           fileEncoding = "UTF-8-BOM",
           stringsAsFactors = FALSE)
colnames(authors) <- c("year", "first", "full", "gender", "name")

# Server
shinyServer(function(input, output, session) {
  # Stores reactive values
  values <- reactiveValues()
  # Sets the default year to "2000"
  values$year <- 2000
  
  # sets the range for plots?
  ranges <- reactiveValues(x = NULL, y = NULL)
  ranges2 <- reactiveValues(x = NULL, y = NULL)
  ranges3 <- reactiveValues(x = NULL, y = NULL)
  
  # Stores in "president_filtered" filtered data based upon "president_selection"
  president_filtered <- reactive({
    pres_first_name <- filter(presidents, full == input$president_selection)$first
    pres_gender <- filter(presidents, full == input$president_selection)$gender
    president_data <-
      baby_names %>% filter(first == pres_first_name, gender == pres_gender)
    values$year <-
      filter(presidents, full == input$president_selection)$year
    return(president_data)
  })
  
  # Stores in "singer_filtered" filtered data based upon "singer_selection"
  singer_filtered <- reactive({
    sing_first_name <- filter(grammys, full == input$singer_selection)$first
    sing_gender <- filter(grammys, full == input$singer_selection)$gender
    singer_data <-
      baby_names %>% filter(first == sing_first_name, gender == sing_gender)
    values$year <-
      filter(grammys, full == input$singer_selection)$year
    return(singer_data)
  })
  
  # Stores in "author_filtered" filtered data based upon "author_selection"
  author_filtered <- reactive({
    auth_first_name <- filter(authors, full == input$author_selection)$first
    auth_gender <- filter(authors, full == input$author_selection)$gender
    author_data <-
      baby_names %>% filter(first == auth_first_name, gender == auth_gender)
    values$year <-
      filter(authors, full == input$author_selection)$year
    return(author_data)
  })
  
  # Outputs to "president_plot" plot data for presidents
  output$president_plot <- renderPlot({
    p <-
      ggplot((data = president_filtered()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y)
    return(p)
  })
  
  # Outputs to "singer_plot" plot data for singers
  output$singer_plot <- renderPlot({
    q <-
      ggplot((data = singer_filtered()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year) +
      coord_cartesian(xlim = ranges2$x, ylim = ranges2$y)
    return(q)
  })
  
  # Outputs to "author_plot" plot data for authors
  output$author_plot <- renderPlot({
    w <-
      ggplot((data = author_filtered()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year) +
      coord_cartesian(xlim = ranges3$x, ylim = ranges3$y)
    return(w)
  })
  
  # Not sure if we need separate clicks/brushes for each plot
  
  # observes event "plot_dblclick", and zooms in on range
  observeEvent(input$presplot_dblclick, {
    presbrush <- input$presplot_brush
    if (!is.null(presbrush)) {
      ranges$x <- c(presbrush$xmin, presbrush$xmax)
      ranges$y <- c(presbrush$ymin, presbrush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  observeEvent(input$singerplot_dblclick, {
    singerbrush <- input$singerplot_brush
    if (!is.null(singerbrush)) {
      ranges2$x <- c(singerbrush$xmin, singerbrush$xmax)
      ranges2$y <- c(singerbrush$ymin, singerbrush$ymax)
      
    } else {
      ranges2$x <- NULL
      ranges2$y <- NULL
    }
  })
  observeEvent(input$authplot_dblclick, {
    authbrush <- input$authplot_brush
    if (!is.null(authbrush)) {
      ranges3$x <- c(authbrush$xmin, authbrush$xmax)
      ranges3$y <- c(authbrush$ymin, authbrush$ymax)
      
    } else {
      ranges3$x <- NULL
      ranges3$y <- NULL
    }
  })
  
  # prints information about brushed area
  output$presbrush_info <- renderPrint({
    cat("input$presplot_brush:\n")
    str(input$presplot_brush)
  })
  
  # prints information about plot click
  output$presclick_info <- renderPrint({
    cat("input$presplot_click:\n")
    str(input$presplot_click)
  })
  output$singerbrush_info <- renderPrint({
    cat("input$singerplot_brush:\n")
    str(input$singerplot_brush)
  })
  
  # prints information about plot click
  output$singerclick_info <- renderPrint({
    cat("input$singerplot_click:\n")
    str(input$singerplot_click)
  })
  output$authbrush_info <- renderPrint({
    cat("input$authplot_brush:\n")
    str(input$authplot_brush)
  })
  
  # prints information about plot click
  output$authclick_info <- renderPrint({
    cat("input$authplot_click:\n")
    str(input$authplot_click)
  })
  
  
  # Renders data table for "president_table" with filtered president data
  output$president_table <- renderDataTable({
    return(president_filtered())
  })
  output$singer_table <- renderDataTable({
    return(singer_filtered())
  })
  output$author_table <- renderDataTable({
    return(author_filtered())
  })
  
  # Returns a summary of the filtered president data
  output$president_summary <- renderPrint({
    summary(data.frame(president_filtered()))
  })
  output$singer_summary <- renderPrint({
    summary(data.frame(singer_filtered()))
  })
  output$author_summary <- renderPrint({
    summary(data.frame(author_filtered()))
  })
  
  
  # Create summary data for report, to show impact
  
  # President Influence Table outputted to "president_influence"
  output$president_influence <- renderDataTable({
    return(GetInfluenceForDataSet(presidents))
  })
  
  # Singer Influence Table outputted to "singer_influence"
  output$singer_influence <- renderDataTable({
    return(GetInfluenceForDataSet(grammys))
  })
  
  # Author Influence Table outputted to "author_influence"
  output$author_influence <- renderDataTable({
    return(GetInfluenceForDataSet(authors))
  })
  
  # Summary Statistic Calculation
  
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
      overall_change <- round((after_slope - before_slope) * 1000, digits = 3)
    }
    
    # Returns vector of name, year, and calculated change
    return(c(full_name, year, overall_change))
  }
  
  # Defines "GetInfluenceForDataSet" which takes in a data set of people and returns a data set with a name, year, and influence percentage
  GetInfluenceForDataSet <- function(data) {
    
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
    return(viewable_results)
  }
  
})