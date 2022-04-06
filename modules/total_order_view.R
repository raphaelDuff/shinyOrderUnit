export("ui")
export("init_server")

total_price <- use("R/total_price.R")


import(DT)
import(magrittr)
import(dashboardthemes)
import(modules)
import(ggplot2)
import(scales)
import(shiny)
import(shinydashboard)
import(shiny.fluent)

options = as.list(c("a","b",HTML("&#8364;"),"€"))

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
      solidHeader = F,
      width = 4,
      collapsible = F,
      background = "purple",
      plotOutput(ns("plotOutput"))
    ),
    box(
      title = NULL,
      solidHeader = T,
      width = 4,
      collapsible = F,
      DT::DTOutput(ns("orderOutput"))
    )
  ))
}

init_server <- function(id) {
  callModule(server, id, id)
}

server <- function(input, output, session, id) {
  ns <- session$ns

  #### Load mockup data ####
  load("data/datamockupData.RData")

  #### Reactive Icon value to choose the icon for the currency ####
  moneyIconReac <- reactive({
    return(ifelse(input$currencyInput == "EUR", "euro-sign", "dollar-sign"))
  })

  #### Reactive Currency column name (price_EUR, price_USD) selected ####
  # return: String
  currencyColumn <- reactive({
    return(ifelse(input$currencyInput == "EUR","price_EUR", "price_USD"))
  })

  #### Reactive data ordered by currency input ####
  # return: Data
  ascData <- reactive({
    orderData$product <- factor(orderData$product,
                                levels = unique(orderData$product)[order(orderData[[currencyColumn()]],
                                                                         decreasing = FALSE)])
    descData <- orderData[order(orderData[[currencyColumn()]], decreasing = TRUE), ]
    return(descData)
  })


  #### Reactive barplot ####
  plotReac <- reactive({

    cols <- hue_pal()(length(levels(factor(orderData$product))))

    plot <- ascData() %>%
      ggplot(aes(product,.data[[currencyColumn()]]))+
      geom_col() +
      geom_text(aes(label= paste0(ifelse(input$currencyInput == "EUR",
                                        "\u20ac",
                                        "$"),.data[[currencyColumn()]])),
                vjust=-0.3, size= 5) +
      aes(fill = product) +
      scale_fill_manual(values = rev(cols)) +
      scale_y_continuous(labels = ifelse(input$currencyInput == "EUR",
                                         dollar_format(suffix = "", prefix = "\u20ac"),
                                         dollar_format())) +
      labs(x = NULL,
           y = NULL) +
      theme_minimal() +
      theme(panel.grid = element_blank(), legend.position = "none",
            axis.text.y=element_blank(),
            text = element_text(size = 20))

    return(plot)
  })

  #### Table Output - order table ####
  output$orderOutput <- DT::renderDataTable(ascData(), rownames=F, options = list(pageLength = 5))


  #### Value Box Output - Total Order ####
  output$totalPriceOutput <- renderValueBox({
    valueBox(as.character(total_price$total_price(orderData, input$currencyInput)),
             "Total Price",
             icon = icon(moneyIconReac()),
             color = "green")
  })

  #### Plot Output ###
  output$plotOutput <- renderPlot({plotReac()})
}
