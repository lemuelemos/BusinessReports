# R/zzz.R

#' @keywords internal
"_PACKAGE"

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "BusinessReport ", utils::packageVersion("BusinessReport"), " loaded.\n",
    "Use create_business_report() to start a new report project.\n",
    "Use list_fonts() and list_toc_styles() to explore options."
  )
}
