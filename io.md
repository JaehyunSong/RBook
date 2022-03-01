# データの入出力 {#io}



この章で使うパッケージを読み込む。


```{.r .numberLines}
pacman::p_load(tidyverse, readxl, haven)
```

## データの読み込み {#io-read}

### csvファイルの場合

　csv は、comma separated values の略である。多くの人に馴染みがあると思われる Excelファイル (.xlsx) と同じように、表形式（行列形式）のデータを保存できる。しかし、Excelファイルとは異なり、文字の大きさ、セルの背景色、複数のセルの結合のような情報はもたず、純粋にデータに含まれる変数の名前と各変数の値（数値・文字列）のみが格納されているため、ファイルサイズが小さい。また、文字データしかもたないテキストファイルであり、テキストエディタで開くことができる。テキストファイルで csv ファイルを開けば、"csv" と呼ばれる理由がわかるだろう。csvフォーマットはデータを保存のための標準フォーマットの1つであり、多くのデータがcsv形式で保存されている。データ分析ソフトでcsv ファイルを開けないものはおそらくないだろう。

　Rでもcsv形式のファイルは簡単に読み込める。実際にやっててみよう。データのダウンロード方法については本書の巻頭を参照されたい。csvファイルを読み込むには`read.csv()`または`readr::read_csv()`関数を使う[^io-readcsv1]。読み込む際は前章のベクトルの生成同様、何らかの名前を付けて作業環境に保存する。`Data`フォルダーにある `FIFA_Women.csv` ファイルを読み込み、`my_df1`と名付ける場合、以下のようなコードを実行する[^io-readcsv2]。以下のコードで`my_df1 <-`　の部分を入力しないと、データが画面に出力され、自分の作業スペースには保存されないので注意されたい。

[^io-readcsv1]: `read.csv()`で読み込まれた表は `data.frame` クラスに、`read_csv()`関数で読み込まれた表は `tibble` クラスとして保存される。詳細は第\@ref(datastructure)章で解説する。

[^io-readcsv2]: Rのバージョンが4.0.0 未満の場合は、引数として`stringsAsFactors = FALSE` を追加する。たとえば、`my_df1 <- read.csv("Data/FIFA_Women.csv", stringsAsFactors = FALSE)` とする。これを追加しないと、文字列で構成されている列が `factor` 型として読み込まれる。


```{.r .numberLines}
my_df1 <- read.csv("Data/FIFA_Women.csv")
```

　読み込まれたデータの中身を見るには、ベクトルの場合と同様に`print()`関数を使うか、オブジェクト名を入力する。


```{.r .numberLines}
my_df1
```

