= Первый раздел

Текст раздела. Ссылка на источник ставится так #cite(<пример-источника>).

== Подраздел

Ссылка на рисунок: на @fig-example[рисунке] показан пример.

#figure(
  // Вместо rect подставьте картинку: image("../assets/scheme.png", width: 82%)
  rect(width: 70%, height: 4cm, fill: luma(230)),
  caption: [Название рисунка],
  kind: image,
) <fig-example>
