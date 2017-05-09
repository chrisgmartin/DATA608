#load packages
library(rsconnect)

library(ggplot2)
library(GGally)
library(dplyr)


#load the data
CPI <- read.csv2('https://raw.githubusercontent.com/chrisgmartin/DATA608/master/Final/CPI_table.csv', header=TRUE, sep=',', stringsAsFactors=FALSE)
MWR <- read.csv2('https://raw.githubusercontent.com/chrisgmartin/DATA608/master/Final/MWR_tidy.csv', header=TRUE, sep=',', stringsAsFactors=FALSE)
#modify the data for graphing use
CPI$value <- as.numeric(CPI$value)
MWR$rate <- as.numeric(MWR$rate)
#add row for all state average MWR
MWR_test <- MWR %>%
  group_by(year) %>% 
  summarise(rate=mean(rate))
MWR_test$state <- 'All (average)'
MWR_test$X <- 1
MWR <- rbind(MWR_test, MWR)
#subset CPI data
CPI <- subset(CPI, year > 1967)

#---------------------------------------------------------#
#ui
ui <- fluidPage(
  #title
  titlePanel('Minimum Wage and CPI'),
  
  selectInput('choose_state', 'Choose state', choices=c(MWR$state), uiOutput("choose_columns")),
  
  fluidRow(
    column(width=10, class = "well",
           h4("Brush and double-click to zoom"),
           plotOutput("plot1",
                      dblclick = "plot1_dblclick",
                      brush = brushOpts(
                        id = "plot1_brush",
                        resetOnNew = TRUE
                      )
           )
    )
  )
)





#---------------------------------------------------------#
#server
server <- function(input, output) {
  ranges <- reactiveValues(x = NULL, y = NULL)
  
  #subset data
  subsetTest <- reactive({
  if(is.null(input$choose_state)){
      subsetTest <- MWR
      
    } else{
      var <- input$choose_state
      subsetTest <- subset(MWR, MWR$state==var)
    }
  })

  #----------------------------------
  #plot
  output$plot1 <- renderPlot({
    ggplot(subsetTest(), aes(x=year, y=rate)) + geom_point(aes(color=state)) + geom_line(data=CPI, aes(x=year, y=value* .0409836, color=title)) +
      scale_y_continuous("Minium Wage Rate", limits=c(0,15), sec.axis = sec_axis(~ . * 24, name = "CPI Value")) +
      theme(legend.position = "bottom") + coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  
  #zoom event
  observeEvent(input$plot1_dblclick, {
    brush <- input$plot1_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
}
  

shinyApp(ui, server)
