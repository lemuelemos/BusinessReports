# R/fonts.R

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
    "Serifada", "Serifada", "Serifada",
    "Serifada", "Serifada", "Serifada", "Serifada",
    "Sem serifa", "Sem serifa", "Sem serifa",
    "Sem serifa", "Sem serifa", "Sem serifa", "Sem serifa"
  ),
  origin = c(
    "Microsoft/Monotype", "Hermann Zapf / Linotype", "Claude Garamond (revival)",
    "John Baskerville (revival)", "Sorkin Type", "Jacques Le Bailly", "Production Type",
    "Lukasz Dziedzic", "Adobe", "Mozilla / Carrois",
    "IBM", "Julieta Ulanovsky", "Google", "Rasmus Andersson"
  ),
  license = c(
    "Sistema", "Sistema", "OFL",
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

#' Liste todas as fontes disponíveis em `BusinessReport`
#'
#' @description
#' Retorna um data frame com metadados para cada fonte disponível em
#' `BusinessReport`. A coluna `id` é o valor usado em
#' [create_business_report()] e [set_font()].
#'
#' Fontes com `license = "Sistema"` costumam vir instaladas no sistema.
#' Fontes com `license = "OFL"` ou `"Apache 2.0"` precisam ser instaladas
#' separadamente. O Typst procura automaticamente nas pastas de fontes do
#' sistema. O Google Fonts pode ser usado para baixar essas fontes.
#'
#' @return Um data frame com as colunas `id`, `display_name`, `typst_family`,
#'   `style`, `origin`, `license` e `famous_use`.
#'
#' @examples
#' list_fonts()
#'
#' # Filtrar apenas as opções sem serifa
#' fonts <- list_fonts()
#' fonts[fonts$style == "Sem serifa", c("id", "display_name", "famous_use")]
#'
#' @export
list_fonts <- function() {
  .font_registry
}


#' Altere a fonte de um projeto `BusinessReport` existente
#'
#' @description
#' Atualiza `_extensions/business-report/_business-report-config.typ` no local,
#' modificando o valor de `font-family`. Re-renderize o documento Quarto para
#' ver o efeito.
#'
#' @param path Caminho para a raiz do projeto. O padrão é o diretório de
#'   trabalho atual.
#' @param font Identificador da fonte. Use [list_fonts()] para ver os valores
#'   válidos.
#'
#' @return `path`, invisivelmente.
#'
#' @examples
#' \dontrun{
#' set_font("meu-relatorio", font = "ibm-plex")
#' set_font("meu-relatorio", font = "merriweather")
#' }
#'
#' @export
set_font <- function(path = ".", font) {
  rlang::check_required(font)
  typst_family <- .check_font_id(font)
  .update_config_key(path, "font-family", glue::glue('"{typst_family}"'))
  cli::cli_inform(
    c("v" = "Fonte atualizada para {.strong {typst_family}}.",
      "i" = "Re-renderize seu arquivo {.file .qmd} para ver a mudança.")
  )
  invisible(path)
}
