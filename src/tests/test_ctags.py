from ctags import CTags, TagEntry
from unittest import TestCase
import subprocess

class TestCTags(TestCase):
    def setUp(self):
        proc = subprocess.Popen('ctags --fields=afmikKlnsStz ../_readtags.c'
                     ' ../include/readtags.h ../readtags.c',
                     shell=True,
                     stdin=subprocess.PIPE,
                     stdout=subprocess.PIPE,
                     stderr=subprocess.STDOUT
                     )
        
        stdout_value, stderr_value = proc.communicate()
        
    def testTagEntry(self):
        pass
        
        
