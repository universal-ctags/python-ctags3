"""
$Id$

Copyright (C) 2008 Aaron Diep <ahkdiep@gmail.com>

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

cdef extern from "readtags.h":
    ctypedef struct tagFile

    ctypedef enum tagSortType "sortType":
        TAG_UNSORTED
        TAG_SORTED
        TAG_FOLDSORTED

    ctypedef struct fileType "file":
        short format
        tagSortType sort

    ctypedef struct statusType "status":
            int opened
            int error_number

    ctypedef struct programType "program":
        const char *author
        const char *name
        const char *url
        const char *version

    ctypedef struct tagFileInfo:
        statusType status
        fileType file
        programType program


    ctypedef struct tagExtensionField:
        const char* key
        const char* value

    ctypedef struct addressType "address":
        const char* pattern
        unsigned long lineNumber

    ctypedef struct fieldsType:
        unsigned short count
        tagExtensionField *list

    ctypedef struct tagEntry:
        const char* name
        const char* file

        addressType address

        const char* kind
        short fileScope

        fieldsType fields

    ctypedef enum tagResult:
        TagFailure
        TagSuccess


    tagFile* ctagsOpen "tagsOpen" (const char *const filePath, tagFileInfo *const info)
    tagResult ctagsSetSortType "tagsSetSortType" (tagFile *const file, const tagSortType type)
    tagResult ctagsFirst "tagsFirst" (tagFile *const file, tagEntry *const entry)
#C++:    const char *ctagsField "tagsField" (const tagEntry *const entry, const char *const key) except +MemoryError
    const char *ctagsField "tagsField" (const tagEntry *const entry, const char *const key)
    tagResult ctagsFind "tagsFind" (tagFile *const file, tagEntry *const entry, const char *const name, const int options)
    tagResult ctagsNext "tagsNext" (tagFile *const file, tagEntry *const entry)
    tagResult ctagsFindNext "tagsFindNext" (tagFile *file, tagEntry *entry)
    tagResult ctagsClose "tagsClose" (tagFile *const file)
