#import "@local/sibsiu:0.1.0": *

#show: sibsiu-work.with(
  // coursework — курсовой проект (со страницей задания),
  // practice   — отчёт по практическим занятиям,
  // internship — отчёт по практике,
  // rgr        — расчётно-графическая работа,
  // vkr        — выпускная квалификационная работа.
  kind: "coursework",
  discipline: "Название дисциплины",
  title: "Тема работы",
  group: "ИВТ-23",
  author: (
    short: "И.О. Фамилия",
    full: "Фамилия Имени Отчества",
  ),
  supervisor: (
    short: "И.О. Фамилия",
    full: "уч. степень, звание И.О. Фамилия",
  ),
  // Число 2026 печатается как «2026 г.»
  year: 2026,
  tasks: [
    #task-item("1.", [Первый пункт задания])
    #task-item("2.", [Второй пункт задания])
    #task-item("2.1", [Подпункт задания], indent: 0.6cm)
  ],
)

#titlepage()
// Только для kind: "coursework"; для остальных видов работ строку удалить
#assignment()
#contents()

#include "content/01-introduction.typ"
#include "content/02-main.typ"
#include "content/03-conclusion.typ"

// Убери строку, если ссылок на источники в работе нет
#bibliography-page(read("works.bib"))
