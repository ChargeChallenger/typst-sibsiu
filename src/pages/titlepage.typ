#import "../meta.typ": meta

// Компонент «Титульный лист».
//
// Тема, автор и группа берутся из `sibsiu-work`. Любое значение можно
// переопределить на месте: `#titlepage(year: 2025)`.
//
// Номер на странице не выводится, но сама страница считается первой, поэтому
// на следующей будет номер 2. Нумерация возвращается сама: `set page` ниже
// действует только внутри этой функции, а после неё снова работают правила
// из `sibsiu-work`. Если титульный лист не вызывать, первая страница получит
// номер 1.
#let titlepage(..overrides) = {
  set page(numbering: none)

  context {
    let m = meta.get() + overrides.named()
    let year = m.at("year", default: datetime.today().year())

    align(center + horizon)[
      #text(16pt, weight: "bold")[#m.at("title", default: "")]

      #v(2cm)
      #text(14pt)[#m.at("author", default: "")] \
      #text(14pt)[Группа #m.at("group", default: "")]

      #v(3cm)
      #text(14pt)[#m.at("city", default: "Новокузнецк"), #year]
    ]
  }

  pagebreak(weak: true)
}
