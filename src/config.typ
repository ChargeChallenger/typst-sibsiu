#import "meta.typ": meta
#import "kinds.typ": resolve-kind

// Правила оформления документа
#import "rules/text.typ": sibsiu-text
#import "rules/page.typ": sibsiu-page
#import "rules/headings.typ": sibsiu-headings
#import "rules/lists.typ": sibsiu-lists
#import "rules/figures.typ": sibsiu-figures
#import "rules/equations.typ": sibsiu-equations
#import "rules/footnotes.typ": sibsiu-footnotes

#let sibsiu-work(
  title: "Тема работы",
  author: "Фамилия И. О.",
  group: "Группа",
  // coursework, practice, internship, rgr, vkr
  kind: "coursework",
  discipline: none,
  work-type: "Пояснительная записка",
  // Полное название кафедры — как в проверенной преподавателем работе
  department: "Кафедра прикладных информационных технологий и программирования",
  university: "«Сибирский государственный индустриальный университет»",
  supervisor: none,
  tasks: none,
  // Число (2026 → «2026 г.») или готовая строка
  year: datetime.today().year(),
  city: "Новокузнецк",
  ..rest,
  body,
) = {
  // Неизвестный вид работы — ошибка, а не молчаливая подмена
  let _ = resolve-kind(kind)

  // Безопасное извлечение ФИО автора для метаданных PDF
  let doc-author = if type(author) == dictionary {
    author.at("full", default: author.at("short", default: ""))
  } else {
    str(author)
  }

  set document(title: title, author: doc-author)

  meta.update(
    (
      title: title,
      author: author,
      group: group,
      kind: kind,
      discipline: discipline,
      work-type: work-type,
      department: department,
      university: university,
      supervisor: supervisor,
      tasks: tasks,
      year: year,
      city: city,
    )
      + rest.named(),
  )

  show: sibsiu-text
  show: sibsiu-page
  show: sibsiu-headings
  show: sibsiu-lists
  show: sibsiu-figures
  show: sibsiu-equations
  show: sibsiu-footnotes

  body
}
