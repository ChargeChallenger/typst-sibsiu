#!/usr/bin/env python3
"""
Тесты для scripts/update_progress.py
"""

import sys
import unittest
from pathlib import Path

# Добавляем корень проекта в sys.path
repo_root = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(repo_root))

from scripts.update_progress import (
    SectionProgress,
    generate_badges_block,
    generate_progress_bar_block,
    generate_table_block,
    parse_sections,
    replace_or_insert_block,
    slugify,
    update_progress_content,
)


class TestUpdateProgress(unittest.TestCase):
    def test_slugify(self):
        self.assertEqual(
            slugify("1. Параметры страницы и геометрия (п. 2.1)"),
            "1-параметры-страницы-и-геометрия-п-21",
        )
        self.assertEqual(
            slugify("15. Архитектура и инфраструктура пакета sibsiu"),
            "15-архитектура-и-инфраструктура-пакета-sibsiu",
        )
        self.assertEqual(
            slugify("4. Специальные разделы документа (п. 2.2, Таблица 1)"),
            "4-специальные-разделы-документа-п-22-таблица-1",
        )

    def test_section_progress_bar(self):
        s0 = SectionProgress(num=1, title="Test", short_title="Test", anchor="test", done=0, total=10)
        self.assertEqual(s0.percentage, 0)
        self.assertEqual(s0.status, "Запланировано")
        self.assertEqual(s0.progress_bar(10), "[░░░░░░░░░░]   0%")

        s5 = SectionProgress(num=1, title="Test", short_title="Test", anchor="test", done=5, total=10)
        self.assertEqual(s5.percentage, 50)
        self.assertEqual(s5.status, "В процессе")
        self.assertEqual(s5.progress_bar(10), "[█████░░░░░]  50%")

        s10 = SectionProgress(num=1, title="Test", short_title="Test", anchor="test", done=10, total=10)
        self.assertEqual(s10.percentage, 100)
        self.assertEqual(s10.status, "Готово")
        self.assertEqual(s10.progress_bar(10), "[██████████] 100%")

    def test_parse_sections(self):
        sample = """
# Header

## Детальный перечень требований и задач

### 1. Первый раздел (п. 1.1)
- [x] Задача 1
- [ ] Задача 2
- [X] Задача 3

### 2. Второй раздел
- [ ] Задача 2.1
- [ ] Задача 2.2

## Руководство
Текст руководства...
"""
        sections = parse_sections(sample)
        self.assertEqual(len(sections), 2)
        self.assertEqual(sections[0].num, 1)
        self.assertEqual(sections[0].short_title, "Первый раздел")
        self.assertEqual(sections[0].done, 2)
        self.assertEqual(sections[0].total, 3)

        self.assertEqual(sections[1].num, 2)
        self.assertEqual(sections[1].short_title, "Второй раздел")
        self.assertEqual(sections[1].done, 0)
        self.assertEqual(sections[1].total, 2)

    def test_update_idempotency(self):
        sample = """# Прогресс

<!-- PROGRESS_BADGES:START -->
old badges
<!-- PROGRESS_BADGES:END -->

### Общий прогресс реализации

<!-- PROGRESS_BAR:START -->
old bar
<!-- PROGRESS_BAR:END -->

## Сводная таблица по разделам

<!-- PROGRESS_TABLE:START -->
old table
<!-- PROGRESS_TABLE:END -->

## Детальный перечень требований и задач

### 1. Тестовый раздел (п. 1.0)
- [x] Готово 1
- [ ] Не готово 2

## Другой раздел
"""
        updated_first, sections = update_progress_content(sample)
        self.assertIn("50.0%", updated_first)
        self.assertIn("[█████░░░░░]  50%", updated_first)

        # Повторный запуск должен вернуть точно такой же результат
        updated_second, _ = update_progress_content(updated_first)
        self.assertEqual(updated_first, updated_second)

    def test_code_blocks_ignored(self):
        sample = """
## Детальный перечень требований и задач

### 1. Тестовый раздел
- [x] Реальная выполненная задача
- [ ] Реальная невыполненная задача
```markdown
- [x] Чекбокс в блоке кода не должен считаться!
- [ ] И этот тоже
```
- [x] Еще одна реальная задача
"""
        sections = parse_sections(sample)
        self.assertEqual(len(sections), 1)
        self.assertEqual(sections[0].done, 2)
        self.assertEqual(sections[0].total, 3)

    def test_header_variations(self):
        sample = """
## Детальный перечень требований и задач

### 1. Заголовок с точкой
- [x] Пункт 1

### 2) Заголовок со скобкой
- [ ] Пункт 2

### 3 Заголовок без точки
- [x] Пункт 3
"""
        sections = parse_sections(sample)
        self.assertEqual(len(sections), 3)
        self.assertEqual(sections[0].num, 1)
        self.assertEqual(sections[1].num, 2)
        self.assertEqual(sections[2].num, 3)

    def test_replace_block_with_backslashes(self):
        content = "<!-- TEST:START -->старый блок<!-- TEST:END -->"
        new_block = "<!-- TEST:START -->новый блок с \\1 и \\g<0> и \\LaTeX<!-- TEST:END -->"
        res = replace_or_insert_block(content, "TEST", new_block)
        self.assertEqual(res, new_block)

    def test_empty_section(self):
        s_empty = SectionProgress(num=1, title="Пустой раздел", short_title="Пустой", anchor="empty", done=0, total=0)
        self.assertEqual(s_empty.percentage, 0)
        self.assertEqual(s_empty.status, "Запланировано")
        self.assertEqual(s_empty.progress_bar(10), "[░░░░░░░░░░]   0%")

    def test_cli_check_mode(self):
        import os
        import subprocess
        import tempfile

        sample = """# Прогресс

<!-- PROGRESS_BADGES:START -->
old badges
<!-- PROGRESS_BADGES:END -->

### Общий прогресс реализации

<!-- PROGRESS_BAR:START -->
old bar
<!-- PROGRESS_BAR:END -->

## Сводная таблица по разделам

<!-- PROGRESS_TABLE:START -->
old table
<!-- PROGRESS_TABLE:END -->

## Детальный перечень требований и задач

### 1. Тестовый раздел (п. 1.0)
- [x] Готово 1
- [ ] Не готово 2
"""
        with tempfile.NamedTemporaryFile("w+", encoding="utf-8", delete=False) as tf:
            tf.write(sample)
            tmp_path = tf.name

        try:
            # 1. Несинхронизированный файл -> --check возвращает код 1
            res_fail = subprocess.run(
                [sys.executable, str(repo_root / "scripts" / "update_progress.py"), "--file", tmp_path, "--check"],
                capture_output=True,
            )
            self.assertEqual(res_fail.returncode, 1)

            # 2. Обновление файла
            res_update = subprocess.run(
                [sys.executable, str(repo_root / "scripts" / "update_progress.py"), "--file", tmp_path],
                capture_output=True,
            )
            self.assertEqual(res_update.returncode, 0)

            # 3. Синхронизированный файл -> --check возвращает код 0
            res_ok = subprocess.run(
                [sys.executable, str(repo_root / "scripts" / "update_progress.py"), "--file", tmp_path, "--check"],
                capture_output=True,
            )
            self.assertEqual(res_ok.returncode, 0)
        finally:
            if os.path.exists(tmp_path):
                os.remove(tmp_path)


if __name__ == "__main__":
    unittest.main()
