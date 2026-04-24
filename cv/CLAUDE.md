# CV Modernization Project — Derek C. Briggs

## Project owner
Derek C. Briggs, Professor of Research & Evaluation Methodology, School of Education,
University of Colorado Boulder. Also: Associate Dean of Faculty; Director, CADRE.
- `derek.briggs@colorado.edu` (professional) · `derekcbriggs@gmail.com` (personal)
- GitHub: https://derekcbriggs.github.io/
- Google Scholar: https://scholar.google.com/citations?user=FsarJmwAAAAJ&hl=en
- ORCID: 0000-0003-1628-4661 (confirmed active, 52 works, 48 with DOIs)

## Project goal
Modernize a 22-page academic CV (last restyled ~20 years ago) into a polished,
programmatically-maintained document that:

1. Provides both a qualitative and quantitative picture of scholarly contributions
2. Enables easy annual tracking for CU merit review
3. Makes written work and oral presentations easy to find and access via live links
4. Is visually appealing with generous white space — not a citation wall

## Key features (core design, not optional)

These are intentional capabilities of the CV system. Treat them as load-bearing
design decisions — don't remove or replace them without discussion.

1. **Dual-view publications with topic tags.** Each entry in `publications.yaml`
   carries a `tags: [...]` list (e.g., `[vertical scaling, growth modeling]`).
   The Publications section of the CV renders two views — **By Type** (default,
   matches traditional CV grouping) and **By Topic** (alphabetical sections per
   tag) — with a button pair that toggles between them on the HTML page. Papers
   with multiple tags appear once per tag in the topic view (intentional, since
   many works sit at the intersection of areas). Print/PDF always uses the
   by-type view. Implementation: `render_by_topic()` in `cv.qmd` setup chunk +
   inline `<script>` at end of `cv.qmd` + `.pub-view-toggle` / `.pub-view` in
   `cv.css`. See the "Publications tagging + dual-view toggle" entry under the
   build log for implementation details.

2. **Curated "Selected Publications" section.** A `featured: true` flag in
   `publications.yaml` surfaces a small set of signature works (currently 7)
   in a "Selected Publications" section at the top of the Publications area
   in the by-type view. Entries still appear in their normal category lists
   below — featuring is additive, not exclusive. Reader gets a curated entry
   point into 105+ publications without reading the whole list. Intentionally
   capped at ~5–7 works so the section stays curatorial rather than
   inflationary. No annotations on featured entries — the selection itself is
   the signal; per-work commentary belongs on the research/teaching pages of
   the main website. Implementation: `render_featured()` helper in `cv.qmd`
   setup chunk; section appears only inside `::: {.pub-view data-view="by-type"}`.

