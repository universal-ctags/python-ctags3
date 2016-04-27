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


from ._readtags import TagEntry, CTags
__all__ = ['TagEntry', 'CTags']

# sortType
TAG_UNSORTED=0
TAG_SORTED=1
TAG_FOLDSORTED=2

# Options for tagsFind()
TAG_FULLMATCH=0x0
TAG_PARTIALMATCH=0x1
TAG_OBSERVECASE=0x0
TAG_IGNORECASE=0x2

# tagResult
FAILURE = 0
SUCCESS = 1 
