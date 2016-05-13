"""
$Id$

This file is part of Python-Ctags.

Python-Ctags is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Python-Ctags is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Python-Ctags.  If not, see <http://www.gnu.org/licenses/>.
"""


include "stdlib.pxi"
include "readtags.pxi"


cdef class TagEntry:
    cdef tagEntry c_entry

    def __cinit__(self):
        self.c_entry.fields.count = 0
        self.c_entry.fields.list = NULL


    def __getitem__(self, key):
        cdef char* result
        if key == 'name':
            return self.c_entry.name
        elif key == 'file':
            return self.c_entry.file 
        elif key == 'pattern':
            if self.c_entry.address.pattern == NULL:
                return None
            return self.c_entry.address.pattern 
        elif key == 'lineNumber':
            return self.c_entry.address.lineNumber 
        elif key == 'kind':
            if self.c_entry.kind == NULL:
                return None
            return self.c_entry.kind
        elif key == 'fileScope':
            return self.c_entry.fileScope 
        else:
            # It will crash if we mix NULL/0/None
            # don't mix comparison of type
            result = ctagsField(&self.c_entry, key)
            if result == NULL:
                return None

            return result

cdef class CTags:
    cdef tagFile* file
    cdef tagFileInfo info

    def __cinit__(self, filepath):
        self.open(filepath)

    def __dealloc__(self):

        if self.file:
            ctagsClose(self.file)

    def __getitem__(self, key):
        if key == 'opened':
            return self.info.status.opened
        if key == 'error_number':
            return self.info.status.error_number
        if key == 'format':
            return self.info.file.format
        if key == 'sort':
            return self.info.file.sort
        if key == 'author':
            if self.info.program.author == NULL:
                return ''
            return self.info.program.author
        if key == 'name':
            if self.info.program.name == NULL:
                return ''
            return self.info.program.name
        if key == 'url':
            if self.info.program.url == NULL:
                return ''
            return self.info.program.url
        if key == 'version':
            if self.info.program.version == NULL:
                return ''
            return self.info.program.version


    def open(self, filepath):
        self.file = ctagsOpen(filepath, &self.info)

        if not self.info.status.opened:
            raise Exception('Invalid tag file')

    def setSortType(self, tagSortType type):
        return ctagsSetSortType(self.file, type)

    def first(self, TagEntry entry):
        return ctagsFirst(self.file, &entry.c_entry)

    def find(self, TagEntry entry, char* name, int options):
        return ctagsFind(self.file, &entry.c_entry, name, options)

    def findNext(self, TagEntry entry):
        return ctagsFindNext(self.file, &entry.c_entry)

    def next(self, TagEntry entry):
        return ctagsNext(self.file, &entry.c_entry)

