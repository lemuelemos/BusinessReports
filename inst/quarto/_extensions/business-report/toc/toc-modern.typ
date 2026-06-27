// toc/toc-modern.typ
// Style 2 — Moderno
// Contemporary TOC with coloured left-side accent bars for chapter entries
// and page numbers in small coloured boxes. Generous whitespace throughout.

#let toc-modern(
  primary-color: rgb("#1a3a5c"),
  font-family:   "Georgia",
) = {

  let accent-light = primary-color.lighten(75%)
  let text-muted   = luma(110)
  let page-box-bg  = primary-color.lighten(88%)

  // ── TOC title ─────────────────────────────────────────────────────────────
  set text(font: font-family)
  v(1cm)

  // Title row with large decorative number
  grid(
    columns: (auto, 1fr),
    column-gutter: 1em,
    align: center + horizon,
    text(size: 48pt, weight: "bold", fill: primary-color.lighten(82%))[S],
    {
      text(size: 21pt, weight: "bold", fill: primary-color)[Sumário]
      v(0.15cm)
      line(length: 100%, stroke: 1pt + primary-color.lighten(60%))
    }
  )
  v(1cm)

  // ── Entry styling ─────────────────────────────────────────────────────────

  // Level 1: chapter — accent sidebar + coloured page badge
  show outline.entry.where(level: 1): it => {
    v(10pt, weak: true)
    block(width: 100%, inset: (left: 0pt))[
      #grid(
        columns: (4pt, 1fr, auto),
        column-gutter: 0.9em,
        align: (top, top + left, top + right),

        // Coloured left bar
        rect(
          width:  100%,
          height: 1.4em + 2pt,
          fill:   primary-color,
          radius: 1pt,
        ),

        // Title
        {
          set text(size: 11.5pt, weight: "bold", fill: primary-color)
          pad(top: 1pt, it.body)
        },

        // Page number badge
        {
          set align(right)
          block(
            fill:   page-box-bg,
            stroke: 0.5pt + primary-color.lighten(60%),
            inset:  (x: 0.5em, y: 0.25em),
            radius: 2pt,
          )[
            #set text(size: 9.5pt, weight: "bold", fill: primary-color)
            #it.page
          ]
        }
      )
    ]
  }

  // Level 2: section — lighter bar, regular text
  show outline.entry.where(level: 2): it => {
    v(4pt, weak: true)
    block(
      width:   100%,
      inset:   (left: 1.3em),
    )[
      #grid(
        columns: (3pt, 1fr, auto),
        column-gutter: 0.7em,
        align: (center + horizon, left + horizon, right + horizon),

        // Lighter left accent
        rect(
          width:  100%,
          height: 0.8em,
          fill:   accent-light,
          radius: 1pt,
        ),

        // Title
        text(size: 10pt, fill: luma(50))[#it.body],

        // Page number
        text(size: 9.5pt, fill: text-muted)[#it.page],
      )
    ]
  }

  // Level 3: subsection — minimal, no bar, italic
  show outline.entry.where(level: 3): it => {
    v(2pt, weak: true)
    block(inset: (left: 2.8em))[
      #set text(size: 9.5pt, fill: luma(90), style: "italic")
      #grid(
        columns: (1fr, auto),
        column-gutter: 0.5em,
        it.body,
        text(fill: text-muted)[#it.page],
      )
    ]
  }

  // ── Render outline ─────────────────────────────────────────────────────────
  outline(title: none, depth: 3, indent: false)

  v(0.8cm)
}
