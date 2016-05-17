[![Build Status](https://travis-ci.org/jonashaag/python-ctags3.svg?branch=py3)](https://travis-ci.org/jonashaag/python-ctags3)

*NOTE*: This a fork from the original python-ctags that adds support for Python 3. It is currently maintained by Jonas Haag.

Exuberant Ctags supports indexing of many modern programming languages.  Python is a powerful scriptable dynamic language.  Using Python to access Ctags index file is a natural fit in extending an application's capability to examine source code.

This project wrote a wrapper for read tags library.  I have been using the package in a couple of projects and it has been shown that it could easily handle hundreds of  source files.

## Requirements
 * C compiler (gcc/msvc)
 * Python version >= 2.6
 * [http://prdownloads.sourceforge.net/ctags/ctags-5.7.tar.gz Install Exuberant Ctags] (need it to generate tags file).

## Installation

From Python Package Index,
```bash
pip install python-ctags3
```

From https://github.com/hddmet/python-ctags/archive/master.zip,
```python
python ./setup.py build
python ./setup.py install
```

## Use Cases
### Generating Tags

In command line, run
```bash
ctags --fields=afmikKlnsStz readtags.c  readtags.h
```

**Opening Tags File**
```python
import ctags
from ctags import CTags
import sys

try:
    tagFile = CTags('tags')
except OSError as err:
    print(err)
    sys.exit(1)

# Available file information keys:
#  opened -  was the tag file successfully opened?
#  error_number - errno value when 'opened' is false
#  format - format of tag file (1 = original, 2 = extended)
#  sort - how is the tag file sorted?
#
# Other keys may be available:
#  author - name of author of generating program
#  name - name of program
#  url - URL of distribution
#  version - program version
# If one of them is not present a KeyError is raised.

try:
    print(tagFile['name'])
except KeyError:
    print("No 'name' in the tagfile")

try:
    print(tagFile['author'])
except KeyError:
    print("No 'author' in the tagfile")

print(tagFile['format'])

# Available sort type:
#  TAG_UNSORTED, TAG_SORTED, TAG_FOLDSORTED

# Note: use this only if you know how the tags file is sorted which is 
# specified when you generate the tag file
tagFile.setSortType(ctags.TAG_SORTED)
```

**Listing Tag Entries**
```python
# A generator of all tags in the file can be obtain with:
all_tags = tagFile.all_tags()

# The generator yield a dict for each entry.
# The following keys are always available for a entry:
#  name - name of tag
#  file - path of source file containing definition of tag
#  pattern - pattern for locating source line
#            (None if no pattern, this should no huppen with a correct
#             tag file)
#  fileScope - is tag of file-limited scope?
#
# The dict may contain other keys (extension keys).
# Other keys include :
#  lineNumber - line number in source file of tag definition
#  kind - kind of tag

for entry in all_tags:
    print(entry['name'])
    print(entry['file'])
    try:
        entry['lineNumber']
    except KeyError:
        print("Entry has no lineNumber")
    else:
        print("Entry has a lineNumber")
```

**Finding Tag Entries**
```python
# Available options: 
# TAG_PARTIALMATCH - begin with
# TAG_FULLMATCH - full length matching
# TAG_IGNORECASE - disable binary search
# TAG_OBSERVECASE - case sensitive and allowed binary search to perform

found_tags = tagFile.find_tags('find', ctags.TAG_PARTIALMATCH | ctags.TAG_IGNORECASE)
for entry in found_tags:
    print(entry['lineNumber'])
    print(entry['pattern'])
    print(entry['kind'])

