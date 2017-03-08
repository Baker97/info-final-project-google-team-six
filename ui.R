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
  # Title of page
  titlePanel("Baby names observation data"),
  br(),
  
  # Nav bar, with nav bar title
  navbarPage("Page Title",
             
             # President's page         
             tabPanel("Presidents", 
                      sidebarLayout(
                        
                        # Presidents' user controls
                        sidebarPanel(
                          h3(strong("Please click one box")),
                          p("graphs will only display one data set at a time"),
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
                        
                        # President's data
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
                      ),
             
             # Musicians' page
             tabPanel("Music",      
                      sidebarLayout(
                        
                        # Mucisians' user controls
                        sidebarPanel(
                          h3(strong("Please click one box")),
                          p("graphs will only display one data set at a time"),
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
                        
                        # Mucisians' data
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
                      ),
             
             # Authors' data
             tabPanel("Authors",      
                      sidebarLayout(
                        
                        # Authors' user controls
                        sidebarPanel(
                          h3(strong("Please click one box")),
                          p("graphs will only display one data set at a time"),
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
                        
                        # Authors' data
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
                      ),
             
             # Data summary
             tabPanel("Summary")
             )
             )
)