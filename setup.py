from setuptools import setup
from Cython.Build import cythonize

pyx_files = ["read.pyx", "server.pyx"]

setup(
    ext_modules=cythonize(pyx_files),
)
