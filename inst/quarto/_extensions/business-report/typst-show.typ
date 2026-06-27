// typst-show.typ
// Entry point injected by Quarto/Pandoc.
// Metadata is passed via Pandoc placeholders instead of assuming Typst
// variables are pre-bound in the generated report.typ.

#show: business-report-format.with(
$if(title)$
  title: [$title$],
$endif$
$if(by-author)$
  authors: [
$for(by-author)$
    $if(by-author.name)$$by-author.name$$else$$by-author$$endif$$if(by-author.affiliation)$
    $by-author.affiliation$
$endif$$sep$

$endfor$
  ],
$endif$
$if(date)$
  date: [$date$],
$endif$
)
