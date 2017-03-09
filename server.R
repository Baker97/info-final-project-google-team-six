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
      coord_cartesian(xlim = ranges$x, ylim = ranges$y) +
      labs(title = paste("Displaying data for", input$president_selection) )
    return(p)
  })
  
  # Outputs to "singer_plot" plot data for singers
  output$singer_plot <- renderPlot({
    q <-
      ggplot((data = singer_filtered()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year) +
      coord_cartesian(xlim = ranges2$x, ylim = ranges2$y) +
      labs(title = paste("Displaying data for", input$singer_selection) )
    return(q)
  })
  
  # Outputs to "author_plot" plot data for authors
  output$author_plot <- renderPlot({
    w <-
      ggplot((data = author_filtered()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year) +
      coord_cartesian(xlim = ranges3$x, ylim = ranges3$y) +
      labs(title = paste("Displaying data for", input$author_selection) )
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
    pres_first_name <- filter(presidents, full == input$president_selection)$first
    pres_gender <- filter(presidents, full == input$president_selection)$gender
    nearPoints(filter(baby_names, first == pres_first_name, gender == pres_gender), input$presplot_click)
  })
  output$singerbrush_info <- renderPrint({
    cat("input$singerplot_brush:\n")
    str(input$singerplot_brush)
  })
  
  # prints information about plot click
  output$singerclick_info <- renderPrint({
    sing_first_name <- filter(grammys, full == input$singer_selection)$first
    sing_gender <- filter(grammys, full == input$singer_selection)$gender
    nearPoints(filter(baby_names, first == sing_first_name, gender == sing_gender), input$singerplot_click)
  })
  output$authbrush_info <- renderPrint({
    cat("input$authplot_brush:\n")
    str(input$authplot_brush)
  })
  
  # prints information about plot click
  output$authclick_info <- renderPrint({
    auth_first_name <- filter(authors, full == input$author_selection)$first
    auth_gender <- filter(authors, full == input$author_selection)$gender
    nearPoints(filter(baby_names, first == auth_first_name, gender == auth_gender), input$authplot_click)
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
    
  })
  
  # Singer Influence Table outputted to "singer_influence"
  output$singer_influence <- renderDataTable({
    
  })
  
  # Author Influence Table outputted to "author_influence"
  output$author_influence <- renderDataTable({
    
  })
  
})