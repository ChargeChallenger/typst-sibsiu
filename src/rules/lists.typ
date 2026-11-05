#let ru-letters = (
  "а",
  "б",
  "в",
  "г",
  "д",
  "е",
  "ж",
  "и",
  "к",
  "л",
  "м",
  "н",
  "п",
  "р",
  "с",
  "т",
  "у",
  "ф",
  "х",
  "ц",
  "ш",
  "щ",
  "э",
  "ю",
  "я",
)

#let sibsiu-lists(body) = {
  // Маркированные перечисления: короткое тире, отступ 1.25 см (п. 2.4, рис. 2)
  show list: it => [
    #for item in it.children [
      #set par(
        first-line-indent: 1.25cm,
        leading: 1em,
        justify: true,
      )
      – #item.body
    ]
  ]

  // Нумерованные перечисления (п. 2.4, рис. 3 методички):
  // 1-й уровень: а), б), отступ 1.25 см
  // 2-й уровень: 1), 2), отступ 1.75 см
  set enum(
    full: true,
    indent: 1.25cm,
    body-indent: 0.5em,
    numbering: (..n) => {
      let p = n.pos()
      if p.len() == 0 {
        ""
      } else if p.len() == 1 {
        let idx = p.last()
        ru-letters.at(idx - 1, default: str(idx)) + ")"
      } else {
        str(p.last()) + ")"
      }
    },
  )

  // Любой вложенный enum смещается вправо на 0.5 см (1.25 + 0.5 = 1.75 см по рис. 3)
  show enum: it => {
    set enum(indent: 0.5cm)
    it
  }

  body
}
