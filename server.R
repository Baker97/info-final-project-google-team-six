# Load the appropriate libraries
library(ggplot2)
library(shiny)
library(dplyr)
library(tidyr)

# Load in the datasets
baby_names <- read.csv("data/baby-names.csv")
presidents <- read.csv("data/presidents.csv")
grammys <- read.csv("data/grammy.csv")
authors <- read.csv("data/authors.csv", fileEncoding="UTF-8-BOM")
colnames(authors) <- c("year", "first","full", "gender", "name")


# Server
shinyServer(function(input, output, session) {

  values <- reactiveValues()
  values$year <- 2000
  ranges <- reactiveValues(x = NULL, y = NULL)
  filtered <- reactive({
    
    if(input$showpres){
      data <- baby_names %>% filter(first == input$presselection, gender == "boy")
      values$year <- filter(presidents, first == input$presselection)$year
    }else if(input$showsing){
      data <- baby_names %>% filter(first == input$singerselection)
      values$year <- filter(grammys, first == input$singerselection)$year
    }else if(input$showauth){
      data <- baby_names %>% filter(first == input$authorselection) 
      values$year <- filter(authors, first == input$authorselection)$year
    } else {
    validate(
      need(input$data != "", "Please select a data set")
    )
    }
    return(data)
  })
  
  output$plot <- renderPlot({
    p <- ggplot((data = filtered()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y)
    
    
    return(p)
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
    return(filtered())
  })
  
  #returns a summary of the filtered data
  output$summary <- renderPrint({
    summary(data.frame(filtered()))
  })
})