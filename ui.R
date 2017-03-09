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
authors <- read.csv("data/authors.csv",
           fileEncoding = "UTF-8-BOM",
           stringsAsFactors = FALSE)
colnames(authors) <- c("year", "first", "full", "gender", "name")

# UI
shinyUI(fluidPage(
  theme = shinytheme("flatly"),
  # Title of page
  titlePanel("Comparing popular baby names vs. famous people"),
  br(),
  
  # Nav bar, with nav bar title
  navbarPage(

    div(img("", src="Huskies.png",width = 40, height = 40)),

    # Home page
    tabPanel("Home",
             sidebarLayout(
               sidebarPanel(
                 strong(h2("Team Members")),
                 strong("Andrew Baker"),
                 p("Email: adbaker2@uw.edu"),
                 strong("Daniel Barnes"),
                 p("Email: dbarnes2@uw.edu"),
                 strong("Paul Vaden"),
                 p("Email: pvaden@uw.edu"),
                 strong("John Batts"),
                 p("Email: battsj5@uw.edu")
               ),
               mainPanel(
                 p(strong("Welcome"),"to the Baby Names Observation Data!"),
                 br(),
                 p("We analyzed trends in baby names in relation to:",strong("Presidents, Singers, and Authors."),
                   "Please feel free to browse through the information we have compiled for you. You may select
                   any tab to view it, and inside each data tab, there is an interactive graph. You will find our personal
                   observations inside of the", strong("Summary"), "tab as well as some information about us in the", 
                   strong("About"), "tab."),
                 br(),
                 h2("Who we are"),
                 p(
                   "We are a team of UW (Go Dawgs!) students trying to examine the
                 influence famous people have on people naming their children
                 after them. The data set that we are working with contains
                 popular baby names from 1880 - 2008 and the names of famous people.
                 It contains each name, sex, the percentage of people who were named
                 that particular name in that year, and the year. The famous people
                 data sets will have the year and the famous person of that category
                 for that year(either an author, musician, or president)."),
                 p(strong("Happy Browsing!")),
                 br(),
                 wellPanel(h1("Data set sources"),
                 a("Baby Names Source", href="https://raw.githubusercontent.com/hadley/data-baby-names/master/baby-names.csv"))
               )
             )),
    # President's page
    tabPanel("Presidents",
             sidebarLayout(
               # Presidents' user controls
               sidebarPanel(
                 # Allows the user to chose a president by first name, stores data in "president_selection"
                 # TODO: choose a full name. Should be good because we have no presidents with repeated names?
                 selectInput("president_selection", "Choose a President:", choices = presidents$full)
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
                     brush = brushOpts(id = "presplot_brush", resetOnNew = TRUE)
                   ),
                   wellPanel(p("Clicking once on the graph will display information about where you clicked
                               on the left column below. Holding the left click and moving your cursor will 
                               allow you to brush over an area. Information about the data points in the area 
                               encompassed will be displayed on the right column below. doubling clicking with 
                               an area encompassed will zoom in on that section of the plot. doubling clicking
                               again (without an encompassed area) will revert the plot to its normal size.")),
                   fluidRow(
                     column(width = 5, verbatimTextOutput("presclick_info")),
                     column(width = 5, verbatimTextOutput("presbrush_info"))
                   )
                 ),
                 
                 
                 # Outputs "president_table"
                 tabPanel(
                   strong("Table"),
                   br(),
                   p(
                     "This is a table of all the data
                     points listed under the user's selected name"
                   ),
                   dataTableOutput("president_table")
                   ),
                   
                 
                 # Outputs "president_summary"
                 tabPanel(
                   strong("Summary"),
                   br(),
                   p(
                     "Shows a summary of the data selected (same as the data points
                     displayed on the table tab)"),
                 verbatimTextOutput("president_summary")
                 
                   )
               ))
  )),
  
  # Musicians' page
  tabPanel("Singers",
           sidebarLayout(
             # Mucisians' user controls
             sidebarPanel(
               # Allows the user to chose a mucisian by first name, stores data in "mucisian_selection"
               # TODO: fix choosing, do we have repeated full names?
               selectInput("singer_selection", "Choose a Musician:", choices = grammys$full)
             ),
             
             # Mucisian's data
             # TODO: Have to make labels specific to mucisian
             mainPanel(tabsetPanel(
               type = "tabs",
               
               # Outputs "mucisian_plot"
               # TODO: might have to specify specific click/brush variable names? Not sure how this works
               tabPanel(
                 strong("Plot"),
                 plotOutput(
                   "singer_plot",
                   click = 'singerplot_click',
                   dblclick = "singerplot_dblclick",
                   brush = brushOpts(id = "singerplot_brush", resetOnNew = TRUE)
                 ),
                 wellPanel(p("Clicking once on the graph will display information about where you clicked
                               on the left column below. Holding the left click and moving your cursor will 
                             allow you to brush over an area. Information about the data points in the area 
                             encompassed will be displayed on the right column below. doubling clicking with 
                             an area encompassed will zoom in on that section of the plot. doubling clicking
                             again (without an encompassed area) will revert the plot to its normal size.")),
                 fluidRow(
                   column(width = 5, verbatimTextOutput("singerclick_info")),
                   column(width = 5, verbatimTextOutput("singerbrush_info"))
                 )
               ),
               
               
               # Outputs "mucisian_table"
               # TODO: Source data
               tabPanel(
                 strong("Table"),
                 br(),
                 p(
                   "This is a table of all the data
                   points listed under the user's selected name"
                 ),
                 dataTableOutput("singer_table"),
                 wellPanel(helpText(
                   a("Musician source data",
                     href =
                       "http://www.worldbank.org/")
                 ))
                 ),
               
               # Outputs "mucisian_summary"
               tabPanel(
                 strong("Summary"),
                 br(),
                 p(
                   "Shows a summary of the data selected (same as the data points
                   displayed on the table table tab"),
               verbatimTextOutput("singer_summary")
               
                 )
             ))
  )),
  
  # Authors' data
  tabPanel("Authors",
           sidebarLayout(
             # Authors' user controls
             sidebarPanel(
               # Allows the user to chose a author by first name, stores data in "author_selection"
               # TODO: fix choosing
               selectInput("author_selection", "Choose an Author:", choices = authors$full)
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
                   brush = brushOpts(id = "authplot_brush", resetOnNew = TRUE)
                 ),
                 wellPanel(p("Clicking once on the graph will display information about where you clicked
                               on the left column below. Holding the left click and moving your cursor will 
                             allow you to brush over an area. Information about the data points in the area 
                             encompassed will be displayed on the right column below. doubling clicking with 
                             an area encompassed will zoom in on that section of the plot. doubling clicking
                             again (without an encompassed area) will revert the plot to its normal size.")),
                 fluidRow(
                   column(width = 5, verbatimTextOutput("authclick_info")),
                   column(width = 5, verbatimTextOutput("authbrush_info"))
                 )
                 
               ),
               
               # Outputs "author_table"
               # TODO: Fix source data
               tabPanel(
                 strong("Table"),
                 br(),
                 p("This is a table of all the data
                   points listed under the user's selected name"
                 ),
                 
                 dataTableOutput("author_table"),
                 wellPanel(helpText(
                   a("Author source data",
                     href =
                       "http://www.worldbank.org/")
                 ))
                 ),
               
               # Outputs "author_summary"
               tabPanel(
                 strong("Summary"),
                 br(),
                 p("Shows a summary of the data selected (same as the data points
                   displayed on the table table tab"),
               verbatimTextOutput("author_summary")
               
                 )
             ))
           )),
  
  # Data summary
  tabPanel("Summary",
           
           # Introduces each table
           fluidRow(
             column(4,
                    h4("Presidents"),
                    p("Presidents data."),
                    br(),
                    p("Lyndon Johnson, Dwight D. Eisenhower, Franklin Roosevelt, Herbert Hoover, 
                      Calvin Coolidge, Warren Harding, Woodrow Wilson, and Theodore Roosevelt were
                      the only presidents that showed statistically significant gain, either on the
                      year of inauguration, or shortly there after. Most presidents (10/18) in our data
                      did not show any drastic change in name popularity around the time of their 
                      election. We are not sure why there are spikes in name popularity for the names
                      of certain presidents and not others, but we are pretty sure it doesn't have
                      to do with their party affiliation, as 3 of the spikes were Democrat, and 5 of the spikes
                      were Republican.")
             ),
             column(4,
                    h4("Singers"),
                    p("Singers data."),
                    br(),
                    p("Christopher Cross, Sheena Easton, Mariah Carey, Lauryn Hill, and Norah Jones were
                      the only artists (out of 32) that showed significant growth around the time of receiving
                      the grammy award for 'best new artist'. This shows that popular artists do not have a 
                      consistent impact (positive or negative) on the names that people choose for their children.")
             ),
             column(4,
                    h4("Authors"),
                    p("Authors data."),
                    br(),
                    p("Thomas B. Costain, John Le Carre, Jacqueline Susann, Erich Segal, Stephen King, 
                      and Alexandra Ripley were all experiencing gain in popularity for their first names,
                      however, after receiving their award, their first names started to DECLINE in popularity.
                      All of the other names (103 out of 109) showed no significant impact (i.e. change in direction
                      for name popularity).") 
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
       )))))
  

