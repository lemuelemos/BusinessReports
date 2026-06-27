// toc/toc-classic.typ
// Style 1 - Classico

#let toc-classic(
  primary-color: rgb("#1a3a5c"),
  font-family:   "Georgia",
) = {

  let text-muted = luma(110)
  let rule-color = luma(215)

  set text(font: font-family)
  v(1cm)
  text(size: 20pt, weight: "bold", fill: primary-color)[Sumario]
  v(0.3cm)
  line(length: 100%, stroke: 1.5pt + primary-color)
  v(0.8cm)

  show outline.entry.where(level: 1): it => {
    v(6pt, weak: true)
    set text(size: 11pt, weight: "bold", fill: primary-color)
    grid(
      columns: (1fr, 2em),
      column-gutter: 4pt,
      align: (left + bottom, right + bottom),
      box(width: 1fr)[
        #it.element.body
        #h(4pt)
        #box(width: 1fr)[
          #set text(weight: "regular", fill: rule-color, size: 10pt)
          #repeat[.]
        ]
      ],
      text(fill: primary-color)[#it.page()],
    )
  }

  show outline.entry.where(level: 2): it => {
    v(2pt, weak: true)
    set text(size: 10pt, fill: luma(50))
    grid(
      columns: (1.8em, 1fr, 2em),
      column-gutter: 2pt,
      align: (left, left + bottom, right + bottom),
      [],
      box(width: 1fr)[
        #it.element.body
        #h(4pt)
        #box(width: 1fr)[
          #set text(fill: rule-color, size: 9pt)
          #repeat[.]
        ]
      ],
      text(fill: text-muted, size: 9.5pt)[#it.page()],
    )
  }

  show outline.entry.where(level: 3): it => {
    v(1pt, weak: true)
    set text(size: 9.5pt, fill: luma(80), style: "italic")
    grid(
      columns: (3.6em, 1fr, 2em),
      column-gutter: 2pt,
      [],
      it.element.body,
      align(right, text(fill: text-muted, size: 9pt)[#it.page()]),
    )
  }

  outline(title: none, depth: 3, indent: auto)

  v(1cm)
}
