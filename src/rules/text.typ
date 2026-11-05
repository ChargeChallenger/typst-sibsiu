#let sibsiu-text(body) = {
  set text(
    font: "Times New Roman",
    size: 14pt,
    lang: "ru",
  )

  set par(
    first-line-indent: (amount: 1.25cm, all: true),
    leading: 1em,
    spacing: 1em,
    justify: true,
  )

  body
}
