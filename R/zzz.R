# R/zzz.R

#' BusinessReport: Modelos profissionais de relatórios para Quarto/Typst
#'
#' Fornece modelos profissionais de relatórios em Quarto com renderização via
#' Typst para usos corporativos, analíticos e técnicos. Inclui capa e
#' contracapa opcionais, uma coleção curada de fontes e três estilos distintos
#' de sumário.
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
    "Use create_business_report() para iniciar um novo projeto de relatório.\n",
    "Use list_fonts() e list_toc_styles() para explorar as opções."
  )
}
