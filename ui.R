

shinyUI(fluidPage(
  dashboardPage(
    skin = 'blue', 
    dashboardHeader(title = "Beat the Bookies",
                    titleWidth = "100%"
  ),
  
  dashboardSidebar(
    width = 350, 
    sidebarUserPanel(name = 'Think Smart'),
    sidebarMenu(
      
      menuItem('Story',
               tabName = 'story'),
      menuItem('Overall Picture', 
               tabName = 'overall'),
      menuItem('Agencies',
               tabName = 'by_agency'),
      menuItem('Winnings',
               tabName = 'winnings'),
      menuItem('Stage of Season',
               tabName = 'stage')
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(
        tabName = 'story'
      ), 
      tabItem(
        tabName = 'overall',
        fluidRow(column (6, (plotlyOutput('Agencies'))),
                 column(6, plotlyOutput('Reality')))
        ),
      tabItem(
        tabName = 'by_agency',
        fluidRow(plotlyOutput('Percentage'))
      ),
      tabItem(
        tabName = 'winnings',
        fluidRow(
          column(6,
          selectInput("where", label = h3("Home/Away/Draw"), 
                      choices = list("Bet on Home" = "H",
                                     "Bet on Away" = "A",
                                     "Bet on Draw" = "D"),
                      selected = "Bet on Home")),
          column(6,
          selectInput("which", label = h3("Bookmaker"),
                      choices = list("Bet365" = "B365", 
                                     "Blue Square" = "BS",
                                     "BetWin" = "BW",
                                     "Gamebookers" = "GB",
                                     "Interwetten" = "IW",
                                     "Ladbrokes" = "LB", 
                                     "Stan James" = "SJ",
                                     "VC Bet" = "VC",
                                     "William Hill" = "WH"),
                      selected = "Bet365"))),
          fluidRow(
          
          plotlyOutput('Winnings')
          
          )
      ),
      tabItem(
        tabName = 'stage',
        fluidRow(
          selectInput("league", label = h3("League"),
                      choices = list("English Premier League" = "English Premier League",
                                     "Belguim Jupiler League" = "Belgium Jupiler League",
                                     "France Ligue 1" = "France Ligue 1",
                                     "Germany 1. Bundesliga" = "Germany 1. Bundesliga",
                                     "Italy Serie A" = "Italy Serie A", 
                                     "Netherlands Eredivisie" = "Netherlands Eredivisie", 
                                     "Portugal Liga ZON Sagres" = "Portugal Liga ZON Sagres",
                                     "Scotland Premier League" = "Scotland Premier League",
                                     "Spain LIGA BBVA" = "Spain LIGA BBVA"),
                      selected = "English Premier League"),
          plotlyOutput("Stage")
        )
      )
      )
    )
  )
))



# fluidRow(selectizeInput(
#   
#   inputId = 'Agencies',
#   label = 'agency', 
#   choices = list("Bet365" = 1, "Blue Square" = 2)

# ),








# library(shiny)
# fluidPage(
#   titlePanel("Beat the Bookies!"),
#     selectInput("agency", label = h3("Bookmaker"), 
#                 choices = list("Bet365" = 1, "Blue Square" = 2), 
#                 selected = 1),
#   mainPanel(plotOutput("value"))
# )











# library(shiny)
# fluidPage(
#   titlePanel("Beat the Bookies!"),
#     sidebarLayout(
#     sidebarPanel(selectizeInput(inputId = "agency_predictions",
#                                 label = "Bookmakers",
#                                 choices = unique(Agencies))),
#     mainPanel(fluidRow(plotOutput("pie")))
#   )
# )
