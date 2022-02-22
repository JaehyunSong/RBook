# R Markdown [応用] {#rmarkdown2}



## 表の作成 {#rmarkdown2-table}

## R Markdownを用いたスライド作成 {#rmakrdown2-slide}

R Markdownを用いたスライド作成例

ioslides、SlidyのようなHTMLフォーマット

Beamer出力、Powerpoint出力も可能

ここでは[Xaringan](https://github.com/yihui/xaringan)パッケージを使用

<iframe src="https://www.jaysong.net/teaching/KPU2020/Slide1.html" width="672" height="400px" data-external="1"></iframe>

### スライド区分 {#rmakrdown2-brak}

### コード {#rmakrdown2-chunk}

### ハイライト {#rmakrdown2-highlight}

### Xaringanスライドの操作 {#rmakrdown2-operation}

### 日本語フォントの指定 {#rmakrdown2-japanese}

### スライドのPDF出力

[Chrome](https://www.google.com/intl/ja_jp/chrome/)や[Opera](https://www.opera.com/ja)からスライドを開き、印刷でPDF出力

```r
pagedown::chrome_print("スライドファイル名.html")
```

Firefoxではできない

### もっと詳しく

[remarkのマニュアル](https://github.com/gnab/remark/wiki)
