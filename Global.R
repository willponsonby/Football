library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(shinydashboard)

full_recovery = read.csv("full_recovery.csv", header = TRUE)

### pie chart for all agencies
pie = full_recovery %>% 
  select(odds_for, new_agency, odds, match_api_id)%>% 
  group_by(match_api_id, new_agency) %>% 
  mutate(min = min(odds)) %>% 
  filter(odds == min) %>% 
  group_by(odds_for) %>% 
  summarise(count = n())

pie_plot = plot_ly(data = pie, labels = c("A" = "Away Win", "D" = "Draw", "H" = "Home Win"), values = pie$count, type = 'pie') %>% 
  layout(title = 'Bookmaker Result Predictions',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

### pie chart for the reality

reality = full_recovery %>% select(home_team_goal, away_team_goal) %>% 
  mutate(result = ifelse(home_team_goal>away_team_goal, "Home Win", 
                         ifelse(away_team_goal>home_team_goal, "Away Win", "Draw"))) %>% 
  group_by(result) %>% 
  mutate(total = n()) %>% 
  select(result, total) %>% 
  unique() 
reality

reality_plot = plot_ly(data = reality, labels = reality$result, values = reality$total, type = 'pie') %>% 
  layout(title = 'Actual results',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))


x_axis_labels_agencies = c("VC Bet", "Pinnacle", "Bet365", "Stan James",
                           "William Hill", "Blue Square", "Gamebookers",
                           "BetWin", "Ladbrokes", "Interwetten")

percentage_by_agency = ggplotly(full_recovery %>% select(home_team_goal, away_team_goal, odds_for, match_api_id, odds, new_agency) %>% 
                                  group_by(match_api_id) %>% 
                                  mutate(min = min(odds)) %>% 
                                  filter(odds == min) %>%
                                  mutate(result = ifelse(home_team_goal>away_team_goal, "H", 
                                                         ifelse(away_team_goal>home_team_goal, "A", "D"))) %>% 
                                  mutate(right_or_wrong = ifelse(result == odds_for, "Correct", "Incorrect")) %>% 
                                  select(right_or_wrong, new_agency) %>%
                                  ungroup(match_api_id) %>% 
                                  group_by(new_agency, right_or_wrong) %>% 
                                  summarise(count = n()) %>% 
                                  ungroup(right_or_wrong) %>%
                                  group_by(new_agency) %>%
                                  mutate(Percentage = (count[1]/(count[1]+count[2]))*100) %>% 
                                  filter(right_or_wrong == "Correct") %>% 
                                  ggplot(aes(x = reorder(new_agency, -Percentage), y = Percentage)) + 
                                  geom_bar(aes(fill = Percentage), stat = "identity") +
                                  ggtitle("Correct predictions by Bookmaker") +
                                  ylab("Correct Prediction %") + 
                                  xlab("Agency") +
                                  scale_x_discrete(labels = x_axis_labels_agencies) +
                                  theme(axis.text.x = element_text(angle=45)))


### Average Odds by agency
average_odd = full_recovery %>%
  group_by(new_agency, season) %>%
  summarise(average_odds = sum(odds)/n())



### Boxplots for agency losses

loss = full_recovery %>% 
  mutate(result = ifelse(home_team_goal>away_team_goal, "H", 
                         ifelse(away_team_goal>home_team_goal, "A", "D"))) %>% 
  filter(result == odds_for) %>% 
  group_by(result) %>% 
  select(result, odds_for, odds) %>% 
  mutate(loss = (odds-1))


losses = ggplotly(ggplot(loss, aes(y = loss, x = result)) + 
                    geom_boxplot(y = loss, aes(fill = result)) +
                    coord_cartesian(ylim = 0:6) +
                    ggtitle("Bookmaker losses on a succesful £1 Bet") +
                    xlab("Result") +
                    ylab("Losses (£)") +
                    scale_x_discrete(labels = c("Away Win", "Draw", "Home Win")))




