

shinyUI(fluidPage(
  dashboardPage(
    skin = 'blue', 
    dashboardHeader(title = "Beat the Bookies",
                    titleWidth = "100%"
  ),
  
  dashboardSidebar(
    width = 350,
    sidebarMenu(
      
      menuItem('Story',
               tabName = 'story', 
               icon=icon("book-open")),
      menuItem('Overall Picture', 
               tabName = 'overall',
               icon=icon("chart-pie")),
      menuItem('Quality of Bookmaker',
               tabName = 'by_agency', 
               icon=icon("check")),
      menuItem('Winnings (Or more likely losses..)',
               tabName = 'winnings', 
               icon=icon("pound-sign")),
      menuItem('Stage of Season',
               tabName = 'stage',
               icon=icon("calendar-alt")),
      menuItem('Average odds per Bookmaker',
               tabName = 'average',
               icon=icon("chart-line")),
      menuItem('About the Author',
               tabName = 'about_me',
               icon=icon("user"))
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
          selectInput("league", label = h3("Average Results by League from 2008/2009 to 2015/2016"),
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
      ),
      tabItem(
        tabName = 'average',
        fluidRow(column(2, 
          checkboxGroupInput("agency", label = h3("Bookmaker"),
                             choices = list("Bet365" = "B365",
                                            "Blue Square" = "BS",
                                            "BetWin" = "BW",
                                            "Gamebookers" = "GB",
                                            "Interwetten" = "IW",
                                            "Ladbrokes" = "LB",
                                            "Stan James" = "SJ",
                                            "VC Bet" = "VC",
                                            "William Hill" = "WH"),
                             selected = "Bet365")),
          
            column(10, plotlyOutput("averageodds"))
          
        )
      ),
      tabItem(
        tabName = 'about_me'
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
