import sys
import os
src_dir = os.path.join(
        os.path.dirname(os.path.dirname(os.path.realpath(__file__))), 'src'
)
sys.path.insert(0, src_dir)
from unittest import TestCase
import ctags

class TestCTagsOpen(TestCase):
    def setUp(self):
        self.file_path = os.path.join(src_dir, 'examples', 'tags')

    def test_open_str(self):
        ctags.CTags(self.file_path)

    def test_open_bytes(self):
        ctags.CTags(self.file_path.encode(sys.getfilesystemencoding()))

class TestCTagsParse(TestCase):
    def setUp(self):
        file_path = os.path.join(src_dir, 'examples', 'tags')
        self.ctags = ctags.CTags(file_path)
    def test_tag_entry(self):
        self.ctags.setSortType(ctags.TAG_SORTED)
        entry = next(self.ctags.all_tags())
        entry_info = [entry[_]
                for _ in ('file', 'name', 'pattern', 'kind', 'language')
        ]
        self.assertEqual(
                entry_info,
                [b'../_readtags.c', b'DL_EXPORT', b'10', b'macro', b'C']
        )
    def test_tag_find(self):
        self.ctags.setSortType(ctags.TAG_SORTED)
        entry = next(self.ctags.find_tags(b'find', ctags.TAG_PARTIALMATCH | ctags.TAG_IGNORECASE))
        entry_info = [entry[_]
                for _ in ('file', 'name', 'pattern', 'kind', 'language')
        ]
        self.assertEqual(
                entry_info,
                [b'../readtags.c', b'find', b'/^static tagResult find (tagFile '
                b'*const file, tagEntry *const entry,$/', b'function', b'C']
        )
