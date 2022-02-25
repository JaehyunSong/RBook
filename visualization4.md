---
always_allow_html: true
---
# 可視化[発展] {#visualization4}



## 概要 {#visual4-intro}

　第\@ref(visualization1)章では{ggplot2}の仕組みについて、第\@ref(visualization2)章ではよく使われる5種類のプロット（棒グラフ、散布図、折れ線グラフ、箱ひげ図、ヒストグラム）の作り方を、第\@ref(visualization3)章ではスケール、座標系などの操作を通じたグラフの見た目調整について解説しました。本章では第\@ref(visualization2)章の延長線上に位置づけることができ、紹介しきれなかった様々なグラフの作り方について簡単に解説します。本章で紹介するグラフは以下の通りです。

* [バイオリンプロット](#visual4-violin)
* [ラグプロット](#visual4-rug)
* [リッジプロット](#visual4-ridge)
* [エラーバー付き散布図](#visual4-pointrange)
* [ロリーポップチャート](#visual4-lollipop)
* [平滑化ライン](#visual4-smooth)
* [ヒートマップ](#visual4-heatmap)
* [等高線図](#visual4-contour)
* [地図](#visual4-map)
* [非巡回有向グラフ](#visual4-dag)
* [バンプチャート](#visual4-bump)
* [沖積図](#visual4-alluvial)
* [ツリーマップ](#visual4-tree)
* [モザイクプロット](#visual4-mosaic)

---


```{.r .numberLines}
pacman::p_load(tidyverse)

Country_df <- read_csv("Data/Countries.csv")
COVID19_df <- read_csv("Data/COVID19_Worldwide.csv", guess_max = 10000)
```

---

## バイオリンプロット {#visual4-violin}

　バイオリンプロットは連続変数の分布を可視化する際に使用するプロットの一つです。第\@ref(visualization1)章で紹介しましたヒストグラムや箱ひげ図と目的は同じです。それではバイオリンプロットとは何かについて例を見ながら解説します。

　以下の図は対数化した一人当たり購買力平価GDP（`PPP_per_capita`）のヒストグラムです。


\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-violin1-1} \end{center}

　このヒストグラムをなめらかにすると以下のような図になります。


\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-violin2-1} \end{center}

　この密度曲線を上下対称にすると以下のような図となり、これがバイオリンプロットです。ヒストグラムのようにデータの分布が分かりやすくなります。


\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-violin3-1} \end{center}

　しかし、この図の場合、ヒストグラムと同様、中央値や四分位数などの情報が含まれておりません。これらの箱ひげ図を使用した方が良いでしょう。バイオリンプロットの良い点はバイオリンの中に箱ひげ図を入れ、ヒストグラムと箱ひげ図両方の長所を取ることができる点です。たとえば、バイオリンプロットを90度回転させ、中にバイオリン図を入れると以下のようになります。


\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-violin4-1} \end{center}

　それでは実際にバイオリンプロットを作ってみましょう。使い方は箱ひげ図（`geom_boxplot()`）と同じです。たとえば、横軸は大陸（`Continent`）に、縦軸は対数化した一人当たり購買力平価GDP（`PPP_per_capita`）にしたバイオリンプロットを作るには作るには`geom_violin()`幾何オブジェクトの中にマッピングするだけです。大陸ごとに色分けしたい場合は`fill`引数に`Continent`をマッピングします。


```{.r .numberLines}
Country_df %>%
    ggplot() +
    geom_violin(aes(x = Continent, y = PPP_per_capita, fill = Continent)) +
    labs(x = "大陸", y = "一人当たり購買力平価GDP (対数)") +
    scale_y_continuous(breaks = c(0, 1000, 10000, 100000),
                       labels = c(0, 1000, 10000, 100000),
                       trans  = "log10") + # y軸を対数化
    guides(fill = "none") + # fillのマッピング情報の凡例を隠す
    theme_minimal(base_family = "HiraKakuProN-W3",
                  base_size   = 16)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-violin5-1} \end{center}

　ここに箱ひげ図も載せたい場合は、`geom_violin()`オブジェクトの後に`geom_boxplot()`オブジェクトを入れるだけで十分です。


```{.r .numberLines}
Country_df %>%
    ggplot() +
    geom_violin(aes(x = Continent, y = PPP_per_capita, fill = Continent)) +
    geom_boxplot(aes(x = Continent, y = PPP_per_capita),
                 width = 0.2) +
    labs(x = "大陸", y = "一人当たり購買力平価GDP (対数)") +
    scale_y_continuous(breaks = c(0, 1000, 10000, 100000),
                       labels = c(0, 1000, 10000, 100000),
                       trans = "log10") +
    guides(fill = "none") +
    theme_minimal(base_family = "HiraKakuProN-W3",
                  base_size   = 16)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-violin6-1} \end{center}

　箱ひげ図は四分位範囲、四分位数、最小値、最大値などの情報を素早く読み取れますが、どの値当たりが分厚いかなどの情報が欠けています。これをバイオリンプロットで補うことで、よりデータの分布を的確に把握することができます。

---

## ラグプロット {#visual4-rug}

　ラグプロット（rug plot）は変数の分布を示す点ではヒストグラム、箱ひげ図、バイオリンプロットと同じ目的を持ちますが、大きな違いとしてはラグプロット単体で使われるケースがない（または、非常に稀）という点です。ラグプロットは上述しましたヒストグラムや箱ひげ図、または散布図などと組み合わせて使うのが一般的です。

　以下は`Country_df`の`PPP_per_capita`（常用対数変換）のヒストグラムです。


```{.r .numberLines}
Country_df %>%
    drop_na(PPP_per_capita) %>%
    ggplot() +
    geom_histogram(aes(x = PPP_per_capita), bins = 15, color = "white") +
    labs(x = "PPP per capita (USD; log scale)", 
         y = "Number of Countries") +
    scale_x_log10() +
    guides(fill = "none") +
    theme_minimal(base_size = 12)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-rug1-1} \end{center}

　一変数の分布を確認する場合、ヒストグラムは情報量の損失が少ない方です。それでも値一つ一つの情報は失われますね。例えば、上記のヒストグラムで左端の度数は1です。左端の棒の区間はおおよそ500から780であり、一人当たりPPPがこの区間に属する国は1カ国ということです。ちなみに、その国はブルンジ共和国ですが、ブルンジ共和国の具体的な一人当たりPPPはヒストグラムから分かりません。情報量をより豊富に持たせるためには区間を細かく刻むことも出来ますが、逆に分布の全体像が読みにくくなります。

　ここで登場するのがラグプロットです。これは座標平面の端を使ってデータを一時現状に並べたものです。多くの場合、点ではなく、垂直線（｜）を使います。ラグプロットの幾何オブジェクトは{ggplot2}でデフォルトで提供されており、`geom_rug()`を使います。マッピングは`x`または`y`に対して行いますが、座標平面の下段にラグプロットを出力する場合は`x`に変数（ここでは`PPP_per_capita`）をマッピングします。


```{.r .numberLines}
Country_df %>%
    drop_na(PPP_per_capita) %>%
    ggplot() +
    geom_histogram(aes(x = PPP_per_capita), bins = 15, color = "white") +
    geom_rug(aes(x = PPP_per_capita))  +
    labs(x = "PPP per capita (USD; log scale)", 
         y = "Number of Countries") +
    scale_x_log10() +
    theme_minimal(base_size = 12)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-rug2-1} \end{center}

ラグプロットを使うと本来のヒストグラムの外見にほぼ影響を与えず、更に情報を付け加えることが可能です。点（｜）の密度でデータの分布を確認することもできますが、その密度の相対的な比較に関してはヒストグラムの方が良いでしょう。

ラグプロットは散布図に使うことも可能です。散布図は一つ一つの点が具体的な値がマッピングされるため、情報量の損失はほぼないでしょう。それでも散布図にラグプロットを加える意味はあります。まず、`Country_df`のフリーダムハウス指数（`FH_Total`）と一人当たりPPP（`PPP_per_capita`）の散布図を作ってみましょう。


```{.r .numberLines}
Country_df %>%
    drop_na(FH_Total, PPP_per_capita) %>%
    ggplot() +
    geom_point(aes(x = FH_Total, y = PPP_per_capita)) +
    labs(x = "Freedom House Score", y = "PPP per capita (USD)") +
    scale_y_continuous(breaks = seq(0, 120000, by = 10000),
                       labels = seq(0, 120000, by = 10000)) +
    guides(fill = "none") +
    theme_minimal(base_size = 12)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-rug3-1} \end{center}

散布図の目的は二変量間の**関係**を確認することであって、それぞれの変数の分布を確認することではありません。もし、`FH_Total`と`PPP_per_capita`の分布が確認したいなら、それぞれのヒストグラムや箱ひげ図を作成した方が良いでしょう。しかし、ラグプロットを使えば、点（｜）の密度で大まかな分布は確認出来ますし、図の見た目にもほぼ影響を与えません。

横軸と縦軸両方のラグプロットは、`geom_rug()`に`x`と`y`両方マッピングするだけです。


```{.r .numberLines}
Country_df %>%
    drop_na(FH_Total, PPP_per_capita) %>%
    ggplot() +
    geom_point(aes(x = FH_Total, y = PPP_per_capita)) +
    geom_rug(aes(x = FH_Total, y = PPP_per_capita)) +
    labs(x = "Freedom House Score", y = "PPP per capita (USD)") +
    scale_y_continuous(breaks = seq(0, 120000, by = 10000),
                       labels = seq(0, 120000, by = 10000)) +
    guides(fill = "none") +
    theme_minimal(base_size = 12)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-rug4-1} \end{center}

　これで`FH_Total`はほぼ均等に分布していて、`PPP_per_capita`は2万ドル以下に多く密集していることが確認できます。

　{ggExtra}の`ggMarginal()`を使えば、ラグプロットでなく、箱ひげ図やヒストグラムを付けることも可能です。{ggplot2}で作図した図をオブジェクトとして格納し、`ggMarginal()`の第一引数として指定します。第一引数のみだと密度のだけ出力されるため、箱ひげ図を付けるためには`type = "boxplot"`を指定します（既定値は`"density"`）。ヒストグラムを出力する場合は`"histogram"`と指定します。


```{.r .numberLines}
Scatter_Fig1 <- Country_df %>%
    drop_na(FH_Total, PPP_per_capita) %>%
    ggplot() +
    geom_point(aes(x = FH_Total, y = PPP_per_capita)) +
    labs(x = "Freedom House Score", y = "PPP per capita (USD)") +
    scale_y_continuous(breaks = seq(0, 120000, by = 10000),
                       labels = seq(0, 120000, by = 10000)) +
    guides(fill = "none") +
    theme_minimal(base_size = 12)

ggExtra::ggMarginal(Scatter_Fig1, type = "boxplot")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-rug5-1} \end{center}

---

## リッジプロット {#visual4-ridge}

　リッジプロット（ridge plot）はある変数の分布をグループごとに出力する図です。大陸ごとの人間開発指数の分布を示したり、時系列データなら分布の変化を示す時にも使えます。ここでは大陸ごとの人間開発指数の分布をリッジプロットで示してみましょう。

　リッジプロットを作成する前に、`geom_density()`幾何オブジェクトを用い、変数の密度曲線（density curve）を作ってみます。マッピングは`x`に対し、分布を出力する変数名を指定します。また、密度曲線内部に色塗り（`fill`）をし、曲線を計算する際のバンド幅（`bw`）は0.054にします。`bw`が大きいほど、なめらかな曲線になります。


```{.r .numberLines}
Country_df %>%
  ggplot() +
  geom_density(aes(x = HDI_2018), fill = "gray70", bw = 0.054) +
  labs(x = "2018年人間開発指数", y = "大陸") +
  theme_minimal(base_family = "HiraKakuProN-W3",
                base_size   = 12)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-ridge1-1} \end{center}

　これを大陸ごとに出力する場合、ファセット分割を行います。今回は大陸ごとに1列（`ncol = 1`）でファセットを分割します。


```{.r .numberLines}
Country_df %>%
  ggplot() +
  geom_density(aes(x = HDI_2018), fill = "gray70", bw = 0.054) +
  labs(x = "2018年人間開発指数", y = "大陸") +
  facet_wrap(~Continent, ncol = 1) +
  theme_minimal(base_family = "HiraKakuProN-W3",
                base_size   = 12)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-ridge2-1} \end{center}

　それでは上のグラフをリッジプロットとして作図してみましょう。今回は{ggridges}パッケージを使います。


```{.r .numberLines}
pacman::p_load(ggridges)
```

　使用する幾何オブジェクトは`geom_density_ridges()`です。似たような幾何オブジェクトとして`geom_ridgeline()`がありますが、こちらは予め密度曲線の高さを計算しておく必要があります。一方、`geom_density_ridges()`は変数だけ指定すれば密度を自動的に計算してくれます。マッピングは`x`と`y`に対し、それぞれ分布を出力する変数名とグループ変数名を指定します。また、密度曲線が重なるケースもあるため、透明度（`alpha`）も0.5にしておきましょう。ここでは別途指定しませんが、ハンド幅も指定可能であり、`aes()`の外側に`bandwidth`を指定するだけです。


```{.r .numberLines}
Country_df %>%
  ggplot() +
  geom_density_ridges(aes(x = HDI_2018, y = Continent), 
                      alpha = 0.5) +
  labs(x = "2018年人間開発指数", y = "大陸") +
  theme_minimal(base_family = "HiraKakuProN-W3",
                base_size   = 12)
```

```
## Picking joint bandwidth of 0.054
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-ridge4-1} \end{center}

先ほど作図した図と非常に似た図が出来上がりました。ファセット分割に比べ、空間を最大限に活用していることが分かります。ファセットラベルがなく、グループ名が縦軸上に位置するからです。また、リッジプロットの特徴は密度曲線がオーバラップする点ですが、以下のように`scale = 1`を指定すると、オーバラップなしで作成することも可能です。もし、`scale = 3`にすると最大2つの密度曲線が重なることになります。たとえば最下段のアフリカはアメリカの行と若干オーバラップしていますが、`scale = 3`の場合、アジアの行までオーバーラップされうることになります。


```{.r .numberLines}
Country_df %>%
  ggplot() +
  geom_density_ridges(aes(x = HDI_2018, y = Continent), 
                      scale = 1, alpha = 0.5) +
  labs(x = "2018年人間開発指数", y = "大陸") +
  theme_minimal(base_family = "HiraKakuProN-W3",
                base_size   = 12)
```

```
## Picking joint bandwidth of 0.054
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-ridge5-1} \end{center}

　また、横軸の値に応じて背景の色をグラデーションで表現することも可能です。この場合、`geom_density_ridges()`幾何オブジェクトでなく、`geom_density_ridges_gradient()`を使い、`fill`にもマッピングをする必要があります。横軸（`x`）の値に応じて色塗りをする場合、`fill = stat(x)`とします。デフォルトでは横軸の値が高いほど空色、低いほど黒になります。ここでは高いほど黄色、低いほど紫ににするため、色弱にも優しい`scale_fill_viridis_c()`を使い[^viridis]、カラーオプションはplasmaにします（`option = "c"`）。

[^viridis]: 最後の`_c`はマッピングする変数（ここでは`HDI_2018`）が連続変数（**c**ontinuous）であることを意味します。


```{.r .numberLines}
Country_df %>%
  ggplot() +
  geom_density_ridges_gradient(aes(x = HDI_2018, y = Continent, fill = stat(x)), 
                               alpha = 0.5) +
  scale_fill_viridis_c(option = "C") +
  labs(x = "2018年人間開発指数", y = "大陸", fill = "2018年人間開発指数") +
  theme_minimal(base_family = "HiraKakuProN-W3",
                base_size   = 12) +
  theme(legend.position = "bottom")
```

```
## Picking joint bandwidth of 0.054
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-ridge6-1} \end{center}

密度曲線は基本的にはなめらかな曲線であるため、データが存在しない箇所にも密度が高く見積もられるケースがあります。全体的な分布を俯瞰するには良いですが、情報の損失は避けられません。そこで出てくるのが点付きのリッジプロットです。`HDI_2018`の個々の値を点で出力するには`jittered_points = TRUE`を指定するだけです。これだけで密度曲線の内側に点が若干のズレ付き（jitter）で出力されます。ただし、密度曲線がオーバーラップされるリッジプロットの特徴を考えると、グループごとに点の色分けをする必要があります（同じ色になると、どのグループの点かが分からなくなるので）。この場合、`point_color`に対し、グループ変数（`Continent`）をマッピングします。また、密度曲線の色と合わせるために密度曲線の色塗りも`fill`で指定します。


```{.r .numberLines}
Country_df %>%
  ggplot() +
  geom_density_ridges(aes(x = HDI_2018, y = Continent, fill = Continent,
                          point_color = Continent), 
                      alpha = 0.5, jittered_points = TRUE) +
  guides(fill = "none", point_color = "none") + # 凡例を削除
  labs(x = "2018年人間開発指数", y = "大陸") +
  theme_minimal(base_family = "HiraKakuProN-W3",
                base_size   = 12)
```

```
## Picking joint bandwidth of 0.054
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-ridge7-1} \end{center}

　他にも密度曲線の下側にラグプロットを付けることも可能です。こうすれば点ごとに色訳をする必要もなくなります。ラグプロットを付けるためには点の形（`point_shape`）を「|」にする必要があります。ただ、これだけだと「|」が密度曲線内部に散らばる（jittered）だけです。散らばりをなくす、つまり密度曲線の下段に固定する必要があり、これは`aes()`その外側に`position = position_points_jitter(width = 0, height = 0)`を指定することで出来ます。


```{.r .numberLines}
Country_df %>%
  ggplot() +
  geom_density_ridges(aes(x = HDI_2018, y = Continent, fill = Continent), 
                      alpha = 0.5, jittered_points = TRUE,
                      position = position_points_jitter(width = 0, height = 0),
                      point_shape = "|", point_size = 3) +
  guides(fill = "none") +
  labs(x = "2018年人間開発指数", y = "大陸") +
  theme_minimal(base_family = "HiraKakuProN-W3",
                base_size   = 12)
```

```
## Picking joint bandwidth of 0.054
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-ridge8-1} \end{center}

　最後に密度曲線でなく、ヒストグラムで示す方法を紹介します。これは`geom_density_ridges()`の内部に`stat = "binline"`を指定するだけです。


```{.r .numberLines}
Country_df %>%
  ggplot() +
  geom_density_ridges(aes(x = HDI_2018, y = Continent), alpha = 0.5,
                      stat = "binline") +
  labs(x = "2018年人間開発指数", y = "大陸") +
  theme_minimal(base_family = "HiraKakuProN-W3",
                base_size   = 12)
```

```
## `stat_binline()` using `bins = 30`. Pick better value with `binwidth`.
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-ridge9-1} \end{center}

---

## エラーバー付き散布図 {#visual4-pointrange}

　エラーバー付きの散布図は推定結果の点推定値とその不確実性（信頼区間など）を示す際によく使われる図です。以下の表は`Country_df`を用い、大陸（オセアニアを除く）ごとにフリーダムハウス・スコア（`FH_Total`）を一人当たりPPP GDP（`PPP_per_capita`）に回帰させた分析から得られたフリーダムハウス・スコア（`FH_Total`）の係数（以下の式の$\beta_1$）の点推定値と95%信頼区間です。

$$
\text{PPP per capita} = \beta_0 + \beta_1 \cdot \text{FH}\_\text{Total} + \varepsilon
$$



```r
Pointrange_df <- tibble(
    Continent = c("Asia", "Europe", "Africa", "America"),
    Coef      = c(65.3, 588.0, 53.4, 316.0),
    Conf_lwr  = c(-250.0, 376.0, -14.5, 128.0),
    Conf_upr  = c(380.0, 801.0, 121.0, 504.0)
)
```


```{.r .numberLines}
Pointrange_df
```

```
## # A tibble: 4 x 4
## # Groups:   Continent [4]
##   Continent  Coef Conf_lwr Conf_upr
##   <chr>     <dbl>    <dbl>    <dbl>
## 1 Asia       65.3   -250.      380.
## 2 Europe    588.     376.      801.
## 3 Africa     53.4    -14.5     121.
## 4 America   316.     128.      504.
```

　実は以上のデータは以下のようなコードで作成されています。{purrr}パッケージの使い方に慣れる必要があるので、第\@ref(iteration)章を参照してください。

```r
Pointrange_df <- Country_df %>%
    filter(Continent != "Oceania") %>%
    group_by(Continent) %>%
    nest() %>%
    mutate(Fit = map(data, ~lm(PPP_per_capita ~ FH_Total, data = .)),
           Est = map(Fit, broom::tidy, conf.int = TRUE)) %>%
    unnest(Est) %>%
    filter(term == "FH_Total") %>%
    select(Continent, Coef = estimate, 
           Conf_lwr = conf.low, Conf_upr = conf.high) 
```

この`Pointrange_df`を用いて横軸は大陸（`Continent`）、縦軸には点推定値（`Coef`）と95%信頼区間（`Conf_lwr`と`Conf_upr`）を出力します。ここで使う幾何オブジェクトは`geom_pointrange()`です。横軸`x`と点推定値`y`、95%信頼区間の下限の`ymin`、上限の`ymax`にマッピングします。エラーバー付き散布図を立てに並べたい場合は`y`と`x`、`xmin`、`xmax`にマッピングします。


```{.r .numberLines}
Pointrange_df %>%
    ggplot() +
    geom_hline(yintercept = 0, linetype = 2) +
    geom_pointrange(aes(x = Continent, y = Coef, 
                        ymin = Conf_lwr, ymax = Conf_upr),
                    size = 0.75) +
    labs(y = expression(paste(beta[1], " with 95% CI"))) +
    theme_bw(base_size = 12)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-pointrage3-1} \end{center}

ここでもう一つの次元を追加することもあるでしょう。たとえば、複数のモデルを比較した場合がそうかもしれません。以下の`Pointrange_df2`について考えてみましょう。



```r
Pointrange_df2 <- tibble(
    Continent = rep(c("Asia", "Europe", "Africa", "America"), each = 2),
    Term      = rep(c("Civic Liverty", "Political Right"), 4),
    Coef      = c(207.747, 29.188, 1050.164, 1284.101,
                  110.025, 93.537, 581.4593, 646.9211),
    Conf_lwr  = c(-385.221, -609.771, 692.204, 768.209,
                  -12.648, -53.982, 262.056, 201.511),
    Conf_upr  = c(800.716, 668.147, 1408.125, 1801.994,
                  232.697, 241.057, 900.863, 1092.331))
```


```{.r .numberLines}
Pointrange_df2
```

```
## # A tibble: 8 x 5
## # Groups:   Continent [4]
##   Continent Term              Coef Conf_lwr Conf_upr
##   <chr>     <chr>            <dbl>    <dbl>    <dbl>
## 1 Asia      Civic Liberty    208.    -385.      801.
## 2 Asia      Political Right   29.2   -610.      668.
## 3 Europe    Civic Liberty   1050.     692.     1408.
## 4 Europe    Political Right 1285.     768.     1802.
## 5 Africa    Civic Liberty    110.     -12.6     233.
## 6 Africa    Political Right   93.5    -54.0     241.
## 7 America   Civic Liberty    581.     262.      901.
## 8 America   Political Right  647.     202.     1092.
```

このデータは以下の2つのモデルを大陸ごとに推定した$\beta_1$と$\gamma_1$の点推定値と95%信頼区間です。

$$
\begin{aligned}
\text{PPP per capita} & = \beta_0 + \beta_1 \cdot \text{FH}\_\text{CL} + \varepsilon \\
\text{PPP per capita} & = \gamma_0 + \gamma_1 \cdot \text{FH}\_\text{PR} + \upsilon
\end{aligned}
$$

　どの説明変数を用いたかでエラーバーと点の色分けを行う場合、`color`に対して`Term`をマッピングします。


```{.r .numberLines}
Pointrange_df2 %>%
    ggplot() +
    geom_hline(yintercept = 0, linetype = 2) +
    geom_pointrange(aes(x = Continent, y = Coef, 
                        ymin = Conf_lwr, ymax = Conf_upr,
                        color = Term), size = 0.75) +
    labs(y = expression(paste(beta[1], " and ", gamma[1], " with 95% CI")),
         color = "") +
    theme_bw(base_size = 12) +
    theme(legend.position = "bottom")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-pointrage6-1} \end{center}

　何か違いますね。この2つのエラーバーと点の位置をずらす必要があるようです。これは3次元以上の棒グラフで使った`position`引数で調整可能です。今回は実引数として`position_dodge(0.5)`を指定してみましょう。


```{.r .numberLines}
Pointrange_df2 %>%
    ggplot() +
    geom_hline(yintercept = 0, linetype = 2) +
    geom_pointrange(aes(x = Continent, y = Coef, 
                        ymin = Conf_lwr, ymax = Conf_upr,
                        color = Term),
                    size = 0.75, position = position_dodge(0.5)) +
    labs(y = expression(paste(beta[1], " and ", gamma[1], " with 95% CI")),
         color = "") +
    theme_bw(base_size = 12) +
    theme(legend.position = "bottom")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-pointrage7-1} \end{center}

　これで完成です。更に、$\alpha = 0.05$水準で統計的に有意か否かを透明度で示し、透明度の凡例を非表示にしてみましょう。$\alpha = 0.05$水準で統計的に有意か否かは95%信頼区間の上限と下限の積が0より大きいか否かで判定できます。`ggplot()`にデータを渡す前に統計的有意か否かを意味する`Sig`変数を作成し、`geom_pointrage()`の内部では`alpha`に`Sig`をマッピングします。


```{.r .numberLines}
Pointrange_df2 %>%
    mutate(Sig = if_else(Conf_lwr * Conf_upr > 0, 
                         "Significant", "Insignificant")) %>%
    ggplot() +
    geom_hline(yintercept = 0, linetype = 2) +
    geom_pointrange(aes(x = Continent, y = Coef, 
                        ymin = Conf_lwr, ymax = Conf_upr,
                        color = Term, alpha = Sig),
                    size = 0.75, position = position_dodge(0.5)) +
    labs(y = expression(paste(beta[1], " and ", gamma[1], " with 95% CI")),
         color = "") +
    scale_alpha_manual(values = c("Significant" = 1, "Insignificant" = 0.35)) +
    guides(alpha = FALSE) +
    theme_bw(base_size = 12) +
    theme(legend.position = "bottom")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-pointrage8-1} \end{center}

---

## ロリーポップチャート {#visual4-lollipop}

　ロリーポップチャートは棒グラフの特殊な形態であり、棒がロリーポップ（チュッパチャップス）の形をしているものを指します。したがって、2つの図は本質的に同じですが、棒が多い場合はロリーポップチャートを使うケースがあります。棒が非常に多い棒グラフの場合、図を不適切に縮小すると[モアレ](https://ja.wikipedia.org/wiki/%E3%83%A2%E3%82%A2%E3%83%AC)が生じるケースがあるからです。

　まず、`Country_df`を用い、ヨーロッパ諸国の一人当たりPPP GDP（`PPP_per_capita`）の棒グラフを作るとします。`PPP_per_capita`が欠損していないヨーロッパの国は46行であり、非常に棒が多い棒グラフになります。


```{.r .numberLines}
Country_df %>%
  filter(Continent == "Europe") %>%
  drop_na(PPP_per_capita) %>%
  ggplot() +
  geom_bar(aes(y = Country, x = PPP_per_capita), stat = "identity") +
  labs(x = "一人あたり購買力平価GDP", y = "国") +
  theme_bw(base_family = "HiraKakuProN-W3",
           base_size   = 12)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-lollipop1-1} \end{center}

ここで登場するのがロリーポップチャートです。ロリーポップチャートの構成要素は棒とキャンディーの部分です。棒は線になるため`geom_segement()`を、キャンディーは散布図`geom_point()`を使います。散布図については既に第\@ref(visualization2)章で説明しましたので、ここでは`geom_segment()`について説明します。

　`geom_segment()`は直線を引く幾何オブジェクトであり、線の起点（`x`と`y`）と終点（`xend`と`yend`）に対してマッピングをする必要があります。横軸上の起点は0、縦軸上の起点は`Country`です。そして横軸上の終点は`PPP_per_capita`、縦軸上のそれは`Country`です。縦軸上の起点と終点が同じということは水平線を引くことになります。

　`geom_segment()`で水平線を描いたら、次は散布図をオーバーラップさせます。点の横軸上の位置は`PPP_per_capita`、縦軸上の位置は`Country`です。


```{.r .numberLines}
Country_df %>%
  filter(Continent == "Europe") %>%
  drop_na(PPP_per_capita) %>%
  ggplot() +
  geom_segment(aes(y = Country, yend = Country,
                   x = 0, xend = PPP_per_capita)) +
  geom_point(aes(y = Country, x = PPP_per_capita), color = "orange") +
  labs(x = "一人あたり購買力平価GDP (USD)", y = "国") +
  theme_bw(base_family = "HiraKakuProN-W3",
           base_size   = 12) +
  theme(panel.grid.major.y = element_blank(),
        panel.border = element_blank(),
        axis.ticks.y = element_blank())
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-lollipop2-1} \end{center}

　これで完成です。もし一人当たりPPP GDP順で並べ替えたい場合は`fct_reorder()`を使います。`Country`を`PPP_per_capita`の低い方を先にくるようにするなら、`fct_reorder(Country, PPP_per_capita)`です。縦に並ぶの棒グラフなら最初に来る水準が下に位置されます。もし、順番を逆にしたいなら、更に`fct_rev()`で水準の順番を逆転させます。


```{.r .numberLines}
Country_df %>%
  filter(Continent == "Europe") %>%
  drop_na(PPP_per_capita) %>%
  mutate(Country = fct_reorder(Country, PPP_per_capita)) %>% 
  ggplot() +
  geom_segment(aes(y = Country, yend = Country,
                   x = 0, xend = PPP_per_capita)) +
  geom_point(aes(y = Country, x = PPP_per_capita), color = "orange") +
  labs(x = "一人あたり購買力平価GDP (USD)", y = "国") +
  theme_bw(base_family = "HiraKakuProN-W3",
           base_size   = 12) +
  theme(panel.grid.major.y = element_blank(),
        panel.border = element_blank(),
        axis.ticks.y = element_blank())
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-lollipop3-1} \end{center}

　ロリーポップロリーポップチャートで次元を追加するには点（キャンディー）の色分けが考えられます。たとえば、OECD加盟国か否かの次元を追加する場合、`geom_point()`において`color`をマッピングするだけです。


```{.r .numberLines}
Country_df %>%
  filter(Continent == "Europe") %>%
  drop_na(PPP_per_capita) %>%
  mutate(Country = fct_reorder(Country, PPP_per_capita),
         OECD    = if_else(OECD == 1, "OECD", "non-OECD"),
         OECD    = factor(OECD, levels = c("OECD", "non-OECD"))) %>% 
  ggplot() +
  geom_segment(aes(y = Country, yend = Country,
                   x = 0, xend = PPP_per_capita)) +
  geom_point(aes(y = Country, x = PPP_per_capita, color = OECD)) +
  scale_color_manual(values = c("OECD" = "orange", "non-OECD" = "royalblue")) +
  labs(x = "一人あたり購買力平価GDP (USD)", y = "国", color = "") +
  theme_bw(base_family = "HiraKakuProN-W3",
           base_size   = 12) +
  theme(panel.grid.major.y = element_blank(),
        panel.border       = element_blank(),
        axis.ticks.y       = element_blank(),
        legend.position    = "bottom")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-lollipop4-1} \end{center}

　ファセット分割ももちろんできますが、この場合、OECD加盟国の一人当たりPPP GDPが相対的に高いことを示すなら、一つのファセットにまとめた方が良いでしょう。

　以下のようにロリーポップを横に並べることもできますが、棒の数が多いケースがほとんどであるロリーポップチャートではラベルの回転が必要になるため、読みにくくなるかも知れません。


```{.r .numberLines}
Country_df %>%
  filter(Continent == "Europe") %>%
  drop_na(PPP_per_capita) %>%
  mutate(Country = fct_reorder(Country, PPP_per_capita),
         Country = fct_rev(Country)) %>% 
  ggplot() +
  geom_segment(aes(x = Country, xend = Country,
                   y = 0, yend = PPP_per_capita)) +
  geom_point(aes(x = Country, y = PPP_per_capita), color = "orange") +
  labs(x = "国", y = "一人あたり購買力平価GDP (USD)") +
  theme_bw(base_family = "HiraKakuProN-W3",
           base_size   = 12) +
  theme(panel.grid.major.y = element_blank(),
        panel.border = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-lollipop5-1} \end{center}

---

## 平滑化ライン {#visual4-smooth}

2次元平面上に散布図をプロットし、二変数間の関係を一本の線で要約するのは平滑化ラインです。{ggplot2}では`geom_smooth()`幾何オブジェクトを重ねることで簡単に平滑化ラインをプロットすることができます。まずは、横軸をフリーダムハウス・スコア（`FH_Total`）、縦軸を一人当たり購買力平価GDP（`PPP_per_capita`）にした散布図を出力し、その上に平滑化ラインを追加してみましょう。`geom_smooth()`にもマッピングが必要で、`aes()`の内部に`x`と`y`をマッピングします。今回は`geom_point()`と`geom_smooth()`が同じマッピング情報を共有するため、`ggplot()`内部でマッピングします。


```{.r .numberLines}
Country_df %>%
    ggplot(aes(x = FH_Total, y = PPP_per_capita)) +
    geom_point() +
    geom_smooth()  +
    labs(x = "Freedom House Score", y = "PPP per capita (USD)") +
    scale_y_continuous(breaks = seq(0, 120000, by = 10000),
                       labels = seq(0, 120000, by = 10000)) +
    theme_minimal(base_size = 12)
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-smooth1-1} \end{center}

　青い線が平滑化ライン、網掛けの領域が95%信頼区間です。この線はLOESS (**LO**cal **E**stimated **S**catterplot **S**moothing)と呼ばれる非線形平滑化ラインです。どのようなラインを引くかは`method`引数で指定しますが、この`method`既定値が`"loess"`です。これを見るとフリーダムハウス・スコアが75以下の国では国の自由度と所得間の関係があまり見られませんが、75からは正の関係が確認できます。

　LOESS平滑化の場合、`span`引数を使って滑らかさを調整することができます。`span`の既定値は0.75ですが、これが小さいほど散布図によりフィットしたラインが引かれ、よりギザギザな線になります。たとえば、`span`を0.25にすると以下のようなグラフが得られます。


```{.r .numberLines}
Country_df %>%
    ggplot(aes(x = FH_Total, y = PPP_per_capita)) +
    geom_point() +
    geom_smooth(method = "loess", span = 0.25)  +
    labs(x = "Freedom House Score", y = "PPP per capita (USD)") +
    scale_y_continuous(breaks = seq(0, 120000, by = 10000),
                       labels = seq(0, 120000, by = 10000)) +
    theme_minimal(base_size = 12)
