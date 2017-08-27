# Cython compile instructions
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import numpy
# Use python setup.py build_ext --inplace
# to compile

extension = Extension("drillpython",
              sources=["column.pyx", "query.pyx"],  
              include_dirs=["/drill/contrib/native/client/src/include/","/usr/local/drill_boost_1_60_0/"],
              #libraries = ["/drill/contrib/native/client/build/libquerySubmitter.a",],
              language="c++",
              extra_objects=["/drill/contrib/native/client/build/libquerySubmitter.a",]
)

setup(
  name = "drillpython",
  ext_modules = [extension],
  include_dirs = [numpy.get_include()],
  cmdclass = {'build_ext': build_ext },
)
