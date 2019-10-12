

shinyServer(function(input, output) {
        
  output$Agencies <- renderPlotly(pie_plot)
  output$Reality <- renderPlotly(reality_plot)
  output$Percentage <- renderPlotly(percentage_by_agency)
  
  r <- reactive({
    
    full_recovery %>% 
      filter(odds_for == input$where) %>% 
      filter(new_agency == input$which) %>% 
      group_by(league_id) %>% 
      mutate(result = ifelse(home_team_goal>away_team_goal, "H", 
                             ifelse(away_team_goal>home_team_goal, "A", "D"))) %>% 
      mutate(winnings = ifelse(odds_for == result, (odds-1), -1)) %>% 
      summarise(Percentage = (sum(winnings)/n())*100)
  })
  
  
  output$Winnings <- renderPlotly({
  
  g = r() %>% ggplot(aes(x = reorder(league_id, -Percentage), y = Percentage)) +
    geom_bar(aes(fill = Percentage), stat = "identity") +
    ggtitle("Winnings by Agency for consistent betting on Home Team/Away Team/Draw") +
    xlab("League") +
    ylab("Winnings %") +
    theme(axis.text.x = element_text(angle=45))
ggplotly(g)
  })

  l <- reactive({
    
    full_recovery %>% 
      filter(league_id == input$league) %>% 
      mutate(result = ifelse(home_team_goal>away_team_goal, "H", 
                             ifelse(away_team_goal>home_team_goal, "A", "D"))) %>%
      group_by(stage, result) %>% 
      select(stage, result) %>% 
      summarise(count = n()) 
  })

  output$Stage <- renderPlotly({
    
    h <- l() %>% 
      ggplot(aes(x = stage, y = count)) +
      geom_bar(aes(fill = result), stat = "identity", position = "fill")
    
    ggplotly(h)
    
   })

  
  
})

  # agency_reactive <- reactive({
  #     switch(input$agency, 
  #            "Bet365" = final_football$Bet365_result,
  #            "Blue Square" = final_football$BlueSquare_result)
  #   })







# 
# 
# my_football_odds3 %>% 
#   group_by(input$agency) %>% 
#   summarise(count = n()) %>% 
#   ggplot(aes(x = input$agency, y = count)) + geom_bar(stat = "identity")


#   
#  agency_reactive <- reactive({
#     switch(input$agency, 
#            "Bet365" = my_football_odds3$Bet365_result,
#            "Blue Square" = my_football_odds3$BlueSquare_result)
#   })
#   
#   output$value <- renderPlotly({  
#   
#   agency_reactive() %>% 
#     group_by(agency_reactive()[1]) %>% 
#     summarise(count = n()) %>% 
#     ggplot(aes(x = agency_reactive(), y = count)) + geom_bar(stat = "identity") 
#     
#   })

















# function(input, output) {
#   
#   observeEvent({
#     the_agencies <- unique(Agencies)
#     updateSelectizeInput(
#       choices = the_agencies,
#       selected = the_agencies[1])
#   })
#   
#   agency_predictions <- reactive({input$the_agencies %>% 
#       mutate(result_prediction = ifelse(input$the_agencies[1]<input$the_agencies[2] & input$the_agencies[1]<input$the_agencies[3], "home win", 
#                                         ifelse(input$the_agencies[3]<input$the_agencies[2] & input$the_agencies[3]<input$the_agencies[1], "away win", "draw"))) %>% 
#       group_by(result_prediction) %>% 
#       mutate(total = n())})
#   
#   output$pie <- renderPlot(agency_predictions %>% 
#                              ggplot(aes(x = 1)) + geom_bar(aes(fill = result_prediction)) + 
#                              coord_polar(theta = "y"))
# }