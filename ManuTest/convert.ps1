# convert.ps1  – PowerShell 5 / 7 両対応
$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $baseDir
chcp 65001 > $null          # 文字化け対策（UTF‑8）

# 出力先ディレクトリ
New-Item -Force -ItemType Directory -Path "$baseDir\output\html" | Out-Null
New-Item -Force -ItemType Directory -Path "$baseDir\output\pdf"  | Out-Null

# manuals/* フォルダを走査
Get-ChildItem "$baseDir\manuals" -Directory | ForEach-Object {

    $manualName = $_.Name
    $manualPath = $_.FullName

    # 最新 .md
    $latest = Get-ChildItem $manualPath -Filter "*.md" |
              Sort-Object Name | Select-Object -Last 1
    if (-not $latest) {
        Write-Host "skip: No .md in $manualName"
        return
    }

    $mdName  = $latest.Name                        # ファイル名だけ
    $htmlOut = "$baseDir\output\html\$manualName.html"
    $pdfOut  = "$baseDir\output\pdf\$manualName.pdf"

    Push-Location $manualPath      # === manualX を作業ディレクトリに ===
    try {
        # ---------- HTML ----------
        if (-not (Test-Path $htmlOut) -or
            $latest.LastWriteTime -gt (Get-Item $htmlOut).LastWriteTime) {

            pandoc $mdName `
              --standalone --embed-resources --number-sections `
              --lua-filter="$baseDir\shared\filter.lua" `
              --include-in-header="$baseDir\shared\adjust_CSSRev.html" `
              -o $htmlOut
            Write-Host "   HTML : $htmlOut"
        }

        # ---------- PDF ----------
        if (-not (Test-Path $pdfOut) -or
            $latest.LastWriteTime -gt (Get-Item $pdfOut).LastWriteTime) {

            pandoc $mdName `
              --pdf-engine=xelatex `
              --template="$baseDir\shared\template_custom.latex" `
              --from markdown+raw_tex --columns=140 `
              --highlight-style=pygments `
              --lua-filter="$baseDir\shared\filter.lua" `
              --resource-path="$manualPath;$manualPath\img" `
              -o $pdfOut
            Write-Host "   PDF  : $pdfOut"
        }
    }
    finally {
        Pop-Location
    }
}

# 目次 index.html
$index = "$baseDir\output\html\index.html"
@(
  '<h1>Manuals</h1><ul>'
  (Get-ChildItem "$baseDir\output\html" -Filter "*.html" |
     Where-Object { $_.Name -ne "index.html" } |
     ForEach-Object {
        '  <li><a href="' + $_.Name + '">' + $_.BaseName + '</a></li>'
     })
  '</ul>'
) | Set-Content -Encoding UTF8 $index

Write-Host "`n=== Conversion finished successfully ==="
