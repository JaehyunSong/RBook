library(jsonlite)
library(tidyverse)

# ぐるなびAPI
# 利用制限: APIアクセスキーあたりのAPIコール数1000回/1日まで
# 1. ジャンル取得: ラーメンは RSFST08008
# 2. 都道府県キーの取得 (東京、神奈川、千葉、埼玉、大阪、京都、兵庫、奈良、和歌山)
# 3. 店舗数取得
# 4. 各都道府県から最大1000店舗のデータ取得
#    ID, 店名, 住所, 緯度, 経度, 
#    最寄りの駅の路線, 最寄りの駅, 最寄りの駅からの距離 (徒歩)
#    平均予算
# 5. 各店舗ごとの口コミを取得
#    口コミ数、評価の平均値
# 6. データ結合後
# 7. 変数クリーニング
#    住所から郵便番号のみ抽出
#    Walkを分割

# APIキー
key       <- "166741b1dd16924d939d8410a29d50e2"
gnavi_url <- "https://api.gnavi.co.jp"
rest_url  <- "https://api.gnavi.co.jp/RestSearchAPI/v3"

# ======================================================= #
# =====================ジャンル取得====================== #
# ======================================================= #
## ラーメン: RSFST08008
genre_url <- sprintf("%s/master/CategorySmallSearchAPI/v3/?keyid=%s", 
                     gnavi_url, key)
Genre.df  <- fromJSON(genre_url, flatten = TRUE)

# ======================================================= #
# =================都道府県データの取得================== #
# ======================================================= #
## 東京: PREF13
## 神奈川: PREF14
## 千葉県: PREF12
## 埼玉県: PREF11
## 大阪府: PREF27
## 京都府: PREF26
## 兵庫県: PREF28
## 奈良県: PREF29
## 和歌山県: PREF30
pref_url <- sprintf("%s/master/PrefSearchAPI/v3/?keyid=%s", gnavi_url, key)
Pref.df  <- fromJSON(pref_url, flatten = TRUE)$pref

# ======================================================= #
# ================店舗数取得 (全都道府県)================ #
# ======================================================= #
Pref_Vec  <- Pref.df$pref_code
Count_Vec <- rep(NA, length(Pref_Vec))
for (i in 1:length(Pref_Vec)) {
    count_url <- sprintf("%s/?keyid=%s&pref=%s&category_s=%s",
                         rest_url, key, Pref_Vec[i], "RSFST08008")
    Temp      <- fromJSON(count_url, flatten = TRUE)$total_hit_count
    
    Count_Vec[i] <- Temp
}
Pref.df$Total <- Count_Vec

Pref.df %>%
    select(Pref = pref_name, RamenN = Total) %>%
    write.csv("Scraping/Ramen/RamenN_All.csv", row.names = FALSE)

# ======================================================= #
# ======================店舗数取得======================= #
# ======================================================= #
## 東京都: 3223, 神奈川県: 1254, 千葉県: 1096, 埼玉県: 1106
## 大阪府: 1324, 京都府: 414, 兵庫県: 591, 奈良県: 147, 和歌山県: 140
Pref_Vec  <- paste0("PREF", c(13, 14, 12, 11, 27, 26, 28, 29, 30))
Count_Vec <- rep(NA, length(Pref_Vec))
for (i in 1:length(Pref_Vec)) {
    count_url <- sprintf("%s/?keyid=%s&pref=%s&category_s=%s",
                         rest_url, key, Pref_Vec[i], "RSFST08008")
    Temp      <- fromJSON(count_url, flatten = TRUE)$total_hit_count
    
    Count_Vec[i] <- Temp
}

# ======================================================= #
# =====================店舗情報取得====================== #
# ======================================================= #
# 各都道府県ごとに最大1000件 (ぐるなびオススメ順)
Tokyo_List    <- list()
Kanagawa_List <- list()
Chiba_List    <- list()
Saitama_List  <- list()
Osaka_List    <- list()
Kyoto_List    <- list()
Hyogo_List    <- list()
Nara_List     <- list()
Wakayama_List <- list()

CleanDF <- function(x) {
    Result <- x %>%
        select(ID        = id, 
               Name      = name, 
               Address   = address,
               Latitude  = latitude,
               Longitude = longitude,
               Line      = access.line, 
               Station   = access.station, 
               Walk      = access.walk, 
               Budget    = budget) %>%
        mutate(Latitude  = as.numeric(Latitude),
               Longitude = as.numeric(Longitude),
               Budget    = as.numeric(Budget))
    return(Result)
}

GetRestInfo <- function(id, iter) {
    
    Temp_List <- list()
    
    for (i in 1:iter) {
        url <- sprintf("%s/?keyid=%s&pref=%s&category_s=%s&hit_per_page=100&offset_page=%d",
                       rest_url, key, Pref_Vec[id], "RSFST08008", i)
        Temp <- fromJSON(url, flatten = TRUE)$rest
        Temp <- CleanDF(Temp)
        Temp_List[[i]] <- Temp
    }
    
    return(Temp_List)
}

