--- 
title: '私たちのR: ベストプラクティスの探究'
author: "宋財泫 (Jaehyun Song)・矢内勇生 (Yuki Yanai)"
date: '改訂: 2022-02-24'
description: 'R Not for Everyone: An Esoteric Guide.'
url: https\://jaysong.net/RBook/
site: bookdown::bookdown_site
bibliography: tex/reference.bib
biblio-style: tex/jecon.bst
link-citations: yes
always_allow_html: yes
github-repo: JaehyunSong/RBook
cover-image: HTML/cover.png
favicon: HTML/favicon.png
apple-touch-icon: HTML/apple-favicon.png
apple-touch-icon-size: 120
---

 



# 紹介 {#preface .unnumbered}

<img src="figures/Cover.png" width="225" alt="RN4E" align="right" style="margin: 0 0 1em 1em; border-width: 1px; border-style: solid; border-color: black;" />

『私たちのR: ベストプラクティスの探究 (R Not for Everyone: An Esoteric Guide)』は[SONG Jaehyun](https://www.jaysong.net/) と [矢内勇生](https://yukiyanai.github.io) が共同で執筆するRプログラミングの「入門書」である。**統計学の本ではない**。また、**本書はデータ分析の手法の解説書でもない**。Rを用いたデータ分析については他の本を参照されたい。私たちが専門とする政治学におけるデータ分析については、以下の本を勧める。

- 浅野正彦, 矢内勇生. 2018. 『[Rによる計量政治学](https://www.ohmsha.co.jp/book/9784274223136/)』オーム社.
- 飯田健. 2013.『[計量政治分析](https://www.kyoritsu-pub.co.jp/bookdetail/9784320019249)』共立出版.
- 今井耕介（粕谷裕子, 原田勝孝, 久保浩樹 訳）2018.『[社会科学のためのデータ分析入門（上）（下）](https://www.iwanami.co.jp/book/b352348.html)』岩波書店.

本書が想定するのは、次のような希望をもつ読者である。

- 分析に入るまでの段階、つまりデータの入手やクリーニング方法が知りたい
- 分析結果を自分の思いどおりに可視化したい
- 複数のモデルを効率的に分析したい
- Rでシミュレーションがしたい
- Rと友達になりたい

本書を読んでも統計学やデータ分析を理解することはできない。本書の目的は、統計学やデータ分析についての知識を持った方々と、Rを使ってもっと効率的にデータ分析をする方法を共有することである。また、統計学やデータ分析を勉強する際に、プログラミングについての副読本として読むことも想定している。

本書を読み終える頃には、Rなしでは生活できなくなっていることだろう。

本書の執筆環境については本書の巻末節を参照されたい。

## 進捗状況 {-}

章立ては未定。著者が書きたいものから書く予定（全部で30~35章くらいになる見込み）。

- **第I部: Rの導入**
   - 第\@ref(aboutR)章: R? (50%)
   - 第\@ref(installation)章: Rのインストール (0%)
   - 第\@ref(ide)章: IDEの導入 (0%)
   - 第\@ref(R-Customize)章: 分析環境のカスタマイズ (0%)
   - 第\@ref(packages)章: Rパッケージ (50%)
- **第II部: Rの基礎**
   - 第\@ref(rbasic)章: 基本的な操作 (80%)
   - 第\@ref(io)章: データの入出力 (70%)
   - 第\@ref(datatype)章: データ型 (90%)
   - 第\@ref(datastructure)章: データ構造 (80%)
   - 第\@ref(programming)章: Rプログラミングの基礎 (75%)
   - 第\@ref(functions)章: 関数の自作 (50%)
- **第III部: データハンドリング**
   - 第\@ref(datahandling1)章: データハンドリング [基礎編: 抽出] (95%)
   - 第\@ref(datahandling2)章: データハンドリング [基礎編: 拡張] (95%)
   - 第\@ref(factor)章: データハンドリング [基礎編: factor型] (90%)
   - 第\@ref(tidydata)章: 整然データ構造 (85%)
   - 第\@ref(string)章: 文字列の処理 (0%)
- **第IV部: 可視化**
   - 第\@ref(visualization1)章: 可視化[理論] (85%)
   - 第\@ref(visualization2)章: 可視化[基礎] (85%)
   - 第\@ref(visualization3)章: 可視化[応用] (85%)
   - 第\@ref(visualization4)章: 可視化[発展] (85%)
- **第V部: 再現可能な研究**
   - 第\@ref(rmarkdown)章: R Markdown [基礎] (85%)
   - 第\@ref(rmarkdown2)章: R Markdown [応用] (0%)
   - 第\@ref(table)章: 表の作成 (0%)
   - 第\@ref(visualization5)章: モデルの可視化 (0%)
- **第VI部: 中級者向け**
   - 第\@ref(datahandling3)章: データハンドリング [応用編] (0%)
   - 第\@ref(iteration)章: 反復処理 (70%)
   - 第\@ref(oop)章: オブジェクト指向プログラミング (70%)
   - 第\@ref(monte)章: モンテカルロシミュレーション (50%)
   - 第\@ref(scraping)章: スクレイピング (0%)
   - 第\@ref(api)章: API (0%)

## 著者紹介 {-}

<div class="figure" style="text-align: center">
<img src="figures/Authors/SongYanai.jpg" alt="事例研究をこよなく愛する著者 (Portland, OR. 2016年2月)" width="50%" />
<p class="caption">(\#fig:preface-author)事例研究をこよなく愛する著者 (Portland, OR. 2016年2月)</p>
</div>

**Song Jaehyun**（宋 財泫 [ソン ジェヒョン]; 写真左）はR黒帯の大学教員。猫好き。
主な著書：[真に驚くべき業績を残しているが、この余白はそれを書くには狭すぎる](https://ja.wikipedia.org/wiki/フェルマーの最終定理)。
公開したRパッケージ: [BalanceR](https://github.com/JaehyunSong/BalanceR), [PRcalc](https://github.com/JaehyunSong/PRcalc), [SimpleConjoint](https://github.com/JaehyunSong/SimpleConjoint) など

* [関西大学](https://www.kansai-u.ac.jp/) [総合情報学部](https://www.kansai-u.ac.jp/Fc_inf/) 准教授
* Email: song@kansai-u.ac.jp
* Webpage: https://www.jaysong.net
* Twitter: [\@Tintstyle](https://twitter.com/Tintstyle)
* GitHub: https://github.com/JaehyunSong

**矢内勇生**（やない ゆうき; 写真右）はR歴15年の大学教員。猫好き。主な著書：『[Rによる計量政治学](https://github.com/yukiyanai/quant-methods-R)』（共著, オーム社, 2018年）, 『[政治経済学](http://www.yuhikaku.co.jp/books/detail/9784641150799)』（共著, 有斐閣, 2020年）
公開したRパッケージ：[rgamer](https://github.com/yukiyanai/rgamer)

* [高知工科大学](https://www.kochi-tech.ac.jp/) [経済・マネジメント学群](https://www.kochi-tech.ac.jp/academics/mng/) 准教授 
* Email: yanai.yuki@kochi-tech.ac.jp
* Webpage: https://yukiyanai.github.io
* Twitter: [\@yuki871](https://twitter.com/yuki871)
* GitHub: https://github.com/yukiyanai

## データのダウンロード {-}

本書のデータは全て筆者の GitHub リポジトリから入手可能である。データは以下の手順でダウンロードできる。

1. 本書の[GitHubリポジトリ](https://github.com/JaehyunSong/RBook) にアクセスする。
    * リポジトリのURL: https://github.com/JaehyunSong/RBook
2. dataフォルダーを選択する。
3. ダウンロードするファイル名を選択する。
4. 「Raw」を右クリックし、「Save Linked Contents As...」を選択する。
5. 保存するフォルダーを指定して、ダウンロードする。

## 本書における表記法 {-}

* コードは以下のように背景に色が付けられている部分である。


```{.r .numberLines}
print("Hello!")
```

* コードの中で`#`で始まる内容はコメントであり、分析に影響を与えない。ただし、`"`や`'`で囲まれた`#`はコメントではない。また、行の途中から`#`が入る場合、`#`以降は実行されない。


```{.r .numberLines}
# Hello!を出力するコード
print("Hello!")

# "や'内の#はコメントではない
print("この#はコメントではありません")

print("Hello World!") # Hellow World!を出力
```

* 出力結果は色付き背景かつ`##`で始まる箇所である。


```
## [1] "Hello!"
```

* オブジェクト名は`変数名`や`関数名()`のように文中の色付き背景で示された部分である。

* パッケージ名は{}で囲む。tidyverseパッケージの場合、{tidyverse}と表記する[^package-name]。

[^package-name]: ただし、パッケージ名を{}で囲むのは一般的な表記ではないことを断っておきたい。

## 著作権 {-}

<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a>

本著作物は [クリエイティブ・コモンズ 表示-非営利-改変禁止 4.0国際ライセンス](http://creativecommons.org/licenses/by-nc-nd/4.0/)の下に提供されています。


