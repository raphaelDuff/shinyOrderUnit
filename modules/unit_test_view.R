export("ui")
export("init_server")

import(DT)
import(magrittr)
import(dashboardthemes)
import(modules)
import(plotly)
import(shiny)
import(shinydashboard)
import(shiny.fluent)

ui <- function(id) {
  ns <- NS(id)
  box(width = NULL, htmlOutput(ns("unitTest")))
}

init_server <- function(id) {
  callModule(server, id, id)
}

server <- function(input, output, session, id) {
  ns <- session$ns

  #### Get html page ####
  getUnitPage<-function() {
    return(includeHTML("www/r_candidate_raphael_prates.html"))
  }

  #### Unit Tests Output ####
  if ( id == "unit_test_view") {
    output$unitTest <- renderUI({getUnitPage()})
  }
}
