import sys
import os
src_dir = os.path.join(
        os.path.dirname(os.path.dirname(os.path.realpath(__file__))), 'src'
)
sys.path.insert(0, src_dir)
from unittest import TestCase
import ctags

class TestCTagsParse(TestCase):
    def setUp(self):
        file_path = os.path.join(src_dir, 'examples', 'tags')
        self.ctags = ctags.CTags(file_path.encode(sys.getfilesystemencoding()))
    def test_tag_entry(self):
        entry = ctags.TagEntry()
        self.ctags.setSortType(ctags.TAG_SORTED)
        self.ctags.first(entry)
        entry_info = [entry[_]
                for _ in ('file', 'name', 'pattern', 'kind', b'language')
        ]
        self.assertEqual(
                entry_info,
                [b'../_readtags.c', b'DL_EXPORT', b'10', b'macro', b'C']
        )
    def test_tag_find(self):
        entry = ctags.TagEntry()
        self.ctags.setSortType(ctags.TAG_SORTED)
        self.ctags.find(entry, b'find', ctags.TAG_PARTIALMATCH | ctags.TAG_IGNORECASE)
        entry_info = [entry[_]
                for _ in ('file', 'name', 'pattern', 'kind', b'language')
        ]
        self.assertEqual(
                entry_info,
                [b'../readtags.c', b'find', b'/^static tagResult find (tagFile '
                b'*const file, tagEntry *const entry,$/', b'function', b'C']
        )
