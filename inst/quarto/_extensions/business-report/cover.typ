// cover.typ
// Professional cover page for BusinessReport.
// Called from typst-template.typ when _show-cover is true.

#let business-cover(
  title:         "",
  authors:       none,
  date:          "",
  primary-color: rgb("#1a3a5c"),
  cover-image:   none,
  cover-title-color: white,
  cover-title-x: 18mm,
  cover-title-y: 110mm,
  logo-path:     none,
) = {
  if cover-image != none {
    set page(
      paper:     "a4",
      margin:    0pt,
      numbering: none,
      header:    none,
      footer:    none,
    )

    place(top + left, image(cover-image, width: 210mm, height: 297mm, fit: "cover"))
    place(
      top + left,
      dx: cover-title-x,
      dy: cover-title-y,
      box(
        width: 140mm,
        text(size: 30pt, weight: "bold", tracking: -0.3pt, fill: cover-title-color)[#title]
      )
    )
  } else {
    let header-bg    = primary-color
    let accent-bar   = primary-color.lighten(50%)
    let footer-bg    = primary-color
    let text-on-dark = white
    let text-body    = luma(30)

    set page(
      paper:     "a4",
      margin:    0pt,
      numbering: none,
      header:    none,
      footer:    none,
    )

    block(
      width:  100%,
      height: 11cm,
      fill:   header-bg,
      inset:  (x: 3.5cm, top: 2cm, bottom: 1.5cm),
      {
        set align(bottom + left)

        if logo-path != none {
          box(height: 2cm)[
            #image(logo-path, height: 2cm, fit: "contain")
          ]
          v(0.6cm)
        } else {
          v(2.6cm)
        }

        set text(fill: text-on-dark)
        text(size: 30pt, weight: "bold", tracking: -0.3pt)[#title]
      }
    )

    rect(width: 100%, height: 0.35cm, fill: primary-color.lighten(30%))

    block(
      width:  100%,
      height: 1fr,
      inset:  (x: 3.5cm, top: 2.2cm, bottom: 1cm),
      {
        set align(top + left)
        set text(fill: text-body)

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

            if authors != none {
              text(size: 12pt, weight: "semibold")[#authors]
            }

            v(0.4cm)
            text(size: 9.5pt, fill: luma(120))[#date]
          }
        )
      }
    )

    rect(width: 100%, height: 1cm, fill: footer-bg)
  }
}
