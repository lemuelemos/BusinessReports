# BusinessReport (development version)

# BusinessReport 0.1.0

## New features

* `create_business_report()` scaffolds a complete Quarto/Typst project with a
  single function call. Options control the title, author, institution, date,
  font, accent colour, TOC style, and the presence of cover and back-cover
  pages.

* `list_fonts()` displays the 14 curated typefaces available, spanning
  seven Serif and seven Sans-Serif families drawn from renowned financial
  publications and open-source typeface projects.

* `set_font()`, `set_toc_style()`, `set_primary_color()`, `toggle_cover()`,
  and `toggle_back_cover()` allow post-creation adjustments to any project
  without re-scaffolding.

* Three table of contents styles are provided: **Classic** (dot leaders,
  chapter numbers in accent colour), **Modern** (coloured sidebar bar,
  page-number badge), and **Minimal** (tracked caps header, fine rule,
  hierarchy by size only).

* Optional cover page features a full-bleed colour band, placeholder logo,
  title in white, author grid with accent bar, and date. Optional back-cover
  features a solid accent background, monogram, and package wordmark.

* The Quarto extension (`business-report-typst` format) uses a Typst template
  that reads configuration from a generated `_business-report-config.typ` file,
  making post-creation edits robust and version-control friendly.
