// cover.typ
// Professional cover page for BusinessReport.
// Called from typst-template.typ when _show-cover is true.

#let business-cover(
  title:         "",
  authors:       (),
  date:          "",
  primary-color: rgb("#1a3a5c"),
  logo-path:     none,
) = {

  // ── Derived colours ──────────────────────────────────────────────────────
  let header-bg    = primary-color
  let accent-bar   = primary-color.lighten(50%)
  let footer-bg    = primary-color
  let text-on-dark = white
  let text-light   = luma(90)
  let text-body    = luma(30)

  // ── Cover page setup: zero margins, no header/footer ────────────────────
  set page(
    paper:     "a4",
    margin:    0pt,
    numbering: none,
    header:    none,
    footer:    none,
  )

  // ── Layout: top band + content area + bottom strip ───────────────────────
  // Top coloured band (≈38 % of A4 height ≈ 11 cm)
  block(
    width:  100%,
    height: 11cm,
    fill:   header-bg,
    inset:  (x: 3.5cm, top: 2cm, bottom: 1.5cm),
    {
      set align(bottom + left)

      // Logo (optional)
      if logo-path != none {
        box(height: 2cm)[
          #image(logo-path, height: 2cm, fit: "contain")
        ]
        v(0.6cm)
      } else {
        v(2.6cm)
      }

      // Title
      set text(fill: text-on-dark, font: "inherit")
      text(size: 30pt, weight: "bold", tracking: -0.3pt)[#title]
    }
  )

  // Thin accent separator
  rect(width: 100%, height: 0.35cm, fill: primary-color.lighten(30%))

  // Content block (authors, institution, date)
  block(
    width:  100%,
    height: 1fr,
    inset:  (x: 3.5cm, top: 2.2cm, bottom: 1cm),
    {
      set align(top + left)
      set text(fill: text-body)

      // Vertical accent bar + author block
      grid(
        columns: (0.4cm, 1fr),
        column-gutter: 1.2cm,
        rect(
          width:  100%,
          height: 100%,
          fill:   accent-bar,
          radius: 2pt,
        ),
        {
          set par(leading: 0.5em)

          // Authors
          if type(authors) == array and authors.len() > 0 {
            for auth in authors {
              if type(auth) == dictionary {
                let name = auth.at("name", default: "")
                let aff  = auth.at("affiliation", default: "")
                text(size: 12pt, weight: "semibold")[#name]
                if aff != "" {
                  linebreak()
                  text(size: 9.5pt, fill: luma(100))[#aff]
                }
              } else {
                text(size: 12pt, weight: "semibold")[#str(auth)]
              }
              v(0.5cm)
            }
          }

          // Date
          v(0.4cm)
          text(size: 9.5pt, fill: luma(120))[#date]
        }
      )
    }
  )

  // Bottom coloured strip
  rect(width: 100%, height: 1cm, fill: footer-bg)
}
