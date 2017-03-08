# Load the appropriate libraries
library(ggplot2)
library(shiny)
library(dplyr)
library(tidyr)
library(shinythemes)

# Load in the datasets
baby_names <- read.csv("data/baby-names.csv", stringsAsFactors = FALSE)
presidents <- read.csv("data/presidents.csv", stringsAsFactors = FALSE)
grammys <- read.csv("data/grammy.csv", stringsAsFactors = FALSE)
authors <- read.csv("data/authors.csv", fileEncoding="UTF-8-BOM", stringsAsFactors = FALSE)
colnames(authors) <- c("year", "first","full", "gender", "name")

# UI
shinyUI(fluidPage(theme = shinytheme("flatly"),
                  # Title of page
                  titlePanel("Baby names observation data"),
                  br(),
                  
                  # Nav bar, with nav bar title
                  navbarPage("NavBar",
                             
                             # President's page         
                             tabPanel("Presidents", 
                                      sidebarLayout(
                                        
                                        # Presidents' user controls
                                        sidebarPanel(
                                          selectInput("presselection", "Choose a President:", choices = presidents$first)
                                        ),
                                        
                                        # President's data
                                        mainPanel(
                                          tabsetPanel(type = "tabs",
                                                      tabPanel(strong("Plot"), plotOutput("plot1", click = 'plot_click', 
                                                                                          dblclick = "plot_dblclick", brush = brushOpts(
                                                                                            id = "plot_brush", resetOnNew = TRUE)), fluidRow(column
                                                                                                                                             (width = 5, verbatimTextOutput("click_info")),
                                                                                                                                             column(width = 5,verbatimTextOutput("brush_info")))),
                                                      
                                                      tabPanel(strong("Table"), br(), p("This is a table of all the data 
                                                                                        points listed under the user's selected name and profession"),
                                                               dataTableOutput("table"), wellPanel(helpText(a("President source data", 
                                                                                                              href="http://www.worldbank.org/")))), 
                                                      
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
                               selectInput("singerselection", "Choose a Singer:", choices = grammys$first)
                             ),
                             
                             # Mucisians' data
                             mainPanel(
                               tabsetPanel(type = "tabs",tabPanel(strong("Plot"), plotOutput("plot2", 
                                                                                             click = 'plot_click', dblclick = "plot_dblclick",
                                                                                             brush = brushOpts(id = "plot_brush", resetOnNew = TRUE)), 
                                                                  fluidRow(column(width = 5, verbatimTextOutput("click_info")),
                                                                           column(width = 5,verbatimTextOutput("brush_info")))),
                                           
                                           tabPanel(strong("Table"), br(), p("This is a table of all the data 
                                                                             points listed under the user's selected name and profession"),
                                                    dataTableOutput("table"), wellPanel(helpText(a("Baby names source data",
                                                                                                   href="http://www.worldbank.org/")), helpText(a("Grammy data source", 
                                                                                                                                                  href = "http://www.worldbank.org/")), 
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
                               selectInput("authorselection", "Choose a Author:", choices = authors$first)
                             ),
                             
                             # Authors' data
                             mainPanel(
                               tabsetPanel(type = "tabs",
                                           tabPanel(strong("Plot"), plotOutput("plot3", click = 'plot_click', 
                                                                               dblclick = "plot_dblclick", brush = brushOpts(
                                                                                 id = "plot_brush", resetOnNew = TRUE)), fluidRow(column(width = 5, 
                                                                                                                                         verbatimTextOutput("click_info")),
                                                                                                                                  column(width = 5,verbatimTextOutput("brush_info")))),
                                           
                                           tabPanel(strong("Table"), br(), p("This is a table of all the data 
                                                                             points listed under the user's selected name and profession"),
                                                    dataTableOutput("table"), wellPanel(helpText(a("Baby names source data",
                                                                                                   href="http://www.worldbank.org/")), helpText(a("Grammy data source", 
                                                                                                                                                  href = "http://www.worldbank.org/")), 
                                                                                        helpText(a("President source data", href="http://www.worldbank.org/")))), 
                                           
                                           tabPanel(strong("Summary"), br(), p("Shows a summary of the data selected (same as the data points 
                                                                               displayed on the table table tab)"), verbatimTextOutput("summary")))
                                           )
                               )
                           ),
                  
                  # Data summary
                  tabPanel("Summary"
                  ),
                  
                  tabPanel("About", br(),             
                           sidebarLayout(
                             
                             # Authors' user controls
                             sidebarPanel(
                               strong(h3("Team Members")),
                               strong("Andrew Baker"),
                               p("Email: adbaker2@uw.edu"),
                               strong("Daniel Barnes"),
                               p("Email: dbarnes2@uw.edu"),
                               strong("Paul Vaden"),
                               p("Email: pvaden@uw.edu"),
                               strong("John Batts"),
                               p("Email: battsj5@uw.edu")
                             ),
                             
                             
                             # Authors' data
                             mainPanel(p("We are a team of UW students trying to examine the 
                                         influence of famous people on people naming their children 
                                         after them."))
                             )))
                             )
                           )