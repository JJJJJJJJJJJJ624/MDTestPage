# Markdownテスト

## 概要
誰が作っても楽に、いい感じに社内ドキュメントが作れるようにしたい人生だった  

## つかいかた
れぽじとりくろーんして使ってね
- PDF生成したいとき  
```
pandoc sample.md -o sample.pdf --template=template_custom.latex --pdf-engine=xelatex --from markdown+raw_tex --columns=140 --highlight-style=pygments --lua-filter=filter.lua
```
- html生成したいとき  
```
pandoc sample.md --standalone --embed-resources --number-sections --lua-filter=filter.lua --include-in-header=adjust_CSSRev.html -o output/sample.html
```
## さんこうにしたさいと
[Github使いかたサイト](https://www.kagoya.jp/howto/it-glossary/develop/howtousegithub/)

#Pandoc テンプレート
[Pandocテンプレート：デフォルトのやつを使うべきか否か](https://zenn.dev/sky_y/articles/pandoc-default-template-or-not)