3. **Auto-computed section counts.** Every h3 heading under Publications and
   Presentations shows an entry count in parentheses (e.g., "Refereed Journal
   Articles (38)") derived from the YAML data files at render time. h-index is
   the only manually-maintained metric; everything else refreshes when the data
   files change.

4. **HTML-first with browser Print-to-PDF.** Single `cv.qmd` source produces both
   a live web CV and a high-fidelity PDF via browser print. No LaTeX, no
   weasyprint, no Python dependency. `@media print` and `@page` rules in
   `cv.css` handle the print layout.

5. **Multi-page structure.** `cv.qmd` renders the main CV; `presentations-full.qmd`
   renders the complete 86-entry conference history grouped by year. The CV's
   Conference Presentations section links to the full list. Both use the same
   `cv.css`.

## Authoring system decision
**Quarto (HTML primary, PDF via browser Print-to-PDF) — confirmed 2026-04-22.**
- Single `cv.qmd` source renders an HTML version (hosted at `/cv/cv.html`, live
  links, navigable, always current)
- PDF is produced manually by opening the rendered HTML in a browser and choosing
  File → Print → Save as PDF. Saved as `cv/cv.pdf` next to the source.
- The `@page` and `@media print` rules in `cv.css` drive PDF layout — browsers
  implement the same CSS Paged Media spec weasyprint does
- **No weasyprint/LaTeX/Python dependency.** Original plan was weasyprint, but
  that requires Homebrew + Pango on macOS (Derek has neither), so we dropped it.
  Revisit only if PDF generation needs to be automated (e.g., CI build).
- Requires Quarto ≥ 1.3
- Derek codes in R; all data wrangling will be in R (tibbles, readr, etc.)
- Reference: Cynthia Huang's approach — https://www.cynthiahqy.com/posts/cv-html-pdf/

## Content inventory (from existing CV)

| Category | Count |
|---|---|
| Refereed journal articles | 38 |
| Refereed book chapters | 18 |
| Books | 1 (Routledge, 2021) |
| Published commentaries & reviews | 16 |
| Reports & working papers | 25 |
| Invited talks & keynotes | 26 |
| Conference presentations | 61 (+ 39 in a separate "papers" section = ~100 total) |
| Blogs, interviews, podcasts | 5 |
| Works in progress | 2 |
| PhD students graduated | 15 (2008–2025) |
| Current advisory board memberships | 20+ |

## Verified metrics (April 2026)
- h-index: **34** (Google Scholar, confirmed by Derek 2026-04-22; auto-displayed
  under Publications heading; update `h_index <- 34L` and `metrics_date` in
  `cv.qmd` setup chunk once/year)
- Total grants: **$7.62M** across 21 projects ($2.38M as PI, $5.25M as Co-PI;
  auto-computed from `data/grants.csv`, displayed as "$7M+" in context)
- Annual citations 2016–2024: sustained 389–464/year (reference only; not
  surfaced on CV)
- Total citations on Scholar: 6,305 as of April 2026 (reference only; we
  elected to display h-index rather than raw citations on the CV)

## Key honors to surface prominently
- Elected to the National Academy of Education, 2025
- AERA Fellow, 2023
- NCME President, 2021–22
- AERA Division D Award for Significant Contribution, 2024
- Editor, Educational Measurement: Issues & Practice, 2013-2016
- NCME Annual Award for Contributions to Theory and Practice, 2012
- NAEd/Spencer Postdoctoral Fellowship, 2007–2009

## Structural diagnosis of existing CV

### Problems to fix
1. **No year-anchored navigation** — not helpful for merit review; reader must scan everything
   manually to find activity in a given year
2. **No metrics/dashboard header** — most impressive credentials are buried on page 2+
3. **Conference section is bloated and redundant** — two separate sections
   ("Professional Conference Papers" + "Conference Presentations") covering the same
   activity type, totaling ~100 entries back to 1999
4. **Grants are listed as prose paragraphs** — no totals, no role column, no active/closed
   distinction, no table structure
5. **PhD students listed as a paragraph** — no current positions, no quick count
6. **URLs in PDF are plain text** — not functional hyperlinks; DOIs typed out inline

### Things that work — keep them
- Publication category hierarchy (Books / Refereed Articles / Chapters / Reports) is clean
- Professional experience section is well-structured
- Service sections are comprehensive

## Proposed new section architecture

```
[Dashboard header]          <- NEW: name, title, affiliations, honor chips, metrics row
[Research expertise]        <- keep (brief keyword list)
[Professional experience]   <- keep
[Education]                 <- keep
[Honors & awards]           <- keep, add year anchors
[Grants]                    <- RESTRUCTURE: table with funder/title/role/amount/dates/status
[Teaching]                  <- keep courses; restructure PhD students as table with positions
[Publications]              <- keep category hierarchy; add DOI hyperlinks; year anchors
  - Books
  - Refereed journal articles
  - Refereed book chapters
  - Reports & working papers
  - Commentaries & reviews
  - Blogs, interviews, podcasts
  - Works in progress
[Presentations]             <- RESTRUCTURE: merge two conference sections; keep invited talks
                               separate; cap conference list at last 10 years in full, note
                               count for prior years
[Professional service]      <- keep; tighten advisory boards into table
```

## Dashboard header (final design, 2026-04-23)

The dashboard now contains only the name, titles, contact links, and honor
chips — no metric row. Counts are surfaced in context instead:

- **h-index** appears as a small muted note directly under `## Publications`,
  rendered via `.section-meta` CSS class (also carries the "(Google Scholar,
  April 2026)" date stamp).
- **Per-subsection counts** appear in parentheses on each h3 heading, e.g.
  `### Refereed Journal Articles (38)`. These are computed at render time from
  the YAML data files, so they stay current automatically.
- **Grant total** is not duplicated in the header — the Grants section already
  renders a totals footer below its table.
- **PhD student count** is not duplicated — the students table is self-evident.

Header background: `#1a3050`. Honor chips: semi-transparent white pills.

## Build roadmap (4 stages)

### Stage 1 — YAML header + CSS skeleton ✅ (2026-04-22)
- `cv.qmd` with HTML format block, theme: none, css: cv.css
- `cv.css` with: CSS custom properties, dashboard header (`#1a3050`), honor chips,
  6-metric row, year-anchor styles, tables, responsive breakpoint at 640px,
  `@page` + `@media print` overrides for browser Print-to-PDF
- "Download PDF" is a static markdown link to `cv.pdf` (hidden in print output
  via `.pdf-download` class), pointing to the manually-saved PDF next to `cv.qmd`

### Publications tagging + dual-view toggle ✅ (2026-04-23)
- Each entry in `publications.yaml` has an optional `tags: [...]` field.
  19 distinct tags currently in use (vertical scaling, growth modeling,
  causal inference, learning progressions, item response theory, rasch models,
  history of measurement, educational measurement, large-scale assessment,
  assessment policy, diagnostic assessment, value-added modeling,
  teacher evaluation, test preparation, meta-analysis, validity,
  formative assessment, science education, fairness).
- 104 of 105 publications tagged (the 2013 *Current Zoology* paper is
  intentionally untagged — co-authored biology paper, not Derek's research
  domain).
- Publications section on the main CV shows a **By Type / By Topic**
  button pair. Clicking toggles visibility between two pre-rendered views;
  a small inline `<script>` at the end of `cv.qmd` handles the swap via the
  `hidden` HTML attribute.
- Print CSS hides the toggle and the topic view — printed output always
  uses the by-type grouping.
- Papers with multiple tags appear once per tag in the topic view
  (intentional duplication for accuracy).
- Rendering via `render_by_topic()` helper in `cv.qmd` setup chunk.
  Tags rendered alphabetically with title-casing (preserving lowercase
  minor words like "of", "and").

### Stage 2 — Publications data structure ✅ (2026-04-22)
- `data/publications.yaml` is source of truth (105 entries across 7 categories)
- R helpers in `cv.qmd` setup chunk render each category reverse-chronologically
  in APA style; `render_category("...")` in each subsection
- DOI/URL links rendered small and muted via `.pub-doi` class
- **Uniform styling across all entries.** No bolding, no annotations, no signal-
  work emphasis. The `annotation` and `highlight` fields were removed from the
  schema on 2026-04-22. Rationale: per-work commentary belongs in the research/
  teaching sections of the main website, not on the CV page.

### Layout decisions (2026-04-22)
- Quarto's auto-generated title block is hidden via CSS (`#title-block-header`,
  `.quarto-title-block`). The `.dashboard` at the top of `cv.qmd` acts as the
  header. `title:` in YAML is kept for the browser tab / SEO metadata only.
