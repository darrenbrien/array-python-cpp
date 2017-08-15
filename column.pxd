from libcpp.string cimport string
from libcpp.vector cimport vector

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
        void SayGoodbye()