```
##      ID                   Team Rank Points Prev_Points Confederation
## 1     1                Albania   75   1325        1316          UEFA
## 2     2                Algeria   85   1271        1271           CAF
## 3     3         American Samoa  133   1030        1030           OFC
## 4     4                Andorra  155    749         749          UEFA
## 5     5                 Angola  121   1117        1117           CAF
## 6     6    Antigua and Barbuda  153    787         787      CONCACAF
## 7     7              Argentina   32   1659        1659      CONMEBOL
## 8     8                Armenia  126   1103        1104          UEFA
## 9     9                  Aruba  157    724         724      CONCACAF
## 10   10              Australia    7   1963        1963           AFC
## 11   11                Austria   22   1792        1797          UEFA
## 12   12             Azerbaijan   76   1321        1326          UEFA
## 13   13                Bahrain   84   1274        1274           AFC
## 14   14             Bangladesh  134   1008        1008           AFC
## 15   15               Barbados  135   1002        1002      CONCACAF
## 16   16                Belarus   53   1434        1437          UEFA
## 17   17                Belgium   17   1819        1824          UEFA
## 18   18                 Belize  150    824         824      CONCACAF
## 19   19                Bermuda  136    987         987      CONCACAF
## 20   20                 Bhutan  154    769         769           AFC
## 21   21                Bolivia   91   1236        1236      CONMEBOL
## 22   22 Bosnia and Herzegovina   59   1411        1397          UEFA
## 23   23               Botswana  148    848         848           CAF
## 24   24                 Brazil    8   1958        1956      CONMEBOL
## 25   25               Bulgaria   79   1303        1303          UEFA
## 26   26               Cameroon   51   1455        1486           CAF
## 27   27                 Canada    8   1958        1958      CONCACAF
## 28   28                  Chile   37   1640        1637      CONMEBOL
## 29   29               China PR   15   1867        1842           AFC
## 30   30         Chinese Taipei   40   1589        1584           AFC
## 31   31               Colombia   25   1700        1700      CONMEBOL
## 32   32                Comoros  156    731         731           CAF
## 33   33                  Congo  104   1178        1178           CAF
## 34   34               Congo DR  110   1159        1159           CAF
## 35   35           Cook Islands  103   1194        1194           OFC
## 36   36             Costa Rica   36   1644        1630      CONCACAF
## 37   37          Côte d'Ivoire   63   1392        1392           CAF
## 38   38                Croatia   52   1453        1439          UEFA
## 39   39                   Cuba   88   1240        1240      CONCACAF
## 40   40                 Cyprus  123   1114        1123          UEFA
## 41   41         Czech Republic   29   1678        1678          UEFA
## 42   42                Denmark   16   1851        1839          UEFA
## 43   43     Dominican Republic  105   1173        1173      CONCACAF
## 44   44            El Salvador  109   1164        1164      CONCACAF
## 45   45                England    6   1999        2001          UEFA
## 46   46      Equatorial Guinea   71   1356        1356           CAF
## 47   47                Estonia   95   1210        1206          UEFA
## 48   48               Eswatini  151    822         822           CAF
## 49   49               Ethiopia  111   1151        1151           CAF
## 50   50          Faroe Islands   86   1259        1262          UEFA
## 51   51                   Fiji   66   1373        1373           OFC
## 52   52                Finland   30   1671        1678          UEFA
## 53   53                 France    3   2036        2033          UEFA
## 54   54                  Gabon  130   1066        1066           CAF
## 55   55                 Gambia  113   1143        1183           CAF
## 56   56                Georgia  115   1138        1145          UEFA
## 57   57                Germany    2   2090        2078          UEFA
## 58   58                  Ghana   60   1401        1404           CAF
## 59   59                 Greece   62   1396        1395          UEFA
## 60   60                   Guam   82   1282        1282           AFC
## 61   61              Guatemala   80   1290        1290      CONCACAF
## 62   62                  Haiti   64   1391        1368      CONCACAF
## 63   63               Honduras  116   1136        1136      CONCACAF
## 64   64              Hong Kong   74   1329        1335           AFC
## 65   65                Hungary   43   1537        1526          UEFA
## 66   66                Iceland   19   1817        1821          UEFA
## 67   67                  India   55   1432        1432           AFC
## 68   68              Indonesia   94   1222        1222           AFC
## 69   69                IR Iran   70   1358        1358           AFC
## 70   70                 Israel   67   1369        1371          UEFA
## 71   71                  Italy   14   1889        1882          UEFA
## 72   72                Jamaica   50   1460        1461      CONCACAF
## 73   73                  Japan   11   1937        1942           AFC
## 74   74                 Jordan   58   1419        1419           AFC
## 75   75             Kazakhstan   77   1318        1318          UEFA
## 76   76                  Kenya  137    986         986           CAF
## 77   77              Korea DPR   10   1940        1940           AFC
## 78   78         Korea Republic   18   1818        1812           AFC
## 79   79                 Kosovo  125   1104        1109          UEFA
## 80   80        Kyrgyz Republic  120   1118        1118           AFC
## 81   81                 Latvia   93   1223        1223          UEFA
## 82   82                Lebanon  141    967         967           AFC
## 83   83                Lesotho  147    850         850           CAF
## 84   84              Lithuania  107   1169        1168          UEFA
## 85   85             Luxembourg  119   1124        1124          UEFA
## 86   86             Madagascar  158    691         691           CAF
## 87   87                 Malawi  145    887         887           CAF
## 88   88               Malaysia   90   1238        1238           AFC
## 89   89               Maldives  142    966         966           AFC
## 90   90                   Mali   83   1276        1276           CAF
## 91   91                  Malta  101   1197        1195          UEFA
## 92   92              Mauritius  159    357         357           CAF
## 93   93                 Mexico   27   1686        1699      CONCACAF
## 94   94                Moldova   92   1228        1229          UEFA
## 95   95               Mongolia  123   1114        1114           AFC
## 96   96             Montenegro   97   1201        1206          UEFA
## 97   97                Morocco   81   1289        1280           CAF
## 98   98             Mozambique  152    814         814           CAF
## 99   99                Myanmar   45   1511        1527           AFC
## 100 100                Namibia  143    956         956           CAF
## 101 101                  Nepal   99   1200        1200           AFC
## 102 102            Netherlands    4   2032        2035          UEFA
## 103 103          New Caledonia   96   1208        1208           OFC
## 104 104            New Zealand   23   1757        1760           OFC
## 105 105              Nicaragua  122   1116        1116      CONCACAF
## 106 106                Nigeria   38   1614        1614           CAF
## 107 107        North Macedonia  129   1072        1073          UEFA
## 108 108       Northern Ireland   55   1432        1433          UEFA
## 109 109                 Norway   12   1930        1929          UEFA
## 110 110              Palestine  117   1131        1131           AFC
## 111 111                 Panama   60   1401        1437      CONCACAF
## 112 112       Papua New Guinea   46   1504        1504           OFC
## 113 113               Paraguay   48   1490        1490      CONMEBOL
## 114 114                   Peru   65   1376        1376      CONMEBOL
## 115 115            Philippines   67   1369        1369           AFC
## 116 116                 Poland   28   1683        1677          UEFA
## 117 117               Portugal   32   1659        1667          UEFA
## 118 118            Puerto Rico  106   1172        1172      CONCACAF
## 119 119    Republic of Ireland   31   1666        1665          UEFA
## 120 120                Romania   44   1535        1542          UEFA
## 121 121                 Russia   24   1708        1708          UEFA
## 122 122                 Rwanda  144    899         899           CAF
## 123 123                  Samoa  107   1169        1169           OFC
## 124 124               Scotland   21   1804        1794          UEFA
## 125 125                Senegal   87   1247        1245           CAF
## 126 126                 Serbia   41   1558        1553          UEFA
## 127 127              Singapore  128   1089        1089           AFC
## 128 128               Slovakia   47   1501        1500          UEFA
## 129 129               Slovenia   49   1471        1467          UEFA
## 130 130        Solomon Islands  114   1140        1140           OFC
## 131 131           South Africa   53   1434        1434           CAF
## 132 132                  Spain   13   1915        1900          UEFA
## 133 133              Sri Lanka  140    968         968           AFC
## 134 134    St. Kitts and Nevis  131   1050        1054      CONCACAF
## 135 135              St. Lucia  138    982         982      CONCACAF
## 136 136               Suriname  127   1093        1093      CONCACAF
## 137 137                 Sweden    5   2007        2022          UEFA
## 138 138            Switzerland   20   1815        1817          UEFA
## 139 139                 Tahiti  102   1196        1196           OFC
## 140 140             Tajikistan  132   1035        1035           AFC
## 141 141               Tanzania  139    978         978           CAF
## 142 142               Thailand   39   1596        1620           AFC
## 143 143                  Tonga   88   1240        1240           OFC
## 144 144    Trinidad and Tobago   72   1354        1354      CONCACAF
## 145 145                Tunisia   78   1304        1313           CAF
## 146 146                 Turkey   69   1365        1361          UEFA
## 147 147                 Uganda  146    868         868           CAF
## 148 148                Ukraine   26   1692        1697          UEFA
## 149 149   United Arab Emirates   97   1201        1201           AFC
## 150 150                Uruguay   73   1346        1346      CONMEBOL
## 151 151      US Virgin Islands  149    843         843      CONCACAF
## 152 152                    USA    1   2181        2174      CONCACAF
## 153 153             Uzbekistan   42   1543        1543           AFC
## 154 154                Vanuatu  117   1131        1131           OFC
## 155 155              Venezuela   57   1425        1425      CONMEBOL
## 156 156                Vietnam   35   1657        1665           AFC
## 157 157                  Wales   34   1658        1659          UEFA
## 158 158                 Zambia  100   1198        1167           CAF
## 159 159               Zimbabwe  111   1151        1151           CAF
```

