# Markdown→PDF/html

## 概要
**Markdown 原稿 → PDF / HTML** 自動変換と  
バージョン管理を兼ね備えたドキュメント集(例)
最新版は nightly バッチで `output/` に集約され、Web 共有や社内配布に即利用できる。 

## ファイル構造
project_root/  
├── manuals/ # 各マニュアル専用フォルダ  
│ ├── A001_Manual1/  
│ │ ├── A001_Manual1_v1.2.md # ★ 最新版 Markdown  
│ │ ├── img/ # 最新版で使う画像  
│ │ │ └── fig1.png  
│ │ └── oldversions/ # 旧バージョン収納  
│ │ │ ├── A001_Manual1_v1.0  
│ │ │ │ ├── A001_Manual1_v1.0.md  
│ │ │ │ └── img/ # 旧バージョン収納  
│ │ │ └── A001_Manual1_v1.1/ ...  
│ └── A002_Manual2/ ...  
│  
├── shared/ # 共有テンプレート・フィルタ  
│ ├── filter.lua  
│ ├── adjust_CSSRev.html  
│ └── template_custom.latex  
│  
├── output/ # ★ バッチ生成物を集中管理  
│ ├── html/ # latest 版のみ  
│ │ ├── A001_Manual1.html  
│ │ ├── A002_Manual2.html  
│ │ └── index.html # 自動生成の目次  
│ └── pdf/  
│ ├── A001_Manual1.pdf  
│ └── A002_Manual2.pdf  
│  
├── convert.ps1 # PowerShell 自動変換スクリプト  
└── README.md  

### 命名規則
| 種別 | ルール | 例 |
|------|--------|----|
| **フォルダ** | `AAAA_ManualX`（番号_タイトル） | `A001_Manual1` |
| **最新版** | `同名_vX.Y.md` で最大バージョンを最新版とみなす | `A001_Manual1_v1.2.md` |
| **旧版** | `manualX/oldversions/` 配下にコピーして保管 | `oldversions/A001_Manual1_v1.0.md` |

画像は 常に `img/` に置き、Markdown では相対パス `img/(ファイル名).png` を記述してください。

##  convert.ps1 ― 変換スクリプト

- **HTML**  
  - `--standalone --embed-resources --number-sections` で単ファイル化  
  - `shared/adjust_CSSRev.html` でカスタム CSS 注入  
- **PDF**  
  - `shared/template_custom.latex` ＋ `xelatex` 出力  
  - Python / LaTeX コードブロック用ハイライトは `pygments`  
- **差分ビルド**  
  - 既存出力より `.md` が新しい場合のみ再生成


### 夜に走れ
タスク スケジューラ設定（例：毎日 01:00）  
- Create Basic Task
    - Name: Markdown_Convert_Nightly
- Trigger → Daily / 01:00
- Action → Start a program
'''
Program : powershell.exe
Args    : -ExecutionPolicy Bypass -NoProfile `
          -File "C:\path\to\project_root\convert.ps1" `
          >> "C:\path\to\project_root\nightly.log" 2>>&1
'''

- 完了後、右クリック→Runでテスト実行

## つかいかた
1. 新規フォルダ作成  
'''
manuals\A(分別番号)003(連番でつける)_NewManual(マニュアル名)\
'''
1. Markdown と画像配置

```
A003_NewManual_v1.0.md
img\...
```
※ バッチ処理は、v以降の数字が一番大きいものを最新とみなしてなされる。
1. 夜間バッチ or 手動 convert.ps1 実行  
output/ に A003_NewManual.html と A003_NewManual.pdf が生成される
htmlとpdfの旧版を残すときは、 oldversions/ にフォルダごとコピーして保存しておくこと。　　


## さんこうにしたさいと
[Github使いかたサイト](https://www.kagoya.jp/howto/it-glossary/develop/howtousegithub/)

#Pandoc テンプレート
[Pandocテンプレート：デフォルトのやつを使うべきか否か](https://zenn.dev/sky_y/articles/pandoc-default-template-or-not)

