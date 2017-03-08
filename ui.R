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
          
          # Allows the user to chose a president by first name, stores data in "president_selection"
          # TODO: choose a full name. Should be good because we have no presidents with repeated names?
          selectInput("president_selection", "Choose a President:", choices = presidents$first)
        ),
        
        # President's data
        # TODO: Have to make labels specific to presidents
        mainPanel(
          tabsetPanel(type = "tabs",
                      
            # Outputs "president_plot"
            # TODO: might have to specify specific click/brush variable names? Not sure how this works
            tabPanel(strong("Plot"), plotOutput("president_plot", click = 'plot_click', 
                     dblclick = "plot_dblclick", brush = brushOpts(
                     id = "plot_brush", resetOnNew = TRUE)), fluidRow(column
                     (width = 5, verbatimTextOutput("click_info")),
                     column(width = 5,verbatimTextOutput("brush_info")))),
            
            # Outputs "president_table"
            tabPanel(strong("Table"), br(), p("This is a table of all the data 
                     points listed under the user's selected name and profession"),
                     dataTableOutput("president_table"), wellPanel(helpText(a("President source data", 
                     href="http://www.worldbank.org/")))), 
            
            # Outputs "president_summary"
            tabPanel(strong("Summary"), br(), p("Shows a summary of the data selected (same as the data points 
                                          displayed on the table table tab)"), verbatimTextOutput("president_summary"))
          )
        )
      )
    ),
    
    # Musicians' page
    tabPanel("Mucisians", 
             sidebarLayout(
               
               # Mucisians' user controls
               sidebarPanel(
                 
                 # Allows the user to chose a mucisian by first name, stores data in "mucisian_selection"
                 # TODO: fix choosing, do we have repeated full names?
                 selectInput("mucisian_selection", "Choose a Mucisian:", choices = grammys$first)
               ),
               
               # Mucisian's data
               # TODO: Have to make labels specific to mucisian
               mainPanel(
                 tabsetPanel(type = "tabs",
                             
                             # Outputs "mucisian_plot"
                             # TODO: might have to specify specific click/brush variable names? Not sure how this works
                             tabPanel(strong("Plot"), plotOutput("mucisian_plot", click = 'plot_click', 
                                                                 dblclick = "plot_dblclick", brush = brushOpts(
                                                                   id = "plot_brush", resetOnNew = TRUE)), fluidRow(column
                                                                                                                    (width = 5, verbatimTextOutput("click_info")),
                                                                                                                    column(width = 5,verbatimTextOutput("brush_info")))),
                             
                             # Outputs "mucisian_table"
                             # TODO: Source data
                             tabPanel(strong("Table"), br(), p("This is a table of all the data 
                                                               points listed under the user's selected name and profession"),
                                      dataTableOutput("mucisian_table"), wellPanel(helpText(a("Mucisian source data", 
                                                                                               href="http://www.worldbank.org/")))), 
                             
                             # Outputs "mucisian_summary"
                             tabPanel(strong("Summary"), br(), p("Shows a summary of the data selected (same as the data points 
                                                                 displayed on the table table tab)"), verbatimTextOutput("mucisian_summary"))
                             )
                             )
  )
    ),
    
    # Authors' data
    tabPanel("Authors:", 
             sidebarLayout(
               
               # Authors' user controls
               sidebarPanel(
                 
                 # Allows the user to chose a author by first name, stores data in "author_selection"
                 # TODO: fix choosing
                 selectInput("author_selection", "Choose a Author:", choices = authors$first)
               ),
               
               # Authors's data
               # TODO: Have to make labels specific to authors
               mainPanel(
                 tabsetPanel(type = "tabs",
                             
                             # Outputs "author_plot"
                             # TODO: might have to specify specific click/brush variable names? Not sure how this works
                             tabPanel(strong("Plot"), plotOutput("author_plot", click = 'plot_click', 
                                                                 dblclick = "plot_dblclick", brush = brushOpts(
                                                                   id = "plot_brush", resetOnNew = TRUE)), fluidRow(column
                                                                                                                    (width = 5, verbatimTextOutput("click_info")),
                                                                                                                    column(width = 5,verbatimTextOutput("brush_info")))),
                             
                             # Outputs "author_table"
                             # TODO: Fix source data
                             tabPanel(strong("Table"), br(), p("This is a table of all the data 
                                                               points listed under the user's selected name and profession"),
                                      dataTableOutput("author_table"), wellPanel(helpText(a("Author source data", 
                                                                                               href="http://www.worldbank.org/")))), 
                             
                             # Outputs "author_summary"
                             tabPanel(strong("Summary"), br(), p("Shows a summary of the data selected (same as the data points 
                                                                 displayed on the table table tab)"), verbatimTextOutput("author_summary"))
                             )
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