　しかし、通常はデータが読み込まれているかどうかを確認するためにデータ全体を見る必要はない。最初の数行のみで問題ないはずだ。そのために、`head()` 関数を使う。これは最初の6行 (`n` で表示行数を変える) を表示してくれる。


```{.r .numberLines}
head(my_df1)
```

```
##   ID                Team Rank Points Prev_Points Confederation
## 1  1             Albania   75   1325        1316          UEFA
## 2  2             Algeria   85   1271        1271           CAF
## 3  3      American Samoa  133   1030        1030           OFC
## 4  4             Andorra  155    749         749          UEFA
## 5  5              Angola  121   1117        1117           CAF
## 6  6 Antigua and Barbuda  153    787         787      CONCACAF
```

　同様に、最後の `n`行は`tail()` で表示する。


```{.r .numberLines}
tail(my_df1, n = 9)
```

```
##      ID              Team Rank Points Prev_Points Confederation
## 151 151 US Virgin Islands  149    843         843      CONCACAF
## 152 152               USA    1   2181        2174      CONCACAF
## 153 153        Uzbekistan   42   1543        1543           AFC
## 154 154           Vanuatu  117   1131        1131           OFC
## 155 155         Venezuela   57   1425        1425      CONMEBOL
## 156 156           Vietnam   35   1657        1665           AFC
## 157 157             Wales   34   1658        1659          UEFA
## 158 158            Zambia  100   1198        1167           CAF
## 159 159          Zimbabwe  111   1151        1151           CAF
```

