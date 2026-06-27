# R/create_report.R

#' Crie um novo projeto Quarto do `BusinessReport`
#'
#' @description
#' Gera um projeto Quarto/Typst pronto para renderização. A função:
#' \enumerate{
#'   \item cria o diretório do projeto;
#'   \item copia a extensão Quarto (`_extensions/business-report/`);
#'   \item gera `_extensions/business-report/_business-report-config.typ`;
#'   \item copia a pasta `assets/` com arquivos de imagem iniciais;
#'   \item escreve o esqueleto de `report.qmd` com título e metadados.
#' }
#'
#' Após a criação, abra `report.qmd` e renderize com
#' `quarto::quarto_render("report.qmd")` ou pelo botão Render do RStudio.
#'
#' @param path Caminho para o novo diretório do projeto. Não deve existir, a
#'   menos que `overwrite = TRUE`.
#' @param title Título do relatório.
#' @param subtitle Subtítulo opcional.
#' @param author Nome do autor.
#' @param institution Nome da instituição ou organização.
#' @param date Data do relatório. O padrão é a data de hoje.
#' @param font Identificador da fonte. Use [list_fonts()] para ver as opções.
#' @param primary_color Cor hexadecimal de destaque com `#`.
#' @param toc_style Estilo do sumário: `1` (Clássico), `2` (Moderno) ou
#'   `3` (Minimalista).
#' @param cover Lógico. Se `TRUE`, inclui capa.
#' @param back_cover Lógico. Se `TRUE`, inclui contracapa.
#' @param lang Tag BCP 47 de idioma. O padrão é `"pt"`.
#' @param overwrite Lógico. Se `TRUE`, sobrescreve um diretório existente.
#' @param open Lógico. Se `TRUE`, abre `report.qmd` na IDE após a criação.
#'
#' @return `path`, invisivelmente.
#'
#' @examples
#' \dontrun{
#' create_business_report("meu-relatorio")
#'
#' create_business_report(
#'   path = "relatorio-2025",
#'   title = "Relatório Anual: 2025",
#'   subtitle = "Análise de Adequação de Capital",
#'   author = "Gerência de Modelagem e Monitoramento",
#'   institution = "FGCoop",
#'   font = "ibm-plex",
#'   primary_color = "#0d3d6e",
#'   toc_style = 2L,
#'   cover = TRUE,
#'   back_cover = TRUE
#' )
#' }
#'
#' @export
create_business_report <- function(
  path,
  title         = "Relatório Empresarial",
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

  typst_family <- .check_font_id(font)
  .check_color(primary_color)
  toc_style <- .check_toc_style(toc_style)

  if (is.null(date)) {
    date <- .format_date(Sys.Date(), lang)
  }

  subtitle    <- subtitle    %||% ""
  author      <- author      %||% ""
  institution <- institution %||% ""

  path <- fs::path_abs(path)

  if (fs::dir_exists(path) && !overwrite) {
    cli::cli_abort(
      c(
        "O diretório {.path {path}} já existe.",
        "i" = "Use {.code overwrite = TRUE} para sobrescrevê-lo."
      )
    )
  }

  fs::dir_create(path, recurse = TRUE)

  cli::cli_progress_step("Criando projeto em {.path {path}}")

  ext_dest <- .ext_dest(path)
  fs::dir_create(fs::path(path, "_extensions", "business-report"), recurse = TRUE)

  cli::cli_progress_step("Copiando a extensão Quarto")
  fs::dir_copy(.ext_source(), ext_dest, overwrite = TRUE)

  cli::cli_progress_step("Escrevendo a configuração")
  .write_config(
    path          = path,
    font_family   = typst_family,
    primary_color = primary_color,
    toc_style     = toc_style,
    cover         = cover,
    back_cover    = back_cover,
    lang          = lang
  )

  assets_dest <- fs::path(path, "assets")
  fs::dir_create(assets_dest)
  fs::dir_copy(.assets_source(), assets_dest, overwrite = TRUE)

  cli::cli_progress_step("Escrevendo o esqueleto do relatório")
  .write_skeleton(
    path        = path,
    title       = title,
    subtitle    = subtitle,
    author      = author,
    institution = institution,
    date        = date,
    lang        = lang
  )

  cli::cli_inform(c(
    "",
    "v" = "Projeto pronto: {.path {path}}",
    "",
    "*" = "Próximos passos:",
    " " = "1. Substitua {.file assets/logo.svg} pelo seu logo.",
    " " = "2. Abra {.file report.qmd} e comece a escrever.",
    " " = "3. Renderize com {.code quarto::quarto_render(\"report.qmd\")}.",
    " " = "",
    "i" = "Use {.fn BusinessReport::set_font}, {.fn set_toc_style} e",
    " " = "   {.fn set_primary_color} para ajustar o visual sem recriar o projeto."
  ))

  if (isTRUE(open)) {
    open_report(path)
  }

  invisible(path)
}


#' Abra o arquivo principal de um projeto `BusinessReport` na IDE
#'
#' @param path Diretório raiz do projeto. O padrão é `"."`.
#'
#' @return `path`, invisivelmente.
#'
#' @export
open_report <- function(path = ".") {
  qmd <- fs::path(path, "report.qmd")
  if (!fs::file_exists(qmd)) {
    cli::cli_warn("Nenhum {.file report.qmd} foi encontrado em {.path {path}}.")
    return(invisible(path))
  }
  if (rlang::is_interactive()) {
    utils::file.edit(qmd)
  }
  invisible(path)
}

`%||%` <- function(x, y) if (is.null(x)) y else x

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

.write_skeleton <- function(
  path, title, subtitle, author, institution, date, lang
) {
  skeleton_raw <- readLines(.skeleton_path(), warn = FALSE, encoding = "UTF-8")

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
  writeLines(enc2utf8(result), dest, useBytes = TRUE)
  invisible(dest)
}
