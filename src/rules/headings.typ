#let struct-names = (
  "лист замечаний",
  "аннотация",
  "содержание",
  "введение",
  "основные термины и определения",
  "заключение",
  "библиографический список",
  "список использованных источников",
)

// Извлечение чистого текста из заголовка
#let get-text(el) = {
  if type(el) == str { el } else if el == none { "" } else if el.has("text") { el.text } else if el.has("children") {
    el.children.map(get-text).join("")
  } else if el.has("body") { get-text(el.body) } else { "" }
}

// Проверка: является ли заголовок структурным
#let is-struct-heading(it) = {
  let clean-title = lower(get-text(it.body)).trim()
  it.numbering == none or (it.level == 1 and clean-title in struct-names)
}

#let sibsiu-headings(body) = {
  set heading(numbering: "1.1.1.1")

  // Начертания: 1-3 уровни полужирные, 4-й — обычный
  show heading: set text(size: 14pt, weight: "bold", hyphenate: false)
  show heading.where(level: 1): set text(size: 16pt)
  show heading.where(level: 4): set text(weight: "regular")

  // 1. Отображение заголовков в тексте
  show heading: it => {
    if is-struct-heading(it) {
      pagebreak(weak: true)

      // Не даем "Введению" увеличивать счетчик глав
      if it.level == 1 and it.numbering != none {
        counter(heading).update(n => n - 1)
      }

      align(center)[
        #set par(first-line-indent: 0pt, justify: false)
        #text(size: 16pt, weight: "bold")[#upper(it.body)]
      ]
      v(24pt)
    } else {
      if it.level == 1 {
        pagebreak(weak: true)
      } else {
        v(24pt, weak: true)
      }

      block(width: 100%)[
        #set par(
          first-line-indent: 0pt,
          leading: 1em,
          justify: true,
        )
        // Красная строка 1.25 см
        #h(1.25cm)
        #if it.numbering != none {
          counter(heading).display(it.numbering)
          h(0.25em)
        }
        #it.body
      ]

      v(24pt, weak: true)
    }
  }

  // 2. Отображение в СОДЕРЖАНИИ (без дублирования и без номеров у структурных)
  show outline.entry: it => {
    let is-struct = if it.element.func() == heading {
      is-struct-heading(it.element)
    } else {
      false
    }

    // Если раздел структурный (Введение и т.д.) — префикс отсутствует (none),
    // иначе оставляем стандартный номер (it.prefix())
    let prefix = if is-struct { none } else { it.prefix() }

    link(it.element.location(), it.indented(prefix, it.inner()))
  }

  body
}
