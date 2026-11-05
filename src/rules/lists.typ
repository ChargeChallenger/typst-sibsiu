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
  // Маркированные перечисления: короткое тире, отступ 1.25 см (рис. 2)
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

  // Нумерованные перечисления (п. 2.4, рис. 3):
  // 1-й уровень: буквы со скобкой а), б), отступ 1.25 см
  // 2-й уровень: арабские цифры со скобкой 1), 2), отступ 1.75 см
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

  // Смещение 2-го уровня до 1.75 см (1.25 см + 0.5 см)
  show enum.where(full: true): it => {
    set enum(indent: 1.75cm) if it.level > 1
    it
  }

  body
}
