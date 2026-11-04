#!/usr/bin/env python3
"""
Скрипт автоматического расчета прогресса разработки и обновления PROGRESS.md.

Функционал:
1. Сканирует разделы требований (### N. Название ...) и подсчитывает чекбоксы (- [x] / - [ ]).
2. Вычисляет процент готовности для каждого раздела и суммарно по всему проекту.
3. Генерирует Unicode прогресс-бары ([████░░░░░░]).
4. Обновляет сводную таблицу разделов, блок общего прогресса и Shields.io бейджи в PROGRESS.md.
5. Поддерживает режим валидации (--check) для использования в CI и git pre-commit hook.
"""

from __future__ import annotations

import argparse
import os
import re
import sys
from dataclasses import dataclass
from pathlib import Path


@dataclass
class SectionProgress:
    num: int
    title: str
    short_title: str
    anchor: str
    done: int
    total: int

    @property
    def percentage(self) -> int:
        if self.total == 0:
            return 0
        return round(self.done / self.total * 100)

    @property
    def status(self) -> str:
        if self.total > 0 and self.done == self.total:
            return "Готово"
        if self.done > 0:
            return "В процессе"
        return "Запланировано"

    def progress_bar(self, width: int = 10) -> str:
        if self.total == 0:
            filled = 0
        else:
            filled = round((self.done / self.total) * width)
        filled = max(0, min(width, filled))
        empty = width - filled
        pct = self.percentage
        return f"[{'█' * filled}{'░' * empty}] {pct:>3}%"


def slugify(text: str) -> str:
    """Генерация slug/якоря в стиле GitHub Markdown."""
    s = text.strip().lower()
    s = re.sub(r"[^\w\s\-]", "", s, flags=re.UNICODE)
    s = re.sub(r"[\s]+", "-", s)
    return s.strip("-")


def parse_sections(content: str) -> list[SectionProgress]:
    """Разбор детального перечня требований на разделы и подсчет чекбоксов."""
    lines = content.splitlines()
    sections: list[SectionProgress] = []

    current_num: int | None = None
    current_title: str = ""
    current_done = 0
    current_total = 0

    section_header_re = re.compile(r"^###\s+(\d+)[\.\)]?\s+(.*)$")
    checkbox_re = re.compile(r"^\s*[-*]\s*\[([ xX])\]")

    def finalize_current():
        nonlocal current_num, current_title, current_done, current_total
        if current_num is not None:
            # Убираем уточнения в скобках для компактного имени в таблице
            short_title = re.sub(r"\s*\([^)]*\)$", "", current_title).strip()
            anchor = slugify(f"{current_num}. {current_title}")
            sections.append(
                SectionProgress(
                    num=current_num,
                    title=current_title,
                    short_title=short_title,
                    anchor=anchor,
                    done=current_done,
                    total=current_total,
                )
            )
            current_num = None
            current_title = ""
            current_done = 0
            current_total = 0

    in_detail_part = False
    in_code_block = False

    for line in lines:
        stripped = line.strip()
        if stripped.startswith("```") or stripped.startswith("~~~"):
            in_code_block = not in_code_block
            continue

        if in_code_block:
            continue

        if re.match(r"^##\s+Детальный перечень требований", line):
            in_detail_part = True
            continue

        if not in_detail_part:
            continue

        # Завершение блока детального перечня (следующий раздел h2)
        if re.match(r"^##\s+(?!#)", line) and in_detail_part:
            finalize_current()
            break

        header_match = section_header_re.match(line)
        if header_match:
            finalize_current()
            current_num = int(header_match.group(1))
            current_title = header_match.group(2).strip()
            current_done = 0
            current_total = 0
            continue

        if current_num is not None:
            cb_match = checkbox_re.match(line)
            if cb_match:
                current_total += 1
                if cb_match.group(1).lower() == "x":
                    current_done += 1

    finalize_current()
    return sections


