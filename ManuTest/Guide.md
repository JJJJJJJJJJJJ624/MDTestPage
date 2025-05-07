---
title:  Markdown文書作成ガイドライン（PDF出力対応）
author: XXXXXX
date: 2025年4月
---

# 概要

このガイドラインは、Pandoc と LaTeX テンプレートを用いて Markdown ファイルから PDF を安定して生成するための記述ルールを定めたものです。


# 一般設定（出力時の基本オプション）

\begin{CodeBlockBox}
\texttt{pandoc Guide.md -o Guide.pdf \\
  --template=template\_custom.latex \\
  --pdf-engine=xelatex \\
  --columns=120}
\end{CodeBlockBox}

- "--pdf-engine=xelatex"：日本語フォントに対応。
- "--columns=120" は自動折り返しや表幅の制御のために必要です。

# セクション構成と自動番号付け  

\# Markdownの\verb|#|,\verb|##|,\verb|###| などを使えば、自動で LaTeX の \section, \subsection, \subsubsection に変換され、番号は自動で付与されます。

\begin{CodeBlockBox}
\verb|#| 第1章のタイトル

\verb|##| 1.1 セクションタイトル

\verb|###| 1.1.1 小見出し
\end{CodeBlockBox}

セクション番号を手動で書かないでください（PDFで重複やズレの原因になります）。


# 表のルール
## 書き方の基本
- 通常のMarkdown表記でOK。
- ただし、文字数に制限がある。目安は以下の通り

| 項目 | 推奨1列あたりの文字数（全角）|備考|
|-----------|------------------------------------------------|
|2列|~40文字|安定して表示される|
|3列|~30文字|調整次第で表示可能|
|4列|~20文字|改行が必要|

## 長文セルの改行方法
長文セルでは \textbackslash{}\textbackslash{} ではなく、LaTeXコマンド \textbackslash{}makecell{...} を使う：

\begin{CodeBlockBox}
| 項目 | 説明                                     | \\
|------|------------------------------------------| \\
| 例   | \textbackslash{}makecell{これは長い文章なので\textbackslash{}\textbackslash{}改行して見やすくしています} |
\end{CodeBlockBox}

↓出力例

| 項目 | 説明                                     |
|------|------------------------------------------|
| 例   | \makecell{これは長い文章なので\\改行して見やすくしています} |

# 画像挿入のルール
画像のレイアウトや大きさは テンプレート側で制御しています。
そのため、画像を挿入したい場合は、以下をマークダウンへ書き込んでください。

## 単体画像
\begin{CodeBlockBox}
\textbackslash{}SingleImage{images\textbackslash{}xxx.jpg}
\end{CodeBlockBox}

サイズ：縦長の画像は本文高さの40%になり、横長の画像は本文幅の80%になる

## 横並び画像

\begin{CodeBlockBox}
\textbackslash{}InsertImageRow{{images\textbackslash{}img1.jpg}, {images\textbackslash{}img2.jpg}, {images\textbackslash{}img3.jpg}}
\end{CodeBlockBox}

- 一枚だけ指定しても問題なく動作するが、出力される画像は小さくなる。
- 最大5毎まで横に並ぶ
- 自動で余白や画像幅が調整される

# 改行と段落のルール

| 操作 | Markdown記法|説明|
|-----|------------|-----|
|段落区切り|空行を挟む|通常の段落区切り|
|明示的改行|\textbackslash{}\textbackslash{}（非推奨）|表内だと効かない時がある|
|表内改行|\textbackslash{}makecell{atextbackslash{}\textbackslash{}b}|表中の複数行対応|

# コードブロックや記号・特殊文字の取り扱い

## 絵文字・記号など
PDF 出力時には対応フォント（例: Segoe UI）に該当の文字が含まれていないと、Missing character エラーになる。

## コードブロックの代替マクロ
Pandoc の \verb|--|highlight\verb|-|style によるシンタックスハイライトが LaTeX でうまく機能しないため、LaTeXでコードブロックがうまく機能しないときがありました。　　
テンプレート側のマクロ で対処しています。コードブロック風に仕立てたいときは、以下のように記述してください。

\begin{CodeBlockBox}
\texttt{\char92 begin\{CodeBlockBox\} \\
（ここに書きたい内容を記述） \\
\char92 end\{CodeBlockBox\}}
\end{CodeBlockBox}

# 禁止事項
- 表の中に数式など複雑なLaTeXコマンドを直接書くこと（エラー原因になります）

- \textbackslash{}section などの LaTeX 命令をMarkdown中に直接書くこと（Pandocで二重変換してしまいます）

- \textbackslash{}\textbackslash{} で強制改行しすぎる（表や画像と干渉してしまいます）

# その他注意事項
- 改ページは自動に任せましょう（\textbackslash{}newpage は使わない）

- ページ内に画像が入りきらない場合、自動的に次ページに送られます

- できる限りテンプレート内で自動制御されるよう調整済みです

# よくあるエラーと対処

| エラー内容 | 説明                                     |
|------|------------------------------------------|
| Missing number, treated as zero |一列内の文字が多すぎる|
| File ended while scanning use of |"{}"の対応ミス|
| 画像が出ない |パスミス or 画像ファイルの存在確認|
| 表がはみ出す |\texttt{columns=120 設定 or makecellで改行}|
