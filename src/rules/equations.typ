#let sibsiu-equations(body) = {
  set math.equation(numbering: "(1)", supplement: none)
  show math.equation.where(block: true): it => {
    v(12pt, weak: true)
    it
    v(12pt, weak: true)
  }
  body
}