```

```
## `geom_smooth()` using formula 'y ~ x'
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-smooth2-1} \end{center}

　他にも定番の回帰直線を引くこともできます。`method`の実引数を`"lm"`に変えるだけです。


```{.r .numberLines}
Country_df %>%
    ggplot(aes(x = FH_Total, y = PPP_per_capita)) +
    geom_point() +
    geom_smooth(method = "lm")  +
    labs(x = "Freedom House Score", y = "PPP per capita (USD)") +
    scale_y_continuous(breaks = seq(0, 120000, by = 10000),
                       labels = seq(0, 120000, by = 10000)) +
    theme_minimal(base_size = 12)
```

```
## `geom_smooth()` using formula 'y ~ x'
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-smooth3-1} \end{center}

　信頼区間は既定値だと95%信頼区間が表示されますが、`level`引数で調整することができます。たとえば、99.9%信頼区間を表示したい場合、`level = 0.999`を指定します。


```{.r .numberLines}
Country_df %>%
    ggplot(aes(x = FH_Total, y = PPP_per_capita)) +
    geom_point() +
    geom_smooth(method = "lm", level = 0.999)  +
    labs(x = "Freedom House Score", y = "PPP per capita (USD)") +
    scale_y_continuous(breaks = seq(0, 120000, by = 10000),
                       labels = seq(0, 120000, by = 10000)) +
    theme_minimal(base_size = 12)
```

```
## `geom_smooth()` using formula 'y ~ x'
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-smooth4-1} \end{center}

　信頼区間を消したい場合は`se = FALSE`を指定します（既定値は`TRUE`）。


```{.r .numberLines}
Country_df %>%
    ggplot(aes(x = FH_Total, y = PPP_per_capita)) +
    geom_point() +
    geom_smooth(method = "lm", se = FALSE)  +
    labs(x = "Freedom House Score", y = "PPP per capita (USD)") +
    scale_y_continuous(breaks = seq(0, 120000, by = 10000),
                       labels = seq(0, 120000, by = 10000)) +
    theme_minimal(base_size = 12)
```

```
## `geom_smooth()` using formula 'y ~ x'
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-smooth5-1} \end{center}

　最後にデータのサブセットごとに回帰直線を引く方法について説明します。散布図で色分けを行う場合、`aes()`内で`color`引数を指定しますが、これだけで十分です。今回はこれまでの散布図をOECD加盟有無ごとに色分けし、それぞれ別の回帰直線を重ねてみましょう。回帰直線も色分けしたいので`color`引数で次元を増やす必要があり、これは`geom_point()`と共通であるため、`ggplot()`内でマッピングします。


```{.r .numberLines}
Country_df %>%
    mutate(OECD = if_else(OECD == 1, "加盟国", "非加盟国")) %>%
    ggplot(aes(x = FH_Total, y = PPP_per_capita, color = OECD)) +
    geom_point() +
    geom_smooth(method = "lm")  +
    labs(x = "Freedom House Score", y = "PPP per capita (USD)") +
    scale_y_continuous(breaks = seq(0, 120000, by = 10000),
                       labels = seq(0, 120000, by = 10000)) +
    coord_cartesian(ylim = c(0, 120000)) +
    theme_bw(base_family = "HiraKakuProN-W3",
             base_size = 12)
```

```
## `geom_smooth()` using formula 'y ~ x'
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-smooth6-1} \end{center}

　これを見ると、国の自由度と所得の間に関係が見られるのはOECD加盟国で、非加盟国では非常に関係が弱いことが分かります。

　あまりいい方法ではないと思いますが、散布図は色（`color`）で分け、回帰直線は線の種類（`linetype`）で分けるならどうすれば良いでしょうか。この場合は`color`は`geom_point()`内部で、`linetype`は`geom_smooth()`でマッピングします。


```{.r .numberLines}
Country_df %>%
    mutate(OECD = if_else(OECD == 1, "加盟国", "非加盟国")) %>%
    ggplot(aes(x = FH_Total, y = PPP_per_capita)) +
    geom_point(aes(color = OECD)) +
    geom_smooth(aes(linetype = OECD), method = "lm", color = "black")  +
    labs(x = "Freedom House Score", y = "PPP per capita (USD)") +
    scale_y_continuous(breaks = seq(0, 120000, by = 10000),
                       labels = seq(0, 120000, by = 10000)) +
    coord_cartesian(ylim = c(0, 120000)) +
    theme_bw(base_family = "HiraKakuProN-W3",
             base_size = 12)
```

```
## `geom_smooth()` using formula 'y ~ x'
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-smooth7-1} \end{center}

　{ggplot2}が提供する平滑化ラインにはLOESSと回帰直線以外にも`"glm"`や`"gam"`などがります。詳細はRコンソール上で`?geom_smooth`を入力し、ヘルプを参照してください。

---

## ヒートマップ {#visual4-heatmap}

### 2つの離散変数の分布を表すヒートマップ

　ヒートマップ（heat map）には2つの使い方があります。まずは、離散変数$\times$離散変数の同時分布を示す時です。これは後ほど紹介するモザイク・プロットと目的は同じですが、モザイク・プロットはセルの**面積**で密度や度数を表すに対し、ヒートマップは主に**色**で密度や度数を表します。

　ここでは一人当たり購買力平価GDP（`PPP_per_capita`）を「1万ドル未満」、「1万ドル以上・2万ドル未満」、「2万ドル以上、3万ドル未満」、「3万ドル以上」の離散変数に変換し、大陸ごとの国家数をヒートマップとして示してみたいと思います。まずは、変数のリコーディングをし、全てfactor化します。最後に国家名（`Country`）、大陸（`Continent`）、所得（`Income`）、フリーダム・ハウス・スコア（`FH_Total`）、人間開発指数（`HDI_2018`）列のみ抽出し、`Heatmap_df`という名のオブジェクトとして格納しておきます。


```{.r .numberLines}
Heatmap_df <- Country_df %>%
  filter(!is.na(PPP_per_capita)) %>%
  mutate(Continent = recode(Continent,
                            "Africa"  = "アフリカ",
                            "America" = "アメリカ",
                            "Asia"    = "アジア",
                            "Europe"  = "ヨーロッパ",
                            .default  = "オセアニア"),
         Continent = factor(Continent, levels = c("アフリカ", "アメリカ", "アジア", 
                                                  "ヨーロッパ", "オセアニア")),
         Income    = case_when(PPP_per_capita < 10000 ~ "1万ドル未満",
                               PPP_per_capita < 20000 ~ "1万ドル以上\n2万ドル未満",
                               PPP_per_capita < 30000 ~ "2万ドル以上\n3万ドル未満",
                               TRUE                   ~ "3万ドル以上"),
         Income    = factor(Income, levels = c("1万ドル未満", "1万ドル以上\n2万ドル未満",
                                               "2万ドル以上\n3万ドル未満", "3万ドル以上"))) %>%
  select(Country, Continent, Income, FH_Total, HDI_2018)

Heatmap_df
```

```
## # A tibble: 178 x 5
##    Country             Continent  Income                     FH_Total HDI_2018
##    <chr>               <fct>      <fct>                         <dbl>    <dbl>
##  1 Afghanistan         アジア     "1万ドル未満"                    27    0.496
##  2 Albania             ヨーロッパ "1万ドル以上\n2万ドル未満"       67    0.791
##  3 Algeria             アフリカ   "1万ドル以上\n2万ドル未満"       34    0.759
##  4 Angola              アフリカ   "1万ドル未満"                    32    0.574
##  5 Antigua and Barbuda アメリカ   "2万ドル以上\n3万ドル未満"       85    0.776
##  6 Argentina           アメリカ   "2万ドル以上\n3万ドル未満"       85    0.83 
##  7 Armenia             ヨーロッパ "1万ドル以上\n2万ドル未満"       53    0.76 
##  8 Australia           オセアニア "3万ドル以上"                    97    0.938
##  9 Austria             ヨーロッパ "3万ドル以上"                    93    0.914
## 10 Azerbaijan          ヨーロッパ "1万ドル以上\n2万ドル未満"       10    0.754
## # ... with 168 more rows
```

　次は`group_by()`と`summarise()`を使って、各カテゴリーに属するケース数を計算し、`N`という名の列として追加します。


```{.r .numberLines}
Heatmap_df1 <- Heatmap_df %>%
  group_by(Continent, Income) %>%
  summarise(N       = n(),
            .groups = "drop")

Heatmap_df1
```

```
## # A tibble: 18 x 3
##    Continent  Income                         N
##    <fct>      <fct>                      <int>
##  1 アフリカ   "1万ドル未満"                 41
##  2 アフリカ   "1万ドル以上\n2万ドル未満"     9
##  3 アフリカ   "2万ドル以上\n3万ドル未満"     2
##  4 アメリカ   "1万ドル未満"                 10
##  5 アメリカ   "1万ドル以上\n2万ドル未満"    14
##  6 アメリカ   "2万ドル以上\n3万ドル未満"     6
##  7 アメリカ   "3万ドル以上"                  5
##  8 アジア     "1万ドル未満"                 17
##  9 アジア     "1万ドル以上\n2万ドル未満"    10
## 10 アジア     "2万ドル以上\n3万ドル未満"     3
## 11 アジア     "3万ドル以上"                 11
## 12 ヨーロッパ "1万ドル未満"                  1
## 13 ヨーロッパ "1万ドル以上\n2万ドル未満"    10
## 14 ヨーロッパ "2万ドル以上\n3万ドル未満"     7
## 15 ヨーロッパ "3万ドル以上"                 28
## 16 オセアニア "1万ドル未満"                  1
## 17 オセアニア "1万ドル以上\n2万ドル未満"     1
## 18 オセアニア "3万ドル以上"                  2
```

　これでデータの準備は終わりました。ヒートマップを作成する幾何オブジェクトは`geom_tile()`です。同時分布を示したい変数を、それぞれ`x`と`y`にマッピングし、密度、または度数を表す変数を`fill`にマッピングします。ここでは横軸を大陸（`Continent`）、縦軸を一人当たり購買力平価GDP（`Income`）とし、`fill`には`N`変数をマッピングします。


```{.r .numberLines}
Heatmap_df1 %>%
  ggplot() +
  geom_tile(aes(x = Continent, y = Income, fill = N)) +
  labs(x = "大陸", y = "一人当たり購買力平価GDP（ドル）", fill = "国家数") +
  theme_bw(base_family = "HiraKakuProN-W3",
           base_size = 12) +
  theme(panel.grid = element_blank()) # グリッドラインを消す
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-heatmap3-1} \end{center}

　明るいほどカテゴリーに属するケースが多く、暗いほど少ないことを意味します。これを見ると世界で最も多くの割合を占めているのは、一人当たり購買力平価GDPが1万ドル未満のアフリカの国で、次は一人当たり購買力平価GDPが3万ドル以上のヨーロッパの国であることが分かります。欠損している（ケース数が0）セルは白の空白となります。

　色をカスタマイズするには`scale_fill_gradient()`です。これは第\@ref(visualization3)章で紹介しました`scale_color_gradient()`と使い方は同じです。`scale_fill_gradient()`は中間点なし、`scale_fill_gradient2()`は中間点ありの場合に使いますが、ここでは度数が小さい場合は<span style="color:#FFF8DC;font-weight:bold;">cornsilk</span>色を、大きい場合は<span style="color:#cd3333;font-weight:bold;">brown3</span>色を使います。それぞれ`low`と`high`に色を指定するだけです。


```{.r .numberLines}
Heatmap_df1 %>%
  ggplot() +
  geom_tile(aes(x = Continent, y = Income, fill = N)) +
  labs(x = "大陸", y = "一人当たり購買力平価GDP（ドル）", fill = "国家数") +
  scale_fill_gradient(low  = "cornsilk", 
                      high = "brown3") +
  theme_bw(base_family = "HiraKakuProN-W3",
           base_size = 12) +
  theme(panel.grid = element_blank()) # グリッドラインを消す
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-heatmap4-1} \end{center}

　気のせいかも知れませんが、先ほどよりは読みやすくなったような気がしますね。

### 離散変数$\times$離散変数における連続変数の値を示すヒートマップ

　次は、離散変数$\times$離散変数における連続変数の値を示すヒートマップを作ってみましょう。ヒートマップにおけるそれぞれのタイル（tile）は横軸上の位置と縦軸上の位置情報を持ち、これは前回と同様、離散変数でマッピングされます。そして、タイルの色は何らかの連続変数にマッピングされます。前回作成しましたヒートマップは度数、または密度であり、これも実は連続変数だったので、図の作り方は本質的には同じです。

　ここでは大陸と所得ごとに人間開発指数の平均値を表すヒートマップを作ってみましょう。大陸（`Continent`）と所得（`Income`）でグループ化し、人間開発指数（`HDI_2018`）の平均値を計算したものを`Heatmap_df2`という名のオブジェクトとして格納します。


```{.r .numberLines}
Heatmap_df2 <- Heatmap_df %>%
  group_by(Continent, Income) %>%
  summarise(HDI     = mean(HDI_2018, na.rm = TRUE),
            .groups = "drop")

Heatmap_df2
```

```
## # A tibble: 18 x 3
##    Continent  Income                       HDI
##    <fct>      <fct>                      <dbl>
##  1 アフリカ   "1万ドル未満"              0.510
##  2 アフリカ   "1万ドル以上\n2万ドル未満" 0.697
##  3 アフリカ   "2万ドル以上\n3万ドル未満" 0.798
##  4 アメリカ   "1万ドル未満"              0.638
##  5 アメリカ   "1万ドル以上\n2万ドル未満" 0.752
##  6 アメリカ   "2万ドル以上\n3万ドル未満" 0.806
##  7 アメリカ   "3万ドル以上"              0.841
##  8 アジア     "1万ドル未満"              0.624
##  9 アジア     "1万ドル以上\n2万ドル未満" 0.730
## 10 アジア     "2万ドル以上\n3万ドル未満" 0.818
## 11 アジア     "3万ドル以上"              0.872
## 12 ヨーロッパ "1万ドル未満"              0.711
## 13 ヨーロッパ "1万ドル以上\n2万ドル未満" 0.776
## 14 ヨーロッパ "2万ドル以上\n3万ドル未満" 0.827
## 15 ヨーロッパ "3万ドル以上"              0.902
## 16 オセアニア "1万ドル未満"              0.543
## 17 オセアニア "1万ドル以上\n2万ドル未満" 0.724
## 18 オセアニア "3万ドル以上"              0.930
```

　作図の方法は前回と同じですが、今回はタイルの色塗り（`fill`）を人間開発指数の平均値（`HDI`）でマッピングする必要があります。他の箇所は同じコードでも良いですが、ここでは色塗りの際、中間点を指定してみましょう。たとえば人間開発指数が0.75なら色を<span style="color:#fff8dc;font-weight:bold;background-color:#000000;">cornsilk</span>色とし、これより低いっほど<span style="color:#6495ED;font-weight:bold;">cornflowerblue</span>色に、高いほど<span style="color:#cd3333;font-weight:bold;">brown3</span>色になるように指定します。中間点を持つグラデーション色塗りは`scale_fill_gradient2()`で調整することができます。使い方は`scale_fill_gradient()`とほぼ同じですが、中間点の色（`mid`）と中間点の値（`midpoint`）をさらに指定する必要があります。


```{.r .numberLines}
Heatmap_df2 %>%
  ggplot() +
  geom_tile(aes(x = Continent, y = Income, fill = HDI)) +
  labs(x = "大陸", y = "一人当たり購買力平価GDP（ドル）", 
       fill = "人間開発指数の平均値 (2018)") +
  scale_fill_gradient2(low  = "cornflowerblue", 
                       mid  = "cornsilk",
                       high = "brown3",
                       midpoint = 0.75) +
  theme_bw(base_family = "HiraKakuProN-W3",
           base_size = 12) +
  theme(legend.position = "bottom",
        panel.grid      = element_blank())
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-heatmap6-1} \end{center}

---

## 等高線図 {#visual4-contour}

連続変数$\times$連続変数の同時分布


```{.r .numberLines}
Country_df %>%
  ggplot(aes(x = FH_Total, y = HDI_2018)) +
  geom_density_2d() +
  labs(x = "フリーダム・ハウス・スコア", y = "人間開発指数 (2018)") +
  theme_minimal(base_family = "HiraKakuProN-W3",
                base_size = 12)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-contour1-1} \end{center}


```{.r .numberLines}
Country_df %>%
  ggplot(aes(x = FH_Total, y = HDI_2018)) +
  geom_point() +
  geom_density_2d() +
  labs(x = "フリーダム・ハウス・スコア", y = "人間開発指数 (2018)") +
  theme_minimal(base_family = "HiraKakuProN-W3",
                base_size = 12)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-contour2-1} \end{center}


```{.r .numberLines}
Country_df %>%
  ggplot(aes(x = FH_Total, y = HDI_2018)) +
  geom_density_2d_filled() +
  labs(x = "フリーダム・ハウス・スコア", y = "人間開発指数 (2018)",
       fill = "密度") +
  theme_minimal(base_family = "HiraKakuProN-W3",
                base_size = 12)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-contour3-1} \end{center}

　`geom_density_2d_filled()`オブジェクトの後に`geom_density_2d()`オブジェクトを重ねると、区間の区画線を追加することもできます。


```{.r .numberLines}
Country_df %>%
  ggplot(aes(x = FH_Total, y = HDI_2018)) +
  geom_density_2d_filled() +
  geom_density_2d(color = "black") +
  labs(x = "フリーダム・ハウス・スコア", y = "人間開発指数 (2018)",
       fill = "密度") +
  theme_minimal(base_family = "HiraKakuProN-W3",
                base_size = 12)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-contour4-1} \end{center}

　色が気に入らない場合、自分で調整することも可能です。`scale_fill_manual()`で各区間ごとの色を指定することもできませんが、あまり効率的ではありません。ここでは`scale_fill_brewer()`関数を使って、[ColorBrewer](https://colorbrewer2.org/)のパレットを使ってみましょう。引数なしでも使えますが、既定値のパレットは区間が9つまで対応します。今回の等高線図は全部で10区間ですので、あまり適切ではありません。ここでは11区間まで対応可能な`"Spectral"`パレットを使いますが、これは`palette`引数で指定できます。


```{.r .numberLines}
Country_df %>%
  ggplot(aes(x = FH_Total, y = HDI_2018)) +
  geom_density_2d_filled() +
  scale_fill_brewer(palette = "Spectral") +
  labs(x = "フリーダム・ハウス・スコア", y = "人間開発指数 (2018)",
       fill = "密度") +
  theme_minimal(base_family = "HiraKakuProN-W3",
                base_size = 12)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-contour5-1} \end{center}

　`palette`で指定可能なカラーパレットの一覧は{RColorBrewer}の`display.brewer.all()`関数で確認することが出来ます。各パレットが何区間まで対応できるかを見てから自分でパレットを作成することも可能ですが、詳細はネット上の各種記事を参照してください。


```{.r .numberLines}
RColorBrewer::display.brewer.all()
```

\begin{figure}

{\centering \includegraphics{visualization4_files/figure-latex/visual4-contour6-1} 

}

\caption{{RColorBrewer}が提供するパレート一覧}(\#fig:visual4-contour6)
\end{figure}

---

## 地図 {#visual4-map}

### 世界地図

{ggplot2}で地図をプロットする方法は色々あります。理想としては各国政府が提供する地図データをダウンロードし、それを読み込み・加工してプロットすることでしょうが、ここではパッケージを使ったマッピングについて紹介します。

　今回使用するパッケージは{rnaturalearth}、{rnaturalearthdata}、{rgeos}です。他にも使うパッケージはありますが、世界地図ならとりあえずこれで十分です。


```{.r .numberLines}
pacman::p_load(rnaturalearth, rnaturalearthdata, rgeos)
```

　世界地図を読み込む関数は{rnaturalearth}が提供する`ne_countries()`です。とりあえず指定する引数は`scale`と`retunrclass`です。`scale`は地図の解像度であり、世界地図なら`"small"`で十分です。もう少し拡大される大陸地図なら`"medium"`が、一国だけの地図なら`"large"`が良いかも知れません。`reutrnclass`は`"sf"`と指定します。今回は低解像度の世界地図をsfクラスで読み込んでみましょう。


```{.r .numberLines}
world_map <- ne_countries(scale = "small", returnclass = "sf")

class(world_map)
```

```
## [1] "sf"         "data.frame"
```

　クラスはdata.frameとsfであり、実際、`world_map`を出力してみると、見た目がデータフレームであることが分かります。地図の出力は`geom_sf()`幾何オブジェクトを使用します。とりあえず、やってみましょう。


```{.r .numberLines}
world_map %>% 
  ggplot() +
  geom_sf() +
  theme_void() # 何もないテーマを指定する。ここはお好みで
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-map3-1} \end{center}

　もし、各国の人口に応じて色塗りをする場合はどうすれば良いでしょうか。実は、今回使用するデータがデータフレーム形式であることを考えると、これまでの{ggplot2}の使い方とあまり変わりません。{rnaturalearth}から読み込んだデータには既に`pop_est`という各国の人口データが含まれて負います。この値に応じて色塗りを行うため、`geom_sf()`内に`fill = pop_est`でマッピングするだけです。

　他にも自分で構築したデータがあるなら、データを結合して使用すれば良いでしょう。これについては後述します。


```{.r .numberLines}
world_map %>% 
  ggplot() +
  geom_sf(aes(fill = pop_est)) +
  # 人口が少ない国はcornflowerblue色に、多い国はbrown3色とする
  scale_fill_gradient(low = "cornflowerblue", high = "brown3") +
  labs(fill = "人口") +
  theme_minimal(base_family = "HiraginoSans-W3") +
  theme_void()
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-map4-1} \end{center}

　もし、世界でなく一部の地域だけを出力するなら、`coord_sf()`で座標系を調整します。東アジアと東南アジアの一部を出力したいとします。この場合、経度は90度から150度まで、緯度は10度から50度に絞ることになります。経度は`xlim`で、緯度は`ylim`で調整します。


```{.r .numberLines}
world_map %>% 
  ggplot() +
  geom_sf(aes(fill = pop_est)) +
  scale_fill_gradient(low = "cornflowerblue", high = "brown3") +
  labs(fill = "人口") +
  coord_sf(xlim = c(90, 150), ylim = c(10, 50)) +
  theme_minimal(base_family = "HiraKakuProN-W3") +
  theme(legend.position = "bottom")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-map5-1} \end{center}

　他にも`ne_countries()`内に`continent`引数を指定し、特定の大陸だけを読み込むことで可能です。ここではアジアの国のみを抽出し、`asia_map`という名のオブジェクトとして格納します。解像度は中程度とします。


```{.r .numberLines}
asia_map <- ne_countries(scale = "medium", continent = "Asia", 
                         returnclass = "sf")

asia_map %>%
    ggplot() +
    # 所得グループで色塗り
    geom_sf(aes(fill = income_grp)) +
    theme_void() +
    labs(fill = "Income Group")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-map6-1} \end{center}

　アジアの中から更に東アジアに絞りたい場合は`filter()`を使用し、`subregion`列を基準に抽出することも可能です。


```{.r .numberLines}
asia_map %>%
    filter(subregion == "Eastern Asia") %>%
    ggplot() +
    geom_sf(aes(fill = income_grp)) +
    theme_void() +
    labs(fill = "Income Group")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-map7-1} \end{center}

　`subregion`の値は以下のように確認可能です。


```{.r .numberLines}
unique(asia_map$subregion)
```

```
## [1] "Southern Asia"           "Western Asia"           
## [3] "South-Eastern Asia"      "Eastern Asia"           
## [5] "Seven seas (open ocean)" "Central Asia"
```

　これまで使用してきたデータがデータフレームと同じ見た目をしているため、{dplyr}を用いたデータハンドリングも可能です。たとえば、人口を連続変数としてでなく、factor型に変換してからマッピングをしてみましょう。


```{.r .numberLines}
asia_map %>% 
  mutate(Population = case_when(pop_est < 10000000  ~ "1千万未満",
                                pop_est < 50000000  ~ "5千万未満",
                                pop_est < 100000000 ~ "1億未満",
                                pop_est < 500000000 ~ "5億未満",
                                TRUE                ~ "5億以上"),
         Population = factor(Population, 
                             levels = c("1千万未満", "5千万未満", "1億未満",
                                        "5億未満", "5億以上"))) %>%
  ggplot() +
  geom_sf(aes(fill = Population)) +
  scale_fill_brewer(palette = "Blues", drop = FALSE) +
  labs(fill = "人口") +
  theme_void(base_family = "HiraginoSans-W3") +
  theme(legend.position = "bottom")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-map9-1} \end{center}

　`scale_fill_brewer()`の`palette`引数は等高線図のときに紹介しましたパレート一覧を参照してください。

### 日本地図（全体）

　次は日本地図の出力についてです。日本全土だけを出力するなら、これまで使いました`ne_countries`に`country`引数を指定するだけで使えます。たとえば、日本の地図だけなら、`country = "Japan"`を指定します。


```{.r .numberLines}
ne_countries(scale = "small", country = "Japan", returnclass = "sf") %>%
    ggplot() +
    geom_sf() +
    theme_void() # 空っぽのテーマ
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-map10-1} \end{center}

　これだと、物足りない感があるので、もう少し高解像度の地図にしてみましょう。高解像度の地図データを読み込む際は`scale = "large"`を指定します。


```{.r .numberLines}
ne_countries(scale = "large", country = "Japan", returnclass = "sf") %>%
    ggplot() +
    geom_sf() +
    theme_void() # 空っぽのテーマ
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-map11-1} \end{center}

　ただ、日本地図を出すという場合、多くは都道府県レベルでマッピングが目的でしょう。世界地図のマッピングならこれで問題ありませんが、一国だけなら、その下の自治体の境界線も必要です。したがって、先ほど使用しましたパッケージのより高解像度の地図が含まれている{rnaturalearthhires}をインストールし、読み込みましょう。2022年Feb月25日現在、{rnaturalearthhires}はCRANに登録されておらず、GitHubの[ropensciレポジトリー](https://github.com/ropensci)のみで公開されているため、今回は{pacman}の`p_load()`でなく、`p_load_gh()`を使用します。


```{.r .numberLines}
pacman::p_load_gh("ropensci/rnaturalearthhires")
```

　地図データの抽出には`ne_states()`関数を使用します。第一引数として国家名を指定し、地図データのクラスはsfとします。抽出したデータの使い方は世界地図の時と同じです。


```{.r .numberLines}
Japan_Map <- ne_states("Japan", returnclass = "sf")

Japan_Map %>%
  ggplot() +
  geom_sf() +
  theme_void()
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-map13-1} \end{center}

　今回は各都道府県を人口密度ごとに色塗りをしてみましょう。`ne_states()`で読み込んだデータに人口密度のデータはないため、別途のデータと結合する必要があります。筆者が予め作成しておいた[データ](Data/Japan_Density.csv)を読み込み、中身を確認してみます。


```{.r .numberLines}
Japan_Density <- read_csv("Data/Japan_Density.csv")
```

```
## Rows: 47 Columns: 3
## -- Column specification --------------------------------------------------------
## Delimiter: ","
## chr (1): Name
## dbl (2): Code, Density
## 
## i Use `spec()` to retrieve the full column specification for this data.
## i Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```{.r .numberLines}
Japan_Density
```

```
## # A tibble: 47 x 3
##     Code Name   Density
##    <dbl> <chr>    <dbl>
##  1     1 北海道    66.6
##  2     2 青森県   128. 
##  3     3 岩手県    79.2
##  4     4 宮城県   316. 
##  5     5 秋田県    82.4
##  6     6 山形県   115. 
##  7     7 福島県   133  
##  8     8 茨城県   470. 
##  9     9 栃木県   302. 
## 10    10 群馬県   305. 
## # ... with 37 more rows
```

　各都道府県の人口密度がついております、左側の`Code`は何でしょうか。これは各都道府県のISOコードであり、このコードをキー変数としてデータを結合することとなります。各都道府県のコードは[国土交通省のホームページ](https://nlftp.mlit.go.jp/ksj/gml/codelist/PrefCd.html)から確認可能です。

　それではデータを結合してみましょう。`ne_states()`で読み込んだデータの場合、地域のコードは`iso_3166_2`という列に格納されています。


```{.r .numberLines}
Japan_Map$iso_3166_2
```

```
##  [1] "JP-46" "JP-44" "JP-40" "JP-41" "JP-42" "JP-43" "JP-45" "JP-36" "JP-37"
## [10] "JP-38" "JP-39" "JP-32" "JP-35" "JP-31" "JP-28" "JP-26" "JP-18" "JP-17"
## [19] "JP-16" "JP-15" "JP-06" "JP-05" "JP-02" "JP-03" "JP-04" "JP-07" "JP-08"
## [28] "JP-12" "JP-13" "JP-14" "JP-22" "JP-23" "JP-24" "JP-30" "JP-27" "JP-33"
## [37] "JP-34" "JP-01" "JP-47" "JP-10" "JP-20" "JP-09" "JP-21" "JP-25" "JP-11"
## [46] "JP-19" "JP-29"
```

　こちらは文字列となっていますね。これを左から4番目の文字から切り取り、数値型に変換します。変換したコードは結合のために`Code`という名の列として追加しましょう。


```{.r .numberLines}
Japan_Map <- Japan_Map %>%
    mutate(Code = str_sub(iso_3166_2, 4),
           Code = as.numeric(Code))

Japan_Map$Code
```

```
##  [1] 46 44 40 41 42 43 45 36 37 38 39 32 35 31 28 26 18 17 16 15  6  5  2  3  4
## [26]  7  8 12 13 14 22 23 24 30 27 33 34  1 47 10 20  9 21 25 11 19 29
```

　続いて、`Japan_Map`と`Japan_Density`を`Code`列をキー変数として結合します。データの中身を確認すると、`Density`列が最後(の直前)の列に追加されたことが分かります。


```{.r .numberLines}
Japan_Map <- left_join(Japan_Map, Japan_Density, by = "Code")

