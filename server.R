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

# Server
shinyServer(function(input, output, session) {
  
  # Stores reactive values 
  values <- reactiveValues()
  # Sets the default year to "2000"
  values$year <- 2000
  
  # sets the range for plots?
  ranges <- reactiveValues(x = NULL, y = NULL)
  
  # Stores in "president_filtered" filtered data based upon "president_selection"
  president_filtered <- reactive({
    president_data <- baby_names %>% filter(first == input$president_selection, gender == "boy")
    values$year <- filter(presidents, first == input$president_selection)$year
    return(president_data)
  })
  
  # Stores in "singer_filtered" filtered data based upon "singer_selection"
  singer_filtered <- reactive({
    singer_data <- baby_names %>% filter(first == input$singer_selection)
    values$year <- filter(grammys, first == input$singer_selection)$year
    return(singer_data)
  })
  
  # Stores in "author_filtered" filtered data based upon "author_selection"
  author_filtered <- reactive({
    author_data <- baby_names %>% filter(first == input$author_selection) 
    values$year <- filter(authors, first == input$author_selection)$year
    return(author_data)
  })
  
  # Outputs to "president_plot" plot data for presidents
  output$president_plot <- renderPlot({
    p <- ggplot((data = president_filtered()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y)
    return(p)
  })
  
  # Outputs to "singer_plot" plot data for singers
  output$singer_plot <- renderPlot({
    q <- ggplot((data = singer_filtered()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y)
    return(q)
  })
  
  # Outputs to "author_plot" plot data for authors
  output$author_plot <- renderPlot({
    w <- ggplot((data = author_filtered()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y)
    return(w)
  })
  
  # Not sure if we need separate clicks/brushes for each plot
  
  # observes event "plot_dblclick", and zooms in on range
  observeEvent(input$presplot_dblclick, {
    brush <- input$presplot_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  observeEvent(input$singerplot_dblclick, {
    brush <- input$singerplot_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  observeEvent(input$authplot_dblclick, {
    brush <- input$authplot_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
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
    cat("input$plot_brush:\n")
    str(input$plot_brush)
  })
  
  # prints information about plot click
  output$singerclick_info <- renderPrint({
    cat("input$plot_click:\n")
    str(input$plot_click)
  })
  output$authbrush_info <- renderPrint({
    cat("input$plot_brush:\n")
    str(input$plot_brush)
  })
  
  # prints information about plot click
  output$authclick_info <- renderPrint({
    cat("input$plot_click:\n")
    str(input$plot_click)
  })
  
  
  # Renders data table for "president_table" with filtered president data
  output$president_table <- renderDataTable({
    return(president_filtered())
  })
  
  # Returns a summary of the filtered president data
  output$president_summary <- renderPrint({
    summary(data.frame(president_filtered()))
  })
})