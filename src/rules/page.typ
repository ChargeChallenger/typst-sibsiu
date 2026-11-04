#let sibsiu-page(body) = {
  set page(
    paper: "a4",
    margin: (
      top: 20mm,
      bottom: 20mm,
      left: 20mm, 
      right: 10mm,  
    ),
    numbering: "1",
    number-align: center,
  )
  body
}