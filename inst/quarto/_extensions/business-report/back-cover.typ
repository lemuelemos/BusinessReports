// back-cover.typ
// Minimal back cover page for BusinessReport.

#let business-back-cover(
  primary-color: rgb("#1a3a5c"),
  font-family:   "Georgia",
) = {

  let text-on-dark = white
  let accent       = primary-color.lighten(40%)

  set page(
    paper:     "a4",
    margin:    0pt,
    numbering: none,
    header:    none,
    footer:    none,
  )
  set text(font: font-family)

  // Full-page coloured background
  block(
    width:  100%,
    height: 100%,
    fill:   primary-color,
    {
      // Top decorative bar in lighter shade
      place(top, rect(width: 100%, height: 0.8cm, fill: accent))

      // Bottom decorative bar
      place(bottom, rect(width: 100%, height: 0.8cm, fill: accent))

      // Centred content
      set align(center + horizon)
      set text(fill: text-on-dark)

      // Large decorative initial or geometric accent
      text(size: 80pt, weight: "bold", fill: white.transparentize(85%))[B]

      v(-1.5cm)

      // Wordmark / institution name area
      rect(
        width:  6cm,
        height: 2pt,
        fill:   white.transparentize(60%),
        radius: 1pt,
      )

      v(0.6cm)

      text(size: 9pt, tracking: 2pt, fill: white.transparentize(30%))[
        BUSINESSREPORT
      ]

      v(1.5cm)

      // Contact or URL placeholder
      text(size: 8.5pt, fill: white.transparentize(50%))[
        Gerado com o pacote R \
        #link("https://github.com/lemuelemos/BusinessReport")[BusinessReport]
      ]
    }
  )
}
