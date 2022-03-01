library(rvest)
url1   <- "https://www.fifa.com/fifa-world-ranking/ranking-table/women/#all"
url2   <- "https://www.fifa.com/fifa-world-ranking/ranking-table/men/#all"
Soccer1 <- read_html(url1) %>% html_table()
Soccer2 <- read_html(url2) %>% html_table()
Soccer1 <- Soccer1[[1]]
Soccer2 <- Soccer2[[1]]

names(Soccer1) <- names(Soccer2) <- c("Rank", "Team", "Points", "Prev_Points", 
                                      "UpDown", "Positions", "Confederation")

Soccer1 <- Soccer1 %>% select(Rank:Prev_Points, Confederation)
Soccer2 <- Soccer2 %>% select(Rank:Prev_Points, Confederation)
Soccer1 <- separate(Soccer1, Team, c("Team1", "Team2"), sep = "\r")
Soccer2 <- separate(Soccer2, Team, c("Team1", "Team2"), sep = "\r")
Soccer1 <- Soccer1 %>% select(Rank, Team = Team1, Points:Confederation)
Soccer2 <- Soccer2 %>% select(Rank, Team = Team1, Points:Confederation)

Soccer1$Confederation <- str_replace_all(Soccer1$Confederation, "#", "")
Soccer2$Confederation <- str_replace_all(Soccer2$Confederation, "#", "")

Soccer1 <- Soccer1 %>% arrange(Team)
Soccer2 <- Soccer2 %>% arrange(Team)

Soccer1$ID <- 1:nrow(Soccer1)
Soccer2$ID <- 1:nrow(Soccer2)

Soccer1 <- Soccer1 %>% 
    select(ID, Team, Rank, Points, Prev_Points, Confederation)
Soccer2 <- Soccer2 %>% 
    select(ID, Team, Rank, Points, Prev_Points, Confederation)

Soccer1 %>%
    group_by(Confederation) %>%
    summarise(Points = mean(Points)) %>%
    ggplot() +
    geom_bar(aes(x = Confederation, y = Points), sta = "identity")
Soccer2 %>%
    group_by(Confederation) %>%
    summarise(Points = mean(Points)) %>%
    ggplot() +
    geom_bar(aes(x = Confederation, y = Points), sta = "identity")

Soccer1 %>%
    filter(Confederation == "UEFA") %>%
    arrange(Rank) %>%
    select(-Confederation)
Soccer2 %>%
    filter(Confederation == "UEFA") %>%
    arrange(Rank) %>%
    select(-Confederation)

write.csv(Soccer1, "Data/FIFA_Women.csv", row.names = FALSE)
write.csv(Soccer2, "Data/FIFA_Men.csv", row.names = FALSE)
