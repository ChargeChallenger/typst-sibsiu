#let sibsiu-figures(body) = {
  set figure(gap: 12pt)
  set figure.caption(separator: [ - ])
  show figure: set block(below: 12pt, above: 12pt)
  show figure.where(kind: image): set figure(supplement: [Рисунок])
  show figure.where(kind: table): set figure(supplement: [Таблица])
  show figure.where(kind: table): set figure.caption(position: top)
  body
}