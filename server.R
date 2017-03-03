library(ggplot2)
library(shiny)
library(dplyr)
library(tidyr)
baby_names <- read.csv("data/baby-names.csv") %>% 
              filter(name == "Ronald", sex == "boy")
shinyServer(function(input, output, session) {
  
  
  filtered <- reactive({
    data <- baby_names
    
    return(data)
  })
  
  output$plot <- renderPlot({
    p <- ggplot((data = filtered()), mapping = aes(x = year, y = percent)) +
      geom_point() 
      
    
    return(p)
  })
})