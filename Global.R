library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(shinydashboard)

# write.csv(football4, "final_football.csv", row.names = FALSE)

final_football = read.csv("final_football.csv", header = TRUE)

full_recovery = read.csv("full_recovery.csv", header = TRUE)


### pie chart for all agencies
pie = full_recovery %>% 
  select(odds_for, new_agency, odds, match_api_id)%>% 
  group_by(match_api_id, new_agency) %>% 
  mutate(min = min(odds)) %>% 
  filter(odds == min) %>% 
  group_by(odds_for) %>% 
  summarise(count = n())

pie_plot = plot_ly(data = pie, labels = pie$odds_for, values = pie$count, type = 'pie') %>% 
  layout(title = 'Result prediction for all bookmakers',
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
                                  ylab("Percentage Correct") + 
                                  xlab("Agency"))


### Consistent betting

# consistent = ggplotly(final_football %>% 
#                         filter(odds_for == "A") %>% 
#                         group_by(league_id) %>% 
#                         mutate(result = ifelse(home_team_goal>away_team_goal, "H", 
#                                                ifelse(away_team_goal>home_team_goal, "A", "D"))) %>% 
#                         mutate(winnings = ifelse(odds_for == result, (odds-1), -1)) %>% 
#                         summarise(Percentage = (sum(winnings)/n())*100) %>% 
#                         ggplot(aes(x = reorder(league_id, -Percentage), y = Percentage)) +
#                         geom_bar(aes(fill = Percentage), stat = "identity") +
#                         ggtitle("Winnings by Agency for consistent betting on Home Win/Draw/Loss") +
#                         xlab("League") +
#                         ylab("Winnings %") +
#                         theme(axis.text.x = element_text(angle=45)))









# Bet365 = cut_frame %>% 
#   select(B365H, B365D, B365A) %>% 
#   mutate(., result = ifelse(Bet365[1]<Bet365[2] & Bet365[1]<Bet365[3], "home", 
#                             ifelse(Bet365[3]<Bet365[2] & Bet365[3]<Bet365[1], "away", "draw")))


# my_football_odds$Bet365 = Bet365
# 
# Blue_Square = my_football_odds %>% 
#   select(BSH, BSD, BSA) %>% 
#   filter(complete.cases(BSH, BSD, BSA)) %>% 
#   mutate(., result = ifelse(Blue_Square[1]<Blue_Square[2] & Blue_Square[1]<Blue_Square[3], "home", 
#                             ifelse(Blue_Square[3]<Blue_Square[2] & Blue_Square[3]<Blue_Square[1], "away", "draw")))

# BetWin = my_football_odds %>% 
#   select(BWH, BWD, BWA) %>% 
#   filter(complete.cases(BWH, BWD, BWA))
# 
# Gamebookers = my_football_odds %>% 
#   select(GBH, GBD, GBA) %>% 
#   filter(complete.cases(GBH, GBD, GBA))
# 
# Interwetten = my_football_odds %>% 
#   select(IWH, IWD, IWA) %>% 
#   filter(complete.cases(IWH, IWD, IWA))
# 
# Ladbrokes = my_football_odds %>% 
#   select(LBH, LBD, LBA) %>% 
#   filter(complete.cases(LBH, LBD, LBA))
# 
# Pinnacle = my_football_odds %>% 
#   select(PSH, PSD, PSA) %>% 
#   filter(complete.cases(PSH, PSD, PSA))
# 
# Stan_James = my_football_odds %>% 
#   select(SJH, SJD, SJA) %>% 
#   filter(complete.cases(SJH, SJD, SJA))
# 
# VC_Bet = my_football_odds %>% 
#   select(VCH, VCD, VCA) %>% 
#   filter(complete.cases(VCH, VCD, VCA))
# 
# William_Hill = my_football_odds %>% 
#   select(WHH, WHD, WHA) %>% 
#   filter(complete.cases(WHH, WHD, WHA))
# 
# 
