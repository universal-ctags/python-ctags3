import os
import sys

src_dir = os.path.join(
    os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "src"
)
sys.path.insert(0, src_dir)
from unittest import TestCase

import ctags


class TestCTagsParse(TestCase):
    def setUp(self):
        file_path = os.path.join(src_dir, "examples", "tags")
        self.ctags = ctags.CTags(file_path)

    def test_tag_entry(self):
        entry = ctags.TagEntry()
        self.ctags.setSortType(ctags.TAG_SORTED)
        self.ctags.first(entry)
        entry_info = [
            entry[_] for _ in ("file", "name", "pattern", "kind", b"language")
        ]
        self.assertEqual(
            entry_info, [b"../_readtags.c", b"DL_EXPORT", b"10", b"macro", b"C"]
        )

    def test_tag_find(self):
        entry = ctags.TagEntry()
        self.ctags.setSortType(ctags.TAG_SORTED)
        self.ctags.find(entry, b"find", ctags.TAG_PARTIALMATCH | ctags.TAG_IGNORECASE)
        entry_info = [
            entry[_] for _ in ("file", "name", "pattern", "kind", b"language")
        ]
        self.assertEqual(
            entry_info,
            [
                b"../readtags.c",
                b"find",
                b"/^static tagResult find (tagFile "
                b"*const file, tagEntry *const entry,$/",
                b"function",
                b"C",
            ],
        )

    def test_ptag_find(self):
        entry = ctags.TagEntry()
        self.ctags.findPseudoTag(entry, b"!_TAG_PROGRAM_URL", ctags.TAG_FULLMATCH)
        entry_info = [
            entry[_] for _ in ("file", "name", "pattern")
        ]
        self.assertEqual(
            entry_info,
            [
                b"http://ctags.sourceforge.net",
                b"!_TAG_PROGRAM_URL",
                b"/official site/",
            ],
        )

        self.ctags.nextPseudoTag(entry)
        entry_info = [
            entry[_] for _ in ("file", "name", "pattern")
        ]
        self.assertEqual(
            entry_info,
            [
                b"5.6b1",
                b"!_TAG_PROGRAM_VERSION",
                b"//",
            ],
        )

        self.ctags.firstPseudoTag(entry)
        entry_info = [
            entry[_] for _ in ("file", "name", "pattern")
        ]
        self.assertEqual(
            entry_info,
            [
                b"2",
                b"!_TAG_FILE_FORMAT",
                b"/extended format; --format=1 will not append ;\" to lines/",
            ],
        )

class TestCTagsParseBytes(TestCTagsParse):
    def setUp(self):
        file_path = os.path.join(src_dir, "examples", "tags")
        self.ctags = ctags.CTags(file_path.encode(sys.getfilesystemencoding()))
