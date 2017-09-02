# Cython compile instructions
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import numpy
# Use python setup.py build_ext --inplace
# to compile

query_ext = Extension("query",
              sources=["query.pyx"],  
              include_dirs=["/drill/contrib/native/client/src/include/","/usr/local/drill_boost_1_60_0/"],
	      libraries=['querySubmitter'],
	      library_dirs=['/drill/contrib/native/client/build/'],
              language="c++",
              extra_objects=["/drill/contrib/native/client/build/libquerySubmitter.a",],
	      runtime_library_dirs=['/drill/contrib/native/client/build/'],
)

column_ext = Extension("column",
              sources=["column.pyx"],  
              include_dirs=["/drill/contrib/native/client/src/include/","/usr/local/drill_boost_1_60_0/"],
              language="c++",
              #extra_objects=["/drill/contrib/native/client/build/libquerySubmitter.a",]
)

setup(
  name = "drillpython",
  ext_modules = [column_ext, query_ext],
  include_dirs = [numpy.get_include()],
  cmdclass = {'build_ext': build_ext },
)
