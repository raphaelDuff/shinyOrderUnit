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
  box(width = NULL, htmlOutput(ns("rshinyProjects")))
}

init_server <- function(id) {
  callModule(server, id, id)
}

server <- function(input, output, session, id) {
  ns <- session$ns

  #### Get html page ####
  getProjectsPage<-function() {
    return(includeHTML("www/myProjects.html"))
  }

  #### R Projects Output ####
  if ( id == "myprojects_view") {
    output$rshinyProjects <- renderUI({getProjectsPage()})
  }
}
