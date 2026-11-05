#let sibsiu-work(title: "Тема работы", author: "Фамилия И. О.", group: "Группа", body) = {
  set document(title: title, author: author)
  meta.update((title: title, author: author, group: group))
  show: sibsiu-text
  show: sibsiu-page
  show: sibsiu-headings
  show: sibsiu-lists
  show: sibsiu-figures
  show: sibsiu-equations
  show: sibsiu-footnotes
  body
}
