# (PART) Rの導入 {-}

# R? {#aboutR}



## Rとは {#WhatIsR}

\begin{figure}

{\centering \includegraphics[width=0.25\linewidth]{figures/AboutR/Rlogo} 

}

\caption{R Logo}(\#fig:aboutr-logo)
\end{figure}

　Rは統計、データ分析、作図のためのインタープリタープログラミング言語である。Rという名前は二人の開発者 Ross Ihaka と Robert Clifford Gentleman のイニシャルに由来する。R言語は完全にゼロベースから開発されたものではなく、1976年に開発されたS言語に起源をもつ。S言語もR言語同様、統計やデータ分析に特化した言語であり、S言語の開発が中止された現在、RはSの正当な後継者であると言ってよいだろう。

　R以外にも、統計・データ分析のために利用可能なソフトウェアはたくさんある。社会科学におけるデータ分析の授業を履修したことがあるなら、[SPSS](https://www.ibm.com/products/spss-statistics) や [Stata](https://www.stata.com) という名前をきいたことがあるかもしれない。工学系なら[MATLAB](https://www.mathworks.com/products/matlab.html) が有名かもしれない。企業では[SAS](www.sas.com/) という高価なソフトもよく使われる[^aboutr-sas]。

[^aboutr-sas]: 最近、アカデミック版が無料で使えるようになった。

　これらのソフト（アプリ）は基本的に有料だが、お金がないとデータ分析のソフトウェアが使えないわけではない。無料でありながら優れたソフトウェアも多く公開されている。以下にその一部を示す。

|ソフト・言語名|備考|
|---|---|
|[PSPP](https://www.gnu.org/software/pspp/) | SPSSにとてもよく似た無料ソフトウェア。|
|[JASP](https://jasp-stats.org)/[jamovi](https://www.jamovi.org)| 裏で動いているのはR。詳細は本章の後半で|
|[gretl](http://gretl.sourceforge.net)| 時系列分析など、計量経済学で利用される手法に特化したソフト。|
|[GNU Octave](https://www.gnu.org/software/octave/)|[MATLAB](https://www.mathworks.com/products/matlab.html) とほぼ同じ文法をもつ無料言語|
|[HAD](https://norimune.net/had)|[清水裕士](https://norimune.net) 先生が開発しているExcelベースのデータ分析マクロ|

　統計分析に特化したプログラミング言語としてRの競合相手になるのは [Julia](https://julialang.org) と [Python](https://www.python.org) だろう。Julia言語は一見Rによく似ているが、計算速度が Rより速いと言われている[^aboutr-julia]。ただし、比較的新しい言語であるため、パッケージと解説書がRよりも少ないという難点がある。Pythonは現在のデータサイエンス界隈において、Rとともに最も広く使われている言語である[^aboutr-python]。Pythonは統計・データ分析に特化した言語ではないが、統計・データ分析のライブラリが非常に充実しており、機械学習（とくに、コンピュータービジョン）ではRよりも広く使われている。Python以外の言語、たとえば C や Java、Ruby、Fortranでも統計・データ分析は可能ある。実際、RやPythonのパッケージの一部はCやJavaで作成されている。ただし、RやPythonに比べると、データ分析の方法を解説したマニュアル・参考書があまりないのがつらいところだ。ひとつの言語だけでなく、複数の言語を使えるようになったほうが良いことは言うまでもない。本書はRについて解説するが、他の言語にもぜひ挑戦してほしい。

[^aboutr-julia]: Rもコードの書き方によってパフォーマンス向上ができる。

[^aboutr-python]: Pythonは統計分析以外でも利用されるので、Python自体のユーザはRのユーザより多いだろう。

---

## Why R? {#WhyR}

　私たちRユーザにとっての神のような存在である[Hadley Wickham](http://hadley.nz)（通称：羽鳥先生）は [Advanced R (2nd Ed.)](https://adv-r.hadley.nz) で次のように仰せられた。

> * It’s free, open source, and available on every major platform. As a result, if you do your analysis in R, anyone can easily replicate it, regardless of where they live or how much money they earn.

1. Rは無料で、オープンソースで、多くのプラットフォーム（訳注: macOS, Linux, Windowsなど）で利用できます。よって、Rを使って分析すれば、どこに住んでいるか、いくらお金を稼いでいるかに関係なく、誰でも簡単にその分析を再現できることができます。

> * R has a diverse and welcoming community, both online (e.g. the #rstats twitter community) and in person (like the many R meetups). Two particularly inspiring community groups are rweekly newsletter which makes it easy to keep up to date with R, and R-Ladies which has made a wonderfully welcoming community for women and other minority genders.

2. オンライン (twitterの[#rstat](https://twitter.com/hashtag/rstat?src=hashtag_click)など)、オフライン (訳注：日本では [Tokyo.R](https://tokyor.connpass.com/) が有名。筆者たちが開催している [KUT.R](https://github.com/yukiyanai/KUT_R) もある)　の両方で、多様なRコミュニティがあります。他にも最新のRをキャッチアップするためのニュースレターである[rweekly](https://rweekly.org/)や、女性や性的マイノリティーにやさしい [R-Ladies](http://r-ladies.org/) も活発に活動しています。

> * A massive set of packages for statistical modelling, machine learning, visualisation, and importing and manipulating data. Whatever model or graphic you’re trying to do, chances are that someone has already tried to do it and you can learn from their efforts.

3. 統計モデリング、機械学習、可視化、データ読み込みおよびハンドリングのための膨大なパッケージが用意されています。どのようなモデルやグラフでも、既に誰かがその実装を試みた可能性が高く、先人らの努力に学ことができます。

> * Powerful tools for communicating your results. R Markdown makes it easy to turn your results into HTML files, PDFs, Word documents, PowerPoint presentations, dashboards and more. Shiny allows you to make beautiful interactive apps without any knowledge of HTML or javascript.

4. 分析結果を伝達する強力なツールを提供しています。R Makrdownは分析結果をHTML、PDF、Word、PowerPoint、Dashboard 形式に変換してくれます。HTMLや JavaScript の知識がなくても、Shinyを使って美しい対話型のアプリケーションを開発することができます。

> * RStudio, the IDE, provides an integrated development environment, tailored to the needs of data science, interactive data analysis, and statistical programming.

5. 代表的な統合開発環境であるRStudioはデータサイエンス、対話型のデータ分析、そして統計的プログラミングが必要とするものに最適化されています。

> * Cutting edge tools. Researchers in statistics and machine learning will often publish an R package to accompany their articles. This means immediate access to the very latest statistical techniques and implementations.

6. Rは最先端のツールです。多くの統計学や機械学習の研究者は自分の研究成果とRパッケージを同時に公開しています。これは最先端の方法を誰よりも早く実施可能にします。

> * Deep-seated language support for data analysis. This includes features like missing values, data frames, and vectorisation.

7. データ分析を根強くサポートする言語です。欠損値、データフレーム、ベクトル化などがその例です。

> * A strong foundation of functional programming. The ideas of functional programming are well suited to the challenges of data science, and the R language is functional at heart, and provides many primitives needed for effective functional programming.

8. Rはデータサイエンスに非常に有効である関数型プログラミングのための最適な環境を提供しています。

> * RStudio, the company, which makes money by selling professional products to teams of R users, and turns around and invests much of that money back into the open source community (over 50% of software engineers at RStudio work on open source projects). I work for RStudio because I fundamentally believe in its mission.

9. RStudio社は営利企業ですが、その収益の多くをオープンソースコミュニティーに投資しています。

> * Powerful metaprogramming facilities. R’s metaprogramming capabilities allow you to write magically succinct and concise functions and provide an excellent environment for designing domain-specific languages like ggplot2, dplyr, data.table, and more.

10. メタプログラミングが強力です。Rが持つメタプログラミング能力はあなたのコードを劇的に簡潔にするだけでなく、統計/データ分析に特化した`ggplot2`、`dplyr`、`data.table`などの開発も可能にしました。

> * The ease with which R can connect to high-performance programming languages like C, Fortran, and C++.

11. RはC、C++、Fortranのようなハイパフォーマンス言語と容易に結合できるように設計されています。

　しかし、他のプログラミング言語と同様、Rは完璧な言語ではありません。以下はR言語の短所の一部です。その多くはRそのものの問題というよりも、(プログラマーではなく)データ分析の研究者が中心となっているRユーザーから起因する問題です。

> * Much of the R code you’ll see in the wild is written in haste to solve a pressing problem. As a result, code is not very elegant, fast, or easy to understand. Most users do not revise their code to address these shortcomings.

1. あなたが普段見る多くのRコードは「今の」問題を解決するために迅速に書かれたものです。この場合、コードはあまりエレガントでも、速くも、読みやすくありません。ほとんどのユーザーはこの短所を克服するためのコード修正を行っておりません。

> * Compared to other programming languages, the R community is more focussed on results than processes. Knowledge of software engineering best practices is patchy. For example, not enough R programmers use source code control or automated testing.

2. 他のプログラミング言語に比べ、Rコミュニティーは過程よりも結果に注目する傾向があります。多くのユーザーにおいて、ソフトウェアエンジニアリングの知識を蓄えるための方法が不完全です。たとえば、(GitHubなどの) コード管理システムや自動化された検証を使用するRプログラマーは多くありません。

> * Metaprogramming is a double-edged sword. Too many R functions use tricks to reduce the amount of typing at the cost of making code that is hard to understand and that can fail in unexpected ways.

3. Rの長所でもあるメタプログラミングは諸刃の剣です。あまりにも多くのR関数はコーディングのコストを減らすようなトリックを使用しており、その代償としてコードの理解が難しく、予期せぬ失敗の可能性があります。

> * Inconsistency is rife across contributed packages, and even within base R. You are confronted with over 25 years of evolution every time you use R, and this can make learning R tough because there are so many special cases to remember.

4. 開発されたパッケージは、R内蔵のパッケージさえも一貫性が乏しいです。あなたはRを使う度にこの25年を超えるRの進化に直面することになります。また、Rには覚えておくべきの特殊なケースが多く、これはR学習の妨げとなっています。

> * R is not a particularly fast programming language, and poorly written R code can be terribly slow. R is also a profligate user of memory.

5. Rは格別に速い言語ではありません。下手に書かれたコードは驚くほど遅いです。また、Rはメモリの浪費が激しい言語と知られています。

---

## GUIとIDE {#GUI_IDE}

### GUI

**CUIとGUI**

　現在、多くのソフトウェアはGUIを採用している。GUI とは Graphical User Interface の略で、ソフトウェア上の入力および出力にグラフィックを利用する。単純にいうと「マウスでポチポチするだけで操作できる環境」のことだ。一方、Rでは基本的にCUI (Character User Interface) を利用する[^aboutr-cli]。これは全ての操作を文字列ベースで行う、つまりキーボードで行うことを意味する[^aboutr-mouse]。

[^aboutr-cli]: CLI (Command Line Interface) とも呼ばれる。

[^aboutr-mouse]: 多くの人が片手に5本もつ指を有効に利用できないマウスという不便な機器から解放される。

　身近な例として、あるラーメン屋での注文（呪文）システムを考えてみよう。無料トッピングを指定するときに「決まった言い方」で指定するのがCUI方式である。一文字でも間違うとオーダーは通りらない。たとえば、「野菜マッシマッシ!」とか「野菜MashMash!」と言ってしまうと、店長さんに「は？」と言われ、周りの客から白い目で見られる[^aboutr-jiro]。他方、食券の自動発売機でトッピングを指定できるのがGUI方式だ[^aboutr-ichiran]。この場合、そもそも間違いは起きない。誰でも簡単に注文できるのがGUI式のメリットだが、自分で注文するものが決まっていて、注文の仕方を知っているなら CUI式のほうが早い。毎回同じ注文をするなら、注文内容を録音しておいて、次回はそれを再生することも可能である。GUI方式では、注文方法を再現するのは難しい。

[^aboutr-jiro]: すべての「ラーメン◯郎」がそうだというわけではない。

[^aboutr-ichiran]: たとえば、「◯蘭」の注文システムのように。

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{figures/AboutR/CUI_GUI} 

}

\caption{CUIとGUIの比較}(\#fig:aboutr-cui-gui)
\end{figure}

　CUIとGUIを比べたとき、一見するとGUIのほうが優れているように見える。マウスでポチポチするだけで操作できるほうが楽に見えるし、間違いの心配もなさそうな気がする。キーボードで長いコマンドを打つCUIよりも、ボタンをクリックしたほうが手早く済みそうにも思える[^aboutr-illusion1]。そして、CUIのコマンドを覚えるのはしんどい[^aboutr-illusion2]。

[^aboutr-illusion1]: これらはすべて錯覚である。

[^aboutr-illusion2]: これは錯覚ではない。

　しかし、CUIにはCUIなりの長所がある。まず、コードが記録できる。マウスでポチポチした操作は、パソコンの画面全体を録画しない限り記録できない。よって、GUIでは自分の分析プロセスを記録することが難しい。他方、すべてコマンドで操作した場合、入力したコマンドを文字列として記録することは容易である。また、CUIはGUIよりも柔軟である。先ほどのラーメン屋の例で考えると、CUIでは「一応」野菜ちょいマシのような注文（呪文）のカスタマイズもできる[^aboutr-jiro2]。しかし、GUI（券売機）だと注文の自由なカスタマイズはできない。店が用意したボタンしか押せない（ソフトがメニューに表示しているコマンドしか実行できない）。また、コマンドの入力の時間や暗記も、それほど難しくはない。後で説明するように、Rユーザにとっての超有能な秘書であるRStudio (IDEの1種) がコマンド入力を助けてくれる。スペルが間違っていたり、うろ覚えのコマンドなどがあっても、RStudio （あるいはその他のIDE）が瞬時に正解に導いてくれる。

[^aboutr-jiro2]: 通るかどうかは別だが...

　本書はCUIとしてのRについて解説する。Rは統計ソフトでありながら、言語でもある。外国語の勉強に喩えるなら、CUIを使うのは単語や熟語を覚え、文法やよく使う表現を学習して自分で考えて話すことであるのに対し、GUIを使うのは AI に翻訳を頼み、外国語については自分で一切考えないことに似ている。たいして興味のない国になぜか旅行で訪れることになった場合にはGUI方式で済ますのも良いだろう。しかし、それでその言語を「勉強した」とか「理解した」などという人はいないはずだ。Rを「理解」したいなら、CUI以外の選択肢はない[^aboutr-macgui]。

[^aboutr-macgui]: macOS にRをインストールする場合は、途中で「GUIをインストールする」というチェックを外すことができるので、外しておこう。RのGUIは不要である。あっても困りはしないが。

　それでもやはりGUIのほうがとっつきやすいという頑固なあなたのために代表的なRの GUI を紹介するので、以下のリストを確認したらこの本は閉じていただきたい。またいつかどこかでお会いしましょう。CUIを使う覚悟ができたあなたは、以下のリストを読みとばし、引き続き一緒にRの世界を楽しみましょう！


* [R Commander](https://socialsciences.mcmaster.ca/jfox/Misc/Rcmdr/)

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{figures/AboutR/GUI_Rcmdr} 

}

\caption{R Commander}(\#fig:aboutr-rcmdr)
\end{figure}

* [RKWard](https://rkward.kde.org)

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{figures/AboutR/GUI_RKWard} 

}

\caption{RKWard}(\#fig:aboutr-rkward)
\end{figure}

* [JASP](https://jasp-stats.org)

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{figures/AboutR/GUI_JASP} 

}

\caption{JASP}(\#fig:aboutr-jasp)
\end{figure}

* [jamovi](https://www.jamovi.org)

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{figures/AboutR/GUI_jamovi} 

}

\caption{jamovi}(\#fig:aboutr-jamovi)
\end{figure}

* [R AnalyticFlow](https://r.analyticflow.com)

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{figures/AboutR/GUI_RAnalyticFlow} 

}

\caption{RAnalyticFlow (画像は公式ホームページから)}(\#fig:aboutr-ranalyticflow)
\end{figure}



### IDE {#aboutR-IDE}

　プログラミングは基本的にコードを書く作業の連続だが、コードを書く他にも様々な作業を行うことになる。たとえば、自分が書いたコードの結果が正しく動作するかの確認作業や、なにか問題がある場合の対処（デバッグ）などがある。また、コードを書く際、誤字やミスなどがないかも確認する必要がある。他にもプログラムで使用されるファイルを管理しなければならない。これらの仕事を手助けしてくれるのが統合開発環境 (integrated development environment; IDE) と呼ばれるものである。

　プログラマにとって優れたIDEを使うということは、優れた秘書を雇用するようなものだ。ファイルの管理、うろ覚えのコマンドの補完入力、コードの色分けなどを自動的に行ってくれる。さらに、コードの実行結果の画面をコードと同時に表示してくれたり、これまでの作業を記録してくれるなど、多くの作業を手助けしてくれる。Rにはいくつかの優れたIDEが用意されている。本書では代表的なIDEである [RStudio](https://rstudio.com) を使うことにする。ただし、プログラミングにIDEは必須ではない。IDEをインストールしなくても、本書を読む上で特に問題はない（RStudioに関する説明の部分を除く）が、Rの実行環境に特にこだわりがないなら RStudioの導入を強く推奨する。


\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{figures/AboutR/IDE_RStudio} 

}

\caption{RStudio}(\#fig:aboutr-rstudio)
\end{figure}


　RStudio以外にもRのIDEはある。魔界において圧倒的なシェアを誇ると噂されるWindowsという名のOSを使用しているなら、[R Tools for Visual Studio](https://docs.microsoft.com/ja-jp/visualstudio/rtvs/installer?view=vs-2017) がRStudioの代替候補として有力だ。

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{figures/AboutR/IDE_RTVS} 

}

\caption{R Tools for Visual Studio}(\#fig:aboutr-rtvs)
\end{figure}

　自分が使い慣れたテキストエディタをIDEとして使うことも可能である。[Sublime Text](https://www.sublimetext.com) や [Atom](https://atom.io) はむろん、伝統のある [Emacs](https://www.gnu.org/software/emacs/) や [Vim](https://www.vim.org) を使うこともできる。


