# R/fonts.R

# ─────────────────────────────────────────────────────────────────────────────
# Internal font registry
# ─────────────────────────────────────────────────────────────────────────────
# Each row maps a user-facing `id` to the exact `typst_family` name that Typst
# expects, plus descriptive metadata.
#
# System fonts (Georgia, Palatino) are pre-installed on most operating systems.
# OFL fonts (Google Fonts, IBM) must be installed by the user; Typst will search
# system font directories automatically on macOS, Windows and Linux.

.font_registry <- data.frame(
  id = c(
    "georgia", "palatino", "garamond",
    "baskerville", "merriweather", "crimson", "spectral",
    "lato", "source-sans", "fira-sans",
    "ibm-plex", "montserrat", "roboto", "inter"
  ),
  display_name = c(
    "Georgia", "Palatino Linotype", "EB Garamond",
    "Libre Baskerville", "Merriweather", "Crimson Pro", "Spectral",
    "Lato", "Source Sans 3", "Fira Sans",
    "IBM Plex Sans", "Montserrat", "Roboto", "Inter"
  ),
  typst_family = c(
    "Georgia", "Palatino Linotype", "EB Garamond",
    "Libre Baskerville", "Merriweather", "Crimson Pro", "Spectral",
    "Lato", "Source Sans 3", "Fira Sans",
    "IBM Plex Sans", "Montserrat", "Roboto", "Inter"
  ),
  style = c(
    "Serif", "Serif", "Serif",
    "Serif", "Serif", "Serif", "Serif",
    "Sans-Serif", "Sans-Serif", "Sans-Serif",
    "Sans-Serif", "Sans-Serif", "Sans-Serif", "Sans-Serif"
  ),
  origin = c(
    "Microsoft/Monotype", "Hermann Zapf / Linotype", "Claude Garamond (revival)",
    "John Baskerville (revival)", "Sorkin Type", "Jacques Le Bailly", "Production Type",
    "Lukasz Dziedzic", "Adobe", "Mozilla / Carrois",
    "IBM", "Julieta Ulanovsky", "Google", "Rasmus Andersson"
  ),
  license = c(
    "System", "System", "OFL",
    "OFL", "OFL", "OFL", "OFL",
    "OFL", "OFL", "OFL",
    "OFL", "OFL", "Apache 2.0", "OFL"
  ),
  famous_use = c(
    "The Economist, academic publishing",
    "Many LaTeX documents, academic press",
    "Classic book typography, Penguin Books editions",
    "Academic reports, Google Books",
    "Medium.com, digital long-form reading",
    "Academic journals, literary publications",
    "Google Fonts, digital readability studies",
    "Government reports, UN documents",
    "Adobe Creative Suite, official documentation",
    "Mozilla, open-source technical docs",
    "IBM annual reports, IBM Cloud documentation",
    "Modern branding, startup pitch decks",
    "Google Material Design, Android reports",
    "Linear, Vercel, modern SaaS dashboards"
  ),
  stringsAsFactors = FALSE
)

# ─────────────────────────────────────────────────────────────────────────────
# Exported functions
# ─────────────────────────────────────────────────────────────────────────────

#' List all fonts available in `BusinessReport`
#'
#' @description
#' Returns a data frame with metadata for every font bundled with `BusinessReport`.
#' The `id` column is what you pass to [create_business_report()] and [set_font()].
#'
#' Fonts with `license = "System"` are pre-installed on most operating systems.
#' Fonts with `license = "OFL"` or `"Apache 2.0"` are open-source and must be
#' installed separately; Typst searches system font directories automatically.
#' Google Fonts can be downloaded at <https://fonts.google.com>.
#'
#' @return A data frame with columns `id`, `display_name`, `typst_family`,
#'   `style`, `origin`, `license`, and `famous_use`.
#'
#' @examples
#' list_fonts()
#'
#' # Filter to sans-serif options only
#' fonts <- list_fonts()
#' fonts[fonts$style == "Sans-Serif", c("id", "display_name", "famous_use")]
#'
#' @export
list_fonts <- function() {
  .font_registry
}


#' Change the font of an existing `BusinessReport` project
#'
#' @description
#' Updates `_extensions/business-report/_business-report-config.typ` in place,
#' changing the `font-family` value. Re-render the Quarto document to see
#' the effect.
#'
#' @param path  Path to the project root (the directory that contains the
#'   `_extensions/` folder). Defaults to the current working directory.
#' @param font  Font id string. Use [list_fonts()] to see valid values.
#'
#' @return `path`, invisibly.
#'
#' @examples
#' \dontrun{
#' set_font("my-report", font = "ibm-plex")
#' set_font("my-report", font = "merriweather")
#' }
#'
#' @export
set_font <- function(path = ".", font) {
  rlang::check_required(font)
  typst_family <- .check_font_id(font)
  .update_config_key(path, "font-family", glue::glue('"{typst_family}"'))
  cli::cli_inform(
    c("v" = "Font updated to {.strong {typst_family}}.",
      "i" = "Re-render your {.file .qmd} to see the change.")
  )
  invisible(path)
}