Tokyo_List    <- GetRestInfo(1, 10) # 東京: 1000件
Kanagawa_List <- GetRestInfo(2, 10) # 神奈川: 1000件
Chiba_List    <- GetRestInfo(3, 10) # 千葉: 1000件
Saitama_List  <- GetRestInfo(4, 10) # 埼玉: 1000件
Osaka_List    <- GetRestInfo(5, 10) # 大阪: 1000件
Kyoto_List    <- GetRestInfo(6, 5)  # 京都: 414件
Hyogo_List    <- GetRestInfo(7, 6)  # 兵庫: 591件
Nara_List     <- GetRestInfo(8, 2)  # 奈良: 147件
Wakayama_List <- GetRestInfo(9, 2)  # 和歌山: 140件

TokyoDF    <- bind_rows(Tokyo_List)
KanagawaDF <- bind_rows(Kanagawa_List)
ChibaDF    <- bind_rows(Chiba_List)
SaitamaDF  <- bind_rows(Saitama_List)
OsakaDF    <- bind_rows(Osaka_List)
KyotoDF    <- bind_rows(Kyoto_List)
HyogoDF    <- bind_rows(Hyogo_List)
NaraDF     <- bind_rows(Nara_List)
WakayamaDF <- bind_rows(Wakayama_List)

TokyoDF$Pref    <- "東京都"
KanagawaDF$Pref <- "神奈川県"
ChibaDF$Pref    <- "千葉県"
SaitamaDF$Pref  <- "埼玉県"
OsakaDF$Pref    <- "大阪府"
KyotoDF$Pref    <- "京都府"
HyogoDF$Pref    <- "兵庫県"
NaraDF$Pref     <- "奈良県"
WakayamaDF$Pref <- "和歌山県"


# ======================================================= #
# ======================口コミ取得======================= #
# ======================================================= #

GetScore <- function(id) {
    Score_url <- sprintf("%s/PhotoSearchAPI/v3/?keyid=%s&shop_id=%s&hit_per_page=50", 
                         gnavi_url, key, id)
    Count <- 0
    Score <- NA
    
    tryCatch({
        Temp       <- fromJSON(Score_url, flatten = TRUE)$response
        Count      <- Temp$total_hit_count
        Temp_Score <- rep(NA, Count)
        
        for (j in 1:Count) {
            Temp2 <- Temp[[j+3]]$photo$total_score
            if (is.null(Temp2)) {
                Temp2 <- NA
            }
            Temp_Score[j] <- as.numeric(Temp2)
        }
        
        Score <- mean(Temp_Score, na.rm = TRUE)
    }, 
    error = function(x){
        # Errorの場合、スルー
    })
    
    return(c("Count" = Count, "Score" = Score))
}

## 東京都内店舗の口コミ数、平均評価の取得
TokyoScoreN <- rep(NA, nrow(TokyoDF))
TokyoScore  <- rep(NA, nrow(TokyoDF))

for (i in 1:nrow(TokyoDF)) {
    Temp <- GetScore(TokyoDF$ID[i])
    TokyoScoreN[i] <- Temp[1]
    TokyoScore[i]  <- Temp[2]
}

TokyoDF$ScoreN <- TokyoScoreN
TokyoDF$Score  <- TokyoScore

write.csv(TokyoDF, "Scraping/Ramen/Ramen_Tokyo.csv", row.names = FALSE)

## 神奈川県内店舗の口コミ数、平均評価の取得 (x)
KanagawaScoreN <- rep(NA, nrow(KanagawaDF))
KanagawaScore  <- rep(NA, nrow(KanagawaDF))

for (i in 1:nrow(KanagawaDF)) {
    Temp <- GetScore(KanagawaDF$ID[i])
    KanagawaScoreN[i] <- Temp[1]
    KanagawaScore[i]  <- Temp[2]
}

KanagawaDF$ScoreN <- KanagawaScoreN
KanagawaDF$Score  <- KanagawaScore

write.csv(KanagawaDF, "Scraping/Ramen/Ramen_Kanagawa.csv", row.names = FALSE)

## 千葉県内店舗の口コミ数、平均評価の取得
ChibaScoreN <- rep(NA, nrow(ChibaDF))
ChibaScore  <- rep(NA, nrow(ChibaDF))

for (i in 1:nrow(ChibaDF)) {
    Temp <- GetScore(ChibaDF$ID[i])
    ChibaScoreN[i] <- Temp[1]
    ChibaScore[i]  <- Temp[2]
}

ChibaDF$ScoreN <- ChibaScoreN
ChibaDF$Score  <- ChibaScore

write.csv(ChibaDF, "Scraping/Ramen/Ramen_Chiba.csv", row.names = FALSE)

## 埼玉県内店舗の口コミ数、平均評価の取得
SaitamaScoreN <- rep(NA, nrow(SaitamaDF))
SaitamaScore  <- rep(NA, nrow(SaitamaDF))

