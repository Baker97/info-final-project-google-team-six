# Load the appropriate libraries
library(ggplot2)
library(shiny)
library(dplyr)
library(tidyr)
library(shinythemes)

# Load in the datasets
baby_names <-
  read.csv("data/baby-names.csv", stringsAsFactors = FALSE)
presidents <-
  read.csv("data/presidents.csv", stringsAsFactors = FALSE)
grammys <- read.csv("data/grammy.csv", stringsAsFactors = FALSE)
authors <-
  read.csv("data/authors.csv",
           fileEncoding = "UTF-8-BOM",
           stringsAsFactors = FALSE)
colnames(authors) <- c("year", "first", "full", "gender", "name")

# UI
shinyUI(fluidPage(
  theme = shinytheme("flatly"),
  # Title of page
  titlePanel("Baby names observation data"),
  br(),
  
  # Nav bar, with nav bar title
  navbarPage(
    "NavBar",
    
    # President's page
    tabPanel("Presidents",
             sidebarLayout(
               # Presidents' user controls
               sidebarPanel(
                 # Allows the user to chose a president by first name, stores data in "president_selection"
                 # TODO: choose a full name. Should be good because we have no presidents with repeated names?
                 selectInput("president_selection", "Choose a President:", choices = presidents$first)
               ),
               
               # President's data
               # TODO: Have to make labels specific to presidents
               mainPanel(tabsetPanel(
                 type = "tabs",
                 
                 # Outputs "president_plot"
                 # TODO: might have to specify specific click/brush variable names? Not sure how this works
                 tabPanel(
                   strong("Plot"),
                   plotOutput(
                     "president_plot",
                     click = 'presplot_click',
                     dblclick = "presplot_dblclick",
                     brush = brushOpts(id = "presplot_brush", resetOnNew = TRUE)),
                     fluidRow(column(width = 5, verbatimTextOutput("presclick_info")),
                     column(width = 5,verbatimTextOutput("presbrush_info")))
                   ),
                 
                 
                 # Outputs "president_table"
                 tabPanel(
                   strong("Table"),
                   br(),
                   p(
                     "This is a table of all the data
                     points listed under the user's selected name and profession"
                   ),
                   dataTableOutput("president_table"),
                   wellPanel(helpText(
                     a("President source data",
                       href ="http://www.worldbank.org/")
                     )
                   )
                 ),
                 
                 # Outputs "president_summary"
                 tabPanel(
                   strong("Summary"),
                   br(),
                   p(
                     "Shows a summary of the data selected (same as the data points
                     displayed on the table table tab)"),
                   verbatimTextOutput("president_summary")
              
            )
          )
        )
      )
    ),
    
    # Musicians' page
    tabPanel("Singers",
             sidebarLayout(
               # Singers' user controls
               sidebarPanel(
                 # Allows the user to chose a singer by first name, stores data in "singer_selection"
                 # TODO: fix choosing, do we have repeated full names?
                 selectInput("singer_selection", "Choose a Singer:", choices = grammys$first)
               ),
               
               # Singer's data
               # TODO: Have to make labels specific to singer

               mainPanel(tabsetPanel(
                 type = "tabs",
                 
                 # Outputs "singer_plot"
                 # TODO: might have to specify specific click/brush variable names? Not sure how this works
                 tabPanel(
                   strong("Plot"),
                   plotOutput(
                     "singer_plot",
                     click = 'singerplot_click',
                     dblclick = "singerplot_dblclick",
                     brush = brushOpts(id = "singerplot_brush", resetOnNew = TRUE)),
                    fluidRow(column(width = 5, verbatimTextOutput("singerclick_info")),
                            column(width = 5,verbatimTextOutput("singerbrush_info")))
                   ),
                 
                 
                 # Outputs "singer_table"
                 # TODO: Source data
                 tabPanel(
                   strong("Table"),
                   br(),
                   p(
                     "This is a table of all the data
                     points listed under the user's selected name and profession"
                   ),
                   dataTableOutput("singer_table"),
                   wellPanel(helpText(
                     a("Singer source data",
                       href =
                         "http://www.worldbank.org/")
                      )
                    )
                  ),
                 
                 # Outputs "singer_summary"
                 tabPanel(
                   strong("Summary"),
                   br(),
                   p("Shows a summary of the data selected (same as the data points
                     displayed on the table table tab)"),
                   verbatimTextOutput("singer_summary")
              
            )
          )
        )
      )
    ),
    
    # Authors' data
    tabPanel("Authors",
             sidebarLayout(
               # Authors' user controls
               sidebarPanel(
                 # Allows the user to chose a author by first name, stores data in "author_selection"
                 # TODO: fix choosing
                 selectInput("author_selection", "Choose a Author:", choices = authors$first)
               ),
               
               # Authors's data
               # TODO: Have to make labels specific to authors
               mainPanel(tabsetPanel(
                 type = "tabs",
                 
                 # Outputs "author_plot"
                 # TODO: might have to specify specific click/brush variable names? Not sure how this works
                 tabPanel(
                   strong("Plot"),
                   plotOutput(
                     "author_plot",
                     click = 'authplot_click',
                     dblclick = "authplot_dblclick",
                     brush = brushOpts(id = "authplot_brush", resetOnNew = TRUE)),
                   fluidRow(column(width = 5, verbatimTextOutput("authclick_info")),
                            column(width = 5,verbatimTextOutput("authbrush_info")))
                   
                 ),
                 
                 # Outputs "author_table"
                 # TODO: Fix source data
                 tabPanel(
                   strong("Table"),
                   br(),
                   p(
                     "This is a table of all the data
                     points listed under the user's selected name and profession"
                   ),
                   
                   dataTableOutput("author_table"),
                   wellPanel(helpText(
                     a("Author source data",
                       href =
                         "http://www.worldbank.org/")
                    )
                   )
                 ),
                 
                 # Outputs "author_summary"
                 tabPanel(
                   strong("Summary"),
                   br(),
                   p(
                     "Shows a summary of the data selected (same as the data points
                     displayed on the table table tab)"),
                   verbatimTextOutput("author_summary")
               
             )
           )
         )
       )
     ),
    
    # Data summary
    tabPanel("Summary",
             
             # Introduces each table
             fluidRow(
               column(4,
                      h4("Presidents"),
                      p("Presidents data.")
                      ),
               column(4,
                      h4("Singers"),
                      p("Singers data.")
                      ),
               column(4,
                      h4("Authors"),
                      p("Authors data.")
               )
               ),
             
             # Displays each table, in separate columns
             fluidRow(
               column(4,
                      hr(),
                      
                      # Outputs "president_influence"
                      dataTableOutput("president_influence")
               ),
               column(4,
                      hr(),
                      
                      # Outputs "singer_influence"
                      dataTableOutput("singer_influence")
               ),
               column(4,
                      hr(),
                      
                      # Outputs "author_influence"
                      dataTableOutput("author_influence")
               )
             )),
    
    # Page about our team
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
               
               
               # Data about our team
               mainPanel(
                 p(
                   "We are a team of UW (Go Dawgs!) students trying to examine the
                   influence of famous people on people naming their children
                   after them. The data set that we are working with contains
                   popular baby names from 1880 - 2008 and the names of famous people.
                   It contains each name, sex, the percentage of people who were named
                   that particular name in that year, and the year. The famous people
                   data sets will have the year and the famous person of that category
                   for that year(either an author, musician, or president)."
               )
             )
           )
         )
       )
    )
  )