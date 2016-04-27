from __future__ import print_function
import ctags
from ctags import CTags, TagEntry
import sys

try:
    tagFile = CTags(b'tags')
except:
    sys.exit(1)
    
   
entry = TagEntry()
status = tagFile.setSortType(ctags.TAG_SORTED)
status = tagFile.first(entry)

print(tagFile['name'])
print(tagFile['author'])
print(tagFile['format'])
if status:
    print(entry['name'])
    print(entry['kind'])
    
if tagFile.find(entry, b'find', ctags.TAG_PARTIALMATCH | ctags.TAG_IGNORECASE):
    print('found')
    print(entry['lineNumber'])
    print(entry['pattern'])
    print(entry['kind'])

status = tagFile.findNext(entry)
if status:
    print(entry['lineNumber'])
    print(entry['pattern'])
    print(entry['kind'])
    
if tagFile.next(entry):
    print(entry['lineNumber'])
    print(entry['pattern'])
    print(entry['kind'])
    
