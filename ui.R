# Load the appropriate libraries
library(ggplot2)
library(shiny)
library(dplyr)
library(tidyr)

# Read in the baby names data set
baby_names <- read.csv("data/baby-names.csv")
presidents <- read.csv("data/presidents.csv")

shinyUI(fluidPage(
  titlePanel("Baby names observation data"),
  br(),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("selection", "Choose a president:",
                  choices = presidents$first)
      
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
        tabPanel(strong("Plot"), plotOutput("plot", click = 'plot_click'), 
                 fluidRow(column(width = 5, verbatimTextOutput("click_info")))),
        
        tabPanel(strong("Table"), br(), p("This is a table of all the data point listed under the president's name"),
                 dataTableOutput("table")) 
      )
        
    )
    
    )
  )
  
)