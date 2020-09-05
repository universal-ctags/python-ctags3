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
                ['../_readtags.c', 'DL_EXPORT', '10', 'macro', 'C']
        )
    def test_tag_find(self):
        self.ctags.setSortType(ctags.TAG_SORTED)
        entry = next(self.ctags.find_tags('find', ctags.TAG_PARTIALMATCH | ctags.TAG_IGNORECASE))
        entry_info = [entry[_]
                for _ in ('file', 'name', 'pattern', 'kind', 'language')
        ]
        self.assertEqual(
                entry_info,
                ['../readtags.c', 'find', '/^static tagResult find (tagFile '
                '*const file, tagEntry *const entry,$/', 'function', 'C']
        )

    def test_tag_find_partial_nocase(self):
       for entry in self.ctags.find_tags('tag', ctags.TAG_PARTIALMATCH | ctags.TAG_IGNORECASE):
           self.assertTrue(entry['name'].lower().startswith('tag'))

    def test_tag_find_nocase(self):
       for entry in self.ctags.find_tags('tag', ctags.TAG_IGNORECASE):
           self.assertEqual(entry['name'].lower(), 'tag')

    def test_tag_find_partial(self):
       for entry in self.ctags.find_tags('tag', ctags.TAG_PARTIALMATCH):
           self.assertTrue(entry['name'].startswith('tag'))

    def test_tag_find_noflag(self):
       for entry in self.ctags.find_tags('tag', 0):
           self.assertEqual(entry['name'], 'tag')

    def test_tag_find_bytes(self):
       for entry in self.ctags.find_tags(b'tag', 0):
           self.assertEqual(entry['name'], 'tag')

class TestCTagsParseNoEncoding(TestCase):
    def setUp(self):
        file_path = os.path.join(src_dir, 'examples', 'tags')
        self.ctags = ctags.CTags(file_path, encoding=None)
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

    def test_tag_find_partial_nocase(self):
       for entry in self.ctags.find_tags(b'tag', ctags.TAG_PARTIALMATCH | ctags.TAG_IGNORECASE):
           self.assertTrue(entry['name'].lower().startswith(b'tag'))

    def test_tag_find_nocase(self):
       for entry in self.ctags.find_tags(b'tag', ctags.TAG_IGNORECASE):
           self.assertEqual(entry['name'].lower(), b'tag')

    def test_tag_find_partial(self):
       for entry in self.ctags.find_tags(b'tag', ctags.TAG_PARTIALMATCH):
           self.assertTrue(entry['name'].startswith(b'tag'))

    def test_tag_find_noflag(self):
       for entry in self.ctags.find_tags(b'tag', 0):
           self.assertEqual(entry['name'], b'tag')
