# Load all packages
library(DT)
library(dashboardthemes)
library(magrittr)
library(modules)
library(plotly)
library(shiny)
library(shinydashboard)
library(shiny.fluent)

# Modules
total_order_view <- use("modules/total_order_view.R")
unit_test_view <- use("modules/unit_test_view.R")
myprojects_view <- use("modules/myprojects_view.R")
