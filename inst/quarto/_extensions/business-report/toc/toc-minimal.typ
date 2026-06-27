// toc/toc-minimal.typ
// Style 3 - Minimalista

#let toc-minimal(
  primary-color: rgb("#1a3a5c"),
  font-family:   "Georgia",
) = {

  let text-dark  = luma(30)
  let text-muted = luma(140)
  let rule-color = luma(220)

  set text(font: font-family)
  v(1.5cm)
  text(size: 11pt, tracking: 3pt, fill: text-muted, weight: "regular")[SUMARIO]
  v(0.6cm)
  line(length: 100%, stroke: 0.5pt + rule-color)
  v(0.8cm)

  show outline.entry.where(level: 1): it => {
    v(12pt, weak: true)
    context {
      let entries = query(outline.entry.where(level: 1))
      if entries.len() > 0 and entries.first().location() != it.element.location() {
        v(-4pt)
        line(length: 100%, stroke: 0.3pt + rule-color)
        v(8pt)
      }
    }
    grid(
      columns: (1fr, auto),
      column-gutter: 1.5em,
      align: (left + bottom, right + bottom),
      text(size: 11.5pt, weight: "semibold", fill: text-dark)[#it.element.body],
      text(size: 10pt, fill: primary-color)[#it.page()],
    )
    v(2pt, weak: true)
  }

  show outline.entry.where(level: 2): it => {
    v(4pt, weak: true)
    pad(left: 1.5em)[
      #grid(
        columns: (1fr, auto),
        column-gutter: 1.5em,
        align: (left, right),
        text(size: 10pt, fill: luma(65))[#it.element.body],
        text(size: 9.5pt, fill: text-muted)[#it.page()],
      )
    ]
  }

  show outline.entry.where(level: 3): it => {
    v(2pt, weak: true)
    pad(left: 3em)[
      #grid(
        columns: (1fr, auto),
        column-gutter: 1.5em,
        align: (left, right),
        text(size: 9.5pt, fill: luma(110), style: "italic")[#it.element.body],
        text(size: 9pt, fill: text-muted)[#it.page()],
      )
    ]
  }

  outline(title: none, depth: 3, indent: auto)

  v(1.2cm)
  line(length: 100%, stroke: 0.5pt + rule-color)
}