def generate_badges_block(sum_done: int, sum_total: int) -> str:
    pct = round((sum_done / sum_total * 100)) if sum_total > 0 else 0
    status_label = "Готово" if (sum_total > 0 and sum_done == sum_total) else "В_разработке"
    status_color = "brightgreen" if (sum_total > 0 and sum_done == sum_total) else "orange"

    return f"""<!-- PROGRESS_BADGES:START -->
[![План реализации](https://img.shields.io/badge/План_реализации-{pct}%25_({sum_done}%2F{sum_total})-blue)](#общий-прогресс-реализации)
[![Статус](https://img.shields.io/badge/Статус-{status_label}-{status_color})](#общий-прогресс-реализации)
[![Стандарт](https://img.shields.io/badge/СибГИУ_ПИТиП-2023-brightgreen)](Оформление%20пояснительных%20записок.pdf)
[![Typst](https://img.shields.io/badge/Typst-%E2%89%A50.13.0-239dad)](https://typst.app)
<!-- PROGRESS_BADGES:END -->"""


def generate_progress_bar_block(sum_done: int, sum_total: int, width: int = 20) -> str:
    if sum_total == 0:
        ratio = 0.0
        filled = 0
        pct_float = 0.0
    else:
        ratio = sum_done / sum_total
        filled = round(ratio * width)
        pct_float = ratio * 100.0

    filled = max(0, min(width, filled))
    empty = width - filled
    bar_str = f"[{'█' * filled}{'░' * empty}] {pct_float:.1f}% (выполнено {sum_done} из {sum_total} пунктов)"

    return f"""<!-- PROGRESS_BAR:START -->
```text
{bar_str}
```
<!-- PROGRESS_BAR:END -->"""


def generate_table_block(sections: list[SectionProgress]) -> str:
    sum_done = sum(s.done for s in sections)
    sum_total = sum(s.total for s in sections)
    total_pct = round((sum_done / sum_total * 100)) if sum_total > 0 else 0
    total_filled = round((sum_done / sum_total * 10)) if sum_total > 0 else 0
    total_filled = max(0, min(10, total_filled))
    total_bar = f"[{'█' * total_filled}{'░' * (10 - total_filled)}] {total_pct:>3}%"
    overall_status = "Готово" if (sum_total > 0 and sum_done == sum_total) else "В разработке"

    rows = [
        "<!-- PROGRESS_TABLE:START -->",
        "| № | Раздел требований | Статус | Готово | Всего | Прогресс-бар |",
        "|:---:|:---|:---:|:---:|:---:|:---|",
    ]

    for s in sections:
        rows.append(
            f"| {s.num} | [{s.short_title}](#{s.anchor}) | {s.status} | {s.done} | {s.total} | `{s.progress_bar(10)}` |"
        )

    rows.append(
        f"| **Σ** | **ИТОГО** | **{overall_status}** | **{sum_done}** | **{sum_total}** | `{total_bar}` |"
    )
    rows.append("<!-- PROGRESS_TABLE:END -->")

    return "\n".join(rows)


def replace_or_insert_block(content: str, tag: str, new_block: str, fallback_re: str | None = None) -> str:
    """Заменяет блок между маркерами <!-- TAG:START --> и <!-- TAG:END -->, либо использует fallback."""
    pattern = rf"<!-- {tag}:START -->.*?<!-- {tag}:END -->"
    match = re.search(pattern, content, flags=re.DOTALL)
    if match:
        return content[: match.start()] + new_block + content[match.end() :]

    if fallback_re:
        match = re.search(fallback_re, content, flags=re.DOTALL)
        if match:
            return content[: match.start()] + new_block + content[match.end() :]

    return content


