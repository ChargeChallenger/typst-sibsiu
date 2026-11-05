#import "../meta.typ": meta
#import "parts.typ": institution-header, underlined-field, value-line

#let task-item(number, body, indent: 0pt) = pad(left: indent)[
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.3cm,
    [#number], [#body],
  )
]

#let assignment(tasks: none, ..overrides) = {
  // На бланке задания номер не печатается
  set page(
    margin: (
      top: 16mm,
      bottom: 12mm,
      left: 20mm,
      right: 10mm,
    ),
    numbering: none,
  )
  set text(size: 11pt)
  set par(first-line-indent: 0pt, leading: 0.8em, spacing: 0.7em, justify: false)

  context {
    let m = meta.get() + overrides.named()
    let discipline = m.at("discipline", default: "")
    let topic = m.at("title", default: "")
    let group = m.at("group", default: "")

    let student-raw = m.at("author", default: "")
    let student-short = if type(student-raw) == dictionary {
      student-raw.at("short", default: "")
    } else {
      student-raw
    }
    let student-full = if type(student-raw) == dictionary {
      student-raw.at("full", default: student-short)
    } else {
      student-raw
    }

    let supervisor-raw = m.at("supervisor", default: none)
    let supervisor-short = if type(supervisor-raw) == dictionary {
      supervisor-raw.at("short", default: "")
    } else if supervisor-raw != none {
      str(supervisor-raw)
    } else {
      ""
    }
    let supervisor-role = m.at("supervisor-role", default: "Руководитель курсового проекта")

    let task-body = if tasks != none { tasks } else { m.at("tasks", default: []) }

    institution-header(
      university: m.at("university", default: "«Сибирский государственный индустриальный университет»"),
      department: m.at("department", default: "Кафедра прикладных информационных технологий и программирования"),
    )

    v(10pt)

    align(right)[
      #block(width: 7.8cm)[
        УТВЕРЖДАЮ \
        Заведующий кафедрой

        #v(1pt)
        #grid(
          columns: (2.8cm, 4.4cm),
          column-gutter: 0.4cm,
          [#underlined-field(caption: [(подпись)])], [#underlined-field(caption: [(инициалы, фамилия)])],
        )

        #v(1pt)
        #grid(
          columns: (1.3cm, 3.4cm, 2.0cm),
          column-gutter: 0.2cm,
          [«\_\_\_\_»], [#value-line(reserve: -0.05em)], [20\_\_ г.],
        )
      ]
    ]

    v(14pt)

    align(center)[
      #text(size: 12pt, weight: "bold")[ЗАДАНИЕ НА ВЫПОЛНЕНИЕ КУРСОВОГО ПРОЕКТА]
    ]

    v(6pt)

    if discipline != "" [
      #align(center)[по дисциплине «#discipline»]
    ]
    align(center)[на тему «#topic»]
    align(center)[обучающегося группы #group]
    align(center)[#student-full]

    v(12pt)

    task-body

    v(14pt)

    [Задание к курсовой работе принял:]

    v(4pt)

    grid(
      columns: (1fr, 5.0cm),
      column-gutter: 0.8cm,
      [
        #grid(
          columns: (1.1cm, 3.8cm, 1.8cm),
          column-gutter: 0.2cm,
          [«\_\_\_»], [#value-line(reserve: -0.05em)], [\_\_\_\_\_г.],
        )
      ],
      [#value-line(value: [#student-short], reserve: 0.8em)],
    )

    v(14pt)

    grid(
      columns: (1fr, 3.0cm, 5.0cm),
      column-gutter: 0.4cm,
      [#supervisor-role], [#value-line(reserve: 0.8em)], [#value-line(value: [#supervisor-short], reserve: 0.8em)],
    )
  }

  pagebreak(weak: true)
}
