// toc/toc-classic.typ
// Style 1 — Clássico
// Traditional typographic TOC: bold chapter entries in primary colour,
// dot leaders connecting titles to page numbers, indented subsections.

#let toc-classic(
  primary-color: rgb("#1a3a5c"),
  font-family:   "Georgia",
) = {

  let text-muted = luma(110)
  let rule-color = luma(215)

  // ── TOC title ────────────────────────────────────────────────────────────
  set text(font: font-family)
  v(1cm)
  text(size: 20pt, weight: "bold", fill: primary-color)[Sumário]
  v(0.3cm)
  line(length: 100%, stroke: 1.5pt + primary-color)
  v(0.8cm)

  // ── Entry styling ─────────────────────────────────────────────────────────

  // Level 1: chapter — bold, primary colour, larger, with dot leaders
  show outline.entry.where(level: 1): it => {
    v(6pt, weak: true)
    set text(size: 11pt, weight: "bold", fill: primary-color)
    grid(
      columns: (1fr, 2em),
      column-gutter: 4pt,
      align: (left + bottom, right + bottom),
      // Title with dot leaders
      box(width: 1fr)[
        #it.body
        #h(4pt)
        #box(width: 1fr)[
          #set text(weight: "regular", fill: rule-color, size: 10pt)
          #repeat[·]
        ]
      ],
      // Page number
      text(fill: primary-color)[#it.page],
    )
  }

  // Level 2: section — regular weight, dark grey, indented, dot leaders
  show outline.entry.where(level: 2): it => {
    v(2pt, weak: true)
    set text(size: 10pt, fill: luma(50))
    grid(
      columns: (1.8em, 1fr, 2em),
      column-gutter: 2pt,
      align: (left, left + bottom, right + bottom),
      [],  // indent spacer
      // Title with dot leaders
      box(width: 1fr)[
        #it.body
        #h(4pt)
        #box(width: 1fr)[
          #set text(fill: rule-color, size: 9pt)
          #repeat[·]
        ]
      ],
      // Page number
      text(fill: text-muted, size: 9.5pt)[#it.page],
    )
  }

  // Level 3: subsection — lighter, more indented, no leaders
  show outline.entry.where(level: 3): it => {
    v(1pt, weak: true)
    set text(size: 9.5pt, fill: luma(80), style: "italic")
    grid(
      columns: (3.6em, 1fr, 2em),
      column-gutter: 2pt,
      [],
      it.body,
      align(right, text(fill: text-muted, size: 9pt)[#it.page]),
    )
  }

  // ── Render outline ────────────────────────────────────────────────────────
  outline(title: none, depth: 3, indent: false)

  v(1cm)
}
