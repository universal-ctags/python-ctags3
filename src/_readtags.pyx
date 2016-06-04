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

cdef extern from "string.h":
    char* strerror(int errnum)

include "stdlib.pxi"
include "readtags.pxi"
import sys



cdef class CTags:
    cdef tagFile* file
    cdef tagFileInfo info
    cdef tagEntry c_entry
    cdef object current_id
    cdef object encoding
    cdef str encoding_errors

    def __cinit__(self, filepath, encoding='utf8', encoding_errors='strict'):
        if isinstance(filepath, unicode):
            filepath = (<unicode>filepath).encode(sys.getfilesystemencoding())
        self.file = ctagsOpen(filepath, &self.info)
        if not self.file:
            raise OSError(self.info.status.error_number,
                          strerror(self.info.status.error_number),
                          filepath)
        self.encoding = encoding
        self.encoding_errors = encoding_errors

    cdef decode(self, bytes bytes_array):
        if not self.encoding:
            return bytes_array
        return bytes_array.decode(self.encoding, self.encoding_errors)

    def __dealloc__(self):
        if self.file:
            ctagsClose(self.file)

    def __getitem__(self, key):
        ret = None
        if key == 'format':
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
            return self.decode(ret)

    def setSortType(self, tagSortType type):
        success = ctagsSetSortType(self.file, type)
        if not success:
            raise RuntimeError()

    cdef create_tagEntry(self, const tagEntry* const c_entry):
        cdef dict ret = {}
        ret['name'] = self.decode(c_entry.name)
        ret['file'] = self.decode(c_entry.file)
        ret['fileScope'] = c_entry.fileScope
        if c_entry.address.pattern != NULL:
            ret['pattern'] = self.decode(c_entry.address.pattern)
        if c_entry.address.lineNumber:
            ret['lineNumber'] = c_entry.address.lineNumber
        if c_entry.kind != NULL:
            ret['kind'] = self.decode(c_entry.kind)
        for index in range(c_entry.fields.count):
            key = c_entry.fields.list[index].key
            ret[key.decode()] = self.decode(c_entry.fields.list[index].value)
        return ret

    cdef first(self):
        success = ctagsFirst(self.file, &self.c_entry)
        if not success:
            raise RuntimeError()
        return self.create_tagEntry(&self.c_entry)

    cdef find(self, bytes name, int options):
        success = ctagsFind(self.file, &self.c_entry, name, options)
        if not success:
            raise RuntimeError()
        return self.create_tagEntry(&self.c_entry)

    cdef findNext(self):
        success = ctagsFindNext(self.file, &self.c_entry)
        if not success:
            raise RuntimeError()
        return self.create_tagEntry(&self.c_entry)

    cdef next(self):
        success = ctagsNext(self.file, &self.c_entry)
        if not success:
            raise RuntimeError()
        return self.create_tagEntry(&self.c_entry)

    def find_tags(self, name, int options):
        """ Find tags corresponding to name in the tag file.
            @name : a bytes array to search to.
            @options : A option flags for the search.
            @return : A iterator on all tags corresponding to the search.

            WARNING: Only one iterator can run on a tag file.
            If you use another iterator (by calling all_tags or find_tags),
            any previous iterator will be invalidated and raise a RuntimeError.
        """
        if isinstance(name, unicode):
            if self.encoding is None:
                raise ValueError("%r is a unicode string and you do not provide"
                                 "a encoding"%name)
            name = (<unicode>name).encode(self.encoding)
        try:
            first = self.find(name, options)
            self.current_id = first
            yield first
        except RuntimeError:
            raise StopIteration from None

        while True:
            if self.current_id is not first:
                raise RuntimeError("Only one search/list generator at a time")
            try:
                other = self.findNext()
            except RuntimeError:
                raise StopIteration from None
            else:
                yield other

    def all_tags(self):
        """ List all tags in the tag file.
            @return : A iterator on all tags in the file.

            WARNING: Only one iterator can run on a tag file.
            If you use another iterator (by calling all_tags or find_tags),
            any previous iterator will be invalidated and raise a RuntimeError.
        """
        try:
            first = self.first()
            self.current_id = first
            yield first
        except RuntimeError:
            raise StopIteration from None

        while True:
            if self.current_id is not first:
                raise RuntimeError("Only one search/list generator at a time")
            try:
                other = self.next()
            except RuntimeError:
                raise StopIteration from None
            else:
                yield other

