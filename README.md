# callista-connector

The public site for **Callista**, the WIFU library MCP connector.
Live at **https://callista.familybusiness.se**

Install guide, FAQ and contact. Static HTML, no build step, no JavaScript.

## What is NOT here

- **The connector itself** lives in the private repo `CeFEO-JIBS/wifu-mcp-connector`
  and runs at `mcp.familybusiness.se/callista`. Editing this site does not touch the
  service, and deploying the service does not update this site.
- **The admin console** is served by the connector at `/admin-callista`, behind nginx
  basic auth. It is deliberately not here: GitHub Pages cannot do basic auth and cannot
  reach the database, so putting it here would mean cross-origin calls plus app-level
  sessions — replacing a gate that already works with one the service has no code for.

## Serving

GitHub Pages, **Source = `main` / root**. `.nojekyll` is present so files are served
as-is. `CNAME` carries the custom domain.

DNS at one.com: `callista` is a **CNAME → `cefeo-jibs.github.io`**, not an A record.

Verification after any DNS or Pages change is a **200**, not merely a `server: GitHub.com`
header — a 404 carrying that header means Pages is enabled with nothing published,
normally because Source is set to *GitHub Actions* on a repo with no workflow. Fix it in
Settings → Pages → Deploy from a branch → `main` → `/ (root)`.

## Brand assets — two slots still open

Palette and type come from WIFU's own theme (`bergauf`), applied to a CeFEO-operated
surface:

| token | value | use |
|---|---|---|
| `--navy` | `#22416C` | all body copy, headings |
| `--cyan` | `#309ABE` | rules, fills, large headings **only** |
| `--tert` | `#3C6D9D` | secondary text |
| `--grey` | `#ECECEC` | borders, panels |
| `--mid`  | `#9B9B9B` | muted text |

`#309ABE` on white is ~3.1:1. Fine for large text, rules and fills; **not** for body
copy. Body stays navy or near-black. Do not "brighten" it.

**Still to drop in:**

1. `logo.svg` and `mark.svg` — the finalised Callista bubble mark and wordmark. The
   header currently renders a typographic wordmark; `styles.css` documents where the
   `<img>` goes.
2. `favicon.svg` — currently a **placeholder**: a drawn cyan bubble on navy, deliberately
   provisional. Replace with the drawn 32px favicon from the final set.
3. `fonts/` — `roboto-400.woff2`, `roboto-500.woff2`, `roboto-condensed-700.woff2`,
   self-hosted. The `@font-face` rules already point at them; until the files land the
   stacks fall back to Arial Narrow / system-ui, so nothing is blocked on the drop.

**The WIFU logo does not go in the site header.** This is a CeFEO-operated domain; a WIFU
mark up there reads as "published by WIFU", which it is not. WIFU is credited in the
footer and linked throughout.

## Corpus numbers

The figures on `index.html` (459 publications, 515 editions, 8,685 sections, 1,313
figures, 285 authors, 2007–2026) are **hardcoded**, with the count date shown beneath
them.

They are not fetched live. The connector does expose `/public-stats`, but it is on
`mcp.familybusiness.se` while this site is on GitHub Pages — a cross-origin call needing
a CORS header that the connector deliberately does not send. Genny gets away with a live
number because its stats endpoint is same-origin with its site; Callista's is not.

So: when the corpus is re-ingested, update the numbers **and the date** by hand. A stale
number with an honest date is fine; a stale number presented as current is not.
