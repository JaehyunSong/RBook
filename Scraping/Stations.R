library(tidyverse)
library(RANN)

Pass.df <- read_csv("Data/Stations/Passenger.csv")
Stat.df <- read_csv("Data/Stations/AllData.csv")

Geo1.df <- Pass.df %>%
    select(Latitude, Longitude)

Geo2.df <- Stat.df %>%
    select(Latitude, Longitude)

nn.test <- nn2(Geo1.df, Geo2.df)

Pass.df$NN_Index <- 1:nrow(Pass.df)
Stat.df$NN_Index <- as.vector(nn.test[["nn.idx"]])

Full.df <- left_join(Stat.df, Pass.df, by = "NN_Index")

Full.df <- Full.df %>%
    select(-Latitude.y, -Longitude.y) %>%
    rename(Longitude = Longitude.x, 
           Latitude = Latitude.x) %>% 
    mutate(Diff = ifelse(S_Name == Name, "O", ""))

write.csv(Full.df, "Data/Stations/FullData.csv", row.names = FALSE)

Full.df %>% 
    filter(Diff == "O") %>%
    select(ID             = S_ID,
           Station_Name   = S_Name,
           Pref:Latitude, 
           Station_Status = S_Status, 
           Line_ID        = L_ID,
           Line_Name      = L_Name,
           Line_Status    = L_Status,
           Company_ID     = C_ID,
           Company_Name   = C_Name,
           Company_Type1  = C_Type,
           Company_Type2  = TypeC,
           Company_Status = C_Status,
           P2011:P2017) %>%
    write.csv("Data/Stations.csv", row.names = FALSE)

df <- read_csv("Data/Stations.csv")



df2 <- df[!duplicated(select(df, Station_Name, P2017)), ]

df <- df %>%
    mutate(Company_Type2 = recode(Company_Type2,
                                  `1` = 1, `2` = 1, `3` = 2, `4` = 3, `5` = 4)) 

write.csv(df, "Data/Stations.csv", row.names = FALSE)
