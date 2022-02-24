# 演習問題の回答 {#solution .unnumbered}



結果は載せておりません。自分で結果を確認しましょう。

## 基本的な操作 {#solution-rbasic}


```{.r .numberLines}
(myVec1 <- c(3, 9, 10, 8, 3, 5, 8)) # 問1
myVec1[c(2, 4, 6)]                  # 問2
sum(myVec1)                         # 問3
sum(myVec1[(myVec1 %% 2 == 1)])     # 問4
(myVec2 <- c(1, 2, 3, 4, 3, 2, 1))  # 問5
(myVec3 <- myVec1 + myVec2)         # 問6
myVec3[myVec3 < 10]                 # 問7
myVec4 <- 1:100                     # 問8
sum(myVec4^2)                       # 問9
sum((myVec4[myVec4 %% 2 == 1])^2)   # 問10
```

## データの構造 {#solution-datastructure}

### ベクトル


```{.r .numberLines}
# 問1 1から10までの公差1の等差数列を作成し、myVec1と名付けよ。
myVec1 <- 1:10

# 問2 myVec1の長さを求めよ。
length(myVec1)

# 問3 myVec1から偶数のみを抽出せよ
myVec1[myVec1 %% 2 == 0]

# 問4 myVec1をmyVec2という名でコピーし、myVec2の偶数を全て0に置換せよ。
myVec2 <- myVec1
myVec2[myVec2 %% 2 == 0] <- 0

# 問5 myVec1の全要素から1を引し、myVec3と名付けよ。
myVec3 <- myVec1 - 1

# 問6 myVec1の奇数番目の要素には1を、偶数番目の要素には2を足し、myVec4と名付けよ。
myVec4 <- myVec1 + c(1, 2)

# 問7 myVec4からmyVec1を引け。
myVec4 - myVec1
```

### 行列

**問1** 以下のような2つの行列を作成せよ。

$$
\text{myMat1} = \left[
\begin{matrix} 
1 & 2 & 3 \\ 
4 & 5 & 6 
\end{matrix}
\right],
\text{myMat2} = \left[
\begin{matrix} 
1 & 4 & 7 \\ 
2 & 5 & 8 \\
3 & 6 & 9
\end{matrix}
\right]
$$


```{.r .numberLines}
# myMat1: byrow = を指定する場合
myMat1 <- matrix(1:6, nrow = 2, byrow = TRUE)
# myMat1: byrow = を指定しない場合
myMat1 <- matrix(c(1, 4, 2, 5, 3, 6), nrow = 2)

# myMat2: byrow = を指定する場合
myMat2 <- matrix(c(1, 4, 7, 2, 5, 8, 3, 6, 9), nrow = 3, byrow = TRUE) 
# myMat2: byrow = を指定しない場合
myMat2 <- matrix(1:9, nrow = 3)
```

**問2** `myMat1`と`myMat2`の掛け算を行い、`myMat3`と名付けよ。


```{.r .numberLines}
myMat3 <- myMat1 %*% myMat2
```

**問3** 連立方程式の解を求めよ。


```{.r .numberLines}
# 問3-1
myMat4 <- matrix(c(3, -1,  2, 
                   1,  2,  3,
                   2, -1, -1), nrow = 3, byrow = TRUE)
myMat5 <- matrix(c(12, 11, 2), nrow = 3)

# 問3-2
solve(myMat4)

# 問3-3
myMat6 <- solve(myMat4) %*% myMat5

# 問3-4
myMat4 %*% myMat6
```

### データフレーム


```{.r .numberLines}
# 問1. 以下のようなデータフレームを作成し、myDF1と名付けよ。
myDF1 <- data.frame(
    ID    = 1:10,
    Name  = c("Australia", "China", "Iran", "Iraq", "Japan", 
              "Qatar", "Saudi Arabia", "South Korea",  "Syria", "UAE"),
    Rank  = c(42, 76, 33, 70, 28, 55, 67, 40, 79, 71),
    Socre = c(1457, 1323, 1489, 1344, 1500,
              1396, 1351, 1464, 1314, 1334)
)

# 問2. myDF1からName列を抽出せよ。
myDF1$Name

# 問3. myDF1のName列から3番目の要素を抽出せよ。
myDF1$Name[3]

# 問4. myDF1の3行目を抽出せよ。
myDF1[3, ]

# 問5. FIFA_Women.csvをtibble型として読み込み、myTbl1と名付けよ。
myTbl1 <- read_csv("Data/FIFA_Women.csv")

# 問6. myTbl1のRank列を抽出し、それぞれの要素が20より小さいかを判定せよ。
myTbl1$Rank < 20

# 問7. Rankが20より小さい国名を抽出せよ。
myTbl1$Team[myTbl1$Rank < 20]

# 問8. myTbl1からランキングが20位以内の行を抽出せよ。
myTbl1[myTbl1$Rank < 20, ]
```

## Rプログラミングの基礎

**問1**

`while()`を使う場合


```{.r .numberLines}
Trial <- 1
Total <- 0

while (Total != 15) {
  Dice  <- sample(1:6, 3, replace = TRUE)
  Total <- sum(Dice)
  
  print(paste0(Trial, "目のサイコロ投げの結果: ",
               Dice[1], ", ", Dice[2], ", ", Dice[3],
               " (合計: ", Total, ")"))
  
  Trial <- Trial + 1
}
```

