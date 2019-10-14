

shinyServer(function(input, output) {
        
  output$Agencies <- renderPlotly(pie_plot)
  output$Reality <- renderPlotly(reality_plot)
  output$Percentage <- renderPlotly(percentage_by_agency)
  output$Average <- renderPlotly(av_plot)
  output$Losses <- renderPlotly(losses)


  url <- a("LinkedIn", 
           href="https://www.linkedin.com/in/william-ponsonby-72196015b/",
           icon("linkedin"))
    output$LItab <- renderUI({
    tagList(url)
  })
 
  
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
    ylab("Winnings/Losses %") +
    xlab("") +
    theme(axis.text.x = element_text(angle=45))
ggplotly(g)
  })

  l <- reactive({
    
    full_recovery %>% 
      filter(league_id == input$league) %>% 
      mutate(result = ifelse(home_team_goal>away_team_goal, "Home Win", 
                             ifelse(away_team_goal>home_team_goal, "Away Win", "Draw"))) %>%
      group_by(stage, result) %>% 
      select(stage, result) %>% 
      summarise(Percentage = n()) 
  })

  output$Stage <- renderPlotly({
    
    h <- l() %>% 
      ggplot(aes(x = stage, y = Percentage)) +
      geom_bar(aes(fill = result), stat = "identity", position = "fill") +
      xlab("Season by Stage")
    
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
        } else NULL,if("PS" %in% input$agency){
          full_recovery %>%
            # group_by(new_agency, season) %>%
            filter(new_agency == "PS")
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
               geom_smooth(method = lm, se = F) +
               ggtitle("Average Odds by Year and Agency") +
               ylab("Average Odds") +
               xlab("") +
               theme(legend.title = element_blank()))

    })

  
})


