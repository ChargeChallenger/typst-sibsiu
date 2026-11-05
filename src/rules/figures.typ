#let sibsiu-figures(body) = {
  set figure(gap: 12pt)
  set figure.caption(separator: [ – ])
  show figure: set block(below: 12pt, above: 12pt)
  show figure.caption: set par(first-line-indent: 0pt)

  // Рисунки
  show figure.where(kind: image): set figure(supplement: [Рисунок])
  show figure.where(kind: image): show figure.caption: set align(center)

  // Таблицы
  show figure.where(kind: table): set figure(supplement: [Таблица])
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): show figure.caption: set align(left)
  show figure.where(kind: table): set block(breakable: true)

  // Убрать абзацный отступ внутри таблицы
  show table.cell: set par(first-line-indent: 0pt)

  body
}
