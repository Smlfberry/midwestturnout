# PROJECT_NOTES.md — midwestturnout

> Living notes file for Sam's UChicago capstone. Read this first at the start of every Claude session — it's the cheapest way to load context.

_Last updated: 2026-05-01_

---

## What this project is

**Title:** Midwest Voter Turnout Study — *Who Votes, and Why Some Counties Beat the Odds*
**Author:** Sam Berry, University of Chicago, Crown Family School of Social Work, Policy, and Practice (2026 capstone)
**Partner:** Chicago Lawyers' Committee for Civil Rights (CLC) — extends prior descriptive needs assessment Sam did for them
**GitHub:** https://github.com/Smlfberry/midwestturnout

**One-line pitch:** A county-level OLS model of 2024 general election turnout across IL, IN, OH, WI, MI, using residuals to flag over- and under-performing counties — followed by qualitative case studies of six counties to investigate *why*.

**Scale:** 5 states · 437 counties · 6 case studies · 4 models · 12 predictors (Model 4)

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

The analysis builds up four nested OLS models. Each adds variables to its predecessor; comparing across them shows which findings are robust and which are model-spec artifacts.

**Model 1** — original CLC-derived structural predictors (5 variables):
- % Bachelor's+ (B15003)
- % Households with internet access (B28002)
- % Limited English proficiency (B16004)
- % With a disability (B18101)
- % Below poverty line (B17001)

**Model 2** — Model 1 + lower-tail education and racial composition (7 variables):
- % No high school diploma (B15003) — lower-tail educational disadvantage
- % Black or African American (B02001) — racial composition / suppression exposure

**Model 3** — Model 2 + state fixed effects (7 substantive predictors + 4 state dummies). Adjusts case identification for state-level institutional context (registration rules, ballot access, party competition).

**Model 4** — full comprehensive specification (12 predictors + state FE):
- % Hispanic / Latino (B03003)
- % American Indian / Alaska Native (B02001)
- % Age 18–24 (B01001) — captures college-town age structure
- % Age 65+ (B01001) — captures retirement-aged share

**Outcome:** Turnout rate, 2024 general election, denominator = **CVAP** (Citizen Voting Age Population, ACS Special Tabulation).

Residuals from **Model 4** drive case selection. Earlier models (1–3) are presented as a methodological progression showing how adding state context and demographic detail shifts which counties stand out.

---

## The six case-study counties

Selected from Model 4 residuals. The selection picks **one extreme + one moderate** from each tail, rather than just the two most extreme cases — this lets the analysis show that the pattern holds beyond just outliers. The two middle counties sit near the median rank with residuals close to zero.

| Tier            | County        | State     | Turnout | Predicted (m4) | Residual (m4) | Rank (m4) |
| --------------- | ------------- | --------- | ------- | -------------- | ------------- | --------- |
| Over-performer  | Jasper        | Illinois  | 77.7%   | 66.3%          | +11.4 pp      | 437 (top) |
| Over-performer  | Martin        | Indiana   | 66.1%   | 57.4%          | +8.7 pp       | 434       |
| As-expected     | Rock Island   | Illinois  | 61.1%   | 61.0%          | ≈+0.1 pp      | 214       |
| As-expected     | Rusk          | Wisconsin | 73.6%   | 73.6%          | ≈+0.1 pp      | 212       |
| Under-performer | Lawrence      | Illinois  | 50.9%   | 57.5%          | −6.6 pp       | 7         |
| Under-performer | Gogebic       | Michigan  | 70.3%   | 79.7%          | −9.4 pp       | 3         |

**Note on excluded counties:** the two most extreme underperformers in Model 4 — Noble OH (rank 1) and Gratiot MI (rank 5) — were excluded from case selection because both host substantial state correctional facilities (Noble Correctional Institution; Mid-Michigan Correctional Facility). Their incarcerated populations inflate the CVAP denominator while being disenfranchised from voting under state law, mechanically depressing the turnout rate. This denominator artifact is discussed as a measurement caveat in the appendix.

**Note on prior selection:** an earlier round of case-study work used a different 6 (Montmorency MI, Trempealeau WI, Clinton OH, DeKalb IL, Brown IL, Vanderburgh IN) drawn from Model 1 residuals. After expanding to Model 4 (adding state FE, age, and corrected race variables), several of those original cases attenuated or shifted category, and the case selection was refreshed. Original-six analytic notes preserved in screenshots; not used in current write-up.

---

## Data

- **Predictors:** 2024 ACS 5-Year estimates, retrieved via `tidycensus`
  - Education / language / disability / internet — original CLC pull
  - Poverty — table B17001
  - Hispanic / Latino — table B03003 (corrected; earlier extract was constant-100 bug)
  - American Indian / Alaska Native — table B02001
  - Age structure (18–24, 65+) — table B01001
- **Turnout numerators:** State election commissions (IL, IN, OH, WI, MI)
- **Turnout denominator:** CVAP Special Tabulation
- **Merge key:** County GEOID
- **Cached data objects (in `data/`):**
  - `df_pct.rds` — base feature dataset (44 cols after model4 update)
  - `df_pct_with_predictions.rds` — same dataset + predicted/residual/rank for all 4 models (used by website pages)
  - `model1.rds`, `model2.rds`, `model3.rds`, `model4.rds` — fitted lm objects
  - `selected_counties.rds` / `.csv` — the 6 case studies subset
  - Various comparison CSVs for residual/coefficient/fit comparison
- **Data pipeline:** `update_data_new.R` in the Capstone folder pulls ACS, refits all four models, writes outputs to both `Capstone/data/` and `midwestturnout/data/`. Re-run that script whenever spec or input changes.

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

**Picking up here (paused 2026-05-01):**
- Model framework expanded to 4 specs (m1 → m2 → m3 with state FE → m4 with age + corrected race vars)
- Case selection refreshed to new 6 counties drawn from Model 4 residuals
- Website data layer fully updated (`midwestturnout/data/` has all 4 models + selected_counties)
- [ ] Update `index.Rmd` — hero scatter tier mappings, 6 county-cards HTML, model narrative, data sources table
- [ ] Update `model.Rmd` — major rework: show progression across all 4 models (Option A1)
- [ ] Update `case-studies.Rmd` — replace structural elements (cards, predictor charts, setup chunk) for new 6; qualitative analysis text remains pending Sam's research on the new counties
- [ ] Audit / update `synthesis.Rmd`, `explore.Rmd`, `descriptive.Rmd`, `about.Rmd` for old county references
- [ ] Knit + visually verify each page after edits
- Suggested order: PROJECT_NOTES → index → model → about → synthesis/explore/descriptive → case-studies (last, blocks on qual research)

---

## How to use this file

**Sam:** at the start of each Claude session, just say *"read PROJECT_NOTES.md"* — that's enough for Claude to load all of the above without crawling the whole project. Cheap on usage, fast to orient.

**Claude:** keep this file accurate. When a meaningful decision gets made (model spec, file added, page restructured, design choice locked in), update the relevant section. When a session ends with work in progress, note it under "Open questions / what's next."
