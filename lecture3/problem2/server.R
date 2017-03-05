
library(shiny)
library(dplyr)
library(ggplot2)

#Often you are asked whether particular States are improving their 
#mortality rates (per cause) faster than, or slower than, the national average.
#Create a visualization that lets your clients see this
#for themselves for one cause of death at the time.
#Keep in mind that the national average should be weighted by the national population.


mortality <- read.csv('https://raw.githubusercontent.com/chrisgmartin/DATA608/master/lecture3/cleaned-cdc-mortality-1999-2010-2.csv', stringsAsFactors = FALSE)

shinyServer(function(input, output) {
  output$mytable <- renderDataTable({
    data <- mortality %>% 
      filter(State == input$state, ICD.Chapter==input$vars)
    data[order(-data$Year),]
    },
    options = list(lengthMenu=c(5, 10, 15, 20), pageLength=5)
    )
  
    output$myplot <- renderPlot({
    data <- mortality %>% 
      filter(State == input$state, ICD.Chapter==input$vars)
    dataNat <- mortality %>% 
      filter(ICD.Chapter==input$vars) %>% 
      group_by(Year) %>% 
      summarise(rate=(sum(as.numeric(Deaths))/sum(as.numeric(Population))*100000))
    ggplot(data, aes(x=Year, y=Crude.Rate, color='red')) + geom_line() + geom_line(aes(x=dataNat$Year, y=dataNat$rate, color='blue')) + scale_color_manual(name='color', values=c('red'='red', 'blue'='blue'), labels=c('National Average', 'State'))
  })
})
