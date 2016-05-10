"""Exuberant Ctags indexing python bindings

Exuberant Ctags supports indexing of many modern programming languages. Python
is a powerful scriptable dynamic language. Using Python to access Ctags index
file is a natural fit in extending an application's capability to examine source
code.

This project wrote a wrapper for readtags.c. I have been using the package in
a couple of projects and it has been shown that it could easily handle hundreds
source files.
"""
from setuptools import setup, Extension

doclines = __doc__.split("\n")

setup(
    name='python-ctags3',
    version='1.2.0' ,
    description=doclines[0],
    long_description="\n".join(doclines[2:]),
    author='Aaron H. K. Diep',
    author_email='ahkdiep@gmail.com',
    license = 'LGPL',
    url='https://github.com/jonashaag/python-ctags',
    packages = ['ctags'],
    ext_package='ctags',
    ext_modules=[Extension('_readtags', ['src/readtags.c', 'src/_readtags.c'],
                           include_dirs=['src/include'])
                ],
    package_dir = {'ctags' : 'src/ctags'},
    test_suite='tests',
    classifiers = [
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'Programming Language :: Python',
        'Programming Language :: C',
        'License :: OSI Approved :: GNU Library or Lesser General Public License (LGPL)',
        'Operating System :: MacOS :: MacOS X',
        'Operating System :: Microsoft :: Windows',
        'Operating System :: POSIX',
        'Topic :: Software Development :: Libraries :: Python Modules',
        "Programming Language :: Python :: 2.7",
        "Programming Language :: Python :: 3.4",
        "Programming Language :: Python :: 3.5",
    ],
)
