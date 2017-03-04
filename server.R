# Load the appropriate libraries
library(ggplot2)
library(shiny)
library(dplyr)
library(tidyr)

# Load in the datasets
baby_names <- read.csv("data/baby-names.csv")
presidents <- read.csv("data/presidents.csv")
grammys <- read.csv("data/grammy.csv")

# Server
shinyServer(function(input, output, session) {
  
  filtered <- reactive({
    data <- baby_names %>% filter(name == input$selection) 
    
    return(data)
  })
  
  output$plot <- renderPlot({
    p <- ggplot((data = filtered()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = filter(presidents, first == input$selection)$year[1])
      
    
    return(p)
  })
  
  output$click_info <- renderPrint({
    cat("input$plot_click:\n")
    str(input$plot_click)
  })
  
  output$table <- renderDataTable({
    return(filtered())
  })
  
})