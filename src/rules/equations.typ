#let sibsiu-equations(body) = {
  set math.equation(numbering: "(1)", supplement: none)
  show math.equation.where(block: true): set block(above: 12pt, below: 12pt)
  body
}