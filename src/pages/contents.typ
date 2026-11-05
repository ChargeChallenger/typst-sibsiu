#let contents() = {
  // Структурный заголовок СОДЕРЖАНИЕ (не попадает в оглавление)
  heading(level: 1, numbering: none, outlined: false)[СОДЕРЖАНИЕ]

  // Заполнитель отточием (. . .)
  set outline.entry(fill: repeat([. ]))

  // Смещение уровней по ГОСТ и п. 2.3 методички:
  // 1-й уровень: 0 см, 2-й: 0.5 см, 3-й: 1.0 см
  outline(title: none, indent: 0.5cm)

  pagebreak(weak: true)
}
