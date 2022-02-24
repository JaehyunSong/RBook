# Rのインストール {#installation}



本章の内容は今後、以下の資料に基づき、再作成する予定である。

* 矢内による資料 ([macOS編](https://yukiyanai.github.io/jp/resources/docs/install-R_macOS.pdf)、[Linux (Ubuntu)編](https://yukiyanai.github.io/jp/resources/docs/install-R_ubuntu.pdf)、[Windows編](https://yukiyanai.github.io/jp/resources/docs/install-R_windows.pdf))

<!--
## Rのインストール {#install-R}

### macOSの場合

#### 前準備

* Xcodeの入手
    * Command Line Tools?
* XQuartz
* clang, gfortran, tcltk?
* http://mac.r-project.org/tools/

#### Rのダウンロードとインストール

### Linuxの場合

Linuxの場合、ディストリビューション (distribution)[^dist]によってインストール方法がやや異なります。詳細は[CRAN](https://cran.r-project.org/index.html)を参照して頂きますが、ここでは個人用OSとして広く使われている[Ubuntu](https://jp.ubuntu.com/) 18.04.4 LTSの例を紹介します。

[^dist]: よく使われるディストリビューションとしては[Debian](https://www.debian.org)系とRed Hat系があります。シェアトップレベルの[Ubuntu](https://ubuntu.com)と[Mint](https://www.linuxmint.com)はDebian系です。ちなみに、個人向けのRed Hat Linuxは開発中止され、現在は[Fedora](https://getfedora.org)に受け継がれています。Red Hat系ではFedoraだけでなく、[CentOS](https://www.centos.org)も広く使われています。最近は[arch linux](https://www.archlinux.org)系の[manjaro linux](https://manjaro.org)も人気です。人気ディストリビューションにつしては[DistroWatch.com](https://distrowatch.com/dwres.php?resource=popularity)から最新ランキングを確認してください。

<div class="figure" style="text-align: center">
<img src="Figures/Installation/R_Ubuntu1.png" alt="Terminalの起動" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-1)Terminalの起動</p>
</div>

まず、Terminal (端末)を立ち上げます。Terminalはデスクトップ画面で右クリックし、「Open Terminal (端末を開く)」を選択します。Terminalプロンプト上に以下のように入力します。

```
sudo apt-get install r-base
```

パスワードを入力すれば、Rがインストールされます。インストールされたRするにはいくつかの方法があります。1つ目はTerminal上で

```
R
```

と入力するだけです。

<div class="figure" style="text-align: center">
<img src="Figures/Installation/R_Ubuntu2.png" alt="Applicationから起動1" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-2)Applicationから起動1</p>
</div>

2つ目の方法はApplicationから開く方法です。Ubuntuの左上の「Activities (アクティビティ)」または、左下のボタンをクリックします。

<div class="figure" style="text-align: center">
<img src="Figures/Installation/R_Ubuntu3.png" alt="Applicationから起動2" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-3)Applicationから起動2</p>
</div>

上段中央の検索で「R」を入力し、検索結果からRを選択します。

<div class="figure" style="text-align: center">
<img src="Figures/Installation/R_Ubuntu4.png" alt="R Console" width="100%" />
<p class="caption">(\#fig:linux-r-console)R Console</p>
</div>

図\@ref(fig:linux-r-console)のような画面が表示されたらRはインストールは完了です。

### Windowsの場合

<center>
    <font color="red"><b>R 4.0.0ではOneDriveとの同期問題がなくなったという噂も...?</b></font>
</center>

#### 前準備

Rをインストールする前に以下の2点を確認します。

1. 自分のWindowsがOneDriveと連携している[^winproblem1]
2. ユーザー名が日本語になっている[^winproblem2]

[^winproblem1]: この場合、パッケージのインストールがうまくできない可能性があります。
[^winproblem2]: RStudioが起動しない可能性があります。

一つ以上当てはまる場合、以下の手順で前準備をします。どれも該当しない場合、次節に移りましょう。

**OneDriveとの連携を確認する方法**

1. そもそもOneDriveがインストールされていないなら、問題ありません。
2. タスクバー (画面下段のバー)の右側にあるOneDriveのアイコンをクリックし、「その他」>「設定」
3. 「バックアップ」タブの「バックアップを管理」をクリック
4. 真ん中の「ドキュメント」の列に「**ファイルはバックアップされました**」と表示されている場合、WindowsとOneDriveが連携していることを意味します。

**OneDirveとの連携を解除する方法**

5. 「バックアップを停止」をクリックします[^onedrive1]。

[^onedrive1]: 普段OneDriveのバックアップ機能を使用している場合、この方法は推奨できません。

**ユーザー名の確認方法**

1. 「設定」>「アカウント」
2. でかいアイコンの下にユーザー名が表示されていますが、ここが日本語になっていると、ユーザー名は日本語ということになります。

**解決方法**

新しいユーザーを生成するのが手っ取り早いです。詳しい手順は[ここ](https://support.microsoft.com/ja-jp/help/4026923/windows-10-create-a-local-user-or-administrator-account)から確認できます。

#### Rのダウンロードとインストール

<div class="figure" style="text-align: center">
<img src="Figures/Installation/R_Windows1.png" alt="Rのインストール1 (Windows)" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-4)Rのインストール1 (Windows)</p>
</div>

CRAN (https://cran.r-project.org/)にアクセスし、「Download R for Windows」を選択します。

<div class="figure" style="text-align: center">
<img src="Figures/Installation/R_Windows2.png" alt="Rのインストール2 (Windows)" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-5)Rのインストール2 (Windows)</p>
</div>

「base」を選択します。

<div class="figure" style="text-align: center">
<img src="Figures/Installation/R_Windows3.png" alt="Rのインストール3 (Windows)" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-6)Rのインストール3 (Windows)</p>
</div>

「Download R x.x.x for Windows」を選択し、インストーラーをダウンロードします。

インストールの途中、コンポーネントの選択画面が表示されます。「Core File」と「Message translation」にはチェックを入れますが、自分のパソコンのbitによって32bitか64bitかが決まります。多くの場合、64bitで問題ありませんが、以下のような方法で確認できます。

<div class="figure" style="text-align: center">
<img src="Figures/Installation/R_Windows_Pre1.png" alt="bitの確認 (1)" width="50%" />
<p class="caption">(\#fig:unnamed-chunk-7)bitの確認 (1)</p>
</div>

1. デスクトップ画面のPCを**右クリック**し、「プロパティ」を選択

<div class="figure" style="text-align: center">
<img src="Figures/Installation/R_Windows_Pre2.png" alt="bitの確認 (2)" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-8)bitの確認 (2)</p>
</div>

2. 「システムの種類」を確認

#### Rtoolsのインストール

---

## .Rprofileの設定 {#rbasic-profile}

---

## RStudio {#install-rstudio}

### RStudioのインストール

RStudioのインストール方法はもっと簡単です。

<div class="figure" style="text-align: center">
<img src="Figures/Installation/RStudio1.png" alt="RStudioのインストール1" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-9)RStudioのインストール1</p>
</div>

