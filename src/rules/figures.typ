#let sibsiu-figures(body) = {
  set figure(gap: 12pt)
  set figure.caption(separator: [ – ])
  show figure.caption: set par(first-line-indent: 0pt)
  show figure.caption: set text(size: 14pt)

  // Рисунки: по центру, интервалы по 12 пт (п. 2.5)
  show figure.where(kind: image): set figure(supplement: [Рисунок])
  show figure.where(kind: image): it => {
    v(12pt, weak: true)
    align(center)[
      #it.body
      #v(12pt)
      #it.caption
    ]
    v(12pt, weak: true)
  }

  // Таблицы: подпись над таблицей, интервалы по 12 пт (п. 2.6)
  show figure.where(kind: table): set figure(supplement: [Таблица])
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set block(breakable: true)
  show figure.where(kind: table): it => {
    v(12pt, weak: true)
    show figure.caption: set align(left)
    it
    v(12pt, weak: true)
  }

  // Убираем абзацный отступ в ячейках
  show table.cell: set par(first-line-indent: 0pt)

  body
}