　ただし、今後、特殊な事情がない限り、データの読み込みは`read.csv()`を使用せず、`read_csv()`を使用しますが、使い方は同じです。`read_csv()`は{tidyverse}の一部である{readr}パッケージに含まれている関数であるため、あらかじめ{tidyverse}を読み込んでおく必要があります。


```{.r .numberLines}
pacman::p_load(tidyverse)
my_df1 <- read_csv("Data/FIFA_Women.csv")

my_df1
```

```
## # A tibble: 159 x 6
##       ID Team                 Rank Points Prev_Points Confederation
##    <dbl> <chr>               <dbl>  <dbl>       <dbl> <chr>        
##  1     1 Albania                75   1325        1316 UEFA         
##  2     2 Algeria                85   1271        1271 CAF          
##  3     3 American Samoa        133   1030        1030 OFC          
##  4     4 Andorra               155    749         749 UEFA         
##  5     5 Angola                121   1117        1117 CAF          
##  6     6 Antigua and Barbuda   153    787         787 CONCACAF     
##  7     7 Argentina              32   1659        1659 CONMEBOL     
##  8     8 Armenia               126   1103        1104 UEFA         
##  9     9 Aruba                 157    724         724 CONCACAF     
## 10    10 Australia               7   1963        1963 AFC          
## # ... with 149 more rows
```

　同じファイルが読み込まれましたが、データを出力する際、最初の10行のみが表示されます。また、画面に収まらない横長のデータであれば、適宜省略し、見やすく出力してくれます。`read_csv()`で読み込まれた表形式データはtibbleと呼ばれるやや特殊なものとして格納されます。Rがデフォルトで提供する表形式データの構造はdata.frameですが、tibbleはその拡張版です。詳細は第\@ref(structure-dataframe)章を参照してください。

### エンコーディングの話

　`Vote_ShiftJIS.csv` はShift-JIS でエンコーディングされた csvファイルである。このファイルを `read.csv()` 関数で読み込んでみよう。


```{.r .numberLines}
ShiftJIS_df <- read.csv("Data/Vote_ShiftJIS.csv")
```

```
## Error in type.convert.default(data[[i]], as.is = as.is[i], dec = dec, : invalid multibyte string at '<96>k<8a>C<93><b9>'
```

　Windowsならなんの問題なく読み込まれるだろう。しかし、macOSの場合、以下のようなエラーが表示され、読み込めない。

```
## Error in type.convert.default(data[[i]], as.is = as.is[i], dec = dec, :  '<96>k<8a>C<93><b9>' に不正なマルチバイト文字があります
```

　このファイルは、`read.csv()`の代わりに **readr**パッケージの`read_csv()`を使えば読み込むことができる[^io-readr]。`read_csv()`で読み込み、中身を確認してみよう。


```{.r .numberLines}
ShiftJIS_df1 <- read_csv("Data/Vote_ShiftJIS.csv")
head(ShiftJIS_df1)
```

```
## # A tibble: 6 x 11
##      ID Pref           Zaisei Over65 Under30   LDP   DPJ Komei Ishin   JCP   SDP
##   <dbl> <chr>           <dbl>  <dbl>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
## 1     1 "\x96k\x8aC\x~  0.419   29.1    24.7  32.8  30.6 13.4   3.43 11.4   1.68
## 2     2 "\x90\xc2\x90~  0.332   30.1    23.9  40.4  24.6 12.8   3.82  8.92  3.41
## 3     3 "\x8a\xe2\x8e~  0.341   30.4    24.5  34.9  22.4  8.61  5.16 11.2   5.29
## 4     4 "\x8b{\x8f\xe~  0.596   25.8    27.3  36.7  25.4 13.4   3.97  9.99  3.62
## 5     5 "\x8fH\x93c\x~  0.299   33.8    21.4  43.5  22.7 11.2   5.17  7.56  5.12
## 6     6 "\x8eR\x8c`\x~  0.342   30.8    24.8  42.5  21.5 11.8   4.3   7.6   5.2
```

　2列目の`Pref`列には日本語で都道府県名が入っているはずだが、謎の文字列が表示される。`read.csv()`の場合、少なくともWindowsでは問題なく読み込めたはずだ。なぜなら`read.csv()`はWindowsの場合、Shift-JISで、macOSの場合UTF-8でファイルを読み込む。一方、`read_csv()`はOSと関係なく世界標準であるUTF-8でファイルを読み込むからだ。

[^io-readr]: readr パッケージは tidyverse の一部なので、上で読み込み済みである。


　正しい都道府県名を表示する方法はいくつかあるが、ここでは3つの方法を紹介する。

**1. `read.csv()`関数の`fileEncoing`引数の指定**

　一つ目の方法は、`read.csv()`関数の `fileEncoding ` 引数を追加するというものだる。この引数に、指定したファイルのエンコーディングを指定すればよいが、Shift-JISの場合、`"Shift_JIS"`　を指定する。ハイフン (`-`)ではなく、アンダーバー (`_`) であることに注意されたい。この`"Shift_JIS"`は`"cp932"` に書き換えても良い。それではやってみよう。


```{.r .numberLines}
ShiftJIS_df2 <- read.csv("Data/Vote_ShiftJIS.csv", 
                         fileEncoding = "Shift_JIS")
