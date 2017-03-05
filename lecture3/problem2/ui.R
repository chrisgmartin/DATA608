library(shiny)
library(dplyr)
library(ggplot2)

#Often you are asked whether particular States are improving their mortality rates (per cause)
#faster than, or slower than, the national average.
#Create a visualization that lets your clients see this for themselves for one cause of death at the time.
#Keep in mind that the national average should be weighted by the national population.

unique(mortality$ICD.Chapter)

shinyUI(fluidPage(
  title = "Mortality Rate by State",
  fluidRow(
    column(4,
           selectInput('vars', 'Cause of Death', choices=unique(mortality$ICD.Chapter))
           ),
    column(4,
           selectInput('state', 'Choose a State(s)', choices=unique(mortality$State))
           )
  ),
  fluidRow(
    plotOutput('myplot')
  ),
  fluidRow(
    dataTableOutput('mytable')
  )
))