- TOC ("Contents") is a **sticky right-sidebar in a two-column grid** on
  screens ≥ 1100px wide, and fully hidden below that width and in print.
  Implemented as: `body` becomes a CSS grid (`1fr | 15rem`) at ≥ 1100px;
  `nav#TOC` spans all grid rows in column 2 and uses `position: sticky; top: 2rem`
  so it stays visible while the content scrolls. Body max-width is 78rem on
  wide screens (vs. 52rem narrow) so the content column fills ~58rem of
  usable width.
  Tradeoff: mobile/tablet users lose in-page navigation. Acceptable for a CV
  that's mostly read on desktop or printed.

### Stage 3 — Grants table + PhD students table ✅ (2026-04-22)
- `data/grants.csv`: 21 grants, columns funder/title/role/amount/start/end/status.
  Actual total: **$7.62M** ($2.38M as PI, $5.25M as Co-PI). The dashboard metric
  currently says "$5M+" — should probably be bumped to "$7M+" to match.
  **Status column** currently has "Closed" on every row because the PDF source has
  no grants active past 2024; once user adds an active grant, `render_grants`
  already handles it.
- `data/students.csv`: 15 students graduated 2008-2025, with empty `position`
  column for user to fill in. Rendering shows "—" for missing positions.
- R rendering via `render_grants()` and `render_students()` in `cv.qmd` setup
  chunk; uses `knitr::kable(format="html")` with table classes for CSS styling.
