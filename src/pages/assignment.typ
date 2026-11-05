#import "../meta.typ": meta
#import "../kinds.typ": resolve-kind
#import "parts.typ": institution-header, underlined-field, value-line

// Пункт задания: #task-item("2.1", [Подпункт], indent: 0.6cm)
#let task-item(number, body, indent: 0pt) = pad(left: indent)[
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.2cm,
    [#number], [#body],
  )
]

// Страница задания нужна только для курсового проекта (kind: "coursework").
// Для practice / internship / rgr / vkr вызов #assignment() из main.typ нужно убрать.
#let assignment(tasks: none, ..overrides) = {
  // На бланке задания номер не печатается; поля и кегль — как в проверенном оформлении
  set page(
    margin: (
      top: 16mm,
      bottom: 10mm,
      left: 20mm,
      right: 10mm,
    ),
    numbering: none,
  )
  set text(size: 12pt)
  set par(first-line-indent: 0pt, leading: 1.05em, spacing: 0.85em, justify: false)

  context {
    let m = meta.get() + overrides.named()
    let kind-info = resolve-kind(m.at("kind", default: "coursework"))
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
    let supervisor-role = m.at("supervisor-role", default: kind-info.supervisor-role)

    let task-body = if tasks != none { tasks } else { m.at("tasks", default: []) }

    institution-header(
      university: m.at("university", default: "«Сибирский государственный индустриальный университет»"),
      department: m.at("department", default: "Кафедра прикладных информационных технологий и программирования"),
    )

    v(24pt)

    align(right)[
      #block(width: 8.2cm)[
        УТВЕРЖДАЮ

        Заведующий кафедрой

        #v(2pt)

        #grid(
          columns: (3.0cm, 4.4cm),
          column-gutter: 0.45cm,
          [#underlined-field(caption: [(подпись)])], [#underlined-field(caption: [(инициалы, фамилия)])],
        )

        #v(2pt)

        #grid(
          columns: (1.5cm, 3.6cm, 2.2cm),
          column-gutter: 0.25cm,
          [«\_\_\_\_»], [#value-line(reserve: -0.05em)], [20\_\_ г.],
        )
      ]
    ]

    v(34pt)

    align(center)[
      #text(size: 14pt, weight: "bold")[ЗАДАНИЕ НА ВЫПОЛНЕНИЕ КУРСОВОГО ПРОЕКТА]
    ]

    v(18pt)

    if discipline != none and discipline != "" [
      #align(center)[по дисциплине «#discipline»]
    ]
    align(center)[на тему «#topic»]
    align(center)[обучающегося группы #group]
    align(center)[#student-full]

    v(18pt)

    task-body

    v(24pt)

    [Задание к курсовой работе принял:]

    v(8pt)

    grid(
      columns: (1fr, 5.2cm),
      column-gutter: 0.9cm,
      [
        #grid(
          columns: (1.1cm, 4.1cm, 1.8cm),
          column-gutter: 0.25cm,
          [«\_\_\_»], [#value-line(reserve: -0.05em)], [\_\_\_\_\_г.],
        )
      ],
      [#value-line(value: [#student-short], reserve: 0.9em)],
    )

    v(32pt)

    grid(
      columns: (1fr, 3.3cm, 5.2cm),
      column-gutter: 0.45cm,
      [#supervisor-role], [#value-line(reserve: 0.9em)], [#value-line(value: [#supervisor-short], reserve: 0.9em)],
    )
  }

  pagebreak(weak: true)
}
