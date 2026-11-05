#import "meta.typ": meta

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
  work-type: "Пояснительная записка",
  department: "Кафедра ПИТиП",
  supervisor: none,
  year: datetime.today().year(),
  city: "Новокузнецк",
  ..rest,
  body,
) = {
  set document(title: title, author: author)
  meta.update(
    (
      title: title,
      author: author,
      group: group,
      work-type: work-type,
      department: department,
      supervisor: supervisor,
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
