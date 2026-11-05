#import "@local/sibsiu:0.1.0": *

#show: sibsiu-work.with(
  kind: "coursework", // coursework, practice, rgr, vkr
  discipline: "Название дисциплины",
  title: "Тема работы",
  group: "ИВТ-23",
  author: (
    short: "И. О. Фамилия",
    full: "Фамилия Имени Отчества",
  ),
  supervisor: (
    short: "И. О. Фамилия",
    full: "уч. степень, звание И. О. Фамилия",
  ),
  year: 2026,
  tasks: [
    #task-item("1.", [Изучить предметную область])
    #task-item("2.", [Разработать программную часть])
  ],
)

#titlepage()
#assignment()
#contents()

#include "content/01-introduction.typ"
#include "content/02-main.typ"
#include "content/03-conclusion.typ"

#bibliography-page(read("works.bib"))
