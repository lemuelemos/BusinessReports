// typst-show.typ
// Entry point injected by Quarto. Quarto provides `title`, `authors`, and
// `date` as Typst variables from the document YAML front matter.
// All visual configuration is read from `_business-report-config.typ`.

#import "typst-template.typ": business-report-format

#show: business-report-format.with(
  title:   title,
  authors: authors,
  date:    date,
)
