// toc/toc-cards.typ
// Style 4 - Cards

#let toc-cards(
  primary-color: rgb("#1a3a5c"),
  font-family:   "Georgia",
) = {

  let accent-dark  = primary-color.darken(25%)
  let accent-light = primary-color.lighten(78%)
  let text-dark    = luma(30)
  let text-muted   = luma(110)
  let surface      = luma(247)

  set text(font: font-family)
  v(0.7cm)

  stack(dir: ltr, spacing: 0pt,
    box(
      fill: primary-color,
      inset: (x: 14pt, y: 10pt),
      radius: (top-left: 8pt, bottom-left: 0pt, top-right: 0pt, bottom-right: 0pt),
      text(size: 16pt, weight: "bold", fill: white)[Sumario]
    ),
    align(bottom,
      line(length: 100%, stroke: 2pt + primary-color)
    )
  )

  v(0.5cm)

  context {
    let cards = query(heading.where(level: 1))
    let rendered = cards.enumerate().map(((idx, cap)) => {
      let secs = if idx + 1 < cards.len() {
        query(
          heading.where(level: 2)
            .after(cap.location())
            .before(cards.at(idx + 1).location())
        )
      } else {
        query(heading.where(level: 2).after(cap.location()))
      }

      box(
        width: 100%,
        fill: surface,
        stroke: 0.6pt + accent-light,
        radius: 6pt,
        inset: 0pt,
        clip: true,
        stack(dir: ttb,
          box(
            width: 100%,
            fill: primary-color,
            inset: (x: 12pt, y: 8pt),
            grid(
              columns: (auto, 1fr, auto),
              column-gutter: 8pt,
              align: (center + horizon, left + horizon, right + horizon),
              box(
                fill: accent-dark,
                inset: (x: 7pt, y: 4pt),
                radius: 3pt,
                text(size: 11pt, weight: "bold", fill: white)[#(idx + 1)]
              ),
              text(size: 10.5pt, weight: "bold", fill: white)[#cap.body],
              box(
                fill: white,
                inset: (x: 7pt, y: 4pt),
                radius: 3pt,
                text(size: 9pt, weight: "bold", fill: primary-color)[#counter(page).at(cap.location()).first()]
              )
            )
          ),
          box(
            width: 100%,
            inset: (x: 12pt, top: 8pt, bottom: 8pt),
            if secs.len() > 0 {
              stack(
                dir: ttb,
                spacing: 4pt,
                ..secs.map(sec =>
                  grid(
                    columns: (auto, 1fr, auto),
                    column-gutter: 6pt,
                    align: (top, left + horizon, right + horizon),
                    circle(radius: 2pt, fill: primary-color),
                    text(size: 8.5pt, fill: text-dark)[#sec.body],
                    text(size: 8pt, fill: text-muted)[#counter(page).at(sec.location()).first()],
                  )
                )
              )
            } else {
              text(size: 8.5pt, fill: text-muted, style: "italic")[Sem secoes de segundo nivel]
            }
          )
        )
      )
    })

    grid(columns: (1fr, 1fr), gutter: 5mm, ..rendered)
  }

  v(0.8cm)
}
