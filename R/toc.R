# R/toc.R

# ─────────────────────────────────────────────────────────────────────────────
# Internal TOC style registry
# ─────────────────────────────────────────────────────────────────────────────

.toc_registry <- data.frame(
  id = 1L:3L,
  name = c("Clássico", "Moderno", "Minimalista"),
  description = c(
    paste0(
      "Estilo tipográfico clássico. ",
      "Entradas de capítulo em negrito com o acento da cor primária. ",
      "Pontos de preenchimento (dot leaders) conectando título e número de página. ",
      "Seções recuadas, subcapítulos em peso regular."
    ),
    paste0(
      "Estilo contemporâneo com barra lateral colorida. ",
      "Capítulos destacados com retângulo de cor primária à esquerda. ",
      "Números de página em caixas coloridas. ",
      "Amplo espaçamento entre entradas para leitura aerada."
    ),
    paste0(
      "Estilo minimalista, máximo espaço em branco. ",
      "Sem líderes de pontos nem decorações. ",
      "Número de página alinhado à direita separado por fio fino. ",
      "Hierarquia transmitida apenas via tamanho de fonte e recuo."
    )
  ),
  typst_file = c("toc-classic.typ", "toc-modern.typ", "toc-minimal.typ"),
  stringsAsFactors = FALSE
)

# ─────────────────────────────────────────────────────────────────────────────
# Exported functions
# ─────────────────────────────────────────────────────────────────────────────

#' List the three table of contents styles available in `BusinessReport`
#'
#' @description
#' Returns a data frame describing each TOC style. Pass the `id` value (1, 2,
#' or 3) to [create_business_report()] or [set_toc_style()].
#'
#' @return A data frame with columns `id`, `name`, and `description`.
#'
#' @examples
#' list_toc_styles()
#'
#' @export
list_toc_styles <- function() {
  .toc_registry[, c("id", "name", "description")]
}


#' Change the table of contents style of an existing `BusinessReport` project
#'
#' @description
#' Updates `_extensions/business-report/_business-report-config.typ` in place,
#' setting `toc-style` to the chosen value. Re-render to see the effect.
#'
#' @param path   Project root directory. Defaults to the current working directory.
#' @param style  Integer: `1` (Clássico), `2` (Moderno), or `3` (Minimalista).
#'   Use [list_toc_styles()] for descriptions.
#'
#' @return `path`, invisibly.
#'
#' @examples
#' \dontrun{
#' set_toc_style("my-report", style = 2)
#' }
#'
#' @export
set_toc_style <- function(path = ".", style) {
  rlang::check_required(style)
  style <- .check_toc_style(style)
  .update_config_key(path, "toc-style", as.character(style))
  toc_name <- .toc_registry[.toc_registry[["id"]] == style, "name"]
  cli::cli_inform(
    c("v" = "TOC style updated to {.strong {toc_name}} (style {style}).",
      "i" = "Re-render your {.file .qmd} to see the change.")
  )
  invisible(path)
}


#' Change the primary accent colour of an existing `BusinessReport` project
#'
#' @description
#' Updates `_extensions/business-report/_business-report-config.typ` to use a new
#' primary colour. The colour is applied to headings, the cover, the TOC, and
#' decorative elements throughout the report.
#'
#' @param path   Project root directory. Defaults to the current working directory.
#' @param color  A six-digit hex colour string with a leading `#`, e.g. `"#2d6a9a"`.
#'
#' @return `path`, invisibly.
#'
#' @examples
#' \dontrun{
#' set_primary_color("my-report", color = "#8b1a1a")  # Deep red
#' set_primary_color("my-report", color = "#1a5c3a")  # Forest green
#' }
#'
#' @export
set_primary_color <- function(path = ".", color) {
  rlang::check_required(color)
  .check_color(color)
  .update_config_key(path, "primary-color", glue::glue('rgb("{color}")'))
  cli::cli_inform(
    c("v" = "Primary colour updated to {.val {color}}.",
      "i" = "Re-render your {.file .qmd} to see the change.")
  )
  invisible(path)
}


#' Toggle the cover page of an existing `BusinessReport` project
#'
#' @param path   Project root directory.
#' @param cover  Logical. `TRUE` to include the cover; `FALSE` to omit it.
#'
#' @return `path`, invisibly.
#'
#' @examples
#' \dontrun{
#' toggle_cover("my-report", cover = FALSE)
#' }
#'
#' @export
toggle_cover <- function(path = ".", cover) {
  rlang::check_required(cover)
  bool_val <- if (isTRUE(cover)) "true" else "false"
  .update_config_key(path, "cover", bool_val)
  label <- if (isTRUE(cover)) "enabled" else "disabled"
  cli::cli_inform(c("v" = "Cover page {label}."))
  invisible(path)
}


#' Toggle the back cover of an existing `BusinessReport` project
#'
#' @param path       Project root directory.
#' @param back_cover Logical. `TRUE` to include the back cover; `FALSE` to omit it.
#'
#' @return `path`, invisibly.
#'
#' @examples
#' \dontrun{
#' toggle_back_cover("my-report", back_cover = FALSE)
#' }
#'
#' @export
toggle_back_cover <- function(path = ".", back_cover) {
  rlang::check_required(back_cover)
  bool_val <- if (isTRUE(back_cover)) "true" else "false"
  .update_config_key(path, "back-cover", bool_val)
  label <- if (isTRUE(back_cover)) "enabled" else "disabled"
  cli::cli_inform(c("v" = "Back cover {label}."))
  invisible(path)
}
