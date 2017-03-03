# Load the appropriate libraries
library(ggplot2)
library(shiny)
library(dplyr)
library(tidyr)

# Read in the baby names data set
baby_names <- read.csv("data/baby-names.csv")
presidents <- read.csv("data/presidents.csv")

shinyUI(fluidPage(
  titlePanel(""),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("selection", "Choose a president:",
                  choices = presidents$first)
      
    ),
    mainPanel(
      plotOutput("plot", click = 'plot_click')
    )
    
    
  )
  
))