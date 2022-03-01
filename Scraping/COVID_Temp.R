library(tidyverse)

C_df <- read_csv("Scraping/COVID19/time_series_covid19_confirmed_global.csv")

C_df <- C_df %>%
    mutate(`Country/Region` = ifelse(`Country/Region` %in% c("US", "MS Zaandam"), 
                                      "United States",
                                      `Country/Region`),
           `Country/Region` = ifelse(`Country/Region` == "Diamond Princess", 
                                      "Japan",
                                      `Country/Region`)) %>%
    group_by(`Country/Region`) %>%
    summarise(across(.cols = `1/22/20`:`7/10/20`, .fns = sum)) %>%
    rename(Country = `Country/Region`)

C_df <- C_df %>%
    pivot_longer(cols = `1/22/20`:`7/10/20`,
                 names_to = "Date",
                 values_to = "Confirmed")

D_df <- read_csv("Scraping/COVID19/time_series_covid19_deaths_global.csv")

D_df <- D_df %>%
    mutate(`Country/Region` = ifelse(`Country/Region` %in% c("US", "MS Zaandam"), 
                                     "United States",
                                     `Country/Region`),
           `Country/Region` = ifelse(`Country/Region` == "Diamond Princess", 
                                     "Japan",
                                     `Country/Region`)) %>%
    group_by(`Country/Region`) %>%
    summarise(across(.cols = `1/22/20`:`7/10/20`, .fns = sum)) %>%
    rename(Country = `Country/Region`)

D_df <- D_df %>%
    pivot_longer(cols = `1/22/20`:`7/10/20`,
                 names_to = "Date",
                 values_to = "Death")

T_df  <- read_csv("Scraping/COVID19/covid-testing-all-observations.csv")

T_df <- T_df %>%
    select(Country = Entity,
           Date,
           Test_Cum = `Cumulative total`,
           Test_Dat = `Daily change in cumulative total`)

T_df <- T_df %>%
    separate(Country, into = c("Country", "Temp"), sep = " - ") %>%
    select(-Temp)

T_df <- T_df %>%
    mutate(Country = ifelse(Country == "South Korea", "Korea, South",
                            Country))

C_df <- C_df %>% mutate(Date = as.Date(Date, format = c("%m/%d/%y")))
D_df <- D_df %>% mutate(Date = as.Date(Date, format = c("%m/%d/%y")))

Temp_df <- left_join(C_df, D_df, by = c("Country", "Date"))
Temp_df <- left_join(Temp_df, T_df, by = c("Country", "Date"))

Temp_df$ID <- 1:nrow(Temp_df)

Temp_df <- Temp_df %>%
    relocate(ID, .before = Country)

Temp_df <- Temp_df[!duplicated(select(Temp_df, Country, Date)), ]

Temp_df <- Temp_df %>%
    group_by(Country) %>%
    mutate(Confiremd_Day = lag(Confirmed, default = 0),
           Death_Day     = lag(Death, default = 0))

names(Temp)

Temp_df <- Temp_df %>%
    select(ID:Date,
           Confiremd_Day,
           Confirmed_Total = Confirmed,
           Death_Day,
           Death_Total = Death,
           Test_Day = Test_Dat,
           Test_Total = Test_Cum)


write.csv(Temp_df, "Data/COVID19_Worldwide.csv", row.names = FALSE)



