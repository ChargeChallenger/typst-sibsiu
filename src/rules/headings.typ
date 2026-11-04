#let sibsiu-headings(body) = {
  set heading(numbering: "1.1.1.1")
  show heading: set text(size: 14pt, weight: "bold", hyphenate: false)
  show heading.where(level: 1): set text(size: 16pt)
  show heading.where(level: 4): set text(weight: "regular")
  show heading: set block(above: 24pt, below: 24pt)
  show heading: set par(justify: true, first-line-indent: (amount: 1.25cm, all: true))
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    it
  }
  show heading.where(numbering: none): set align(center)
  show heading.where(numbering: none): set text(size: 16pt, weight: "bold")
  show heading.where(numbering: none): it => {
    pagebreak(weak: true)
    it.element
  }
  body
}
