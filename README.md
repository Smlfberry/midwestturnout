# What Demographics Can — and Can't — Explain

### A County-Level Analysis of Midwest Voter Turnout

Live site: [smlfberry.github.io/midwestturnout](https://smlfberry.github.io/midwestturnout)

This project examines county-level voter turnout inequality across five Midwestern states — Illinois, Indiana, Ohio, Wisconsin, and Michigan — using a predictive model to identify counties that perform above or below their structural expectations. The analysis pairs quantitative methods with qualitative case-study research to ananlyze the civic and institutional factors that may shape participation beyond what demographics predict.

The work builds on practicum research conducted with the Chicago Lawyers' Committee for Civil Rights (CLC) Midwest Voting Rights Program as part of their Midwest voting rights expansion.

---

## Reproducing the Site

### Requirements
- R (≥ 4.3)
- RStudio
- Key packages: `tidyverse`, `tidycensus`, `sf`, `tigris`, `broom`, `kableExtra`, `ggrepel`, `showtext`


```

### Steps to reproduce

1. Clone the repository

2. All model outputs included in data/ 

3. Build the site: rmarkdown::render_site()

4. Push docs/ to GitHub — deploys automatically via GitHub Pages

---

## Data Sources

| Source | Description |
|--------|-------------|
| U.S. Census Bureau, ACS 2024 5-Year Estimates | Educational attainment, internet access, LEP, disability, poverty, racial/ethnic composition, age structure — retrieved via `tidycensus` |
| ACS CVAP Special Tabulation | Citizen Voting Age Population denominators for turnout rate calculation |
| IL State Board of Elections | 2024 general election vote totals by county |
| IN Secretary of State | 2024 general election vote totals by county |
| OH Secretary of State | 2024 general election vote totals by county |
| WI Elections Commission | 2024 general election vote totals by county |
| MI Department of State | 2024 general election vote totals by county |

Qualitative case study research draws on secondary sources including DataUSA county profiles, local government economic development websites, the Naval Surface Warfare Center Crane Division official site, U.S. Bureau of Labor Statistics data, state nonprofit directories, and regional news archives.

---

## Repository Structure
midwestturnout/
├── data/                            # model outputs and predictions
│   ├── df_pct_with_predictions.rds  # primary dataset used across all pages
│   ├── model1.rds through model4.rds
│   └── supporting csvs
├── docs/                            # rendered site output (GitHub Pages root)
├── index.Rmd                        # overview page
├── descriptive.Rmd                  # background: descriptive findings
├── model.Rmd                        # methodology: predictive model
├── case-studies.Rmd                 # qualitative case studies
├── synthesis.Rmd                    # synthesis and implications
├── explore.Rmd                      # interactive explorer
├── about.Rmd                        # about the project
├── custom.css                       # site-wide styles
└── _site.yml                        # site configuration and nav

---

## Analysis

All data processing, modeling, and visualization conducted in R. The predictive model uses OLS regression with state fixed effects. Full model specification and coefficient estimates are available on the Methodology page.
