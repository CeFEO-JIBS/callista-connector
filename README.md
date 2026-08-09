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

## Brand assets

**The site is dark**, and matched to the connector's own surfaces (`src/theme.ts` in
`CeFEO-JIBS/wifu-mcp-connector`). A reader crosses between the two mid-install — this
site, then `mcp.familybusiness.se/callista` to sign in — so they have to look like one
product. Change the palette in one place and change it in the other.

The deeper reason is the lockup itself: it is chrome artwork on a transparent background.
On white it has almost no edge contrast and reads as a grey smudge, and the mark's own
field is near-black. Dark is what it was drawn for.

| token | value | use |
|---|---|---|
| `--ground` | `#0D1520` | page |
| `--panel` | `#16212F` | cards |
| `--raised` | `#1D2A3A` | code, inputs |
| `--line` | `#27384E` | borders |
| `--text` | `#E7EDF5` | body copy |
| `--muted` | `#93A6BC` | secondary text |
| `--cyan` | `#309ABE` | WIFU accent |
| `--lift` | `#4FB8DA` | links, hover |
| `--navy` | `#22416C` | WIFU primary, as a deep fill |

The contrast constraint from the brand notes **inverts** on this ground, usefully:
`#309ABE` is ~3.1:1 on white and barred from body copy there, but clears 7:1 here. It can
carry text as well as rules. Do not carry that permission back to a light surface.

Images are derived from the master lockup by script — a resize, and a square crop taken
at the measured alpha bounding box. Nothing is redrawn. `logo.png` (640w) with
`logo@2x.png` for the header, `mark.png` plus `favicon.ico` / `favicon-32.png` /
`favicon-180.png` for icons. The 360 KB master is deliberately not shipped.

**One slot still open:** `fonts/` — `roboto-400.woff2`, `roboto-500.woff2`,
`roboto-condensed-700.woff2`, self-hosted. The `@font-face` rules already point at them;
until the files land the stacks fall back to Arial Narrow / system-ui, so nothing is
blocked on the drop.

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
