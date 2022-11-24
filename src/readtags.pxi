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
        char *author
        char *name
        char *url
        char *version

    ctypedef struct tagFileInfo:
        statusType status
        fileType file
        programType program


    ctypedef struct tagExtensionField:
        char* key
        char* value

    ctypedef struct addressType "address":
        char* pattern
        unsigned long lineNumber

    ctypedef struct fieldsType:
        unsigned short count
        tagExtensionField *list

    ctypedef struct tagEntry:
        char* name
        char* file

        addressType address

        char* kind
        short fileScope

        fieldsType fields

    ctypedef enum tagResult:
        TagFailure
        TagSuccess


    tagFile* ctagsOpen "tagsOpen" (char *filePath, tagFileInfo *info)
    tagResult ctagsSetSortType "tagsSetSortType" (tagFile* file, tagSortType type)
    tagResult ctagsFirst "tagsFirst" (tagFile *file, tagEntry *entry)
#C++:    char *ctagsField "tagsField" (tagEntry *entry, char *key) except +MemoryError
    char *ctagsField "tagsField" (tagEntry *entry, char *key)
    tagResult ctagsFind "tagsFind" (tagFile *file, tagEntry *entry, char *name, int options)
    tagResult ctagsNext "tagsNext" (tagFile *file, tagEntry *entry)
    tagResult ctagsFindNext "tagsFindNext" (tagFile *file, tagEntry *entry)
    tagResult ctagsFirstPseudoTag "tagsFirstPseudoTag" (tagFile *file, tagEntry *entry)
    tagResult ctagsNextPseudoTag "tagsNextPseudoTag" (tagFile *file, tagEntry *entry)
    tagResult ctagsFindPseudoTag "tagsFindPseudoTag" (tagFile *file, tagEntry *entry, char *name, int options)
    tagResult ctagsClose "tagsClose" (tagFile *file)
