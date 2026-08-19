# callista-connector

The public site for **Callista**, the WIFU library MCP connector.
Live at **https://callista.familybusiness.se**

Install guide, FAQ, contact, and the downloadable Callista skill. Static HTML, no
JavaScript; the only build step is `skill/build.sh`, which packages the skill.

## What is NOT here

- **The connector itself** lives in the private repo `CeFEO-JIBS/wifu-mcp-connector`
  and runs at `mcp.familybusiness.se/callista`. Editing this site does not touch the
  service, and deploying the service does not update this site.
- **The admin console** is served by the connector at `/admin-callista`, behind nginx
  basic auth. It is deliberately not here: GitHub Pages cannot do basic auth and cannot
  reach the database, so putting it here would mean cross-origin calls plus app-level
  sessions — replacing a gate that already works with one the service has no code for.

## The skill

`skill/callista-connector/SKILL.md` is the source; `callista-connector.zip` at the repo root
is the built artifact the install page hands out. Rebuild after any edit:

```sh
./skill/build.sh
```

Both are committed. The zip is a build output, but GitHub Pages serves files, not build
steps, so the artifact has to be in the tree for the download link to resolve.

**The archive's root must be the skill folder** — `callista-connector/SKILL.md`, not a bare
`SKILL.md` and not `skill/callista-connector/SKILL.md`. claude.ai's uploader rejects the
other two shapes. That is the whole reason `build.sh` does a `cd` before zipping.

Frontmatter is restricted to `name` and `description`. The upload path validates against
the Agent Skills spec's six permitted fields and fails hard on anything else, so do not add
convenience keys.

**There is no one-click install, and the page says so.** Claude has no install-from-a-URL
for skills: a skill is a file the user uploads to their own account under Customize →
Skills. A download button is the closest thing that exists, and the alternative — a
`claude-cli://` deep link — only pre-fills a prompt in a local Claude Code session, which
is not the audience this site serves. If Anthropic ships an install URL, the button on
`install.html#skill` is the one place to change.

The skill is not a substitute for the connector and does not carry a copy of the library. It
instructs Claude to check for the connector's tools and to stop if they are absent, so a
user who installs only the skill gets a refusal rather than a fluent invention.

## Serving

GitHub Pages, **Source = `main` / root**. `.nojekyll` is present so files are served
as-is. `CNAME` carries the custom domain.

DNS at one.com: `callista` is a **CNAME → `cefeo-jibs.github.io`**, not an A record.

Verification after any DNS or Pages change is a **200**, not merely a `server: GitHub.com`
header — a 404 carrying that header means Pages is enabled with nothing published,
normally because Source is set to *GitHub Actions* on a repo with no workflow. Fix it in
Settings → Pages → Deploy from a branch → `main` → `/ (root)`.

## Brand assets

**The site wears WIFU's livery**: the WIFU navy `#22416C` and the WIFU accent cyan
`#309ABE`, arranged the way wifu.de arranges them — white ground, navy uppercase condensed
headings each with a short cyan rule beneath, navy pill buttons, navy full-bleed bands top
and bottom. A reader arriving from wifu.de should recognise where the material comes from.

**The header and footer are navy for a reason, and it is not decoration.** The Callista
lockup is chrome artwork on a transparent background: on white it has almost no edge
contrast and reads as a grey smudge, and the mark's own field is near-black. It was drawn
for a dark ground. The navy bands give it that ground while the page itself stays light
like wifu.de. **Do not move the lockup onto the white.** If a light-ground lockup is ever
drawn, that constraint lifts and the bands become a free choice again.

| token | value | use |
|---|---|---|
| `--ground` | `#FFFFFF` | page |
| `--surface` | `#F2F5F8` | cards, code |
| `--line` | `#D8E0EA` | borders |
| `--text` | `#16202E` | body copy |
| `--muted` | `#56657A` | secondary text |
| `--navy` | `#22416C` | WIFU primary — headings, bands, buttons |
| `--navy-lo` | `#1A3357` | hover on navy |
| `--cyan` | `#309ABE` | WIFU accent — rules, fills, chips |
| `--link` | `#1B5E7E` | links |
| `--on-navy` | `#C6D5E8` | copy on a navy band |
| `--on-navy-link` | `#8FD3EC` | links on a navy band |

**`#309ABE` cannot carry body copy here.** It is ~3.2:1 on white — fine for rules, fills,
chips and borders, barred from text. That is why `--link` exists: the same hue darkened to
7.1:1. On the earlier dark ground the same cyan cleared 7:1 and could carry text; that
permission does not survive the move to white, and the ratio is the reason, not taste.
Every pair in use is AA or better — body 16.4:1, secondary 5.9:1, headings 10.3:1, links
7.1:1, white on navy 10.3:1, footer copy 6.9:1, footer links 6.2:1, step numerals 5.1:1.

**The connector's own surfaces are still dark** (`src/theme.ts` in
`CeFEO-JIBS/wifu-mcp-connector`), and a reader crosses from this site to
`mcp.familybusiness.se/callista` to sign in. The two no longer match. Either restyle the
connector's sign-in to this palette, or accept the seam — but know it is there.

Images are derived from the master lockup by script — a resize, and a square crop taken
at the measured alpha bounding box. Nothing is redrawn. `logo.png` (640w) with
`logo@2x.png` for the header, `mark.png` plus `favicon.ico` / `favicon-32.png` /
`favicon-180.png` for icons. The 360 KB master is deliberately not shipped.

**One slot still open:** `fonts/` — `roboto-400.woff2`, `roboto-500.woff2`,
`roboto-condensed-700.woff2`, self-hosted. The `@font-face` rules already point at them;
until the files land the stacks fall back to Arial Narrow / system-ui, so nothing is
blocked on the drop.

**The WIFU logo does not go in the site header, and the colours do not change that.** This
is a CeFEO-operated domain. Wearing WIFU's palette already pushes towards "published by
WIFU", which it is not — a WIFU mark up there would settle the impression. WIFU is credited
in the footer of every page and linked throughout, and the footer wording is what carries
the distinction; do not trim it.

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
