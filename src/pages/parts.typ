// Общие элементы для бланков СибГИУ (титул, задание).
// Размеры шрифта не задаются здесь: берутся у страницы, где вызван элемент
// (титул — 14 pt, задание — 12 pt), как в проверенном оформлении.

#let institution-header(
  ministry: "Министерство науки и высшего образования Российской Федерации",
  institution-line-1: "Федеральное государственное бюджетное образовательное учреждение",
  institution-line-2: "высшего образования",
  university: "«Сибирский государственный индустриальный университет»",
  department: "Кафедра прикладных информационных технологий и программирования",
) = [
  #align(center)[
    #ministry

    #institution-line-1

    #institution-line-2

    #university
  ]

  #v(24pt)

  #align(center)[#department]
]

#let underlined-field(
  width: 100%,
  value: none,
  caption: none,
  reserve: 0.55em,
) = block(width: width)[
  #block(width: 100%, height: reserve)[
    #align(center)[
      #if value != none [
        #value
      ]
    ]
  ]
  #line(length: 100%)
  #if caption != none [
    #v(-2pt)
    #align(center)[
      #text(size: 10pt)[#caption]
    ]
  ]
]

#let value-line(width: 100%, value: none, reserve: 0.2em) = block(width: width)[
  #block(width: 100%, height: reserve)[
    #align(center)[
      #if value != none [
        #value
      ]
    ]
  ]
  #line(length: 100%)
]