Japan_Map
```

```
## Simple feature collection with 47 features and 86 fields
## Geometry type: MULTIPOLYGON
## Dimension:     XY
## Bounding box:  xmin: 122.9382 ymin: 24.2121 xmax: 153.9856 ymax: 45.52041
## Geodetic CRS:  SOURCECRS
## First 10 features:
##            featurecla scalerank adm1_code diss_me iso_3166_2 wikipedia iso_a2
## 1  Admin-1 scale rank         2  JPN-3501    3501      JP-46      <NA>     JP
## 2  Admin-1 scale rank         6  JPN-1835    1835      JP-44      <NA>     JP
## 3  Admin-1 scale rank         6  JPN-1829    1829      JP-40      <NA>     JP
## 4  Admin-1 scale rank         6  JPN-1827    1827      JP-41      <NA>     JP
## 5  Admin-1 scale rank         2  JPN-3500    3500      JP-42      <NA>     JP
## 6  Admin-1 scale rank         6  JPN-1830    1830      JP-43      <NA>     JP
## 7  Admin-1 scale rank         6  JPN-1831    1831      JP-45      <NA>     JP
## 8  Admin-1 scale rank         6  JPN-1836    1836      JP-36      <NA>     JP
## 9  Admin-1 scale rank         6  JPN-1833    1833      JP-37      <NA>     JP
## 10 Admin-1 scale rank         6  JPN-1832    1832      JP-38      <NA>     JP
##    adm0_sr      name name_alt name_local type    type_en code_local code_hasc
## 1        5 Kagoshima     <NA>       <NA>  Ken Prefecture       <NA>     JP.KS
## 2        1      Oita     <NA>       <NA>  Ken Prefecture       <NA>     JP.OT
## 3        1   Fukuoka  Hukuoka       <NA>  Ken Prefecture       <NA>     JP.FO
## 4        1      Saga     <NA>       <NA>  Ken Prefecture       <NA>     JP.SG
## 5        3  Nagasaki     <NA>       <NA>  Ken Prefecture       <NA>     JP.NS
## 6        1  Kumamoto     <NA>       <NA>  Ken Prefecture       <NA>     JP.KM
## 7        1  Miyazaki     <NA>       <NA>  Ken Prefecture       <NA>     JP.MZ
## 8        1 Tokushima Tokusima       <NA>  Ken Prefecture       <NA>     JP.TS
## 9        1    Kagawa     <NA>       <NA>  Ken Prefecture       <NA>     JP.KG
## 10       4     Ehime     <NA>       <NA>  Ken Prefecture       <NA>     JP.EH
##    note hasc_maybe  region region_cod provnum_ne gadm_level check_me datarank
## 1  <NA>      JP.NR  Kyushu    JPN-KYS          3          1       20        9
## 2  <NA>      JP.ON  Kyushu    JPN-SHK         48          1       20        2
## 3  <NA>      JP.NS  Kyushu    JPN-KYS         46          1       20        2
## 4  <NA>      JP.OS    <NA>       <NA>         47          1       20        2
## 5  <NA>      JP.OY    <NA>       <NA>          5          1       20        9
## 6  <NA>      JP.NI  Kyushu    JPN-KYS          6          1       20        2
## 7  <NA>      JP.OT  Kyushu    JPN-KYS         49          1       20        2
## 8  <NA>      JP.SZ Shikoku    JPN-SHK         45          1       20        2
## 9  <NA>      JP.SH Shikoku    JPN-SHK          4          1       20        2
## 10 <NA>      JP.ST Shikoku    JPN-SHK         14          1       20        2
##    abbrev postal area_sqkm sameascity labelrank name_len mapcolor9 mapcolor13
## 1    <NA>   <NA>         0         NA         2        9         5          4
## 2    <NA>     OT         0          7         7        4         5          4
## 3    <NA>     FO         0          7         7        7         5          4
## 4    <NA>     SG         0         NA         6        4         5          4
## 5    <NA>   <NA>         0         NA         2        8         5          4
## 6    <NA>     KM         0         NA         6        8         5          4
## 7    <NA>     MZ         0         NA         6        8         5          4
## 8    <NA>     TS         0         NA         6        9         5          4
## 9    <NA>     KG         0         NA         6        6         5          4
## 10   <NA>     EH         0         NA         6        5         5          4
##    fips fips_alt   woe_id                       woe_label  woe_name latitude
## 1  JA18     JA28  2345867 Kagoshima Prefecture, JP, Japan Kagoshima  29.4572
## 2  JA30     JA47  2345879      Oita Prefecture, JP, Japan      Oita  33.2006
## 3  JA07     JA27 58646425   Fukuoka Prefecture, JP, Japan   Fukuoka  33.4906
## 4  JA33     JA32  2345882      Saga Prefecture, JP, Japan      Saga  33.0097
## 5  JA27     JA31  2345876  Nagasaki Prefecture, JP, Japan  Nagasaki  32.6745
## 6  JA21     JA29  2345870  Kumamoto Prefecture, JP, Japan  Kumamoto  32.5880
## 7  JA25     JA30  2345874  Miyazaki Prefecture, JP, Japan  Miyazaki  32.0981
## 8  JA39     JA37  2345888 Tokushima Prefecture, JP, Japan Tokushima  33.8546
## 9  JA17     JA35  2345866    Kagawa Prefecture, JP, Japan    Kagawa  34.2162
## 10 JA05     JA34  2345855     Ehime Prefecture, JP, Japan     Ehime  33.8141
##    longitude sov_a3 adm0_a3 adm0_label admin geonunit gu_a3   gn_id
## 1    129.601    JPN     JPN          4 Japan    Japan   JPN 1860825
## 2    131.449    JPN     JPN          4 Japan    Japan   JPN 1854484
## 3    130.616    JPN     JPN          4 Japan    Japan   JPN 1863958
## 4    130.147    JPN     JPN          4 Japan    Japan   JPN 1853299
## 5    128.755    JPN     JPN          4 Japan    Japan   JPN 1856156
## 6    130.834    JPN     JPN          4 Japan    Japan   JPN 1858419
## 7    131.286    JPN     JPN          4 Japan    Japan   JPN 1856710
## 8    134.200    JPN     JPN          4 Japan    Japan   JPN 1850157
## 9    134.001    JPN     JPN          4 Japan    Japan   JPN 1860834
## 10   132.916    JPN     JPN          4 Japan    Japan   JPN 1864226
##          gn_name  gns_id      gns_name gn_level gn_region gn_a1_code region_sub
## 1  Kagoshima-ken -231556 Kagoshima-ken        1      <NA>      JP.18       <NA>
## 2       Oita-ken -240089      Oita-ken        1      <NA>      JP.30       <NA>
## 3    Fukuoka-ken -227382   Fukuoka-ken        1      <NA>      JP.07       <NA>
## 4       Saga-ken -241905      Saga-ken        1      <NA>      JP.33       <NA>
## 5   Nagasaki-ken -237758  Nagasaki-ken        1      <NA>      JP.27       <NA>
## 6   Kumamoto-ken -234759  Kumamoto-ken        1      <NA>      JP.21       <NA>
## 7   Miyazaki-ken -236958  Miyazaki-ken        1      <NA>      JP.25       <NA>
## 8  Tokushima-ken -246216 Tokushima-ken        1      <NA>      JP.39       <NA>
## 9     Kagawa-ken -231546    Kagawa-ken        1      <NA>      JP.17       <NA>
## 10     Ehime-ken -227007     Ehime-ken        1      <NA>      JP.05       <NA>
##    sub_code gns_level gns_lang gns_adm1 gns_region min_label max_label min_zoom
## 1      <NA>         1      jpn     JA18       <NA>         7        11        3
## 2      <NA>         1      jpn     JA30       <NA>         7        11        3
## 3      <NA>         1      jpn     JA07       <NA>         7        11        3
## 4      <NA>         1      jpn     JA33       <NA>         7        11        3
## 5      <NA>         1      jpn     JA27       <NA>         7        11        3
## 6      <NA>         1      jpn     JA21       <NA>         7        11        3
## 7      <NA>         1      jpn     JA25       <NA>         7        11        3
## 8      <NA>         1      jpn     JA39       <NA>         7        11        3
## 9      <NA>         1      jpn     JA17       <NA>         7        11        3
## 10     <NA>         1      jpn     JA05       <NA>         7        11        3
##    wikidataid name_ar name_bn             name_de              name_en
## 1      Q15701    <NA>    <NA> Präfektur Kagoshima Kagoshima Prefecture
## 2     Q133924    <NA>    <NA>      Präfektur Oita      Oita Prefecture
## 3     Q123258    <NA>    <NA>   Präfektur Fukuoka   Fukuoka Prefecture
## 4     Q160420    <NA>    <NA>      Präfektur Saga      Saga Prefecture
## 5     Q169376    <NA>    <NA>  Präfektur Nagasaki  Nagasaki Prefecture
## 6     Q130308    <NA>    <NA>  Präfektur Kumamoto  Kumamoto Prefecture
## 7     Q130300    <NA>    <NA>  Präfektur Miyazaki  Miyazaki Prefecture
## 8     Q160734    <NA>    <NA> Präfektur Tokushima Tokushima Prefecture
## 9     Q161454    <NA>    <NA>    Präfektur Kagawa    Kagawa Prefecture
## 10    Q123376    <NA>    <NA>     Präfektur Ehime     Ehime Prefecture
##                    name_es                 name_fr name_el name_hi
## 1  Prefectura de Kagoshima Préfecture de Kagoshima    <NA>    <NA>
## 2       Prefectura de Oita       Préfecture d'Oita    <NA>    <NA>
## 3    Prefectura de Fukuoka   Préfecture de Fukuoka    <NA>    <NA>
## 4       Prefectura de Saga      Préfecture de Saga    <NA>    <NA>
## 5   Prefectura de Nagasaki  Préfecture de Nagasaki    <NA>    <NA>
## 6   Prefectura de Kumamoto  Préfecture de Kumamoto    <NA>    <NA>
## 7   Prefectura de Miyazaki  Préfecture de Miyazaki    <NA>    <NA>
## 8  Prefectura de Tokushima Préfecture de Tokushima    <NA>    <NA>
## 9     Prefectura de Kagawa    Préfecture de Kagawa    <NA>    <NA>
## 10     Prefectura de Ehime      Préfecture d'Ehime    <NA>    <NA>
##                 name_hu             name_id                 name_it name_ja
## 1   Kagosima prefektúra Prefektur Kagoshima prefettura di Kagoshima    <NA>
## 2       Óita prefektúra      Prefektur Oita      prefettura di Oita    <NA>
## 3    Fukuoka prefektúra   Prefektur Fukuoka   prefettura di Fukuoka    <NA>
## 4      Szaga prefektúra      Prefektur Saga      Prefettura di Saga    <NA>
## 5  Nagaszaki prefektúra  Prefektur Nagasaki  prefettura di Nagasaki    <NA>
## 6   Kumamoto prefektúra  Prefektur Kumamoto  prefettura di Kumamoto    <NA>
## 7   Mijazaki prefektúra  Prefektur Miyazaki  prefettura di Miyazaki    <NA>
## 8   Tokusima prefektúra Prefektur Tokushima prefettura di Tokushima    <NA>
## 9     Kagava prefektúra    Prefektur Kagawa    prefettura di Kagawa    <NA>
## 10     Ehime prefektúra     Prefektur Ehime     prefettura di Ehime    <NA>
##    name_ko   name_nl              name_pl   name_pt name_ru             name_sv
## 1     <NA> Kagoshima Prefektura Kagoshima Kagoshima    <NA> Kagoshima prefektur
## 2     <NA>      Oita      Prefektura Oita      Oita    <NA>      Oita prefektur
## 3     <NA>   Fukuoka   Prefektura Fukuoka   Fukuoka    <NA>   Fukuoka prefektur
## 4     <NA>      Saga      Prefektura Saga      Saga    <NA>      Saga prefektur
## 5     <NA>  Nagasaki  Prefektura Nagasaki  Nagasaki    <NA>  Nagasaki prefektur
## 6     <NA>  Kumamoto  Prefektura Kumamoto  Kumamoto    <NA>  Kumamoto prefektur
## 7     <NA>  Miyazaki  Prefektura Miyazaki  Miyazaki    <NA>  Miyazaki prefektur
## 8     <NA> Tokushima Prefektura Tokushima Tokushima    <NA> Tokushima prefektur
## 9     <NA>    Kagawa    Prefektura Kagawa    Kagawa    <NA>    Kagawa prefektur
## 10    <NA>     Ehime     Prefektura Ehime     Ehime    <NA>     Ehime prefektur
##         name_tr   name_vi name_zh      ne_id Code     Name Density
## 1  Kagosima ili Kagoshima    <NA> 1159315225   46 鹿児島県   172.9
## 2          Oita      Oita    <NA> 1159311905   44   大分県   177.2
## 3       Fukuoka   Fukuoka    <NA> 1159311899   40   福岡県  1029.8
## 4          Saga      Saga    <NA> 1159311895   41   佐賀県   332.5
## 5      Nagasaki  Nagasaki    <NA> 1159315235   42   長崎県   317.7
## 6      Kumamoto  Kumamoto    <NA> 1159311901   43   熊本県   234.6
## 7      Miyazaki  Miyazaki    <NA> 1159311903   45   宮崎県   138.3
## 8     Tokushima Tokushima    <NA> 1159311909   36   徳島県   173.5
## 9        Kagawa    Kagawa    <NA> 1159311907   37   香川県   506.3
## 10        Ehime     Ehime    <NA> 1159311139   38   愛媛県   235.2
##                          geometry
## 1  MULTIPOLYGON (((129.7832 31...
## 2  MULTIPOLYGON (((131.2009 33...
## 3  MULTIPOLYGON (((130.0363 33...
## 4  MULTIPOLYGON (((129.8145 33...
## 5  MULTIPOLYGON (((130.2041 32...
## 6  MULTIPOLYGON (((130.3446 32...
## 7  MULTIPOLYGON (((131.8723 32...
## 8  MULTIPOLYGON (((134.4424 34...
## 9  MULTIPOLYGON (((133.5919 34...
## 10 MULTIPOLYGON (((132.6399 32...
```

　それではマッピングをしてみましょう。人口密度を5つのカテゴリーに順序付きfactor化してから、そのカテゴリーに応じて色塗りをします。


```{.r .numberLines}
Japan_Map %>%
    mutate(Density2 = case_when(Density >= 3000 ~ "3000人以上",
                                Density >= 1000 ~ "1000人以上",
                                Density >=  500 ~ "500人以上",
                                Density >=  100 ~ "100人以上",
                                TRUE            ~ "100人未満"),
           Density2 = factor(Density2, ordered = TRUE,
                             levels = c("3000人以上", "1000人以上", "500人以上",
                                        "100人以上", "100人未満"))) %>%
    ggplot() +
    geom_sf(aes(fill = Density2)) +
    labs(fill = "人口密度 (km^2)") +
    theme_void(base_family = "HiraginoSans-W3")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-map18-1} \end{center}

　世界地図でも同じやり方でデータの結合が可能です。この場合はISO3コードかISO2コードがキー変数となります。ISO3コードは`iso_a3`、ISO2コードは`iso_a2`列に格納されています。他に使用可能なキー変数は`iso_n3`であり、こちらは各国を識別する3桁の数字となります。

### 日本地図（特定の都道府県）

　また日本地図のマッピングですが、今回は市区町村レベルまで見てみましょう。`ne_states()`では市区町村までマッピングすることはできませんので、今回は徳島大学の[瓜生真也](https://twitter.com/u_ribo)先生が公開しました{jpndistrict}を使います。


```{.r .numberLines}
pacman::p_load_gh("uribo/jpndistrict")
```

　今回は大阪府の地図を出力してみましょう。特定の都道府県の地図を読み込むためには`jpn_pref()`関数を使用します。都道府県は`pref_code`または`admin_name`で指定します。大阪のコードは27であるため、`pref_code = 27`でも良いですし、`admin_name = "大阪府"`でも同じです。


```{.r .numberLines}
# Osaka_map <- jpn_pref(admin_name = "大阪府") でも同じ
Osaka_map <- jpn_pref(pref_code = 27)

class(Osaka_map)
```

```
## [1] "sf"         "tbl_df"     "tbl"        "data.frame"
```

　プロットの方法は同じです。


```{.r .numberLines}
Osaka_map %>%
  ggplot() +
  geom_sf() +
  theme_minimal()
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-map21-1} \end{center}

　ここでもデータの結合&マッピングが可能です。大阪府内自治体の人口と学生数が格納された[データ](data/Osaka_Student.csv)を読み込んでみましょう。こちらは2015年国勢調査の結果から取得したデータです。


```{.r .numberLines}
Osaka_Student <- read_csv("data/Osaka_Student.csv")
```

```
## Rows: 75 Columns: 4
## -- Column specification --------------------------------------------------------
## Delimiter: ","
## chr (1): Name
## dbl (3): Code, Pop, Student
## 
## i Use `spec()` to retrieve the full column specification for this data.
## i Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```{.r .numberLines}
Osaka_Student
```

```
## # A tibble: 75 x 4
##     Code Name                Pop Student
##    <dbl> <chr>             <dbl>   <dbl>
##  1 27000 大阪府          8839469  438901
##  2 27100 大阪市          2691185  104208
##  3 27102 大阪市 都島区    104727    3889
##  4 27103 大阪市 福島区     72484    2448
##  5 27104 大阪市 此花区     66656    2478
##  6 27106 大阪市 西区       92430    2633
##  7 27107 大阪市 港区       82035    3072
##  8 27108 大阪市 大正区     65141    2627
##  9 27109 大阪市 天王寺区   75729    3480
## 10 27111 大阪市 浪速区     69766    1409
## # ... with 65 more rows
```

　各市区町村にもコードが指定されており、`Osaka_Student`では`Code`列、`Osaka_map`では`citi_code`列となります。`Osaka_map`の`city_code`は文字列であるため、こちらを数値型に変換し`Code`という名の列として追加しておきましょう。続いて、`Code`列をキー変数とし、2つのデータセットを結合します。


```{.r .numberLines}
Osaka_map <- Osaka_map %>%
    mutate(Code = as.numeric(city_code))

Osaka_map <- left_join(Osaka_map, Osaka_Student, by = "Code")
```

　最後にマッピングです。ここでは人口1万人当たり学生数を`Student_Ratio`という列として追加し、こちらの値に合わせて色塗りをしてみましょう。`scale_fill_gradient()`を使用し、人口1万人当たり学生数が少ないほど白、多いほど黒塗りします。


```{.r .numberLines}
Osaka_map %>%
  mutate(Student_Ratio = Student / Pop * 10000) %>%
  ggplot() +
  geom_sf(aes(fill = Student_Ratio)) +
  scale_fill_gradient(low = "white", high = "black") +
  labs(fill = "1万人当たり学生数 (人)") +
  theme_minimal(base_family = "HiraginoSans-W3") +
  theme(legend.position = "bottom")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-map24-1} \end{center}

---

## 非巡回有向グラフ {#visual4-dag}

　近年、因果推論の界隈でよく登場する非巡回有向グラフ（DAG）ですが、「グラフ」からも分かるように、DAGの考え方に基づく因果推論の研究には多くの図が登場します。DAGを作図するには{ggplot2}のみでも可能ですが、{dagitty}パッケージでDAGの情報を含むオブジェクトを生成し、{ggdag}で作図した方が簡単です。以下の図はDAGの一例です。


\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-dag1-1} \end{center}

　ここでX、Y、Zはノード（node）と呼ばれ、それぞれのノードをつなぐ線のことをエッジ（edge）と呼びます。また、これらのエッジには方向があります（有向）。簡単に言うと原因と結果といった関係ですが、DAGを描く際は、各ノード間の関係を記述する必要があります。

　それではまず、以上の図を作ってみましょう。最初のステップとして{dagitty}と{ggdag}をインストールし、読み込みましょう。


```{.r .numberLines}
pacman::p_load(dagitty, ggdag)
```

　つづいて、DAGの情報を含むオブジェクトを作成します。使用する関数は`dagify()`であり、ここには`結果 ~ 原因`の形で各ノード間の関係を記述します。先ほどの図では`X`は`Y`の原因（`X ~ Y`）、`Z`は`X`と`Y`の原因（`X ~ Z`と`Y ~ Z`）です。これらの情報を`dagify()`内で指定します。


```{.r .numberLines}
DAG_data1 <- dagify(X ~ Z,
                    Y ~ Z,
                    Y ~ X,
                    exposure = "X",
                    outcome  = "Y")

DAG_data1
```

```
## dag {
## X [exposure]
## Y [outcome]
## Z
## X -> Y
## Z -> X
## Z -> Y
## }
```

　`Y ~ X`と`Y ~ Z`は`Y ~ X + Z`とまとめることも可能です。これは「`Y`の原因は`X`と`Z`である」という意味であり、「`Y`の原因は`X`であり、`Y`の原因は`Z`である」と同じ意味です。また、DAGを作図する際、`dagify()`内に`exposure`と`outcome`は不要ですが、もし`adjustmentSets()`関数などを使って統制変数を特定したい場合は処置変数（`exposure`）と応答変数（`outcome`）にそれぞれ変数名を指定します。ちなみに、以上のコードは以下のように書くことも可能です。


```{.r .numberLines}
DAG_data1 <- dagitty(
  "dag{
  X -> Y
  X <- Z -> Y
  X [exposure]
  Y [outcome]
  }")

DAG_data1
```

```
## dag {
## X [exposure]
## Y [outcome]
## Z
## X -> Y
## Z -> X
## Z -> Y
## }
```

　格納された`DAG_data1`オブジェクトのクラスは`"dagitty"`です。`"dagitty"`の可視化には{ggdag}の`ggdag()`を使用します。


```{.r .numberLines}
DAG_data1 %>%
  ggdag()
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-dag5-1} \end{center}

　DAGにおいて背景、軸の目盛り、ラベルは不要ですので、`theme_dag_blank()`テーマを指定して全て除去します。


```{.r .numberLines}
DAG_data1 %>%
  ggdag() +
  theme_dag_blank()
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-dag6-1} \end{center}

### ノードの位置を指定する

　読者の多くは以上のグラフと異なるものが得られたかも知れません。ノード間の関係は同じはずですが、ノードの位置が異なるでしょう。また、同じコードを実行する度にノードの位置は変わります。以下ではノードの位置を固定する方法について紹介します。位置を指定するには`dagify()`内で`coords`引数に各ノードの情報が格納されたリスト型オブジェクトを指定する必要があります。リストの長さは2であり、それぞれの名前は`x`と`y`です。そしてリストの各要素にはベクトルが入ります。たとえば、ノード`X`の位置を (1, 1)、`Y`の位置を (3, 1)、`Z`の位置を (2, 2)に指定してみましょう。`dagify()`内で直接リストを書くことも可能ですが、コードの可読性が落ちるため、別途のオブジェクト（`DAG_Pos2`）として格納しておきます。


```{.r .numberLines}
DAG_Pos2  <- list(x = c(X = 1, Y = 3, Z = 2),
                  y = c(X = 1, Y = 1, Z = 2))
```

　続いて、`dagify()`内で`coords`引数を追加し、ノードの位置情報が格納されている`DAG_Pos2`を指定します。


```{.r .numberLines}
DAG_data2 <- dagify(X ~ Z,
                    Y ~ X + Z,
                    exposure = "X",
                    outcome  = "Y",
                    coords   = DAG_Pos2)

DAG_data2
```

```
## dag {
## X [exposure,pos="1.000,1.000"]
## Y [outcome,pos="3.000,1.000"]
## Z [pos="2.000,2.000"]
## X -> Y
## Z -> X
## Z -> Y
## }
```

　可視化の方法は同じです。


```{.r .numberLines}
DAG_data2 %>%
  ggdag() +
  theme_dag_blank()
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-dag9-1} \end{center}

　以上の使い方だけでも、ほとんどのDAGは描けるでしょう。また、ノードを若干オシャレ（?）にするには、`ggdag()`内で`stylized = TRUE`を指定します。


```{.r .numberLines}
DAG_Pos3  <- list(x = c(X1 = 3, X2 = 3, X3 = 1, T = 2, Y = 4),
                  y = c(X1 = 1, X2 = 2, X3 = 2, T = 3, Y = 3))

DAG_data3 <- dagify(Y  ~ T + X1 + X2,
                    T  ~ X3,
                    X2 ~ T +X1 + X3,
                    exposure = "T",
                    outcome  = "Y",
                    coords   = DAG_Pos3)

DAG_data3 %>%
  ggdag(stylized = TRUE) +
  theme_dag_blank()
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-dag10-1} \end{center}

　可視化の話ではありませんが、`adjustmentSets()`関数を用いると、処置変数`T`の総効果（total effect）を推定するためにはどの変数を統制（調整）する必要があるかを調べることも可能です。


```{.r .numberLines}
adjustmentSets(DAG_data3, effect = "total")
```

```
## { X3 }
```

　`X3`変数のみ統制すれば良いという結果が得られました。また、`T`から`Y`への直接効果（direct effect）の場合、`effect = "direct"`を指定します。


```{.r .numberLines}
adjustmentSets(DAG_data3, effect = "direct")
```

```
## { X1, X2 }
```

　`X1`と`X2`を統制する必要があることが分かりますね。

---

## バンプチャート {#visual4-bump}

　バンプチャート (bump chart)は順位の変化などを示す時に有効なグラフです。たとえば、G7構成国の新型コロナ感染者数の順位の変化を示すにはどうすれば良いでしょうか。そもそもどのような形式のデータが必要でしょうか。まずは必要なデータ形式を紹介したいと思います。

　まず、{ggplot2}によるバンプチャートの作成を支援する{ggbump}パッケージをインストールし、読み込みましょう[^bump1]。

[^bump1]: これから登場する`geom_bump()`幾何オブジェクトが使えるようになります。{ggbump}を使用せず、{ggplot2}が提供する`geom_line()`でも代替可能です。`geom_line()`の場合、直線で順位の変化が表示され、`geom_bump()`の場合は曲線で表示されます。丸い感じの図を好まない方なら、{ggbump}を読み込まず、`geom_bump()`を`geom_line()`に書き換えてください。


```{.r .numberLines}
pacman::p_load(ggbump)
```

　ここではG7構成国の100万人当り新型コロナ感染者数の順位がどのように変化したのかを2020年4月から7月まで1ヶ月単位で表したデータが必要です。データは以下のようなコードで作成しますが、[本書のサポートページ](https://github.com/JaehyunSong/RBook)からもダウンロード可能です。


```{.r .numberLines}
Bump_df <- left_join(COVID19_df, Country_df, by = "Country") %>%
  select(Country, Date, Population, Confirmed_Total, G7) %>%
  separate(Date, into = c("Year", "Month", "Day"), sep = "/") %>%
  mutate(Month = as.numeric(Month)) %>%
  filter(Month >= 4, G7 == 1) %>%
  group_by(Country, Month) %>%
  summarise(Population            = mean(Population),
            New_Cases             = sum(Confirmed_Total, na.rm = TRUE),
            New_Cases_per_million = New_Cases / Population * 1000000,
            .groups               = "drop") %>%
  select(Country, Month, New_Cases_per_million)
```


```{.r .numberLines}
Bump_df <- Bump_df %>%
  group_by(Month) %>%
  mutate(Rank = rank(New_Cases_per_million, ties.method = "random")) %>%
  ungroup() %>%
  select(Country, Month, Rank, New_Cases_per_million)
```

　必要なデータは以下のような形式です。ちなみにバンプチャートを作成するためには最後の`New_Cases_per_million`列 (100万人当り新型コロナ感染者数)は不要です。つまり、国名、月、順位のみで十分です。

```r
# 以上のコードを省略し、加工済みのデータを読み込んでもOK
# Bump_df <- read_csv("Data/Bumpchart.csv")
Bump_df
```


```
## PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.
```

```{=html}
<div id="htmlwidget-1c8b8a8fe4fbb23d5799" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-1c8b8a8fe4fbb23d5799">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28"],["Canada","Canada","Canada","Canada","France","France","France","France","Germany","Germany","Germany","Germany","Italy","Italy","Italy","Italy","Japan","Japan","Japan","Japan","United Kingdom","United Kingdom","United Kingdom","United Kingdom","United States","United States","United States","United States"],[4,5,6,7,4,5,6,7,4,5,6,7,4,5,6,7,4,5,6,7,4,5,6,7,4,5,6,7],[2,2,3,3,5,4,4,4,3,3,2,2,7,6,5,5,1,1,1,1,4,5,6,6,6,7,7,7],[24637.9154724449,62787.0894703042,79922.1210320958,28516.76139099,54618.9011745094,81421.0565109242,85834.8084016522,30116.9264854476,47060.6288732512,64783.4760508165,67683.1605750897,23598.8299524031,81514.6403285935,114367.419204309,117681.394538101,39973.3378876119,2257.49517137422,4100.01984479942,4324.67034320323,1622.05677149679,48576.4676505625,102407.379263796,119872.185871719,41919.1582848447,58486.8693972508,135824.160741713,194232.174864135,87484.5641143518]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Country<\/th>\n      <th>Month<\/th>\n      <th>Rank<\/th>\n      <th>New_Cases_per_million<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[2,3,4]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```

　それでは{ggbump}が提供する`geom_bump()`幾何オブジェクトを使用し、簡単なバンプチャートを作成してみましょう。必要なマッピング要素は`x`と`y`、`color`です。`x`には時間を表す変数である`Month`を、`y`には順位を表す`Rank`をマッピングします。また、7本の線が出るため、月と順位、それぞれの値がどの国の値かを特定する必要があります。`groups`に国名である`Country`をマッピングしても線は引けますが、どの線がどの国かが分からなくなるため、`color`に`Country`をマッピングし、線の色分けをします。


```{.r .numberLines}
Bump_df %>%
  ggplot(aes(x = Month, y = Rank, color = Country)) +
  geom_bump()
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-bump5-1} \end{center}

　これで最低限のバンプチャートはできましたが、もう少し見やすく、可愛くしてみましょう。今は線が細いのでややぶ厚めにします。これは`geom_bump()`レイヤーの`size`引数で指定可能です。また、各月に点を付けることによって、同時期における順位の比較をよりしやすくしてみましょう。これは散布図と同じであるため、`geom_point()`幾何オブジェクトを使用します。


```{.r .numberLines}
Bump_df %>%
  ggplot(aes(x = Month, y = Rank, color = Country)) +
  geom_point(size = 7) +
  geom_bump(size = 2) +
  theme_minimal(base_size = 14)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-bump6-1} \end{center}

　これでだいぶ見やすくなりましたが、凡例における国名の順番がやや気になりますね。7月の時点において順位が最も高い国はアメリカ、最も低い国は日本ですが、凡例の順番はアルファベット順となっています。この凡例の順番を7月時点における`Rank`の値に合わせた方がより見やすいでしょう。ここで第\@ref(factor-forcat-reorder2)で紹介しました`fct_reorder2()`を使って`Country`変数の水準 (level)を7月時点における`Rank`の順位に合わせます。この場合、`Country`変数 (`.f = Country`)の水準を`Month`が (`.x = Month`)最も大きい (`.fun = last2`)時点における`Rank`の順番に合わせる (`.y = Rank`)こととなります。`fct_reorder2()`内の引数の順番の既定値は`.f`、`.x`、`.y`、`.fun`となります。


```{.r .numberLines}
Bump_df %>%
  mutate(Country = fct_reorder2(Country, Month, Rank, last2)) %>%
  ggplot(aes(x = Month, y = Rank, color = Country)) +
  geom_point(size = 7) +
  geom_bump(size = 2) +
  theme_minimal(base_size = 14)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-bump7-1} \end{center}

　最後に縦軸の目盛りラベルを付けます。上に行くほど順位が高くなりますので、1を7に、2を6に、...、7を1に変更します。また、図内のグリッドも不要ですので、`theme()`を使用し、グリッドを削除します (`panel.grid = element_blank()`)。


```{.r .numberLines}
Bump_df %>%
  mutate(Country = fct_reorder2(Country, Month, Rank, last2)) %>%
  ggplot(aes(x = Month, y = Rank, color = Country)) +
  geom_point(size = 7) +
  geom_bump(size = 2) +
  scale_y_continuous(breaks = 1:7, labels = 7:1) +
  theme_minimal(base_size = 14) +
  theme(panel.grid = element_blank())
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-bump8-1} \end{center}

　これでバンプチャートの完成です。このままでの良いかも知れませんが、もう少し手間を掛けることでより読みやすいグラフが作れます。たとえば、今のままだと「日本のトレンド」を確認したい場合、まず凡例から日本の色を確認し、その色に該当する点と線を見つけてトレンドを見る必要がありますね。もし、ここで図の左端と右端の点の横に国名を出力すると、凡例がなくても良いですし、4月の時点から日本のトレンドを確認することも、7月の時点から遡る形で日本のトレンドを確認することも可能かも知れません。

　図に文字列を追加するためには`geom_text()`幾何オブジェクトを使用します。マッピング要素は文字列の横軸上の位置 (`x`)、縦軸上の位置 (`y`)、そして出力する文字列 (`label`)です。左端に文字列を出力するのであれば、横軸上の位置は4 (= 4月)よりも若干左側が良いでしょう。ぴったり4になると、点と文字列が重なって読みにくくなりますね。縦軸上の位置は**4月の時点**での順位 (`Rank`)で、出力する文字列は国名 (`Country`)です。現在、使用しているデータは4月から7月までのデータですが、4月に限定したデータを使いたいので、`geom_text()`内に`data`引数を追加し、`Bump_df`から`Month`の値が4の行のみを抽出したデータを割り当てます (`data = filter(Bump_df, Month == 4`)、または`data = Bump_df %>% filter(Month == 4)`)。右端についても同じです。横軸上の位置は7から右方向へずらし、使用するデータは7月のデータとなります。

　最後にもう一点調整が必要ですが、それは座標系です。図の座標系は`ggplot()`関数で使用するデータに基づきます。`Bump_df`の場合、横軸 (`Month`)は4から7です。しかし、文字列を追加した場合、文字列がすべて出力されないかも知れません。したがって、座標系を横方向に広める必要があります。今回は3から8までに調整します。座標系や文字列の位置調整は出力結果を見ながら、少しずつ調整していきましょう。


