#!/usr/bin/env python3
"""
Тест компиляции Typst-пакета с использованием lib.typ и компонентов.
"""

import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

repo_root = Path(__file__).resolve().parent.parent


class TestTypstCompilation(unittest.TestCase):
    def setUp(self):
        if not shutil.which("typst"):
            self.skipTest("typst CLI не установлен в системе")

    def test_compile_sample_document(self):
        doc = """
#import "/lib.typ": sibsiu-work, titlepage

#show: sibsiu-work.with(
  title: "Тестовая пояснительная записка",
  author: "Студент А. А.",
  group: "АСУ-21",
)

#titlepage()

= 1 Общая часть

Тестовый текст введения и первого раздела для проверки базовых стилей.
"""
        with tempfile.NamedTemporaryFile(suffix=".pdf", delete=False) as tf:
            out_pdf = tf.name

        try:
            res = subprocess.run(
                ["typst", "compile", "--root", str(repo_root), "-", out_pdf],
                input=doc,
                text=True,
                capture_output=True,
            )
            self.assertEqual(res.returncode, 0, f"Ошибка компиляции Typst: {res.stderr}")
            self.assertTrue(os.path.exists(out_pdf))
            self.assertGreater(os.path.getsize(out_pdf), 1000)
        finally:
            if os.path.exists(out_pdf):
                os.remove(out_pdf)


if __name__ == "__main__":
    unittest.main()
