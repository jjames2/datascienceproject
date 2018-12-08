library(shiny)

source("help.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  library(tidyr)
  library(reshape2)
  library(dplyr)
  library(ggplot2)
  
  origCityData <- read.csv("C:\\Work\\DataScience\\500_Cities__Local_Data_for_Better_Health__2018_release.csv")
  data <- subset(origCityData, select = c("UniqueID", "CityName", "CityFIPS", "StateAbbr", "GeoLocation", "Year","Measure","Data_Value","PopulationCount","GeographicLevel", "Short_Question_Text", "Category", "DataValueTypeID"))
  
  mapdata <- data[data$GeographicLevel == "City" & data$DataValueTypeID == "AgeAdjPrv" & data$Category == "Health Outcomes" & !(data$StateAbbr %in% c("AK","HI")),]
  #make a temp data frame of the CityFips, Short_Question_Text, and Data Value
  tmp <- data.frame("CityFIPS" = mapdata$CityFIPS, "Short_Question_Text" = mapdata$Short_Question_Text, "Data_Value" = mapdata$Data_Value)
  
  # convert the temp DF from long format to wide format. 
  tmp2 <- dcast(tmp, CityFIPS ~ Short_Question_Text, value.var = "Data_Value", median)
  
  cityHealthOutcomes <- origCityData[origCityData$Category == "Health Outcomes" & origCityData$StateAbbr != "US" & origCityData$GeographicLevel=="City" & origCityData$DataValueTypeID == "AgeAdjPrv",]
  #perform a left join to return the rest of the needed data, this creates duplicate records. The unique() function remove duplicate records.
  HealthOutcomesFinal <- unique(left_join(tmp2, data.frame("CityFIPS" = cityHealthOutcomes$CityFIPS, "StateDesc" = cityHealthOutcomes$StateDesc, "CityName" = cityHealthOutcomes$CityName, "Category" = cityHealthOutcomes$Category, "DataSource" = cityHealthOutcomes$DataSource, "PopulationCount" = cityHealthOutcomes$PopulationCount, "Geolocation" = cityHealthOutcomes$GeoLocation)))
  
  #cleanup tmp variables
  rm(tmp, tmp2)
  
  mapdata$GeoLocation <- gsub("[ ()]", "", mapdata$GeoLocation)
  mapdata <- mapdata %>% separate(GeoLocation, c("lat", "long"), ",")
  mapdata$lat <- as.numeric(mapdata$lat)
  mapdata$long <- as.numeric(mapdata$long)
  
  tractdata <- dcast(data[data$GeographicLevel=="Census Tract" & data$DataValueTypeID=="CrdPrv",], UniqueID+CityName+StateAbbr+GeoLocation+Year+PopulationCount+GeographicLevel~Short_Question_Text, value.var="Data_Value")
  
  output$select <- renderUI({
    selectInput("disease", label = h3("Select disease to visualize"), 
                choices = unique(mapdata$Short_Question_Text), 
                selected = "Arthritis")
  })
  
  output$xmeasures <- renderUI({
    selectInput("xmeasure", label = h3("Select a measure for the x axis"), 
                choices = unique(origCityData$Short_Question_Text), 
                selected = "Annual Checkup")
  })
  
  output$ymeasures <- renderUI({
    selectInput("ymeasure", label = h3("Select a measure for the y axis"), 
                choices = unique(origCityData$Short_Question_Text), 
                selected = "Arthritis")
  })
  
  output$mapPlot <- renderPlot({
    disease_map(input$disease, mapdata)
  })
  
  output$barPlot <- renderPlot({
    disease_bar_plot(input$disease, HealthOutcomesFinal)
  })
  
  output$scatterPlot <- renderPlot({
    scatter_plot(input$xmeasure, input$ymeasure, tractdata)
  })
  
})