# Load the appropriate libraries
library(ggplot2)
library(shiny)
library(dplyr)
library(tidyr)

# Load in the datasets
baby_names <- read.csv("data/baby-names.csv", stringsAsFactors = FALSE)
presidents <- read.csv("data/presidents.csv", stringsAsFactors = FALSE)
grammys <- read.csv("data/grammy.csv", stringsAsFactors = FALSE)
authors <- read.csv("data/authors.csv", fileEncoding="UTF-8-BOM", stringsAsFactors = FALSE)
colnames(authors) <- c("year", "first","full", "gender", "name")

# UI
shinyUI(fluidPage(
  titlePanel("Baby names observation data"),
  br(),
  
  sidebarLayout(
    sidebarPanel(
      h3(strong("Please click one box")),
      p("graphs will only display one data set at a time"),
      checkboxInput(inputId = "showpres",
                    label = strong("Include President"),
                    value = TRUE),
      selectInput("presselection", "Choose a president:",
                  choices = presidents$full),
      checkboxInput(inputId = "showauth",
                    label = strong("Include Author"),
                    value = FALSE),
      selectInput("authorselection", "Choose a Author:",
                  choices = authors$full),
      checkboxInput(inputId = "showsing",
                    label = strong("Include Singer"),
                    value = FALSE),
      selectInput("singerselection", "Choose a singer:",
                  choices = grammys$full)
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
        tabPanel(strong("Plot"), plotOutput("plot", click = 'plot_click', dblclick = "plot_dblclick", brush = brushOpts(
                 id = "plot_brush", resetOnNew = TRUE)), fluidRow(column(width = 5, verbatimTextOutput("click_info")),
                 column(width = 5,verbatimTextOutput("brush_info")))),
        
        tabPanel(strong("Table"), br(), p("This is a table of all the data points listed under the user's selected name and profession"),
                 dataTableOutput("table"), wellPanel(helpText(a("Baby names source data", href="http://www.worldbank.org/")), 
                  helpText(a("Grammy data source", href = "http://www.worldbank.org/")), 
                  helpText(a("President source data", href="http://www.worldbank.org/")))), 
        
        tabPanel(strong("Summary"), br(), p("Shows a summary of the data selected (same as the data points 
                                      displayed on the table table tab)"), verbatimTextOutput("summary"))
        )
      )
    )
  )
)