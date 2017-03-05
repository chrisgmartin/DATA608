library(shiny)
library(dplyr)
library(ggplot2)

#As a researcher, you frequently compare mortality rates from particular causes across different States.
#You need a visualization that will let you see (for 2010 only) the crude mortality rate, across all States,
#from one cause (for example, Neoplasms, which are effectively cancers).
#Create a visualization that allows you to rank States by crude mortality for each cause of death
unique(mortality$ICD.Chapter)

shinyUI(fluidPage(
  
  headerPanel("Mortality Rate by State"),
  fluidRow(
   column(4, selectInput('vars', 'Cause of Death', c('All', unique(mortality$ICD.Chapter)))
   )
  ),
   fluidRow(
     dataTableOutput('mytable')
   )
))