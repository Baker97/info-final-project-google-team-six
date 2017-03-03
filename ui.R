# Load the appropriate libraries
library(ggplot2)
library(shiny)
library(dplyr)
library(tidyr)

# Read in the baby names data set
baby.names <- read.csv("data/baby-names.csv")

shinyUI(fluidPage(
  titlePanel(""),
  
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      plotOutput("plot", click = 'plot_click')
    )
    
    
  )
  
))