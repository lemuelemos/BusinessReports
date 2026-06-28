# R/zzz.R

#' BusinessReport: Modelos profissionais de relatorios para Quarto/Typst
#'
#' Fornece modelos profissionais de relatorios em Quarto com renderizacao via
#' Typst para usos corporativos, analiticos e tecnicos. Inclui capa e
#' contracapa opcionais, uma colecao curada de fontes e tres estilos distintos
#' de sumario.
#'
#' @keywords internal
"_PACKAGE"

.onAttach <- function(libname, pkgname) {
  version <- tryCatch(
    as.character(utils::packageVersion(pkgname)),
    error = function(...) utils::packageDescription(pkgname, fields = "Version")
  )

  packageStartupMessage(
    "BusinessReport ", version, " carregado.\n",
    "Use create_business_report() para iniciar um novo projeto de relatorio.\n",
    "Use list_fonts() e list_toc_styles() para explorar as opcoes."
  )
}
