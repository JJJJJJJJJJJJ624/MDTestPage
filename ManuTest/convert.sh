#!/usr/bin/env bash
# convert.sh  ─ manuals/*/ 内の最新版 .md を PDF & HTML へ変換
# 生成物は output/html/, output/pdf/ に集約（旧版は出力しない）

set -euo pipefail
cd "$(dirname "$0")"            # ← スクリプトを置いたディレクトリを基準にする

# 出力ディレクトリを準備
mkdir -p output/html output/pdf

# ------------------------------------------
# 1. manuals/*/ を走査して最新版だけ選択
# ------------------------------------------
for dir in manuals/*/ ; do
  [[ -d "$dir" ]] || continue            # 念のため

  manual_name=$(basename "$dir")         # 例: manual1
  # 最新版 .md を名前順 (ver ソート) で一番後ろを取得
  latest_md=$(ls "$dir"/*.md 2>/dev/null | sort -V | tail -n 1) || true

  # .md が無いディレクトリはスキップ
  [[ -f "$latest_md" ]] || continue

  # 出力ファイル名
  html_out="output/html/${manual_name}.html"
  pdf_out="output/pdf/${manual_name}.pdf"

  # ----------------------------------------
  # 2. HTML 生成（更新が必要なら作る）
  # ----------------------------------------
  if [[ ! -f "$html_out" || "$latest_md" -nt "$html_out" ]]; then
    pandoc "$latest_md" \
      --from markdown \
      --to html5 \
      --resource-path="$dir" \
      --standalone \
      --output="$html_out"
    echo "  HTML 生成: $html_out"
  fi

  # ----------------------------------------
  # 3. PDF 生成（更新が必要なら作る）
  # ----------------------------------------
  if [[ ! -f "$pdf_out" || "$latest_md" -nt "$pdf_out" ]]; then
    pandoc "$latest_md" \
      --from markdown \
      --template=shared/template.tex \
      --lua-filter=shared/filter.lua \
      --resource-path="$dir" \
      --pdf-engine=xelatex \
      --output="$pdf_out"
    echo "  PDF 生成:  $pdf_out"
  fi
done

# ------------------------------------------
# 4. 簡易目次 (index.html) 更新
# ------------------------------------------
index_html="output/html/index.html"
{
  echo "<h1>Manuals – Latest Versions</h1><ul>"
  for html in output/html/*.html ; do
    file=$(basename "$html")
    [[ "$file" == "index.html" ]] && continue
    name="${file%.html}"
    echo "  <li><a href=\"$file\">$name</a></li>"
  done
  echo "</ul>"
} > "$index_html"

echo "=== 完了: 最新版を output/ に出力しました ==="
