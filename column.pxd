from libcpp.string cimport string
from libcpp.vector cimport vector
import numpy as np
cimport numpy as np


cdef extern from "Column.cpp":
    cdef cppclass ColumnBase:
        ColumnBase(string name, int t)
        int getType()
        string getName()

cdef extern from "Column.cpp":
    cdef cppclass Column[T]:
        Column(string name, int t)
        int getType()
        string getName()
        vector[T] vec
        void dispose()


cdef extern from "Column.cpp":
    cdef cppclass ByteStringColumn:
        ByteStringColumn(string name, int type) except +
        int getType()
        string getName()
        vector[char] vec
        vector[size_t] offsets
        vector[size_t] lengths
        void dispose()

