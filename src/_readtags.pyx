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
from collections.abc import Mapping

cdef class cTagEntry:
    cdef tagEntry c_entry

    def __getitem__(self, key):
        if key == 'name':
            return self.c_entry.name
        elif key == 'file':
            return self.c_entry.file 
        elif key == 'pattern':
            if self.c_entry.address.pattern == NULL:
                return None
            return self.c_entry.address.pattern 
        elif key == 'lineNumber':
            if not self.c_entry.address.lineNumber:
                raise KeyError(key)
            return self.c_entry.address.lineNumber
        elif key == 'kind':
            if self.c_entry.kind == NULL:
                raise KeyError(key)
            return self.c_entry.kind
        elif key == 'fileScope':
            return self.c_entry.fileScope 
        else:
            # It will crash if we mix NULL/0/None
            # don't mix comparison of type
            result = ctagsField(&self.c_entry, key.encode())
            if result == NULL:
                raise KeyError(key)

            return result

    def __iter__(self):
        yield from ('name', 'file', 'pattern', 'fileScope')
        if self.c_entry.address.lineNumber:
            yield 'lineNumber'
        if self.c_entry.kind != NULL:
            yield 'kind'
        for index in range(self.c_entry.fields.count):
            key = self.c_entry.fields.list[index].key
            yield key.decode()

    def __len__(self):
        return (4   # Number of fields always present.
              + bool(self.c_entry.address.lineNumber) # Do we have lineNumber ?
              + bool(self.c_entry.kind != NULL) # Do we have kind ?
              + self.c_entry.fields.count # Number of extra fields.
               )

class TagEntry(cTagEntry, Mapping):
    pass

cdef class CTags:
    cdef tagFile* file
    cdef tagFileInfo info

    def __cinit__(self, filepath):
        self.open(filepath)

    def __dealloc__(self):

        if self.file:
            ctagsClose(self.file)

    def __getitem__(self, key):
        ret = None
        if key == 'opened':
            return self.info.status.opened
        elif key == 'error_number':
            return self.info.status.error_number
        elif key == 'format':
            return self.info.file.format
        elif key == 'sort':
            return self.info.file.sort
        else:
            if key == 'author':
                ret = self.info.program.author
            elif key == 'name':
                ret = self.info.program.name
            elif key == 'url':
                ret = self.info.program.url
            elif key == 'version':
                ret = self.info.program.version
            if ret is None:
                raise KeyError(key)
            return ret


    def open(self, filepath):
        self.file = ctagsOpen(filepath, &self.info)

        if not self.info.status.opened:
            raise Exception('Invalid tag file')

    def setSortType(self, tagSortType type):
        return ctagsSetSortType(self.file, type)

    def first(self, cTagEntry entry):
        return ctagsFirst(self.file, &entry.c_entry)

    def find(self, cTagEntry entry, char* name, int options):
        return ctagsFind(self.file, &entry.c_entry, name, options)

    def findNext(self, cTagEntry entry):
        return ctagsFindNext(self.file, &entry.c_entry)

    def next(self, cTagEntry entry):
        return ctagsNext(self.file, &entry.c_entry)

