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
  
  # Nav bar, with Husky logo for extra coolness
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
                 h1(strong("Welcome"),"to the Baby Names Observation Data!"),
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
                 br(),
                 p("We analyzed trends in baby names in relation to:",strong("Presidents, Singers, and Authors."),
                   "Please feel free to browse through the information we have compiled for you. You may select
                   any tab to view it, and inside each data tab, there is an interactive graph. Check out the ",
                   strong("Summary"), "tab for some cool", strong("insights!")),
                 br(),
                 p(strong("Happy Browsing!")),
                 br(),
                 
                 #these are the sources for all our data
                 wellPanel(h1("Data set sources"),
                 a("Baby Names Source", 
                   href="https://raw.githubusercontent.com/hadley/data-baby-names/master/baby-names.csv"),
                 br(),
                 a("Singers Source",
                   href="https://en.wikipedia.org/wiki/Grammy_Award_for_Best_New_Artist"),
                 br(),
                 a("Authors Source",
                   href="https://en.wikipedia.org/wiki/Publishers_Weekly_lists_of_bestselling_novels_in_the_United_States"))
         )
       )
     ),
    
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
                   
                   wellPanel(p("The vertical line is when the president was first elected.  Clicking once on the graph will display information about where you clicked
                               on the left column below. Holding the left click and moving your cursor will 
                               allow you to brush over an area. Information about the data points in the area 
                               encompassed will be displayed on the right column below. doubling clicking with 
                               an area encompassed will zoom in on that section of the plot. doubling clicking
                               again (without an encompassed area) will revert the plot to its normal size.
                               The line above indicates the year that the selected president was inaugurated.")),
                   fluidRow(
                     column(width = 5, verbatimTextOutput("presclick_info")),
                     column(width = 5, verbatimTextOutput("presbrush_info"))
                   )
                 ),
                 
                 # Outputs "president_table"
                 tabPanel(
                   strong("Table"),
                   br(),
                   p("This is a table of all the data
                     points listed under the user's selected name"
                   ),
                   dataTableOutput("president_table")
                 ),
                   
                 
                 # Outputs "president_summary"
                 tabPanel(
                   strong("Summary"),
                   br(),
                   p("Shows a summary of the data selected (same as the data points
                     displayed on the table tab)"),
                 verbatimTextOutput("president_summary")
                 
          )
        )
      )
    )
  ),
  
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
               
               # Outputs "musician_plot"
               tabPanel(
                 strong("Plot"),
                 plotOutput(
                   "singer_plot",
                   click = 'singerplot_click',
                   dblclick = "singerplot_dblclick",
                   
                   #allows the brush to be reset when zooming in
                   brush = brushOpts(id = "singerplot_brush", resetOnNew = TRUE)
                 ),
                 
                 wellPanel(p("The vertical line is when the singer won a grammy.  Clicking once on the graph will display information about where you clicked
                               on the left column below. Holding the left click and moving your cursor will 
                             allow you to brush over an area. Information about the data points in the area 
                             encompassed will be displayed on the right column below. doubling clicking with 
                             an area encompassed will zoom in on that section of the plot. doubling clicking
                             again (without an encompassed area) will revert the plot to its normal size.
                             The line above indicate when the artist selected received a grammy for 'Best 
                             New Artist.'")),
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
                 p("This is a table of all the data
                   points listed under the user's selected name"
                 ),
                 
                 dataTableOutput("singer_table")
               ),
               
               # Outputs "mucisian_summary"
               tabPanel(
                 strong("Summary"),
                 br(),
                 p("Shows a summary of the data selected (same as the data points
                   displayed on the table tab)"),
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
                 wellPanel(p("The vertical line is when the author won the Publisher Weekly best novel award.  Clicking once on the graph will display information about where you clicked
                               on the left column below. Holding the left click and moving your cursor will 
                             allow you to brush over an area. Information about the data points in the area 
                             encompassed will be displayed on the right column below. doubling clicking with 
                             an area encompassed will zoom in on that section of the plot. doubling clicking
                             again (without an encompassed area) will revert the plot to its normal size.
                             The line(s) above indicate the year(s) that the selected author won the award for
                             'Best Selling Novel.'")),
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
                 
                 dataTableOutput("author_table")
               ),
               
               # Outputs "author_summary"
               tabPanel(
                 strong("Summary"),
                 br(),
                 p("Shows a summary of the data selected (same as the data points
                   displayed on the table tab)"),
               verbatimTextOutput("author_summary")
               
               )
        )
      )
    )
  ),
  
  # Data summary
  tabPanel("Summary",
           
           # Introduces how we came to the insights we made
           fluidRow(
             h1("Summary of Collected Data", align = "center"),
             p("Our project's goal is to see what influences American culture the most: academia,
               pop culture, or politics. Our hypothesis is that important cultural icons have a statistically 
               significant impact upon baby naming trends. We tried to choose the \"biggest\" names in each 
               area, but what's \"hot\" or \"big\" can be subjective. With politics, it's easier 
               because presidential elections have the highest voter turnout compared to any other 
               election in government and includes the whole country, so for this project we chose to compare 
               baby names against presidents and when they were elected (it's also noted that presidents
               are most popular within their first 100 days). In pop culture, we tried looking for trends in
               baby names from when new artists won a grammy for \"Best New Artist\". This area is 
               harder to pinpoint when there are many popular music artists that people love. In our graphs, there
               many not be many significant correlations in this area because we simply didn't include the music
               artists that have the correlation with people naming their children after them. There may be a much 
               larger influence of singers on people than the data may suggest because of this. In comparing against 
               authors' influence on people, we chose to select authors who have made the Publishers Weekly lists 
               of bestselling novels in the United States. We chose to use this as a marker for our graph on authors because
               more sales are linked to popularity.")
           ),
           
           # Introduces each table
           fluidRow(
             column(4,
                    h2("Presidents"),
                    br(),
                    h4(strong("Visual Observations (from graphs):")),
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
                    h2("Singers"),
                    br(),
                    h4(strong("Visual Observations (from graphs):")),
                    p("Christopher Cross, Sheena Easton, Mariah Carey, Lauryn Hill, and Norah Jones were
                      the only artists (out of 32) that showed significant growth around the time of receiving
                      the grammy award for 'best new artist'. This shows that popular artists do not have a 
                      consistent impact (positive or negative) on the names that people choose for their children.")
             ),
             column(4,
                    h2("Authors"),
                    br(),
                    h4(strong("Visual Observations (from graphs):")),
                    p("Thomas B. Costain, John Le Carre, Jacqueline Susann, Erich Segal, Stephen King, 
                      and Alexandra Ripley were all experiencing gain in popularity for their first names,
                      however, after receiving their award, their first names started to DECLINE in popularity.
                      All of the other names (103 out of 109) showed no significant impact (i.e. change in direction
                      for name popularity)."))
           ),
           
           # Conclusion
           fluidRow(
             h2("Overall Conclusion", align = "center"),
             p("Over the course of this project, as we performed more calculations and statistical analysis, we began to notice that
               we might have over-estimated how much influence one person can have over all of America's baby names. In 2009, there were
               4.13 million children born in the United States- even if some parents were to name their children based off of important figures
               of the day, this number of parents would be too small compared to the sheer amount of parents who name their children conventionally.
               For presidents, we noticed a large short-term influence, but this quickly faded, showing that it did not change
               long-term cultural trends. Overall, we were unable to prove our hypothesis that important cultural figures impact our baby naming convention.")
             
             ),
           
           # Explanation for Influence Graphs
           fluidRow(
             h2("About the following graphs", align = "center"),
             p("The influence graphs were created for the presidents, singers, and authors data sets. The process for finding
               the influence of each name is as follows: First, we distilled the first name and gender from each person, and used
               this to search our data set of baby name popularity to find what percentage of babies possessed their name 5 years 
               before and after the year we found them to be influential. Next, we found the linear regression of both of these year
               sets, to find how the name was trending before and after their influence. Then, we compared these two numbers, subtracting
               the linear regression before from the linear regression after: isolating the impact the person had. This gives us a percent
               change in babies getting named with the same first name as our influential person, that we attribute to that person's
               influence."),
             strong("In order to make this data more readable, these percent influence numbers were multiplied by 1000. For instance,
                    a person with an influence number of 0.3 is associated with a +0.0003% difference in the popularity of their first
                    name used naming babies.")
           ),
           
           # Statistical observations for each
           fluidRow(
             column(4,
                    hr(),
                    h4(strong("Statistical Observations for presidents:"))
                    ),
             column(4,
                    hr(),
                    h4(strong("Statistical Observations for singers:"))
                    ),
             column(4,
                    hr(),
                    h4(strong("Statistical Observations for authors:"))
                    )
             ),
           
           # Displays each table, in separate columns
           fluidRow(
             column(4,
                    # Outputs "president_influence"
                    dataTableOutput("president_influence")
             ),
             column(4,
                    # Outputs "singer_influence"
                    dataTableOutput("singer_influence")
             ),
             column(4,
                    # Outputs "author_influence"
                    dataTableOutput("author_influence")
             )
        )
      )
    )
  )
)
  

