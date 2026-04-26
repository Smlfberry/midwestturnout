# PROJECT_NOTES.md — midwestturnout

> Living notes file for Sam's UChicago capstone. Read this first at the start of every Claude session — it's the cheapest way to load context.

_Last updated: 2026-04-25_

---

## What this project is

**Title:** Midwest Voter Turnout Study — *Who Votes, and Why Some Counties Beat the Odds*
**Author:** Sam Berry, University of Chicago, Crown Family School of Social Work, Policy, and Practice (2026 capstone)
**Partner:** Chicago Lawyers' Committee for Civil Rights (CLC) — extends prior descriptive needs assessment Sam did for them
**GitHub:** https://github.com/Smlfberry/midwestturnout

**One-line pitch:** A county-level OLS model of 2024 general election turnout across IL, IN, OH, WI, MI, using residuals to flag over- and under-performing counties — followed by qualitative case studies of six counties to investigate *why*.

**Scale:** 5 states · 437 counties · 6 case studies · 2 models · 7 predictors (Model 2)

---

## The deliverable

An **R Markdown website** (`rmarkdown::render_site()`), output to `docs/`.

### Site map (from `_site.yml`)

| Nav label    | File                | Purpose                                                        |
| ------------ | ------------------- | -------------------------------------------------------------- |
| Overview     | `index.Rmd`         | Landing page — pitch, six counties, data sources, navigation   |
| Background   | `descriptive.Rmd`   | Prior CLC descriptive findings, choropleths, demographic gaps  |
| The Model    | `model.Rmd`         | Model spec, coefficient tables, fit stats, residual distribution |
| Case Studies | `case-studies.Rmd`  | Qualitative deep-dive on each of the 6 counties                 |
| Synthesis    | `synthesis.Rmd`     | Cross-case patterns, institutional access argument, CLC implications |
| Explore      | `explore.Rmd`       | Interactive tools for the full 437-county dataset               |
| About        | `about.Rmd`         | About / methods / acknowledgments                               |

Theme: `flatly` (Bootswatch, via `html_document`) with `custom.css` overriding.

---

## Models

**Model 1** — five structural ACS predictors:
- % Bachelor's+ (B15003)
- % Households with internet access (B28002)
- % Limited English proficiency (B16004)
- % With a disability (B18101)
- % Below poverty line (B17001)

**Model 2** — Model 1 + two predictors as a theoretically motivated robustness check informed by prior CLC findings:
- % No high school diploma (B15003) — lower-tail educational disadvantage
- % Black or African American (B02001) — racial composition / suppression exposure

**Outcome:** Turnout rate, 2024 general election, denominator = **CVAP** (Citizen Voting Age Population, ACS Special Tabulation).

Residuals from **Model 1** drive case selection.

---

## The six case-study counties

| Tier            | County             | State      | Turnout | Predicted | Residual  |
| --------------- | ------------------ | ---------- | ------- | --------- | --------- |
| Over-performer  | Montmorency        | Michigan   | 80.1%   | 63.8%     | +16.2 pp  |
| Over-performer  | Trempealeau        | Wisconsin  | 75.3%   | 60.9%     | +14.5 pp  |
| As-expected     | Clinton            | Ohio       | 65.7%   | 65.7%     | ≈0.0 pp   |
| As-expected     | DeKalb             | Illinois   | 63.2%   | 63.2%     | ≈0.0 pp   |
| Under-performer | Brown              | Illinois   | 47.8%   | 64.2%     | −16.4 pp  |
| Under-performer | Vanderburgh        | Indiana    | 54.3%   | 68.7%     | −14.5 pp  |

---

## Data

- **Predictors:** 2024 ACS 5-Year estimates, retrieved via `tidycensus`
- **Turnout numerators:** State election commissions (IL, IN, OH, WI, MI)
- **Turnout denominator:** CVAP Special Tabulation
- **Merge key:** County GEOID
- **Cached data object:** `data/df_pct.rds` (loaded in `index.Rmd` setup chunk)

---

## File map (top level)

```
midwestturnout/
├── _site.yml             # Site config (nav, theme, output dir)
├── index.Rmd             # Overview / landing
├── descriptive.Rmd       # Background page
├── model.Rmd             # Model spec & results
├── case-studies.Rmd      # 6-county qualitative
├── synthesis.Rmd         # Cross-case + implications
├── explore.Rmd           # Interactive data tools
├── about.Rmd             # About page
├── custom.css            # Site styling overrides
├── header.html           # Custom HTML head includes
├── data/
│   └── df_pct.rds        # Cached cleaned dataset
├── docs/                 # Rendered site output (rmarkdown::render_site)
├── figures/              # Saved figure outputs
├── README.md             # Currently a stub
└── midwestturnout.Rproj  # RStudio project file
```

---

## Conventions / decisions made so far

- **Building the site shell** is the current focus — content scaffolding, custom.css polish, navigation, hero/cards/callouts on the landing page.
- Landing page uses styled HTML blocks: `.site-hero`, `.county-grid > .county-card.{over|middle|under}`, `.callout`, `.method-tag`, `.section-label`, `.kicker`, `.dek`, `.byline`, `.site-footer`. Keep these classes consistent across pages.
- Setup chunks: `echo = FALSE, warning = FALSE, message = FALSE`. Prefer pre-computed objects from `df_pct.rds` over re-running heavy ACS pulls in chunks.
- `output_dir: "docs"` so the site can be served via GitHub Pages.

---

## Open questions / what's next

_(Update this section every session — it's the single most useful thing for picking up where we left off.)_

**Picking up here (paused 2026-04-25):**
- [ ] Replace filler/placeholder copy across the `.Rmd` pages with Sam's own writing
- [ ] Continue formatting edits to `custom.css` and the styled HTML blocks (hero, county cards, callouts, etc.)
- Suggested order when resuming: pick one page at a time, swap real text in, render the site (`rmarkdown::render_site()`), tweak CSS as issues surface.

---

## How to use this file

**Sam:** at the start of each Claude session, just say *"read PROJECT_NOTES.md"* — that's enough for Claude to load all of the above without crawling the whole project. Cheap on usage, fast to orient.

**Claude:** keep this file accurate. When a meaningful decision gets made (model spec, file added, page restructured, design choice locked in), update the relevant section. When a session ends with work in progress, note it under "Open questions / what's next."
