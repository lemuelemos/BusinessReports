# R/toc.R

.toc_registry <- data.frame(
  id = 1L:3L,
  name = c("Clássico", "Moderno", "Minimalista"),
  description = c(
    paste0(
      "Estilo tipográfico clássico. ",
      "Entradas de capítulo em negrito com o acento da cor primária. ",
      "Pontos de preenchimento conectando título e número de página. ",
      "Seções recuadas e subcapítulos em peso regular."
    ),
    paste0(
      "Estilo contemporâneo com barra lateral colorida. ",
      "Capítulos destacados com retângulo de cor primária à esquerda. ",
      "Números de página em caixas coloridas. ",
      "Espaçamento generoso entre entradas."
    ),
    paste0(
      "Estilo minimalista, com máximo espaço em branco. ",
      "Sem líderes de pontos nem decorações. ",
      "Número de página alinhado à direita. ",
      "Hierarquia transmitida por tamanho de fonte e recuo."
    )
  ),
  typst_file = c("toc-classic.typ", "toc-modern.typ", "toc-minimal.typ"),
  stringsAsFactors = FALSE
)

#' Liste os três estilos de sumário disponíveis em `BusinessReport`
#'
#' @description
#' Retorna um data frame descrevendo cada estilo de sumário. Passe o valor de
#' `id` (1, 2 ou 3) para [create_business_report()] ou [set_toc_style()].
#'
#' @return Um data frame com as colunas `id`, `name` e `description`.
#'
#' @examples
#' list_toc_styles()
#'
#' @export
list_toc_styles <- function() {
  .toc_registry[, c("id", "name", "description")]
}


#' Altere o estilo do sumário de um projeto `BusinessReport` existente
#'
#' @description
#' Atualiza `_extensions/business-report/_business-report-config.typ` no local,
#' definindo `toc-style` para o valor escolhido. Re-renderize para ver o efeito.
#'
#' @param path Diretório raiz do projeto. O padrão é o diretório de trabalho
#'   atual.
#' @param style Inteiro: `1` (Clássico), `2` (Moderno) ou `3` (Minimalista).
#'   Use [list_toc_styles()] para ver as descrições.
#'
#' @return `path`, invisivelmente.
#'
#' @examples
#' \dontrun{
#' set_toc_style("meu-relatorio", style = 2)
#' }
#'
#' @export
set_toc_style <- function(path = ".", style) {
  rlang::check_required(style)
  style <- .check_toc_style(style)
  .update_config_key(path, "toc-style", as.character(style))
  toc_name <- .toc_registry[.toc_registry[["id"]] == style, "name"]
  cli::cli_inform(
    c("v" = "Estilo do sumário atualizado para {.strong {toc_name}} (estilo {style}).",
      "i" = "Re-renderize seu arquivo {.file .qmd} para ver a mudança.")
  )
  invisible(path)
}


#' Altere a cor primária de destaque de um projeto `BusinessReport` existente
#'
#' @description
#' Atualiza `_extensions/business-report/_business-report-config.typ` com uma
#' nova cor primária. A cor é aplicada a títulos, capa, sumário e elementos
#' decorativos ao longo do relatório.
#'
#' @param path Diretório raiz do projeto. O padrão é o diretório de trabalho
#'   atual.
#' @param color Cor hexadecimal de seis dígitos com `#`, por exemplo
#'   `"#2d6a9a"`.
#'
#' @return `path`, invisivelmente.
#'
#' @examples
#' \dontrun{
#' set_primary_color("meu-relatorio", color = "#8b1a1a")
#' set_primary_color("meu-relatorio", color = "#1a5c3a")
#' }
#'
#' @export
set_primary_color <- function(path = ".", color) {
  rlang::check_required(color)
  .check_color(color)
  .update_config_key(path, "primary-color", glue::glue('rgb("{color}")'))
  cli::cli_inform(
    c("v" = "Cor primária atualizada para {.val {color}}.",
      "i" = "Re-renderize seu arquivo {.file .qmd} para ver a mudança.")
  )
  invisible(path)
}


#' Ative ou desative a capa de um projeto `BusinessReport` existente
#'
#' @param path Diretório raiz do projeto.
#' @param cover Lógico. `TRUE` para incluir a capa; `FALSE` para removê-la.
#'
#' @return `path`, invisivelmente.
#'
#' @examples
#' \dontrun{
#' toggle_cover("meu-relatorio", cover = FALSE)
#' }
#'
#' @export
toggle_cover <- function(path = ".", cover) {
  rlang::check_required(cover)
  bool_val <- if (isTRUE(cover)) "true" else "false"
  .update_config_key(path, "cover", bool_val)
  label <- if (isTRUE(cover)) "ativada" else "desativada"
  cli::cli_inform(c("v" = "Capa {label}."))
  invisible(path)
}


#' Ative ou desative a contracapa de um projeto `BusinessReport` existente
#'
#' @param path Diretório raiz do projeto.
#' @param back_cover Lógico. `TRUE` para incluir a contracapa; `FALSE` para
#'   removê-la.
#'
#' @return `path`, invisivelmente.
#'
#' @examples
#' \dontrun{
#' toggle_back_cover("meu-relatorio", back_cover = FALSE)
#' }
#'
#' @export
toggle_back_cover <- function(path = ".", back_cover) {
  rlang::check_required(back_cover)
  bool_val <- if (isTRUE(back_cover)) "true" else "false"
  .update_config_key(path, "back-cover", bool_val)
  label <- if (isTRUE(back_cover)) "ativada" else "desativada"
  cli::cli_inform(c("v" = "Contracapa {label}."))
  invisible(path)
}
