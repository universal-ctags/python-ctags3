all:
	cython src/_readtags.pyx
	python setup.py test
