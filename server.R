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

  values <- reactiveValues()
  values$year <- 2000

  ranges <- reactiveValues(x = NULL, y = NULL)
  
  filtered1 <- reactive({
      data1 <- baby_names %>% filter(first == input$presselection, gender == "boy")
      values$year <- filter(presidents, first == input$presselection)$year
      return(data1)
  })
  filtered2 <- reactive({
      data2 <- baby_names %>% filter(first == input$singerselection)
      values$year <- filter(grammys, first == input$singerselection)$year
      return(data2)
  })
  filtered3 <- reactive({
      data3 <- baby_names %>% filter(first == input$authorselection) 
      values$year <- filter(authors, first == input$authorselection)$year
 
    return(data3)
  })
  
  output$plot1 <- renderPlot({
    p <- ggplot((data = filtered1()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y)
    
    
    return(p)
  })
  output$plot2 <- renderPlot({
    q <- ggplot((data = filtered2()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y)
    
    
    return(q)
  })
  output$plot3 <- renderPlot({
    w <- ggplot((data = filtered3()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y)
    
    
    return(w)
  })
  observeEvent(input$plot_dblclick, {
    brush <- input$plot_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$brush_info <- renderPrint({
    cat("input$plot_brush:\n")
    str(input$plot_brush)
  })
  
  output$click_info <- renderPrint({
    cat("input$plot_click:\n")
    str(input$plot_click)
  })
  
  output$table <- renderDataTable({
    return(filtered1())
  })
  
  #returns a summary of the filtered data
  output$summary <- renderPrint({
    summary(data.frame(filtered1()))
  })
})

