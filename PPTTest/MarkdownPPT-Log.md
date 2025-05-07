---
theme : "black"
transition : "default"
title: Markdownによるプレゼンテーション作成ツールの比較検討
author: あなた
date: 2025-05-07
---

# はじめに  
- Markdownの可能性  
  - 軽量マークアップで可読性◎  
  - テキストとデザイン分離→メッセージに集中  
  - バージョン管理・共同編集に最適  
- 本レポートの目的  
  - CLIベースかつオフライン完結  
  - PPTX / PDF / HTML 出力  
  - 図表、LaTeX数式、英日対応  
  - セキュリティ重視

---

# 比較対象ツール一覧  
1. **Pandoc**  
2. **Marp**  
3. **Slidev**  
4. **Reveal.js**  
5. **md2pptx**  
6. **Slidesdown**  

---

<section>

## 各ツールの特徴まとめ  
<span style="font-size: 0.8em;">  

| ツール       | PPTX  | PDF   | HTML  | CLI  | Anime | Formula |
|--|:--:|:--:|:--:|:--:|:--:|:--:|
| **Pandoc** | ○     | ○     | ○     | ○   | △ | ○    |
| **Marp**   | ○ | ○     | ○     | ○   | △ | ○    |
| **Slidev** | ○ | ○     | ○     | ○   | ◎   | ○    |
| **Reveal.js** | ×   | △| ○    | △ | ◎  | ○    |
| **md2pptx**| ○     | ×     | ×     | ○   | △   | ○    |
| **Slidesdown** | ×  | ○     | ○     | ○   | ○| ○  |

※Marp/SlidevのPPTXは「スライドを画像化」方式  
↓各ツールの詳細は下スライドに記載  
→選び方総括は横スライドに記載  

</span>

</section>
<section>

## 1. Pandoc  
- **メリット**  
  - 多彩な出力形式：PPTX/PDF/HTML（Reveal, Beamer等）  
  - 完全CLI＆ローカル完結→セキュア  
  - LaTeX数式埋込可  
- **デメリット**  
  - テンプレート／CSS／LaTeX知識が必要  
  - PPTX中の画像・テキスト配置に制限あり  
  - アニメーションは一覧段階表示のみ  
- 所感  
  - 変換力が売りっぽい。
  - テンプレートとフィルターの利用でいろいろと拡張できる
  - そのぶんカスタムが大事になる  
</section>
<section>

## 2. Marp  
- **メリット**  
  - VSCode拡張でライブプレビュー◎  
  - PPTX/PDF/HTML出力  
  - MathJaxで数式対応  
  - 日本人開発・日本語フォントOK  
- **デメリット**  
  - PPTXは画像貼付形式（編集制限）  
  - 高度なアニメーションはカスタマイズ要  
  - CSS知識があるとデザイン幅が広がる  
- 所感  
  - ディレクティブ機能が優秀らしい
  - 洗練されたテーマが最初から用意されていて、CSS無しでもきれいなスライドが作れるらしい
</section>
<section>

## 3. Slidev  
- **メリット**  
  - Vueコンポーネント併用でインタラクティブ  
  - Mermaid, 動的グラフなど開発者向け機能  
  - PPTX/PDFは画像貼付で一括出力  
- **デメリット**  
  - Node.js／npm 環境が必要  
  - 非エンジニアには初期ハードル高め  
- 所感  
  - ブラウザでリアルタイム編集できるらしい
  - Presenterモードが優秀で、 Reveal.jsより高機能とも言われるらしい
</section>
<section>

## 4. Reveal.js  
- **メリット**  
  - 多彩なテーマ・トランジション  
  - Auto-Animateなど高度なアニメーション  
  - 動画・音声・外部ライブラリ埋込◎  
- **デメリット**  
  - HTMLフレームワークのため初期設定がやや重い  
  - 直接PPTX出力× → PDFはブラウザ印刷で代替  
- 所感  
  - スライドを上下に増やせるのはReveal.jsのみっぽい
  - 補足つけまくれる分脳死でスライド作れそう
</section>
<section>

## 5. md2pptx  
- **メリット**  
  - PythonベースでMarkdown→PPTX直接変換  
  - オフラインで完結  
  - カスタムテンプレートが後付け可能  
- **デメリット**  
  - 複雑なMarkdownの書式に弱い場合あり  
  - アニメーション機能は限定的  

</section>
<section>

## 6. Slidesdown  
- **メリット**  
  - Reveal.jsエコシステムをCLIで手軽に操作  
  - Dockerオプションで完全オフライン可  
- **デメリット**  
  - PPTX直接出力×  
  - HTMLベース前提

</section>

---

## 選び方  
- **汎用性重視** → **Pandoc**  
- **PPTX直接出力重視** → **md2pptx**  
- **簡便さ＋PPTX対応** → **Marp**  
- **インタラクティブ性重視** → **Slidev/Reveal.js**  

---

## CLIツールの基本コマンド例  

```bash
# Pandoc
pandoc slides.md -o slides.pptx
pandoc slides.md -o slides.pdf
pandoc slides.md -t revealjs -s -o slides.html

# md2pptx
python3 md2pptx.py slides.pptx < slides.md

# Marp CLI
marp slides.md --output slides.pptx
marp slides.md --output slides.pdf
