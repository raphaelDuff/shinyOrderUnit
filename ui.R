dashboardPage(
  dashboardHeader(title = "Order Appsi"),
  #### SideBar ####
  dashboardSidebar(
    hr(),
    Persona(
      imageInitials = "RP",
      text = "Raphael Prates",
      secondaryText = "R Developer Candidate",
      presence = 2
    ),
    hr(),
    sidebarMenu(id="tabs",
                menuItem("Total Order", tabName = "orderTab", icon=icon("chart-bar"), selected = TRUE),
                menuItem("Unit tests", tabName = "unitTab", icon=icon("atom")),
                menuItem("My Projects", tabName = "projectsTab", icon=icon("r-project"))
    )
  ),
  #### Body ####
  dashboardBody(shinyDashboardThemes(theme = "grey_light"),
                tabItems(
                  tabItem(
                    title = "Total Order",
                    tabName = "orderTab",
                    total_order_view$ui("total_order_view")),
                  tabItem(tabName = "unitTab",
                          unit_test_view$ui("unit_test_view")),
                  tabItem(tabName = "projectsTab",
                          myprojects_view$ui("myprojects_view"))
                ))
)
