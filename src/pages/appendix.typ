#let appendix-letters = (
  "А",
  "Б",
  "В",
  "Г",
  "Д",
  "Е",
  "Ж",
  "И",
  "К",
  "Л",
  "М",
  "Н",
  "П",
  "Р",
  "С",
  "Т",
  "У",
  "Ф",
  "Х",
  "Ц",
  "Ш",
  "Щ",
  "Э",
  "Ю",
  "Я",
)

#let appendix-counter = counter("sibsiu-appendix")

#let appendix-page(title: none, body) = {
  pagebreak(weak: true)
  appendix-counter.step()

  context {
    let num = appendix-counter.get().first()
    let letter = appendix-letters.at(num - 1, default: str(num))
    let full-title = if title != none [Приложение #letter #title] else [Приложение #letter]

    // Невидимый заголовок для корректного отображения в содержании
    {
      show heading: none
      heading(level: 1, numbering: none, outlined: true)[#full-title]
    }

    align(center)[
      #text(size: 14pt, weight: "bold")[Приложение #letter] \
      #if title != none [
        #v(6pt)
        #text(size: 14pt, weight: "bold")[#title]
      ]
    ]

    v(18pt)

    // В приложениях рекомендован 12 кегль (п. 2.10)
    set text(size: 12pt)
    set par(first-line-indent: 1.25cm, leading: 1em, justify: true)

    body
  }
}
