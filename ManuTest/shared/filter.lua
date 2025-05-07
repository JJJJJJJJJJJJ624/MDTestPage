-- filter.lua
-- Pandoc Lua フィルタ：LaTeXマクロ → HTML変換（画像・改行・コード・makecell対応）

-- ----------------------------
-- ユーティリティ関数
-- ----------------------------
local function clean_path(s)
  local t = s:match("^%s*(.-)%s*$")
  return t:gsub("[{}]", "")
end

local function handle_codeblockbox(txt)
  local content = txt:match("\\begin{CodeBlockBox}([%s%S]-)\\end{CodeBlockBox}")
  if content then
    local clean = content:gsub("^%s*\n?", ""):gsub("\n?%s*$", "")
    return pandoc.CodeBlock(clean)
  end
  return nil
end

local function handle_makecell(txt)
  local content = txt:match("\\makecell%{(.-)%}")
  if content then
    local html = content:gsub("\\\\", "<br>")
    return pandoc.RawInline("html", html)
  end
  return nil
end

local function wrap_single_image(path)
  local p = clean_path(path)
  return pandoc.Image({}, p, "", pandoc.Attr("", {"macro-singleimage"}, {}))
end

local function wrap_image_row(list, align)
  local imgs = {}
  for _, raw in ipairs(list) do
    local p = clean_path(raw)
    table.insert(imgs,
      pandoc.Image({}, p, "", pandoc.Attr("", {"macro-insertimagerow"}, {}))
    )
  end
  return pandoc.Div(imgs, pandoc.Attr("", {"macro-insertimagerow", "img-"..align}, {}))
end

-- ----------------------------
-- インライン処理
-- ----------------------------
function RawInline(elem)
  if elem.format ~= "tex" or not FORMAT:match("html") then
    return nil
  end
  local txt = elem.text

  -- \SingleImage{…}
  local single = txt:match("\\SingleImage%{(.-)%}")
  if single then
    return wrap_single_image(single)
  end

  -- \textbackslash{} → "\"
  if txt:match("\\textbackslash") then
    return pandoc.Str("\\")
  end

  -- \makecell{… \\ …}
  local makecell = handle_makecell(txt)
  if makecell then return makecell end

  -- \newpage や \clearpage → 改ページ div
  if txt:match("\\newpage") or txt:match("\\clearpage") then
    return pandoc.RawInline("html",
      '<div class="macro-newpage" style="page-break-after:always;"></div>'
    )
  end

  return nil
end

-- ----------------------------
-- ブロック処理
-- ----------------------------
function RawBlock(elem)
  if elem.format ~= "tex" or not FORMAT:match("html") then
    return nil
  end
  local txt = elem.text

  -- CodeBlockBox
  local codebox = handle_codeblockbox(txt)
  if codebox then return codebox end

  -- \SingleImage{…}（行頭）
  local single = txt:match("\\SingleImage%{(.-)%}")
  if single then
    return pandoc.Para({ wrap_single_image(single) })
  end

  -- \InsertImageRow{{…}}
  local row = txt:match("\\InsertImageRow%{%{(.-)%}%}")
  if row then
    local parts = {}
    for item in row:gmatch("([^,}]+)") do
      table.insert(parts, item)
    end
    return wrap_image_row(parts, "center") -- 中央寄せにしたければ "center"
  end

  -- \section{…} → h1
  local sec = txt:match("\\section%{(.-)%}")
  if sec then
    return pandoc.Header(1, pandoc.Str(sec))
  end

  -- \subsection{…} → h2
  local sub = txt:match("\\subsection%{(.-)%}")
  if sub then
    return pandoc.Header(2, pandoc.Str(sub))
  end

  -- 環境系（center / flushleft / flushright）
  local env, content = txt:match("\\begin%{(center|flushright|flushleft)%}([%s%S]-)\\end%{%1%}")
  if env then
    local align = ({center="center", flushright="right", flushleft="left"})[env]
    return pandoc.RawBlock("html", '<div style="text-align:'..align..';">'..content..'</div>')
  end

  return nil
end
