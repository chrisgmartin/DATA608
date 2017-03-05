
library(shiny)
library(dplyr)
library(ggplot2)

#As a researcher, you frequently compare mortality rates from particular causes across different States.
#You need a visualization that will let you see (for 2010 only) the crude mortality rate, across all States,
#from one cause (for example, Neoplasms, which are effectively cancers).
#Create a visualization that allows you to rank States by crude mortality for each cause of death


mortality <- read.csv('https://raw.githubusercontent.com/chrisgmartin/DATA608/master/lecture3/cleaned-cdc-mortality-1999-2010-2.csv', stringsAsFactors = FALSE)
mortality <- mortality %>% 
  filter(Year == 2010)

shinyServer(function(input, output) {
  output$mytable <- renderDataTable({
    data <- mortality
    if (input$vars != 'All'){
      data <- data[data$ICD.Chapter == input$vars,]
      data[order(-data$Crude.Rate),]
    }
    data[order(-data$Crude.Rate),]
  })
})