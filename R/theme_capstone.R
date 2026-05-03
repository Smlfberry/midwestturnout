# =============================================================================
# theme_capstone.R
#
# Shared ggplot2 theme + palette helpers for the midwest-turnout website.
# Source from each Rmd setup chunk:
#   source("R/theme_capstone.R")
# Then plots can use: + theme_capstone()
# And residual fills/colors via: + scale_fill_capstone_diverging()
#
# Palette mirrors custom.css "Civic Editorial" palette: bone bg, oxblood
# brand, midnight navy accent, mustard ochre warmth, plum-amber diverging
# scale (colorblind-safe; avoids partisan red/blue and red/green pairing).
# =============================================================================

suppressPackageStartupMessages({
  library(ggplot2)
  library(scales)
})

# ---- Palette ---------------------------------------------------------------
# Hex values match the --token names in custom.css.
capstone_palette <- list(
  ink         = "#1a1a1a",
  page        = "#f7f4ed",
  page_alt    = "#ede6d4",
  rule        = "#d8d0c0",
  brand       = "#6e1f2e",   # oxblood — site identity
  accent      = "#1d2d4d",   # midnight navy — links, methodology
  accent_warm = "#c89b3b",   # mustard ochre — emphasis, trend lines
  under       = "#5e2e6e",   # deep plum — underperformers
  mid         = "#a09387",   # warm gray — expected
  over        = "#b8772e",   # burnt amber — overperformers
  text_body   = "#2a2625",
  text_mid    = "#5a544a",
  text_light  = "#8c857a"
)

# ---- Fonts -----------------------------------------------------------------
# We try to load IBM Plex from Google Fonts via {showtext}. If unavailable
# (no showtext installed, no internet, etc.) the theme falls back to system
# serif/sans, which still looks editorial.
.capstone_use_plex <- function() {
  if (!requireNamespace("sysfonts", quietly = TRUE) ||
      !requireNamespace("showtext", quietly = TRUE)) {
    return(FALSE)
  }
  ok <- tryCatch({
    sysfonts::font_add_google("IBM Plex Serif", "plex_serif")
    sysfonts::font_add_google("IBM Plex Sans",  "plex_sans")
    showtext::showtext_auto()
    showtext::showtext_opts(dpi = 150)
    TRUE
  }, error = function(e) FALSE)
  ok
}

.capstone_fonts <- if (.capstone_use_plex()) {
  list(serif = "plex_serif", sans = "plex_sans")
} else {
  list(serif = "serif", sans = "sans")
}

# ---- Theme -----------------------------------------------------------------
#' Editorial ggplot2 theme matching the Civic Editorial site palette.
#' @param base_size base font size in pt (default 12)
#' @param plot_bg if TRUE, use bone (page) background; if FALSE, transparent
theme_capstone <- function(base_size = 12, plot_bg = TRUE) {
  pal <- capstone_palette
  fnt <- .capstone_fonts

  bg <- if (plot_bg) pal$page else NA

  theme_minimal(base_size = base_size) %+replace%
    theme(
      # Backgrounds
      plot.background  = element_rect(fill = bg, colour = NA),
      panel.background = element_rect(fill = bg, colour = NA),
      panel.border     = element_blank(),

      # Grid — soft warm tan, subtle
      panel.grid.major.x = element_line(colour = pal$rule, linewidth = 0.3),
      panel.grid.major.y = element_line(colour = pal$rule, linewidth = 0.3),
      panel.grid.minor   = element_blank(),

      # Titles + subtitles — serif, editorial
      plot.title = element_text(
        family = fnt$serif, face = "bold",
        size = rel(1.45), colour = pal$ink,
        hjust = 0, margin = margin(b = 4)
      ),
      plot.subtitle = element_text(
        family = fnt$serif, face = "italic",
        size = rel(1.05), colour = pal$text_mid,
        hjust = 0, margin = margin(b = 14)
      ),
      plot.caption = element_text(
        family = fnt$sans,
        size = rel(0.78), colour = pal$text_light,
        hjust = 0, margin = margin(t = 12)
      ),
      plot.caption.position = "plot",
      plot.title.position   = "plot",

      # Axis — sans for legibility
      axis.title.x = element_text(
        family = fnt$sans, size = rel(0.92),
        colour = pal$text_mid, margin = margin(t = 8)
      ),
      axis.title.y = element_text(
        family = fnt$sans, size = rel(0.92),
        colour = pal$text_mid, margin = margin(r = 8), angle = 90
      ),
      axis.text = element_text(
        family = fnt$sans, size = rel(0.85),
        colour = pal$text_mid
      ),
      axis.ticks = element_line(colour = pal$rule, linewidth = 0.3),
      axis.line  = element_blank(),

      # Legend — sans, top by default
      legend.position    = "top",
      legend.title       = element_text(
        family = fnt$sans, size = rel(0.85),
        colour = pal$text_mid, face = "bold"
      ),
      legend.text        = element_text(
        family = fnt$sans, size = rel(0.85),
        colour = pal$text_body
      ),
      legend.background  = element_rect(fill = bg, colour = NA),
      legend.key         = element_rect(fill = bg, colour = NA),

      # Strip (facet) labels — serif, italic
      strip.background = element_rect(fill = pal$page_alt, colour = NA),
      strip.text       = element_text(
        family = fnt$serif, face = "italic",
        size = rel(0.95), colour = pal$ink,
        margin = margin(t = 5, b = 5)
      ),

      complete = TRUE
    )
}

# ---- Color & fill scales ---------------------------------------------------
# Diverging plum ↔ amber for residuals.
capstone_diverging <- c(
  capstone_palette$under,
  "#a17896",                           # mid plum
  capstone_palette$page_alt,           # cream center
  "#d6a565",                           # mid amber
  capstone_palette$over
)

#' Diverging fill scale anchored at zero (residuals in pp).
#' @param limits numeric length-2; symmetric residual range, e.g. c(-0.12, 0.12)
scale_fill_capstone_diverging <- function(limits = NULL,
                                          name = "Residual",
                                          ...) {
  if (is.null(limits)) limits <- c(-0.12, 0.12)
  scale_fill_gradientn(
    colours  = capstone_diverging,
    values   = scales::rescale(c(limits[1], limits[1] / 2, 0,
                                 limits[2] / 2, limits[2])),
    limits   = limits,
    oob      = scales::squish,
    name     = name,
    ...
  )
}

scale_color_capstone_diverging <- function(limits = NULL,
                                           name = "Residual",
                                           ...) {
  if (is.null(limits)) limits <- c(-0.12, 0.12)
  scale_color_gradientn(
    colours  = capstone_diverging,
    values   = scales::rescale(c(limits[1], limits[1] / 2, 0,
                                 limits[2] / 2, limits[2])),
    limits   = limits,
    oob      = scales::squish,
    name     = name,
    ...
  )
}

# Discrete tier scale for the three case-study tiers.
scale_color_capstone_tier <- function(...) {
  scale_color_manual(
    values = c(
      "Over-Performer"  = capstone_palette$over,
      "As-Expected"     = capstone_palette$mid,
      "Under-Performer" = capstone_palette$under
    ),
    breaks = c("Over-Performer", "As-Expected", "Under-Performer"),
    ...
  )
}

scale_fill_capstone_tier <- function(...) {
  scale_fill_manual(
    values = c(
      "Over-Performer"  = capstone_palette$over,
      "As-Expected"     = capstone_palette$mid,
      "Under-Performer" = capstone_palette$under
    ),
    breaks = c("Over-Performer", "As-Expected", "Under-Performer"),
    ...
  )
}