```{.r .numberLines}
Bump_df %>%
  ggplot(aes(x = Month, y = Rank, color = Country)) +
  geom_point(size = 7) +
  geom_bump(size = 2) +
  # 4月の時点での行のみ抽出し、xはMonthより0.15分左方向、
  # yはRankの値の位置に国名を出力する。揃える方向は右揃え (hjust = 1)
  geom_text(data = filter(Bump_df, Month == 4),
            aes(x = Month - 0.15, y = Rank, label = Country), hjust = 1) +
  # 7月の時点での行のみ抽出し、xはMonthより0.15分右方向、
  # yはRankの値の位置に国名を出力する。揃える方向は左揃え (hjust = 0)
  geom_text(data = filter(Bump_df, Month == 7),
            aes(x = Month + 0.15, y = Rank, label = Country), hjust = 0) +
  # 座標系の調整
  coord_cartesian(xlim = c(3, 8)) +
  scale_x_continuous(breaks = 4:7, labels = 4:7) +
  scale_y_continuous(breaks = 1:7, labels = 7:1) +
  labs(y = "Rank", x = "Month") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none",
        panel.grid      = element_blank())
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-bump9-1} \end{center}

---

## 沖積図 {#visual4-alluvial}

　沖積図 (alluvial plot)は同じ対象を複数回観察したデータ（パネル・データなど）から変化を示すことに適したグラフです。たとえば、同じ回答者を対象に2回世論調査を実施し、1回目調査時の支持政党と2回目調査時の支持政党を変化を見ることも可能です。もし、変化が大きい場合は政党支持態度は弱いこととなりますし、変化が小さい場合は安定していると解釈できるでしょう。

　ここでは2009年の衆院選と2010年の参院選における投票先の変化を沖積図で確認してみたいと思います。まずは、沖積図の作成に特化した{ggalluvial}パッケージをインストールし、読み込みます。


```{.r .numberLines}
pacman::p_load(ggalluvial)
```

　続きまして、実習用データを読み込みます。データは @Nakazawa:2014 の表3を元に筆者 (宋)が作成したものです。


```{.r .numberLines}
Vote_0910 <- read_csv("Data/Vote_09_10.csv")
```

```r
Vote_0910
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["ID"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["Vote09"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Vote10"],"name":[3],"type":["chr"],"align":["left"]}],"data":[{"1":"1","2":"棄権","3":"棄権"},{"1":"2","2":"民主","3":"民主"},{"1":"3","2":"民主","3":"民主"},{"1":"4","2":"自民","3":"民主"},{"1":"5","2":"自民","3":"共産・社民"},{"1":"6","2":"民主","3":"共産・社民"},{"1":"7","2":"その他","3":"その他"},{"1":"8","2":"自民","3":"自民"},{"1":"9","2":"民主","3":"民主"},{"1":"10","2":"共産・社民","3":"共産・社民"},{"1":"11","2":"棄権","3":"自民"},{"1":"12","2":"自民","3":"民主"},{"1":"13","2":"棄権","3":"棄権"},{"1":"14","2":"自民","3":"自民"},{"1":"15","2":"共産・社民","3":"共産・社民"},{"1":"16","2":"DK","3":"共産・社民"},{"1":"17","2":"自民","3":"DK"},{"1":"18","2":"民主","3":"民主"},{"1":"19","2":"民主","3":"民主"},{"1":"20","2":"民主","3":"民主"},{"1":"21","2":"自民","3":"民主"},{"1":"22","2":"DK","3":"民主"},{"1":"23","2":"棄権","3":"自民"},{"1":"24","2":"DK","3":"民主"},{"1":"25","2":"公明","3":"公明"},{"1":"26","2":"DK","3":"公明"},{"1":"27","2":"公明","3":"公明"},{"1":"28","2":"自民","3":"自民"},{"1":"29","2":"自民","3":"自民"},{"1":"30","2":"DK","3":"DK"},{"1":"31","2":"棄権","3":"棄権"},{"1":"32","2":"民主","3":"民主"},{"1":"33","2":"棄権","3":"棄権"},{"1":"34","2":"棄権","3":"棄権"},{"1":"35","2":"棄権","3":"棄権"},{"1":"36","2":"民主","3":"民主"},{"1":"37","2":"その他","3":"民主"},{"1":"38","2":"その他","3":"DK"},{"1":"39","2":"棄権","3":"棄権"},{"1":"40","2":"棄権","3":"棄権"},{"1":"41","2":"民主","3":"民主"},{"1":"42","2":"民主","3":"民主"},{"1":"43","2":"その他","3":"民主"},{"1":"44","2":"DK","3":"自民"},{"1":"45","2":"自民","3":"自民"},{"1":"46","2":"棄権","3":"DK"},{"1":"47","2":"民主","3":"民主"},{"1":"48","2":"民主","3":"民主"},{"1":"49","2":"棄権","3":"棄権"},{"1":"50","2":"棄権","3":"棄権"},{"1":"51","2":"DK","3":"DK"},{"1":"52","2":"公明","3":"公明"},{"1":"53","2":"民主","3":"民主"},{"1":"54","2":"自民","3":"自民"},{"1":"55","2":"自民","3":"自民"},{"1":"56","2":"その他","3":"その他"},{"1":"57","2":"自民","3":"自民"},{"1":"58","2":"DK","3":"民主"},{"1":"59","2":"自民","3":"棄権"},{"1":"60","2":"その他","3":"その他"},{"1":"61","2":"民主","3":"民主"},{"1":"62","2":"自民","3":"自民"},{"1":"63","2":"その他","3":"民主"},{"1":"64","2":"自民","3":"自民"},{"1":"65","2":"民主","3":"民主"},{"1":"66","2":"DK","3":"DK"},{"1":"67","2":"民主","3":"民主"},{"1":"68","2":"棄権","3":"棄権"},{"1":"69","2":"棄権","3":"棄権"},{"1":"70","2":"共産・社民","3":"共産・社民"},{"1":"71","2":"民主","3":"民主"},{"1":"72","2":"民主","3":"民主"},{"1":"73","2":"民主","3":"民主"},{"1":"74","2":"公明","3":"民主"},{"1":"75","2":"民主","3":"民主"},{"1":"76","2":"DK","3":"DK"},{"1":"77","2":"DK","3":"棄権"},{"1":"78","2":"民主","3":"民主"},{"1":"79","2":"棄権","3":"棄権"},{"1":"80","2":"共産・社民","3":"自民"},{"1":"81","2":"その他","3":"民主"},{"1":"82","2":"民主","3":"棄権"},{"1":"83","2":"自民","3":"棄権"},{"1":"84","2":"民主","3":"民主"},{"1":"85","2":"民主","3":"自民"},{"1":"86","2":"棄権","3":"棄権"},{"1":"87","2":"その他","3":"民主"},{"1":"88","2":"民主","3":"民主"},{"1":"89","2":"公明","3":"公明"},{"1":"90","2":"公明","3":"公明"},{"1":"91","2":"自民","3":"自民"},{"1":"92","2":"自民","3":"自民"},{"1":"93","2":"棄権","3":"共産・社民"},{"1":"94","2":"棄権","3":"棄権"},{"1":"95","2":"民主","3":"民主"},{"1":"96","2":"DK","3":"棄権"},{"1":"97","2":"棄権","3":"自民"},{"1":"98","2":"DK","3":"民主"},{"1":"99","2":"棄権","3":"棄権"},{"1":"100","2":"自民","3":"民主"},{"1":"101","2":"その他","3":"民主"},{"1":"102","2":"民主","3":"民主"},{"1":"103","2":"民主","3":"その他"},{"1":"104","2":"民主","3":"民主"},{"1":"105","2":"棄権","3":"民主"},{"1":"106","2":"自民","3":"民主"},{"1":"107","2":"民主","3":"民主"},{"1":"108","2":"その他","3":"DK"},{"1":"109","2":"民主","3":"民主"},{"1":"110","2":"自民","3":"自民"},{"1":"111","2":"その他","3":"自民"},{"1":"112","2":"DK","3":"民主"},{"1":"113","2":"民主","3":"民主"},{"1":"114","2":"民主","3":"民主"},{"1":"115","2":"棄権","3":"民主"},{"1":"116","2":"民主","3":"民主"},{"1":"117","2":"公明","3":"自民"},{"1":"118","2":"民主","3":"民主"},{"1":"119","2":"自民","3":"民主"},{"1":"120","2":"民主","3":"民主"},{"1":"121","2":"民主","3":"その他"},{"1":"122","2":"その他","3":"その他"},{"1":"123","2":"自民","3":"自民"},{"1":"124","2":"DK","3":"自民"},{"1":"125","2":"自民","3":"自民"},{"1":"126","2":"共産・社民","3":"DK"},{"1":"127","2":"その他","3":"民主"},{"1":"128","2":"自民","3":"自民"},{"1":"129","2":"自民","3":"自民"},{"1":"130","2":"民主","3":"民主"},{"1":"131","2":"公明","3":"公明"},{"1":"132","2":"棄権","3":"棄権"},{"1":"133","2":"民主","3":"民主"},{"1":"134","2":"公明","3":"公明"},{"1":"135","2":"共産・社民","3":"共産・社民"},{"1":"136","2":"棄権","3":"棄権"},{"1":"137","2":"棄権","3":"棄権"},{"1":"138","2":"自民","3":"民主"},{"1":"139","2":"棄権","3":"棄権"},{"1":"140","2":"棄権","3":"棄権"},{"1":"141","2":"共産・社民","3":"共産・社民"},{"1":"142","2":"民主","3":"民主"},{"1":"143","2":"民主","3":"民主"},{"1":"144","2":"その他","3":"民主"},{"1":"145","2":"公明","3":"公明"},{"1":"146","2":"自民","3":"自民"},{"1":"147","2":"棄権","3":"民主"},{"1":"148","2":"棄権","3":"棄権"},{"1":"149","2":"民主","3":"民主"},{"1":"150","2":"その他","3":"民主"},{"1":"151","2":"民主","3":"民主"},{"1":"152","2":"共産・社民","3":"棄権"},{"1":"153","2":"自民","3":"自民"},{"1":"154","2":"自民","3":"自民"},{"1":"155","2":"棄権","3":"民主"},{"1":"156","2":"棄権","3":"棄権"},{"1":"157","2":"その他","3":"その他"},{"1":"158","2":"民主","3":"民主"},{"1":"159","2":"民主","3":"民主"},{"1":"160","2":"その他","3":"その他"},{"1":"161","2":"民主","3":"DK"},{"1":"162","2":"自民","3":"自民"},{"1":"163","2":"民主","3":"民主"},{"1":"164","2":"民主","3":"民主"},{"1":"165","2":"自民","3":"棄権"},{"1":"166","2":"民主","3":"棄権"},{"1":"167","2":"自民","3":"自民"},{"1":"168","2":"棄権","3":"棄権"},{"1":"169","2":"民主","3":"自民"},{"1":"170","2":"自民","3":"民主"},{"1":"171","2":"民主","3":"民主"},{"1":"172","2":"公明","3":"公明"},{"1":"173","2":"民主","3":"民主"},{"1":"174","2":"民主","3":"民主"},{"1":"175","2":"棄権","3":"民主"},{"1":"176","2":"民主","3":"棄権"},{"1":"177","2":"自民","3":"自民"},{"1":"178","2":"その他","3":"民主"},{"1":"179","2":"民主","3":"共産・社民"},{"1":"180","2":"棄権","3":"棄権"},{"1":"181","2":"DK","3":"民主"},{"1":"182","2":"自民","3":"自民"},{"1":"183","2":"民主","3":"民主"},{"1":"184","2":"民主","3":"民主"},{"1":"185","2":"自民","3":"自民"},{"1":"186","2":"棄権","3":"自民"},{"1":"187","2":"棄権","3":"民主"},{"1":"188","2":"民主","3":"民主"},{"1":"189","2":"自民","3":"自民"},{"1":"190","2":"自民","3":"自民"},{"1":"191","2":"棄権","3":"棄権"},{"1":"192","2":"自民","3":"自民"},{"1":"193","2":"民主","3":"民主"},{"1":"194","2":"棄権","3":"棄権"},{"1":"195","2":"自民","3":"民主"},{"1":"196","2":"民主","3":"民主"},{"1":"197","2":"自民","3":"民主"},{"1":"198","2":"民主","3":"民主"},{"1":"199","2":"民主","3":"民主"},{"1":"200","2":"自民","3":"民主"},{"1":"201","2":"DK","3":"公明"},{"1":"202","2":"民主","3":"自民"},{"1":"203","2":"自民","3":"民主"},{"1":"204","2":"公明","3":"棄権"},{"1":"205","2":"民主","3":"民主"},{"1":"206","2":"自民","3":"自民"},{"1":"207","2":"その他","3":"その他"},{"1":"208","2":"自民","3":"自民"},{"1":"209","2":"自民","3":"民主"},{"1":"210","2":"DK","3":"自民"},{"1":"211","2":"棄権","3":"棄権"},{"1":"212","2":"共産・社民","3":"共産・社民"},{"1":"213","2":"公明","3":"公明"},{"1":"214","2":"DK","3":"棄権"},{"1":"215","2":"民主","3":"民主"},{"1":"216","2":"その他","3":"自民"},{"1":"217","2":"民主","3":"民主"},{"1":"218","2":"DK","3":"民主"},{"1":"219","2":"棄権","3":"民主"},{"1":"220","2":"自民","3":"自民"},{"1":"221","2":"民主","3":"民主"},{"1":"222","2":"その他","3":"民主"},{"1":"223","2":"棄権","3":"棄権"},{"1":"224","2":"自民","3":"自民"},{"1":"225","2":"棄権","3":"棄権"},{"1":"226","2":"自民","3":"民主"},{"1":"227","2":"その他","3":"自民"},{"1":"228","2":"棄権","3":"棄権"},{"1":"229","2":"自民","3":"棄権"},{"1":"230","2":"民主","3":"民主"},{"1":"231","2":"民主","3":"民主"},{"1":"232","2":"自民","3":"民主"},{"1":"233","2":"DK","3":"DK"},{"1":"234","2":"棄権","3":"棄権"},{"1":"235","2":"民主","3":"民主"},{"1":"236","2":"DK","3":"民主"},{"1":"237","2":"民主","3":"民主"},{"1":"238","2":"自民","3":"自民"},{"1":"239","2":"自民","3":"自民"},{"1":"240","2":"自民","3":"民主"},{"1":"241","2":"棄権","3":"棄権"},{"1":"242","2":"民主","3":"民主"},{"1":"243","2":"棄権","3":"自民"},{"1":"244","2":"その他","3":"民主"},{"1":"245","2":"民主","3":"自民"},{"1":"246","2":"民主","3":"民主"},{"1":"247","2":"その他","3":"棄権"},{"1":"248","2":"民主","3":"公明"},{"1":"249","2":"民主","3":"民主"},{"1":"250","2":"公明","3":"公明"},{"1":"251","2":"DK","3":"棄権"},{"1":"252","2":"棄権","3":"自民"},{"1":"253","2":"民主","3":"民主"},{"1":"254","2":"自民","3":"自民"},{"1":"255","2":"棄権","3":"民主"},{"1":"256","2":"棄権","3":"棄権"},{"1":"257","2":"自民","3":"自民"},{"1":"258","2":"自民","3":"自民"},{"1":"259","2":"自民","3":"自民"},{"1":"260","2":"自民","3":"自民"},{"1":"261","2":"棄権","3":"棄権"},{"1":"262","2":"民主","3":"DK"},{"1":"263","2":"棄権","3":"民主"},{"1":"264","2":"民主","3":"民主"},{"1":"265","2":"民主","3":"民主"},{"1":"266","2":"棄権","3":"自民"},{"1":"267","2":"公明","3":"公明"},{"1":"268","2":"自民","3":"棄権"},{"1":"269","2":"DK","3":"DK"},{"1":"270","2":"自民","3":"棄権"},{"1":"271","2":"棄権","3":"棄権"},{"1":"272","2":"民主","3":"民主"},{"1":"273","2":"DK","3":"民主"},{"1":"274","2":"共産・社民","3":"共産・社民"},{"1":"275","2":"共産・社民","3":"棄権"},{"1":"276","2":"棄権","3":"棄権"},{"1":"277","2":"民主","3":"民主"},{"1":"278","2":"自民","3":"自民"},{"1":"279","2":"棄権","3":"民主"},{"1":"280","2":"共産・社民","3":"共産・社民"},{"1":"281","2":"公明","3":"公明"},{"1":"282","2":"棄権","3":"その他"},{"1":"283","2":"民主","3":"民主"},{"1":"284","2":"DK","3":"DK"},{"1":"285","2":"自民","3":"自民"},{"1":"286","2":"民主","3":"民主"},{"1":"287","2":"その他","3":"民主"},{"1":"288","2":"民主","3":"民主"},{"1":"289","2":"DK","3":"民主"},{"1":"290","2":"民主","3":"自民"},{"1":"291","2":"民主","3":"民主"},{"1":"292","2":"民主","3":"民主"},{"1":"293","2":"棄権","3":"棄権"},{"1":"294","2":"民主","3":"民主"},{"1":"295","2":"棄権","3":"DK"},{"1":"296","2":"民主","3":"棄権"},{"1":"297","2":"自民","3":"自民"},{"1":"298","2":"棄権","3":"棄権"},{"1":"299","2":"その他","3":"棄権"},{"1":"300","2":"自民","3":"自民"},{"1":"301","2":"自民","3":"自民"},{"1":"302","2":"民主","3":"民主"},{"1":"303","2":"民主","3":"民主"},{"1":"304","2":"民主","3":"民主"},{"1":"305","2":"DK","3":"民主"},{"1":"306","2":"自民","3":"自民"},{"1":"307","2":"自民","3":"自民"},{"1":"308","2":"自民","3":"自民"},{"1":"309","2":"その他","3":"その他"},{"1":"310","2":"民主","3":"民主"},{"1":"311","2":"DK","3":"民主"},{"1":"312","2":"共産・社民","3":"共産・社民"},{"1":"313","2":"民主","3":"民主"},{"1":"314","2":"民主","3":"民主"},{"1":"315","2":"民主","3":"民主"},{"1":"316","2":"自民","3":"自民"},{"1":"317","2":"棄権","3":"棄権"},{"1":"318","2":"棄権","3":"民主"},{"1":"319","2":"自民","3":"自民"},{"1":"320","2":"民主","3":"民主"},{"1":"321","2":"その他","3":"その他"},{"1":"322","2":"DK","3":"棄権"},{"1":"323","2":"民主","3":"民主"},{"1":"324","2":"棄権","3":"棄権"},{"1":"325","2":"民主","3":"民主"},{"1":"326","2":"民主","3":"民主"},{"1":"327","2":"自民","3":"自民"},{"1":"328","2":"民主","3":"民主"},{"1":"329","2":"その他","3":"その他"},{"1":"330","2":"棄権","3":"民主"},{"1":"331","2":"民主","3":"民主"},{"1":"332","2":"自民","3":"自民"},{"1":"333","2":"DK","3":"民主"},{"1":"334","2":"民主","3":"民主"},{"1":"335","2":"DK","3":"棄権"},{"1":"336","2":"棄権","3":"棄権"},{"1":"337","2":"棄権","3":"棄権"},{"1":"338","2":"その他","3":"その他"},{"1":"339","2":"民主","3":"民主"},{"1":"340","2":"その他","3":"自民"},{"1":"341","2":"自民","3":"棄権"},{"1":"342","2":"棄権","3":"民主"},{"1":"343","2":"自民","3":"DK"},{"1":"344","2":"DK","3":"自民"},{"1":"345","2":"その他","3":"その他"},{"1":"346","2":"民主","3":"民主"},{"1":"347","2":"共産・社民","3":"共産・社民"},{"1":"348","2":"民主","3":"民主"},{"1":"349","2":"自民","3":"自民"},{"1":"350","2":"その他","3":"自民"},{"1":"351","2":"民主","3":"民主"},{"1":"352","2":"民主","3":"民主"},{"1":"353","2":"民主","3":"棄権"},{"1":"354","2":"自民","3":"自民"},{"1":"355","2":"自民","3":"自民"},{"1":"356","2":"民主","3":"自民"},{"1":"357","2":"棄権","3":"民主"},{"1":"358","2":"棄権","3":"棄権"},{"1":"359","2":"民主","3":"民主"},{"1":"360","2":"DK","3":"自民"},{"1":"361","2":"棄権","3":"棄権"},{"1":"362","2":"共産・社民","3":"共産・社民"},{"1":"363","2":"公明","3":"棄権"},{"1":"364","2":"棄権","3":"棄権"},{"1":"365","2":"民主","3":"DK"},{"1":"366","2":"民主","3":"民主"},{"1":"367","2":"公明","3":"棄権"},{"1":"368","2":"民主","3":"民主"},{"1":"369","2":"その他","3":"その他"},{"1":"370","2":"民主","3":"民主"},{"1":"371","2":"民主","3":"民主"},{"1":"372","2":"民主","3":"民主"},{"1":"373","2":"その他","3":"民主"},{"1":"374","2":"民主","3":"民主"},{"1":"375","2":"棄権","3":"棄権"},{"1":"376","2":"DK","3":"民主"},{"1":"377","2":"DK","3":"民主"},{"1":"378","2":"民主","3":"民主"},{"1":"379","2":"民主","3":"民主"},{"1":"380","2":"民主","3":"民主"},{"1":"381","2":"棄権","3":"民主"},{"1":"382","2":"棄権","3":"自民"},{"1":"383","2":"共産・社民","3":"民主"},{"1":"384","2":"自民","3":"民主"},{"1":"385","2":"棄権","3":"DK"},{"1":"386","2":"その他","3":"共産・社民"},{"1":"387","2":"その他","3":"民主"},{"1":"388","2":"自民","3":"民主"},{"1":"389","2":"共産・社民","3":"DK"},{"1":"390","2":"棄権","3":"棄権"},{"1":"391","2":"棄権","3":"共産・社民"},{"1":"392","2":"民主","3":"民主"},{"1":"393","2":"自民","3":"DK"},{"1":"394","2":"DK","3":"共産・社民"},{"1":"395","2":"自民","3":"民主"},{"1":"396","2":"DK","3":"棄権"},{"1":"397","2":"民主","3":"民主"},{"1":"398","2":"民主","3":"民主"},{"1":"399","2":"DK","3":"民主"},{"1":"400","2":"棄権","3":"棄権"},{"1":"401","2":"民主","3":"民主"},{"1":"402","2":"その他","3":"民主"},{"1":"403","2":"民主","3":"民主"},{"1":"404","2":"自民","3":"民主"},{"1":"405","2":"その他","3":"民主"},{"1":"406","2":"民主","3":"民主"},{"1":"407","2":"棄権","3":"棄権"},{"1":"408","2":"棄権","3":"棄権"},{"1":"409","2":"DK","3":"DK"},{"1":"410","2":"自民","3":"自民"},{"1":"411","2":"共産・社民","3":"民主"},{"1":"412","2":"DK","3":"DK"},{"1":"413","2":"民主","3":"民主"},{"1":"414","2":"DK","3":"DK"},{"1":"415","2":"その他","3":"民主"},{"1":"416","2":"その他","3":"その他"},{"1":"417","2":"その他","3":"その他"},{"1":"418","2":"棄権","3":"棄権"},{"1":"419","2":"民主","3":"DK"},{"1":"420","2":"その他","3":"民主"},{"1":"421","2":"自民","3":"民主"},{"1":"422","2":"共産・社民","3":"民主"},{"1":"423","2":"共産・社民","3":"共産・社民"},{"1":"424","2":"民主","3":"民主"},{"1":"425","2":"DK","3":"DK"},{"1":"426","2":"民主","3":"DK"},{"1":"427","2":"民主","3":"民主"},{"1":"428","2":"その他","3":"民主"},{"1":"429","2":"棄権","3":"棄権"},{"1":"430","2":"民主","3":"民主"},{"1":"431","2":"棄権","3":"民主"},{"1":"432","2":"民主","3":"民主"},{"1":"433","2":"民主","3":"民主"},{"1":"434","2":"その他","3":"自民"},{"1":"435","2":"棄権","3":"棄権"},{"1":"436","2":"自民","3":"自民"},{"1":"437","2":"公明","3":"公明"},{"1":"438","2":"民主","3":"自民"},{"1":"439","2":"民主","3":"民主"},{"1":"440","2":"民主","3":"民主"},{"1":"441","2":"DK","3":"民主"},{"1":"442","2":"民主","3":"民主"},{"1":"443","2":"民主","3":"民主"},{"1":"444","2":"民主","3":"民主"},{"1":"445","2":"DK","3":"DK"},{"1":"446","2":"自民","3":"自民"},{"1":"447","2":"その他","3":"民主"},{"1":"448","2":"民主","3":"民主"},{"1":"449","2":"DK","3":"棄権"},{"1":"450","2":"その他","3":"民主"},{"1":"451","2":"民主","3":"民主"},{"1":"452","2":"その他","3":"その他"},{"1":"453","2":"民主","3":"民主"},{"1":"454","2":"民主","3":"自民"},{"1":"455","2":"民主","3":"民主"},{"1":"456","2":"民主","3":"民主"},{"1":"457","2":"公明","3":"公明"},{"1":"458","2":"民主","3":"民主"},{"1":"459","2":"その他","3":"棄権"},{"1":"460","2":"棄権","3":"棄権"},{"1":"461","2":"棄権","3":"棄権"},{"1":"462","2":"DK","3":"民主"},{"1":"463","2":"棄権","3":"棄権"},{"1":"464","2":"民主","3":"民主"},{"1":"465","2":"公明","3":"共産・社民"},{"1":"466","2":"民主","3":"民主"},{"1":"467","2":"棄権","3":"民主"},{"1":"468","2":"棄権","3":"棄権"},{"1":"469","2":"DK","3":"民主"},{"1":"470","2":"自民","3":"自民"},{"1":"471","2":"民主","3":"民主"},{"1":"472","2":"公明","3":"公明"},{"1":"473","2":"民主","3":"DK"},{"1":"474","2":"民主","3":"民主"},{"1":"475","2":"公明","3":"公明"},{"1":"476","2":"民主","3":"民主"},{"1":"477","2":"DK","3":"棄権"},{"1":"478","2":"DK","3":"DK"},{"1":"479","2":"民主","3":"民主"},{"1":"480","2":"自民","3":"自民"},{"1":"481","2":"民主","3":"民主"},{"1":"482","2":"自民","3":"民主"},{"1":"483","2":"棄権","3":"棄権"},{"1":"484","2":"民主","3":"民主"},{"1":"485","2":"棄権","3":"共産・社民"},{"1":"486","2":"民主","3":"民主"},{"1":"487","2":"棄権","3":"民主"},{"1":"488","2":"自民","3":"自民"},{"1":"489","2":"自民","3":"自民"},{"1":"490","2":"民主","3":"民主"},{"1":"491","2":"民主","3":"民主"},{"1":"492","2":"DK","3":"DK"},{"1":"493","2":"民主","3":"民主"},{"1":"494","2":"棄権","3":"民主"},{"1":"495","2":"共産・社民","3":"共産・社民"},{"1":"496","2":"棄権","3":"DK"},{"1":"497","2":"自民","3":"自民"},{"1":"498","2":"公明","3":"自民"},{"1":"499","2":"自民","3":"棄権"},{"1":"500","2":"棄権","3":"民主"},{"1":"501","2":"棄権","3":"棄権"},{"1":"502","2":"棄権","3":"民主"},{"1":"503","2":"棄権","3":"DK"},{"1":"504","2":"自民","3":"自民"},{"1":"505","2":"民主","3":"民主"},{"1":"506","2":"民主","3":"民主"},{"1":"507","2":"DK","3":"民主"},{"1":"508","2":"DK","3":"DK"},{"1":"509","2":"自民","3":"民主"},{"1":"510","2":"棄権","3":"DK"},{"1":"511","2":"DK","3":"民主"},{"1":"512","2":"民主","3":"民主"},{"1":"513","2":"DK","3":"共産・社民"},{"1":"514","2":"民主","3":"民主"},{"1":"515","2":"自民","3":"DK"},{"1":"516","2":"その他","3":"自民"},{"1":"517","2":"棄権","3":"棄権"},{"1":"518","2":"公明","3":"民主"},{"1":"519","2":"棄権","3":"自民"},{"1":"520","2":"棄権","3":"民主"},{"1":"521","2":"DK","3":"民主"},{"1":"522","2":"民主","3":"民主"},{"1":"523","2":"DK","3":"自民"},{"1":"524","2":"棄権","3":"棄権"},{"1":"525","2":"DK","3":"民主"},{"1":"526","2":"民主","3":"民主"},{"1":"527","2":"DK","3":"公明"},{"1":"528","2":"棄権","3":"民主"},{"1":"529","2":"自民","3":"その他"},{"1":"530","2":"共産・社民","3":"共産・社民"},{"1":"531","2":"民主","3":"民主"},{"1":"532","2":"民主","3":"民主"},{"1":"533","2":"民主","3":"民主"},{"1":"534","2":"民主","3":"民主"},{"1":"535","2":"自民","3":"自民"},{"1":"536","2":"棄権","3":"棄権"},{"1":"537","2":"その他","3":"その他"},{"1":"538","2":"民主","3":"民主"},{"1":"539","2":"棄権","3":"民主"},{"1":"540","2":"棄権","3":"民主"},{"1":"541","2":"棄権","3":"民主"},{"1":"542","2":"自民","3":"自民"},{"1":"543","2":"民主","3":"民主"},{"1":"544","2":"棄権","3":"棄権"},{"1":"545","2":"民主","3":"民主"},{"1":"546","2":"民主","3":"民主"},{"1":"547","2":"自民","3":"自民"},{"1":"548","2":"その他","3":"その他"},{"1":"549","2":"棄権","3":"棄権"},{"1":"550","2":"民主","3":"民主"},{"1":"551","2":"その他","3":"民主"},{"1":"552","2":"公明","3":"公明"},{"1":"553","2":"その他","3":"自民"},{"1":"554","2":"共産・社民","3":"共産・社民"},{"1":"555","2":"民主","3":"民主"},{"1":"556","2":"棄権","3":"棄権"},{"1":"557","2":"民主","3":"民主"},{"1":"558","2":"自民","3":"自民"},{"1":"559","2":"DK","3":"棄権"},{"1":"560","2":"棄権","3":"棄権"},{"1":"561","2":"DK","3":"DK"},{"1":"562","2":"その他","3":"その他"},{"1":"563","2":"民主","3":"民主"},{"1":"564","2":"共産・社民","3":"共産・社民"},{"1":"565","2":"自民","3":"自民"},{"1":"566","2":"民主","3":"民主"},{"1":"567","2":"DK","3":"民主"},{"1":"568","2":"公明","3":"公明"},{"1":"569","2":"その他","3":"民主"},{"1":"570","2":"民主","3":"自民"},{"1":"571","2":"棄権","3":"棄権"},{"1":"572","2":"民主","3":"民主"},{"1":"573","2":"民主","3":"民主"},{"1":"574","2":"自民","3":"自民"},{"1":"575","2":"棄権","3":"民主"},{"1":"576","2":"共産・社民","3":"共産・社民"},{"1":"577","2":"公明","3":"公明"},{"1":"578","2":"棄権","3":"民主"},{"1":"579","2":"民主","3":"民主"},{"1":"580","2":"自民","3":"民主"},{"1":"581","2":"DK","3":"DK"},{"1":"582","2":"民主","3":"民主"},{"1":"583","2":"DK","3":"棄権"},{"1":"584","2":"自民","3":"その他"},{"1":"585","2":"民主","3":"民主"},{"1":"586","2":"民主","3":"民主"},{"1":"587","2":"自民","3":"自民"},{"1":"588","2":"自民","3":"自民"},{"1":"589","2":"その他","3":"その他"},{"1":"590","2":"自民","3":"自民"},{"1":"591","2":"民主","3":"民主"},{"1":"592","2":"自民","3":"自民"},{"1":"593","2":"自民","3":"自民"},{"1":"594","2":"自民","3":"自民"},{"1":"595","2":"自民","3":"その他"},{"1":"596","2":"民主","3":"民主"},{"1":"597","2":"自民","3":"民主"},{"1":"598","2":"民主","3":"民主"},{"1":"599","2":"自民","3":"自民"},{"1":"600","2":"自民","3":"棄権"},{"1":"601","2":"民主","3":"民主"},{"1":"602","2":"その他","3":"民主"},{"1":"603","2":"DK","3":"自民"},{"1":"604","2":"自民","3":"自民"},{"1":"605","2":"自民","3":"自民"},{"1":"606","2":"民主","3":"民主"},{"1":"607","2":"自民","3":"自民"},{"1":"608","2":"その他","3":"共産・社民"},{"1":"609","2":"民主","3":"民主"},{"1":"610","2":"自民","3":"民主"},{"1":"611","2":"民主","3":"民主"},{"1":"612","2":"自民","3":"民主"},{"1":"613","2":"民主","3":"民主"},{"1":"614","2":"自民","3":"民主"},{"1":"615","2":"その他","3":"民主"},{"1":"616","2":"民主","3":"共産・社民"},{"1":"617","2":"民主","3":"棄権"},{"1":"618","2":"民主","3":"民主"},{"1":"619","2":"棄権","3":"民主"},{"1":"620","2":"自民","3":"民主"},{"1":"621","2":"DK","3":"その他"},{"1":"622","2":"民主","3":"民主"},{"1":"623","2":"自民","3":"自民"},{"1":"624","2":"自民","3":"民主"},{"1":"625","2":"民主","3":"民主"},{"1":"626","2":"自民","3":"民主"},{"1":"627","2":"その他","3":"民主"},{"1":"628","2":"自民","3":"自民"},{"1":"629","2":"DK","3":"DK"},{"1":"630","2":"その他","3":"DK"},{"1":"631","2":"その他","3":"民主"},{"1":"632","2":"DK","3":"共産・社民"},{"1":"633","2":"民主","3":"民主"},{"1":"634","2":"棄権","3":"DK"},{"1":"635","2":"自民","3":"棄権"},{"1":"636","2":"棄権","3":"棄権"},{"1":"637","2":"棄権","3":"棄権"},{"1":"638","2":"民主","3":"民主"},{"1":"639","2":"民主","3":"民主"},{"1":"640","2":"DK","3":"DK"},{"1":"641","2":"自民","3":"自民"},{"1":"642","2":"民主","3":"民主"},{"1":"643","2":"民主","3":"民主"},{"1":"644","2":"共産・社民","3":"共産・社民"},{"1":"645","2":"民主","3":"民主"},{"1":"646","2":"DK","3":"DK"},{"1":"647","2":"DK","3":"棄権"},{"1":"648","2":"民主","3":"民主"},{"1":"649","2":"民主","3":"民主"},{"1":"650","2":"その他","3":"共産・社民"},{"1":"651","2":"自民","3":"自民"},{"1":"652","2":"民主","3":"民主"},{"1":"653","2":"自民","3":"自民"},{"1":"654","2":"棄権","3":"棄権"},{"1":"655","2":"民主","3":"民主"},{"1":"656","2":"その他","3":"民主"},{"1":"657","2":"DK","3":"DK"},{"1":"658","2":"その他","3":"民主"},{"1":"659","2":"DK","3":"民主"},{"1":"660","2":"民主","3":"民主"},{"1":"661","2":"DK","3":"民主"},{"1":"662","2":"民主","3":"自民"},{"1":"663","2":"民主","3":"民主"},{"1":"664","2":"民主","3":"民主"},{"1":"665","2":"自民","3":"自民"},{"1":"666","2":"棄権","3":"民主"},{"1":"667","2":"棄権","3":"棄権"},{"1":"668","2":"DK","3":"棄権"},{"1":"669","2":"その他","3":"民主"},{"1":"670","2":"自民","3":"自民"},{"1":"671","2":"DK","3":"DK"},{"1":"672","2":"自民","3":"DK"},{"1":"673","2":"棄権","3":"棄権"},{"1":"674","2":"自民","3":"自民"},{"1":"675","2":"自民","3":"自民"},{"1":"676","2":"棄権","3":"棄権"},{"1":"677","2":"棄権","3":"棄権"},{"1":"678","2":"DK","3":"自民"},{"1":"679","2":"DK","3":"DK"},{"1":"680","2":"自民","3":"自民"},{"1":"681","2":"民主","3":"民主"},{"1":"682","2":"自民","3":"公明"},{"1":"683","2":"自民","3":"民主"},{"1":"684","2":"DK","3":"DK"},{"1":"685","2":"自民","3":"自民"},{"1":"686","2":"民主","3":"自民"},{"1":"687","2":"民主","3":"民主"},{"1":"688","2":"DK","3":"DK"},{"1":"689","2":"公明","3":"公明"},{"1":"690","2":"DK","3":"自民"},{"1":"691","2":"その他","3":"民主"},{"1":"692","2":"民主","3":"民主"},{"1":"693","2":"その他","3":"自民"},{"1":"694","2":"民主","3":"民主"},{"1":"695","2":"共産・社民","3":"民主"},{"1":"696","2":"民主","3":"棄権"},{"1":"697","2":"DK","3":"民主"},{"1":"698","2":"自民","3":"棄権"},{"1":"699","2":"民主","3":"民主"},{"1":"700","2":"その他","3":"民主"},{"1":"701","2":"その他","3":"棄権"},{"1":"702","2":"民主","3":"民主"},{"1":"703","2":"民主","3":"民主"},{"1":"704","2":"その他","3":"自民"},{"1":"705","2":"DK","3":"DK"},{"1":"706","2":"棄権","3":"民主"},{"1":"707","2":"民主","3":"民主"},{"1":"708","2":"民主","3":"民主"},{"1":"709","2":"棄権","3":"民主"},{"1":"710","2":"DK","3":"民主"},{"1":"711","2":"公明","3":"公明"},{"1":"712","2":"民主","3":"民主"},{"1":"713","2":"公明","3":"公明"},{"1":"714","2":"棄権","3":"棄権"},{"1":"715","2":"民主","3":"民主"},{"1":"716","2":"自民","3":"自民"},{"1":"717","2":"自民","3":"民主"},{"1":"718","2":"自民","3":"自民"},{"1":"719","2":"その他","3":"自民"},{"1":"720","2":"自民","3":"棄権"},{"1":"721","2":"棄権","3":"棄権"},{"1":"722","2":"その他","3":"自民"},{"1":"723","2":"民主","3":"民主"},{"1":"724","2":"棄権","3":"棄権"},{"1":"725","2":"DK","3":"民主"},{"1":"726","2":"棄権","3":"棄権"},{"1":"727","2":"棄権","3":"棄権"},{"1":"728","2":"民主","3":"民主"},{"1":"729","2":"民主","3":"民主"},{"1":"730","2":"自民","3":"自民"},{"1":"731","2":"共産・社民","3":"共産・社民"},{"1":"732","2":"自民","3":"自民"},{"1":"733","2":"その他","3":"民主"},{"1":"734","2":"DK","3":"DK"},{"1":"735","2":"自民","3":"自民"},{"1":"736","2":"自民","3":"自民"},{"1":"737","2":"民主","3":"民主"},{"1":"738","2":"民主","3":"棄権"},{"1":"739","2":"公明","3":"民主"},{"1":"740","2":"民主","3":"民主"},{"1":"741","2":"棄権","3":"棄権"},{"1":"742","2":"民主","3":"民主"},{"1":"743","2":"公明","3":"公明"},{"1":"744","2":"DK","3":"民主"},{"1":"745","2":"自民","3":"自民"},{"1":"746","2":"棄権","3":"棄権"},{"1":"747","2":"その他","3":"その他"},{"1":"748","2":"その他","3":"その他"},{"1":"749","2":"DK","3":"民主"},{"1":"750","2":"自民","3":"自民"},{"1":"751","2":"民主","3":"民主"},{"1":"752","2":"民主","3":"民主"},{"1":"753","2":"共産・社民","3":"共産・社民"},{"1":"754","2":"その他","3":"自民"},{"1":"755","2":"棄権","3":"民主"},{"1":"756","2":"民主","3":"民主"},{"1":"757","2":"民主","3":"民主"},{"1":"758","2":"棄権","3":"棄権"},{"1":"759","2":"民主","3":"民主"},{"1":"760","2":"自民","3":"自民"},{"1":"761","2":"DK","3":"民主"},{"1":"762","2":"棄権","3":"棄権"},{"1":"763","2":"自民","3":"DK"},{"1":"764","2":"DK","3":"公明"},{"1":"765","2":"民主","3":"民主"},{"1":"766","2":"共産・社民","3":"民主"},{"1":"767","2":"自民","3":"自民"},{"1":"768","2":"その他","3":"民主"},{"1":"769","2":"民主","3":"民主"},{"1":"770","2":"その他","3":"その他"},{"1":"771","2":"棄権","3":"DK"},{"1":"772","2":"民主","3":"民主"},{"1":"773","2":"棄権","3":"自民"},{"1":"774","2":"民主","3":"民主"},{"1":"775","2":"共産・社民","3":"共産・社民"},{"1":"776","2":"民主","3":"民主"},{"1":"777","2":"公明","3":"公明"},{"1":"778","2":"民主","3":"自民"},{"1":"779","2":"民主","3":"民主"},{"1":"780","2":"民主","3":"民主"},{"1":"781","2":"民主","3":"民主"},{"1":"782","2":"自民","3":"自民"},{"1":"783","2":"民主","3":"民主"},{"1":"784","2":"自民","3":"民主"},{"1":"785","2":"自民","3":"自民"},{"1":"786","2":"その他","3":"民主"},{"1":"787","2":"民主","3":"民主"},{"1":"788","2":"棄権","3":"民主"},{"1":"789","2":"その他","3":"民主"},{"1":"790","2":"棄権","3":"棄権"},{"1":"791","2":"民主","3":"民主"},{"1":"792","2":"自民","3":"民主"},{"1":"793","2":"棄権","3":"棄権"},{"1":"794","2":"棄権","3":"棄権"},{"1":"795","2":"民主","3":"民主"},{"1":"796","2":"その他","3":"民主"},{"1":"797","2":"その他","3":"DK"},{"1":"798","2":"自民","3":"自民"},{"1":"799","2":"自民","3":"自民"},{"1":"800","2":"その他","3":"棄権"},{"1":"801","2":"民主","3":"棄権"},{"1":"802","2":"自民","3":"民主"},{"1":"803","2":"民主","3":"民主"},{"1":"804","2":"DK","3":"DK"},{"1":"805","2":"民主","3":"民主"},{"1":"806","2":"民主","3":"民主"},{"1":"807","2":"民主","3":"民主"},{"1":"808","2":"その他","3":"民主"},{"1":"809","2":"民主","3":"民主"},{"1":"810","2":"共産・社民","3":"民主"},{"1":"811","2":"自民","3":"自民"},{"1":"812","2":"棄権","3":"民主"},{"1":"813","2":"自民","3":"自民"},{"1":"814","2":"民主","3":"民主"},{"1":"815","2":"自民","3":"自民"},{"1":"816","2":"その他","3":"自民"},{"1":"817","2":"DK","3":"共産・社民"},{"1":"818","2":"民主","3":"自民"},{"1":"819","2":"DK","3":"棄権"},{"1":"820","2":"自民","3":"自民"},{"1":"821","2":"民主","3":"棄権"},{"1":"822","2":"民主","3":"民主"},{"1":"823","2":"その他","3":"棄権"},{"1":"824","2":"DK","3":"DK"},{"1":"825","2":"棄権","3":"自民"},{"1":"826","2":"民主","3":"民主"},{"1":"827","2":"自民","3":"民主"},{"1":"828","2":"民主","3":"民主"},{"1":"829","2":"自民","3":"自民"},{"1":"830","2":"民主","3":"民主"},{"1":"831","2":"棄権","3":"DK"},{"1":"832","2":"その他","3":"その他"},{"1":"833","2":"棄権","3":"民主"},{"1":"834","2":"民主","3":"民主"},{"1":"835","2":"民主","3":"民主"},{"1":"836","2":"公明","3":"公明"},{"1":"837","2":"民主","3":"民主"},{"1":"838","2":"DK","3":"棄権"},{"1":"839","2":"その他","3":"棄権"},{"1":"840","2":"公明","3":"公明"},{"1":"841","2":"民主","3":"民主"},{"1":"842","2":"民主","3":"民主"},{"1":"843","2":"民主","3":"民主"},{"1":"844","2":"自民","3":"民主"},{"1":"845","2":"その他","3":"民主"},{"1":"846","2":"棄権","3":"棄権"},{"1":"847","2":"民主","3":"民主"},{"1":"848","2":"民主","3":"民主"},{"1":"849","2":"DK","3":"DK"},{"1":"850","2":"棄権","3":"棄権"},{"1":"851","2":"民主","3":"民主"},{"1":"852","2":"棄権","3":"民主"},{"1":"853","2":"民主","3":"民主"},{"1":"854","2":"民主","3":"民主"},{"1":"855","2":"民主","3":"民主"},{"1":"856","2":"その他","3":"民主"},{"1":"857","2":"その他","3":"DK"},{"1":"858","2":"民主","3":"民主"},{"1":"859","2":"民主","3":"民主"},{"1":"860","2":"自民","3":"棄権"},{"1":"861","2":"その他","3":"自民"},{"1":"862","2":"棄権","3":"棄権"},{"1":"863","2":"自民","3":"自民"},{"1":"864","2":"その他","3":"民主"},{"1":"865","2":"公明","3":"民主"},{"1":"866","2":"民主","3":"民主"},{"1":"867","2":"民主","3":"民主"},{"1":"868","2":"共産・社民","3":"民主"},{"1":"869","2":"共産・社民","3":"共産・社民"},{"1":"870","2":"民主","3":"民主"},{"1":"871","2":"民主","3":"民主"},{"1":"872","2":"自民","3":"公明"},{"1":"873","2":"棄権","3":"棄権"},{"1":"874","2":"民主","3":"民主"},{"1":"875","2":"民主","3":"自民"},{"1":"876","2":"その他","3":"民主"},{"1":"877","2":"民主","3":"その他"},{"1":"878","2":"自民","3":"民主"},{"1":"879","2":"棄権","3":"棄権"},{"1":"880","2":"棄権","3":"民主"},{"1":"881","2":"棄権","3":"民主"},{"1":"882","2":"民主","3":"民主"},{"1":"883","2":"民主","3":"民主"},{"1":"884","2":"民主","3":"民主"},{"1":"885","2":"棄権","3":"棄権"},{"1":"886","2":"民主","3":"民主"},{"1":"887","2":"DK","3":"民主"},{"1":"888","2":"棄権","3":"棄権"},{"1":"889","2":"棄権","3":"棄権"},{"1":"890","2":"公明","3":"公明"},{"1":"891","2":"民主","3":"民主"},{"1":"892","2":"DK","3":"民主"},{"1":"893","2":"DK","3":"棄権"},{"1":"894","2":"自民","3":"棄権"},{"1":"895","2":"DK","3":"DK"},{"1":"896","2":"DK","3":"DK"},{"1":"897","2":"自民","3":"自民"},{"1":"898","2":"棄権","3":"棄権"},{"1":"899","2":"民主","3":"民主"},{"1":"900","2":"民主","3":"民主"},{"1":"901","2":"棄権","3":"棄権"},{"1":"902","2":"民主","3":"民主"},{"1":"903","2":"その他","3":"民主"},{"1":"904","2":"民主","3":"民主"},{"1":"905","2":"DK","3":"民主"},{"1":"906","2":"DK","3":"民主"},{"1":"907","2":"棄権","3":"民主"},{"1":"908","2":"自民","3":"棄権"},{"1":"909","2":"民主","3":"民主"},{"1":"910","2":"民主","3":"民主"},{"1":"911","2":"棄権","3":"棄権"},{"1":"912","2":"民主","3":"民主"},{"1":"913","2":"自民","3":"民主"},{"1":"914","2":"DK","3":"DK"},{"1":"915","2":"棄権","3":"棄権"},{"1":"916","2":"共産・社民","3":"共産・社民"},{"1":"917","2":"共産・社民","3":"民主"},{"1":"918","2":"民主","3":"民主"},{"1":"919","2":"民主","3":"民主"},{"1":"920","2":"棄権","3":"民主"},{"1":"921","2":"棄権","3":"棄権"},{"1":"922","2":"民主","3":"民主"},{"1":"923","2":"DK","3":"民主"},{"1":"924","2":"棄権","3":"棄権"},{"1":"925","2":"その他","3":"自民"},{"1":"926","2":"民主","3":"民主"},{"1":"927","2":"自民","3":"その他"},{"1":"928","2":"その他","3":"自民"},{"1":"929","2":"自民","3":"自民"},{"1":"930","2":"民主","3":"民主"},{"1":"931","2":"その他","3":"民主"},{"1":"932","2":"民主","3":"民主"},{"1":"933","2":"DK","3":"DK"},{"1":"934","2":"その他","3":"民主"},{"1":"935","2":"棄権","3":"棄権"},{"1":"936","2":"DK","3":"公明"},{"1":"937","2":"公明","3":"公明"},{"1":"938","2":"民主","3":"民主"},{"1":"939","2":"自民","3":"民主"},{"1":"940","2":"公明","3":"公明"},{"1":"941","2":"その他","3":"民主"},{"1":"942","2":"自民","3":"自民"},{"1":"943","2":"民主","3":"民主"},{"1":"944","2":"共産・社民","3":"共産・社民"},{"1":"945","2":"民主","3":"棄権"},{"1":"946","2":"その他","3":"民主"},{"1":"947","2":"その他","3":"民主"},{"1":"948","2":"棄権","3":"民主"},{"1":"949","2":"棄権","3":"棄権"},{"1":"950","2":"その他","3":"その他"},{"1":"951","2":"共産・社民","3":"共産・社民"},{"1":"952","2":"DK","3":"民主"},{"1":"953","2":"民主","3":"自民"},{"1":"954","2":"棄権","3":"棄権"},{"1":"955","2":"共産・社民","3":"共産・社民"},{"1":"956","2":"共産・社民","3":"民主"},{"1":"957","2":"自民","3":"自民"},{"1":"958","2":"棄権","3":"民主"},{"1":"959","2":"DK","3":"DK"},{"1":"960","2":"DK","3":"民主"},{"1":"961","2":"自民","3":"自民"},{"1":"962","2":"公明","3":"自民"},{"1":"963","2":"DK","3":"棄権"},{"1":"964","2":"自民","3":"自民"},{"1":"965","2":"共産・社民","3":"民主"},{"1":"966","2":"自民","3":"自民"},{"1":"967","2":"民主","3":"民主"},{"1":"968","2":"自民","3":"棄権"},{"1":"969","2":"棄権","3":"棄権"},{"1":"970","2":"民主","3":"民主"},{"1":"971","2":"棄権","3":"DK"},{"1":"972","2":"DK","3":"民主"},{"1":"973","2":"棄権","3":"民主"},{"1":"974","2":"民主","3":"民主"},{"1":"975","2":"自民","3":"自民"},{"1":"976","2":"DK","3":"民主"},{"1":"977","2":"DK","3":"棄権"},{"1":"978","2":"民主","3":"民主"},{"1":"979","2":"棄権","3":"棄権"},{"1":"980","2":"その他","3":"自民"},{"1":"981","2":"棄権","3":"棄権"},{"1":"982","2":"DK","3":"自民"},{"1":"983","2":"DK","3":"民主"},{"1":"984","2":"棄権","3":"その他"},{"1":"985","2":"DK","3":"民主"},{"1":"986","2":"共産・社民","3":"共産・社民"},{"1":"987","2":"棄権","3":"自民"},{"1":"988","2":"民主","3":"DK"},{"1":"989","2":"棄権","3":"棄権"},{"1":"990","2":"民主","3":"民主"},{"1":"991","2":"民主","3":"民主"},{"1":"992","2":"民主","3":"民主"},{"1":"993","2":"自民","3":"自民"},{"1":"994","2":"自民","3":"民主"},{"1":"995","2":"民主","3":"民主"},{"1":"996","2":"棄権","3":"DK"},{"1":"997","2":"棄権","3":"棄権"},{"1":"998","2":"民主","3":"民主"},{"1":"999","2":"その他","3":"民主"},{"1":"1000","2":"DK","3":"棄権"},{"1":"1001","2":"民主","3":"民主"},{"1":"1002","2":"棄権","3":"民主"},{"1":"1003","2":"民主","3":"民主"},{"1":"1004","2":"公明","3":"公明"},{"1":"1005","2":"自民","3":"自民"},{"1":"1006","2":"民主","3":"民主"},{"1":"1007","2":"棄権","3":"棄権"},{"1":"1008","2":"棄権","3":"棄権"},{"1":"1009","2":"自民","3":"自民"},{"1":"1010","2":"その他","3":"民主"},{"1":"1011","2":"棄権","3":"棄権"},{"1":"1012","2":"その他","3":"その他"},{"1":"1013","2":"DK","3":"DK"},{"1":"1014","2":"棄権","3":"民主"},{"1":"1015","2":"棄権","3":"棄権"},{"1":"1016","2":"棄権","3":"その他"},{"1":"1017","2":"民主","3":"民主"},{"1":"1018","2":"その他","3":"民主"},{"1":"1019","2":"棄権","3":"棄権"},{"1":"1020","2":"民主","3":"民主"},{"1":"1021","2":"民主","3":"民主"},{"1":"1022","2":"民主","3":"民主"},{"1":"1023","2":"その他","3":"自民"},{"1":"1024","2":"民主","3":"民主"},{"1":"1025","2":"自民","3":"民主"},{"1":"1026","2":"DK","3":"DK"},{"1":"1027","2":"民主","3":"民主"},{"1":"1028","2":"自民","3":"自民"},{"1":"1029","2":"棄権","3":"棄権"},{"1":"1030","2":"民主","3":"民主"},{"1":"1031","2":"民主","3":"民主"},{"1":"1032","2":"棄権","3":"民主"},{"1":"1033","2":"棄権","3":"棄権"},{"1":"1034","2":"民主","3":"棄権"},{"1":"1035","2":"棄権","3":"民主"},{"1":"1036","2":"民主","3":"民主"},{"1":"1037","2":"民主","3":"民主"},{"1":"1038","2":"共産・社民","3":"共産・社民"},{"1":"1039","2":"公明","3":"公明"},{"1":"1040","2":"自民","3":"自民"},{"1":"1041","2":"DK","3":"民主"},{"1":"1042","2":"民主","3":"民主"},{"1":"1043","2":"民主","3":"民主"},{"1":"1044","2":"棄権","3":"棄権"},{"1":"1045","2":"棄権","3":"自民"},{"1":"1046","2":"民主","3":"民主"},{"1":"1047","2":"自民","3":"自民"},{"1":"1048","2":"棄権","3":"棄権"},{"1":"1049","2":"棄権","3":"その他"},{"1":"1050","2":"民主","3":"民主"},{"1":"1051","2":"自民","3":"自民"},{"1":"1052","2":"民主","3":"民主"},{"1":"1053","2":"棄権","3":"棄権"},{"1":"1054","2":"民主","3":"民主"},{"1":"1055","2":"民主","3":"民主"},{"1":"1056","2":"民主","3":"民主"},{"1":"1057","2":"民主","3":"民主"},{"1":"1058","2":"民主","3":"DK"},{"1":"1059","2":"共産・社民","3":"共産・社民"},{"1":"1060","2":"公明","3":"公明"},{"1":"1061","2":"民主","3":"民主"},{"1":"1062","2":"民主","3":"民主"},{"1":"1063","2":"民主","3":"民主"},{"1":"1064","2":"自民","3":"自民"},{"1":"1065","2":"民主","3":"民主"},{"1":"1066","2":"自民","3":"共産・社民"},{"1":"1067","2":"自民","3":"自民"},{"1":"1068","2":"民主","3":"民主"},{"1":"1069","2":"民主","3":"民主"},{"1":"1070","2":"民主","3":"共産・社民"},{"1":"1071","2":"自民","3":"民主"},{"1":"1072","2":"DK","3":"DK"},{"1":"1073","2":"その他","3":"民主"},{"1":"1074","2":"民主","3":"民主"},{"1":"1075","2":"民主","3":"自民"},{"1":"1076","2":"自民","3":"自民"},{"1":"1077","2":"民主","3":"自民"},{"1":"1078","2":"その他","3":"棄権"},{"1":"1079","2":"自民","3":"自民"},{"1":"1080","2":"DK","3":"民主"},{"1":"1081","2":"共産・社民","3":"共産・社民"},{"1":"1082","2":"民主","3":"民主"},{"1":"1083","2":"共産・社民","3":"共産・社民"},{"1":"1084","2":"自民","3":"自民"},{"1":"1085","2":"棄権","3":"自民"},{"1":"1086","2":"自民","3":"自民"},{"1":"1087","2":"棄権","3":"民主"},{"1":"1088","2":"その他","3":"自民"},{"1":"1089","2":"DK","3":"民主"},{"1":"1090","2":"DK","3":"DK"},{"1":"1091","2":"自民","3":"自民"},{"1":"1092","2":"自民","3":"自民"},{"1":"1093","2":"自民","3":"棄権"},{"1":"1094","2":"民主","3":"民主"},{"1":"1095","2":"民主","3":"民主"},{"1":"1096","2":"民主","3":"民主"},{"1":"1097","2":"民主","3":"民主"},{"1":"1098","2":"棄権","3":"棄権"},{"1":"1099","2":"その他","3":"共産・社民"},{"1":"1100","2":"民主","3":"民主"},{"1":"1101","2":"自民","3":"自民"},{"1":"1102","2":"民主","3":"民主"},{"1":"1103","2":"民主","3":"共産・社民"},{"1":"1104","2":"棄権","3":"民主"},{"1":"1105","2":"棄権","3":"棄権"},{"1":"1106","2":"DK","3":"民主"},{"1":"1107","2":"DK","3":"DK"},{"1":"1108","2":"民主","3":"民主"},{"1":"1109","2":"自民","3":"民主"},{"1":"1110","2":"民主","3":"民主"},{"1":"1111","2":"DK","3":"DK"},{"1":"1112","2":"民主","3":"民主"},{"1":"1113","2":"自民","3":"棄権"},{"1":"1114","2":"公明","3":"民主"},{"1":"1115","2":"公明","3":"民主"},{"1":"1116","2":"民主","3":"民主"},{"1":"1117","2":"DK","3":"自民"},{"1":"1118","2":"棄権","3":"民主"},{"1":"1119","2":"その他","3":"民主"},{"1":"1120","2":"棄権","3":"棄権"},{"1":"1121","2":"自民","3":"民主"},{"1":"1122","2":"棄権","3":"棄権"},{"1":"1123","2":"公明","3":"公明"},{"1":"1124","2":"民主","3":"民主"},{"1":"1125","2":"民主","3":"民主"},{"1":"1126","2":"その他","3":"その他"},{"1":"1127","2":"共産・社民","3":"共産・社民"},{"1":"1128","2":"民主","3":"民主"},{"1":"1129","2":"棄権","3":"棄権"},{"1":"1130","2":"DK","3":"民主"},{"1":"1131","2":"その他","3":"民主"},{"1":"1132","2":"DK","3":"民主"},{"1":"1133","2":"自民","3":"自民"},{"1":"1134","2":"棄権","3":"DK"},{"1":"1135","2":"棄権","3":"棄権"},{"1":"1136","2":"民主","3":"民主"},{"1":"1137","2":"民主","3":"民主"},{"1":"1138","2":"自民","3":"自民"},{"1":"1139","2":"DK","3":"棄権"},{"1":"1140","2":"棄権","3":"棄権"},{"1":"1141","2":"棄権","3":"棄権"},{"1":"1142","2":"棄権","3":"DK"},{"1":"1143","2":"民主","3":"民主"},{"1":"1144","2":"民主","3":"民主"},{"1":"1145","2":"棄権","3":"棄権"},{"1":"1146","2":"民主","3":"民主"},{"1":"1147","2":"DK","3":"その他"},{"1":"1148","2":"棄権","3":"棄権"},{"1":"1149","2":"自民","3":"自民"},{"1":"1150","2":"民主","3":"民主"},{"1":"1151","2":"自民","3":"民主"},{"1":"1152","2":"共産・社民","3":"共産・社民"},{"1":"1153","2":"公明","3":"民主"},{"1":"1154","2":"民主","3":"民主"},{"1":"1155","2":"民主","3":"民主"},{"1":"1156","2":"自民","3":"自民"},{"1":"1157","2":"棄権","3":"棄権"},{"1":"1158","2":"公明","3":"公明"},{"1":"1159","2":"民主","3":"民主"},{"1":"1160","2":"棄権","3":"棄権"},{"1":"1161","2":"棄権","3":"棄権"},{"1":"1162","2":"その他","3":"自民"},{"1":"1163","2":"棄権","3":"棄権"},{"1":"1164","2":"DK","3":"DK"},{"1":"1165","2":"棄権","3":"民主"},{"1":"1166","2":"民主","3":"民主"},{"1":"1167","2":"民主","3":"民主"},{"1":"1168","2":"棄権","3":"自民"},{"1":"1169","2":"棄権","3":"棄権"},{"1":"1170","2":"民主","3":"民主"},{"1":"1171","2":"公明","3":"公明"},{"1":"1172","2":"棄権","3":"棄権"},{"1":"1173","2":"民主","3":"棄権"},{"1":"1174","2":"民主","3":"民主"},{"1":"1175","2":"民主","3":"民主"},{"1":"1176","2":"民主","3":"共産・社民"},{"1":"1177","2":"民主","3":"民主"},{"1":"1178","2":"共産・社民","3":"共産・社民"},{"1":"1179","2":"自民","3":"自民"},{"1":"1180","2":"自民","3":"棄権"},{"1":"1181","2":"民主","3":"民主"},{"1":"1182","2":"民主","3":"民主"},{"1":"1183","2":"公明","3":"公明"},{"1":"1184","2":"DK","3":"棄権"},{"1":"1185","2":"公明","3":"公明"},{"1":"1186","2":"DK","3":"棄権"},{"1":"1187","2":"共産・社民","3":"共産・社民"},{"1":"1188","2":"自民","3":"自民"},{"1":"1189","2":"民主","3":"民主"},{"1":"1190","2":"民主","3":"民主"},{"1":"1191","2":"公明","3":"公明"},{"1":"1192","2":"民主","3":"民主"},{"1":"1193","2":"棄権","3":"棄権"},{"1":"1194","2":"DK","3":"共産・社民"},{"1":"1195","2":"棄権","3":"棄権"},{"1":"1196","2":"その他","3":"民主"},{"1":"1197","2":"共産・社民","3":"共産・社民"},{"1":"1198","2":"自民","3":"自民"},{"1":"1199","2":"自民","3":"民主"},{"1":"1200","2":"民主","3":"民主"},{"1":"1201","2":"民主","3":"民主"},{"1":"1202","2":"棄権","3":"棄権"},{"1":"1203","2":"自民","3":"自民"},{"1":"1204","2":"その他","3":"民主"},{"1":"1205","2":"民主","3":"民主"},{"1":"1206","2":"共産・社民","3":"民主"},{"1":"1207","2":"民主","3":"民主"},{"1":"1208","2":"その他","3":"その他"},{"1":"1209","2":"DK","3":"DK"},{"1":"1210","2":"自民","3":"民主"},{"1":"1211","2":"棄権","3":"棄権"},{"1":"1212","2":"民主","3":"民主"},{"1":"1213","2":"自民","3":"自民"},{"1":"1214","2":"棄権","3":"民主"},{"1":"1215","2":"民主","3":"民主"},{"1":"1216","2":"民主","3":"民主"},{"1":"1217","2":"民主","3":"民主"},{"1":"1218","2":"DK","3":"民主"},{"1":"1219","2":"棄権","3":"棄権"},{"1":"1220","2":"棄権","3":"棄権"},{"1":"1221","2":"DK","3":"DK"},{"1":"1222","2":"棄権","3":"民主"},{"1":"1223","2":"自民","3":"自民"},{"1":"1224","2":"その他","3":"その他"},{"1":"1225","2":"その他","3":"民主"},{"1":"1226","2":"公明","3":"棄権"},{"1":"1227","2":"民主","3":"民主"},{"1":"1228","2":"民主","3":"民主"},{"1":"1229","2":"棄権","3":"棄権"},{"1":"1230","2":"DK","3":"棄権"},{"1":"1231","2":"自民","3":"自民"},{"1":"1232","2":"民主","3":"民主"},{"1":"1233","2":"自民","3":"民主"},{"1":"1234","2":"民主","3":"棄権"},{"1":"1235","2":"共産・社民","3":"棄権"},{"1":"1236","2":"棄権","3":"棄権"},{"1":"1237","2":"棄権","3":"民主"},{"1":"1238","2":"民主","3":"自民"},{"1":"1239","2":"その他","3":"その他"},{"1":"1240","2":"自民","3":"自民"},{"1":"1241","2":"棄権","3":"棄権"},{"1":"1242","2":"自民","3":"自民"},{"1":"1243","2":"棄権","3":"棄権"},{"1":"1244","2":"民主","3":"民主"},{"1":"1245","2":"その他","3":"自民"},{"1":"1246","2":"DK","3":"DK"},{"1":"1247","2":"DK","3":"DK"},{"1":"1248","2":"民主","3":"民主"},{"1":"1249","2":"自民","3":"自民"},{"1":"1250","2":"民主","3":"自民"},{"1":"1251","2":"民主","3":"民主"},{"1":"1252","2":"DK","3":"棄権"},{"1":"1253","2":"DK","3":"民主"},{"1":"1254","2":"民主","3":"民主"},{"1":"1255","2":"棄権","3":"棄権"},{"1":"1256","2":"民主","3":"民主"},{"1":"1257","2":"民主","3":"民主"},{"1":"1258","2":"その他","3":"自民"},{"1":"1259","2":"民主","3":"民主"},{"1":"1260","2":"自民","3":"自民"},{"1":"1261","2":"自民","3":"棄権"},{"1":"1262","2":"その他","3":"その他"},{"1":"1263","2":"民主","3":"民主"},{"1":"1264","2":"民主","3":"民主"},{"1":"1265","2":"民主","3":"民主"},{"1":"1266","2":"棄権","3":"DK"},{"1":"1267","2":"その他","3":"民主"},{"1":"1268","2":"DK","3":"DK"},{"1":"1269","2":"その他","3":"民主"},{"1":"1270","2":"共産・社民","3":"民主"},{"1":"1271","2":"その他","3":"民主"},{"1":"1272","2":"民主","3":"民主"},{"1":"1273","2":"民主","3":"民主"},{"1":"1274","2":"自民","3":"自民"},{"1":"1275","2":"その他","3":"民主"},{"1":"1276","2":"民主","3":"民主"},{"1":"1277","2":"民主","3":"民主"},{"1":"1278","2":"民主","3":"民主"},{"1":"1279","2":"共産・社民","3":"自民"},{"1":"1280","2":"DK","3":"民主"},{"1":"1281","2":"民主","3":"DK"},{"1":"1282","2":"DK","3":"民主"},{"1":"1283","2":"民主","3":"民主"},{"1":"1284","2":"民主","3":"自民"},{"1":"1285","2":"その他","3":"自民"},{"1":"1286","2":"棄権","3":"DK"},{"1":"1287","2":"自民","3":"自民"},{"1":"1288","2":"共産・社民","3":"棄権"},{"1":"1289","2":"DK","3":"DK"},{"1":"1290","2":"自民","3":"自民"},{"1":"1291","2":"公明","3":"公明"},{"1":"1292","2":"DK","3":"共産・社民"},{"1":"1293","2":"DK","3":"DK"},{"1":"1294","2":"公明","3":"民主"},{"1":"1295","2":"民主","3":"民主"},{"1":"1296","2":"民主","3":"民主"},{"1":"1297","2":"自民","3":"棄権"},{"1":"1298","2":"民主","3":"民主"},{"1":"1299","2":"棄権","3":"棄権"},{"1":"1300","2":"棄権","3":"棄権"},{"1":"1301","2":"棄権","3":"棄権"},{"1":"1302","2":"DK","3":"共産・社民"},{"1":"1303","2":"自民","3":"自民"},{"1":"1304","2":"民主","3":"民主"},{"1":"1305","2":"棄権","3":"民主"},{"1":"1306","2":"公明","3":"公明"},{"1":"1307","2":"自民","3":"棄権"},{"1":"1308","2":"自民","3":"自民"},{"1":"1309","2":"DK","3":"民主"},{"1":"1310","2":"公明","3":"公明"},{"1":"1311","2":"棄権","3":"民主"},{"1":"1312","2":"公明","3":"公明"},{"1":"1313","2":"民主","3":"民主"},{"1":"1314","2":"自民","3":"民主"},{"1":"1315","2":"民主","3":"民主"},{"1":"1316","2":"民主","3":"民主"},{"1":"1317","2":"その他","3":"自民"},{"1":"1318","2":"DK","3":"棄権"},{"1":"1319","2":"棄権","3":"民主"},{"1":"1320","2":"棄権","3":"民主"},{"1":"1321","2":"棄権","3":"DK"},{"1":"1322","2":"DK","3":"DK"},{"1":"1323","2":"棄権","3":"棄権"},{"1":"1324","2":"その他","3":"民主"},{"1":"1325","2":"自民","3":"自民"},{"1":"1326","2":"棄権","3":"棄権"},{"1":"1327","2":"棄権","3":"DK"},{"1":"1328","2":"自民","3":"自民"},{"1":"1329","2":"民主","3":"民主"},{"1":"1330","2":"民主","3":"民主"},{"1":"1331","2":"その他","3":"民主"},{"1":"1332","2":"自民","3":"DK"},{"1":"1333","2":"自民","3":"自民"},{"1":"1334","2":"民主","3":"民主"},{"1":"1335","2":"民主","3":"DK"},{"1":"1336","2":"DK","3":"DK"},{"1":"1337","2":"その他","3":"自民"},{"1":"1338","2":"自民","3":"民主"},{"1":"1339","2":"民主","3":"民主"},{"1":"1340","2":"自民","3":"自民"},{"1":"1341","2":"自民","3":"自民"},{"1":"1342","2":"民主","3":"民主"},{"1":"1343","2":"棄権","3":"DK"},{"1":"1344","2":"その他","3":"棄権"},{"1":"1345","2":"民主","3":"民主"},{"1":"1346","2":"公明","3":"公明"},{"1":"1347","2":"民主","3":"民主"},{"1":"1348","2":"民主","3":"民主"},{"1":"1349","2":"民主","3":"公明"},{"1":"1350","2":"棄権","3":"棄権"},{"1":"1351","2":"DK","3":"その他"},{"1":"1352","2":"自民","3":"自民"},{"1":"1353","2":"棄権","3":"棄権"},{"1":"1354","2":"棄権","3":"DK"},{"1":"1355","2":"DK","3":"棄権"},{"1":"1356","2":"自民","3":"自民"},{"1":"1357","2":"民主","3":"民主"},{"1":"1358","2":"棄権","3":"棄権"},{"1":"1359","2":"棄権","3":"棄権"},{"1":"1360","2":"その他","3":"民主"},{"1":"1361","2":"自民","3":"民主"},{"1":"1362","2":"民主","3":"民主"},{"1":"1363","2":"DK","3":"DK"},{"1":"1364","2":"公明","3":"公明"},{"1":"1365","2":"その他","3":"棄権"},{"1":"1366","2":"民主","3":"自民"},{"1":"1367","2":"自民","3":"棄権"},{"1":"1368","2":"民主","3":"棄権"},{"1":"1369","2":"民主","3":"民主"},{"1":"1370","2":"民主","3":"民主"},{"1":"1371","2":"棄権","3":"DK"},{"1":"1372","2":"棄権","3":"棄権"},{"1":"1373","2":"民主","3":"民主"},{"1":"1374","2":"民主","3":"民主"},{"1":"1375","2":"自民","3":"自民"},{"1":"1376","2":"自民","3":"民主"},{"1":"1377","2":"棄権","3":"公明"},{"1":"1378","2":"自民","3":"棄権"},{"1":"1379","2":"自民","3":"民主"},{"1":"1380","2":"民主","3":"その他"},{"1":"1381","2":"棄権","3":"棄権"},{"1":"1382","2":"棄権","3":"民主"},{"1":"1383","2":"公明","3":"公明"},{"1":"1384","2":"民主","3":"民主"},{"1":"1385","2":"民主","3":"棄権"},{"1":"1386","2":"民主","3":"自民"},{"1":"1387","2":"民主","3":"棄権"},{"1":"1388","2":"自民","3":"自民"},{"1":"1389","2":"DK","3":"自民"},{"1":"1390","2":"共産・社民","3":"共産・社民"},{"1":"1391","2":"自民","3":"民主"},{"1":"1392","2":"棄権","3":"棄権"},{"1":"1393","2":"その他","3":"民主"},{"1":"1394","2":"民主","3":"民主"},{"1":"1395","2":"棄権","3":"棄権"},{"1":"1396","2":"DK","3":"DK"},{"1":"1397","2":"自民","3":"棄権"},{"1":"1398","2":"その他","3":"DK"},{"1":"1399","2":"民主","3":"DK"},{"1":"1400","2":"棄権","3":"棄権"},{"1":"1401","2":"自民","3":"自民"},{"1":"1402","2":"民主","3":"民主"},{"1":"1403","2":"民主","3":"民主"},{"1":"1404","2":"自民","3":"民主"},{"1":"1405","2":"DK","3":"DK"},{"1":"1406","2":"共産・社民","3":"DK"},{"1":"1407","2":"DK","3":"DK"},{"1":"1408","2":"棄権","3":"民主"},{"1":"1409","2":"棄権","3":"棄権"},{"1":"1410","2":"民主","3":"民主"},{"1":"1411","2":"DK","3":"DK"},{"1":"1412","2":"自民","3":"DK"},{"1":"1413","2":"DK","3":"民主"},{"1":"1414","2":"自民","3":"自民"},{"1":"1415","2":"民主","3":"民主"},{"1":"1416","2":"その他","3":"民主"},{"1":"1417","2":"DK","3":"共産・社民"},{"1":"1418","2":"自民","3":"自民"},{"1":"1419","2":"DK","3":"民主"},{"1":"1420","2":"民主","3":"民主"},{"1":"1421","2":"DK","3":"民主"},{"1":"1422","2":"民主","3":"民主"},{"1":"1423","2":"棄権","3":"棄権"},{"1":"1424","2":"DK","3":"民主"},{"1":"1425","2":"民主","3":"民主"},{"1":"1426","2":"棄権","3":"公明"},{"1":"1427","2":"民主","3":"民主"},{"1":"1428","2":"自民","3":"DK"},{"1":"1429","2":"自民","3":"自民"},{"1":"1430","2":"DK","3":"民主"},{"1":"1431","2":"民主","3":"民主"},{"1":"1432","2":"自民","3":"民主"},{"1":"1433","2":"棄権","3":"棄権"},{"1":"1434","2":"棄権","3":"棄権"},{"1":"1435","2":"自民","3":"自民"},{"1":"1436","2":"民主","3":"自民"},{"1":"1437","2":"その他","3":"民主"},{"1":"1438","2":"自民","3":"自民"},{"1":"1439","2":"DK","3":"民主"},{"1":"1440","2":"DK","3":"DK"},{"1":"1441","2":"棄権","3":"棄権"},{"1":"1442","2":"棄権","3":"民主"},{"1":"1443","2":"自民","3":"自民"},{"1":"1444","2":"自民","3":"自民"},{"1":"1445","2":"DK","3":"自民"},{"1":"1446","2":"自民","3":"共産・社民"},{"1":"1447","2":"その他","3":"民主"},{"1":"1448","2":"DK","3":"民主"},{"1":"1449","2":"共産・社民","3":"共産・社民"},{"1":"1450","2":"自民","3":"DK"},{"1":"1451","2":"自民","3":"自民"},{"1":"1452","2":"自民","3":"自民"},{"1":"1453","2":"民主","3":"民主"},{"1":"1454","2":"民主","3":"自民"},{"1":"1455","2":"自民","3":"自民"},{"1":"1456","2":"民主","3":"民主"},{"1":"1457","2":"民主","3":"民主"},{"1":"1458","2":"民主","3":"民主"},{"1":"1459","2":"民主","3":"民主"},{"1":"1460","2":"民主","3":"民主"},{"1":"1461","2":"自民","3":"自民"},{"1":"1462","2":"民主","3":"民主"},{"1":"1463","2":"民主","3":"民主"},{"1":"1464","2":"民主","3":"民主"},{"1":"1465","2":"棄権","3":"民主"},{"1":"1466","2":"民主","3":"民主"},{"1":"1467","2":"民主","3":"民主"},{"1":"1468","2":"民主","3":"民主"},{"1":"1469","2":"民主","3":"自民"},{"1":"1470","2":"棄権","3":"棄権"},{"1":"1471","2":"民主","3":"民主"},{"1":"1472","2":"民主","3":"民主"},{"1":"1473","2":"民主","3":"民主"},{"1":"1474","2":"民主","3":"民主"},{"1":"1475","2":"棄権","3":"棄権"},{"1":"1476","2":"公明","3":"自民"},{"1":"1477","2":"共産・社民","3":"共産・社民"},{"1":"1478","2":"民主","3":"民主"},{"1":"1479","2":"民主","3":"民主"},{"1":"1480","2":"自民","3":"自民"},{"1":"1481","2":"民主","3":"民主"},{"1":"1482","2":"共産・社民","3":"共産・社民"},{"1":"1483","2":"民主","3":"民主"},{"1":"1484","2":"棄権","3":"棄権"},{"1":"1485","2":"民主","3":"民主"},{"1":"1486","2":"その他","3":"その他"},{"1":"1487","2":"その他","3":"公明"},{"1":"1488","2":"自民","3":"民主"},{"1":"1489","2":"公明","3":"棄権"},{"1":"1490","2":"民主","3":"民主"},{"1":"1491","2":"民主","3":"民主"},{"1":"1492","2":"公明","3":"公明"},{"1":"1493","2":"DK","3":"民主"},{"1":"1494","2":"棄権","3":"棄権"},{"1":"1495","2":"共産・社民","3":"民主"},{"1":"1496","2":"自民","3":"棄権"},{"1":"1497","2":"DK","3":"棄権"},{"1":"1498","2":"棄権","3":"棄権"},{"1":"1499","2":"自民","3":"自民"},{"1":"1500","2":"その他","3":"その他"},{"1":"1501","2":"自民","3":"自民"},{"1":"1502","2":"棄権","3":"棄権"},{"1":"1503","2":"自民","3":"自民"},{"1":"1504","2":"DK","3":"DK"},{"1":"1505","2":"共産・社民","3":"共産・社民"},{"1":"1506","2":"棄権","3":"棄権"},{"1":"1507","2":"棄権","3":"棄権"},{"1":"1508","2":"その他","3":"その他"},{"1":"1509","2":"棄権","3":"民主"},{"1":"1510","2":"棄権","3":"棄権"},{"1":"1511","2":"棄権","3":"棄権"},{"1":"1512","2":"棄権","3":"民主"},{"1":"1513","2":"公明","3":"その他"},{"1":"1514","2":"公明","3":"公明"},{"1":"1515","2":"棄権","3":"棄権"},{"1":"1516","2":"民主","3":"民主"},{"1":"1517","2":"民主","3":"民主"},{"1":"1518","2":"自民","3":"民主"},{"1":"1519","2":"その他","3":"その他"},{"1":"1520","2":"棄権","3":"棄権"},{"1":"1521","2":"自民","3":"民主"},{"1":"1522","2":"民主","3":"DK"},{"1":"1523","2":"民主","3":"民主"},{"1":"1524","2":"自民","3":"自民"},{"1":"1525","2":"DK","3":"DK"},{"1":"1526","2":"棄権","3":"自民"},{"1":"1527","2":"民主","3":"民主"},{"1":"1528","2":"棄権","3":"民主"},{"1":"1529","2":"DK","3":"公明"},{"1":"1530","2":"民主","3":"民主"},{"1":"1531","2":"棄権","3":"棄権"},{"1":"1532","2":"DK","3":"DK"},{"1":"1533","2":"その他","3":"棄権"},{"1":"1534","2":"自民","3":"棄権"},{"1":"1535","2":"自民","3":"自民"},{"1":"1536","2":"民主","3":"民主"},{"1":"1537","2":"民主","3":"民主"},{"1":"1538","2":"その他","3":"DK"},{"1":"1539","2":"自民","3":"自民"},{"1":"1540","2":"自民","3":"自民"},{"1":"1541","2":"自民","3":"自民"},{"1":"1542","2":"自民","3":"自民"},{"1":"1543","2":"棄権","3":"棄権"},{"1":"1544","2":"民主","3":"民主"},{"1":"1545","2":"民主","3":"民主"},{"1":"1546","2":"自民","3":"自民"},{"1":"1547","2":"DK","3":"DK"},{"1":"1548","2":"棄権","3":"棄権"},{"1":"1549","2":"民主","3":"民主"},{"1":"1550","2":"民主","3":"民主"},{"1":"1551","2":"民主","3":"民主"},{"1":"1552","2":"棄権","3":"棄権"},{"1":"1553","2":"自民","3":"自民"},{"1":"1554","2":"その他","3":"民主"},{"1":"1555","2":"民主","3":"民主"},{"1":"1556","2":"共産・社民","3":"共産・社民"},{"1":"1557","2":"棄権","3":"棄権"},{"1":"1558","2":"その他","3":"棄権"},{"1":"1559","2":"棄権","3":"棄権"},{"1":"1560","2":"民主","3":"民主"},{"1":"1561","2":"自民","3":"棄権"},{"1":"1562","2":"公明","3":"公明"},{"1":"1563","2":"自民","3":"民主"},{"1":"1564","2":"その他","3":"民主"},{"1":"1565","2":"棄権","3":"民主"},{"1":"1566","2":"民主","3":"民主"},{"1":"1567","2":"民主","3":"共産・社民"},{"1":"1568","2":"自民","3":"自民"},{"1":"1569","2":"自民","3":"DK"},{"1":"1570","2":"公明","3":"自民"},{"1":"1571","2":"民主","3":"民主"},{"1":"1572","2":"民主","3":"民主"},{"1":"1573","2":"民主","3":"DK"},{"1":"1574","2":"民主","3":"民主"},{"1":"1575","2":"民主","3":"民主"},{"1":"1576","2":"民主","3":"民主"},{"1":"1577","2":"棄権","3":"棄権"},{"1":"1578","2":"自民","3":"自民"},{"1":"1579","2":"DK","3":"DK"},{"1":"1580","2":"自民","3":"自民"},{"1":"1581","2":"棄権","3":"棄権"},{"1":"1582","2":"DK","3":"DK"},{"1":"1583","2":"その他","3":"民主"},{"1":"1584","2":"自民","3":"自民"},{"1":"1585","2":"DK","3":"民主"},{"1":"1586","2":"自民","3":"自民"},{"1":"1587","2":"公明","3":"公明"},{"1":"1588","2":"民主","3":"その他"},{"1":"1589","2":"自民","3":"自民"},{"1":"1590","2":"DK","3":"DK"},{"1":"1591","2":"棄権","3":"DK"},{"1":"1592","2":"その他","3":"民主"},{"1":"1593","2":"公明","3":"民主"},{"1":"1594","2":"自民","3":"民主"},{"1":"1595","2":"民主","3":"民主"},{"1":"1596","2":"公明","3":"公明"},{"1":"1597","2":"民主","3":"民主"},{"1":"1598","2":"棄権","3":"棄権"},{"1":"1599","2":"民主","3":"自民"},{"1":"1600","2":"棄権","3":"自民"},{"1":"1601","2":"棄権","3":"民主"},{"1":"1602","2":"棄権","3":"棄権"},{"1":"1603","2":"その他","3":"DK"},{"1":"1604","2":"その他","3":"民主"},{"1":"1605","2":"その他","3":"その他"},{"1":"1606","2":"その他","3":"民主"},{"1":"1607","2":"民主","3":"共産・社民"},{"1":"1608","2":"棄権","3":"棄権"},{"1":"1609","2":"自民","3":"自民"},{"1":"1610","2":"自民","3":"自民"},{"1":"1611","2":"民主","3":"民主"},{"1":"1612","2":"自民","3":"自民"},{"1":"1613","2":"棄権","3":"棄権"},{"1":"1614","2":"自民","3":"その他"},{"1":"1615","2":"棄権","3":"棄権"},{"1":"1616","2":"民主","3":"民主"},{"1":"1617","2":"自民","3":"棄権"},{"1":"1618","2":"民主","3":"民主"},{"1":"1619","2":"棄権","3":"棄権"},{"1":"1620","2":"その他","3":"自民"},{"1":"1621","2":"民主","3":"民主"},{"1":"1622","2":"その他","3":"その他"},{"1":"1623","2":"民主","3":"民主"},{"1":"1624","2":"自民","3":"自民"},{"1":"1625","2":"その他","3":"棄権"},{"1":"1626","2":"その他","3":"自民"},{"1":"1627","2":"棄権","3":"棄権"},{"1":"1628","2":"自民","3":"自民"},{"1":"1629","2":"民主","3":"民主"},{"1":"1630","2":"DK","3":"DK"},{"1":"1631","2":"民主","3":"民主"},{"1":"1632","2":"DK","3":"DK"},{"1":"1633","2":"共産・社民","3":"民主"},{"1":"1634","2":"自民","3":"民主"},{"1":"1635","2":"自民","3":"棄権"},{"1":"1636","2":"自民","3":"自民"},{"1":"1637","2":"その他","3":"自民"},{"1":"1638","2":"自民","3":"民主"},{"1":"1639","2":"棄権","3":"棄権"},{"1":"1640","2":"自民","3":"民主"},{"1":"1641","2":"自民","3":"自民"},{"1":"1642","2":"民主","3":"共産・社民"},{"1":"1643","2":"自民","3":"自民"},{"1":"1644","2":"民主","3":"民主"},{"1":"1645","2":"棄権","3":"棄権"},{"1":"1646","2":"民主","3":"民主"},{"1":"1647","2":"自民","3":"民主"},{"1":"1648","2":"自民","3":"自民"},{"1":"1649","2":"共産・社民","3":"共産・社民"},{"1":"1650","2":"その他","3":"自民"},{"1":"1651","2":"棄権","3":"DK"},{"1":"1652","2":"自民","3":"自民"},{"1":"1653","2":"民主","3":"民主"},{"1":"1654","2":"民主","3":"民主"},{"1":"1655","2":"民主","3":"民主"},{"1":"1656","2":"民主","3":"民主"},{"1":"1657","2":"共産・社民","3":"共産・社民"},{"1":"1658","2":"民主","3":"民主"},{"1":"1659","2":"自民","3":"自民"},{"1":"1660","2":"棄権","3":"棄権"},{"1":"1661","2":"民主","3":"民主"},{"1":"1662","2":"自民","3":"自民"},{"1":"1663","2":"その他","3":"その他"},{"1":"1664","2":"棄権","3":"棄権"},{"1":"1665","2":"民主","3":"民主"},{"1":"1666","2":"棄権","3":"棄権"},{"1":"1667","2":"DK","3":"DK"},{"1":"1668","2":"民主","3":"DK"},{"1":"1669","2":"民主","3":"民主"},{"1":"1670","2":"民主","3":"民主"},{"1":"1671","2":"棄権","3":"民主"},{"1":"1672","2":"その他","3":"公明"},{"1":"1673","2":"自民","3":"自民"},{"1":"1674","2":"その他","3":"自民"},{"1":"1675","2":"DK","3":"自民"},{"1":"1676","2":"民主","3":"民主"},{"1":"1677","2":"自民","3":"自民"},{"1":"1678","2":"その他","3":"民主"},{"1":"1679","2":"棄権","3":"棄権"},{"1":"1680","2":"その他","3":"民主"},{"1":"1681","2":"DK","3":"民主"},{"1":"1682","2":"民主","3":"民主"},{"1":"1683","2":"民主","3":"民主"},{"1":"1684","2":"DK","3":"DK"},{"1":"1685","2":"自民","3":"自民"},{"1":"1686","2":"民主","3":"民主"},{"1":"1687","2":"民主","3":"DK"},{"1":"1688","2":"自民","3":"自民"},{"1":"1689","2":"民主","3":"民主"},{"1":"1690","2":"民主","3":"民主"},{"1":"1691","2":"DK","3":"DK"},{"1":"1692","2":"その他","3":"民主"},{"1":"1693","2":"共産・社民","3":"民主"},{"1":"1694","2":"その他","3":"共産・社民"},{"1":"1695","2":"自民","3":"自民"},{"1":"1696","2":"民主","3":"民主"},{"1":"1697","2":"民主","3":"民主"},{"1":"1698","2":"DK","3":"民主"},{"1":"1699","2":"公明","3":"公明"},{"1":"1700","2":"民主","3":"民主"},{"1":"1701","2":"棄権","3":"棄権"},{"1":"1702","2":"DK","3":"DK"},{"1":"1703","2":"民主","3":"民主"},{"1":"1704","2":"自民","3":"自民"},{"1":"1705","2":"棄権","3":"棄権"},{"1":"1706","2":"民主","3":"民主"},{"1":"1707","2":"自民","3":"自民"},{"1":"1708","2":"民主","3":"民主"},{"1":"1709","2":"棄権","3":"棄権"},{"1":"1710","2":"民主","3":"民主"},{"1":"1711","2":"民主","3":"民主"},{"1":"1712","2":"民主","3":"民主"},{"1":"1713","2":"民主","3":"自民"},{"1":"1714","2":"自民","3":"自民"},{"1":"1715","2":"自民","3":"自民"},{"1":"1716","2":"民主","3":"民主"},{"1":"1717","2":"その他","3":"その他"},{"1":"1718","2":"自民","3":"自民"},{"1":"1719","2":"民主","3":"民主"},{"1":"1720","2":"棄権","3":"棄権"},{"1":"1721","2":"その他","3":"その他"},{"1":"1722","2":"その他","3":"その他"},{"1":"1723","2":"民主","3":"民主"},{"1":"1724","2":"自民","3":"DK"},{"1":"1725","2":"自民","3":"民主"},{"1":"1726","2":"棄権","3":"棄権"},{"1":"1727","2":"民主","3":"民主"},{"1":"1728","2":"自民","3":"自民"},{"1":"1729","2":"民主","3":"民主"},{"1":"1730","2":"DK","3":"民主"},{"1":"1731","2":"民主","3":"民主"},{"1":"1732","2":"棄権","3":"棄権"},{"1":"1733","2":"棄権","3":"棄権"},{"1":"1734","2":"その他","3":"その他"},{"1":"1735","2":"棄権","3":"棄権"},{"1":"1736","2":"民主","3":"民主"},{"1":"1737","2":"DK","3":"民主"},{"1":"1738","2":"棄権","3":"民主"},{"1":"1739","2":"公明","3":"民主"},{"1":"1740","2":"DK","3":"民主"},{"1":"1741","2":"民主","3":"民主"},{"1":"1742","2":"棄権","3":"民主"},{"1":"1743","2":"棄権","3":"民主"},{"1":"1744","2":"棄権","3":"民主"},{"1":"1745","2":"棄権","3":"棄権"},{"1":"1746","2":"民主","3":"自民"},{"1":"1747","2":"棄権","3":"棄権"},{"1":"1748","2":"DK","3":"棄権"},{"1":"1749","2":"DK","3":"自民"},{"1":"1750","2":"民主","3":"民主"},{"1":"1751","2":"自民","3":"民主"},{"1":"1752","2":"民主","3":"自民"},{"1":"1753","2":"棄権","3":"棄権"},{"1":"1754","2":"その他","3":"その他"},{"1":"1755","2":"公明","3":"棄権"},{"1":"1756","2":"棄権","3":"棄権"},{"1":"1757","2":"民主","3":"民主"},{"1":"1758","2":"棄権","3":"棄権"},{"1":"1759","2":"民主","3":"民主"},{"1":"1760","2":"棄権","3":"棄権"},{"1":"1761","2":"公明","3":"公明"},{"1":"1762","2":"棄権","3":"民主"},{"1":"1763","2":"民主","3":"民主"},{"1":"1764","2":"棄権","3":"棄権"},{"1":"1765","2":"民主","3":"共産・社民"},{"1":"1766","2":"自民","3":"自民"},{"1":"1767","2":"民主","3":"民主"},{"1":"1768","2":"棄権","3":"棄権"},{"1":"1769","2":"自民","3":"自民"},{"1":"1770","2":"棄権","3":"棄権"},{"1":"1771","2":"民主","3":"その他"},{"1":"1772","2":"棄権","3":"棄権"},{"1":"1773","2":"民主","3":"民主"},{"1":"1774","2":"自民","3":"自民"},{"1":"1775","2":"棄権","3":"その他"},{"1":"1776","2":"棄権","3":"棄権"},{"1":"1777","2":"棄権","3":"棄権"},{"1":"1778","2":"民主","3":"民主"},{"1":"1779","2":"自民","3":"自民"},{"1":"1780","2":"民主","3":"民主"},{"1":"1781","2":"民主","3":"民主"},{"1":"1782","2":"民主","3":"民主"},{"1":"1783","2":"民主","3":"民主"},{"1":"1784","2":"民主","3":"民主"},{"1":"1785","2":"棄権","3":"民主"},{"1":"1786","2":"民主","3":"民主"},{"1":"1787","2":"棄権","3":"民主"},{"1":"1788","2":"民主","3":"民主"},{"1":"1789","2":"自民","3":"自民"},{"1":"1790","2":"民主","3":"民主"},{"1":"1791","2":"民主","3":"民主"},{"1":"1792","2":"民主","3":"棄権"},{"1":"1793","2":"棄権","3":"自民"},{"1":"1794","2":"公明","3":"公明"},{"1":"1795","2":"民主","3":"DK"},{"1":"1796","2":"棄権","3":"民主"},{"1":"1797","2":"DK","3":"民主"},{"1":"1798","2":"自民","3":"共産・社民"},{"1":"1799","2":"その他","3":"共産・社民"},{"1":"1800","2":"民主","3":"民主"},{"1":"1801","2":"民主","3":"民主"},{"1":"1802","2":"民主","3":"民主"},{"1":"1803","2":"自民","3":"自民"},{"1":"1804","2":"DK","3":"民主"},{"1":"1805","2":"自民","3":"自民"},{"1":"1806","2":"自民","3":"民主"},{"1":"1807","2":"共産・社民","3":"共産・社民"},{"1":"1808","2":"DK","3":"DK"},{"1":"1809","2":"民主","3":"民主"},{"1":"1810","2":"その他","3":"民主"},{"1":"1811","2":"自民","3":"自民"},{"1":"1812","2":"民主","3":"民主"},{"1":"1813","2":"DK","3":"棄権"},{"1":"1814","2":"民主","3":"自民"},{"1":"1815","2":"棄権","3":"棄権"},{"1":"1816","2":"DK","3":"民主"},{"1":"1817","2":"民主","3":"民主"},{"1":"1818","2":"民主","3":"民主"},{"1":"1819","2":"民主","3":"民主"},{"1":"1820","2":"民主","3":"民主"},{"1":"1821","2":"棄権","3":"棄権"},{"1":"1822","2":"民主","3":"民主"},{"1":"1823","2":"民主","3":"DK"},{"1":"1824","2":"民主","3":"民主"},{"1":"1825","2":"DK","3":"棄権"},{"1":"1826","2":"その他","3":"棄権"},{"1":"1827","2":"共産・社民","3":"共産・社民"},{"1":"1828","2":"棄権","3":"棄権"},{"1":"1829","2":"自民","3":"自民"},{"1":"1830","2":"民主","3":"民主"},{"1":"1831","2":"民主","3":"民主"},{"1":"1832","2":"民主","3":"民主"},{"1":"1833","2":"棄権","3":"棄権"},{"1":"1834","2":"自民","3":"自民"},{"1":"1835","2":"その他","3":"自民"},{"1":"1836","2":"DK","3":"棄権"},{"1":"1837","2":"民主","3":"民主"},{"1":"1838","2":"棄権","3":"その他"},{"1":"1839","2":"民主","3":"民主"},{"1":"1840","2":"DK","3":"民主"},{"1":"1841","2":"民主","3":"民主"},{"1":"1842","2":"自民","3":"自民"},{"1":"1843","2":"自民","3":"自民"},{"1":"1844","2":"DK","3":"DK"},{"1":"1845","2":"共産・社民","3":"民主"},{"1":"1846","2":"民主","3":"民主"},{"1":"1847","2":"その他","3":"共産・社民"},{"1":"1848","2":"DK","3":"民主"},{"1":"1849","2":"自民","3":"棄権"},{"1":"1850","2":"DK","3":"民主"},{"1":"1851","2":"その他","3":"民主"},{"1":"1852","2":"棄権","3":"棄権"},{"1":"1853","2":"棄権","3":"民主"},{"1":"1854","2":"民主","3":"民主"},{"1":"1855","2":"公明","3":"棄権"},{"1":"1856","2":"自民","3":"自民"},{"1":"1857","2":"民主","3":"民主"},{"1":"1858","2":"民主","3":"民主"},{"1":"1859","2":"その他","3":"民主"},{"1":"1860","2":"民主","3":"民主"},{"1":"1861","2":"棄権","3":"民主"},{"1":"1862","2":"棄権","3":"棄権"},{"1":"1863","2":"自民","3":"自民"},{"1":"1864","2":"棄権","3":"棄権"},{"1":"1865","2":"DK","3":"DK"},{"1":"1866","2":"民主","3":"民主"},{"1":"1867","2":"自民","3":"棄権"},{"1":"1868","2":"棄権","3":"共産・社民"},{"1":"1869","2":"自民","3":"自民"},{"1":"1870","2":"共産・社民","3":"共産・社民"},{"1":"1871","2":"自民","3":"自民"},{"1":"1872","2":"棄権","3":"民主"},{"1":"1873","2":"民主","3":"民主"},{"1":"1874","2":"公明","3":"民主"},{"1":"1875","2":"自民","3":"自民"},{"1":"1876","2":"DK","3":"民主"},{"1":"1877","2":"自民","3":"自民"},{"1":"1878","2":"棄権","3":"棄権"},{"1":"1879","2":"その他","3":"民主"},{"1":"1880","2":"棄権","3":"自民"},{"1":"1881","2":"自民","3":"自民"},{"1":"1882","2":"民主","3":"民主"},{"1":"1883","2":"公明","3":"公明"},{"1":"1884","2":"民主","3":"民主"},{"1":"1885","2":"自民","3":"民主"},{"1":"1886","2":"自民","3":"棄権"},{"1":"1887","2":"自民","3":"自民"},{"1":"1888","2":"DK","3":"棄権"},{"1":"1889","2":"DK","3":"民主"},{"1":"1890","2":"その他","3":"民主"},{"1":"1891","2":"棄権","3":"民主"},{"1":"1892","2":"その他","3":"民主"},{"1":"1893","2":"DK","3":"民主"},{"1":"1894","2":"民主","3":"民主"},{"1":"1895","2":"民主","3":"民主"},{"1":"1896","2":"DK","3":"DK"},{"1":"1897","2":"DK","3":"共産・社民"},{"1":"1898","2":"民主","3":"民主"},{"1":"1899","2":"自民","3":"共産・社民"},{"1":"1900","2":"DK","3":"棄権"},{"1":"1901","2":"棄権","3":"DK"},{"1":"1902","2":"DK","3":"棄権"},{"1":"1903","2":"民主","3":"民主"},{"1":"1904","2":"棄権","3":"民主"},{"1":"1905","2":"自民","3":"自民"},{"1":"1906","2":"その他","3":"民主"},{"1":"1907","2":"民主","3":"民主"},{"1":"1908","2":"DK","3":"棄権"},{"1":"1909","2":"DK","3":"DK"},{"1":"1910","2":"民主","3":"民主"},{"1":"1911","2":"その他","3":"民主"},{"1":"1912","2":"DK","3":"棄権"},{"1":"1913","2":"自民","3":"自民"},{"1":"1914","2":"民主","3":"民主"},{"1":"1915","2":"民主","3":"民主"},{"1":"1916","2":"棄権","3":"棄権"},{"1":"1917","2":"民主","3":"民主"},{"1":"1918","2":"棄権","3":"棄権"},{"1":"1919","2":"民主","3":"自民"},{"1":"1920","2":"民主","3":"共産・社民"},{"1":"1921","2":"棄権","3":"棄権"},{"1":"1922","2":"民主","3":"民主"},{"1":"1923","2":"民主","3":"民主"},{"1":"1924","2":"棄権","3":"棄権"},{"1":"1925","2":"民主","3":"民主"},{"1":"1926","2":"DK","3":"民主"},{"1":"1927","2":"DK","3":"民主"},{"1":"1928","2":"民主","3":"民主"},{"1":"1929","2":"民主","3":"民主"},{"1":"1930","2":"DK","3":"DK"},{"1":"1931","2":"自民","3":"自民"},{"1":"1932","2":"DK","3":"棄権"},{"1":"1933","2":"民主","3":"民主"},{"1":"1934","2":"共産・社民","3":"民主"},{"1":"1935","2":"公明","3":"公明"},{"1":"1936","2":"民主","3":"民主"},{"1":"1937","2":"その他","3":"民主"},{"1":"1938","2":"棄権","3":"棄権"},{"1":"1939","2":"公明","3":"公明"},{"1":"1940","2":"民主","3":"民主"},{"1":"1941","2":"自民","3":"共産・社民"},{"1":"1942","2":"棄権","3":"棄権"},{"1":"1943","2":"棄権","3":"民主"},{"1":"1944","2":"棄権","3":"棄権"},{"1":"1945","2":"DK","3":"DK"},{"1":"1946","2":"その他","3":"民主"},{"1":"1947","2":"民主","3":"民主"},{"1":"1948","2":"棄権","3":"棄権"},{"1":"1949","2":"民主","3":"民主"},{"1":"1950","2":"自民","3":"自民"},{"1":"1951","2":"棄権","3":"民主"},{"1":"1952","2":"自民","3":"DK"},{"1":"1953","2":"その他","3":"DK"},{"1":"1954","2":"民主","3":"民主"},{"1":"1955","2":"民主","3":"民主"},{"1":"1956","2":"棄権","3":"自民"},{"1":"1957","2":"DK","3":"DK"},{"1":"1958","2":"棄権","3":"棄権"},{"1":"1959","2":"その他","3":"民主"},{"1":"1960","2":"民主","3":"民主"},{"1":"1961","2":"棄権","3":"自民"},{"1":"1962","2":"その他","3":"自民"},{"1":"1963","2":"共産・社民","3":"共産・社民"},{"1":"1964","2":"民主","3":"民主"},{"1":"1965","2":"棄権","3":"棄権"},{"1":"1966","2":"棄権","3":"棄権"},{"1":"1967","2":"民主","3":"民主"},{"1":"1968","2":"DK","3":"民主"},{"1":"1969","2":"共産・社民","3":"民主"},{"1":"1970","2":"棄権","3":"棄権"},{"1":"1971","2":"自民","3":"自民"},{"1":"1972","2":"共産・社民","3":"共産・社民"},{"1":"1973","2":"公明","3":"DK"},{"1":"1974","2":"公明","3":"公明"},{"1":"1975","2":"民主","3":"民主"},{"1":"1976","2":"その他","3":"その他"},{"1":"1977","2":"民主","3":"民主"},{"1":"1978","2":"棄権","3":"自民"},{"1":"1979","2":"自民","3":"自民"},{"1":"1980","2":"その他","3":"DK"},{"1":"1981","2":"自民","3":"自民"},{"1":"1982","2":"自民","3":"自民"},{"1":"1983","2":"DK","3":"自民"},{"1":"1984","2":"自民","3":"自民"},{"1":"1985","2":"その他","3":"その他"},{"1":"1986","2":"民主","3":"共産・社民"},{"1":"1987","2":"DK","3":"DK"},{"1":"1988","2":"民主","3":"民主"},{"1":"1989","2":"棄権","3":"自民"},{"1":"1990","2":"民主","3":"民主"},{"1":"1991","2":"その他","3":"その他"},{"1":"1992","2":"棄権","3":"DK"},{"1":"1993","2":"自民","3":"自民"},{"1":"1994","2":"棄権","3":"民主"},{"1":"1995","2":"民主","3":"民主"},{"1":"1996","2":"自民","3":"DK"},{"1":"1997","2":"棄権","3":"棄権"},{"1":"1998","2":"その他","3":"自民"},{"1":"1999","2":"その他","3":"自民"},{"1":"2000","2":"民主","3":"民主"},{"1":"2001","2":"棄権","3":"棄権"},{"1":"2002","2":"民主","3":"民主"},{"1":"2003","2":"棄権","3":"棄権"},{"1":"2004","2":"棄権","3":"棄権"},{"1":"2005","2":"その他","3":"DK"},{"1":"2006","2":"民主","3":"民主"},{"1":"2007","2":"公明","3":"その他"},{"1":"2008","2":"民主","3":"民主"},{"1":"2009","2":"DK","3":"共産・社民"},{"1":"2010","2":"DK","3":"棄権"},{"1":"2011","2":"DK","3":"自民"},{"1":"2012","2":"共産・社民","3":"共産・社民"},{"1":"2013","2":"民主","3":"民主"},{"1":"2014","2":"自民","3":"自民"},{"1":"2015","2":"民主","3":"民主"},{"1":"2016","2":"棄権","3":"民主"},{"1":"2017","2":"民主","3":"自民"},{"1":"2018","2":"棄権","3":"棄権"},{"1":"2019","2":"DK","3":"民主"},{"1":"2020","2":"民主","3":"民主"},{"1":"2021","2":"自民","3":"自民"},{"1":"2022","2":"民主","3":"民主"},{"1":"2023","2":"棄権","3":"棄権"},{"1":"2024","2":"自民","3":"自民"},{"1":"2025","2":"棄権","3":"民主"},{"1":"2026","2":"自民","3":"自民"},{"1":"2027","2":"民主","3":"民主"},{"1":"2028","2":"DK","3":"民主"},{"1":"2029","2":"自民","3":"自民"},{"1":"2030","2":"共産・社民","3":"共産・社民"},{"1":"2031","2":"棄権","3":"棄権"},{"1":"2032","2":"自民","3":"その他"},{"1":"2033","2":"自民","3":"共産・社民"},{"1":"2034","2":"棄権","3":"棄権"},{"1":"2035","2":"自民","3":"自民"},{"1":"2036","2":"棄権","3":"その他"},{"1":"2037","2":"棄権","3":"棄権"},{"1":"2038","2":"民主","3":"棄権"},{"1":"2039","2":"棄権","3":"棄権"},{"1":"2040","2":"棄権","3":"民主"},{"1":"2041","2":"自民","3":"民主"},{"1":"2042","2":"自民","3":"棄権"},{"1":"2043","2":"棄権","3":"DK"},{"1":"2044","2":"その他","3":"その他"},{"1":"2045","2":"自民","3":"自民"},{"1":"2046","2":"自民","3":"民主"},{"1":"2047","2":"その他","3":"民主"},{"1":"2048","2":"自民","3":"自民"},{"1":"2049","2":"民主","3":"民主"},{"1":"2050","2":"公明","3":"自民"},{"1":"2051","2":"棄権","3":"棄権"},{"1":"2052","2":"共産・社民","3":"共産・社民"},{"1":"2053","2":"民主","3":"民主"},{"1":"2054","2":"棄権","3":"棄権"},{"1":"2055","2":"民主","3":"民主"},{"1":"2056","2":"民主","3":"民主"},{"1":"2057","2":"公明","3":"公明"},{"1":"2058","2":"その他","3":"その他"},{"1":"2059","2":"DK","3":"棄権"},{"1":"2060","2":"民主","3":"民主"},{"1":"2061","2":"自民","3":"自民"},{"1":"2062","2":"棄権","3":"棄権"},{"1":"2063","2":"自民","3":"自民"},{"1":"2064","2":"棄権","3":"棄権"},{"1":"2065","2":"民主","3":"民主"},{"1":"2066","2":"共産・社民","3":"民主"},{"1":"2067","2":"自民","3":"自民"},{"1":"2068","2":"民主","3":"民主"},{"1":"2069","2":"民主","3":"棄権"},{"1":"2070","2":"DK","3":"民主"},{"1":"2071","2":"民主","3":"民主"},{"1":"2072","2":"自民","3":"自民"},{"1":"2073","2":"棄権","3":"棄権"},{"1":"2074","2":"DK","3":"DK"},{"1":"2075","2":"DK","3":"民主"},{"1":"2076","2":"棄権","3":"公明"},{"1":"2077","2":"自民","3":"自民"},{"1":"2078","2":"自民","3":"自民"},{"1":"2079","2":"自民","3":"棄権"},{"1":"2080","2":"自民","3":"自民"},{"1":"2081","2":"棄権","3":"棄権"},{"1":"2082","2":"民主","3":"民主"},{"1":"2083","2":"共産・社民","3":"共産・社民"},{"1":"2084","2":"棄権","3":"棄権"},{"1":"2085","2":"自民","3":"自民"},{"1":"2086","2":"自民","3":"自民"},{"1":"2087","2":"自民","3":"民主"},{"1":"2088","2":"民主","3":"民主"},{"1":"2089","2":"棄権","3":"棄権"},{"1":"2090","2":"棄権","3":"棄権"},{"1":"2091","2":"自民","3":"自民"},{"1":"2092","2":"棄権","3":"棄権"},{"1":"2093","2":"自民","3":"自民"},{"1":"2094","2":"棄権","3":"民主"},{"1":"2095","2":"DK","3":"民主"},{"1":"2096","2":"その他","3":"DK"},{"1":"2097","2":"棄権","3":"DK"},{"1":"2098","2":"棄権","3":"DK"},{"1":"2099","2":"民主","3":"民主"},{"1":"2100","2":"棄権","3":"棄権"},{"1":"2101","2":"その他","3":"自民"},{"1":"2102","2":"その他","3":"その他"},{"1":"2103","2":"民主","3":"民主"},{"1":"2104","2":"DK","3":"民主"},{"1":"2105","2":"民主","3":"民主"},{"1":"2106","2":"棄権","3":"民主"},{"1":"2107","2":"民主","3":"民主"},{"1":"2108","2":"棄権","3":"DK"},{"1":"2109","2":"棄権","3":"DK"},{"1":"2110","2":"民主","3":"民主"},{"1":"2111","2":"その他","3":"自民"},{"1":"2112","2":"DK","3":"民主"},{"1":"2113","2":"その他","3":"DK"},{"1":"2114","2":"その他","3":"公明"},{"1":"2115","2":"DK","3":"棄権"},{"1":"2116","2":"民主","3":"民主"},{"1":"2117","2":"自民","3":"自民"},{"1":"2118","2":"民主","3":"民主"},{"1":"2119","2":"棄権","3":"棄権"},{"1":"2120","2":"民主","3":"棄権"},{"1":"2121","2":"民主","3":"民主"},{"1":"2122","2":"自民","3":"民主"},{"1":"2123","2":"民主","3":"民主"},{"1":"2124","2":"棄権","3":"民主"},{"1":"2125","2":"その他","3":"棄権"},{"1":"2126","2":"公明","3":"公明"},{"1":"2127","2":"棄権","3":"DK"},{"1":"2128","2":"民主","3":"民主"},{"1":"2129","2":"民主","3":"民主"},{"1":"2130","2":"棄権","3":"棄権"},{"1":"2131","2":"DK","3":"民主"},{"1":"2132","2":"DK","3":"棄権"},{"1":"2133","2":"民主","3":"民主"},{"1":"2134","2":"その他","3":"その他"},{"1":"2135","2":"棄権","3":"民主"},{"1":"2136","2":"自民","3":"自民"},{"1":"2137","2":"棄権","3":"棄権"},{"1":"2138","2":"自民","3":"自民"},{"1":"2139","2":"民主","3":"民主"},{"1":"2140","2":"DK","3":"民主"},{"1":"2141","2":"民主","3":"民主"},{"1":"2142","2":"DK","3":"共産・社民"},{"1":"2143","2":"棄権","3":"DK"},{"1":"2144","2":"自民","3":"自民"},{"1":"2145","2":"その他","3":"自民"},{"1":"2146","2":"自民","3":"自民"},{"1":"2147","2":"棄権","3":"棄権"},{"1":"2148","2":"自民","3":"民主"},{"1":"2149","2":"棄権","3":"棄権"},{"1":"2150","2":"民主","3":"民主"},{"1":"2151","2":"棄権","3":"民主"},{"1":"2152","2":"棄権","3":"棄権"},{"1":"2153","2":"公明","3":"公明"},{"1":"2154","2":"棄権","3":"棄権"},{"1":"2155","2":"DK","3":"DK"},{"1":"2156","2":"棄権","3":"民主"},{"1":"2157","2":"棄権","3":"棄権"},{"1":"2158","2":"共産・社民","3":"共産・社民"},{"1":"2159","2":"棄権","3":"棄権"},{"1":"2160","2":"DK","3":"その他"},{"1":"2161","2":"民主","3":"民主"},{"1":"2162","2":"DK","3":"民主"},{"1":"2163","2":"自民","3":"自民"},{"1":"2164","2":"DK","3":"自民"},{"1":"2165","2":"民主","3":"民主"},{"1":"2166","2":"民主","3":"民主"},{"1":"2167","2":"棄権","3":"棄権"},{"1":"2168","2":"民主","3":"民主"},{"1":"2169","2":"共産・社民","3":"共産・社民"},{"1":"2170","2":"DK","3":"自民"},{"1":"2171","2":"自民","3":"自民"},{"1":"2172","2":"自民","3":"自民"},{"1":"2173","2":"民主","3":"民主"},{"1":"2174","2":"共産・社民","3":"民主"},{"1":"2175","2":"民主","3":"民主"},{"1":"2176","2":"民主","3":"民主"},{"1":"2177","2":"共産・社民","3":"共産・社民"},{"1":"2178","2":"棄権","3":"棄権"},{"1":"2179","2":"自民","3":"棄権"},{"1":"2180","2":"棄権","3":"棄権"},{"1":"2181","2":"民主","3":"民主"},{"1":"2182","2":"自民","3":"民主"},{"1":"2183","2":"その他","3":"民主"},{"1":"2184","2":"棄権","3":"民主"},{"1":"2185","2":"DK","3":"民主"},{"1":"2186","2":"自民","3":"民主"},{"1":"2187","2":"棄権","3":"DK"},{"1":"2188","2":"自民","3":"自民"},{"1":"2189","2":"公明","3":"公明"},{"1":"2190","2":"民主","3":"民主"},{"1":"2191","2":"自民","3":"自民"},{"1":"2192","2":"公明","3":"公明"},{"1":"2193","2":"共産・社民","3":"共産・社民"},{"1":"2194","2":"その他","3":"民主"},{"1":"2195","2":"自民","3":"自民"},{"1":"2196","2":"棄権","3":"棄権"},{"1":"2197","2":"棄権","3":"棄権"},{"1":"2198","2":"民主","3":"民主"},{"1":"2199","2":"その他","3":"共産・社民"},{"1":"2200","2":"棄権","3":"民主"},{"1":"2201","2":"DK","3":"DK"},{"1":"2202","2":"棄権","3":"棄権"},{"1":"2203","2":"民主","3":"民主"},{"1":"2204","2":"棄権","3":"棄権"},{"1":"2205","2":"自民","3":"自民"},{"1":"2206","2":"公明","3":"民主"},{"1":"2207","2":"公明","3":"自民"},{"1":"2208","2":"その他","3":"民主"},{"1":"2209","2":"民主","3":"民主"},{"1":"2210","2":"自民","3":"自民"},{"1":"2211","2":"民主","3":"民主"},{"1":"2212","2":"公明","3":"公明"},{"1":"2213","2":"自民","3":"自民"},{"1":"2214","2":"民主","3":"民主"},{"1":"2215","2":"自民","3":"自民"},{"1":"2216","2":"民主","3":"民主"},{"1":"2217","2":"民主","3":"民主"},{"1":"2218","2":"民主","3":"民主"},{"1":"2219","2":"棄権","3":"棄権"},{"1":"2220","2":"自民","3":"民主"},{"1":"2221","2":"その他","3":"その他"},{"1":"2222","2":"自民","3":"民主"},{"1":"2223","2":"自民","3":"自民"},{"1":"2224","2":"公明","3":"自民"},{"1":"2225","2":"DK","3":"共産・社民"},{"1":"2226","2":"その他","3":"その他"},{"1":"2227","2":"自民","3":"民主"},{"1":"2228","2":"その他","3":"その他"},{"1":"2229","2":"民主","3":"共産・社民"},{"1":"2230","2":"その他","3":"自民"},{"1":"2231","2":"棄権","3":"棄権"},{"1":"2232","2":"その他","3":"その他"},{"1":"2233","2":"棄権","3":"棄権"},{"1":"2234","2":"民主","3":"民主"},{"1":"2235","2":"自民","3":"民主"},{"1":"2236","2":"自民","3":"自民"},{"1":"2237","2":"自民","3":"自民"},{"1":"2238","2":"民主","3":"棄権"},{"1":"2239","2":"民主","3":"民主"},{"1":"2240","2":"DK","3":"民主"},{"1":"2241","2":"その他","3":"その他"},{"1":"2242","2":"自民","3":"DK"},{"1":"2243","2":"共産・社民","3":"共産・社民"},{"1":"2244","2":"自民","3":"DK"},{"1":"2245","2":"DK","3":"DK"},{"1":"2246","2":"棄権","3":"DK"},{"1":"2247","2":"自民","3":"自民"},{"1":"2248","2":"棄権","3":"棄権"},{"1":"2249","2":"棄権","3":"棄権"},{"1":"2250","2":"民主","3":"民主"},{"1":"2251","2":"DK","3":"DK"},{"1":"2252","2":"民主","3":"棄権"},{"1":"2253","2":"民主","3":"民主"},{"1":"2254","2":"DK","3":"民主"},{"1":"2255","2":"その他","3":"その他"},{"1":"2256","2":"DK","3":"DK"},{"1":"2257","2":"公明","3":"公明"},{"1":"2258","2":"公明","3":"公明"},{"1":"2259","2":"その他","3":"棄権"},{"1":"2260","2":"民主","3":"民主"},{"1":"2261","2":"民主","3":"民主"},{"1":"2262","2":"民主","3":"民主"},{"1":"2263","2":"自民","3":"自民"},{"1":"2264","2":"自民","3":"自民"},{"1":"2265","2":"棄権","3":"棄権"},{"1":"2266","2":"民主","3":"民主"},{"1":"2267","2":"棄権","3":"民主"},{"1":"2268","2":"自民","3":"自民"},{"1":"2269","2":"DK","3":"自民"},{"1":"2270","2":"民主","3":"民主"},{"1":"2271","2":"民主","3":"民主"},{"1":"2272","2":"公明","3":"公明"},{"1":"2273","2":"自民","3":"自民"},{"1":"2274","2":"自民","3":"民主"},{"1":"2275","2":"その他","3":"民主"},{"1":"2276","2":"民主","3":"民主"},{"1":"2277","2":"DK","3":"自民"},{"1":"2278","2":"自民","3":"民主"},{"1":"2279","2":"民主","3":"民主"},{"1":"2280","2":"民主","3":"民主"},{"1":"2281","2":"民主","3":"民主"},{"1":"2282","2":"民主","3":"自民"},{"1":"2283","2":"棄権","3":"棄権"},{"1":"2284","2":"民主","3":"民主"},{"1":"2285","2":"DK","3":"自民"},{"1":"2286","2":"民主","3":"共産・社民"},{"1":"2287","2":"DK","3":"自民"},{"1":"2288","2":"共産・社民","3":"共産・社民"},{"1":"2289","2":"民主","3":"民主"},{"1":"2290","2":"自民","3":"自民"},{"1":"2291","2":"棄権","3":"棄権"},{"1":"2292","2":"DK","3":"DK"},{"1":"2293","2":"民主","3":"民主"},{"1":"2294","2":"民主","3":"民主"},{"1":"2295","2":"棄権","3":"棄権"},{"1":"2296","2":"民主","3":"民主"},{"1":"2297","2":"民主","3":"民主"},{"1":"2298","2":"民主","3":"民主"},{"1":"2299","2":"自民","3":"民主"},{"1":"2300","2":"棄権","3":"棄権"},{"1":"2301","2":"自民","3":"自民"},{"1":"2302","2":"自民","3":"自民"},{"1":"2303","2":"自民","3":"棄権"},{"1":"2304","2":"民主","3":"民主"},{"1":"2305","2":"民主","3":"民主"},{"1":"2306","2":"民主","3":"民主"},{"1":"2307","2":"その他","3":"その他"},{"1":"2308","2":"民主","3":"民主"},{"1":"2309","2":"民主","3":"民主"},{"1":"2310","2":"民主","3":"民主"},{"1":"2311","2":"共産・社民","3":"共産・社民"},{"1":"2312","2":"棄権","3":"棄権"},{"1":"2313","2":"棄権","3":"棄権"},{"1":"2314","2":"棄権","3":"民主"},{"1":"2315","2":"その他","3":"その他"},{"1":"2316","2":"民主","3":"民主"},{"1":"2317","2":"共産・社民","3":"共産・社民"},{"1":"2318","2":"棄権","3":"民主"},{"1":"2319","2":"公明","3":"棄権"},{"1":"2320","2":"公明","3":"自民"},{"1":"2321","2":"棄権","3":"棄権"},{"1":"2322","2":"民主","3":"民主"},{"1":"2323","2":"自民","3":"自民"},{"1":"2324","2":"民主","3":"民主"},{"1":"2325","2":"その他","3":"棄権"},{"1":"2326","2":"民主","3":"棄権"},{"1":"2327","2":"棄権","3":"棄権"},{"1":"2328","2":"自民","3":"自民"},{"1":"2329","2":"棄権","3":"棄権"},{"1":"2330","2":"棄権","3":"棄権"},{"1":"2331","2":"棄権","3":"棄権"},{"1":"2332","2":"民主","3":"民主"},{"1":"2333","2":"棄権","3":"棄権"},{"1":"2334","2":"民主","3":"民主"},{"1":"2335","2":"民主","3":"民主"},{"1":"2336","2":"その他","3":"民主"},{"1":"2337","2":"DK","3":"民主"},{"1":"2338","2":"棄権","3":"民主"},{"1":"2339","2":"共産・社民","3":"民主"},{"1":"2340","2":"民主","3":"民主"},{"1":"2341","2":"自民","3":"自民"},{"1":"2342","2":"民主","3":"民主"},{"1":"2343","2":"公明","3":"公明"},{"1":"2344","2":"民主","3":"民主"},{"1":"2345","2":"DK","3":"民主"},{"1":"2346","2":"その他","3":"民主"},{"1":"2347","2":"自民","3":"自民"},{"1":"2348","2":"民主","3":"民主"},{"1":"2349","2":"民主","3":"民主"},{"1":"2350","2":"自民","3":"自民"},{"1":"2351","2":"棄権","3":"棄権"},{"1":"2352","2":"棄権","3":"DK"},{"1":"2353","2":"民主","3":"民主"},{"1":"2354","2":"民主","3":"民主"},{"1":"2355","2":"共産・社民","3":"共産・社民"},{"1":"2356","2":"民主","3":"民主"},{"1":"2357","2":"公明","3":"公明"},{"1":"2358","2":"民主","3":"民主"},{"1":"2359","2":"自民","3":"自民"},{"1":"2360","2":"棄権","3":"民主"},{"1":"2361","2":"棄権","3":"民主"},{"1":"2362","2":"DK","3":"DK"},{"1":"2363","2":"公明","3":"民主"},{"1":"2364","2":"公明","3":"公明"},{"1":"2365","2":"棄権","3":"棄権"},{"1":"2366","2":"棄権","3":"棄権"},{"1":"2367","2":"自民","3":"自民"},{"1":"2368","2":"共産・社民","3":"共産・社民"},{"1":"2369","2":"その他","3":"民主"},{"1":"2370","2":"DK","3":"民主"},{"1":"2371","2":"その他","3":"その他"},{"1":"2372","2":"DK","3":"民主"},{"1":"2373","2":"その他","3":"自民"},{"1":"2374","2":"DK","3":"民主"},{"1":"2375","2":"棄権","3":"棄権"},{"1":"2376","2":"自民","3":"民主"},{"1":"2377","2":"民主","3":"民主"},{"1":"2378","2":"棄権","3":"棄権"},{"1":"2379","2":"棄権","3":"DK"},{"1":"2380","2":"棄権","3":"棄権"},{"1":"2381","2":"棄権","3":"棄権"},{"1":"2382","2":"棄権","3":"棄権"},{"1":"2383","2":"棄権","3":"棄権"},{"1":"2384","2":"公明","3":"民主"},{"1":"2385","2":"DK","3":"棄権"},{"1":"2386","2":"民主","3":"自民"},{"1":"2387","2":"棄権","3":"民主"},{"1":"2388","2":"民主","3":"民主"},{"1":"2389","2":"公明","3":"公明"},{"1":"2390","2":"棄権","3":"棄権"},{"1":"2391","2":"自民","3":"自民"},{"1":"2392","2":"DK","3":"民主"},{"1":"2393","2":"民主","3":"民主"},{"1":"2394","2":"DK","3":"DK"},{"1":"2395","2":"DK","3":"棄権"},{"1":"2396","2":"その他","3":"自民"},{"1":"2397","2":"棄権","3":"民主"},{"1":"2398","2":"共産・社民","3":"自民"},{"1":"2399","2":"民主","3":"民主"},{"1":"2400","2":"民主","3":"民主"},{"1":"2401","2":"棄権","3":"民主"},{"1":"2402","2":"民主","3":"民主"},{"1":"2403","2":"自民","3":"民主"},{"1":"2404","2":"民主","3":"民主"},{"1":"2405","2":"公明","3":"公明"},{"1":"2406","2":"その他","3":"民主"},{"1":"2407","2":"自民","3":"自民"},{"1":"2408","2":"民主","3":"民主"},{"1":"2409","2":"自民","3":"棄権"},{"1":"2410","2":"その他","3":"その他"},{"1":"2411","2":"棄権","3":"棄権"},{"1":"2412","2":"民主","3":"民主"},{"1":"2413","2":"棄権","3":"棄権"},{"1":"2414","2":"自民","3":"自民"},{"1":"2415","2":"棄権","3":"棄権"},{"1":"2416","2":"自民","3":"その他"},{"1":"2417","2":"棄権","3":"DK"},{"1":"2418","2":"その他","3":"民主"},{"1":"2419","2":"DK","3":"DK"},{"1":"2420","2":"民主","3":"民主"},{"1":"2421","2":"その他","3":"その他"},{"1":"2422","2":"自民","3":"自民"},{"1":"2423","2":"その他","3":"自民"},{"1":"2424","2":"棄権","3":"棄権"},{"1":"2425","2":"自民","3":"民主"},{"1":"2426","2":"自民","3":"民主"},{"1":"2427","2":"棄権","3":"棄権"},{"1":"2428","2":"自民","3":"自民"},{"1":"2429","2":"DK","3":"民主"},{"1":"2430","2":"棄権","3":"棄権"},{"1":"2431","2":"棄権","3":"棄権"},{"1":"2432","2":"自民","3":"自民"},{"1":"2433","2":"公明","3":"公明"},{"1":"2434","2":"その他","3":"その他"},{"1":"2435","2":"民主","3":"民主"},{"1":"2436","2":"民主","3":"民主"},{"1":"2437","2":"自民","3":"自民"},{"1":"2438","2":"その他","3":"その他"},{"1":"2439","2":"公明","3":"公明"},{"1":"2440","2":"DK","3":"民主"},{"1":"2441","2":"民主","3":"民主"},{"1":"2442","2":"民主","3":"民主"},{"1":"2443","2":"棄権","3":"棄権"},{"1":"2444","2":"棄権","3":"棄権"},{"1":"2445","2":"自民","3":"自民"},{"1":"2446","2":"その他","3":"民主"},{"1":"2447","2":"その他","3":"その他"},{"1":"2448","2":"民主","3":"民主"},{"1":"2449","2":"民主","3":"民主"},{"1":"2450","2":"民主","3":"民主"},{"1":"2451","2":"民主","3":"民主"},{"1":"2452","2":"民主","3":"民主"},{"1":"2453","2":"棄権","3":"棄権"},{"1":"2454","2":"公明","3":"公明"},{"1":"2455","2":"民主","3":"民主"},{"1":"2456","2":"DK","3":"棄権"},{"1":"2457","2":"民主","3":"民主"},{"1":"2458","2":"共産・社民","3":"共産・社民"},{"1":"2459","2":"その他","3":"民主"},{"1":"2460","2":"自民","3":"民主"},{"1":"2461","2":"棄権","3":"棄権"},{"1":"2462","2":"自民","3":"自民"},{"1":"2463","2":"その他","3":"民主"},{"1":"2464","2":"DK","3":"民主"},{"1":"2465","2":"共産・社民","3":"共産・社民"},{"1":"2466","2":"民主","3":"共産・社民"},{"1":"2467","2":"民主","3":"棄権"},{"1":"2468","2":"その他","3":"共産・社民"},{"1":"2469","2":"民主","3":"民主"},{"1":"2470","2":"公明","3":"公明"},{"1":"2471","2":"DK","3":"DK"},{"1":"2472","2":"民主","3":"民主"},{"1":"2473","2":"公明","3":"公明"},{"1":"2474","2":"棄権","3":"棄権"},{"1":"2475","2":"民主","3":"民主"},{"1":"2476","2":"その他","3":"自民"},{"1":"2477","2":"その他","3":"民主"},{"1":"2478","2":"棄権","3":"棄権"},{"1":"2479","2":"棄権","3":"民主"},{"1":"2480","2":"棄権","3":"民主"},{"1":"2481","2":"自民","3":"民主"},{"1":"2482","2":"民主","3":"民主"},{"1":"2483","2":"DK","3":"自民"},{"1":"2484","2":"民主","3":"民主"},{"1":"2485","2":"自民","3":"自民"},{"1":"2486","2":"棄権","3":"棄権"},{"1":"2487","2":"民主","3":"自民"},{"1":"2488","2":"自民","3":"民主"},{"1":"2489","2":"その他","3":"その他"},{"1":"2490","2":"その他","3":"自民"},{"1":"2491","2":"民主","3":"民主"},{"1":"2492","2":"公明","3":"公明"},{"1":"2493","2":"棄権","3":"民主"},{"1":"2494","2":"自民","3":"自民"},{"1":"2495","2":"公明","3":"公明"},{"1":"2496","2":"民主","3":"民主"},{"1":"2497","2":"自民","3":"棄権"},{"1":"2498","2":"その他","3":"その他"},{"1":"2499","2":"公明","3":"民主"},{"1":"2500","2":"DK","3":"民主"},{"1":"2501","2":"民主","3":"民主"},{"1":"2502","2":"棄権","3":"棄権"},{"1":"2503","2":"棄権","3":"DK"},{"1":"2504","2":"棄権","3":"棄権"},{"1":"2505","2":"棄権","3":"棄権"},{"1":"2506","2":"民主","3":"棄権"},{"1":"2507","2":"民主","3":"民主"},{"1":"2508","2":"民主","3":"民主"},{"1":"2509","2":"DK","3":"共産・社民"},{"1":"2510","2":"民主","3":"民主"},{"1":"2511","2":"民主","3":"DK"},{"1":"2512","2":"民主","3":"民主"},{"1":"2513","2":"その他","3":"自民"},{"1":"2514","2":"自民","3":"自民"},{"1":"2515","2":"その他","3":"民主"},{"1":"2516","2":"棄権","3":"棄権"},{"1":"2517","2":"棄権","3":"民主"},{"1":"2518","2":"DK","3":"DK"},{"1":"2519","2":"民主","3":"民主"},{"1":"2520","2":"DK","3":"棄権"},{"1":"2521","2":"棄権","3":"自民"},{"1":"2522","2":"共産・社民","3":"共産・社民"},{"1":"2523","2":"公明","3":"公明"},{"1":"2524","2":"民主","3":"共産・社民"},{"1":"2525","2":"DK","3":"DK"},{"1":"2526","2":"棄権","3":"DK"},{"1":"2527","2":"民主","3":"その他"},{"1":"2528","2":"DK","3":"DK"},{"1":"2529","2":"その他","3":"その他"},{"1":"2530","2":"民主","3":"民主"},{"1":"2531","2":"DK","3":"DK"},{"1":"2532","2":"DK","3":"DK"},{"1":"2533","2":"民主","3":"民主"},{"1":"2534","2":"その他","3":"民主"},{"1":"2535","2":"棄権","3":"棄権"},{"1":"2536","2":"棄権","3":"民主"},{"1":"2537","2":"民主","3":"民主"},{"1":"2538","2":"自民","3":"自民"},{"1":"2539","2":"自民","3":"自民"},{"1":"2540","2":"公明","3":"公明"},{"1":"2541","2":"自民","3":"民主"},{"1":"2542","2":"棄権","3":"DK"},{"1":"2543","2":"自民","3":"自民"},{"1":"2544","2":"自民","3":"その他"},{"1":"2545","2":"民主","3":"民主"},{"1":"2546","2":"DK","3":"DK"},{"1":"2547","2":"民主","3":"民主"},{"1":"2548","2":"民主","3":"民主"},{"1":"2549","2":"DK","3":"民主"},{"1":"2550","2":"自民","3":"棄権"},{"1":"2551","2":"自民","3":"自民"},{"1":"2552","2":"自民","3":"自民"},{"1":"2553","2":"棄権","3":"棄権"},{"1":"2554","2":"共産・社民","3":"民主"},{"1":"2555","2":"DK","3":"自民"},{"1":"2556","2":"公明","3":"公明"},{"1":"2557","2":"民主","3":"民主"},{"1":"2558","2":"DK","3":"民主"},{"1":"2559","2":"公明","3":"公明"},{"1":"2560","2":"民主","3":"公明"},{"1":"2561","2":"公明","3":"公明"},{"1":"2562","2":"棄権","3":"民主"},{"1":"2563","2":"棄権","3":"棄権"},{"1":"2564","2":"民主","3":"民主"},{"1":"2565","2":"民主","3":"民主"},{"1":"2566","2":"民主","3":"民主"},{"1":"2567","2":"棄権","3":"棄権"},{"1":"2568","2":"自民","3":"民主"},{"1":"2569","2":"自民","3":"自民"},{"1":"2570","2":"その他","3":"共産・社民"},{"1":"2571","2":"棄権","3":"民主"},{"1":"2572","2":"民主","3":"自民"},{"1":"2573","2":"その他","3":"DK"},{"1":"2574","2":"棄権","3":"民主"},{"1":"2575","2":"公明","3":"公明"},{"1":"2576","2":"棄権","3":"棄権"},{"1":"2577","2":"棄権","3":"棄権"},{"1":"2578","2":"DK","3":"棄権"},{"1":"2579","2":"DK","3":"民主"},{"1":"2580","2":"自民","3":"棄権"},{"1":"2581","2":"民主","3":"民主"},{"1":"2582","2":"DK","3":"共産・社民"},{"1":"2583","2":"民主","3":"民主"},{"1":"2584","2":"自民","3":"自民"},{"1":"2585","2":"民主","3":"民主"},{"1":"2586","2":"民主","3":"民主"},{"1":"2587","2":"自民","3":"自民"},{"1":"2588","2":"自民","3":"自民"},{"1":"2589","2":"DK","3":"その他"},{"1":"2590","2":"民主","3":"民主"},{"1":"2591","2":"民主","3":"民主"},{"1":"2592","2":"民主","3":"民主"},{"1":"2593","2":"民主","3":"民主"},{"1":"2594","2":"DK","3":"DK"},{"1":"2595","2":"民主","3":"民主"},{"1":"2596","2":"民主","3":"民主"},{"1":"2597","2":"DK","3":"DK"},{"1":"2598","2":"民主","3":"民主"},{"1":"2599","2":"DK","3":"その他"},{"1":"2600","2":"棄権","3":"DK"},{"1":"2601","2":"棄権","3":"棄権"},{"1":"2602","2":"その他","3":"公明"},{"1":"2603","2":"民主","3":"民主"},{"1":"2604","2":"民主","3":"民主"},{"1":"2605","2":"民主","3":"民主"},{"1":"2606","2":"棄権","3":"棄権"},{"1":"2607","2":"自民","3":"自民"},{"1":"2608","2":"DK","3":"民主"},{"1":"2609","2":"自民","3":"民主"},{"1":"2610","2":"棄権","3":"棄権"},{"1":"2611","2":"棄権","3":"民主"},{"1":"2612","2":"民主","3":"棄権"},{"1":"2613","2":"棄権","3":"棄権"},{"1":"2614","2":"棄権","3":"共産・社民"},{"1":"2615","2":"DK","3":"DK"},{"1":"2616","2":"棄権","3":"棄権"},{"1":"2617","2":"民主","3":"棄権"},{"1":"2618","2":"棄権","3":"民主"},{"1":"2619","2":"共産・社民","3":"共産・社民"},{"1":"2620","2":"DK","3":"その他"},{"1":"2621","2":"その他","3":"民主"},{"1":"2622","2":"棄権","3":"棄権"},{"1":"2623","2":"DK","3":"DK"},{"1":"2624","2":"棄権","3":"棄権"},{"1":"2625","2":"自民","3":"民主"},{"1":"2626","2":"自民","3":"自民"},{"1":"2627","2":"自民","3":"自民"},{"1":"2628","2":"民主","3":"民主"},{"1":"2629","2":"民主","3":"DK"},{"1":"2630","2":"自民","3":"DK"},{"1":"2631","2":"棄権","3":"民主"},{"1":"2632","2":"自民","3":"自民"},{"1":"2633","2":"自民","3":"自民"},{"1":"2634","2":"共産・社民","3":"共産・社民"},{"1":"2635","2":"民主","3":"民主"},{"1":"2636","2":"民主","3":"民主"},{"1":"2637","2":"民主","3":"民主"},{"1":"2638","2":"民主","3":"民主"},{"1":"2639","2":"自民","3":"自民"},{"1":"2640","2":"DK","3":"DK"},{"1":"2641","2":"自民","3":"自民"},{"1":"2642","2":"自民","3":"その他"},{"1":"2643","2":"民主","3":"民主"},{"1":"2644","2":"民主","3":"民主"},{"1":"2645","2":"DK","3":"民主"},{"1":"2646","2":"棄権","3":"民主"},{"1":"2647","2":"その他","3":"民主"},{"1":"2648","2":"民主","3":"共産・社民"},{"1":"2649","2":"民主","3":"民主"},{"1":"2650","2":"民主","3":"民主"},{"1":"2651","2":"共産・社民","3":"共産・社民"},{"1":"2652","2":"民主","3":"民主"},{"1":"2653","2":"共産・社民","3":"共産・社民"},{"1":"2654","2":"公明","3":"公明"},{"1":"2655","2":"共産・社民","3":"民主"},{"1":"2656","2":"民主","3":"民主"},{"1":"2657","2":"自民","3":"民主"},{"1":"2658","2":"その他","3":"DK"},{"1":"2659","2":"その他","3":"その他"},{"1":"2660","2":"棄権","3":"棄権"},{"1":"2661","2":"民主","3":"民主"},{"1":"2662","2":"自民","3":"民主"},{"1":"2663","2":"棄権","3":"自民"},{"1":"2664","2":"自民","3":"公明"},{"1":"2665","2":"DK","3":"自民"},{"1":"2666","2":"棄権","3":"公明"},{"1":"2667","2":"民主","3":"民主"},{"1":"2668","2":"棄権","3":"公明"},{"1":"2669","2":"棄権","3":"棄権"},{"1":"2670","2":"その他","3":"共産・社民"},{"1":"2671","2":"棄権","3":"民主"},{"1":"2672","2":"民主","3":"民主"},{"1":"2673","2":"共産・社民","3":"共産・社民"},{"1":"2674","2":"民主","3":"民主"},{"1":"2675","2":"民主","3":"民主"},{"1":"2676","2":"民主","3":"民主"},{"1":"2677","2":"民主","3":"民主"},{"1":"2678","2":"DK","3":"その他"},{"1":"2679","2":"民主","3":"民主"},{"1":"2680","2":"棄権","3":"その他"},{"1":"2681","2":"民主","3":"民主"},{"1":"2682","2":"棄権","3":"棄権"},{"1":"2683","2":"自民","3":"自民"},{"1":"2684","2":"自民","3":"民主"},{"1":"2685","2":"民主","3":"民主"},{"1":"2686","2":"棄権","3":"民主"},{"1":"2687","2":"民主","3":"民主"},{"1":"2688","2":"自民","3":"自民"},{"1":"2689","2":"共産・社民","3":"共産・社民"},{"1":"2690","2":"その他","3":"自民"},{"1":"2691","2":"自民","3":"自民"},{"1":"2692","2":"その他","3":"その他"},{"1":"2693","2":"自民","3":"自民"},{"1":"2694","2":"DK","3":"棄権"},{"1":"2695","2":"民主","3":"民主"},{"1":"2696","2":"民主","3":"民主"},{"1":"2697","2":"民主","3":"民主"},{"1":"2698","2":"共産・社民","3":"共産・社民"},{"1":"2699","2":"その他","3":"自民"},{"1":"2700","2":"民主","3":"民主"},{"1":"2701","2":"自民","3":"自民"},{"1":"2702","2":"棄権","3":"棄権"},{"1":"2703","2":"民主","3":"民主"},{"1":"2704","2":"民主","3":"民主"},{"1":"2705","2":"自民","3":"自民"},{"1":"2706","2":"DK","3":"DK"},{"1":"2707","2":"棄権","3":"棄権"},{"1":"2708","2":"棄権","3":"棄権"},{"1":"2709","2":"その他","3":"民主"},{"1":"2710","2":"自民","3":"自民"},{"1":"2711","2":"民主","3":"民主"},{"1":"2712","2":"自民","3":"自民"},{"1":"2713","2":"民主","3":"民主"},{"1":"2714","2":"民主","3":"民主"},{"1":"2715","2":"棄権","3":"棄権"},{"1":"2716","2":"DK","3":"民主"},{"1":"2717","2":"自民","3":"自民"},{"1":"2718","2":"共産・社民","3":"民主"},{"1":"2719","2":"その他","3":"その他"},{"1":"2720","2":"棄権","3":"棄権"},{"1":"2721","2":"DK","3":"民主"},{"1":"2722","2":"民主","3":"民主"},{"1":"2723","2":"民主","3":"民主"},{"1":"2724","2":"DK","3":"DK"},{"1":"2725","2":"自民","3":"自民"},{"1":"2726","2":"民主","3":"自民"},{"1":"2727","2":"棄権","3":"棄権"},{"1":"2728","2":"DK","3":"棄権"},{"1":"2729","2":"民主","3":"民主"},{"1":"2730","2":"その他","3":"民主"},{"1":"2731","2":"民主","3":"民主"},{"1":"2732","2":"棄権","3":"民主"},{"1":"2733","2":"棄権","3":"棄権"},{"1":"2734","2":"DK","3":"棄権"},{"1":"2735","2":"棄権","3":"棄権"},{"1":"2736","2":"棄権","3":"棄権"},{"1":"2737","2":"民主","3":"民主"},{"1":"2738","2":"民主","3":"民主"},{"1":"2739","2":"DK","3":"DK"},{"1":"2740","2":"自民","3":"自民"},{"1":"2741","2":"民主","3":"民主"},{"1":"2742","2":"自民","3":"自民"},{"1":"2743","2":"自民","3":"棄権"},{"1":"2744","2":"棄権","3":"棄権"},{"1":"2745","2":"棄権","3":"棄権"},{"1":"2746","2":"民主","3":"棄権"},{"1":"2747","2":"棄権","3":"棄権"},{"1":"2748","2":"民主","3":"民主"},{"1":"2749","2":"その他","3":"民主"},{"1":"2750","2":"棄権","3":"棄権"},{"1":"2751","2":"民主","3":"共産・社民"},{"1":"2752","2":"民主","3":"棄権"},{"1":"2753","2":"民主","3":"民主"},{"1":"2754","2":"自民","3":"自民"},{"1":"2755","2":"民主","3":"民主"},{"1":"2756","2":"自民","3":"民主"},{"1":"2757","2":"棄権","3":"民主"},{"1":"2758","2":"民主","3":"民主"},{"1":"2759","2":"自民","3":"民主"},{"1":"2760","2":"共産・社民","3":"棄権"},{"1":"2761","2":"民主","3":"民主"},{"1":"2762","2":"その他","3":"その他"},{"1":"2763","2":"棄権","3":"共産・社民"},{"1":"2764","2":"公明","3":"公明"},{"1":"2765","2":"民主","3":"民主"},{"1":"2766","2":"自民","3":"DK"},{"1":"2767","2":"棄権","3":"棄権"},{"1":"2768","2":"自民","3":"自民"},{"1":"2769","2":"公明","3":"公明"},{"1":"2770","2":"自民","3":"自民"},{"1":"2771","2":"DK","3":"自民"},{"1":"2772","2":"民主","3":"自民"},{"1":"2773","2":"民主","3":"民主"},{"1":"2774","2":"民主","3":"民主"},{"1":"2775","2":"自民","3":"自民"},{"1":"2776","2":"棄権","3":"民主"},{"1":"2777","2":"自民","3":"自民"},{"1":"2778","2":"その他","3":"民主"},{"1":"2779","2":"民主","3":"民主"},{"1":"2780","2":"DK","3":"DK"},{"1":"2781","2":"棄権","3":"棄権"},{"1":"2782","2":"DK","3":"棄権"},{"1":"2783","2":"民主","3":"民主"},{"1":"2784","2":"DK","3":"DK"},{"1":"2785","2":"自民","3":"自民"},{"1":"2786","2":"自民","3":"自民"},{"1":"2787","2":"自民","3":"その他"},{"1":"2788","2":"民主","3":"民主"},{"1":"2789","2":"民主","3":"民主"},{"1":"2790","2":"民主","3":"民主"},{"1":"2791","2":"DK","3":"民主"},{"1":"2792","2":"その他","3":"民主"},{"1":"2793","2":"自民","3":"DK"},{"1":"2794","2":"自民","3":"公明"},{"1":"2795","2":"公明","3":"棄権"},{"1":"2796","2":"自民","3":"民主"},{"1":"2797","2":"棄権","3":"民主"},{"1":"2798","2":"民主","3":"民主"},{"1":"2799","2":"自民","3":"民主"},{"1":"2800","2":"民主","3":"民主"},{"1":"2801","2":"共産・社民","3":"共産・社民"},{"1":"2802","2":"棄権","3":"棄権"},{"1":"2803","2":"公明","3":"公明"},{"1":"2804","2":"自民","3":"民主"},{"1":"2805","2":"民主","3":"民主"},{"1":"2806","2":"棄権","3":"棄権"},{"1":"2807","2":"DK","3":"DK"},{"1":"2808","2":"棄権","3":"棄権"},{"1":"2809","2":"公明","3":"民主"},{"1":"2810","2":"その他","3":"民主"},{"1":"2811","2":"自民","3":"自民"},{"1":"2812","2":"公明","3":"公明"},{"1":"2813","2":"棄権","3":"棄権"},{"1":"2814","2":"棄権","3":"棄権"},{"1":"2815","2":"自民","3":"自民"},{"1":"2816","2":"棄権","3":"棄権"},{"1":"2817","2":"民主","3":"民主"},{"1":"2818","2":"共産・社民","3":"共産・社民"},{"1":"2819","2":"その他","3":"民主"},{"1":"2820","2":"棄権","3":"棄権"},{"1":"2821","2":"その他","3":"民主"},{"1":"2822","2":"民主","3":"民主"},{"1":"2823","2":"棄権","3":"棄権"},{"1":"2824","2":"自民","3":"自民"},{"1":"2825","2":"その他","3":"自民"},{"1":"2826","2":"DK","3":"棄権"},{"1":"2827","2":"DK","3":"DK"},{"1":"2828","2":"棄権","3":"棄権"},{"1":"2829","2":"棄権","3":"棄権"},{"1":"2830","2":"その他","3":"民主"},{"1":"2831","2":"民主","3":"民主"},{"1":"2832","2":"民主","3":"民主"},{"1":"2833","2":"自民","3":"棄権"},{"1":"2834","2":"DK","3":"民主"},{"1":"2835","2":"自民","3":"自民"},{"1":"2836","2":"その他","3":"棄権"},{"1":"2837","2":"民主","3":"民主"},{"1":"2838","2":"自民","3":"自民"},{"1":"2839","2":"DK","3":"DK"},{"1":"2840","2":"棄権","3":"棄権"},{"1":"2841","2":"DK","3":"民主"},{"1":"2842","2":"公明","3":"公明"},{"1":"2843","2":"共産・社民","3":"共産・社民"},{"1":"2844","2":"棄権","3":"民主"},{"1":"2845","2":"棄権","3":"棄権"},{"1":"2846","2":"民主","3":"民主"},{"1":"2847","2":"共産・社民","3":"共産・社民"},{"1":"2848","2":"自民","3":"自民"},{"1":"2849","2":"公明","3":"公明"},{"1":"2850","2":"自民","3":"民主"},{"1":"2851","2":"民主","3":"民主"},{"1":"2852","2":"民主","3":"民主"},{"1":"2853","2":"公明","3":"公明"},{"1":"2854","2":"その他","3":"DK"},{"1":"2855","2":"民主","3":"民主"},{"1":"2856","2":"民主","3":"民主"},{"1":"2857","2":"棄権","3":"棄権"},{"1":"2858","2":"DK","3":"棄権"},{"1":"2859","2":"その他","3":"民主"},{"1":"2860","2":"自民","3":"自民"},{"1":"2861","2":"自民","3":"自民"},{"1":"2862","2":"棄権","3":"DK"},{"1":"2863","2":"自民","3":"自民"},{"1":"2864","2":"共産・社民","3":"民主"},{"1":"2865","2":"民主","3":"棄権"},{"1":"2866","2":"民主","3":"民主"},{"1":"2867","2":"民主","3":"民主"},{"1":"2868","2":"民主","3":"民主"},{"1":"2869","2":"DK","3":"棄権"},{"1":"2870","2":"民主","3":"民主"},{"1":"2871","2":"自民","3":"自民"},{"1":"2872","2":"DK","3":"棄権"},{"1":"2873","2":"自民","3":"自民"},{"1":"2874","2":"民主","3":"民主"},{"1":"2875","2":"棄権","3":"棄権"},{"1":"2876","2":"その他","3":"DK"},{"1":"2877","2":"民主","3":"民主"},{"1":"2878","2":"民主","3":"民主"},{"1":"2879","2":"自民","3":"その他"},{"1":"2880","2":"民主","3":"民主"},{"1":"2881","2":"民主","3":"民主"},{"1":"2882","2":"棄権","3":"棄権"},{"1":"2883","2":"公明","3":"公明"},{"1":"2884","2":"民主","3":"民主"},{"1":"2885","2":"公明","3":"公明"},{"1":"2886","2":"民主","3":"民主"},{"1":"2887","2":"民主","3":"棄権"},{"1":"2888","2":"民主","3":"民主"},{"1":"2889","2":"民主","3":"民主"},{"1":"2890","2":"DK","3":"民主"},{"1":"2891","2":"公明","3":"公明"},{"1":"2892","2":"民主","3":"民主"},{"1":"2893","2":"DK","3":"民主"},{"1":"2894","2":"DK","3":"棄権"},{"1":"2895","2":"棄権","3":"棄権"},{"1":"2896","2":"民主","3":"民主"},{"1":"2897","2":"公明","3":"自民"},{"1":"2898","2":"民主","3":"その他"},{"1":"2899","2":"自民","3":"棄権"},{"1":"2900","2":"棄権","3":"棄権"},{"1":"2901","2":"DK","3":"公明"},{"1":"2902","2":"その他","3":"その他"},{"1":"2903","2":"棄権","3":"棄権"},{"1":"2904","2":"自民","3":"自民"},{"1":"2905","2":"民主","3":"民主"},{"1":"2906","2":"その他","3":"民主"},{"1":"2907","2":"民主","3":"民主"},{"1":"2908","2":"棄権","3":"共産・社民"},{"1":"2909","2":"自民","3":"自民"},{"1":"2910","2":"民主","3":"民主"},{"1":"2911","2":"民主","3":"民主"},{"1":"2912","2":"公明","3":"公明"},{"1":"2913","2":"民主","3":"民主"},{"1":"2914","2":"棄権","3":"棄権"},{"1":"2915","2":"民主","3":"民主"},{"1":"2916","2":"民主","3":"民主"},{"1":"2917","2":"DK","3":"自民"},{"1":"2918","2":"自民","3":"自民"},{"1":"2919","2":"自民","3":"自民"},{"1":"2920","2":"共産・社民","3":"棄権"},{"1":"2921","2":"棄権","3":"民主"},{"1":"2922","2":"DK","3":"棄権"},{"1":"2923","2":"その他","3":"DK"},{"1":"2924","2":"DK","3":"DK"},{"1":"2925","2":"民主","3":"民主"},{"1":"2926","2":"民主","3":"民主"},{"1":"2927","2":"自民","3":"自民"},{"1":"2928","2":"その他","3":"民主"},{"1":"2929","2":"自民","3":"自民"},{"1":"2930","2":"その他","3":"民主"},{"1":"2931","2":"自民","3":"自民"},{"1":"2932","2":"民主","3":"民主"},{"1":"2933","2":"DK","3":"民主"},{"1":"2934","2":"民主","3":"棄権"},{"1":"2935","2":"棄権","3":"自民"},{"1":"2936","2":"DK","3":"棄権"},{"1":"2937","2":"DK","3":"自民"},{"1":"2938","2":"民主","3":"民主"},{"1":"2939","2":"民主","3":"民主"},{"1":"2940","2":"民主","3":"その他"},{"1":"2941","2":"DK","3":"DK"},{"1":"2942","2":"公明","3":"公明"},{"1":"2943","2":"その他","3":"その他"},{"1":"2944","2":"自民","3":"民主"},{"1":"2945","2":"民主","3":"DK"},{"1":"2946","2":"公明","3":"公明"},{"1":"2947","2":"棄権","3":"棄権"},{"1":"2948","2":"民主","3":"民主"},{"1":"2949","2":"その他","3":"民主"},{"1":"2950","2":"公明","3":"公明"},{"1":"2951","2":"民主","3":"共産・社民"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

|変数名|説明|
|---|---|
|`ID`|回答者ID|
|`Vote09`|2009年衆院選における投票先|
|`Vote10`|2010年参院選における投票先|

　たとえば、1番目の回答者は2009年に棄権し、2010年も棄権したことを意味する。また、5番目の回答者は2009年に自民党に投票し、2010年は共産党または社民党に投票したことを意味する。続いて、このデータを{ggalluvial}に適した形式のデータに加工します。具体的には「2009年棄権、かつ2010年棄権」、「2009年棄権、かつ2010年自民党投票」、...、「2009年民主党投票、かつ2010年自民党投票」のように全ての組み合わせに対し、該当するケース数を計算する必要があります。今回のデータだと、投票先はいずれも自民、民主、公明、共産・社民、その他、棄権、DK (わからない)の7であるため、49パターンができます。それぞれのパターンに該当するケース数を計算するためには`Vote09`と`Vote10`でデータをグループ化し、ケース数を計算します。


```{.r .numberLines}
Vote_0910 <- Vote_0910 %>%
  group_by(Vote09, Vote10) %>%
  summarise(Freq    = n(),
            .groups = "drop")

Vote_0910
```

```
## # A tibble: 47 x 3
##    Vote09 Vote10      Freq
##    <chr>  <chr>      <int>
##  1 DK     DK           111
##  2 DK     その他         8
##  3 DK     公明           7
##  4 DK     共産・社民    15
##  5 DK     棄権          57
##  6 DK     民主         116
##  7 DK     自民          29
##  8 その他 DK            18
##  9 その他 その他        73
## 10 その他 公明           4
## # ... with 37 more rows
```

　2009年の調査で「わからない」と回答し、2010年の調査でも「わからない」と回答した回答者数は111名、2009年の調査で「わからない」と回答し、2010年の調査では「棄権」と回答した回答者数は8名、...といったことが分かりますね。

　続いて、グラフを作成する前に投票先変数 (`Vote09`と`Vote10`)をfactor化します。可視化の際、投票先が出力される順番に決まりはありませんが、自民、民主、公明、...、DKの順が自然かと思います。むろん、こちらは自分から見て分かりやいように順番を決めましょう。ただし、2変数における水準 (level)の順番は一致させた方が良いでしょう。


```{.r .numberLines}
Vote_0910 <- Vote_0910 %>%
  mutate(Vote09 = factor(Vote09, levels = c("自民", "民主", "公明", "共産・社民", 
                                            "その他", "棄権", "DK")),
         Vote10 = factor(Vote10, levels = c("自民", "民主", "公明", "共産・社民", 
                                            "その他", "棄権", "DK")))
```

　それでは沖積図を描いてみましょう。使用する幾何オブジェクトは`geom_alluvium()`と`geom_stratum()`です。必ずこの順番でレイヤーを重ねてください。マッピングは`y`、`axis1`、`axis2`に対し、`y`には当該パターン内のケース数 (`Freq`)、`axis1`は2009年の投票先 (`Vote09`)、`axis2`は2010年の投票先 (`Vote10`)を指定します[^alluvial1]。これらのマッピングは`geom_stratum()`と`geom_alluvim()`共通であるため、`ggplot()`内でマッピングした方が効率的です。

[^alluvial1]: 今回は2期間の変化を示していますが、3期以上の場合、`axis3`、`axis4`、...と追加してください。


```{.r .numberLines}
Vote_0910 %>%
    ggplot(aes(y = Freq, axis1 = Vote09, axis2 = Vote10)) +
    geom_alluvium() +
    geom_stratum()
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-alluvial6-1} \end{center}

　何かの図は出てきましたが、これだけだと、それぞれの四角形がどの政党を示しているのかが分かりませんね。四角形内に政党名を出力するためには{ggplot2}内蔵の`geom_text()`を使用します。マッピング要素は`ggplot()`内でマッピングしたものに加え、`label`が必要ですが、ここでは`after_stat(stratum)`を指定します。そして、`aes()`のその側に`stat = "stratum"`を指定するだけです。フォントの指定が必要な場合は`family`を使います。`theme_*()`内で`base_family`を指定した場合でも必要です。


```{.r .numberLines}
Vote_0910 %>%
    ggplot(aes(y = Freq, axis1 = Vote09, axis2 = Vote10)) +
    geom_alluvium() +
    geom_stratum() +
    geom_text(aes(label = after_stat(stratum)), 
              stat = "stratum", family = "HiraginoSans-W3")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-alluvial7-1} \end{center}

　これで沖積図はとりあえず完成ですが、少し読みやすく加工してみましょう。たとえば、2010年に民主党に投票した回答者において2009年の投票先の割合を見たいとした場合、`geom_alluvium()`内に`fill = Vote09`をマッピングします。これで帯に2009年の投票先ごとの色付けができます。


```{.r .numberLines}
Vote_0910 %>%
    ggplot(aes(y = Freq, axis1 = Vote09, axis2 = Vote10)) +
    geom_alluvium(aes(fill = Vote09)) +
    geom_stratum() +
    geom_text(aes(label = after_stat(stratum)), 
              stat = "stratum", family = "HiraginoSans-W3")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-alluvial8-1} \end{center}

　`fill = Vote10`とマッピングした場合は、感覚が変わります。実際にやってみましょう。


```{.r .numberLines}
Alluvial_Plot <- Vote_0910 %>%
    ggplot(aes(y = Freq, axis1 = Vote09, axis2 = Vote10)) +
    geom_alluvium(aes(fill = Vote10)) +
    geom_stratum() +
    geom_text(aes(label = after_stat(stratum)), 
              stat = "stratum", family = "HiraginoSans-W3")

Alluvial_Plot
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-alluvial9-1} \end{center}

