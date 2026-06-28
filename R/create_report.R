# R/create_report.R

#' Crie um novo projeto Quarto do `BusinessReport`
#'
#' @description
#' Gera um projeto Quarto/Typst pronto para renderizacao. A funcao:
#' \enumerate{
#'   \item cria o diretorio do projeto;
#'   \item copia a extensao Quarto (`_extensions/business-report/`);
#'   \item gera `_extensions/business-report/_business-report-config.typ`;
#'   \item copia a pasta `assets/` com arquivos de imagem iniciais;
#'   \item escreve o esqueleto de `report.qmd` com titulo e metadados.
#' }
#'
#' Apos a criacao, abra `report.qmd` e renderize com
#' `quarto::quarto_render("report.qmd")` ou pelo botao Render do RStudio.
#'
#' @param path Caminho para o novo diretorio do projeto. Nao deve existir, a
#'   menos que `overwrite = TRUE`.
#' @param title Titulo do relatorio.
#' @param subtitle Subtitulo opcional.
#' @param author Nome do autor.
#' @param institution Nome da instituicao ou organizacao.
#' @param date Data do relatorio. O padrao e a data de hoje.
#' @param font Identificador da fonte. Use [list_fonts()] para ver as opcoes.
#' @param primary_color Cor hexadecimal de destaque com `#`.
#' @param toc_style Estilo do sumario: `1` (Classico), `2` (Moderno),
#'   `3` (Minimalista) ou `4` (Cards).
#' @param cover Logico. Se `TRUE`, inclui capa.
#' @param cover_image Caminho da imagem de capa relativa a raiz do projeto,
#'   por exemplo `"assets/minha-capa.png"`. Se `NULL` ou `""`, usa a capa
#'   padrao do template.
#' @param cover_title_color Cor hexadecimal do titulo sobre a imagem de capa.
#'   O padrao e `"#FFFFFF"`.
#' @param cover_title_x Posicao horizontal do titulo sobre a imagem de capa,
#'   em unidade Typst, por exemplo `"18mm"`.
#' @param cover_title_y Posicao vertical do titulo sobre a imagem de capa,
#'   em unidade Typst, por exemplo `"110mm"`.
#' @param back_cover Logico. Se `TRUE`, inclui contracapa.
#' @param lang Tag BCP 47 de idioma. O padrao e `"pt"`.
#' @param overwrite Logico. Se `TRUE`, sobrescreve um diretorio existente.
#' @param open Logico. Se `TRUE`, abre `report.qmd` na IDE apos a criacao.
#'
#' @return `path`, invisivelmente.
#'
#' @examples
#' \dontrun{
#' create_business_report("meu-relatorio")
#'
#' create_business_report(
#'   path = "relatorio-2025",
#'   title = "Relatorio Anual: 2025",
#'   subtitle = "Analise de Adequacao de Capital",
#'   author = "Gerencia de Modelagem e Monitoramento",
#'   institution = "FGCoop",
#'   font = "ibm-plex",
#'   primary_color = "#0d3d6e",
#'   toc_style = 2L,
#'   cover = TRUE,
#'   cover_image = "assets/minha-capa.png",
#'   cover_title_color = "#FFFFFF",
#'   cover_title_x = "18mm",
#'   cover_title_y = "110mm",
#'   back_cover = TRUE
#' )
#' }
#'
#' @export
create_business_report <- function(
  path,
  title         = "Relatorio Empresarial",
  subtitle      = NULL,
  author        = NULL,
  institution   = NULL,
  date          = NULL,
  font          = "georgia",
  primary_color = "#1a3a5c",
  toc_style     = 1L,
  cover         = TRUE,
  cover_image   = NULL,
  cover_title_color = "#FFFFFF",
  cover_title_x = "18mm",
  cover_title_y = "110mm",
  back_cover    = TRUE,
  lang          = "pt",
  overwrite     = FALSE,
  open          = rlang::is_interactive()
) {
  rlang::check_required(path)

  typst_family <- .check_font_id(font)
  .check_color(primary_color)
  .check_color(cover_title_color)
  toc_style <- .check_toc_style(toc_style)
  cover <- .check_flag(cover, "cover")
  cover_image <- .normalize_cover_image_path(cover_image)
  cover_title_x <- .normalize_typst_length(cover_title_x, "cover_title_x")
  cover_title_y <- .normalize_typst_length(cover_title_y, "cover_title_y")
  back_cover <- .check_flag(back_cover, "back_cover")
  open <- .check_flag(open, "open")

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
        "O diretorio {.path {path}} ja existe.",
        "i" = "Use {.code overwrite = TRUE} para sobrescreve-lo."
      )
    )
  }

  fs::dir_create(path, recurse = TRUE)

  cli::cli_progress_step("Criando projeto em {.path {path}}")

  ext_dest <- .ext_dest(path)
  fs::dir_create(fs::path(path, "_extensions", "business-report"), recurse = TRUE)

  cli::cli_progress_step("Copiando a extensao Quarto")
  fs::dir_copy(.ext_source(), ext_dest, overwrite = TRUE)

  cli::cli_progress_step("Escrevendo a configuracao")
  .write_config(
    path          = path,
    font_family   = typst_family,
    primary_color = primary_color,
    toc_style     = toc_style,
    cover         = cover,
    cover_image   = cover_image,
    cover_title_color = cover_title_color,
    cover_title_x = cover_title_x,
    cover_title_y = cover_title_y,
    back_cover    = back_cover,
    lang          = lang
  )

  assets_dest <- fs::path(path, "assets")
  fs::dir_create(assets_dest)
  fs::dir_copy(.assets_source(), assets_dest, overwrite = TRUE)

  cli::cli_progress_step("Escrevendo o esqueleto do relatorio")
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
    "*" = "Proximos passos:",
    " " = "1. Substitua {.file assets/logo.svg} pelo seu logo.",
    " " = "2. Abra {.file report.qmd} e comece a escrever.",
    " " = "3. Renderize com {.code quarto::quarto_render(\"report.qmd\")}.",
    " " = "",
    "i" = "Use {.fn BusinessReport::set_font}, {.fn set_toc_style} e",
    " " = "   {.fn set_primary_color} para ajustar o visual sem recriar o projeto."
  ))

  if (open) {
    open_report(path)
  }

  invisible(path)
}


#' Abra o arquivo principal de um projeto `BusinessReport` na IDE
#'
#' @param path Diretorio raiz do projeto. O padrao e `"."`.
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

.format_date <- function(date, lang = "pt") {
  if (lang == "pt") {
    months_pt <- c(
      "janeiro", "fevereiro", "marco", "abril",
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
