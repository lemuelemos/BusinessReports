# R/create_report.R

#' Create a new `BusinessReport` Quarto project
#'
#' @description
#' Scaffolds a ready-to-render Quarto/Typst project for business reporting.
#' The function:
#' \enumerate{
#'   \item Creates the project directory (with an error if it already exists,
#'     unless `overwrite = TRUE`).
#'   \item Copies the Quarto extension (`_extensions/business-report/`) into the
#'     project.
#'   \item Generates `_extensions/business-report/_business-report-config.typ` with the
#'     chosen options.
#'   \item Copies an `assets/` folder containing placeholder logo and back-cover
#'     images that you should replace with your own.
#'   \item Writes the `report.qmd` skeleton pre-filled with title and metadata.
#' }
#'
#' After creation, open `report.qmd` and render with
#' `quarto::quarto_render("report.qmd")` or the RStudio Render button.
#'
#' @param path  Path to the new project directory. Must not exist unless
#'   `overwrite = TRUE`.
#' @param title  Report title (character string).
#' @param subtitle  Optional subtitle (character string or `NULL`).
#' @param author  Author name (character string or `NULL`).
#' @param institution  Institution or organisation name (character string or `NULL`).
#' @param date  Report date. Defaults to today in `"dd de Month de YYYY"` format
#'   for Portuguese documents. Pass any string to override.
#' @param font  Font id. Use [list_fonts()] to see options. Defaults to
#'   `"georgia"`.
#' @param primary_color  Hex accent colour with leading `#`. Default `"#1a3a5c"`.
#' @param toc_style  TOC style: `1` (Clássico), `2` (Moderno), or
#'   `3` (Minimalista). Use [list_toc_styles()] for descriptions.
#' @param cover  Logical. Whether to include a cover page. Default `TRUE`.
#' @param back_cover  Logical. Whether to include a back cover page. Default `TRUE`.
#' @param lang  BCP 47 language tag. Default `"pt"` (Portuguese). Pass `"en"`
#'   for English date formatting in the template.
#' @param overwrite  Logical. If `TRUE`, an existing directory at `path` is
#'   overwritten. Use with care.
#' @param open  Logical. Whether to open `report.qmd` in the IDE after creation.
#'   Defaults to `TRUE` in interactive sessions.
#'
#' @return `path`, invisibly.
#'
#' @examples
#' \dontrun{
#' # Minimal call — uses all defaults
#' create_business_report("my-report")
#'
#' # Customised call
#' create_business_report(
#'   path          = "my-report-2025",
#'   title         = "Relatório Anual: 2025",
#'   subtitle      = "Análise de Adequação de Capital",
#'   author        = "Gerência de Modelagem e Monitoramento",
#'   institution   = "FGCoop",
#'   font          = "ibm-plex",
#'   primary_color = "#0d3d6e",
#'   toc_style     = 2,
#'   cover         = TRUE,
#'   back_cover    = TRUE
#' )
#' }
#'
#' @export
create_business_report <- function(
  path,
  title         = "Business Report",
  subtitle      = NULL,
  author        = NULL,
  institution   = NULL,
  date          = NULL,
  font          = "georgia",
  primary_color = "#1a3a5c",
  toc_style     = 1L,
  cover         = TRUE,
  back_cover    = TRUE,
  lang          = "pt",
  overwrite     = FALSE,
  open          = rlang::is_interactive()
) {
  rlang::check_required(path)

  # ── Input validation ──────────────────────────────────────────────────────
  typst_family <- .check_font_id(font)
  .check_color(primary_color)
  toc_style <- .check_toc_style(toc_style)

  if (is.null(date)) {
    date <- .format_date(Sys.Date(), lang)
  }

  subtitle    <- subtitle    %||% ""
  author      <- author      %||% ""
  institution <- institution %||% ""

  # ── Directory ─────────────────────────────────────────────────────────────
  path <- fs::path_abs(path)

  if (fs::dir_exists(path) && !overwrite) {
    cli::cli_abort(
      c(
        "Directory {.path {path}} already exists.",
        "i" = "Use {.code overwrite = TRUE} to replace it."
      )
    )
  }

  fs::dir_create(path, recurse = TRUE)

  cli::cli_progress_step("Creating project at {.path {path}}")

  # ── Copy Quarto extension ─────────────────────────────────────────────────
  ext_dest <- .ext_dest(path)
  fs::dir_create(fs::path(path, "_extensions", "business-report"), recurse = TRUE)

  cli::cli_progress_step("Copying Quarto extension")

  fs::dir_copy(.ext_source(), ext_dest, overwrite = TRUE)

  # ── Write config Typst file ───────────────────────────────────────────────
  cli::cli_progress_step("Writing configuration")

  .write_config(
    path          = path,
    font_family   = typst_family,
    primary_color = primary_color,
    toc_style     = toc_style,
    cover         = cover,
    back_cover    = back_cover,
    lang          = lang
  )

  # ── Copy placeholder assets ───────────────────────────────────────────────
  assets_dest <- fs::path(path, "assets")
  fs::dir_create(assets_dest)
  fs::dir_copy(.assets_source(), assets_dest, overwrite = TRUE)

  # ── Write skeleton .qmd ───────────────────────────────────────────────────
  cli::cli_progress_step("Writing report skeleton")

  .write_skeleton(
    path        = path,
    title       = title,
    subtitle    = subtitle,
    author      = author,
    institution = institution,
    date        = date,
    lang        = lang
  )

  # ── Done ──────────────────────────────────────────────────────────────────
  cli::cli_inform(c(
    "",
    "v" = "Project ready: {.path {path}}",
    "",
    "*" = "Next steps:",
    " " = "1. Replace {.file assets/logo.svg} with your logo.",
    " " = "2. Open {.file report.qmd} and start writing.",
    " " = "3. Render with {.code quarto::quarto_render(\"report.qmd\")}.",
    " " = "",
    "i" = "Use {.fn BusinessReport::set_font}, {.fn set_toc_style}, and",
    " " = "   {.fn set_primary_color} to adjust the look without re-creating."
  ))

  if (isTRUE(open)) {
    open_report(path)
  }

  invisible(path)
}