　この場合、2009年に民主党に投票した人が2010年にどこに流れたかが分かりやすくなります。`Vote09`に色分けするか、`Vote10`に色分けするかは作成する人が決める問題であり、自分の主張・メッセージに適したマッピングをしましょう。

　最後に、図をもう少し加工してみましょう。まず、横軸に0.8、1.2、1.6、2.0となっている目盛りを修正し、1と2の箇所に「2009年衆院選」と「2010年参院選」を出力します。これは`scale_x_continuous()`で調整可能です。そして、`theme_minimal()`で余計なものを排除したテーマを適用します。最後に`theme()`内で全ての凡例を削除 (`legend.position = "none"`)し、パネルのグリッド (`panel.grid`)と縦軸・横軸のタイトル (`axis.title`)、縦軸の目盛りラベル (`axis.text.y`)を削除 (`element_blank()`)します。


```{.r .numberLines}
Alluvial_Plot +
    scale_x_continuous(breaks = 1:2, 
                       labels = c("2009年衆院選", "2010年参院選")) +
    theme_minimal(base_family = "HiraginoSans-W3",
                  base_size   = 16) +
    theme(legend.position = "none",
          panel.grid = element_blank(),
          axis.title = element_blank(),
          axis.text.y = element_blank())
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-alluvial10-1} \end{center}

　これでだいぶスッキリした沖積図が出来上がりました。

---

## ツリーマップ {#visual4-tree}

　ツリーマップ（tree map）は変数の値の大きさを長方形の面積として表すグラフです。全体におけるシェアを示す時に使う点で、円グラフの代替案の一つになります。円グラフは項目が多すぎると読みにくいデメリットがありますが、ツリーマップは項目が多い場合でも有効です。むろん、多すぎると読みにくいことは同じですので、注意が必要です。

　ツリーマップを作成するためには{treemapify}パッケージの`geom_treemap()`幾何オブジェクトを使用します。まず、{treemapify}をインストールし、読み込みます。


```{.r .numberLines}
pacman::p_load(treemapify)
```

　ここでは`Country_df`からアジア諸国の人口（`Population`）をツリーマップをして可視化したいと思います。`geom_treemap()`の場合、各長方形は面積の情報のみを持ちます。この面積の情報を`area`にマッピングします。


```{.r .numberLines}
Country_df %>%
  filter(Continent == "Asia") %>%
  ggplot() +
  geom_treemap(aes(area = Population))
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-tree2-1} \end{center}

