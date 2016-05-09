all:
	cython src/_readtags.pyx
	PYTHONPATH=src python setup.py test