#' Open the main report file of a `BusinessReport` project in the IDE
#'
#' @param path  Project root directory. Defaults to `"."`.
#'
#' @return `path`, invisibly.
#'
#' @export
open_report <- function(path = ".") {
  qmd <- fs::path(path, "report.qmd")
  if (!fs::file_exists(qmd)) {
    cli::cli_warn("No {.file report.qmd} found at {.path {path}}.")
    return(invisible(path))
  }
  if (rlang::is_interactive()) {
    utils::file.edit(qmd)
  }
  invisible(path)
}

# ─────────────────────────────────────────────────────────────────────────────
# Internal helpers
# ─────────────────────────────────────────────────────────────────────────────

#' Null-coalescing operator
#' @noRd
`%||%` <- function(x, y) if (is.null(x)) y else x


#' Format a Date for the skeleton YAML
#' @noRd
.format_date <- function(date, lang = "pt") {
  if (lang == "pt") {
    months_pt <- c(
      "janeiro", "fevereiro", "março", "abril",
      "maio", "junho", "julho", "agosto",
      "setembro", "outubro", "novembro", "dezembro"
    )
    d <- as.Date(date)
    glue::glue(
      "{format(d, '%d')} de {months_pt[as.integer(format(d, '%m'))]} de {format(d, '%Y')}"
    )
  } else {
    format(as.Date(date), "%B %d, %Y")
  }
}


#' Write the report.qmd skeleton into the project
#' @noRd
.write_skeleton <- function(
  path, title, subtitle, author, institution, date, lang
) {
  skeleton_raw <- readLines(.skeleton_path(), warn = FALSE)

  # Map placeholders to values; all are strings so no type issues
  replacements <- list(
    "<<TITLE>>"       = title,
    "<<SUBTITLE>>"    = subtitle,
    "<<AUTHOR>>"      = author,
    "<<INSTITUTION>>" = institution,
    "<<DATE>>"        = date,
    "<<LANG>>"        = lang
  )

  result <- skeleton_raw
  for (ph in names(replacements)) {
    result <- gsub(ph, replacements[[ph]], result, fixed = TRUE)
  }

  dest <- fs::path(path, "report.qmd")
  writeLines(result, dest)
  invisible(dest)
}
