# Load the appropriate libraries
library(ggplot2)
library(shiny)
library(dplyr)
library(tidyr)

# Load in the datasets
baby_names <- read.csv("data/baby-names.csv")
presidents <- read.csv("data/presidents.csv")
grammys <- read.csv("data/grammy.csv")

displays <- c("Presidents", "Musicans")
actual.file.names <- c("presidents", "grammy_data")

data.selection <- data.frame(displays, actual.file.names)

# UI
shinyUI(fluidPage(
  titlePanel("Baby names observation data"),
  br(),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("selection", "Choose a president:",
                  choices = presidents$first),
      selectInput("comparison", "Compare popular baby names to:", 
                  choices = data.selection$displays )
      
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
        tabPanel(strong("Plot"), plotOutput("plot", click = 'plot_click'), 
                 fluidRow(column(width = 5, verbatimTextOutput("click_info")))),
        
        tabPanel(strong("Table"), br(), p("This is a table of all the data points listed under the president's name"),
                 dataTableOutput("table")) 
      )
        
    )
    
    )
  )
  
)