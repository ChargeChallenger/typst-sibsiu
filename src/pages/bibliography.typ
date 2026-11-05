#let bibliography-page(
  bib-source,
  outlined: true,
  style: "gost-r-7-0-5-2008-numeric",
) = {
  // Заголовок библиографического списка
  heading(level: 1, numbering: none, outlined: outlined)[БИБЛИОГРАФИЧЕСКИЙ СПИСОК]

  show bibliography: set par(
    first-line-indent: 1.25cm,
    leading: 1em,
    justify: true,
  )

  let bib-data = if type(bib-source) == str {
    bytes(bib-source)
  } else {
    bib-source
  }

  bibliography(
    bib-data,
    title: none,
    style: style,
  )
}