- Title column NOT truncated; CSS lets long titles wrap naturally with
  `vertical-align: top` on cells.

### Professional Service restructure ✅ (2026-04-23)
Reorganized into a **5-tier hierarchy** to make major field-shaping service
legible vs. routine professional citizenship:

1. **National & International Leadership** — NCME Executive Committee,
   at-large board, AERA/SREE program chairs, conference chair.
2. **Editorial Roles** — Editor (EMIP), Editorial Boards (current), Editorial
   Boards (past). Editorial board memberships were previously buried inside
   Advisory Boards; pulling them out makes both categories more scannable.
3. **Advisory Panels & Technical Committees** — state TACs and national
   panels. Current/Past kept as h4 subheads within one tier rather than
   two top-level sections.
4. **Institutional Service — University of Colorado Boulder** — Associate
   Dean, program chair, search committees, institutional taskforces.
5. **Manuscript Reviewing** — compact inline journal list (lowest
   differentiation, deliberately de-emphasized by placement and format).

**Plus** a brief one-line Professional Affiliations roster at the very end.

**Intentional trims** made during the restructure:
- Five near-identical "Chair of REM Search Committee" entries (2008--09,
  2011--12, 2013--14, 2014--15, 2016) rolled up into one line
  "Chair, REM Search Committees, 2008--2016 (multiple cycles)" — preserves
  the signal (chair role repeatedly held over a decade) without the visual
  wall of near-duplicates.
- The "REM Program Chair, 2008--2019" entry previously duplicated between
  Leadership Positions and University of Colorado is now listed only in
  Institutional Service.

### Stage 4 — Presentations restructure ✅ (2026-04-22)
- `data/presentations.yaml`: 113 entries (26 invited/keynote + 87 conference).
- Conference entries 2015+ (22) show on the main CV under the heading
  "Selected Conference Presentations". Below the section is a link to the
  full-list page.
- Conference entries pre-2015 (65) are deduplicated from the PDF's two prior
  sections ("Professional Conference Papers" + "Conference Presentations")
  and appear only on the full-list page.
- Rendering:
  - `render_presentations(category_name, year_min = NULL)` in `cv.qmd`
    handles the 2015+ filter for the main CV.
  - `render_by_year(category_name)` in `presentations-full.qmd` renders with
    year headings (`## 2025`, `## 2024`, ...) so the TOC shows years.
  - Format helpers (`esc`, `title_end`, `format_presentation`) are duplicated
    between the two files rather than sourced from a shared `.R` file —
    trading minor duplication for simplicity. If a third page is added,
    extract to `cv/_helpers.R`.
- Multi-page structure: `cv.qmd` → renders to `_site/cv/cv.html`;
  `presentations-full.qmd` → renders to `_site/cv/presentations-full.html`.
  Quarto picks up both via the site's `**/*.qmd` render glob.
- Link from CV to full list: `[See full list of conference presentations →]
  (presentations-full.html){.pdf-download}` — `.pdf-download` class hides
  it when printed, since a link is useless on paper.

## Technical notes
- Quarto version: use ≥ 1.3
- PDF engine: **none** — PDF is produced by opening the rendered HTML in a
  browser and using File → Print → Save as PDF. Save output as `cv/cv.pdf`.
- R packages likely needed: `readr`, `dplyr`, `glue`, `knitr`, `tibble`
- The `vitae` package is an option for PDF-only but is **not** the chosen approach here —
  we are doing HTML-first with browser-driven PDF for full goal coverage
- CSS variable strategy: use CSS custom properties for the color palette so switching the
  accent color (currently `#1a3050`) is a one-line change
- File structure suggestion:
  ```
  cv/
  ├── cv.qmd           # main source file
  ├── cv.css           # stylesheet (html + print)
  ├── data/
  │   ├── publications.bib   # or publications.yaml
  │   ├── grants.csv
  │   └── students.csv
  └── _quarto.yml      # project-level config (optional)
  ```

## Style preferences
- Derek's preferred R style: tidyverse (`dplyr`, `tibble`, `readr`, `glue`)
- No Python
- Technically precise; no sugar-coating; succinct answers first
- This is a living document — update frequency likely 1x/year for merit review,
  with occasional mid-year additions for new publications or talks