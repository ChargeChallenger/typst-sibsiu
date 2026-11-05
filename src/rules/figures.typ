#let sibsiu-figures(body) = {
  // 1. Общие настройки для всех фигур по ГОСТ
  set figure(gap: 12pt, supplement: [Рисунок])
  set figure.caption(separator: [ – ])
  show figure.caption: set par(first-line-indent: 0pt)
  show figure.caption: set text(size: 14pt)

  // 2. Таблицы: подпись СВЕРХУ СЛЕВА, заголовок «Таблица»
  show figure.where(kind: table): set figure(supplement: [Таблица])
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set block(breakable: true)
  show figure.where(kind: table): it => {
    v(12pt, weak: true)
    show figure.caption: set align(left)
    it
    v(12pt, weak: true)
  }

  // 3. Все остальные фигуры (картинки, диаграммы Ганта, схемы):
  // подпись СНИЗУ ПО ЦЕНТРУ, интервалы по 12 пт (п. 2.5 методички)
  show figure: it => {
    if it.kind == table {
      it // таблицы уже обработаны правилом выше
    } else {
      v(12pt, weak: true)
      align(center)[
        #it.body
        #v(12pt)
        #it.caption
      ]
      v(12pt, weak: true)
    }
  }

  // Убираем абзацный отступ в ячейках таблиц
  show table.cell: set par(first-line-indent: 0pt)

  body
}
