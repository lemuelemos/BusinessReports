normalize_text <- function(paths, replacements) {
  for (path in paths) {
    contents <- readLines(path, warn = FALSE, encoding = "UTF-8")
    updated <- contents

    for (i in seq_along(replacements)) {
      updated <- gsub(
        names(replacements)[i],
        replacements[[i]],
        updated,
        fixed = TRUE,
        useBytes = TRUE
      )
    }

    if (!identical(contents, updated)) {
      writeLines(updated, path, useBytes = TRUE)
    }
  }
}

if (nzchar(Sys.getenv("QUARTO_PANDOC"))) {
  Sys.setenv(RSTUDIO_PANDOC = Sys.getenv("QUARTO_PANDOC"))
} else if (!nzchar(Sys.getenv("RSTUDIO_PANDOC"))) {
  quarto_pandoc <- "C:/Users/lemue/AppData/Local/Programs/Quarto/bin/tools"

  if (dir.exists(quarto_pandoc)) {
    Sys.setenv(RSTUDIO_PANDOC = quarto_pandoc)
  }
}

try(Sys.setlocale("LC_ALL", "Portuguese_Brazil.utf8"), silent = TRUE)

roxygen2::roxygenise(".")
pkgdown::build_site_github_pages(new_process = FALSE, install = FALSE)

normalize_text(
  paths = c(
    "man/BusinessReport-package.Rd",
    list.files("docs", pattern = "\\.(html|md|txt)$", recursive = TRUE, full.names = TRUE)
  ),
  replacements = c(
    "Changelog" = "Novidades",
    "Report bugs at" = "Relate problemas em",
    "Useful links:" = "Links úteis:",
    "Maintainer" = "Mantenedor",
    "**Maintainer**:" = "**Mantenedor**:",
    "\\strong{Maintainer}:" = "\\strong{Mantenedor}:"
  )
)
