#let bibliography-page(
  bib-source,
  outlined: true,
  // По умолчанию используем встроенный в пакет выверенный вузовский CSL
  style: "../csl/gost-r-7-0-5-2008-numeric-indent.csl",
) = {
  // Структурный заголовок по стандарту (16 pt, по центру, капсом, без номера)
  heading(level: 1, numbering: none, outlined: outlined)[БИБЛИОГРАФИЧЕСКИЙ СПИСОК]

  // Полуторный интервал и абзацный отступ по ГОСТ
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
