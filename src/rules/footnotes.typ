#let sibsiu-footnotes(body) = {
  set footnote(numbering: n => [#n)])
  set footnote.entry(
    separator: line(length: 30%, stroke: 0.5pt),
    indent: 1.25cm,
  )
  show footnote.entry: set text(size: 10pt)
  // Постраничный сброс нумерации сносок
  set page(header: context counter(footnote).update(0))
  body
}
