

shinyServer(function(input, output) {
        
  output$Agencies <- renderPlotly(pie_plot)
  output$Reality <- renderPlotly(reality_plot)
  output$Percentage <- renderPlotly(percentage_by_agency)
  output$Average <- renderPlotly(av_plot)
  
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

  m <- reactive ({

    if (length(input$agency) > 0){
      rbind(
        if("B365" %in% input$agency){
          full_recovery %>%
            # group_by(new_agency, season) %>%
            filter(new_agency == "B365")
        } else NULL,
        if("BS" %in% input$agency){
          full_recovery %>%
            # group_by(new_agency, season) %>%
            filter(new_agency == "BS")
        } else NULL,if("BW" %in% input$agency){
          full_recovery %>%
            # group_by(new_agency, season) %>%
            filter(new_agency == "BW")
        } else NULL,if("GB" %in% input$agency){
          full_recovery %>%
            # group_by(new_agency, season) %>%
            filter(new_agency == "GB")
        } else NULL,if("IW" %in% input$agency){
          full_recovery %>%
            # group_by(new_agency, season) %>%
            filter(new_agency == "IW")
        } else NULL,if("LB" %in% input$agency){
          full_recovery %>%
            # group_by(new_agency, season) %>%
            filter(new_agency == "LB")
        } else NULL,if("VC" %in% input$agency){
          full_recovery %>%
            # group_by(new_agency, season) %>%
            filter(new_agency == "VC")
        } else NULL,if("SJ" %in% input$agency){
          full_recovery %>%
            # group_by(new_agency, season) %>%
            filter(new_agency == "SJ")
        } else NULL,if("WH" %in% input$agency){
          full_recovery %>%
            # group_by(new_agency, season) %>%
            filter(new_agency == "WH")
        } else NULL) %>%
        group_by(new_agency, season) %>% 
        summarise(average_odds = sum(odds)/n()) -> temporary
    } else average_odd -> temporary
    temporary
   })
  
  output$averageodds <- renderPlotly({

    ggplotly(ggplot(m(), aes(x = as.numeric(season),
                                     y = average_odds, color = new_agency)) +
               geom_point() +
               geom_smooth(method = lm, se = F))

    })

  
})








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