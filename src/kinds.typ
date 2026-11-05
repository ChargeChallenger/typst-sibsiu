// Виды учебных работ: подписи на титуле и наличие страницы задания.
// Вид работы задаётся параметром kind у sibsiu-work.
#let kinds-map = (
  // Курсовой проект: с отдельной страницей задания, утверждаемой кафедрой.
  coursework: (
    work-type: "КУРСОВОЙ ПРОЕКТ",
    supervisor-label: "Руководитель курсового проекта:",
    supervisor-role: "Руководитель курсового проекта",
    assignment: true,
  ),
  // Отчёт по практическим занятиям (оформление, проверенное преподавателем).
  practice: (
    work-type: "ОТЧЕТ ПО ПРАКТИЧЕСКИМ ЗАНЯТИЯМ",
    supervisor-label: "Преподаватель:",
    supervisor-role: "Преподаватель",
    assignment: false,
  ),
  // Отчёт по практике (учебная, производственная и т. п.).
  internship: (
    work-type: "ОТЧЕТ ПО ПРАКТИКЕ",
    supervisor-label: "Руководитель практики:",
    supervisor-role: "Руководитель практики",
    assignment: false,
  ),
  // Расчётно-графическая работа.
  rgr: (
    work-type: "РАСЧЕТНО-ГРАФИЧЕСКАЯ РАБОТА",
    supervisor-label: "Преподаватель:",
    supervisor-role: "Преподаватель",
    assignment: false,
  ),
  // Выпускная квалификационная работа.
  vkr: (
    work-type: "ВЫПУСКНАЯ КВАЛИФИКАЦИОННАЯ РАБОТА",
    supervisor-label: "Руководитель ВКР:",
    supervisor-role: "Руководитель ВКР",
    assignment: false,
  ),
)

#let resolve-kind(kind) = {
  if kind not in kinds-map {
    panic("неизвестный вид работы: " + str(kind) + ". Доступны: " + kinds-map.keys().join(", "))
  }
  kinds-map.at(kind)
}
