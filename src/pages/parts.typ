// Общие элементы для бланков СибГИУ (титул, задание, лист замечаний)

#let institution-header(
  ministry: "Министерство науки и высшего образования Российской Федерации",
  institution-line-1: "Федеральное государственное бюджетное образовательное учреждение",
  institution-line-2: "высшего образования",
  university: "«Сибирский государственный индустриальный университет»",
  department: "Кафедра прикладных информационных технологий и программирования",
) = [
  #set par(leading: 0.65em, spacing: 0.65em, justify: false)
  #align(center)[
    #text(size: 11pt)[
      #ministry \
      #institution-line-1 \
      #institution-line-2 \
      #university
    ]

    #v(14pt)
    #text(size: 12pt)[#department]
  ]
]

#let underlined-field(
  width: 100%,
  value: none,
  caption: none,
  reserve: 0.35em,
) = block(width: width)[
  #block(width: 100%, height: reserve)[
    #align(center + bottom)[
      #if value != none [
        #text(size: 11pt)[#value]
      ]
    ]
  ]
  #line(length: 100%, stroke: 0.5pt)
  #if caption != none [
    #v(-6pt)
    #align(center)[
      #text(size: 8pt)[#caption]
    ]
  ]
]

#let value-line(width: 100%, value: none, reserve: 0.2em) = block(width: width)[
  #block(width: 100%, height: reserve)[
    #align(center + bottom)[
      #if value != none [
        #text(size: 11pt)[#value]
      ]
    ]
  ]
  #line(length: 100%, stroke: 0.5pt)
]
