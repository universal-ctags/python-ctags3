all:
	cython src/_readtags.pyx
	python setup.py test

update-readtags:
	curl -Lv https://raw.githubusercontent.com/universal-ctags/ctags/master/libreadtags/readtags.c -o src/readtags.c
	curl -Lv https://raw.githubusercontent.com/universal-ctags/ctags/master/libreadtags/readtags.h -o src/include/readtags.h
	git commit src/readtags.c src/include/readtags.h -m "Update readtags from https://github.com/universal-ctags/ctags"
