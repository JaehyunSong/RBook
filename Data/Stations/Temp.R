library(tidyverse)

df1 <- read_csv("Data/Stations/Station1.csv")
df2 <- read_csv("Data/Stations/Station2.csv")
df3 <- read_csv("Data/Stations/Company.csv")
df4 <- read_csv("Data/Stations/Line.csv")

df2 <- df2 %>% 
    select(Name = S12_001,
           Company = S12_002,
           Line = S12_003, 
           TypeS = S12_004,
           TypeC = S12_005,
           P2011 = S12_009,
           P2012 = S12_013,
           P2013 = S12_017,
           P2014 = S12_021,
           P2015 = S12_025,
           P2016 = S12_029,
           P2017 = S12_033)
df1 %>% filter(station_name == "古島") %>% as.data.frame()

# 路線データと事業者データ
df3 <- df3 %>%
    select(C_ID     = company_cd,
           R_ID     = rr_cd,
           C_Name   = company_name,
           C_Name2  = company_name_h,
           C_Name3  = company_name_r,
           C_URL    = company_url,
           C_Type   = company_type,
           C_Status = e_status)

df4 <- df4 %>%
    select(L_ID     = line_cd,
           C_ID     = company_cd,
           L_Name   = line_name,
           L_Name2  = line_name_h,
           L_Color  = line_color_c,
           L_Color2 = line_color_t,
           L_Status = e_status)

LC.df <- left_join(df4, df3, by = "C_ID")

# 駅データと(路線+事業者)データ
df1 <- df1 %>%
    select(S_ID      = station_cd,
           S_Name    = station_name,
           L_ID      = line_cd,
           Pref      = pref_cd,
           Zipcode   = post,
           Address   = address,
           Longitude = lon,
           Latitude  = lat,
           Open      = open_ymd,
           Close     = close_ymd,
           S_Status  = e_status)

All.df <- left_join(df1, LC.df, by = "L_ID")

write.csv(All.df, "AllData.csv", row.names = FALSE)
write.csv(df2, "Passenger.csv", row.names = FALSE)
All.df %>% 
    filter(duplicated(S_Name)) %>% 
    arrange(S_Name) %>%
    write.csv("Data/Stations/Duplicated.csv", row.names = FALSE)
