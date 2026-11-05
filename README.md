# sibsiu

Шаблон Typst для оформления студенческих работ по стандарту СибГИУ.
Требуется Typst 0.15.0 или новее.

## Использование

```typst
#import "@local/sibsiu:0.2.0": *

#show: sibsiu-work.with(kind: "coursework", title: "...", /* ... */)

#titlepage()
#assignment()   // только для coursework
#contents()
```

Структурные разделы (`= Введение`, `= Заключение`) печатаются по центру
заглавными без номера. Список литературы: `#bibliography-page(read("works.bib"))`.
Приложение: `#appendix-page(title: [...])[...]`.

## Виды работ (`kind`)

`coursework`, `practice`, `internship`, `rgr`, `vkr`.
