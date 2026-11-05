#import "../meta.typ": meta
#import "../kinds.typ": resolve-kind
#import "parts.typ": institution-header, underlined-field

#let titlepage(..overrides) = {
  // На титульном листе номер не выводится
  set page(numbering: none)

  context {
    let m = meta.get() + overrides.named()
    let kind-info = resolve-kind(m.at("kind", default: "coursework"))

    let discipline = m.at("discipline", default: none)
    let topic = m.at("title", default: "")
    let group = m.at("group", default: "")

    let student-raw = m.at("author", default: "")
    let student-short = if type(student-raw) == dictionary {
      student-raw.at("short", default: "")
    } else {
      student-raw
    }

    let supervisor-raw = m.at("supervisor", default: none)
    let supervisor-full = if type(supervisor-raw) == dictionary {
      supervisor-raw.at("full", default: supervisor-raw.at("short", default: ""))
    } else if supervisor-raw != none {
      str(supervisor-raw)
    } else {
      ""
    }

    // Число 2026 печатается как «2026 г.», строка — как есть
    let year-raw = m.at("year", default: datetime.today().year())
    let year = if type(year-raw) == int [#year-raw г.] else [#year-raw]
    let city = m.at("city", default: "Новокузнецк")

    // Размеры и интервалы титула — как в проверенном оформлении (14 pt)
    set par(first-line-indent: 0pt, leading: 0.95em, justify: false)

    institution-header(
      university: m.at("university", default: "«Сибирский государственный индустриальный университет»"),
      department: m.at("department", default: "Кафедра прикладных информационных технологий и программирования"),
    )

    v(24pt)

    align(center)[
      #text(weight: "bold")[#kind-info.work-type]
    ]

    v(16pt)

    if discipline != none and discipline != "" [
      #align(center)[по дисциплине «#discipline»]
    ]
    align(center)[на тему «#topic»]

    v(12pt)

    align(right)[
      #block(width: 11.4cm)[
        Выполнил:

        #v(3pt)

        #grid(
          columns: (1fr, 4.8cm),
          column-gutter: 0.5cm,
          [Обучающийся группы],
          [#underlined-field(
            value: [#group],
            caption: [(аббревиатура группы)],
            reserve: 0.01em,
          )],
        )

        #grid(
          columns: (3.0cm, 3.0cm, 4.8cm),
          column-gutter: 0.35cm,
          [#underlined-field(caption: [(дата)], reserve: 0.01em)],
          [#underlined-field(caption: [(подпись)], reserve: 0.01em)],
          [#underlined-field(
            value: [#student-short],
            caption: [(инициалы, фамилия)],
            reserve: 0.01em,
          )],
        )

        #kind-info.supervisor-label

        #align(right)[
          #underlined-field(
            width: 8.3cm,
            value: [#supervisor-full],
            caption: [(уч. степень, звание, инициалы, фамилия)],
            reserve: 0.01em,
          )
        ]

        #align(right)[
          #grid(
            columns: (2.7cm, 2.7cm, 4.6cm),
            column-gutter: 0.35cm,
            [#underlined-field(caption: [(оценка)])],
            [#underlined-field(caption: [(дата)])],
            [#underlined-field(caption: [(подпись)])],
          )
        ]
      ]
    ]

    place(bottom + center, dy: -3mm)[
      #align(center)[
        #city

        #year
      ]
    ]
  }

  pagebreak(weak: true)
}
