library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Shiny dashboard for CDC's 500 cities data"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("panel", label = h3("Select Panel"), 
                  choices = c("Map", "Scatterplot"), 
                  selected = "Map"),
      conditionalPanel(
        condition = "input.panel == 'Map'",
        uiOutput("select")),
      conditionalPanel(
        condition = "input.panel == 'Scatterplot'",
        uiOutput("xmeasures"),
        uiOutput("ymeasures")),
      hr(),
      fluidRow(column(3, verbatimTextOutput("value")))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      conditionalPanel(
        condition = "input.panel == 'Map'",
        plotOutput("mapPlot"),
        plotOutput("barPlot")),
      conditionalPanel(
        condition = "input.panel == 'Scatterplot'",
        plotOutput("scatterPlot"))
    )
  )
))