head(ShiftJIS_df2)
```

```
##   ID   Pref  Zaisei Over65 Under30   LDP   DPJ Komei Ishin   JCP  SDP
## 1  1 北海道 0.41903  29.09   24.70 32.82 30.62 13.41  3.43 11.44 1.68
## 2  2 青森県 0.33190  30.14   23.92 40.44 24.61 12.76  3.82  8.92 3.41
## 3  3 岩手県 0.34116  30.38   24.48 34.90 22.44  8.61  5.16 11.24 5.29
## 4  4 宮城県 0.59597  25.75   27.29 36.68 25.40 13.42  3.97  9.99 3.62
## 5  5 秋田県 0.29862  33.84   21.35 43.46 22.72 11.19  5.17  7.56 5.12
## 6  6 山形県 0.34237  30.76   24.75 42.49 21.47 11.78  4.30  7.60 5.20
```

　`Pref`列の日本語が正常に表示された。むろん、Windowsなら`fileEncoding`引数がなくても読み込める。むしろ、UTF-8で書かれたファイルが読み込めない可能性がある。この場合は`fileEncoding = "UTF-8"`を指定すれば良い。

**2. `read_csv()`関数の`locale`引数の指定**

　二つ目の方法は `read_csv()` 関数の`locale` 引数を指定する方法である。`read_csv()`には　`fileEncoding `　引数がないが、代わりに `locale` があるので、`locale = locale(encoding = "Shift_JIS")`を追加すれば良い。


```{.r .numberLines}
ShiftJIS_df3 <- read_csv("Data/Vote_ShiftJIS.csv", 
                         locale = locale(encoding = "Shift_JIS"))
