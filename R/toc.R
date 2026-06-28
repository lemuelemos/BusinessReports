# R/toc.R

.toc_registry <- data.frame(
  id = 1L:4L,
  name = c("Classico", "Moderno", "Minimalista", "Cards"),
  description = c(
    paste0(
      "Estilo tipografico classico. ",
      "Entradas de capitulo em negrito com o acento da cor primaria. ",
      "Pontos de preenchimento conectando titulo e numero de pagina. ",
      "Secoes recuadas e subcapitulos em peso regular."
    ),
    paste0(
      "Estilo contemporaneo com barra lateral colorida. ",
      "Capitulos destacados com retangulo de cor primaria a esquerda. ",
      "Numeros de pagina em caixas coloridas. ",
      "Espacamento generoso entre entradas."
    ),
    paste0(
      "Estilo minimalista, com maximo espaco em branco. ",
      "Sem lideres de pontos nem decoracoes. ",
      "Numero de pagina alinhado a direita. ",
      "Hierarquia transmitida por tamanho de fonte e recuo."
    ),
    paste0(
      "Estilo em cards inspirado em relatorios executivos. ",
      "Capitulos aparecem em blocos com cabecalho destacado. ",
      "Subsecoes sao agrupadas dentro de cada card. ",
      "Mantem a mesma familia tipografica do restante do projeto."
    )
  ),
  typst_file = c("toc-classic.typ", "toc-modern.typ", "toc-minimal.typ", "toc-cards.typ"),
  stringsAsFactors = FALSE
)

#' Liste os estilos de sumario disponiveis em `BusinessReport`
#'
#' @description
#' Retorna um data frame descrevendo cada estilo de sumario. Passe o valor de
#' `id` (1, 2, 3 ou 4) para [create_business_report()] ou [set_toc_style()].
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


#' Altere o estilo do sumario de um projeto `BusinessReport` existente
#'
#' @description
#' Atualiza `_extensions/business-report/_business-report-config.typ` no local,
#' definindo `toc-style` para o valor escolhido. Re-renderize para ver o efeito.
#'
#' @param path Diretorio raiz do projeto. O padrao e o diretorio de trabalho
#'   atual.
#' @param style Inteiro: `1` (Classico), `2` (Moderno), `3` (Minimalista) ou
#'   `4` (Cards). Use [list_toc_styles()] para ver as descricoes.
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
  .inform_config_update(
    "Estilo do sumario atualizado para {.strong {toc_name}} (estilo {style}).",
    .envir = environment()
  )
  invisible(path)
}


#' Altere a cor primaria de destaque de um projeto `BusinessReport` existente
#'
#' @description
#' Atualiza `_extensions/business-report/_business-report-config.typ` com uma
#' nova cor primaria. A cor e aplicada a titulos, capa, sumario e elementos
#' decorativos ao longo do relatorio.
#'
#' @param path Diretorio raiz do projeto. O padrao e o diretorio de trabalho
#'   atual.
#' @param color Cor hexadecimal de seis digitos com `#`, por exemplo
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
  .inform_config_update(
    "Cor primaria atualizada para {.val {color}}.",
    .envir = environment()
  )
  invisible(path)
}


#' Ative ou desative a capa de um projeto `BusinessReport` existente
#'
#' @param path Diretorio raiz do projeto.
#' @param cover Logico. `TRUE` para incluir a capa; `FALSE` para remove-la.
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
  cover <- .check_flag(cover, "cover")
  .update_config_key(path, "cover", .bool_to_typst(cover))
  label <- if (cover) "ativada" else "desativada"
  .inform_config_update("Capa {label}.", rerender = FALSE, .envir = environment())
  invisible(path)
}


#' Ative ou desative a contracapa de um projeto `BusinessReport` existente
#'
#' @param path Diretorio raiz do projeto.
#' @param back_cover Logico. `TRUE` para incluir a contracapa; `FALSE` para
#'   remove-la.
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
  back_cover <- .check_flag(back_cover, "back_cover")
  .update_config_key(path, "back-cover", .bool_to_typst(back_cover))
  label <- if (back_cover) "ativada" else "desativada"
  .inform_config_update("Contracapa {label}.", rerender = FALSE, .envir = environment())
  invisible(path)
}
