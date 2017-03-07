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

# UI
shinyUI(fluidPage(
  titlePanel("Baby names observation data"),
  br(),
  
  sidebarLayout(
    sidebarPanel(
      h3(strong("Please click one box")),
      ("graphs will only display one data set at a time"),
      checkboxInput(inputId = "showpres",
                    label = strong("Include President"),
                    value = TRUE),
      selectInput("presselection", "Choose a president:",
                  choices = presidents$first),
      checkboxInput(inputId = "showauth",
                    label = strong("Include Author"),
                    value = FALSE),
      selectInput("authorselection", "Choose a Author:",
                  choices = authors$first),
      checkboxInput(inputId = "showsing",
                    label = strong("Include Singer"),
                    value = FALSE),
      selectInput("singerselection", "Choose a singer:",
                  choices = grammys$first)
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
        tabPanel(strong("Plot"), plotOutput("plot", click = 'plot_click', dblclick = "plot_dblclick", brush = brushOpts(
                 id = "plot_brush", resetOnNew = TRUE)), fluidRow(column(width = 5, verbatimTextOutput("click_info")),
                 column(width = 5,verbatimTextOutput("brush_info")))),
        
        tabPanel(strong("Table"), br(), p("This is a table of all the data points listed under the president's name"),
                 dataTableOutput("table"), wellPanel(helpText(a("Baby names source data", href="http://www.worldbank.org/")), 
                  helpText(a("Grammy data source", href = "http://www.worldbank.org/")), 
                  helpText(a("President source data", href="http://www.worldbank.org/"))                              
                 )) 
        )
      )
    )
  )
)