`for()`を使う場合


```{.r .numberLines}
for (Trial in 1:10000) {
  Dice  <- sample(1:6, 3, replace = TRUE)
  Total <- sum(Dice)
  
  print(paste0(Trial, "目のサイコロ投げの結果: ",
               Dice[1], ", ", Dice[2], ", ", Dice[3],
               " (合計: ", Total, ")"))
  
  if (Total == 15) {
      break
  }
}
```

**問2**


```{.r .numberLines}
# 問2-1
Cause <- c("喫煙", "飲酒", "食べすぎ", "寝不足", "ストレス")

for (i in Cause) {
  Text <- sprintf("肥満の原因は%sでしょう。", i)
  print(Text)
}
```


```{.r .numberLines}
# 問2-2
Effect <- c("肥満", "ハゲ", "不人気", "金欠")

for (i in Effect) {
  for (j in Cause) {
    Text <- sprintf("%sの原因は%sでしょう。", i, j)
    print(Text)
  }
}
```


```{.r .numberLines}
# 問2-3
Solution <- c("この薬を飲めば", "一日一麺すれば", "Songに100万円振り込めば")

for (i in Effect) {
  for (j in Cause) {
    for (k in Solution) {
      Text <- sprintf("%sの原因は%sですが、%s改善されるでしょう。", i, j, k)
      print(Text)
    }
  }
}
```

## 関数の自作

**問1**


```{.r .numberLines}
Data   <- c(5, 3)

if (Data[1] > Data[2]) {
  Temp    <- Data[1]
  Data[1] <- Data[2]
  Data[2] <- Temp
}

Data
```

**問2**


```{.r .numberLines}
my_sqrt <- function(x, g, e = 0.001) {
    
    if (!is.numeric(x) | x <= 0) {
        stop("xは正の実数でなければなりません。")
    }
    
	gap = Inf
	
	while (gap > e) {
		gap <- abs(x - g^2)
		if (gap > e) {
			g <- (g + x / g) / 2
		} else {
			return(g)
		}
	}
}
```

**問3**


```{.r .numberLines}
Data <- c(5, 2, 4, 1)

for (i in (length(Data)-1):1) {
  for (j in 1:i) {
    if (Data[j] > Data[j+1]) {
      Temp      <- Data[j]
      Data[j]   <- Data[j + 1]
      Data[j+1] <- Temp
    }
  }
}

Data
```

**問4**


```{.r .numberLines}
mySort <- function(x) {
  
  for (i in (length(x)-1):1) {
    for (j in 1:i) {
      if (x[j] > x[j+1]) {
        Temp   <- x[j]
        x[j]   <- x[j + 1]
        x[j+1] <- Temp
      }
    }
  }
  
  x
}

# Bubble Sortの例
Data <- c(28, 92, 29, 84, 29, 27, 19, 23, 32, 30)
mySort(Data)
```

**問5**


```{.r .numberLines}
DQ_Attack2 <- function(attack, defence, hp, enemy) {
  DefaultDamage <- (attack / 2) - (defence / 4)
  DefaultDamage <- ifelse(DefaultDamage < 0, 0, DefaultDamage)
  DamageWidth   <- floor(DefaultDamage / 16) + 1
  
  DamageMin     <- DefaultDamage - DamageWidth
  DamageMin     <- ifelse(DamageMin < 0, 0, DamageMin)
  DamageMax     <- DefaultDamage + DamageWidth
  
  CurrentHP    <- hp
  
  while (CurrentHP > 0) {
    Kaisin <- runif(n = 1, min = 0, max = 1)
    if (Kaisin <= (1/32)) {
        Damage <- runif(n = 1, min = attack * 0.95, max = attack * 1.05)
    } else {
        Damage <- runif(n = 1, min = DamageMin, max = DamageMax)
    }
    
    Damage <- round(Damage, 0)
    
    CurrentHP <- CurrentHP - Damage
    
    if (Kaisin <= (1/32)) {
        print(paste0("かいしんのいちげき!", 
                     enemy, "に", Damage, "のダメージ!!"))
    } else{
        print(paste0(enemy, "に", Damage, "のダメージ!!"))
    }
  }
  
  paste0(enemy, "をやっつけた！")
}
```

**問6**


```{.r .numberLines}
mySample <- function(x, n, seed) {
  
  # 以下の条件が満たされない場合、エラーメッセージを出力し、関数を停止
  stopifnot(
    # length(n) == 1が満たされない場合
    "a length of n must be 1."        = (length(n) == 1),
    # length(seed) == 1が満たされない場合
    "a length of seed must be 1."     = (length(seed) == 1),
    # is.numeric(seed) == TRUEが満たされない場合
    "seed must be integer of double." = is.numeric(seed),
    # ceiling(n) == nが満たされない場合
    "n must be interger."             = (ceiling(n) == n)
  )
  
  # LCG()を用いてn個の乱数を生成し、xの長さだけ倍にする
  index  <- LCG(n = n, seed = seed) * length(x)
  # 得られた疑似乱数を切り上げる
  index  <- ceiling(index)
  # ベクトルxのindex番目要素を抽出し、Resultに格納
  Result <- x[index]
  
  Result
}
```