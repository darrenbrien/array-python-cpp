# distutils: language = c++
# distutils: sources = Column.cpp

# Cython interface file for wrapping the object
#
#
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.map cimport map
import numpy as np
cimport numpy as np

# c++ interface to cython
cdef extern from "Column.cpp": 
    cdef cppclass ColumnBase:
        ColumnBase(string name, int type) except +
        int getType()
        string getName()

cdef extern from "Column.cpp": 
    cdef cppclass Column[T]:
        Column(string name, int type) except +
        int getType()
        string getName()
        vector[T] vec

# creating a cython wrapper class
cdef class PyColumnBase:
    cdef ColumnBase *thisptr      # hold a C++ instance which we're wrapping
    def __cinit__(self, string name, int t):
        self.thisptr = new ColumnBase(name, t)
    def __dealloc__(self):
        del self.thisptr
    def getType(self):
        return self.getType()
    def getName(self):
        return self.getType()