head(ShiftJIS_df3)
```

```
## # A tibble: 6 x 11
##      ID Pref   Zaisei Over65 Under30   LDP   DPJ Komei Ishin   JCP   SDP
##   <dbl> <chr>   <dbl>  <dbl>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
## 1     1 北海道  0.419   29.1    24.7  32.8  30.6 13.4   3.43 11.4   1.68
## 2     2 青森県  0.332   30.1    23.9  40.4  24.6 12.8   3.82  8.92  3.41
## 3     3 岩手県  0.341   30.4    24.5  34.9  22.4  8.61  5.16 11.2   5.29
## 4     4 宮城県  0.596   25.8    27.3  36.7  25.4 13.4   3.97  9.99  3.62
## 5     5 秋田県  0.299   33.8    21.4  43.5  22.7 11.2   5.17  7.56  5.12
## 6     6 山形県  0.342   30.8    24.8  42.5  21.5 11.8   4.3   7.6   5.2
```

**3. LibreOfficeなどを利用した方法**

　第三の方法は、そもそも Shift-JISでではなく、より一般的な UTF-8 でエンコーディングされたファイルを用意し、それを読み込むことである。ただし、この作業のためにはR以外のソフトが必要である。テキストエディタには文字コードを変更する機能がついているものが多いので、その機能を利用して文字コードを Shift-JISからUTF-8に変えれば良い。また、オープンソースのオフィススイートである [LibreOffice](https://ja.libreoffice.org/) は、CSVを開く際に文字コードを尋ねてくれるので、Shift-JIS を指定して上で使った csv ファイルを開こう。その後、文字コードをUTF-8に変更し、別名でcsvファイルを保存すれ、文字コード以外の中身が同じファイルができる。そのようにして作ったのが、`Vote.csv` である。これを読み込んでみよう。




```{.r .numberLines}
UTF8_df <- read.csv("Data/Vote.csv") # macOSの場合
UTF8_df <- read.csv("Data/Vote.csv", fileEncoding = "UTF-8") # Windowsの場合
```


```{.r .numberLines}
head(UTF8_df)
```

```
##   ID   Pref  Zaisei Over65 Under30   LDP   DPJ Komei Ishin   JCP  SDP
## 1  1 北海道 0.41903  29.09   24.70 32.82 30.62 13.41  3.43 11.44 1.68
## 2  2 青森県 0.33190  30.14   23.92 40.44 24.61 12.76  3.82  8.92 3.41
## 3  3 岩手県 0.34116  30.38   24.48 34.90 22.44  8.61  5.16 11.24 5.29
## 4  4 宮城県 0.59597  25.75   27.29 36.68 25.40 13.42  3.97  9.99 3.62
## 5  5 秋田県 0.29862  33.84   21.35 43.46 22.72 11.19  5.17  7.56 5.12
## 6  6 山形県 0.34237  30.76   24.75 42.49 21.47 11.78  4.30  7.60 5.20
```

　第1引数以外の引数を何を指定しなくても、ファイルが正しく読み込まれ、都道府県名が日本語で表示されている。ただし、Windowsで文字化けが生じる場合はファイルのエンコーディングをUTF-8に指定して読み込もう。


### その他のフォーマット

　データ分析で用いられるデータの多くは表の形で保存されている。表形式のデータは、`.csv`以外に、`.xlsx` (Excel)、`.dta` (Stata)、`.sav` (SPSS)、`.ods` (LibreOfficeなど)　などのファイル形式で保存されることがある。ここでは接する機会が多い Excel 形式のファイルと Stata 形式のファイルの読み込みについて説明しよう[^io-read1]。

　Excelファイルを読み込むためには**readxl**パッケージを使う。インストールされていない場合、コンソール上で`install.packages("readxl")`を入力し、インストールする（上で `pacman::p_load(readxl)` を実行したのでインストールされているはずだが）。以下では**readxl**パッケージがインストールされていると想定し、`Soccer.xlsx`ファイルを読み込み、`Excel_DF`と名付けてみよう。


```{.r .numberLines}
Excel_DF <- read_xlsx("Data/Soccer.xlsx", sheet = 1)
```

　Excelファイルには2つ以上のシートが含まれる場合が多いので、どのシートを読み込むかを`sheetIndex ` で指定する。実際、`Soccer.xlsx`ファイルをExcelまたはLibreOffice Calc で開いてみると、シートが3つある。そのうち、必要なデータは1つ目のシートにあるので、ここでは`1`を指定した。きちんと読み込たか確認してみよう。


```{.r .numberLines}
head(Excel_DF)
```

```
## # A tibble: 6 x 6
##      ID Team                 Rank Points Prev_Points Confederation
##   <dbl> <chr>               <dbl>  <dbl>       <dbl> <chr>        
## 1     1 Albania                75   1325        1316 UEFA         
## 2     2 Algeria                85   1271        1271 CAF          
## 3     3 American Samoa        133   1030        1030 OFC          
## 4     4 Andorra               155    749         749 UEFA         
## 5     5 Angola                121   1117        1117 CAF          
## 6     6 Antigua and Barbuda   153    787         787 CONCACAF
```

[^io-read1]: `.sav`ファイルは`haven`パッケージの`read_sav()`で、`.ods`は`readODS`パッケージの`read.ods()`関数で読み込める。

　Stataの`.dta`ファイルは**haven**パッケージの`read_dta()` 関数を使って読み込む。Stata形式で保存された `Soccer.dta` を読み込み、`Stata_DF`と名付けてみよう。


```{.r .numberLines}
Stata_DF <- read_dta("Data/Soccer.dta")
head(Stata_DF)
```

```
## # A tibble: 6 x 6
##      id team                 rank points prev_points confederation
##   <dbl> <chr>               <dbl>  <dbl>       <dbl> <chr>        
## 1     1 Albania                75   1325        1316 UEFA         
## 2     2 Algeria                85   1271        1271 CAF          
## 3     3 American Samoa        133   1030        1030 OFC          
## 4     4 Andorra               155    749         749 UEFA         
## 5     5 Angola                121   1117        1117 CAF          
## 6     6 Antigua and Barbuda   153    787         787 CONCACAF
```

Excel形式のデータと同じ内容のデータであること確認できる（ただし、変数名は少し異なる）。


　実際の社会科学の場合、入手するデータの多くは`.csv`、`.xlsx` (または`.xls`)、`.dta`であるため、以上のやり方で多くのデータの読み込みができる。


### RDataファイルの場合


　データ分析には表形式以外のデータも使われる。データ分析でよく使われるデータの形として、ベクトルや行列のほかに`list`型とがある。表形式だけでなく、Rで扱える様々なデータを含むファイル形式の1つが`.RData`フォーマットである。`.RData`にはRが扱える形式のデータを格納するだけでなく、表形式のデータを**複数**格納することができる。また、データだけでなく、分析結果も保存することができる。`.RData`形式のファイルはRでしか読み込めないため、データの保存方法としては推奨できないが、1つのファイルにさまざまなデータが格納できるという大きな長所があるため、分析の途中経過を保存するためにしばしば利用される。

　ここでは`Data`フォルダにある`Scores.RData`を読み込んでみよう。このファイルには学生5人の数学と英語の成績に関するデータがそれぞれ`MathScore`と`EnglishScore`という名で保存されている。このデータを読み込む前に、現在の実行環境にどのようなオブジェクトがあるかを `ls()` 関数を使って確認してみよう[^io-ls-rstudio]。

[^io-ls-rstudio]: ちなみにRStudioから確認することもできる。第\@ref(R-Customize)章のとおりにRStudioを設定した場合、右下ペインの「Environment」タブに現在の実行環境に存在するオブジェクトが表示されているはずだ。


```{.r .numberLines}
ls()
```

```
## [1] "Excel_DF"     "my_df1"       "ShiftJIS_df1" "ShiftJIS_df2" "ShiftJIS_df3"
## [6] "Stata_DF"     "UTF8_df"
```

　現在の実行環境に7個のオブジェクトがあることがわかる。

　では、`Scores.RData`を読み込んでみよう。`.RData` は、`load()` 関数で読み込む。ただし、これまでのファイルの読み込みとは異なり、保存先のオブジェクト名は指定しない。なぜなら、`.Rdata` の中に既にオブジェクトが保存されているからだ。


```{.r .numberLines}
load("Data/Scores.RData")
```

　ここでもう一度実行環境上にあるオブジェクトのリストを確認してみよう。


```{.r .numberLines}
ls()
```

```
## [1] "EnglishScore" "Excel_DF"     "MathScore"    "my_df1"       "ShiftJIS_df1"
## [6] "ShiftJIS_df2" "ShiftJIS_df3" "Stata_DF"     "UTF8_df"
```

　`MathScore`と`EnglishScore`という名前のオブジェクトが追加されていることが分かる。

　このように、`load()`による`.RData` の読み込みは、`.csv`ファイルや`.xlsx`ファイルの読み込みと異なる。以下の2点が重要な違いである。

1. `.RData` は、1つのファイルに複数のデータを含むことができる。
2. `.RData`の中にRのオブジェクトが保存されているので、ファイルの読み込みと同時に名前を付けて格納する必要がない。

　問題なく読み込まれているか確認するため、それぞれのオブジェクトの中身を見てみよう。


```{.r .numberLines}
MathScore # MathScoreの中身を出力
```

```
##   ID    Name Score
## 1  1 Caracal   100
## 2  2 Cheetah    37
## 3  3  Jaguar    55
## 4  4 Leopard    69
## 5  5  Serval    95
```

```{.r .numberLines}
EnglishScore # EnglishScoreの中身を出力
```

```
##   ID    Name Score
## 1  1 Caracal    90
## 2  2 Cheetah    21
## 3  3  Jaguar    80
## 4  4 Leopard    45
## 5  5  Serval    99
```


---

## データの書き出し {#io-export}

　データを手に入れた時点でそのデータ（生データ）が分析に適した状態であることは稀である。多くの場合、分析をするためには手に入れたデータを分析に適した形に整形する必要がある。この作業を「データクリーニング」と呼ぶが、データ分析の作業全体に占めるデータクリーニングの割合は5から7割ほどで、大部分の作業時をクリーニングに費やすことになる。（クリーニングの方法については、データハンドリングの章で説明する。）

　データクリーニングが終わったら、生データとクリーニングに使ったコード、クリーニング済みのデータをそれぞれ保存しておこう。クリーニングのコードさえあればいつでも生データからクリーニング済みのデータに変換することができるが、時間的にあまり効率的ではないので、クリーニング済みのデータも保存したほうが良い。そうすれば、いつでもそのデータを読み込んですぐに分析作業に取り組無ことができる[^io-cleaning]。

[^io-cleaning]: 言うまでもないが、データクリーニングのコードと生データも必ず残しておくべきである。

### csvファイル

　データを保存する際にまず考えるべきフォーマットは`.csv` である。データが表の形をしていない場合には次節で紹介する`.RData`フォーマットが必要になるが、多くの場合、データは表の形をしている。読み込みのところで説明したとおり、`.csv`ファイルは汎用的なテキストファイルであり、ほとんどの統計ソフトおよび表計算ソフトで読み込むことができるので、特にこだわりがなければ業界標準のフォーマットとも言える csv 形式でデータ保存しておくのが安全だ[^io-format]。

[^io-format]: Excel (`.xlsx`) も広く使われているが、Excelは有料の商用ソフトであり、もっていない人もいることを忘れてはいけない。矢内も自分のラップトップには Excel （MS Office）をインストールしていない。

　まずは、架空のデータを作ってみよう。Rにおける表形式のデータは `data.frame`型で表現する。（詳細については第\@ref(datastructure)章で説明する。）


```{.r .numberLines}
my_data <- data.frame(
    ID    = 1:5,
    Name  = c("Aさん", "Bさん", "Cさん", "Dさん", "Eさん"),
    Score = c(50, 75, 60, 93, 51)
)
```

　上のコードを実行すると、`my_data`というオブジェクトが生成され、中には以下のようなデータが保持される。


```{.r .numberLines}
my_data
```

```
##   ID  Name Score
## 1  1 Aさん    50
## 2  2 Bさん    75
## 3  3 Cさん    60
## 4  4 Dさん    93
## 5  5 Eさん    51
```

　このデータを`my_data.csv`という名前のcsvファイルで保存するには、`write.csv()`という関数を使う。必須の引数は2つで、1つ目の引数は保存するオブジェクト名、2つ目の引数 `file` は書き出すファイル名。もし、プロジェクトフォルダの下位フォルダ、たとえば、Dataフォルダーに保存するなら、ファイル名を`"Data/my_ata.csv"`のように指定する。他によく使う引数として`row.names`があり、デフォルトは`TRUE`だが、`FALSE`にすることを推奨する。`TRUE`のままだと、データの1列目に行番号が保存される。


```{.r .numberLines}
write.csv(my_data, file = "Data/my_data.csv", row.names = FALSE)
```

　これを実行すると、プロジェクトのフォルダの中にある `Data` フォルダに`my_data.csv`が生成される。`LibreOffice`や`Numbers`、`Excel`などを使って`my_data.csv`を開いてみると、先ほど作成したデータが保存されていることが確認できる。

\begin{figure}[H]

{\centering \includegraphics[width=0.4\linewidth]{Figures/Rbasic/Export} 

}

\caption{保存したcsvファイルの中身}(\#fig:io-export-4)
\end{figure}

### RDataファイル

最後に`.RData`形式でデータを書き出してみよう。今回は先ほど作成した`my_data`と、以下で作成する`numeric_vec1`、`numeric_vec2`、`character_vec`を`my_RData.RData`という名のファイルとして `Data`フォルダに書き出す。使用する関数は `save()` である。引数として保存するオブジェクト名をすべてカンマ区切りで書き、最後に`file`　引数でファイル名を指定すればよい。


```{.r .numberLines}
numeric_vec1  <- c(1, 5, 3, 6, 99, 2, 8)
numeric_vec2  <- 1:20
character_vec <- c('cat', 'cheetah', 'lion',　'tiger')
save(my_data, numeric_vec1, numeric_vec2, character_vec, 
     file = "Data/my_RData.RData")
