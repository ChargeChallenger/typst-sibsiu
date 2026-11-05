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
  set list(marker: [–], indent: 1.25cm)
  set enum(full: true, indent: 1.25cm, numbering: (..n) => {
    let p = n.pos()
    if p.len() == 1 { ru-letters.at(p.at(0) - 1) + ")" } else { str(p.last()) + ")" }
  })
  body
}
