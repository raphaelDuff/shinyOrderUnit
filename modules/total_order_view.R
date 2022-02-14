export("ui")
export("init_server")

total_price <- use("R/total_price.R")


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
  tagList(fluidRow(
    column(1, selectInput(
      ns("currencyInput"), "Currency:", c("EUR", "USD")
    )),
    column(
      width = 5,
      offset = 2,
      valueBoxOutput(ns("totalPriceOutput"))
    )
  ),
  fluidRow(
    box(
      title = "Order",
      solidHeader = T,
      width = 4,
      collapsible = T,
      DT::DTOutput(ns("orderOutput"))
    ),
    box(
      solidHeader = T,
      width = 4,
      collapsible = T,
      plotlyOutput(ns("plotOutput"))
    )
  ))
}

init_server <- function(id) {
  callModule(server, id, id)
}

server <- function(input, output, session, id) {
  ns <- session$ns
  load("data/datamockupData.RData")

  # Reactive value to choose the icon for the currency
  moneyIconReac <- reactive({
    return(ifelse(input$currencyInput == "EUR", "euro-sign", "dollar-sign"))
  })

  plotReac <- reactive({
    currencySelected <- ifelse(input$currencyInput == "EUR","price_EUR", "price_USD")
    orderTest <- orderData %>% select(currencySelected)
    plot <- plot_ly(orderData,
                    x = ~product,
                    y = ~orderData[[currencySelected]],
                    type = "bar",
                    color = ~product)

    plot <- plot %>%
      layout(title = "Total order",
             xaxis = list(title = "Product"),
             yaxis = list(title = paste0("Order Price in ", input$currencyInput)))
    return(plot)
  })

  output$orderOutput <- DT::renderDataTable(orderData, rownames=F, options = list(pageLength = 5))


  #### Total Order Output ####
  output$totalPriceOutput <- renderValueBox({
    valueBox(as.character(total_price$total_price(orderData, input$currencyInput)),
             "Total Price",
             icon = icon(moneyIconReac()),
             color = "green")
  })

  #### Plot Output ###
  output$plotOutput <- renderPlotly({plotReac()})
}