for (i in 1:nrow(SaitamaDF)) {
    Temp <- GetScore(SaitamaDF$ID[i])
    SaitamaScoreN[i] <- Temp[1]
    SaitamaScore[i]  <- Temp[2]
}

SaitamaDF$ScoreN <- SaitamaScoreN
SaitamaDF$Score  <- SaitamaScore

write.csv(SaitamaDF, "Scraping/Ramen/Ramen_Saitama.csv", row.names = FALSE)

## 大阪府内店舗の口コミ数、平均評価の取得
OsakaScoreN <- rep(NA, nrow(OsakaDF))
OsakaScore  <- rep(NA, nrow(OsakaDF))

for (i in 1:nrow(OsakaDF)) {
    Temp <- GetScore(OsakaDF$ID[i])
    OsakaScoreN[i] <- Temp[1]
    OsakaScore[i]  <- Temp[2]
}

OsakaDF$ScoreN <- OsakaScoreN
OsakaDF$Score  <- OsakaScore

write.csv(OsakaDF, "Scraping/Ramen/Ramen_Osaka.csv", row.names = FALSE)

## 京都府内店舗の口コミ数、平均評価の取得
KyotoScoreN <- rep(NA, nrow(KyotoDF))
KyotoScore  <- rep(NA, nrow(KyotoDF))

for (i in 1:nrow(KyotoDF)) {
    Temp <- GetScore(KyotoDF$ID[i])
    KyotoScoreN[i] <- Temp[1]
    KyotoScore[i]  <- Temp[2]
}

KyotoDF$ScoreN <- KyotoScoreN
KyotoDF$Score  <- KyotoScore

write.csv(KyotoDF, "Scraping/Ramen/Ramen_Kyoto.csv", row.names = FALSE)

## 兵庫県内店舗の口コミ数、平均評価の取得
HyogoScoreN <- rep(NA, nrow(HyogoDF))
HyogoScore  <- rep(NA, nrow(HyogoDF))

for (i in 1:nrow(HyogoDF)) {
    Temp <- GetScore(HyogoDF$ID[i])
    HyogoScoreN[i] <- Temp[1]
    HyogoScore[i]  <- Temp[2]
}

HyogoDF$ScoreN <- HyogoScoreN
HyogoDF$Score  <- HyogoScore

write.csv(HyogoDF, "Scraping/Ramen/Ramen_Hyogo.csv", row.names = FALSE)

## 奈良県内店舗の口コミ数、平均評価の取得
NaraScoreN <- rep(NA, nrow(NaraDF))
NaraScore  <- rep(NA, nrow(NaraDF))

for (i in 1:nrow(NaraDF)) {
    Temp <- GetScore(NaraDF$ID[i])
    NaraScoreN[i] <- Temp[1]
    NaraScore[i]  <- Temp[2]
}

NaraDF$ScoreN <- NaraScoreN
NaraDF$Score  <- NaraScore

write.csv(NaraDF, "Scraping/Ramen/Ramen_Nara.csv", row.names = FALSE)

## 和歌山県内店舗の口コミ数、平均評価の取得
WakayamaScoreN <- rep(NA, nrow(WakayamaDF))
WakayamaScore  <- rep(NA, nrow(WakayamaDF))

for (i in 1:nrow(WakayamaDF)) {
    Temp <- GetScore(WakayamaDF$ID[i])
    WakayamaScoreN[i] <- Temp[1]
    WakayamaScore[i]  <- Temp[2]
}

WakayamaDF$ScoreN <- WakayamaScoreN
WakayamaDF$Score  <- WakayamaScore

write.csv(WakayamaDF, "Scraping/Ramen/Ramen_Wakayama.csv", row.names = FALSE)

# データ結合
Ramen.df <- rbind(TokyoDF, KanagawaDF, ChibaDF, SaitamaDF,
                  OsakaDF, KyotoDF, HyogoDF, NaraDF, WakayamaDF)
Ramen.df <- Ramen.df %>%
    select(ID, Name, Pref, Address:Budget, ScoreN, Score)
write.csv(Ramen.df, "Scraping/Ramen/Ramen_Full.csv", row.names = FALSE)

# Walk変数の修正
# Walk / Car / Bus変数に分割
Ramen.df <- Ramen.df %>%
    rename(Dist = Walk) %>%
    mutate(Method = str_sub(Dist, 1, 1),
           Car    = ifelse(Method == "車", parse_number(Dist), NA),
           Bus    = ifelse(Method == "バ", parse_number(Dist), NA),
           Walk   = ifelse(is.na(Car) & is.na(Bus), parse_number(Dist), NA)) %>%
    select(ID:Station, Walk, Bus, Car, Budget:Score)

# 住所から郵便番号を抽出
Ramen.df <- Ramen.df %>%
    mutate(Address = str_sub(Address, 2, 9),
           Address = as.numeric(str_replace(Address, "-", ""))) %>%
    rename(Zipcode = Address)

# データの出力
write.csv(Ramen.df, "Scraping/Ramen/Ramen_Full.csv", row.names = FALSE)
write.csv(Ramen.df, "Data/Ramen.csv", row.names = FALSE)
