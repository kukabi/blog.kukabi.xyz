# Codebase Review Suggestions

## 1. Config Duplication / Conflicting Titles

`hugo.toml` and `config/_default/config.toml` both define `baseURL`, `languageCode`, and `title`, but with **different titles**:

- `hugo.toml:4` → `'Kutsal Kaan Bilgin (kukabi) - Blog'`
- `config/_default/config.toml:4` → `'blog.kukabi.xyz'`

Hugo merges these configs and `config/_default/` values win, so the longer title in `hugo.toml` never takes effect. **Fix:** consolidate everything into `config/_default/` and make `hugo.toml` minimal (just `theme` and `capitalizeListTitles`).

---

## 2. Leftover Theme Placeholder

`config/_default/config.toml:15`:
```toml
disqusShortname = "hugo-theme-stack"
```
This is the Stack theme's own example value. Since comments are disabled in `params.toml`, this should be cleared (`""`) or removed entirely.

---

## 3. Dead Code in Footer

`layouts/partials/footer/footer.html:1` defines `$ThemeVersion` but it's only used inside the commented-out `<!--section-->` block. The variable is dead code. Either restore the "Powered by" section or remove both:

```diff
- {{- $ThemeVersion := "3.30.0" -}}
  <footer class="site-footer">
      ...
-     <!--section class="powerby">...</section-->
  </footer>
```

---

## 4. Archetype Front Matter Inconsistency

`archetypes/default.md` uses TOML delimiters (`+++`), while all content files use YAML (`---`). Fix the archetype to match:

```diff
- +++
- date = '{{ .Date }}'
- draft = true
- title = '{{ replace .File.ContentBaseName "-" " " | title }}'
- +++
+ ---
+ date: '{{ .Date }}'
+ draft: true
+ title: '{{ replace .File.ContentBaseName "-" " " | title }}'
+ ---
```

---

## 5. Semantic HTML in `details.html`

`layouts/partials/article/components/details.html:44,54` uses `<header>` for categories and `<footer>` for translations. These are landmark elements with specific semantic meaning and shouldn't be repurposed for arbitrary grouping. Use `<div>` instead:

```diff
- <header class="article-category">
+ <div class="article-category">
      ...
- </header>
+ </div>

- <footer class="article-translations">
+ <div class="article-translations">
      ...
- </footer>
+ </div>
```

---

## 6. `build.sh` Has No Error Handling

If `hugo` fails mid-build, the script still exits 0 (success). Add `set -e` at the top so it fails fast on any error:

```diff
 #!/bin/bash
+set -e
 cd "${0%/*}" || exit
 rm -rf public
 rm -rf resources
 hugo --minify --gc
```

---

## Minor / Optional

- **`params.toml`**: ~70 lines of empty comment provider configs (`disqusjs`, `vssue`, `remark42`, `waline`, etc.) are noise if unused. Keep one as a reference template or move them to a separate reference doc.
- **`params.toml:59`**: `[opengraph.twitter]` has an empty `site` field — set it to your Twitter/X handle since it's already listed in the menu.
- **Article license**: `"Licensed under GPLv3"` is the default for all posts, but GPLv3 is a software license. For blog prose, a Creative Commons license (e.g. CC BY 4.0) is more appropriate.
- **`custom.scss:3`**: `--zh-font-family` (PingFang, Hiragino, etc.) is defined and included in `--base-font-family` even though the site is English-only (`hasCJKLanguage = false`). Harmless but unnecessary.
