#import "../meta.typ": meta
#import "parts.typ": institution-header, underlined-field

#let kinds-map = (
  coursework: (
    work-type: "КУРСОВОЙ ПРОЕКТ",
    supervisor-label: "Руководитель курсового проекта:",
  ),
  practice: (
    work-type: "ОТЧЕТ ПО ПРАКТИКЕ",
    supervisor-label: "Руководитель практики:",
  ),
  rgr: (
    work-type: "РАСЧЕТНО-ГРАФИЧЕСКАЯ РАБОТА",
    supervisor-label: "Преподаватель:",
  ),
  vkr: (
    work-type: "ВЫПУСКНАЯ КВАЛИФИКАЦИОННАЯ РАБОТА",
    supervisor-label: "Руководитель ВКР:",
  ),
)

#let titlepage(..overrides) = {
  // На титульном листе номер не выводится
  set page(numbering: none)

  context {
    let m = meta.get() + overrides.named()
    let kind-key = m.at("kind", default: "coursework")
    let kind-info = kinds-map.at(kind-key, default: (
      work-type: upper(m.at("work-type", default: "КУРСОВОЙ ПРОЕКТ")),
      supervisor-label: "Руководитель:",
    ))

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

    let year = m.at("year", default: datetime.today().year())
    let city = m.at("city", default: "Новокузнецк")

    set par(first-line-indent: 0pt, leading: 0.85em, justify: false)

    institution-header(
      university: m.at("university", default: "«Сибирский государственный индустриальный университет»"),
      department: m.at("department", default: "Кафедра прикладных информационных технологий и программирования"),
    )

    v(20pt)

    align(center)[
      #text(size: 14pt, weight: "bold")[#kind-info.work-type]
    ]

    v(10pt)

    if discipline != none and discipline != "" [
      #align(center)[#text(size: 13pt)[по дисциплине «#discipline»]]
    ]
    align(center)[#text(size: 13pt)[на тему «#topic»]]

    v(20pt)

    align(right)[
      #block(width: 11.4cm)[
        #set text(size: 12pt)
        Выполнил:

        #v(3pt)

        #grid(
          columns: (1fr, 4.8cm),
          column-gutter: 0.4cm,
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

        #v(6pt)
        #kind-info.supervisor-label

        #align(right)[
          #underlined-field(
            width: 8.6cm,
            value: [#supervisor-full],
            caption: [(уч. степень, звание, инициалы, фамилия)],
            reserve: 0.01em,
          )
        ]

        #align(right)[
          #grid(
            columns: (2.7cm, 2.7cm, 4.8cm),
            column-gutter: 0.35cm,
            [#underlined-field(caption: [(оценка)])],
            [#underlined-field(caption: [(дата)])],
            [#underlined-field(caption: [(подпись)])],
          )
        ]
      ]
    ]

    place(bottom + center, dy: -5mm)[
      #align(center)[
        #text(size: 12pt)[
          #city \
          #year
        ]
      ]
    ]
  }

  pagebreak(weak: true)
}
