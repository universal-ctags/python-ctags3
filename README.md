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
from ctags import CTags, TagEntry
import sys

try:
    tagFile = CTags('tags')
except:
    sys.exit(1)

# Available file information keys:
#  opened -  was the tag file successfully opened?
#  error_number - errno value when 'opened' is false
#  format - format of tag file (1 = original, 2 = extended)
#  sort - how is the tag file sorted? 
#  author - name of author of generating program (may be empy string)
#  name - name of program (may be empy string)
#  url - URL of distribution (may be empy string)
#  version - program version (may be empty string)

print tagFile['name']
print tagFile['author']
print tagFile['format']

# Available sort type:
#  TAG_UNSORTED, TAG_SORTED, TAG_FOLDSORTED

# Note: use this only if you know how the tags file is sorted which is 
# specified when you generate the tag file
status = tagFile.setSortType(ctags.TAG_SORTED)
```

**Obtaining First Tag Entry**
```python
entry = TagEntry()
status = tagFile.first(entry)

if status:
    # Available TagEntry keys:
    #  name - name of tag
    #  file - path of source file containing definition of tag
    #  pattern - pattern for locating source line (None if no pattern)
    #  lineNumber - line number in source file of tag definition (may be zero if not known)
    #  kind - kind of tag (none if not known)
    #  fileScope - is tag of file-limited scope?
    
    # Note: other keys will be assumed as an extension key and will 
    # return None if no such key is found 

    print entry['name']
    print entry['kind']
```

**Finding a Tag Entry**
```python   
# Available options: 
# TAG_PARTIALMATCH - begin with
# TAG_FULLMATCH - full length matching
# TAG_IGNORECASE - disable binary search
# TAG_OBSERVECASE - case sensitive and allowed binary search to perform

if tagFile.find(entry, 'find', ctags.TAG_PARTIALMATCH | ctags.TAG_IGNORECASE):
    print 'found'
    print entry['lineNumber']
    print entry['pattern']
    print entry['kind']

# Find the next tag matching the name and options supplied to the 
# most recent call to tagFile.find().  (replace the entry if found)
status = tagFile.findNext(entry)

# Step to the next tag in the file (replace entry if found)
status = tagFile.next(entry)
```
