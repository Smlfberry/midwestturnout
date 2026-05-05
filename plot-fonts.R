plot_serif <- "serif"
plot_sans <- "sans"

font_dir <- file.path("assets", "fonts")
font_files <- list(
  sans_regular = file.path(font_dir, "IBMPlexSans-Regular.ttf"),
  sans_bold = file.path(font_dir, "IBMPlexSans-SemiBold.ttf"),
  sans_italic = file.path(font_dir, "IBMPlexSans-Italic.ttf"),
  serif_regular = file.path(font_dir, "IBMPlexSerif-Regular.ttf"),
  serif_bold = file.path(font_dir, "IBMPlexSerif-SemiBold.ttf"),
  serif_italic = file.path(font_dir, "IBMPlexSerif-Italic.ttf")
)

if (all(file.exists(unlist(font_files))) &&
    requireNamespace("sysfonts", quietly = TRUE) &&
    requireNamespace("showtext", quietly = TRUE)) {
  sysfonts::font_add(
    family = "plex_sans",
    regular = font_files$sans_regular,
    bold = font_files$sans_bold,
    italic = font_files$sans_italic
  )
  sysfonts::font_add(
    family = "plex_serif",
    regular = font_files$serif_regular,
    bold = font_files$serif_bold,
    italic = font_files$serif_italic
  )
  showtext::showtext_auto()
  showtext::showtext_opts(dpi = 150)
  plot_serif <- "plex_serif"
  plot_sans <- "plex_sans"
}