　これだけだと各長方形がどの国を指しているのかが分かりませんね。長方形の上に国名（`Country`）を追加するためには`geom_treemap_text()`幾何オブジェクトを使用します。マッピングは`area`と`label`に対し、それぞれ面積を表す`Population`と国名を表す`Country`を指定します。`area`は`geom_treemap()`と`geom_treemap_text()`両方で使われるので`ggplot()`の内部でマッピングしても問題ありません[^tree_mapping]。また、`aes()`の外側に`color = "white"`で文字を白に指定し、`place = "center"`で長方形の真ん中にラベルが付くようにします。

[^tree_mapping]: 今回の例だと、`label`も`ggplot()`内部でマッピング可能です。


```{.r .numberLines}
Country_df %>%
  filter(Continent == "Asia") %>%
  ggplot(aes(area = Population)) +
  geom_treemap() +
  geom_treemap_text(aes(label = Country), color = "white", place = "center")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-tree3-1} \end{center}

　これでツリーマップが完成しました。インドと中国の存在感がかなり大きいですね。更にラベルのサイズを長方形に合わせると、その存在感をより高めることができます。ラベルの大きさを長方形に合わせるには`geom_treepmap_text()`の内部に`grow = TRUE`を指定します。


```{.r .numberLines}
Country_df %>%
  filter(Continent == "Asia") %>%
  ggplot(aes(area = Population, label = Country)) +
  geom_treemap() +
  geom_treemap_text(color = "white", place = "center",
                    grow = TRUE)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-tree4-1} \end{center}