```

　実際に`my_RData.Rdata`ファイルが生成されているかを確認してみよう。ファイルの保存がうまくいっていれば、`my_RData.Rdata`を読み込むだけで、`my_data`、`numeric_vec1`、`numeric_vec2`、`character_vec` という4つのオブジェクトを一挙に作業スペースに読み込むことができるはずだ。実際にできるか確認しよう。そのために、まず現在の実行環境上にある`my_ata`、`numeric_vec1`、`numeric_vec2`、`character_vec`を削除する。そのために `rm()` 関数を使う。


```{.r .numberLines}
rm(my_data)
rm(numeric_vec1)
rm(numeric_vec2)
rm(character_vec)
```

　このコードは以下のように1行のコードに書き換えられる。


```{.r .numberLines}
rm(list = c("my_data", "numeric_vec1", "numeric_vec2", "character_vec"))
```

　4のオブジェクトが削除されたか、`ls()`関数で確認しよう。


```{.r .numberLines}
ls()
```

```
## [1] "EnglishScore" "Excel_DF"     "MathScore"    "my_df1"       "ShiftJIS_df1"
## [6] "ShiftJIS_df2" "ShiftJIS_df3" "Stata_DF"     "UTF8_df"
```

それでは`Data`フォルダー内の`my_RData.RData`を読み込み、4つのオブジェクトが実行環境に読み込まれるか確認しよう。


```{.r .numberLines}
load("Data/my_RData.RData") # Dataフォルダー内のmy_RData.RDataを読み込む
ls()                        # 作業スペース上のオブジェクトのリストを確認する
```

```
##  [1] "character_vec" "EnglishScore"  "Excel_DF"      "MathScore"    
##  [5] "my_data"       "my_df1"        "numeric_vec1"  "numeric_vec2" 
##  [9] "ShiftJIS_df1"  "ShiftJIS_df2"  "ShiftJIS_df3"  "Stata_DF"     
## [13] "UTF8_df"
```



