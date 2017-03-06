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

  values <- reactiveValues()
  values$year <- 2000
  filtered <- reactive({
    
    if(input$showpres){
      data <- baby_names %>% filter(name == input$presselection, sex == "boy")
      values$year <- filter(presidents, first == input$presselection)$year
    }else if(input$showsing){
      data <- baby_names %>% filter(name == input$singerselection, sex == "boy")
      values$year <- filter(grammy, first == input$presselection)$year
    }else if(input$showsauth){
      data <- baby_names %>% filter(name == input$presselection, sex == "boy") 
      values$year <- filter(authors, first == input$presselection)$year
    }
    
    return(data)
  })
  
  output$plot <- renderPlot({
    p <- ggplot((data = filtered()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year)
    
    
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