　ここで更に次元を追加するために、色塗りをしてみましょう。たとえば、G20加盟国か否かで色分けをしたい場合、`fill`に`G20`をマッピングします。ただし、今のままだと`G20`は連続変数扱いになりますので、character型、またはfactor型に変換します。


```{.r .numberLines}
Country_df %>%
  mutate(G20 = if_else(G20 == 1, "Member", "Non-member")) %>%
  filter(Continent == "Asia") %>%
  ggplot(aes(area = Population, fill = G20,
             label = Country)) +
  geom_treemap() +
  geom_treemap_text(color = "white", place = "centre",
                    grow = TRUE) +
  labs(fill = "G20") +
  ggtitle("Population in Asia") +
  theme(legend.position = "bottom")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-tree5-1} \end{center}

　色塗りは連続変数に対して行うことも可能です。ここでは2018年人間開発指数（`HDI_2108`）の値に応じて色塗りをしてみます。また、`HDI_2018`が低い（`low`）と<span style = "color:#CD3333;">**brown3**</span>、高い（`high`）と<span style = "color:#6495ED;">**cornflowerblue**</span>色にします。真ん中の値（`midpoint`）は0.7とし、色（`mid`）は<span style = "color:#FFF8DC;background-color:#7F7F7F;">**cornsilk**</span>を使います。

　連続変数でマッピングされた色塗り（`fill`）の調整には`scale_fill_gradient()`、または`scale_fill_gradient2()`を使います。前者は中間点なし、後者は中間点ありです。これらの使い方は第\@ref(visualization3)章で紹介しました`scale_color_gradient()`と同じです。


```{.r .numberLines}
Country_df %>%
  filter(Continent == "Asia") %>%
  ggplot(aes(area = Population, fill = HDI_2018,
             label = Country)) +
  geom_treemap() +
  geom_treemap_text(color = "white", place = "centre",
                    grow = TRUE) +
  scale_fill_gradient2(low = "brown3",
                       mid = "cornsilk",
                       high = "cornflowerblue",
                       midpoint = 0.7) +
  labs(fill = "UN Human Development Index (2018)") +
  ggtitle("Population in Asia") +
  theme(legend.position = "bottom")
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-tree6-1} \end{center}