def update_progress_content(content: str) -> tuple[str, list[SectionProgress]]:
    """Основная функция обновления содержимого PROGRESS.md."""
    # Нормализуем переводы строк
    normalized_content = content.replace("\r\n", "\n")
    sections = parse_sections(normalized_content)

    if not sections:
        raise ValueError("Не удалось обнаружить разделы требований в детальном перечне!")

    sum_done = sum(s.done for s in sections)
    sum_total = sum(s.total for s in sections)

    badges_block = generate_badges_block(sum_done, sum_total)
    bar_block = generate_progress_bar_block(sum_done, sum_total)
    table_block = generate_table_block(sections)

    result = normalized_content

    # Обновляем бейджи
    badges_fallback = r"(?:\[!\[План реализации\].*?\n)+.*?(?=\n\n(?:Документ|#|\w))"
    result = replace_or_insert_block(result, "PROGRESS_BADGES", badges_block, badges_fallback)

    # Обновляем общий прогресс-бар
    bar_fallback = r"```text\s*\n\[[█░]+\][^\n]*\n```"
    result = replace_or_insert_block(result, "PROGRESS_BAR", bar_block, bar_fallback)

    # Обновляем сводную таблицу
    table_fallback = r"\| № \| Раздел требований \|.*?(?=\n\n---|\n\n##|\Z)"
    result = replace_or_insert_block(result, "PROGRESS_TABLE", table_block, table_fallback)

    return result, sections


def find_progress_file(explicit_path: str | None = None) -> Path:
    if explicit_path:
        p = Path(explicit_path).resolve()
        if not p.is_file():
            raise FileNotFoundError(f"Файл не найден: {p}")
        return p

    # Поиск относительно расположения скрипта и текущей папки
    candidates = [
        Path(__file__).resolve().parent.parent / "PROGRESS.md",
        Path.cwd() / "PROGRESS.md",
        Path.cwd() / "typst-sibsiu" / "PROGRESS.md",
    ]
    for c in candidates:
        if c.is_file():
            return c.resolve()

    raise FileNotFoundError("PROGRESS.md не найден. Укажите путь через --file.")


def main() -> int:
    parser = argparse.ArgumentParser(description="Автоматический расчет и обновление прогресса в PROGRESS.md")
    parser.add_argument("--file", "-f", help="Путь к PROGRESS.md (по умолчанию ищется в корне репозитория)")
    parser.add_argument("--check", action="store_true", help="Проверить актуальность PROGRESS.md без записи (код возврата 1 при расхождениях)")
    parser.add_argument("--quiet", "-q", action="store_true", help="Минимум вывода")

    args = parser.parse_args()

    try:
        progress_path = find_progress_file(args.file)
    except FileNotFoundError as err:
        print(f"Ошибка: {err}", file=sys.stderr)
        return 2

    raw_content = progress_path.read_text(encoding="utf-8")
    new_content, sections = update_progress_content(raw_content)

    sum_done = sum(s.done for s in sections)
    sum_total = sum(s.total for s in sections)
    pct = (sum_done / sum_total * 100) if sum_total > 0 else 0.0

    if args.check:
        if raw_content.replace("\r\n", "\n") != new_content:
            if not args.quiet:
                print(f"[FAIL] {progress_path.name} не синхронизирован! Расчет: {sum_done}/{sum_total} ({pct:.1f}%). Запустите: python scripts/update_progress.py", file=sys.stderr)
            return 1
        if not args.quiet:
            print(f"[OK] {progress_path.name} актуален ({sum_done}/{sum_total}, {pct:.1f}%).")
        return 0

    if raw_content.replace("\r\n", "\n") == new_content:
        if not args.quiet:
            print(f"Файл {progress_path.name} уже актуален: {sum_done}/{sum_total} ({pct:.1f}%). Изменения не требуются.")
        return 0

    progress_path.write_text(new_content, encoding="utf-8")
    if not args.quiet:
        print(f"Файл {progress_path.name} успешно обновлен:")
        print(f"  - Общий прогресс: {sum_done}/{sum_total} пунктов ({pct:.1f}%)")
        print(f"  - Обработано разделов: {len(sections)}")
        for s in sections:
            status_symbol = "✓" if s.done == s.total and s.total > 0 else ("…" if s.done > 0 else " ")
            print(f"    [{status_symbol}] Раздел {s.num:>2}: {s.done:>2}/{s.total:<2} ({s.percentage:>3}%) - {s.short_title}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
