library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Shiny dashboard for CDC's 500 cities data"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      uiOutput("select"),
      
      hr(),
      fluidRow(column(3, verbatimTextOutput("value")))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("mapPlot"),
      plotOutput("barPlot")
    )
  )
))