　ちなみに以上の図を円グラフにすると以下のようになります（国名は人口の割合が2.5%を超える国のみ表示）。ツリーマップと比較してかなり読みにくいことが分かります。


```{.r .numberLines}
Country_df %>%
  filter(Continent == "Asia") %>%
  arrange(Population) %>%
  mutate(Prop        = Population / sum(Population) * 100,
         LabelY      = 100 - (cumsum(Prop) - 0.5 * Prop),
         CountryName = if_else(Prop < 2.5, "", Country),
         Country     = fct_inorder(Country)) %>%
  ggplot() +
  geom_bar(aes(x = 1, y = Prop, group = Country, fill = HDI_2018), 
           color = "black", stat = "identity", width = 1) +
  geom_text(aes(x = 1, y = LabelY, label = CountryName)) +
  coord_polar("y", start = 0) +
  scale_fill_gradient2(low = "brown3",
                       mid = "cornsilk",
                       high = "cornflowerblue",
                       midpoint = 0.7) +
  labs(fill = "UN Human Development Index (2018)") +
  ggtitle("Population in Asia") +
  theme_minimal() +
  theme(legend.position = "bottom",
        panel.grid = element_blank(),
        axis.title = element_blank(),
        axis.text  = element_blank())
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-tree7-1} \end{center}

　ただし、ツリーマップが必ずしも円グラフより優れているとは言えません。たとえば、 @Heer_Bostock:2010 の研究では円グラフとツリーマップを含む9種類のグラフを用い、被験者に大小関係を判断してもらう実験を行いましたが、ツリーマップ（四角形の面積）は円グラフ（角度）よりも判断までの所要時間が長いことが述べています。

---

## モザイクプロット {#visual4-mosaic}

モザイクプロットは2つの離散変数（おもに名目変数）の関係を可視化するために @Hargian_Kleiner:1984 が考案した図です。2つの名目変数間の関係を見る際によく使われるものはクロス表（クロス集計表）でしょう。


```{.r .numberLines}
pacman::p_load(ggmosaic)
```


```{.r .numberLines}
Mosaic_df <- Country_df %>%
    select(Country, Continent, Polity = Polity_Type, PPP = PPP_per_capita) %>%
    mutate(Continent = factor(Continent, 
                              levels = c("Africa", "America", "Asia",
                                         "Europe", "Oceania")),
           Polity    = factor(Polity,
                              levels = c("Autocracy", "Closed Anocracy",
                                         "Open Anocracy", "Democracy",
                                         "Full Democracy")),
           PPP       = if_else(PPP >= 15000, "High PPP", "Low PPP"),
           PPP       = factor(PPP, levels = c("Low PPP", "High PPP"))) %>%
    drop_na()
```


```{.r .numberLines}
head(Mosaic_df)
```

```
## # A tibble: 6 x 4
##   Country     Continent Polity          PPP     
##   <chr>       <fct>     <fct>           <fct>   
## 1 Afghanistan Asia      Closed Anocracy Low PPP 
## 2 Albania     Europe    Democracy       Low PPP 
## 3 Algeria     Africa    Open Anocracy   Low PPP 
## 4 Angola      Africa    Closed Anocracy Low PPP 
## 5 Argentina   America   Democracy       High PPP
## 6 Armenia     Europe    Democracy       Low PPP
```

　クロス表を作成する内蔵関数としては`table()`があります。2つの変数が必要となり、第一引数が行、第二引数が列を表します。


```{.r .numberLines}
Mosaic_Tab <- table(Mosaic_df$Continent, Mosaic_df$Polity)
Mosaic_Tab
```

```
##          
##           Autocracy Closed Anocracy Open Anocracy Democracy Full Democracy
##   Africa          3              14            11        18              1
##   America         0               1             4        16              5
##   Asia           13               6             0        15              3
##   Europe          2               1             2        16             20
##   Oceania         0               0             2         0              2
```

　この`Mosaic_Tab`のクラスは`"table"`ですが、`"table"`クラスのオブジェクトを`plot()`に渡すと別途のパッケージを使わずモザイクプロットを作成することができます。




```{.r .numberLines}
plot(Mosaic_Tab)
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-mosaic6-1} \end{center}

　やや地味ではありますが、モザイクプロットが出来ました。ここからはより読みやすいモザイクプロットを作成するために{ggmosaic}パッケージの`geom_mosaic()`関数を使います。

　`geom_mosaic()`の場合、`x`のみのマッピングで十分です。ただし、特定の変数を指定するのではなく、`product(変数1, 変数2)`を`x`にマッピングする必要があります。`table()`関数同様、変数1は行、変数2は列です。また、欠損値が含まれている行がある場合は、`aes()`の外側に`na.rm = TRUE`を指定する必要があります。今回は`drop_na()`で欠損値をすべて除外しましたが、念の為に指定しておきます。


```{.r .numberLines}
Mosaic_df %>%
    ggplot() +
    geom_mosaic(aes(x = product(Polity, Continent)), na.rm = TRUE) +
    labs(x = "Continent", y = "Polity Type") +
    theme_minimal() +
    theme(panel.grid = element_blank())
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-mosaic7-1} \end{center}

　これで出来上がりですが、`"table"`オブジェクトを`plot()`に渡した結果とあまり変わらないですね。続いて、この図を少し改良してみましょう。まずはセルの色分けですが、これは`fill`に色分けする変数をマッピングするだけです。今回は政治体制ごとにセルを色分けしましょう。また、文字を大きめにし、横軸の目盛りラベルを回転します。


```{.r .numberLines}
Mosaic_df %>%
    ggplot() +
    geom_mosaic(aes(x = product(Polity, Continent), fill = Polity), 
                na.rm = TRUE) +
    labs(x = "Continent", y = "Polity Type") +
    theme_minimal(base_size   = 16) +
    theme(legend.position = "none",
          panel.grid      = element_blank(),
          axis.text.x     = element_text(angle = 90, vjust = 0.5, hjust = 1))
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-mosaic8-1} \end{center}

　次元を追加するためにはファセット分割を使います。たとえば、一人当たりPPP GDPの高低（`PPP`）でファセットを分割する場合、`facet_wrap(~PPP)`レイヤーを足すだけです。


```{.r .numberLines}
Mosaic_df %>%
    ggplot() +
    geom_mosaic(aes(x = product(Polity, Continent), fill = Polity), 
                na.rm = TRUE) +
    labs(x = "Continent", y = "Polity Type") +
    facet_wrap(~PPP, ncol = 2) +
    theme_minimal(base_size   = 16) +
    theme(legend.position = "none",
          panel.grid      = element_blank(),
          axis.text.x     = element_text(angle = 90, vjust = 0.5, hjust = 1))
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-mosaic9-1} \end{center}

　ただし、一つ問題があります。それは目盛りラベルの位置です。例えば、右側の横軸目盛りラベルの場合、セルの位置とラベルの位置がずれています。これは2つのファセットが同じ目盛りを共有し、左側の方に合わせられたため生じるものです。よく見ると横軸も縦軸も目盛りラベルに位置が同じであることが分かります。これを解消するためには、`facet_wrap()`の内部に`scale = "free"`を指定します[^facet_scale]。これは各ファセットが独自のスケールを有することを意味します。

[^facet_scale]: 他にも**縦**軸のみ共有する`"free_x"`、横軸のみ共有する`"free_y"`があり、既定値は`"fixed"`です。


```{.r .numberLines}
Mosaic_df %>%
    ggplot() +
    geom_mosaic(aes(x = product(Polity, Continent), fill = Polity), 
                na.rm = TRUE) +
    labs(x = "Continent", y = "Polity Type") +
    facet_wrap(~PPP, ncol = 2, scale = "free") +
    theme_minimal(base_size   = 16) +
    theme(legend.position = "none",
          panel.grid      = element_blank(),
          axis.text.x     = element_text(angle = 90, vjust = 0.5, hjust = 1))
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-mosaic10-1} \end{center}

　右側ファセットの横軸ラベルが重なってしまいましたが、これでとりあえず完成です。アフリカにおけるOpen AnocracyとClosed Anocracyの頻度が0であるため、これは仕方ありません。一つの対処方法としては以下のように縦軸目盛りを削除し、凡例で代替することが考えられます。


```{.r .numberLines}
Mosaic_df %>%
    ggplot() +
    geom_mosaic(aes(x = product(Polity, Continent), fill = Polity), 
                na.rm = TRUE) +
    labs(x = "Continent", y = "Polity Type", fill = "Polity Type") +
    facet_wrap(~PPP, ncol = 2, scale = "free_x") +
    theme_minimal(base_size   = 16) +
    theme(panel.grid  = element_blank(),
          axis.text.y = element_blank(),
          axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
```



\begin{center}\includegraphics{visualization4_files/figure-latex/visual4-mosaic11-1} \end{center}

---

## その他のグラフ {#visual4-further}

[The R Graph Gallery](https://www.r-graph-gallery.com/)では本書で紹介できなかった様々な図のサンプルおよびコードを見ることができます。ここまで読み終わった方なら問題なくコードの意味が理解できるでしょう。{ggplot2}では作成できないグラフ（アニメーションや3次元図、インタラクティブなグラフ）についても、他のパッケージを利用した作成方法について紹介されているので、「こんな図が作りたいけど、作り方が分からん！」の時には、まず[The R Graph Gallery](https://www.r-graph-gallery.com/)に目を通してみましょう。