まず、RStudioのホームページ (https://rstudio.com)にアクセスし、「Download」をクリックします。

<div class="figure" style="text-align: center">
<img src="Figures/Installation/RStudio2.png" alt="RStudioのインストール2" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-10)RStudioのインストール2</p>
</div>

RStudio Desktopの「Download」を選択します。

<div class="figure" style="text-align: center">
<img src="Figures/Installation/RStudio3.png" alt="RStudioのインストール3" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-11)RStudioのインストール3</p>
</div>

自分のOSに合ったインストーラーをダウンロードします[^rstudio-ubuntu]。

[^rstudio-ubuntu]: Linuxの場合、OSとそのバージョンによってダウンロードするインストーラーが異なります。現時点 (2020年3月)におけるUbuntuの安定版は18.0.4.4ですので、この場合、「Ubuntu 18/Debian 10」を選択します。

ダウンロードしたインストーラーを実行すると、

* macOSの場合、RStudioのアイコンをApplicationフォルダーに移動させます。
* Ubuntuの場合、Ubuntu Softwareが起動されます。「Install」をクリックするだけです。
* Windowsの場合、自動的にインストーラーが起動されます。指示に従ってインストールします。

### RStudioの起動と設定

とりあえずインスールされたRStudioを立ち上げてみましょう。図\@ref(fig:RStudio1)のおような画面が表示されたら問題なくRStudioがインストールされていると考えて良いでしょう。図\@ref(fig:RStudio1)と完全に同じ画面が表示されなくても問題ゴザ会いません。

<div class="figure" style="text-align: center">
<img src="Figures/Installation/RStudio_Setting1.png" alt="RStudioの初期画面" width="100%" />
<p class="caption">(\#fig:RStudio1)RStudioの初期画面</p>
</div>

### RStudioの設定

このままでもRプログラミングはできます。前章で説明したように、RStudioのようなIDEはプログラミングにおける有能な秘書さんです。もっと自分の好みに合わせてカスタマイズすれば、コーディングも捗るでしょう。せっかくIDEをインストールしましたし、より便利に使えるようにRStudioの設定を変えてみましょう。

1. RStudioの設定を変えるには「Tools」の「Global Option」を選択します。

2. 左側から「General」を選択します。

3. 左側から「Code」を選択します。
    * 「Editing」タブを選択します。
    * 「Display」タブを選択します。


最後にRStudio画面の設定をしましょう。今のままでももんだいありませんが、快適なコーディングのためには、できる限りコードの画面を大きくする必要があります。そのためには、あまり使わない機能はどこかの領域に集め、最終的には最小化させて見えないようにします。

1. メニュー「Tools」から「Global Option」を選択します。
2. 左側から「Pane」を選択します。
3. それぞれの領域を図\@ref(fig:PaneExample)のように設定します。
    * ちなみに、RStudioのテーマやフォントなどの設定は「Apperance」から調整できます。
4. 「OK」を押してRStudioの画面に戻ったら、左下Paneの最小化ボタン (図\@ref(fig:PaneExample)の赤い四角形)をクリックし、最小化します。

<div class="figure" style="text-align: center">
<img src="Figures/Installation/RStudio_Setting4.png" alt="Pane設定後" width="100%" />
<p class="caption">(\#fig:PaneExample)Pane設定後</p>
</div>

---
-->
