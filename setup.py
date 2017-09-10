# Cython compile instructions
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import numpy
# Use python setup.py build_ext --inplace
# to compile

query_ext = Extension("drillpy",
              sources=["query.pyx"],  
              include_dirs=["/drill/contrib/native/client/src/include/","/usr/local/drill_boost_1_60_0/"],
              libraries=["drillClient2"],
              library_dirs=["/drill/contrib/native/client/build/src/clientlib"],
              language="c++",
              extra_objects=["/drill/contrib/native/client/build/libquerySubmitter.a",],
)

column_ext = Extension("column",
              sources=["column.pyx"],  
              include_dirs=["/drill/contrib/native/client/src/include/","/usr/local/drill_boost_1_60_0/"],
              language="c++",
)

setup(
  name = "drillpython",
  ext_modules = [column_ext, query_ext],
  include_dirs = [numpy.get_include()],
  cmdclass = {'build_ext': build_ext },
)
